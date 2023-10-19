//===-- LoongArchFrameLowering.cpp - LoongArch Frame Information --------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the LoongArch implementation of TargetFrameLowering class.
//
//===----------------------------------------------------------------------===//

#include "LoongArchFrameLowering.h"
#include "MCTargetDesc/LoongArchBaseInfo.h"
#include "MCTargetDesc/LoongArchABIInfo.h"
#include "LoongArchInstrInfo.h"
#include "LoongArchMachineFunction.h"
#include "LoongArchTargetMachine.h"
#include "LoongArchRegisterInfo.h"
#include "LoongArchSubtarget.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/Function.h"
#include "llvm/MC/MCDwarf.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MachineLocation.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Target/TargetOptions.h"
#include <cassert>
#include <cstdint>
#include <utility>
#include <vector>

using namespace llvm;

// We would like to split the SP adjustment to reduce prologue/epilogue
// as following instructions. In this way, the offset of the callee saved
// register could fit in a single store.
uint64_t
LoongArchFrameLowering::getFirstSPAdjustAmount(const MachineFunction &MF,
                                               bool IsPrologue) const {
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const std::vector<CalleeSavedInfo> &CSI = MFI.getCalleeSavedInfo();
  uint64_t StackSize = MFI.getStackSize();

  // Return the FirstSPAdjustAmount if the StackSize can not fit in signed
  // 12-bit and there exists a callee saved register need to be pushed.
  if (!isInt<12>(StackSize)) {
    // FirstSPAdjustAmount is choosed as (2048 - StackAlign)
    // because 2048 will cause sp = sp + 2048 in epilogue split into
    // multi-instructions. The offset smaller than 2048 can fit in signle
    // load/store instruction and we have to stick with the stack alignment.
    return CSI.size() > 0 ? 2048 - getStackAlign().value()
                          : (IsPrologue ? 2048 : 0);
  }
  return 0;
}

//===----------------------------------------------------------------------===//
//
// Stack Frame Processing methods
// +----------------------------+
//
// The stack is allocated decrementing the stack pointer on
// the first instruction of a function prologue. Once decremented,
// all stack references are done thought a positive offset
// from the stack/frame pointer, so the stack is considering
// to grow up! Otherwise terrible hacks would have to be made
// to get this stack ABI compliant :)
//
//  The stack frame required by the ABI (after call):
//  Offset
//
//  0                 ----------
//  4                 Args to pass
//  .                 Alloca allocations
//  .                 Local Area
//  .                 CPU "Callee Saved" Registers
//  .                 saved FP
//  .                 saved RA
//  .                 FPU "Callee Saved" Registers
//  StackSize         -----------
//
// Offset - offset from sp after stack allocation on function prologue
//
// The sp is the stack pointer subtracted/added from the stack size
// at the Prologue/Epilogue
//
// References to the previous stack (to obtain arguments) are done
// with offsets that exceeds the stack size: (stacksize+(4*(num_arg-1))
//
// Examples:
// - reference to the actual stack frame
//   for any local area var there is smt like : FI >= 0, StackOffset: 4
//     st.w REGX, SP, 4
//
// - reference to previous stack frame
//   suppose there's a load to the 5th arguments : FI < 0, StackOffset: 16.
//   The emitted instruction will be something like:
//     ld.w REGX, SP, 16+StackSize
//
// Since the total stack size is unknown on LowerFormalArguments, all
// stack references (ObjectOffset) created to reference the function
// arguments, are negative numbers. This way, on eliminateFrameIndex it's
// possible to detect those references and the offsets are adjusted to
// their real location.
//
//===----------------------------------------------------------------------===//
//
LoongArchFrameLowering::LoongArchFrameLowering(const LoongArchSubtarget &STI)
      : TargetFrameLowering(StackGrowsDown, STI.getStackAlignment(), 0,
                                    STI.getStackAlignment()), STI(STI) {}

