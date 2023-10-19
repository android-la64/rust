//===-- LoongArchExpandPseudoInsts.cpp - Expand pseudo instructions ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains a pass that expands pseudo instructions into target
// instructions to allow proper scheduling, if-conversion, and other late
// optimizations. This pass should be run after register allocation but before
// the post-regalloc scheduling pass.
//
// This is currently only used for expanding atomic pseudos after register
// allocation. We do this to avoid the fast register allocator introducing
// spills between ll and sc. These stores cause some LoongArch implementations to
// abort the atomic RMW sequence.
//
//===----------------------------------------------------------------------===//

#include "LoongArch.h"
#include "LoongArchInstrInfo.h"
#include "LoongArchSubtarget.h"
#include "MCTargetDesc/LoongArchMCTargetDesc.h"
#include "llvm/CodeGen/LivePhysRegs.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"

using namespace llvm;

#define DEBUG_TYPE "loongarch-pseudo"

namespace {
  class LoongArchExpandPseudo : public MachineFunctionPass {
  public:
    static char ID;
    LoongArchExpandPseudo() : MachineFunctionPass(ID) {}

    const LoongArchInstrInfo *TII;
    const LoongArchSubtarget *STI;

    bool runOnMachineFunction(MachineFunction &Fn) override;

    MachineFunctionProperties getRequiredProperties() const override {
      return MachineFunctionProperties().set(
          MachineFunctionProperties::Property::NoVRegs);
    }

    StringRef getPassName() const override {
      return "LoongArch pseudo instruction expansion pass";
    }

  private:
    bool expandAtomicCmpSwap(MachineBasicBlock &MBB,
                             MachineBasicBlock::iterator MBBI,
                             MachineBasicBlock::iterator &NextMBBI);
    bool expandAtomicCmpSwapSubword(MachineBasicBlock &MBB,
                                    MachineBasicBlock::iterator MBBI,
                                    MachineBasicBlock::iterator &NextMBBI);

    bool expandAtomicBinOp(MachineBasicBlock &BB,
                           MachineBasicBlock::iterator I,
                           MachineBasicBlock::iterator &NMBBI, unsigned Size);
    bool expandXINSERT_BOp(MachineBasicBlock &BB, MachineBasicBlock::iterator I,
                           MachineBasicBlock::iterator &NMBBI);
    bool expandINSERT_HOp(MachineBasicBlock &BB, MachineBasicBlock::iterator I,
                          MachineBasicBlock::iterator &NMBBI);
    bool expandXINSERT_FWOp(MachineBasicBlock &BB,
                            MachineBasicBlock::iterator I,
                            MachineBasicBlock::iterator &NMBBI);
    bool expandAtomicBinOpSubword(MachineBasicBlock &BB,
                                  MachineBasicBlock::iterator I,
                                  MachineBasicBlock::iterator &NMBBI);

    bool expandPseudoCall(MachineBasicBlock &BB,
                          MachineBasicBlock::iterator I,
                          MachineBasicBlock::iterator &NMBBI);
    bool expandPseudoTailCall(MachineBasicBlock &BB,
                              MachineBasicBlock::iterator I);

    bool expandPseudoTEQ(MachineBasicBlock &BB,
                         MachineBasicBlock::iterator I,
                         MachineBasicBlock::iterator &NMBBI);

    bool expandLoadAddr(MachineBasicBlock &BB,
                        MachineBasicBlock::iterator I,
                        MachineBasicBlock::iterator &NMBBI);

    bool expandMI(MachineBasicBlock &MBB, MachineBasicBlock::iterator MBBI,
                  MachineBasicBlock::iterator &NMBB);
    bool expandMBB(MachineBasicBlock &MBB);
   };
  char LoongArchExpandPseudo::ID = 0;
}

static bool hasDbar(MachineBasicBlock *MBB) {

  for (MachineBasicBlock::iterator MBBb = MBB->begin(), MBBe = MBB->end();
       MBBb != MBBe; ++MBBb) {
    if (MBBb->getOpcode() == LoongArch::DBAR)
      return true;
    if (MBBb->mayLoad() || MBBb->mayStore())
      break;
  }
  return false;
}

bool LoongArchExpandPseudo::expandAtomicCmpSwapSubword(
    MachineBasicBlock &BB, MachineBasicBlock::iterator I,
    MachineBasicBlock::iterator &NMBBI) {

  MachineFunction *MF = BB.getParent();

  DebugLoc DL = I->getDebugLoc();
  unsigned LL, SC;
  unsigned ZERO = LoongArch::ZERO;
  unsigned BNE = LoongArch::BNE32;
  unsigned BEQ = LoongArch::BEQ32;
  unsigned SEOp =
      I->getOpcode() == LoongArch::ATOMIC_CMP_SWAP_I8_POSTRA ? LoongArch::EXT_W_B32 : LoongArch::EXT_W_H32;

  LL = LoongArch::LL_W;
  SC = LoongArch::SC_W;

  unsigned Dest = I->getOperand(0).getReg();
  unsigned Ptr = I->getOperand(1).getReg();
  unsigned Mask = I->getOperand(2).getReg();
  unsigned ShiftCmpVal = I->getOperand(3).getReg();
  unsigned Mask2 = I->getOperand(4).getReg();
  unsigned ShiftNewVal = I->getOperand(5).getReg();
  unsigned ShiftAmnt = I->getOperand(6).getReg();
  unsigned Scratch = I->getOperand(7).getReg();
  unsigned Scratch2 = I->getOperand(8).getReg();

  // insert new blocks after the current block
  const BasicBlock *LLVM_BB = BB.getBasicBlock();
  MachineBasicBlock *loop1MBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *loop2MBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *sinkMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *exitMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineFunction::iterator It = ++BB.getIterator();
  MF->insert(It, loop1MBB);
  MF->insert(It, loop2MBB);
  MF->insert(It, sinkMBB);
  MF->insert(It, exitMBB);

  // Transfer the remainder of BB and its successor edges to exitMBB.
  exitMBB->splice(exitMBB->begin(), &BB,
                  std::next(MachineBasicBlock::iterator(I)), BB.end());
  exitMBB->transferSuccessorsAndUpdatePHIs(&BB);

  //  thisMBB:
  //    ...
  //    fallthrough --> loop1MBB
  BB.addSuccessor(loop1MBB, BranchProbability::getOne());
  loop1MBB->addSuccessor(sinkMBB);
  loop1MBB->addSuccessor(loop2MBB);
  loop1MBB->normalizeSuccProbs();
  loop2MBB->addSuccessor(loop1MBB);
  loop2MBB->addSuccessor(sinkMBB);
  loop2MBB->normalizeSuccProbs();
  sinkMBB->addSuccessor(exitMBB, BranchProbability::getOne());

  // loop1MBB:
  //   ll dest, 0(ptr)
  //   and Mask', dest, Mask
  //   bne Mask', ShiftCmpVal, exitMBB
  BuildMI(loop1MBB, DL, TII->get(LL), Scratch).addReg(Ptr).addImm(0);
  BuildMI(loop1MBB, DL, TII->get(LoongArch::AND32), Scratch2)
      .addReg(Scratch)
      .addReg(Mask);
  BuildMI(loop1MBB, DL, TII->get(BNE))
    .addReg(Scratch2).addReg(ShiftCmpVal).addMBB(sinkMBB);

  // loop2MBB:
  //   and dest, dest, mask2
  //   or dest, dest, ShiftNewVal
  //   sc dest, dest, 0(ptr)
  //   beq dest, $0, loop1MBB
  BuildMI(loop2MBB, DL, TII->get(LoongArch::AND32), Scratch)
      .addReg(Scratch, RegState::Kill)
      .addReg(Mask2);
  BuildMI(loop2MBB, DL, TII->get(LoongArch::OR32), Scratch)
      .addReg(Scratch, RegState::Kill)
      .addReg(ShiftNewVal);
  BuildMI(loop2MBB, DL, TII->get(SC), Scratch)
      .addReg(Scratch, RegState::Kill)
      .addReg(Ptr)
      .addImm(0);
  BuildMI(loop2MBB, DL, TII->get(BEQ))
      .addReg(Scratch, RegState::Kill)
      .addReg(ZERO)
      .addMBB(loop1MBB);

  //  sinkMBB:
  //    srl     srlres, Mask', shiftamt
  //    sign_extend dest,srlres
  BuildMI(sinkMBB, DL, TII->get(LoongArch::SRL_W), Dest)
      .addReg(Scratch2)
      .addReg(ShiftAmnt);

  BuildMI(sinkMBB, DL, TII->get(SEOp), Dest).addReg(Dest);

  if (!hasDbar(sinkMBB)) {
    MachineBasicBlock::iterator Pos = sinkMBB->begin();
    BuildMI(*sinkMBB, Pos, DL, TII->get(LoongArch::DBAR)).addImm(DBAR_HINT);
  }

  LivePhysRegs LiveRegs;
  computeAndAddLiveIns(LiveRegs, *loop1MBB);
  computeAndAddLiveIns(LiveRegs, *loop2MBB);
  computeAndAddLiveIns(LiveRegs, *sinkMBB);
  computeAndAddLiveIns(LiveRegs, *exitMBB);

  NMBBI = BB.end();
  I->eraseFromParent();
  return true;
}

bool LoongArchExpandPseudo::expandAtomicCmpSwap(MachineBasicBlock &BB,
                                           MachineBasicBlock::iterator I,
                                           MachineBasicBlock::iterator &NMBBI) {

  const unsigned Size =
      I->getOpcode() == LoongArch::ATOMIC_CMP_SWAP_I32_POSTRA ? 4 : 8;
  MachineFunction *MF = BB.getParent();

  DebugLoc DL = I->getDebugLoc();

  unsigned LL, SC, ZERO, BNE, BEQ, MOVE;

  if (Size == 4) {
    LL = LoongArch::LL_W;
    SC = LoongArch::SC_W;
    BNE = LoongArch::BNE32;
    BEQ = LoongArch::BEQ32;

    ZERO = LoongArch::ZERO;
    MOVE = LoongArch::OR32;
  } else {
    LL = LoongArch::LL_D;
    SC = LoongArch::SC_D;
    ZERO = LoongArch::ZERO_64;
    BNE = LoongArch::BNE;
    BEQ = LoongArch::BEQ;
    MOVE = LoongArch::OR;
  }

  unsigned Dest = I->getOperand(0).getReg();
  unsigned Ptr = I->getOperand(1).getReg();
  unsigned OldVal = I->getOperand(2).getReg();
  unsigned NewVal = I->getOperand(3).getReg();
  unsigned Scratch = I->getOperand(4).getReg();

  // insert new blocks after the current block
  const BasicBlock *LLVM_BB = BB.getBasicBlock();
  MachineBasicBlock *loop1MBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *loop2MBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *exitMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineFunction::iterator It = ++BB.getIterator();
  MF->insert(It, loop1MBB);
  MF->insert(It, loop2MBB);
  MF->insert(It, exitMBB);

  // Transfer the remainder of BB and its successor edges to exitMBB.
  exitMBB->splice(exitMBB->begin(), &BB,
                  std::next(MachineBasicBlock::iterator(I)), BB.end());
  exitMBB->transferSuccessorsAndUpdatePHIs(&BB);

  //  thisMBB:
  //    ...
  //    fallthrough --> loop1MBB
  BB.addSuccessor(loop1MBB, BranchProbability::getOne());
  loop1MBB->addSuccessor(exitMBB);
  loop1MBB->addSuccessor(loop2MBB);
  loop1MBB->normalizeSuccProbs();
  loop2MBB->addSuccessor(loop1MBB);
  loop2MBB->addSuccessor(exitMBB);
  loop2MBB->normalizeSuccProbs();

  // loop1MBB:
  //   ll dest, 0(ptr)
  //   bne dest, oldval, exitMBB
  BuildMI(loop1MBB, DL, TII->get(LL), Dest).addReg(Ptr).addImm(0);
  BuildMI(loop1MBB, DL, TII->get(BNE))
    .addReg(Dest, RegState::Kill).addReg(OldVal).addMBB(exitMBB);

  // loop2MBB:
  //   move scratch, NewVal
  //   sc Scratch, Scratch, 0(ptr)
  //   beq Scratch, $0, loop1MBB
  BuildMI(loop2MBB, DL, TII->get(MOVE), Scratch).addReg(NewVal).addReg(ZERO);
  BuildMI(loop2MBB, DL, TII->get(SC), Scratch)
    .addReg(Scratch).addReg(Ptr).addImm(0);
  BuildMI(loop2MBB, DL, TII->get(BEQ))
    .addReg(Scratch, RegState::Kill).addReg(ZERO).addMBB(loop1MBB);

  if (!hasDbar(exitMBB)) {
    MachineBasicBlock::iterator Pos = exitMBB->begin();
    BuildMI(*exitMBB, Pos, DL, TII->get(LoongArch::DBAR)).addImm(DBAR_HINT);
  }

  LivePhysRegs LiveRegs;
  computeAndAddLiveIns(LiveRegs, *loop1MBB);
  computeAndAddLiveIns(LiveRegs, *loop2MBB);
  computeAndAddLiveIns(LiveRegs, *exitMBB);

  NMBBI = BB.end();
  I->eraseFromParent();
  return true;
}

