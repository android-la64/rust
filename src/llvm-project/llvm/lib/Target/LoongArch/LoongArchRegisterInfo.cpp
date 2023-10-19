//===- LoongArchRegisterInfo.cpp - LoongArch Register Information -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the LoongArch implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "LoongArchRegisterInfo.h"
#include "MCTargetDesc/LoongArchABIInfo.h"
#include "LoongArch.h"
#include "LoongArchMachineFunction.h"
#include "LoongArchSubtarget.h"
#include "LoongArchTargetMachine.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include <cstdint>

using namespace llvm;

#define DEBUG_TYPE "loongarch-reg-info"

#define GET_REGINFO_TARGET_DESC
#include "LoongArchGenRegisterInfo.inc"

LoongArchRegisterInfo::LoongArchRegisterInfo() : LoongArchGenRegisterInfo(LoongArch::RA) {}

unsigned LoongArchRegisterInfo::getPICCallReg() { return LoongArch::T8; }

const TargetRegisterClass *
LoongArchRegisterInfo::getPointerRegClass(const MachineFunction &MF,
                                     unsigned Kind) const {
  LoongArchABIInfo ABI = MF.getSubtarget<LoongArchSubtarget>().getABI();
  LoongArchPtrClass PtrClassKind = static_cast<LoongArchPtrClass>(Kind);

  switch (PtrClassKind) {
  case LoongArchPtrClass::Default:
    return ABI.ArePtrs64bit() ? &LoongArch::GPR64RegClass : &LoongArch::GPR32RegClass;
  case LoongArchPtrClass::StackPointer:
    return ABI.ArePtrs64bit() ? &LoongArch::SP64RegClass : &LoongArch::SP32RegClass;
  }

  llvm_unreachable("Unknown pointer kind");
}

unsigned
LoongArchRegisterInfo::getRegPressureLimit(const TargetRegisterClass *RC,
                                      MachineFunction &MF) const {
  switch (RC->getID()) {
  default:
    return 0;
  case LoongArch::GPR32RegClassID:
  case LoongArch::GPR64RegClassID:
  {
    const TargetFrameLowering *TFI = MF.getSubtarget().getFrameLowering();
    return 28 - TFI->hasFP(MF);
  }
  case LoongArch::FGR32RegClassID:
    return 32;
  case LoongArch::FGR64RegClassID:
    return 32;
  }
}

//===----------------------------------------------------------------------===//
// Callee Saved Registers methods
//===----------------------------------------------------------------------===//

/// LoongArch Callee Saved Registers
const MCPhysReg *
LoongArchRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  const LoongArchSubtarget &Subtarget = MF->getSubtarget<LoongArchSubtarget>();

  if (Subtarget.isSingleFloat())
    return CSR_SingleFloatOnly_SaveList;

  if (Subtarget.isABI_LP64())
    return CSR_LP64_SaveList;

  if (Subtarget.isABI_LPX32())
    return CSR_LPX32_SaveList;

  return CSR_LP32_SaveList;
}

const uint32_t *
LoongArchRegisterInfo::getCallPreservedMask(const MachineFunction &MF,
                                       CallingConv::ID) const {
  const LoongArchSubtarget &Subtarget = MF.getSubtarget<LoongArchSubtarget>();

  if (Subtarget.isSingleFloat())
    return CSR_SingleFloatOnly_RegMask;

  if (Subtarget.isABI_LP64())
    return CSR_LP64_RegMask;

  return CSR_LP32_RegMask;
}

BitVector LoongArchRegisterInfo::
getReservedRegs(const MachineFunction &MF) const {
  static const MCPhysReg ReservedGPR32[] = {
    LoongArch::ZERO, LoongArch::SP, LoongArch::TP, LoongArch::T9
  };

  static const MCPhysReg ReservedGPR64[] = {
    LoongArch::ZERO_64, LoongArch::SP_64, LoongArch::TP_64, LoongArch::T9_64
  };

  BitVector Reserved(getNumRegs());
  const LoongArchSubtarget &Subtarget = MF.getSubtarget<LoongArchSubtarget>();

  for (unsigned I = 0; I < array_lengthof(ReservedGPR32); ++I)
    Reserved.set(ReservedGPR32[I]);

  for (unsigned I = 0; I < array_lengthof(ReservedGPR64); ++I)
    Reserved.set(ReservedGPR64[I]);

  // Reserve FP if this function should have a dedicated frame pointer register.
  if (Subtarget.getFrameLowering()->hasFP(MF)) {
    Reserved.set(LoongArch::FP);
    Reserved.set(LoongArch::FP_64);

    // Reserve the base register if we need to both realign the stack and
    // allocate variable-sized objects at runtime. This should test the
    // same conditions as LoongArchFrameLowering::hasBP().
    if (hasStackRealignment(MF) && MF.getFrameInfo().hasVarSizedObjects()) {
      Reserved.set(LoongArch::S7);
      Reserved.set(LoongArch::S7_64);
    }
  }

  return Reserved;
}