void LoongArchFrameLowering::emitPrologue(MachineFunction &MF,
                                          MachineBasicBlock &MBB) const {
  MachineFrameInfo &MFI = MF.getFrameInfo();
  LoongArchFunctionInfo *LoongArchFI = MF.getInfo<LoongArchFunctionInfo>();

  const LoongArchInstrInfo &TII =
      *static_cast<const LoongArchInstrInfo *>(STI.getInstrInfo());
  const LoongArchRegisterInfo &RegInfo =
      *static_cast<const LoongArchRegisterInfo *>(STI.getRegisterInfo());
  MachineBasicBlock::iterator MBBI = MBB.begin();
  DebugLoc dl;
  LoongArchABIInfo ABI = STI.getABI();
  unsigned SP = ABI.GetStackPtr();
  unsigned FP = ABI.GetFramePtr();
  unsigned ZERO = ABI.GetNullPtr();
  unsigned MOVE = ABI.GetGPRMoveOp();
  unsigned ADDI = ABI.GetPtrAddiOp();
  unsigned AND = ABI.IsLP64() ? LoongArch::AND : LoongArch::AND32;
  unsigned SLLI = ABI.IsLP64() ? LoongArch::SLLI_D : LoongArch::SLLI_W;

  const TargetRegisterClass *RC = ABI.ArePtrs64bit() ?
        &LoongArch::GPR64RegClass : &LoongArch::GPR32RegClass;

  // First, compute final stack size.
  uint64_t StackSize = MFI.getStackSize();
  uint64_t RealStackSize = StackSize;

  // No need to allocate space on the stack.
  if (StackSize == 0 && !MFI.adjustsStack())
    return;

  uint64_t FirstSPAdjustAmount = getFirstSPAdjustAmount(MF, true);
  uint64_t SecondSPAdjustAmount = RealStackSize - FirstSPAdjustAmount;
  // Split the SP adjustment to reduce the offsets of callee saved spill.
  if (FirstSPAdjustAmount)
    StackSize = FirstSPAdjustAmount;

  // Adjust stack.
  TII.adjustReg(SP, SP, -StackSize, MBB, MBBI, MachineInstr::FrameSetup);
  if (FirstSPAdjustAmount != 2048 || SecondSPAdjustAmount == 0) {
    // Emit ".cfi_def_cfa_offset StackSize".
    unsigned CFIIndex =
        MF.addFrameInst(MCCFIInstruction::cfiDefCfaOffset(nullptr, StackSize));
    BuildMI(MBB, MBBI, dl, TII.get(TargetOpcode::CFI_INSTRUCTION))
        .addCFIIndex(CFIIndex);
  }

  MachineModuleInfo &MMI = MF.getMMI();
  const MCRegisterInfo *MRI = MMI.getContext().getRegisterInfo();

  const std::vector<CalleeSavedInfo> &CSI = MFI.getCalleeSavedInfo();

  if (!CSI.empty()) {
    // Find the instruction past the last instruction that saves a callee-saved
    // register to the stack.
    for (unsigned i = 0; i < CSI.size(); ++i)
      ++MBBI;

    // Iterate over list of callee-saved registers and emit .cfi_offset
    // directives.
    for (std::vector<CalleeSavedInfo>::const_iterator I = CSI.begin(),
           E = CSI.end(); I != E; ++I) {
      int64_t Offset = MFI.getObjectOffset(I->getFrameIdx());
      unsigned Reg = I->getReg();
      unsigned CFIIndex = MF.addFrameInst(MCCFIInstruction::createOffset(
          nullptr, MRI->getDwarfRegNum(Reg, true), Offset));
      BuildMI(MBB, MBBI, dl, TII.get(TargetOpcode::CFI_INSTRUCTION))
          .addCFIIndex(CFIIndex);
    }
  }

  if (LoongArchFI->callsEhReturn()) {
    // Insert instructions that spill eh data registers.
    for (int I = 0; I < 4; ++I) {
      if (!MBB.isLiveIn(ABI.GetEhDataReg(I)))
        MBB.addLiveIn(ABI.GetEhDataReg(I));
      TII.storeRegToStackSlot(MBB, MBBI, ABI.GetEhDataReg(I), false,
                              LoongArchFI->getEhDataRegFI(I), RC, &RegInfo);
    }

    // Emit .cfi_offset directives for eh data registers.
    for (int I = 0; I < 4; ++I) {
      int64_t Offset = MFI.getObjectOffset(LoongArchFI->getEhDataRegFI(I));
      unsigned Reg = MRI->getDwarfRegNum(ABI.GetEhDataReg(I), true);
      unsigned CFIIndex = MF.addFrameInst(
          MCCFIInstruction::createOffset(nullptr, Reg, Offset));
      BuildMI(MBB, MBBI, dl, TII.get(TargetOpcode::CFI_INSTRUCTION))
          .addCFIIndex(CFIIndex);
    }
  }

  // If framepointer enabled, set it to point to the stack pointer on entry.
  if (hasFP(MF)) {
    // Insert instruction "addi.w/d $fp, $sp, StackSize" at this location.
    TII.adjustReg(FP, SP, StackSize - LoongArchFI->getVarArgsSaveSize(), MBB,
                  MBBI, MachineInstr::FrameSetup);
    // Emit ".cfi_def_cfa $fp, $varargs_size".
    unsigned CFIIndex = MF.addFrameInst(
        MCCFIInstruction::cfiDefCfa(nullptr, MRI->getDwarfRegNum(FP, true),
                                    LoongArchFI->getVarArgsSaveSize()));
    BuildMI(MBB, MBBI, dl, TII.get(TargetOpcode::CFI_INSTRUCTION))
        .addCFIIndex(CFIIndex)
        .setMIFlag(MachineInstr::FrameSetup);
  }

  // Emit the second SP adjustment after saving callee saved registers.
  if (FirstSPAdjustAmount && SecondSPAdjustAmount) {
    if (hasFP(MF)) {
      assert(SecondSPAdjustAmount > 0 &&
             "SecondSPAdjustAmount should be greater than zero");
      TII.adjustReg(SP, SP, -SecondSPAdjustAmount, MBB, MBBI,
                    MachineInstr::FrameSetup);
    } else {
      // FIXME: RegScavenger will place the spill instruction before the
      // prologue if a VReg is created in the prologue. This will pollute the
      // caller's stack data. Therefore, until there is better way, we just use
      // the `addi.w/d` instruction for stack adjustment to ensure that VReg
      // will not be created.
      for (int Val = SecondSPAdjustAmount; Val > 0; Val -= 2048)
        BuildMI(MBB, MBBI, dl, TII.get(ADDI), SP)
            .addReg(SP)
            .addImm(Val < 2048 ? -Val : -2048)
            .setMIFlag(MachineInstr::FrameSetup);
      // If we are using a frame-pointer, and thus emitted ".cfi_def_cfa fp, 0",
      // don't emit an sp-based .cfi_def_cfa_offset.
      // Emit ".cfi_def_cfa_offset StackSize"
      unsigned CFIIndex = MF.addFrameInst(
          MCCFIInstruction::cfiDefCfaOffset(nullptr, MFI.getStackSize()));
      BuildMI(MBB, MBBI, dl, TII.get(TargetOpcode::CFI_INSTRUCTION))
          .addCFIIndex(CFIIndex)
          .setMIFlag(MachineInstr::FrameSetup);
    }
  }

  // Realign stack.
  if (hasFP(MF)) {
    if (RegInfo.hasStackRealignment(MF)) {
      // addiu $Reg, $zero, -MaxAlignment
      // andi $sp, $sp, $Reg
      unsigned VR = MF.getRegInfo().createVirtualRegister(RC);
      assert((Log2(MFI.getMaxAlign()) < 16) &&
             "Function's alignment size requirement is not supported.");
      int MaxAlign = -(int)MFI.getMaxAlign().value();
      int Alignment = (int)MFI.getMaxAlign().value();

      if (Alignment <= 2048) {
        BuildMI(MBB, MBBI, dl, TII.get(ADDI), VR).addReg(ZERO).addImm(MaxAlign);
        BuildMI(MBB, MBBI, dl, TII.get(AND), SP).addReg(SP).addReg(VR);
      } else {
        const unsigned NrBitsToZero = countTrailingZeros((unsigned)Alignment);
        BuildMI(MBB, MBBI, dl, TII.get(ADDI), VR).addReg(ZERO).addImm(-1);
        BuildMI(MBB, MBBI, dl, TII.get(SLLI), VR)
            .addReg(VR)
            .addImm(NrBitsToZero);
        BuildMI(MBB, MBBI, dl, TII.get(AND), SP).addReg(SP).addReg(VR);
      }

      if (hasBP(MF)) {
        // move $s7, $sp
        unsigned BP = STI.isABI_LP64() ? LoongArch::S7_64 : LoongArch::S7;
        BuildMI(MBB, MBBI, dl, TII.get(MOVE), BP).addReg(SP).addReg(ZERO);
      }
    }
  }
}

