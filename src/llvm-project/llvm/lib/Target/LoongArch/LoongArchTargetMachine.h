//===- LoongArchTargetMachine.h - Define TargetMachine for LoongArch ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the LoongArch specific subclass of TargetMachine.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHTARGETMACHINE_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHTARGETMACHINE_H

#include "MCTargetDesc/LoongArchABIInfo.h"
#include "LoongArchSubtarget.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Target/TargetMachine.h"
#include <memory>

namespace llvm {

class LoongArchTargetMachine : public LLVMTargetMachine {
  std::unique_ptr<TargetLoweringObjectFile> TLOF;
  // Selected ABI
  LoongArchABIInfo ABI;

  mutable StringMap<std::unique_ptr<LoongArchSubtarget>> SubtargetMap;

public:
  LoongArchTargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                    StringRef FS, const TargetOptions &Options,
                    Optional<Reloc::Model> RM, Optional<CodeModel::Model> CM,
                    CodeGenOpt::Level OL, bool JIT);
  ~LoongArchTargetMachine() override;

  TargetTransformInfo getTargetTransformInfo(const Function &F) override;
  const LoongArchSubtarget *getSubtargetImpl(const Function &F) const override;

  // Pass Pipeline Configuration
  TargetPassConfig *createPassConfig(PassManagerBase &PM) override;

  TargetLoweringObjectFile *getObjFileLowering() const override {
    return TLOF.get();
  }

  /// Returns true if a cast between SrcAS and DestAS is a noop.
  bool isNoopAddrSpaceCast(unsigned SrcAS, unsigned DestAS) const override {
    // Mips doesn't have any special address spaces so we just reserve
    // the first 256 for software use (e.g. OpenCL) and treat casts
    // between them as noops.
    return SrcAS < 256 && DestAS < 256;
  }

  const LoongArchABIInfo &getABI() const { return ABI; }

  bool isMachineVerifierClean() const override {
    return false;
  }
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_LOONGARCH_LOONGARCHTARGETMACHINE_H