bool
LoongArchRegisterInfo::requiresRegisterScavenging(const MachineFunction &MF) const {
  return true;
}

bool LoongArchRegisterInfo::
requiresFrameIndexScavenging(const MachineFunction &MF) const {
  return true;
}

bool
LoongArchRegisterInfo::trackLivenessAfterRegAlloc(const MachineFunction &MF) const {
  return true;
}

/// Get the size of the offset supported by the given load/store/inline asm.
/// The result includes the effects of any scale factors applied to the
/// instruction immediate.
static inline unsigned getLoadStoreOffsetSizeInBits(const unsigned Opcode,
                                                    MachineOperand MO) {
  switch (Opcode) {
  case LoongArch::LDPTR_W:
  case LoongArch::LDPTR_W32:
  case LoongArch::LDPTR_D:
  case LoongArch::STPTR_W:
  case LoongArch::STPTR_W32:
  case LoongArch::STPTR_D:
  case LoongArch::LL_W:
  case LoongArch::LL_D:
  case LoongArch::SC_W:
  case LoongArch::SC_D:
    return 14 + 2 /* scale factor */;
  case LoongArch::INLINEASM: {
    unsigned ConstraintID = InlineAsm::getMemoryConstraintID(MO.getImm());
    switch (ConstraintID) {
    case InlineAsm::Constraint_ZC: {
      return 14 + 2 /* scale factor */;
    }
    default:
      return 12;
    }
  }
  default:
    return 12;
  }
}

/// Get the scale factor applied to the immediate in the given load/store.
static inline unsigned getLoadStoreOffsetAlign(const unsigned Opcode) {
  switch (Opcode) {
  case LoongArch::LDPTR_W:
  case LoongArch::LDPTR_W32:
  case LoongArch::LDPTR_D:
  case LoongArch::STPTR_W:
  case LoongArch::STPTR_W32:
  case LoongArch::STPTR_D:
  case LoongArch::LL_W:
  case LoongArch::LL_D:
  case LoongArch::SC_W:
  case LoongArch::SC_D:
    return 4;
  default:
    return 1;
  }
}