bool LoongArchExpandPseudo::expandXINSERT_FWOp(
    MachineBasicBlock &BB, MachineBasicBlock::iterator I,
    MachineBasicBlock::iterator &NMBBI) {

  MachineFunction *MF = BB.getParent();

  DebugLoc DL = I->getDebugLoc();

  unsigned isGP64 = 0;
  switch (I->getOpcode()) {
  case LoongArch::XINSERT_FW_VIDX64_PSEUDO_POSTRA:
    isGP64 = 1;
    break;
  case LoongArch::XINSERT_FW_VIDX_PSEUDO_POSTRA:
    break;
  default:
    llvm_unreachable("Unknown subword vector pseudo for expansion!");
  }

  unsigned Dest = I->getOperand(0).getReg();
  unsigned SrcVecReg = I->getOperand(1).getReg();
  unsigned LaneReg = I->getOperand(2).getReg();
  unsigned SrcValReg = I->getOperand(3).getReg();

  unsigned Dsttmp = I->getOperand(4).getReg();
  unsigned RI = I->getOperand(5).getReg();
  unsigned RJ = I->getOperand(6).getReg();
  Dsttmp = SrcVecReg;

  const BasicBlock *LLVM_BB = BB.getBasicBlock();
  MachineBasicBlock *blocks[11];
  MachineFunction::iterator It = ++BB.getIterator();
  for (int i = 0; i < 11; i++) {
    blocks[i] = MF->CreateMachineBasicBlock(LLVM_BB);
    MF->insert(It, blocks[i]);
  }

  MachineBasicBlock *mainMBB = blocks[0];
  MachineBasicBlock *FirstMBB = blocks[1];
  MachineBasicBlock *sinkMBB = blocks[9];
  MachineBasicBlock *exitMBB = blocks[10];

  exitMBB->splice(exitMBB->begin(), &BB, std::next(I), BB.end());
  exitMBB->transferSuccessorsAndUpdatePHIs(&BB);

  BB.addSuccessor(mainMBB, BranchProbability::getOne());
  for (int i = 1; i < 9; i++) {
    mainMBB->addSuccessor(blocks[i]);
    blocks[i]->addSuccessor(sinkMBB);
  }

  unsigned ADDI, BLT, ZERO;
  ADDI = isGP64 ? LoongArch::ADDI_D : LoongArch::ADDI_W;
  BLT = isGP64 ? LoongArch::BLT : LoongArch::BLT32;
  ZERO = isGP64 ? LoongArch::ZERO_64 : LoongArch::ZERO;

  for (int i = 1; i < 8; i++) {
    BuildMI(mainMBB, DL, TII->get(ADDI), RI).addReg(ZERO).addImm(i);
    BuildMI(mainMBB, DL, TII->get(BLT))
        .addReg(LaneReg)
        .addReg(RI)
        .addMBB(blocks[i + 1]);
  }

  BuildMI(mainMBB, DL, TII->get(LoongArch::B32)).addMBB(FirstMBB);

  BuildMI(FirstMBB, DL, TII->get(LoongArch::XVINSGR2VR_W), Dsttmp)
      .addReg(SrcVecReg)
      .addReg(RJ)
      .addImm(7);
  BuildMI(FirstMBB, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  for (int i = 0; i < 7; i++) {
    BuildMI(blocks[i + 2], DL, TII->get(LoongArch::XVINSGR2VR_W), Dsttmp)
        .addReg(SrcVecReg)
        .addReg(RJ)
        .addImm(i);
    BuildMI(blocks[i + 2], DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);
  }

  sinkMBB->addSuccessor(exitMBB, BranchProbability::getOne());
  BuildMI(sinkMBB, DL, TII->get(LoongArch::XVORI_B), Dest)
      .addReg(Dsttmp)
      .addImm(0);

  LivePhysRegs LiveRegs;
  for (int i = 0; i < 11; i++) {
    computeAndAddLiveIns(LiveRegs, *blocks[i]);
  }

  NMBBI = BB.end();
  I->eraseFromParent();

  return true;
}

bool LoongArchExpandPseudo::expandINSERT_HOp(
    MachineBasicBlock &BB, MachineBasicBlock::iterator I,
    MachineBasicBlock::iterator &NMBBI) {

  MachineFunction *MF = BB.getParent();

  DebugLoc DL = I->getDebugLoc();

  unsigned isGP64 = 0;
  switch (I->getOpcode()) {
  case LoongArch::INSERT_H_VIDX64_PSEUDO_POSTRA:
    isGP64 = 1;
    break;
  default:
    llvm_unreachable("Unknown subword vector pseudo for expansion!");
  }

  unsigned Dest = I->getOperand(0).getReg();
  unsigned SrcVecReg = I->getOperand(1).getReg();
  unsigned LaneReg = I->getOperand(2).getReg();
  unsigned SrcValReg = I->getOperand(3).getReg();

  unsigned Dsttmp = I->getOperand(4).getReg();
  unsigned RI = I->getOperand(5).getReg();
  Dsttmp = SrcVecReg;

  const BasicBlock *LLVM_BB = BB.getBasicBlock();
  MachineBasicBlock *blocks[11];
  MachineFunction::iterator It = ++BB.getIterator();
  for (int i = 0; i < 11; i++) {
    blocks[i] = MF->CreateMachineBasicBlock(LLVM_BB);
    MF->insert(It, blocks[i]);
  }

  MachineBasicBlock *mainMBB = blocks[0];
  MachineBasicBlock *FirstMBB = blocks[1];
  MachineBasicBlock *sinkMBB = blocks[9];
  MachineBasicBlock *exitMBB = blocks[10];

  exitMBB->splice(exitMBB->begin(), &BB, std::next(I), BB.end());
  exitMBB->transferSuccessorsAndUpdatePHIs(&BB);

  BB.addSuccessor(mainMBB, BranchProbability::getOne());
  for (int i = 1; i < 9; i++) {
    mainMBB->addSuccessor(blocks[i]);
    blocks[i]->addSuccessor(sinkMBB);
  }

  unsigned ADDI, BLT, ZERO;
  ADDI = isGP64 ? LoongArch::ADDI_D : LoongArch::ADDI_W;
  BLT = isGP64 ? LoongArch::BLT : LoongArch::BLT32;
  ZERO = isGP64 ? LoongArch::ZERO_64 : LoongArch::ZERO;

  for (int i = 1; i < 8; i++) {
    BuildMI(mainMBB, DL, TII->get(ADDI), RI).addReg(ZERO).addImm(i);
    BuildMI(mainMBB, DL, TII->get(BLT))
        .addReg(LaneReg)
        .addReg(RI)
        .addMBB(blocks[i + 1]);
  }

  BuildMI(mainMBB, DL, TII->get(LoongArch::B32)).addMBB(FirstMBB);

  BuildMI(FirstMBB, DL, TII->get(LoongArch::VINSGR2VR_H), Dsttmp)
      .addReg(SrcVecReg)
      .addReg(SrcValReg)
      .addImm(7);
  BuildMI(FirstMBB, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  for (int i = 0; i < 7; i++) {
    BuildMI(blocks[i + 2], DL, TII->get(LoongArch::VINSGR2VR_H), Dsttmp)
        .addReg(SrcVecReg)
        .addReg(SrcValReg)
        .addImm(i);
    BuildMI(blocks[i + 2], DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);
  }

  sinkMBB->addSuccessor(exitMBB, BranchProbability::getOne());
  BuildMI(sinkMBB, DL, TII->get(LoongArch::VORI_B), Dest)
      .addReg(Dsttmp)
      .addImm(0);

  LivePhysRegs LiveRegs;
  for (int i = 0; i < 11; i++) {
    computeAndAddLiveIns(LiveRegs, *blocks[i]);
  }

  NMBBI = BB.end();
  I->eraseFromParent();

  return true;
}

bool LoongArchExpandPseudo::expandXINSERT_BOp(
    MachineBasicBlock &BB, MachineBasicBlock::iterator I,
    MachineBasicBlock::iterator &NMBBI) {

  MachineFunction *MF = BB.getParent();

  DebugLoc DL = I->getDebugLoc();

  unsigned isGP64 = 0;
  switch (I->getOpcode()) {
  case LoongArch::XINSERT_B_VIDX64_PSEUDO_POSTRA:
    isGP64 = 1;
    break;
  case LoongArch::XINSERT_B_VIDX_PSEUDO_POSTRA:
    break;
  default:
    llvm_unreachable("Unknown subword vector pseudo for expansion!");
  }

  unsigned Dest = I->getOperand(0).getReg();
  unsigned SrcVecReg = I->getOperand(1).getReg();
  unsigned LaneReg = I->getOperand(2).getReg();
  unsigned SrcValReg = I->getOperand(3).getReg();

  unsigned R4r = I->getOperand(5).getReg();
  unsigned Rib = I->getOperand(6).getReg();
  unsigned Ris = I->getOperand(7).getReg();
  unsigned R7b1 = I->getOperand(8).getReg();
  unsigned R7b2 = I->getOperand(9).getReg();
  unsigned R7b3 = I->getOperand(10).getReg();
  unsigned R7r80_3 = I->getOperand(11).getReg();
  unsigned R7r80l_3 = I->getOperand(12).getReg();
  unsigned R7r81_3 = I->getOperand(13).getReg();
  unsigned R7r81l_3 = I->getOperand(14).getReg();
  unsigned R7r82_3 = I->getOperand(15).getReg();
  unsigned R7r82l_3 = I->getOperand(16).getReg();
  unsigned RI = I->getOperand(17).getReg();
  unsigned tmp_Dst73 = I->getOperand(18).getReg();
  unsigned Rimm = I->getOperand(19).getReg();
  unsigned R70 = I->getOperand(20).getReg();
  tmp_Dst73 = SrcVecReg;

  const BasicBlock *LLVM_BB = BB.getBasicBlock();
  MachineBasicBlock *mainMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SevenMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SevenMBB0 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SevenMBB1 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SevenMBB2 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SevenMBB3 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *ZeroMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *ZeroMBB0 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *ZeroMBB1 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *ZeroMBB2 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *ZeroMBB3 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *OneMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *OneMBB0 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *OneMBB1 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *OneMBB2 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *OneMBB3 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *TwoMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *TwoMBB0 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *TwoMBB1 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *TwoMBB2 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *TwoMBB3 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *ThreeMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *ThreeMBB0 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *ThreeMBB1 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *ThreeMBB2 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *ThreeMBB3 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *FourMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *FourMBB0 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *FourMBB1 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *FourMBB2 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *FourMBB3 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *FiveMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *FiveMBB0 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *FiveMBB1 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *FiveMBB2 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *FiveMBB3 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SixMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SixMBB0 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SixMBB1 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SixMBB2 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SixMBB3 = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *sinkMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *exitMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineFunction::iterator It = ++BB.getIterator();
  MF->insert(It, mainMBB);
  MF->insert(It, SevenMBB);
  MF->insert(It, SevenMBB3);
  MF->insert(It, SevenMBB0);
  MF->insert(It, SevenMBB1);
  MF->insert(It, SevenMBB2);
  MF->insert(It, ZeroMBB);
  MF->insert(It, ZeroMBB3);
  MF->insert(It, ZeroMBB0);
  MF->insert(It, ZeroMBB1);
  MF->insert(It, ZeroMBB2);
  MF->insert(It, OneMBB);
  MF->insert(It, OneMBB3);
  MF->insert(It, OneMBB0);
  MF->insert(It, OneMBB1);
  MF->insert(It, OneMBB2);
  MF->insert(It, TwoMBB);
  MF->insert(It, TwoMBB3);
  MF->insert(It, TwoMBB0);
  MF->insert(It, TwoMBB1);
  MF->insert(It, TwoMBB2);
  MF->insert(It, ThreeMBB);
  MF->insert(It, ThreeMBB3);
  MF->insert(It, ThreeMBB0);
  MF->insert(It, ThreeMBB1);
  MF->insert(It, ThreeMBB2);
  MF->insert(It, FourMBB);
  MF->insert(It, FourMBB3);
  MF->insert(It, FourMBB0);
  MF->insert(It, FourMBB1);
  MF->insert(It, FourMBB2);
  MF->insert(It, FiveMBB);
  MF->insert(It, FiveMBB3);
  MF->insert(It, FiveMBB0);
  MF->insert(It, FiveMBB1);
  MF->insert(It, FiveMBB2);
  MF->insert(It, SixMBB);
  MF->insert(It, SixMBB3);
  MF->insert(It, SixMBB0);
  MF->insert(It, SixMBB1);
  MF->insert(It, SixMBB2);
  MF->insert(It, sinkMBB);
  MF->insert(It, exitMBB);

  exitMBB->splice(exitMBB->begin(), &BB, std::next(I), BB.end());
  exitMBB->transferSuccessorsAndUpdatePHIs(&BB);

  BB.addSuccessor(mainMBB, BranchProbability::getOne());
  mainMBB->addSuccessor(SevenMBB);
  mainMBB->addSuccessor(ZeroMBB);
  mainMBB->addSuccessor(OneMBB);
  mainMBB->addSuccessor(TwoMBB);
  mainMBB->addSuccessor(ThreeMBB);
  mainMBB->addSuccessor(FourMBB);
  mainMBB->addSuccessor(FiveMBB);
  mainMBB->addSuccessor(SixMBB);
  SevenMBB->addSuccessor(SevenMBB0);
  SevenMBB->addSuccessor(SevenMBB1);
  SevenMBB->addSuccessor(SevenMBB2);
  SevenMBB->addSuccessor(SevenMBB3);
  SevenMBB0->addSuccessor(sinkMBB);
  SevenMBB1->addSuccessor(sinkMBB);
  SevenMBB2->addSuccessor(sinkMBB);
  SevenMBB3->addSuccessor(sinkMBB);
  ZeroMBB->addSuccessor(ZeroMBB0);
  ZeroMBB->addSuccessor(ZeroMBB1);
  ZeroMBB->addSuccessor(ZeroMBB2);
  ZeroMBB->addSuccessor(ZeroMBB3);
  ZeroMBB0->addSuccessor(sinkMBB);
  ZeroMBB1->addSuccessor(sinkMBB);
  ZeroMBB2->addSuccessor(sinkMBB);
  ZeroMBB3->addSuccessor(sinkMBB);
  OneMBB->addSuccessor(OneMBB0);
  OneMBB->addSuccessor(OneMBB1);
  OneMBB->addSuccessor(OneMBB2);
  OneMBB->addSuccessor(OneMBB3);
  OneMBB0->addSuccessor(sinkMBB);
  OneMBB1->addSuccessor(sinkMBB);
  OneMBB2->addSuccessor(sinkMBB);
  OneMBB3->addSuccessor(sinkMBB);
  TwoMBB->addSuccessor(TwoMBB0);
  TwoMBB->addSuccessor(TwoMBB1);
  TwoMBB->addSuccessor(TwoMBB2);
  TwoMBB->addSuccessor(TwoMBB3);
  TwoMBB0->addSuccessor(sinkMBB);
  TwoMBB1->addSuccessor(sinkMBB);
  TwoMBB2->addSuccessor(sinkMBB);
  TwoMBB3->addSuccessor(sinkMBB);
  ThreeMBB->addSuccessor(ThreeMBB0);
  ThreeMBB->addSuccessor(ThreeMBB1);
  ThreeMBB->addSuccessor(ThreeMBB2);
  ThreeMBB->addSuccessor(ThreeMBB3);
  ThreeMBB0->addSuccessor(sinkMBB);
  ThreeMBB1->addSuccessor(sinkMBB);
  ThreeMBB2->addSuccessor(sinkMBB);
  ThreeMBB3->addSuccessor(sinkMBB);
  FourMBB->addSuccessor(FourMBB0);
  FourMBB->addSuccessor(FourMBB1);
  FourMBB->addSuccessor(FourMBB2);
  FourMBB->addSuccessor(FourMBB3);
  FourMBB0->addSuccessor(sinkMBB);
  FourMBB1->addSuccessor(sinkMBB);
  FourMBB2->addSuccessor(sinkMBB);
  FourMBB3->addSuccessor(sinkMBB);
  FiveMBB->addSuccessor(FiveMBB0);
  FiveMBB->addSuccessor(FiveMBB1);
  FiveMBB->addSuccessor(FiveMBB2);
  FiveMBB->addSuccessor(FiveMBB3);
  FiveMBB0->addSuccessor(sinkMBB);
  FiveMBB1->addSuccessor(sinkMBB);
  FiveMBB2->addSuccessor(sinkMBB);
  FiveMBB3->addSuccessor(sinkMBB);
  SixMBB->addSuccessor(SixMBB0);
  SixMBB->addSuccessor(SixMBB1);
  SixMBB->addSuccessor(SixMBB2);
  SixMBB->addSuccessor(SixMBB3);
  SixMBB0->addSuccessor(sinkMBB);
  SixMBB1->addSuccessor(sinkMBB);
  SixMBB2->addSuccessor(sinkMBB);
  SixMBB3->addSuccessor(sinkMBB);

  unsigned SRLI, ADDI, OR, MOD, BLT, ZERO;
  SRLI = isGP64 ? LoongArch::SRLI_D : LoongArch::SRLI_W;
  ADDI = isGP64 ? LoongArch::ADDI_D : LoongArch::ADDI_W;
  OR = isGP64 ? LoongArch::OR : LoongArch::OR32;
  MOD = isGP64 ? LoongArch::MOD_DU : LoongArch::MOD_WU;
  BLT = isGP64 ? LoongArch::BLT : LoongArch::BLT32;
  ZERO = isGP64 ? LoongArch::ZERO_64 : LoongArch::ZERO;

  BuildMI(mainMBB, DL, TII->get(SRLI), Rimm).addReg(LaneReg).addImm(2);
  BuildMI(mainMBB, DL, TII->get(ADDI), R4r).addReg(ZERO).addImm(4);
  BuildMI(mainMBB, DL, TII->get(OR), Rib).addReg(Rimm).addReg(ZERO);
  BuildMI(mainMBB, DL, TII->get(MOD), Ris).addReg(Rib).addReg(R4r);
  BuildMI(mainMBB, DL, TII->get(ADDI), RI).addReg(ZERO).addImm(1);
  BuildMI(mainMBB, DL, TII->get(BLT)).addReg(Rib).addReg(RI).addMBB(ZeroMBB);
  BuildMI(mainMBB, DL, TII->get(ADDI), RI).addReg(ZERO).addImm(2);
  BuildMI(mainMBB, DL, TII->get(BLT)).addReg(Rib).addReg(RI).addMBB(OneMBB);
  BuildMI(mainMBB, DL, TII->get(ADDI), RI).addReg(ZERO).addImm(3);
  BuildMI(mainMBB, DL, TII->get(BLT)).addReg(Rib).addReg(RI).addMBB(TwoMBB);
  BuildMI(mainMBB, DL, TII->get(ADDI), RI).addReg(ZERO).addImm(4);
  BuildMI(mainMBB, DL, TII->get(BLT)).addReg(Rib).addReg(RI).addMBB(ThreeMBB);
  BuildMI(mainMBB, DL, TII->get(ADDI), RI).addReg(ZERO).addImm(5);
  BuildMI(mainMBB, DL, TII->get(BLT)).addReg(Rib).addReg(RI).addMBB(FourMBB);
  BuildMI(mainMBB, DL, TII->get(ADDI), RI).addReg(ZERO).addImm(6);
  BuildMI(mainMBB, DL, TII->get(BLT)).addReg(Rib).addReg(RI).addMBB(FiveMBB);
  BuildMI(mainMBB, DL, TII->get(ADDI), RI).addReg(ZERO).addImm(7);
  BuildMI(mainMBB, DL, TII->get(BLT)).addReg(Rib).addReg(RI).addMBB(SixMBB);
  BuildMI(mainMBB, DL, TII->get(LoongArch::B32)).addMBB(SevenMBB);

  BuildMI(SevenMBB, DL, TII->get(LoongArch::XVPICKVE2GR_W), R70)
      .addReg(SrcVecReg)
      .addImm(7);
  BuildMI(SevenMBB, DL, TII->get(ADDI), R7b1).addReg(ZERO).addImm(1);
  BuildMI(SevenMBB, DL, TII->get(BLT))
      .addReg(Ris)
      .addReg(R7b1)
      .addMBB(SevenMBB0);
  BuildMI(SevenMBB, DL, TII->get(ADDI), R7b2).addReg(ZERO).addImm(2);
  BuildMI(SevenMBB, DL, TII->get(BLT))
      .addReg(Ris)
      .addReg(R7b2)
      .addMBB(SevenMBB1);
  BuildMI(SevenMBB, DL, TII->get(ADDI), R7b3).addReg(ZERO).addImm(3);
  BuildMI(SevenMBB, DL, TII->get(BLT))
      .addReg(Ris)
      .addReg(R7b3)
      .addMBB(SevenMBB2);
  BuildMI(SevenMBB, DL, TII->get(LoongArch::B32)).addMBB(SevenMBB3);

  BuildMI(SevenMBB3, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(SevenMBB3, DL, TII->get(LoongArch::LU12I_W), R7r81l_3)
      .addImm(0x00fff);
  BuildMI(SevenMBB3, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(SevenMBB3, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(SevenMBB3, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80_3);
  BuildMI(SevenMBB3, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(7);
  BuildMI(SevenMBB3, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(SevenMBB0, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(SevenMBB0, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(8);
  BuildMI(SevenMBB0, DL, TII->get(LoongArch::LU12I_W), R7r81l_3)
      .addImm(0xff00f);
  BuildMI(SevenMBB0, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(SevenMBB0, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(SevenMBB0, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(SevenMBB0, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(7);
  BuildMI(SevenMBB0, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(SevenMBB1, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(SevenMBB1, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(16);
  BuildMI(SevenMBB1, DL, TII->get(LoongArch::LU12I_W), R7r81l_3)
      .addImm(0xffff0);
  BuildMI(SevenMBB1, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0x0ff);
  BuildMI(SevenMBB1, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(SevenMBB1, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(SevenMBB1, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(7);
  BuildMI(SevenMBB1, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(SevenMBB2, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(SevenMBB2, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(24);
  BuildMI(SevenMBB2, DL, TII->get(LoongArch::LU12I_W), R7r81l_3)
      .addImm(0xfffff);
  BuildMI(SevenMBB2, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xf00);
  BuildMI(SevenMBB2, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(SevenMBB2, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(SevenMBB2, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(7);
  BuildMI(SevenMBB2, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(ZeroMBB, DL, TII->get(LoongArch::XVPICKVE2GR_W), R70)
      .addReg(SrcVecReg)
      .addImm(0);
  BuildMI(ZeroMBB, DL, TII->get(ADDI), R7b1).addReg(ZERO).addImm(1);
  BuildMI(ZeroMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b1).addMBB(ZeroMBB0);
  BuildMI(ZeroMBB, DL, TII->get(ADDI), R7b2).addReg(ZERO).addImm(2);
  BuildMI(ZeroMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b2).addMBB(ZeroMBB1);
  BuildMI(ZeroMBB, DL, TII->get(ADDI), R7b3).addReg(ZERO).addImm(3);
  BuildMI(ZeroMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b3).addMBB(ZeroMBB2);
  BuildMI(ZeroMBB, DL, TII->get(LoongArch::B32)).addMBB(ZeroMBB3);

  BuildMI(ZeroMBB3, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(ZeroMBB3, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0x00fff);
  BuildMI(ZeroMBB3, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(ZeroMBB3, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(ZeroMBB3, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80_3);
  BuildMI(ZeroMBB3, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(0);
  BuildMI(ZeroMBB3, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(ZeroMBB0, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(ZeroMBB0, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(8);
  BuildMI(ZeroMBB0, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xff00f);
  BuildMI(ZeroMBB0, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(ZeroMBB0, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(ZeroMBB0, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(ZeroMBB0, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(0);
  BuildMI(ZeroMBB0, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(ZeroMBB1, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(ZeroMBB1, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(16);
  BuildMI(ZeroMBB1, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xffff0);
  BuildMI(ZeroMBB1, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0x0ff);
  BuildMI(ZeroMBB1, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(ZeroMBB1, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(ZeroMBB1, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(0);
  BuildMI(ZeroMBB1, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(ZeroMBB2, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(ZeroMBB2, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(24);
  BuildMI(ZeroMBB2, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xfffff);
  BuildMI(ZeroMBB2, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xf00);
  BuildMI(ZeroMBB2, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(ZeroMBB2, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(ZeroMBB2, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(0);
  BuildMI(ZeroMBB2, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(OneMBB, DL, TII->get(LoongArch::XVPICKVE2GR_W), R70)
      .addReg(SrcVecReg)
      .addImm(1);
  BuildMI(OneMBB, DL, TII->get(ADDI), R7b1).addReg(ZERO).addImm(1);
  BuildMI(OneMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b1).addMBB(OneMBB0);
  BuildMI(OneMBB, DL, TII->get(ADDI), R7b2).addReg(ZERO).addImm(2);
  BuildMI(OneMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b2).addMBB(OneMBB1);
  BuildMI(OneMBB, DL, TII->get(ADDI), R7b3).addReg(ZERO).addImm(3);
  BuildMI(OneMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b3).addMBB(OneMBB2);
  BuildMI(OneMBB, DL, TII->get(LoongArch::B32)).addMBB(OneMBB3);

  BuildMI(OneMBB3, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(OneMBB3, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0x00fff);
  BuildMI(OneMBB3, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(OneMBB3, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(OneMBB3, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80_3);
  BuildMI(OneMBB3, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(1);
  BuildMI(OneMBB3, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(OneMBB0, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(OneMBB0, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(8);
  BuildMI(OneMBB0, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xff00f);
  BuildMI(OneMBB0, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(OneMBB0, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(OneMBB0, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(OneMBB0, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(1);
  BuildMI(OneMBB0, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(OneMBB1, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(OneMBB1, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(16);
  BuildMI(OneMBB1, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xffff0);
  BuildMI(OneMBB1, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0x0ff);
  BuildMI(OneMBB1, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(OneMBB1, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(OneMBB1, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(1);
  BuildMI(OneMBB1, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(OneMBB2, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(OneMBB2, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(24);
  BuildMI(OneMBB2, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xfffff);
  BuildMI(OneMBB2, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xf00);
  BuildMI(OneMBB2, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(OneMBB2, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(OneMBB2, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(1);
  BuildMI(OneMBB2, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(TwoMBB, DL, TII->get(LoongArch::XVPICKVE2GR_W), R70)
      .addReg(SrcVecReg)
      .addImm(2);
  BuildMI(TwoMBB, DL, TII->get(ADDI), R7b1).addReg(ZERO).addImm(1);
  BuildMI(TwoMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b1).addMBB(TwoMBB0);
  BuildMI(TwoMBB, DL, TII->get(ADDI), R7b2).addReg(ZERO).addImm(2);
  BuildMI(TwoMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b2).addMBB(TwoMBB1);
  BuildMI(TwoMBB, DL, TII->get(ADDI), R7b3).addReg(ZERO).addImm(3);
  BuildMI(TwoMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b3).addMBB(TwoMBB2);
  BuildMI(TwoMBB, DL, TII->get(LoongArch::B32)).addMBB(TwoMBB3);

  BuildMI(TwoMBB3, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(TwoMBB3, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0x00fff);
  BuildMI(TwoMBB3, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(TwoMBB3, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(TwoMBB3, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80_3);
  BuildMI(TwoMBB3, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(2);
  BuildMI(TwoMBB3, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(TwoMBB0, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(TwoMBB0, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(8);
  BuildMI(TwoMBB0, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xff00f);
  BuildMI(TwoMBB0, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(TwoMBB0, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(TwoMBB0, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(TwoMBB0, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(2);
  BuildMI(TwoMBB0, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(TwoMBB1, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(TwoMBB1, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(16);
  BuildMI(TwoMBB1, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xffff0);
  BuildMI(TwoMBB1, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0x0ff);
  BuildMI(TwoMBB1, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(TwoMBB1, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(TwoMBB1, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(2);
  BuildMI(TwoMBB1, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(TwoMBB2, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(TwoMBB2, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(24);
  BuildMI(TwoMBB2, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xfffff);
  BuildMI(TwoMBB2, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xf00);
  BuildMI(TwoMBB2, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(TwoMBB2, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(TwoMBB2, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(2);
  BuildMI(TwoMBB2, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(ThreeMBB, DL, TII->get(LoongArch::XVPICKVE2GR_W), R70)
      .addReg(SrcVecReg)
      .addImm(3);
  BuildMI(ThreeMBB, DL, TII->get(ADDI), R7b1).addReg(ZERO).addImm(1);
  BuildMI(ThreeMBB, DL, TII->get(BLT))
      .addReg(Ris)
      .addReg(R7b1)
      .addMBB(ThreeMBB0);
  BuildMI(ThreeMBB, DL, TII->get(ADDI), R7b2).addReg(ZERO).addImm(2);
  BuildMI(ThreeMBB, DL, TII->get(BLT))
      .addReg(Ris)
      .addReg(R7b2)
      .addMBB(ThreeMBB1);
  BuildMI(ThreeMBB, DL, TII->get(ADDI), R7b3).addReg(ZERO).addImm(3);
  BuildMI(ThreeMBB, DL, TII->get(BLT))
      .addReg(Ris)
      .addReg(R7b3)
      .addMBB(ThreeMBB2);
  BuildMI(ThreeMBB, DL, TII->get(LoongArch::B32)).addMBB(ThreeMBB3);

  BuildMI(ThreeMBB3, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(ThreeMBB3, DL, TII->get(LoongArch::LU12I_W), R7r81l_3)
      .addImm(0x00fff);
  BuildMI(ThreeMBB3, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(ThreeMBB3, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(ThreeMBB3, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80_3);
  BuildMI(ThreeMBB3, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(3);
  BuildMI(ThreeMBB3, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(ThreeMBB0, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(ThreeMBB0, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(8);
  BuildMI(ThreeMBB0, DL, TII->get(LoongArch::LU12I_W), R7r81l_3)
      .addImm(0xff00f);
  BuildMI(ThreeMBB0, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(ThreeMBB0, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(ThreeMBB0, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(ThreeMBB0, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(3);
  BuildMI(ThreeMBB0, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(ThreeMBB1, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(ThreeMBB1, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(16);
  BuildMI(ThreeMBB1, DL, TII->get(LoongArch::LU12I_W), R7r81l_3)
      .addImm(0xffff0);
  BuildMI(ThreeMBB1, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0x0ff);
  BuildMI(ThreeMBB1, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(ThreeMBB1, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(ThreeMBB1, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(3);
  BuildMI(ThreeMBB1, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(ThreeMBB2, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(ThreeMBB2, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(24);
  BuildMI(ThreeMBB2, DL, TII->get(LoongArch::LU12I_W), R7r81l_3)
      .addImm(0xfffff);
  BuildMI(ThreeMBB2, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xf00);
  BuildMI(ThreeMBB2, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(ThreeMBB2, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(ThreeMBB2, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(3);
  BuildMI(ThreeMBB2, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(FourMBB, DL, TII->get(LoongArch::XVPICKVE2GR_W), R70)
      .addReg(SrcVecReg)
      .addImm(4);
  BuildMI(FourMBB, DL, TII->get(ADDI), R7b1).addReg(ZERO).addImm(1);
  BuildMI(FourMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b1).addMBB(FourMBB0);
  BuildMI(FourMBB, DL, TII->get(ADDI), R7b2).addReg(ZERO).addImm(2);
  BuildMI(FourMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b2).addMBB(FourMBB1);
  BuildMI(FourMBB, DL, TII->get(ADDI), R7b3).addReg(ZERO).addImm(3);
  BuildMI(FourMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b3).addMBB(FourMBB2);
  BuildMI(FourMBB, DL, TII->get(LoongArch::B32)).addMBB(FourMBB3);

  BuildMI(FourMBB3, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(FourMBB3, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0x00fff);
  BuildMI(FourMBB3, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(FourMBB3, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(FourMBB3, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80_3);
  BuildMI(FourMBB3, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(4);
  BuildMI(FourMBB3, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(FourMBB0, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(FourMBB0, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(8);
  BuildMI(FourMBB0, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xff00f);
  BuildMI(FourMBB0, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(FourMBB0, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(FourMBB0, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(FourMBB0, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(4);
  BuildMI(FourMBB0, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(FourMBB1, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(FourMBB1, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(16);
  BuildMI(FourMBB1, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xffff0);
  BuildMI(FourMBB1, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0x0ff);
  BuildMI(FourMBB1, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(FourMBB1, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(FourMBB1, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(4);
  BuildMI(FourMBB1, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(FourMBB2, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(FourMBB2, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(24);
  BuildMI(FourMBB2, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xfffff);
  BuildMI(FourMBB2, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xf00);
  BuildMI(FourMBB2, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(FourMBB2, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(FourMBB2, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(4);
  BuildMI(FourMBB2, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(FiveMBB, DL, TII->get(LoongArch::XVPICKVE2GR_W), R70)
      .addReg(SrcVecReg)
      .addImm(5);
  BuildMI(FiveMBB, DL, TII->get(ADDI), R7b1).addReg(ZERO).addImm(1);
  BuildMI(FiveMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b1).addMBB(FiveMBB0);
  BuildMI(FiveMBB, DL, TII->get(ADDI), R7b2).addReg(ZERO).addImm(2);
  BuildMI(FiveMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b2).addMBB(FiveMBB1);
  BuildMI(FiveMBB, DL, TII->get(ADDI), R7b3).addReg(ZERO).addImm(3);
  BuildMI(FiveMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b3).addMBB(FiveMBB2);
  BuildMI(FiveMBB, DL, TII->get(LoongArch::B32)).addMBB(FiveMBB3);

  BuildMI(FiveMBB3, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(FiveMBB3, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0x00fff);
  BuildMI(FiveMBB3, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(FiveMBB3, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(FiveMBB3, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80_3);
  BuildMI(FiveMBB3, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(5);
  BuildMI(FiveMBB3, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(FiveMBB0, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(FiveMBB0, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(8);
  BuildMI(FiveMBB0, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xff00f);
  BuildMI(FiveMBB0, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(FiveMBB0, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(FiveMBB0, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(FiveMBB0, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(5);
  BuildMI(FiveMBB0, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(FiveMBB1, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(FiveMBB1, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(16);
  BuildMI(FiveMBB1, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xffff0);
  BuildMI(FiveMBB1, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0x0ff);
  BuildMI(FiveMBB1, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(FiveMBB1, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(FiveMBB1, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(5);
  BuildMI(FiveMBB1, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(FiveMBB2, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(FiveMBB2, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(24);
  BuildMI(FiveMBB2, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xfffff);
  BuildMI(FiveMBB2, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xf00);
  BuildMI(FiveMBB2, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(FiveMBB2, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(FiveMBB2, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(5);
  BuildMI(FiveMBB2, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(SixMBB, DL, TII->get(LoongArch::XVPICKVE2GR_W), R70)
      .addReg(SrcVecReg)
      .addImm(6);
  BuildMI(SixMBB, DL, TII->get(ADDI), R7b1).addReg(ZERO).addImm(1);
  BuildMI(SixMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b1).addMBB(SixMBB0);
  BuildMI(SixMBB, DL, TII->get(ADDI), R7b2).addReg(ZERO).addImm(2);
  BuildMI(SixMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b2).addMBB(SixMBB1);
  BuildMI(SixMBB, DL, TII->get(ADDI), R7b3).addReg(ZERO).addImm(3);
  BuildMI(SixMBB, DL, TII->get(BLT)).addReg(Ris).addReg(R7b3).addMBB(SixMBB2);
  BuildMI(SixMBB, DL, TII->get(LoongArch::B32)).addMBB(SixMBB3);

  BuildMI(SixMBB3, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(SixMBB3, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0x00fff);
  BuildMI(SixMBB3, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(SixMBB3, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(SixMBB3, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80_3);
  BuildMI(SixMBB3, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(6);
  BuildMI(SixMBB3, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(SixMBB0, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(SixMBB0, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(8);
  BuildMI(SixMBB0, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xff00f);
  BuildMI(SixMBB0, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xfff);
  BuildMI(SixMBB0, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(SixMBB0, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(SixMBB0, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(6);
  BuildMI(SixMBB0, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(SixMBB1, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(SixMBB1, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(16);
  BuildMI(SixMBB1, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xffff0);
  BuildMI(SixMBB1, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0x0ff);
  BuildMI(SixMBB1, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(SixMBB1, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(SixMBB1, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(6);
  BuildMI(SixMBB1, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  BuildMI(SixMBB2, DL, TII->get(LoongArch::SLLI_W), R7r80_3)
      .addReg(SrcValReg)
      .addImm(24);
  BuildMI(SixMBB2, DL, TII->get(LoongArch::SRLI_W), R7r80l_3)
      .addReg(R7r80_3)
      .addImm(24);
  BuildMI(SixMBB2, DL, TII->get(LoongArch::LU12I_W), R7r81l_3).addImm(0xfffff);
  BuildMI(SixMBB2, DL, TII->get(LoongArch::ORI32), R7r81_3)
      .addReg(R7r81l_3)
      .addImm(0xf00);
  BuildMI(SixMBB2, DL, TII->get(LoongArch::AND32), R7r82l_3)
      .addReg(R70)
      .addReg(R7r81_3);
  BuildMI(SixMBB2, DL, TII->get(LoongArch::OR32), R7r82_3)
      .addReg(R7r82l_3)
      .addReg(R7r80l_3);
  BuildMI(SixMBB2, DL, TII->get(LoongArch::XVINSGR2VR_W), tmp_Dst73)
      .addReg(SrcVecReg)
      .addReg(R7r82_3)
      .addImm(6);
  BuildMI(SixMBB2, DL, TII->get(LoongArch::B32)).addMBB(sinkMBB);

  sinkMBB->addSuccessor(exitMBB, BranchProbability::getOne());

  BuildMI(sinkMBB, DL, TII->get(LoongArch::XVORI_B), Dest)
      .addReg(tmp_Dst73)
      .addImm(0);

  LivePhysRegs LiveRegs;
  computeAndAddLiveIns(LiveRegs, *mainMBB);
  computeAndAddLiveIns(LiveRegs, *SevenMBB);
  computeAndAddLiveIns(LiveRegs, *SevenMBB0);
  computeAndAddLiveIns(LiveRegs, *SevenMBB1);
  computeAndAddLiveIns(LiveRegs, *SevenMBB2);
  computeAndAddLiveIns(LiveRegs, *SevenMBB3);
  computeAndAddLiveIns(LiveRegs, *ZeroMBB);
  computeAndAddLiveIns(LiveRegs, *ZeroMBB0);
  computeAndAddLiveIns(LiveRegs, *ZeroMBB1);
  computeAndAddLiveIns(LiveRegs, *ZeroMBB2);
  computeAndAddLiveIns(LiveRegs, *ZeroMBB3);
  computeAndAddLiveIns(LiveRegs, *OneMBB);
  computeAndAddLiveIns(LiveRegs, *OneMBB0);
  computeAndAddLiveIns(LiveRegs, *OneMBB1);
  computeAndAddLiveIns(LiveRegs, *OneMBB2);
  computeAndAddLiveIns(LiveRegs, *OneMBB3);
  computeAndAddLiveIns(LiveRegs, *TwoMBB);
  computeAndAddLiveIns(LiveRegs, *TwoMBB0);
  computeAndAddLiveIns(LiveRegs, *TwoMBB1);
  computeAndAddLiveIns(LiveRegs, *TwoMBB2);
  computeAndAddLiveIns(LiveRegs, *TwoMBB3);
  computeAndAddLiveIns(LiveRegs, *ThreeMBB);
  computeAndAddLiveIns(LiveRegs, *ThreeMBB0);
  computeAndAddLiveIns(LiveRegs, *ThreeMBB1);
  computeAndAddLiveIns(LiveRegs, *ThreeMBB2);
  computeAndAddLiveIns(LiveRegs, *ThreeMBB3);
  computeAndAddLiveIns(LiveRegs, *FourMBB);
  computeAndAddLiveIns(LiveRegs, *FourMBB0);
  computeAndAddLiveIns(LiveRegs, *FourMBB1);
  computeAndAddLiveIns(LiveRegs, *FourMBB2);
  computeAndAddLiveIns(LiveRegs, *FourMBB3);
  computeAndAddLiveIns(LiveRegs, *FiveMBB);
  computeAndAddLiveIns(LiveRegs, *FiveMBB0);
  computeAndAddLiveIns(LiveRegs, *FiveMBB1);
  computeAndAddLiveIns(LiveRegs, *FiveMBB2);
  computeAndAddLiveIns(LiveRegs, *FiveMBB3);
  computeAndAddLiveIns(LiveRegs, *SixMBB);
  computeAndAddLiveIns(LiveRegs, *SixMBB0);
  computeAndAddLiveIns(LiveRegs, *SixMBB1);
  computeAndAddLiveIns(LiveRegs, *SixMBB2);
  computeAndAddLiveIns(LiveRegs, *SixMBB3);
  computeAndAddLiveIns(LiveRegs, *sinkMBB);
  computeAndAddLiveIns(LiveRegs, *exitMBB);

  NMBBI = BB.end();
  I->eraseFromParent();

  return true;
}

bool LoongArchExpandPseudo::expandAtomicBinOpSubword(
    MachineBasicBlock &BB, MachineBasicBlock::iterator I,
    MachineBasicBlock::iterator &NMBBI) {

  MachineFunction *MF = BB.getParent();

  DebugLoc DL = I->getDebugLoc();
  unsigned LL, SC;
  unsigned BEQ = LoongArch::BEQ32;
  unsigned SEOp = LoongArch::EXT_W_H32;

  LL = LoongArch::LL_W;
  SC = LoongArch::SC_W;

  bool IsSwap = false;
  bool IsNand = false;
  bool IsMAX = false;
  bool IsMIN = false;
  bool IsUnsigned = false;

  unsigned Opcode = 0;
  switch (I->getOpcode()) {
  case LoongArch::ATOMIC_LOAD_NAND_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_LOAD_NAND_I16_POSTRA:
    IsNand = true;
    break;
  case LoongArch::ATOMIC_SWAP_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_SWAP_I16_POSTRA:
    IsSwap = true;
    break;
  case LoongArch::ATOMIC_LOAD_ADD_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_LOAD_ADD_I16_POSTRA:
    Opcode = LoongArch::ADD_W;
    break;
  case LoongArch::ATOMIC_LOAD_MAX_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_LOAD_MAX_I16_POSTRA:
    Opcode = LoongArch::AMMAX_DB_W;
    IsMAX = true;
    break;
  case LoongArch::ATOMIC_LOAD_MIN_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_LOAD_MIN_I16_POSTRA:
    Opcode = LoongArch::AMMIN_DB_W;
    IsMIN = true;
    break;
  case LoongArch::ATOMIC_LOAD_UMAX_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_LOAD_UMAX_I16_POSTRA:
    Opcode = LoongArch::AMMAX_DB_WU;
    IsMAX = true;
    IsUnsigned = true;
    break;
  case LoongArch::ATOMIC_LOAD_UMIN_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_LOAD_UMIN_I16_POSTRA:
    Opcode = LoongArch::AMMIN_DB_WU;
    IsMIN = true;
    IsUnsigned = true;
    break;
  case LoongArch::ATOMIC_LOAD_SUB_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_LOAD_SUB_I16_POSTRA:
    Opcode = LoongArch::SUB_W;
    break;
  case LoongArch::ATOMIC_LOAD_AND_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_LOAD_AND_I16_POSTRA:
    Opcode = LoongArch::AND32;
    break;
  case LoongArch::ATOMIC_LOAD_OR_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_LOAD_OR_I16_POSTRA:
    Opcode = LoongArch::OR32;
    break;
  case LoongArch::ATOMIC_LOAD_XOR_I8_POSTRA:
    SEOp = LoongArch::EXT_W_B32;
    LLVM_FALLTHROUGH;
  case LoongArch::ATOMIC_LOAD_XOR_I16_POSTRA:
    Opcode = LoongArch::XOR32;
    break;
  default:
    llvm_unreachable("Unknown subword atomic pseudo for expansion!");
  }

  unsigned Dest = I->getOperand(0).getReg();
  unsigned Ptr = I->getOperand(1).getReg();
  unsigned Incr = I->getOperand(2).getReg();
  unsigned Mask = I->getOperand(3).getReg();
  unsigned Mask2 = I->getOperand(4).getReg();
  unsigned ShiftAmnt = I->getOperand(5).getReg();
  unsigned OldVal = I->getOperand(6).getReg();
  unsigned BinOpRes = I->getOperand(7).getReg();
  unsigned StoreVal = I->getOperand(8).getReg();

  const BasicBlock *LLVM_BB = BB.getBasicBlock();
  MachineBasicBlock *loopMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *sinkMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *exitMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineFunction::iterator It = ++BB.getIterator();
  MF->insert(It, loopMBB);
  MF->insert(It, sinkMBB);
  MF->insert(It, exitMBB);

  exitMBB->splice(exitMBB->begin(), &BB, std::next(I), BB.end());
  exitMBB->transferSuccessorsAndUpdatePHIs(&BB);

  BB.addSuccessor(loopMBB, BranchProbability::getOne());
  loopMBB->addSuccessor(sinkMBB);
  loopMBB->addSuccessor(loopMBB);
  loopMBB->normalizeSuccProbs();

  BuildMI(loopMBB, DL, TII->get(LL), OldVal).addReg(Ptr).addImm(0);
  if (IsNand) {
    //  and andres, oldval, incr2
    //  nor binopres, $0, andres
    //  and newval, binopres, mask
    BuildMI(loopMBB, DL, TII->get(LoongArch::AND32), BinOpRes)
        .addReg(OldVal)
        .addReg(Incr);
    BuildMI(loopMBB, DL, TII->get(LoongArch::NOR32), BinOpRes)
        .addReg(LoongArch::ZERO)
        .addReg(BinOpRes);
    BuildMI(loopMBB, DL, TII->get(LoongArch::AND32), BinOpRes)
        .addReg(BinOpRes)
        .addReg(Mask);
  } else if (IsMAX || IsMIN) {

    unsigned SLTScratch4 = IsUnsigned ? LoongArch::SLTU32 : LoongArch::SLT32;
    unsigned CMPIncr = IsMAX ? LoongArch::MASKEQZ32 : LoongArch::MASKNEZ32;
    unsigned CMPOldVal = IsMAX ? LoongArch::MASKNEZ32 : LoongArch::MASKEQZ32;

    unsigned Scratch4 = I->getOperand(9).getReg();
    unsigned Scratch5 = I->getOperand(10).getReg();

    BuildMI(loopMBB, DL, TII->get(LoongArch::AND32), Scratch5)
        .addReg(OldVal)
        .addReg(Mask);
    BuildMI(loopMBB, DL, TII->get(LoongArch::AND32), Incr)
        .addReg(Incr)
        .addReg(Mask);
    BuildMI(loopMBB, DL, TII->get(SLTScratch4), Scratch4)
        .addReg(Scratch5)
        .addReg(Incr);
    BuildMI(loopMBB, DL, TII->get(CMPOldVal), BinOpRes)
        .addReg(Scratch5)
        .addReg(Scratch4);
    BuildMI(loopMBB, DL, TII->get(CMPIncr), Scratch4)
        .addReg(Incr)
        .addReg(Scratch4);
    BuildMI(loopMBB, DL, TII->get(LoongArch::OR32), BinOpRes)
        .addReg(BinOpRes)
        .addReg(Scratch4);

  } else if (!IsSwap) {
    //  <binop> binopres, oldval, incr2
    //  and newval, binopres, mask
    BuildMI(loopMBB, DL, TII->get(Opcode), BinOpRes)
        .addReg(OldVal)
        .addReg(Incr);
    BuildMI(loopMBB, DL, TII->get(LoongArch::AND32), BinOpRes)
        .addReg(BinOpRes)
        .addReg(Mask);
  } else { // atomic.swap
    //  and newval, incr2, mask
    BuildMI(loopMBB, DL, TII->get(LoongArch::AND32), BinOpRes)
        .addReg(Incr)
        .addReg(Mask);
  }

  // and StoreVal, OlddVal, Mask2
  // or StoreVal, StoreVal, BinOpRes
  // StoreVal<tied1> = sc StoreVal, 0(Ptr)
  // beq StoreVal, zero, loopMBB
  BuildMI(loopMBB, DL, TII->get(LoongArch::AND32), StoreVal)
      .addReg(OldVal)
      .addReg(Mask2);
  BuildMI(loopMBB, DL, TII->get(LoongArch::OR32), StoreVal)
      .addReg(StoreVal)
      .addReg(BinOpRes);
  BuildMI(loopMBB, DL, TII->get(SC), StoreVal)
      .addReg(StoreVal)
      .addReg(Ptr)
      .addImm(0);
  BuildMI(loopMBB, DL, TII->get(BEQ))
      .addReg(StoreVal)
      .addReg(LoongArch::ZERO)
      .addMBB(loopMBB);

  //  sinkMBB:
  //    and     maskedoldval1,oldval,mask
  //    srl     srlres,maskedoldval1,shiftamt
  //    sign_extend dest,srlres

  sinkMBB->addSuccessor(exitMBB, BranchProbability::getOne());

  BuildMI(sinkMBB, DL, TII->get(LoongArch::AND32), Dest)
      .addReg(OldVal)
      .addReg(Mask);
  BuildMI(sinkMBB, DL, TII->get(LoongArch::SRL_W), Dest)
      .addReg(Dest)
      .addReg(ShiftAmnt);

  BuildMI(sinkMBB, DL, TII->get(SEOp), Dest).addReg(Dest);

  LivePhysRegs LiveRegs;
  computeAndAddLiveIns(LiveRegs, *loopMBB);
  computeAndAddLiveIns(LiveRegs, *sinkMBB);
  computeAndAddLiveIns(LiveRegs, *exitMBB);

  NMBBI = BB.end();
  I->eraseFromParent();

  return true;
}

bool LoongArchExpandPseudo::expandAtomicBinOp(MachineBasicBlock &BB,
                                         MachineBasicBlock::iterator I,
                                         MachineBasicBlock::iterator &NMBBI,
                                         unsigned Size) {
  MachineFunction *MF = BB.getParent();

  DebugLoc DL = I->getDebugLoc();

  unsigned LL, SC, ZERO, BEQ, SUB;
  if (Size == 4) {
    LL = LoongArch::LL_W;
    SC = LoongArch::SC_W;
    BEQ = LoongArch::BEQ32;
    ZERO = LoongArch::ZERO;
    SUB = LoongArch::SUB_W;
  } else {
    LL = LoongArch::LL_D;
    SC = LoongArch::SC_D;
    ZERO = LoongArch::ZERO_64;
    BEQ = LoongArch::BEQ;
    SUB = LoongArch::SUB_D;
  }

  unsigned OldVal = I->getOperand(0).getReg();
  unsigned Ptr = I->getOperand(1).getReg();
  unsigned Incr = I->getOperand(2).getReg();
  unsigned Scratch = I->getOperand(3).getReg();

  unsigned Opcode = 0;
  unsigned OR = 0;
  unsigned AND = 0;
  unsigned NOR = 0;
  bool IsNand = false;
  bool IsSub = false;
  switch (I->getOpcode()) {
  case LoongArch::ATOMIC_LOAD_ADD_I32_POSTRA:
    Opcode = LoongArch::AMADD_DB_W;
    break;
  case LoongArch::ATOMIC_LOAD_SUB_I32_POSTRA:
    IsSub = true;
    Opcode = LoongArch::AMADD_DB_W;
    break;
  case LoongArch::ATOMIC_LOAD_AND_I32_POSTRA:
    Opcode = LoongArch::AMAND_DB_W;
    break;
  case LoongArch::ATOMIC_LOAD_OR_I32_POSTRA:
    Opcode = LoongArch::AMOR_DB_W;
    break;
  case LoongArch::ATOMIC_LOAD_XOR_I32_POSTRA:
    Opcode = LoongArch::AMXOR_DB_W;
    break;
  case LoongArch::ATOMIC_LOAD_NAND_I32_POSTRA:
    IsNand = true;
    AND = LoongArch::AND32;
    NOR = LoongArch::NOR32;
    break;
  case LoongArch::ATOMIC_SWAP_I32_POSTRA:
    OR = LoongArch::AMSWAP_DB_W;
    break;
  case LoongArch::ATOMIC_LOAD_MAX_I32_POSTRA:
    Opcode = LoongArch::AMMAX_DB_W;
    break;
  case LoongArch::ATOMIC_LOAD_MIN_I32_POSTRA:
    Opcode = LoongArch::AMMIN_DB_W;
    break;
  case LoongArch::ATOMIC_LOAD_UMAX_I32_POSTRA:
    Opcode = LoongArch::AMMAX_DB_WU;
    break;
  case LoongArch::ATOMIC_LOAD_UMIN_I32_POSTRA:
    Opcode = LoongArch::AMMIN_DB_WU;
    break;
  case LoongArch::ATOMIC_LOAD_ADD_I64_POSTRA:
    Opcode = LoongArch::AMADD_DB_D;
    break;
  case LoongArch::ATOMIC_LOAD_SUB_I64_POSTRA:
    IsSub = true;
    Opcode = LoongArch::AMADD_DB_D;
    break;
  case LoongArch::ATOMIC_LOAD_AND_I64_POSTRA:
    Opcode = LoongArch::AMAND_DB_D;
    break;
  case LoongArch::ATOMIC_LOAD_OR_I64_POSTRA:
    Opcode = LoongArch::AMOR_DB_D;
    break;
  case LoongArch::ATOMIC_LOAD_XOR_I64_POSTRA:
    Opcode = LoongArch::AMXOR_DB_D;
    break;
  case LoongArch::ATOMIC_LOAD_NAND_I64_POSTRA:
    IsNand = true;
    AND = LoongArch::AND;
    NOR = LoongArch::NOR;
    break;
  case LoongArch::ATOMIC_SWAP_I64_POSTRA:
    OR = LoongArch::AMSWAP_DB_D;
    break;
  case LoongArch::ATOMIC_LOAD_MAX_I64_POSTRA:
    Opcode = LoongArch::AMMAX_DB_D;
    break;
  case LoongArch::ATOMIC_LOAD_MIN_I64_POSTRA:
    Opcode = LoongArch::AMMIN_DB_D;
    break;
  case LoongArch::ATOMIC_LOAD_UMAX_I64_POSTRA:
    Opcode = LoongArch::AMMAX_DB_DU;
    break;
  case LoongArch::ATOMIC_LOAD_UMIN_I64_POSTRA:
    Opcode = LoongArch::AMMIN_DB_DU;
    break;
  default:
    llvm_unreachable("Unknown pseudo atomic!");
  }

  const BasicBlock *LLVM_BB = BB.getBasicBlock();
  MachineBasicBlock *loopMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *exitMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineFunction::iterator It = ++BB.getIterator();
  MF->insert(It, loopMBB);
  MF->insert(It, exitMBB);

  exitMBB->splice(exitMBB->begin(), &BB, std::next(I), BB.end());
  exitMBB->transferSuccessorsAndUpdatePHIs(&BB);

  BB.addSuccessor(loopMBB, BranchProbability::getOne());
  loopMBB->addSuccessor(exitMBB);
  loopMBB->addSuccessor(loopMBB);
  loopMBB->normalizeSuccProbs();

  assert((OldVal != Ptr) && "Clobbered the wrong ptr reg!");
  assert((OldVal != Incr) && "Clobbered the wrong reg!");
  if (Opcode) {
    if(IsSub){
      BuildMI(loopMBB, DL, TII->get(SUB), Scratch).addReg(ZERO).addReg(Incr);
      BuildMI(loopMBB, DL, TII->get(Opcode), OldVal).addReg(Scratch).addReg(Ptr).addImm(0);
    }
    else{
      BuildMI(loopMBB, DL, TII->get(Opcode), OldVal).addReg(Incr).addReg(Ptr).addImm(0);
    }
  } else if (IsNand) {
    assert(AND && NOR &&
           "Unknown nand instruction for atomic pseudo expansion");
    BuildMI(loopMBB, DL, TII->get(LL), OldVal).addReg(Ptr).addImm(0);
    BuildMI(loopMBB, DL, TII->get(AND), Scratch).addReg(OldVal).addReg(Incr);
    BuildMI(loopMBB, DL, TII->get(NOR), Scratch).addReg(ZERO).addReg(Scratch);
    BuildMI(loopMBB, DL, TII->get(SC), Scratch).addReg(Scratch).addReg(Ptr).addImm(0);
    BuildMI(loopMBB, DL, TII->get(BEQ)).addReg(Scratch).addReg(ZERO).addMBB(loopMBB);
  } else {
    assert(OR && "Unknown instruction for atomic pseudo expansion!");
    BuildMI(loopMBB, DL, TII->get(OR), OldVal).addReg(Incr).addReg(Ptr).addImm(0);
  }


  NMBBI = BB.end();
  I->eraseFromParent();

  LivePhysRegs LiveRegs;
  computeAndAddLiveIns(LiveRegs, *loopMBB);
  computeAndAddLiveIns(LiveRegs, *exitMBB);

  return true;
}

bool LoongArchExpandPseudo::expandLoadAddr(MachineBasicBlock &BB,
                                           MachineBasicBlock::iterator I,
                                           MachineBasicBlock::iterator &NMBBI) {
  MachineFunction *MF = BB.getParent();
  MachineInstr &MI = *I;
  DebugLoc DL = MI.getDebugLoc();

  unsigned Op = MI.getOpcode();
  unsigned DestReg = MI.getOperand(0).getReg();
  unsigned TmpReg;
  const MachineOperand &MO = MI.getOperand(1);
  Reloc::Model RM = MF->getTarget().getRelocationModel();

  MachineInstrBuilder MIB1, MIB2, MIB3, MIB4, MIB5;
  unsigned HiFlag, LoFlag, HigherFlag, HighestFlag;
  unsigned HiOp, LoOp, HigherOp, HighestOp, LastOp;
  bool UseGot = false;

  HiOp = LoongArch::PCADDU12I_ri;
  LoOp = LoongArch::ORI_rri;
  HigherOp = LoongArch::LU32I_D_ri;
  HighestOp = LoongArch::LU52I_D_rri;

  switch (Op) {
  case LoongArch::LoadAddrLocal:
    if (RM == Reloc::Static) { // for jit
      HiFlag = LoongArchII::MO_ABS_HI;
      LoFlag = LoongArchII::MO_ABS_LO;
      HigherFlag = LoongArchII::MO_ABS_HIGHER;
      HighestFlag = LoongArchII::MO_ABS_HIGHEST;
      // lu12i.w + ori + lu32i.d + lu52i.d
      HiOp = LoongArch::LU12I_W;
      LoOp = LoongArch::ORI;
      HigherOp = LoongArch::LU32I_D;
      HighestOp = LoongArch::LU52I_D;
    } else {
      // pcaddu12i + addi.d
      LoFlag = LoongArchII::MO_PCREL_LO;
      HiFlag = LoongArchII::MO_PCREL_HI;
      LoOp = LoongArch::ADDI_D_rri;
    }
    break;
  case LoongArch::LoadAddrLocalRR:
    // pcaddu12i + ori + lu32i.d + lu52i.d + add.d
    LoFlag = LoongArchII::MO_PCREL_RRLO;
    HiFlag = LoongArchII::MO_PCREL_RRHI;
    HigherFlag = LoongArchII::MO_PCREL_RRHIGHER;
    HighestFlag = LoongArchII::MO_PCREL_RRHIGHEST;
    LastOp = LoongArch::ADD_D_rrr;
    break;
  case LoongArch::LoadAddrGlobal:
  case LoongArch::LoadAddrGlobal_Alias:
    // pcaddu12i + ld.d
    LoFlag = LoongArchII::MO_GOT_LO;
    HiFlag = LoongArchII::MO_GOT_HI;
    HiOp = LoongArch::PCADDU12I_rii;
    LoOp = LoongArch::LD_D_rrii;
    UseGot = true;
    break;
  case LoongArch::LoadAddrGlobalRR:
    // pcaddu12i + ori + lu32i.d + lu52i.d +ldx.d
    LoFlag = LoongArchII::MO_GOT_RRLO;
    HiFlag = LoongArchII::MO_GOT_RRHI;
    HigherFlag = LoongArchII::MO_GOT_RRHIGHER;
    HighestFlag = LoongArchII::MO_GOT_RRHIGHEST;
    HiOp = LoongArch::PCADDU12I_rii;
    LoOp = LoongArch::ORI_rrii;
    HigherOp = LoongArch::LU32I_D_rii;
    HighestOp = LoongArch::LU52I_D_rrii;
    LastOp = LoongArch::LDX_D_rrr;
    UseGot = true;
    break;
  case LoongArch::LoadAddrTLS_LE:
    // lu12i.w + ori + lu32i.d + lu52i.d
    LoFlag = LoongArchII::MO_TLSLE_LO;
    HiFlag = LoongArchII::MO_TLSLE_HI;
    HigherFlag = LoongArchII::MO_TLSLE_HIGHER;
    HighestFlag = LoongArchII::MO_TLSLE_HIGHEST;
    HiOp = LoongArch::LU12I_W_ri;
    break;
  case LoongArch::LoadAddrTLS_IE:
    // pcaddu12i + ld.d
    LoFlag = LoongArchII::MO_TLSIE_LO;
    HiFlag = LoongArchII::MO_TLSIE_HI;
    HiOp = LoongArch::PCADDU12I_rii;
    LoOp = LoongArch::LD_D_rrii;
    UseGot = true;
    break;
  case LoongArch::LoadAddrTLS_IE_RR:
    // pcaddu12i + ori + lu32i.d + lu52i.d +ldx.d
    LoFlag = LoongArchII::MO_TLSIE_RRLO;
    HiFlag = LoongArchII::MO_TLSIE_RRHI;
    HigherFlag = LoongArchII::MO_TLSIE_RRHIGHER;
    HighestFlag = LoongArchII::MO_TLSIE_RRHIGHEST;
    HiOp = LoongArch::PCADDU12I_rii;
    LoOp = LoongArch::ORI_rrii;
    HigherOp = LoongArch::LU32I_D_rii;
    HighestOp = LoongArch::LU52I_D_rrii;
    LastOp = LoongArch::LDX_D_rrr;
    UseGot = true;
    break;
  case LoongArch::LoadAddrTLS_LD:
  case LoongArch::LoadAddrTLS_GD:
    // pcaddu12i + addi.d
    LoFlag = LoongArchII::MO_TLSGD_LO;
    HiFlag = LoongArchII::MO_TLSGD_HI;
    HiOp = LoongArch::PCADDU12I_rii;
    LoOp = LoongArch::ADDI_D_rrii;
    UseGot = true;
    break;
  case LoongArch::LoadAddrTLS_LD_RR:
  case LoongArch::LoadAddrTLS_GD_RR:
    // pcaddu12i + ori + lu32i.d + lu52i.d + add.d
    LoFlag = LoongArchII::MO_TLSGD_RRLO;
    HiFlag = LoongArchII::MO_TLSGD_RRHI;
    HigherFlag = LoongArchII::MO_TLSGD_RRHIGHER;
    HighestFlag = LoongArchII::MO_TLSGD_RRHIGHEST;
    HiOp = LoongArch::PCADDU12I_rii;
    LoOp = LoongArch::ORI_rrii;
    HigherOp = LoongArch::LU32I_D_rii;
    HighestOp = LoongArch::LU52I_D_rrii;
    LastOp = LoongArch::ADD_D_rrr;
    UseGot = true;
    break;
  default:
    break;
  }

  MIB1 = BuildMI(BB, I, DL, TII->get(HiOp), DestReg);

  switch (Op) {
  case LoongArch::LoadAddrLocal:
    if (RM == Reloc::Static) { // for jit
      // la.abs rd, symbol
      MIB2 = BuildMI(BB, I, DL, TII->get(LoOp), DestReg).addReg(DestReg);
      MIB3 = BuildMI(BB, I, DL, TII->get(HigherOp), DestReg);
      MIB4 = BuildMI(BB, I, DL, TII->get(HighestOp), DestReg).addReg(DestReg);
      if (MO.isJTI()) {
        MIB1.addJumpTableIndex(MO.getIndex(), HiFlag);
        MIB2.addJumpTableIndex(MO.getIndex(), LoFlag);
        MIB3.addJumpTableIndex(MO.getIndex(), HigherFlag);
        MIB4.addJumpTableIndex(MO.getIndex(), HighestFlag);
      } else if (MO.isBlockAddress()) {
        MIB1.addBlockAddress(MO.getBlockAddress(), 0, HiFlag);
        MIB2.addBlockAddress(MO.getBlockAddress(), 0, LoFlag);
        MIB3.addBlockAddress(MO.getBlockAddress(), 0, HigherFlag);
        MIB4.addBlockAddress(MO.getBlockAddress(), 0, HighestFlag);
      } else {
        MIB1.addDisp(MO, 0, HiFlag);
        MIB2.addDisp(MO, 0, LoFlag);
        MIB3.addDisp(MO, 0, HigherFlag);
        MIB4.addDisp(MO, 0, HighestFlag);
      }
      break;
    }
    LLVM_FALLTHROUGH;
  case LoongArch::LoadAddrGlobal: // la.global rd, symbol
  case LoongArch::LoadAddrGlobal_Alias: // la rd, symbol
  case LoongArch::LoadAddrTLS_IE: // la.tls.ie rd, symbol
  case LoongArch::LoadAddrTLS_LD: // la.tls.ld rd, symbol
  case LoongArch::LoadAddrTLS_GD: // la.tls.gd rd, symbol
    MIB2 = BuildMI(BB, I, DL, TII->get(LoOp), DestReg)
      .addReg(DestReg);
    if (MO.isJTI()) {
      MIB1.addJumpTableIndex(MO.getIndex(), HiFlag);
      MIB2.addJumpTableIndex(MO.getIndex(), LoFlag);
    } else if (MO.isBlockAddress()) {
      MIB1.addBlockAddress(MO.getBlockAddress(), 0, HiFlag);
      MIB2.addBlockAddress(MO.getBlockAddress(), 0, LoFlag);
    } else {
      MIB1.addDisp(MO, 0, HiFlag);
      MIB2.addDisp(MO, 0, LoFlag);
    }
    if (UseGot == true) {
      MIB1.addExternalSymbol("_GLOBAL_OFFSET_TABLE_");
      MIB2.addExternalSymbol("_GLOBAL_OFFSET_TABLE_");
    }
    break;

  case LoongArch::LoadAddrLocalRR: //la.local rd, rs, symbol
  case LoongArch::LoadAddrGlobalRR: // la.global rd, rs, symbol
  case LoongArch::LoadAddrTLS_IE_RR: // la.tls.ie rd, rs, symbol
  case LoongArch::LoadAddrTLS_LD_RR: // la.tls.ld rd, rs, symbol
  case LoongArch::LoadAddrTLS_GD_RR: // la.tls.gd rd, rs, symbol
    TmpReg = MI.getOperand(MI.getNumOperands()-1).getReg();
    MIB2 = BuildMI(BB, I, DL, TII->get(LoOp), TmpReg)
                  .addReg(TmpReg);
    MIB3 = BuildMI(BB, I, DL, TII->get(HigherOp), TmpReg);
    MIB4 = BuildMI(BB, I, DL, TII->get(HighestOp), TmpReg)
                  .addReg(TmpReg);
    MIB5 = BuildMI(BB, I, DL, TII->get(LastOp), DestReg)
                  .addReg(DestReg)
                  .addReg(TmpReg);
    if (MO.isJTI()) {
      MIB1.addJumpTableIndex(MO.getIndex(), HiFlag);
      MIB2.addJumpTableIndex(MO.getIndex(), LoFlag);
      MIB3.addJumpTableIndex(MO.getIndex(), HigherFlag);
      MIB4.addJumpTableIndex(MO.getIndex(), HighestFlag);
    } else if (MO.isBlockAddress()) {
      MIB1.addBlockAddress(MO.getBlockAddress(), 0, HiFlag);
      MIB2.addBlockAddress(MO.getBlockAddress(), 0, LoFlag);
      MIB3.addBlockAddress(MO.getBlockAddress(), 0, HigherFlag);
      MIB4.addBlockAddress(MO.getBlockAddress(), 0, HighestFlag);
    } else {
      MIB1.addDisp(MO, 0, HiFlag);
      MIB2.addDisp(MO, 0, LoFlag);
      MIB3.addDisp(MO, 0, HigherFlag);
      MIB4.addDisp(MO, 0, HighestFlag);
    }
    if (UseGot == true) {
      MIB1.addExternalSymbol("_GLOBAL_OFFSET_TABLE_");
      MIB2.addExternalSymbol("_GLOBAL_OFFSET_TABLE_");
      MIB3.addExternalSymbol("_GLOBAL_OFFSET_TABLE_");
      MIB4.addExternalSymbol("_GLOBAL_OFFSET_TABLE_");
    }
    break;
  case LoongArch::LoadAddrTLS_LE: // la.tls.le rd, symbol
    MIB2 = BuildMI(BB, I, DL, TII->get(LoOp), DestReg)
                  .addReg(DestReg);
    MIB3 = BuildMI(BB, I, DL, TII->get(HigherOp), DestReg);
    MIB4 = BuildMI(BB, I, DL, TII->get(HighestOp), DestReg)
                  .addReg(DestReg);
    if (MO.isJTI()) {
      MIB1.addJumpTableIndex(MO.getIndex(), HiFlag);
      MIB2.addJumpTableIndex(MO.getIndex(), LoFlag);
      MIB3.addJumpTableIndex(MO.getIndex(), HigherFlag);
      MIB4.addJumpTableIndex(MO.getIndex(), HighestFlag);
    } else if (MO.isBlockAddress()) {
      MIB1.addBlockAddress(MO.getBlockAddress(), 0, HiFlag);
      MIB2.addBlockAddress(MO.getBlockAddress(), 0, LoFlag);
      MIB3.addBlockAddress(MO.getBlockAddress(), 0, HigherFlag);
      MIB4.addBlockAddress(MO.getBlockAddress(), 0, HighestFlag);
    } else {
      MIB1.addDisp(MO, 0, HiFlag);
      MIB2.addDisp(MO, 0, LoFlag);
      MIB3.addDisp(MO, 0, HigherFlag);
      MIB4.addDisp(MO, 0, HighestFlag);
    }
    break;
  default:
    break;
  }

  MI.eraseFromParent();

  return true;
}

bool LoongArchExpandPseudo::expandPseudoTailCall(
    MachineBasicBlock &BB, MachineBasicBlock::iterator I) {

  MachineInstr &MI = *I;
  DebugLoc DL = MI.getDebugLoc();

  const MachineOperand &MO = MI.getOperand(0);

  unsigned NoFlag = LoongArchII::MO_NO_FLAG;

  MachineInstrBuilder MIB =
      BuildMI(BB, I, DL, TII->get(LoongArch::PseudoTailReturn));

  if (MO.isSymbol()) {
    MIB.addExternalSymbol(MO.getSymbolName(), NoFlag);
  } else {
    MIB.addDisp(MO, 0, NoFlag);
  }

  MI.eraseFromParent();

  return true;
}

bool LoongArchExpandPseudo::expandPseudoCall(MachineBasicBlock &BB,
                                           MachineBasicBlock::iterator I,
                                           MachineBasicBlock::iterator &NMBBI) {
  MachineFunction *MF = BB.getParent();
  MachineInstr &MI = *I;
  DebugLoc DL = MI.getDebugLoc();
  CodeModel::Model M = MF->getTarget().getCodeModel();
  Reloc::Model RM = MF->getTarget().getRelocationModel();

  unsigned Ra = LoongArch::RA_64;
  const MachineOperand &MO = MI.getOperand(0);
  unsigned HiFlag, LoFlag, HigherFlag, HighestFlag, NoFlag;

  HiFlag = LoongArchII::MO_CALL_HI;
  LoFlag = LoongArchII::MO_CALL_LO;
  NoFlag = LoongArchII::MO_NO_FLAG;

  if (RM == Reloc::Static) { // for jit
    MachineInstrBuilder MIB1, MIB2, MIB3, MIB4, MIB5;

    HiFlag = LoongArchII::MO_ABS_HI;
    LoFlag = LoongArchII::MO_ABS_LO;
    HigherFlag = LoongArchII::MO_ABS_HIGHER;
    HighestFlag = LoongArchII::MO_ABS_HIGHEST;
    // lu12i.w + ori + lu32i.d + lu52i.d + jirl

    MIB1 = BuildMI(BB, I, DL, TII->get(LoongArch::LU12I_W), Ra);
    MIB2 = BuildMI(BB, I, DL, TII->get(LoongArch::ORI), Ra)
                  .addReg(Ra);
    MIB3 = BuildMI(BB, I, DL, TII->get(LoongArch::LU32I_D), Ra);
    MIB4 = BuildMI(BB, I, DL, TII->get(LoongArch::LU52I_D), Ra)
                  .addReg(Ra);
    MIB5 =
        BuildMI(BB, I, DL, TII->get(LoongArch::JIRL), Ra).addReg(Ra).addImm(0);
    if (MO.isSymbol()) {
      MIB1.addExternalSymbol(MO.getSymbolName(), HiFlag);
      MIB2.addExternalSymbol(MO.getSymbolName(), LoFlag);
      MIB3.addExternalSymbol(MO.getSymbolName(), HigherFlag);
      MIB4.addExternalSymbol(MO.getSymbolName(), HighestFlag);
    } else {
      MIB1.addDisp(MO, 0, HiFlag);
      MIB2.addDisp(MO, 0, LoFlag);
      MIB3.addDisp(MO, 0, HigherFlag);
      MIB4.addDisp(MO, 0, HighestFlag);
    }
  } else if (M == CodeModel::Large) {
    // pcaddu18i + jirl
    MachineInstrBuilder MIB1;
    MachineInstrBuilder MIB2;

    MIB1 = BuildMI(BB, I, DL, TII->get(LoongArch::PCADDU18I), Ra);
    MIB2 = BuildMI(BB, I, DL, TII->get(LoongArch::JIRL_CALL), Ra).addReg(Ra);
    if (MO.isSymbol()) {
      MIB1.addExternalSymbol(MO.getSymbolName(), HiFlag);
      MIB2.addExternalSymbol(MO.getSymbolName(), LoFlag);
    } else {
      MIB1.addDisp(MO, 0, HiFlag);
      MIB2.addDisp(MO, 0, LoFlag);
    }
  } else {
    // bl
    MachineInstrBuilder MIB1;
    MIB1 = BuildMI(BB, I, DL, TII->get(LoongArch::BL));
    if (MO.isSymbol()) {
      MIB1.addExternalSymbol(MO.getSymbolName(), NoFlag);
    } else {
      MIB1.addDisp(MO, 0, NoFlag);
    }
  }

  MI.eraseFromParent();

  return true;
}

bool LoongArchExpandPseudo::expandPseudoTEQ(MachineBasicBlock &BB,
                                           MachineBasicBlock::iterator I,
                                           MachineBasicBlock::iterator &NMBBI) {
  MachineInstr &MI = *I;
  DebugLoc DL = MI.getDebugLoc();

  unsigned Divisor = MI.getOperand(0).getReg();
  unsigned BneOp = LoongArch::BNE;
  unsigned Zero = LoongArch::ZERO_64;

  // beq $Divisor, $zero, 8
  BuildMI(BB, I, DL, TII->get(BneOp), Divisor)
    .addReg(Zero)
    .addImm(8);
  // break 7
  BuildMI(BB, I, DL, TII->get(LoongArch::BREAK))
    .addImm(7);;

  MI.eraseFromParent();

  return true;
}
bool LoongArchExpandPseudo::expandMI(MachineBasicBlock &MBB,
                                MachineBasicBlock::iterator MBBI,
                                MachineBasicBlock::iterator &NMBB) {

  bool Modified = false;

  switch (MBBI->getOpcode()) {
  case LoongArch::PseudoTEQ:
    return expandPseudoTEQ(MBB, MBBI, NMBB);
  case LoongArch::PseudoCall:
    return expandPseudoCall(MBB, MBBI, NMBB);
  case LoongArch::PseudoTailCall:
    return expandPseudoTailCall(MBB, MBBI);
  case LoongArch::LoadAddrLocal:
  case LoongArch::LoadAddrLocalRR:
  case LoongArch::LoadAddrGlobal:
  case LoongArch::LoadAddrGlobalRR:
  case LoongArch::LoadAddrGlobal_Alias:
  case LoongArch::LoadAddrTLS_LD:
  case LoongArch::LoadAddrTLS_LD_RR:
  case LoongArch::LoadAddrTLS_GD:
  case LoongArch::LoadAddrTLS_GD_RR:
  case LoongArch::LoadAddrTLS_IE:
  case LoongArch::LoadAddrTLS_IE_RR:
  case LoongArch::LoadAddrTLS_LE:
    return expandLoadAddr(MBB, MBBI, NMBB);
  case LoongArch::ATOMIC_CMP_SWAP_I32_POSTRA:
  case LoongArch::ATOMIC_CMP_SWAP_I64_POSTRA:
    return expandAtomicCmpSwap(MBB, MBBI, NMBB);
  case LoongArch::ATOMIC_CMP_SWAP_I8_POSTRA:
  case LoongArch::ATOMIC_CMP_SWAP_I16_POSTRA:
    return expandAtomicCmpSwapSubword(MBB, MBBI, NMBB);
  case LoongArch::ATOMIC_SWAP_I8_POSTRA:
  case LoongArch::ATOMIC_SWAP_I16_POSTRA:
  case LoongArch::ATOMIC_LOAD_NAND_I8_POSTRA:
  case LoongArch::ATOMIC_LOAD_NAND_I16_POSTRA:
  case LoongArch::ATOMIC_LOAD_ADD_I8_POSTRA:
  case LoongArch::ATOMIC_LOAD_ADD_I16_POSTRA:
  case LoongArch::ATOMIC_LOAD_SUB_I8_POSTRA:
  case LoongArch::ATOMIC_LOAD_SUB_I16_POSTRA:
  case LoongArch::ATOMIC_LOAD_AND_I8_POSTRA:
  case LoongArch::ATOMIC_LOAD_AND_I16_POSTRA:
  case LoongArch::ATOMIC_LOAD_OR_I8_POSTRA:
  case LoongArch::ATOMIC_LOAD_OR_I16_POSTRA:
  case LoongArch::ATOMIC_LOAD_XOR_I8_POSTRA:
  case LoongArch::ATOMIC_LOAD_XOR_I16_POSTRA:
  case LoongArch::ATOMIC_LOAD_MAX_I8_POSTRA:
  case LoongArch::ATOMIC_LOAD_MAX_I16_POSTRA:
  case LoongArch::ATOMIC_LOAD_MIN_I8_POSTRA:
  case LoongArch::ATOMIC_LOAD_MIN_I16_POSTRA:
  case LoongArch::ATOMIC_LOAD_UMAX_I8_POSTRA:
  case LoongArch::ATOMIC_LOAD_UMAX_I16_POSTRA:
  case LoongArch::ATOMIC_LOAD_UMIN_I8_POSTRA:
  case LoongArch::ATOMIC_LOAD_UMIN_I16_POSTRA:
    return expandAtomicBinOpSubword(MBB, MBBI, NMBB);
  case LoongArch::XINSERT_B_VIDX_PSEUDO_POSTRA:
  case LoongArch::XINSERT_B_VIDX64_PSEUDO_POSTRA:
    return expandXINSERT_BOp(MBB, MBBI, NMBB);
  case LoongArch::INSERT_H_VIDX64_PSEUDO_POSTRA:
    return expandINSERT_HOp(MBB, MBBI, NMBB);
  case LoongArch::XINSERT_FW_VIDX_PSEUDO_POSTRA:
  case LoongArch::XINSERT_FW_VIDX64_PSEUDO_POSTRA:
    return expandXINSERT_FWOp(MBB, MBBI, NMBB);
  case LoongArch::ATOMIC_LOAD_ADD_I32_POSTRA:
  case LoongArch::ATOMIC_LOAD_SUB_I32_POSTRA:
  case LoongArch::ATOMIC_LOAD_AND_I32_POSTRA:
  case LoongArch::ATOMIC_LOAD_OR_I32_POSTRA:
  case LoongArch::ATOMIC_LOAD_XOR_I32_POSTRA:
  case LoongArch::ATOMIC_LOAD_NAND_I32_POSTRA:
  case LoongArch::ATOMIC_SWAP_I32_POSTRA:
  case LoongArch::ATOMIC_LOAD_MAX_I32_POSTRA:
  case LoongArch::ATOMIC_LOAD_MIN_I32_POSTRA:
  case LoongArch::ATOMIC_LOAD_UMAX_I32_POSTRA:
  case LoongArch::ATOMIC_LOAD_UMIN_I32_POSTRA:
    return expandAtomicBinOp(MBB, MBBI, NMBB, 4);
  case LoongArch::ATOMIC_LOAD_ADD_I64_POSTRA:
  case LoongArch::ATOMIC_LOAD_SUB_I64_POSTRA:
  case LoongArch::ATOMIC_LOAD_AND_I64_POSTRA:
  case LoongArch::ATOMIC_LOAD_OR_I64_POSTRA:
  case LoongArch::ATOMIC_LOAD_XOR_I64_POSTRA:
  case LoongArch::ATOMIC_LOAD_NAND_I64_POSTRA:
  case LoongArch::ATOMIC_SWAP_I64_POSTRA:
  case LoongArch::ATOMIC_LOAD_MAX_I64_POSTRA:
  case LoongArch::ATOMIC_LOAD_MIN_I64_POSTRA:
  case LoongArch::ATOMIC_LOAD_UMAX_I64_POSTRA:
  case LoongArch::ATOMIC_LOAD_UMIN_I64_POSTRA:
    return expandAtomicBinOp(MBB, MBBI, NMBB, 8);
  default:
    return Modified;
  }
}

bool LoongArchExpandPseudo::expandMBB(MachineBasicBlock &MBB) {
  bool Modified = false;

  MachineBasicBlock::iterator MBBI = MBB.begin(), E = MBB.end();
  while (MBBI != E) {
    MachineBasicBlock::iterator NMBBI = std::next(MBBI);
    Modified |= expandMI(MBB, MBBI, NMBBI);
    MBBI = NMBBI;
  }

  return Modified;
}

bool LoongArchExpandPseudo::runOnMachineFunction(MachineFunction &MF) {
  STI = &static_cast<const LoongArchSubtarget &>(MF.getSubtarget());
  TII = STI->getInstrInfo();

  bool Modified = false;
  for (MachineFunction::iterator MFI = MF.begin(), E = MF.end(); MFI != E;
       ++MFI)
    Modified |= expandMBB(*MFI);

  if (Modified)
    MF.RenumberBlocks();

  return Modified;
}

/// createLoongArchExpandPseudoPass - returns an instance of the pseudo instruction
/// expansion pass.
FunctionPass *llvm::createLoongArchExpandPseudoPass() {
  return new LoongArchExpandPseudo();
}
