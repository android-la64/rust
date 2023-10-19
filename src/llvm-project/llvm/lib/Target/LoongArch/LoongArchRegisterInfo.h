//===- LoongArchRegisterInfo.h - LoongArch Register Information Impl ------*- C++ -*-===//
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

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHREGISTERINFO_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHREGISTERINFO_H

#include "LoongArch.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include <cstdint>

#define GET_REGINFO_HEADER
#include "LoongArchGenRegisterInfo.inc"

namespace llvm {

class TargetRegisterClass;

class LoongArchRegisterInfo : public LoongArchGenRegisterInfo {
public:
  enum class LoongArchPtrClass {
    /// The default register class for integer values.
    Default = 0,
    /// The stack pointer only.
    StackPointer = 1,
  };

  LoongArchRegisterInfo();

  /// Get PIC indirect call register
  static unsigned getPICCallReg();

  /// Code Generation virtual methods...
  const TargetRegisterClass *getPointerRegClass(const MachineFunction &MF,
                                                unsigned Kind) const override;

  unsigned getRegPressureLimit(const TargetRegisterClass *RC,
                               MachineFunction &MF) const override;
  const MCPhysReg *getCalleeSavedRegs(const MachineFunction *MF) const override;
  const uint32_t *getCallPreservedMask(const MachineFunction &MF,
                                       CallingConv::ID) const override;
  BitVector getReservedRegs(const MachineFunction &MF) const override;

  bool requiresRegisterScavenging(const MachineFunction &MF) const override;

  bool requiresFrameIndexScavenging(const MachineFunction &MF) const override;

  bool trackLivenessAfterRegAlloc(const MachineFunction &MF) const override;

  /// Stack Frame Processing Methods
  void eliminateFrameIndex(MachineBasicBlock::iterator II,
                           int SPAdj, unsigned FIOperandNum,
                           RegScavenger *RS = nullptr) const override;

  // Stack realignment queries.
  bool canRealignStack(const MachineFunction &MF) const override;

  /// Debug information queries.
  Register getFrameRegister(const MachineFunction &MF) const override;

  /// Return GPR register class.
  const TargetRegisterClass *intRegClass(unsigned Size) const;

private:
  void eliminateFI(MachineBasicBlock::iterator II, unsigned OpNo,
                   int FrameIndex, uint64_t StackSize,
                   int SPAdj, int64_t SPOffset) const;
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_LOONGARCH_LOONGARCHREGISTERINFO_H