// FrameIndex represent objects inside a abstract stack.
// We must replace FrameIndex with an stack/frame pointer
// direct reference.
void LoongArchRegisterInfo::
eliminateFrameIndex(MachineBasicBlock::iterator II, int SPAdj,
                    unsigned FIOperandNum, RegScavenger *RS) const {
  MachineInstr &MI = *II;
  MachineFunction &MF = *MI.getParent()->getParent();
  const LoongArchFrameLowering *TFI = getFrameLowering(MF);

  LLVM_DEBUG(errs() << "\nFunction : " << MF.getName() << "\n";
             errs() << "<--------->\n"
                    << MI);

  int FrameIndex = MI.getOperand(FIOperandNum).getIndex();
  uint64_t stackSize = MF.getFrameInfo().getStackSize();
  int64_t spOffset = MF.getFrameInfo().getObjectOffset(FrameIndex);

  LLVM_DEBUG(errs() << "FrameIndex : " << FrameIndex << "\n"
                    << "spOffset   : " << spOffset << "\n"
                    << "stackSize  : " << stackSize << "\n"
                    << "SPAdj      : " << SPAdj << "\n"
                    << "alignment  : "
                    << DebugStr(MF.getFrameInfo().getObjectAlign(FrameIndex))
                    << "\n");

  LoongArchABIInfo ABI =
      static_cast<const LoongArchTargetMachine &>(MF.getTarget()).getABI();

  // Everything else is referenced relative to whatever register
  // getFrameIndexReference() returns.
  Register FrameReg;
  StackOffset Offset =
      TFI->getFrameIndexReference(MF, FrameIndex, FrameReg) +
      StackOffset::getFixed(MI.getOperand(FIOperandNum + 1).getImm());

  LLVM_DEBUG(errs() << "Location   : "
                    << "FrameReg<" << FrameReg << "> + " << Offset.getFixed()
                    << "\n<--------->\n");

  MachineBasicBlock &MBB = *MI.getParent();
  DebugLoc DL = II->getDebugLoc();
  bool IsKill = false;

  if (!MI.isDebugValue()) {
    // Make sure Offset fits within the field available.
    // For ldptr/stptr/ll/sc instructions, this is a 14-bit signed immediate
    // (scaled by 2), otherwise it is a 12-bit signed immediate.
    unsigned OffsetBitSize = getLoadStoreOffsetSizeInBits(
        MI.getOpcode(), MI.getOperand(FIOperandNum - 1));
    const Align OffsetAlign(getLoadStoreOffsetAlign(MI.getOpcode()));

    if (OffsetBitSize == 16 && isInt<12>(Offset.getFixed()) &&
        !isAligned(OffsetAlign, Offset.getFixed())) {
      // If we have an offset that needs to fit into a signed n-bit immediate
      // (where n == 16) and doesn't aligned and does fit into 12-bits
      // then use an ADDI
      const TargetRegisterClass *PtrRC = ABI.ArePtrs64bit()
                                             ? &LoongArch::GPR64RegClass
                                             : &LoongArch::GPR32RegClass;
      MachineRegisterInfo &RegInfo = MBB.getParent()->getRegInfo();
      unsigned Reg = RegInfo.createVirtualRegister(PtrRC);
      const LoongArchInstrInfo &TII = *static_cast<const LoongArchInstrInfo *>(
          MBB.getParent()->getSubtarget().getInstrInfo());
      BuildMI(MBB, II, DL, TII.get(ABI.GetPtrAddiOp()), Reg)
          .addReg(FrameReg)
          .addImm(Offset.getFixed());

      FrameReg = Reg;
      Offset = StackOffset::getFixed(0);
      IsKill = true;
    } else if (!isInt<12>(Offset.getFixed())) {
      // Otherwise split the offset into several pieces and add it in multiple
      // instructions.
      const LoongArchInstrInfo &TII = *static_cast<const LoongArchInstrInfo *>(
          MBB.getParent()->getSubtarget().getInstrInfo());
      unsigned Reg = TII.loadImmediate(Offset.getFixed(), MBB, II, DL);
      BuildMI(MBB, II, DL, TII.get(ABI.GetPtrAddOp()), Reg)
          .addReg(FrameReg)
          .addReg(Reg, RegState::Kill);

      FrameReg = Reg;
      Offset = StackOffset::getFixed(0);
      IsKill = true;
    }
  }

  MI.getOperand(FIOperandNum).ChangeToRegister(FrameReg, false, false, IsKill);
  MI.getOperand(FIOperandNum + 1).ChangeToImmediate(Offset.getFixed());
}

Register LoongArchRegisterInfo::
getFrameRegister(const MachineFunction &MF) const {
  const LoongArchSubtarget &Subtarget = MF.getSubtarget<LoongArchSubtarget>();
  const TargetFrameLowering *TFI = Subtarget.getFrameLowering();
  bool IsLP64 =
      static_cast<const LoongArchTargetMachine &>(MF.getTarget()).getABI().IsLP64();

  return TFI->hasFP(MF) ? (IsLP64 ? LoongArch::FP_64 : LoongArch::FP) :
                            (IsLP64 ? LoongArch::SP_64 : LoongArch::SP);
}

const TargetRegisterClass *
LoongArchRegisterInfo::intRegClass(unsigned Size) const {
  if (Size == 4)
    return &LoongArch::GPR32RegClass;

  assert(Size == 8);
  return &LoongArch::GPR64RegClass;
}

bool LoongArchRegisterInfo::canRealignStack(const MachineFunction &MF) const {
  // Avoid realigning functions that explicitly do not want to be realigned.
  // Normally, we should report an error when a function should be dynamically
  // realigned but also has the attribute no-realign-stack. Unfortunately,
  // with this attribute, MachineFrameInfo clamps each new object's alignment
  // to that of the stack's alignment as specified by the ABI. As a result,
  // the information of whether we have objects with larger alignment
  // requirement than the stack's alignment is already lost at this point.
  if (!TargetRegisterInfo::canRealignStack(MF))
    return false;

  const LoongArchSubtarget &Subtarget = MF.getSubtarget<LoongArchSubtarget>();
  unsigned FP = Subtarget.is64Bit() ? LoongArch::FP_64 : LoongArch::FP;
  unsigned BP = Subtarget.is64Bit() ? LoongArch::S7_64 : LoongArch::S7;

  // We can't perform dynamic stack realignment if we can't reserve the
  // frame pointer register.
  if (!MF.getRegInfo().canReserveReg(FP))
    return false;

  // We can realign the stack if we know the maximum call frame size and we
  // don't have variable sized objects.
  if (Subtarget.getFrameLowering()->hasReservedCallFrame(MF))
    return true;

  // We have to reserve the base pointer register in the presence of variable
  // sized objects.
  return MF.getRegInfo().canReserveReg(BP);
}