void LoongArchFrameLowering::emitEpilogue(MachineFunction &MF,
                                          MachineBasicBlock &MBB) const {
  MachineBasicBlock::iterator MBBI = MBB.getFirstTerminator();
  MachineFrameInfo &MFI            = MF.getFrameInfo();
  LoongArchFunctionInfo *LoongArchFI = MF.getInfo<LoongArchFunctionInfo>();

  const LoongArchInstrInfo &TII =
      *static_cast<const LoongArchInstrInfo *>(STI.getInstrInfo());
  const LoongArchRegisterInfo &RegInfo =
      *static_cast<const LoongArchRegisterInfo *>(STI.getRegisterInfo());

  DebugLoc DL = MBBI != MBB.end() ? MBBI->getDebugLoc() : DebugLoc();
  LoongArchABIInfo ABI = STI.getABI();
  unsigned SP = ABI.GetStackPtr();
  unsigned FP = ABI.GetFramePtr();

  // Get the number of bytes from FrameInfo.
  uint64_t StackSize = MFI.getStackSize();

  // Restore the stack pointer.
  if (hasFP(MF) &&
      (RegInfo.hasStackRealignment(MF) || MFI.hasVarSizedObjects())) {
    // Find the first instruction that restores a callee-saved register.
    MachineBasicBlock::iterator I = MBBI;
    for (unsigned i = 0; i < MFI.getCalleeSavedInfo().size(); ++i)
      --I;
    TII.adjustReg(SP, FP, -(StackSize - LoongArchFI->getVarArgsSaveSize()), MBB,
                  I);
  }

  uint64_t FirstSPAdjustAmount = getFirstSPAdjustAmount(MF);
  if (FirstSPAdjustAmount) {
    uint64_t SecondSPAdjustAmount = MFI.getStackSize() - FirstSPAdjustAmount;
    assert(SecondSPAdjustAmount > 0 &&
           "SecondSPAdjustAmount should be greater than zero");
    // Find the first instruction that restores a callee-saved register.
    MachineBasicBlock::iterator I = MBBI;
    for (unsigned i = 0; i < MFI.getCalleeSavedInfo().size(); ++i)
      --I;

    TII.adjustReg(SP, SP, SecondSPAdjustAmount, MBB, I);
  }

  if (LoongArchFI->callsEhReturn()) {
    const TargetRegisterClass *RC =
        ABI.ArePtrs64bit() ? &LoongArch::GPR64RegClass : &LoongArch::GPR32RegClass;

    // Find first instruction that restores a callee-saved register.
    MachineBasicBlock::iterator I = MBBI;
    for (unsigned i = 0; i < MFI.getCalleeSavedInfo().size(); ++i)
      --I;

    // Insert instructions that restore eh data registers.
    for (int J = 0; J < 4; ++J)
      TII.loadRegFromStackSlot(MBB, I, ABI.GetEhDataReg(J),
                               LoongArchFI->getEhDataRegFI(J), RC, &RegInfo);
  }

  if (FirstSPAdjustAmount)
    StackSize = FirstSPAdjustAmount;

  if (!StackSize)
    return;

  // Final adjust stack.
  TII.adjustReg(SP, SP, StackSize, MBB, MBBI);
}

