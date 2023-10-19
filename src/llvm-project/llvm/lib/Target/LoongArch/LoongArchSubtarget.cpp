//===-- LoongArchSubtarget.cpp - LoongArch Subtarget Information --------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the LoongArch specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#include "LoongArchSubtarget.h"
#include "LoongArch.h"
#include "LoongArchMachineFunction.h"
#include "LoongArchRegisterInfo.h"
#include "LoongArchTargetMachine.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "loongarch-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "LoongArchGenSubtargetInfo.inc"

void LoongArchSubtarget::anchor() {}

LoongArchSubtarget::LoongArchSubtarget(const Triple &TT, StringRef CPU,
                                       StringRef FS,
                                       const LoongArchTargetMachine &TM,
                                       MaybeAlign StackAlignOverride)
    : LoongArchGenSubtargetInfo(TT, CPU, /*TuneCPU*/ CPU, FS), HasLA64(false),
      IsSoftFloat(false), IsSingleFloat(false), IsFP64bit(false), HasLSX(false),
      HasLASX(false), UnalignedAccess(false),
      StackAlignOverride(StackAlignOverride), TM(TM), TargetTriple(TT),
      TSInfo(), InstrInfo(initializeSubtargetDependencies(CPU, FS, TM)),
      FrameLowering(*this), TLInfo(TM, *this) {

  // Check if Architecture and ABI are compatible.
  assert(((!is64Bit() && isABI_LP32()) ||
          (is64Bit() && (isABI_LPX32() || isABI_LP64()))) &&
         "Invalid  Arch & ABI pair.");

  if (hasLSX() && !isFP64bit())
    report_fatal_error("LSX requires 64-bit floating point register."
                       "See -mattr=+fp64.",
                       false);

  assert(isFP64bit());
}

bool LoongArchSubtarget::isPositionIndependent() const {
  return TM.isPositionIndependent();
}

/// This overrides the PostRAScheduler bit in the SchedModel for any CPU.
bool LoongArchSubtarget::enablePostRAScheduler() const { return true; }

void LoongArchSubtarget::getCriticalPathRCs(RegClassVector &CriticalPathRCs) const {
  CriticalPathRCs.clear();
  CriticalPathRCs.push_back(is64Bit() ? &LoongArch::GPR64RegClass
                                        : &LoongArch::GPR32RegClass);
}

CodeGenOpt::Level LoongArchSubtarget::getOptLevelToEnablePostRAScheduler() const {
  return CodeGenOpt::Aggressive;
}

LoongArchSubtarget &
LoongArchSubtarget::initializeSubtargetDependencies(StringRef CPU, StringRef FS,
                                               const TargetMachine &TM) {
  StringRef CPUName = LoongArch_MC::selectLoongArchCPU(TM.getTargetTriple(), CPU);

  // Parse features string.
  ParseSubtargetFeatures(CPUName, /*TuneCPU*/ CPUName, FS);
  // Initialize scheduling itinerary for the specified CPU.
  InstrItins = getInstrItineraryForCPU(CPUName);

  if (StackAlignOverride)
    stackAlignment = *StackAlignOverride;
  else if (isABI_LPX32() || isABI_LP64())
    stackAlignment = Align(16);
  else {
    assert(isABI_LP32() && "Unknown ABI for stack alignment!");
    stackAlignment = Align(8);
  }

  return *this;
}

Reloc::Model LoongArchSubtarget::getRelocationModel() const {
  return TM.getRelocationModel();
}

bool LoongArchSubtarget::isABI_LP64() const { return getABI().IsLP64(); }
bool LoongArchSubtarget::isABI_LPX32() const { return getABI().IsLPX32(); }
bool LoongArchSubtarget::isABI_LP32() const { return getABI().IsLP32(); }
const LoongArchABIInfo &LoongArchSubtarget::getABI() const { return TM.getABI(); }
