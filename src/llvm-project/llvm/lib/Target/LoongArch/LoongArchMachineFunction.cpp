//===-- LoongArchMachineFunctionInfo.cpp - Private data used for LoongArch ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "LoongArchMachineFunction.h"
#include "MCTargetDesc/LoongArchABIInfo.h"
#include "LoongArchSubtarget.h"
#include "LoongArchTargetMachine.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/PseudoSourceValue.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/Support/CommandLine.h"

using namespace llvm;

LoongArchFunctionInfo::~LoongArchFunctionInfo() = default;

void LoongArchFunctionInfo::createEhDataRegsFI() {
  const TargetRegisterInfo &TRI = *MF.getSubtarget().getRegisterInfo();
  for (int I = 0; I < 4; ++I) {
    const TargetRegisterClass &RC =
        static_cast<const LoongArchTargetMachine &>(MF.getTarget()).getABI().IsLP64()
            ? LoongArch::GPR64RegClass
            : LoongArch::GPR32RegClass;

    EhDataRegFI[I] = MF.getFrameInfo().CreateStackObject(TRI.getSpillSize(RC),
        TRI.getSpillAlign(RC), false);
  }
}

bool LoongArchFunctionInfo::isEhDataRegFI(int FI) const {
  return CallsEhReturn && (FI == EhDataRegFI[0] || FI == EhDataRegFI[1]
                        || FI == EhDataRegFI[2] || FI == EhDataRegFI[3]);
}

MachinePointerInfo LoongArchFunctionInfo::callPtrInfo(const char *ES) {
  return MachinePointerInfo(MF.getPSVManager().getExternalSymbolCallEntry(ES));
}

MachinePointerInfo LoongArchFunctionInfo::callPtrInfo(const GlobalValue *GV) {
  return MachinePointerInfo(MF.getPSVManager().getGlobalValueCallEntry(GV));
}

int LoongArchFunctionInfo::getMoveF64ViaSpillFI(const TargetRegisterClass *RC) {
  const TargetRegisterInfo &TRI = *MF.getSubtarget().getRegisterInfo();
  if (MoveF64ViaSpillFI == -1) {
    MoveF64ViaSpillFI = MF.getFrameInfo().CreateStackObject(
        TRI.getSpillSize(*RC), TRI.getSpillAlign(*RC), false);
  }
  return MoveF64ViaSpillFI;
}

void LoongArchFunctionInfo::anchor() {}