StackOffset
LoongArchFrameLowering::getFrameIndexReference(const MachineFunction &MF,
                                               int FI,
                                               Register &FrameReg) const {
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const TargetRegisterInfo *RI = MF.getSubtarget().getRegisterInfo();
  LoongArchABIInfo ABI = STI.getABI();
  const auto *LoongArchFI = MF.getInfo<LoongArchFunctionInfo>();

  // Callee-saved registers should be referenced relative to the stack
  // pointer (positive offset), otherwise use the frame pointer (negative
  // offset).
  const auto &CSI = MFI.getCalleeSavedInfo();
  int MinCSFI = 0;
  int MaxCSFI = -1;
  StackOffset Offset =
      StackOffset::getFixed(MFI.getObjectOffset(FI) - getOffsetOfLocalArea() +
                            MFI.getOffsetAdjustment());
  uint64_t FirstSPAdjustAmount = getFirstSPAdjustAmount(MF);

  if (CSI.size()) {
    MinCSFI = CSI[0].getFrameIdx();
    MaxCSFI = CSI[CSI.size() - 1].getFrameIdx();
  }

  bool EhDataRegFI = LoongArchFI->isEhDataRegFI(FI);
  if ((FI >= MinCSFI && FI <= MaxCSFI) || EhDataRegFI) {
    FrameReg = ABI.GetStackPtr();

    if (FirstSPAdjustAmount)
      Offset += StackOffset::getFixed(FirstSPAdjustAmount);
    else
      Offset += StackOffset::getFixed(MFI.getStackSize());
  } else if (RI->hasStackRealignment(MF) && !MFI.isFixedObjectIndex(FI)) {
    // If the stack was realigned, the frame pointer is set in order to allow
    // SP to be restored, so we need another base register to record the stack
    // after realignment.
    FrameReg = hasBP(MF) ? ABI.GetBasePtr() : ABI.GetStackPtr();
    Offset += StackOffset::getFixed(MFI.getStackSize());
  } else {
    FrameReg = RI->getFrameRegister(MF);
    if (hasFP(MF))
      Offset += StackOffset::getFixed(LoongArchFI->getVarArgsSaveSize());
    else
      Offset += StackOffset::getFixed(MFI.getStackSize());
  }
  return Offset;
}

bool LoongArchFrameLowering::spillCalleeSavedRegisters(
    MachineBasicBlock &MBB, MachineBasicBlock::iterator MI,
    ArrayRef<CalleeSavedInfo> CSI, const TargetRegisterInfo *TRI) const {
  MachineFunction *MF = MBB.getParent();
  const TargetInstrInfo &TII = *STI.getInstrInfo();

  for (unsigned i = 0, e = CSI.size(); i != e; ++i) {
    // Add the callee-saved register as live-in. Do not add if the register is
    // RA and return address is taken, because it has already been added in
    // method LoongArchTargetLowering::lowerRETURNADDR.
    // It's killed at the spill, unless the register is RA and return address
    // is taken.
    unsigned Reg = CSI[i].getReg();
    bool IsRAAndRetAddrIsTaken = (Reg == LoongArch::RA || Reg == LoongArch::RA_64)
        && MF->getFrameInfo().isReturnAddressTaken();
    if (!IsRAAndRetAddrIsTaken)
      MBB.addLiveIn(Reg);

    // Insert the spill to the stack frame.
    bool IsKill = !IsRAAndRetAddrIsTaken;
    const TargetRegisterClass *RC = TRI->getMinimalPhysRegClass(Reg);
    TII.storeRegToStackSlot(MBB, MI, Reg, IsKill,
                            CSI[i].getFrameIdx(), RC, TRI);
  }

  return true;
}

bool
LoongArchFrameLowering::hasReservedCallFrame(const MachineFunction &MF) const {
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  // Reserve call frame if the size of the maximum call frame fits into 12-bit
  // immediate field and there are no variable sized objects on the stack.
  // Make sure the second register scavenger spill slot can be accessed with one
  // instruction.
  return isInt<12>(MFI.getMaxCallFrameSize() + getStackAlignment()) &&
    !MFI.hasVarSizedObjects();
}

/// Mark \p Reg and all registers aliasing it in the bitset.
static void setAliasRegs(MachineFunction &MF, BitVector &SavedRegs,
                         unsigned Reg) {
  const TargetRegisterInfo *TRI = MF.getSubtarget().getRegisterInfo();
  for (MCRegAliasIterator AI(Reg, TRI, true); AI.isValid(); ++AI)
    SavedRegs.set(*AI);
}

void LoongArchFrameLowering::determineCalleeSaves(MachineFunction &MF,
                                                  BitVector &SavedRegs,
                                                  RegScavenger *RS) const {
  TargetFrameLowering::determineCalleeSaves(MF, SavedRegs, RS);
  const TargetRegisterInfo *TRI = MF.getSubtarget().getRegisterInfo();
  LoongArchFunctionInfo *LoongArchFI = MF.getInfo<LoongArchFunctionInfo>();
  LoongArchABIInfo ABI = STI.getABI();
  unsigned FP = ABI.GetFramePtr();
  unsigned BP = ABI.IsLP64() ? LoongArch::S7_64 : LoongArch::S7;

  // Mark $fp as used if function has dedicated frame pointer.
  if (hasFP(MF))
    setAliasRegs(MF, SavedRegs, FP);
  // Mark $s7 as used if function has dedicated base pointer.
  if (hasBP(MF))
    setAliasRegs(MF, SavedRegs, BP);

  // Create spill slots for eh data registers if function calls eh_return.
  if (LoongArchFI->callsEhReturn())
    LoongArchFI->createEhDataRegsFI();

  // Set scavenging frame index if necessary.
  uint64_t MaxSPOffset = estimateStackSize(MF);

  // If there is a variable
  // sized object on the stack, the estimation cannot account for it.
  if (isIntN(12, MaxSPOffset) &&
      !MF.getFrameInfo().hasVarSizedObjects())
    return;

  const TargetRegisterClass &RC =
      ABI.ArePtrs64bit() ? LoongArch::GPR64RegClass : LoongArch::GPR32RegClass;
  int FI = MF.getFrameInfo().CreateStackObject(TRI->getSpillSize(RC),
                                               TRI->getSpillAlign(RC), false);
  RS->addScavengingFrameIndex(FI);
}

// hasFP - Return true if the specified function should have a dedicated frame
// pointer register.  This is true if the function has variable sized allocas,
// if it needs dynamic stack realignment, if frame pointer elimination is
// disabled, or if the frame address is taken.
bool LoongArchFrameLowering::hasFP(const MachineFunction &MF) const {
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const TargetRegisterInfo *TRI = STI.getRegisterInfo();

  return MF.getTarget().Options.DisableFramePointerElim(MF) ||
      MFI.hasVarSizedObjects() || MFI.isFrameAddressTaken() ||
      TRI->hasStackRealignment(MF);
}

bool LoongArchFrameLowering::hasBP(const MachineFunction &MF) const {
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const TargetRegisterInfo *TRI = STI.getRegisterInfo();

  return MFI.hasVarSizedObjects() && TRI->hasStackRealignment(MF);
}

// Estimate the size of the stack, including the incoming arguments. We need to
// account for register spills, local objects, reserved call frame and incoming
// arguments. This is required to determine the largest possible positive offset
// from $sp so that it can be determined if an emergency spill slot for stack
// addresses is required.
uint64_t LoongArchFrameLowering::
estimateStackSize(const MachineFunction &MF) const {
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const TargetRegisterInfo &TRI = *STI.getRegisterInfo();

  int64_t Size = 0;

  // Iterate over fixed sized objects which are incoming arguments.
  for (int I = MFI.getObjectIndexBegin(); I != 0; ++I)
    if (MFI.getObjectOffset(I) > 0)
      Size += MFI.getObjectSize(I);

  // Conservatively assume all callee-saved registers will be saved.
  for (const MCPhysReg *R = TRI.getCalleeSavedRegs(&MF); *R; ++R) {
    unsigned RegSize = TRI.getSpillSize(*TRI.getMinimalPhysRegClass(*R));
    Size = alignTo(Size + RegSize, RegSize);
  }

  // Get the size of the rest of the frame objects and any possible reserved
  // call frame, accounting for alignment.
  return Size + MFI.estimateStackSize(MF);
}

// Eliminate ADJCALLSTACKDOWN, ADJCALLSTACKUP pseudo instructions
MachineBasicBlock::iterator LoongArchFrameLowering::
eliminateCallFramePseudoInstr(MachineFunction &MF, MachineBasicBlock &MBB,
                              MachineBasicBlock::iterator I) const {
  unsigned SP = STI.getABI().IsLP64() ? LoongArch::SP_64 : LoongArch::SP;

  if (!hasReservedCallFrame(MF)) {
    int64_t Amount = I->getOperand(0).getImm();
    if (I->getOpcode() == LoongArch::ADJCALLSTACKDOWN)
      Amount = -Amount;

    STI.getInstrInfo()->adjustReg(SP, SP, Amount, MBB, I);
  }

  return MBB.erase(I);
}
