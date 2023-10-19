//===-- LoongArchMCTargetDesc.h - LoongArch Target Descriptions -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file provides LoongArch specific target descriptions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHMCTARGETDESC_H
#define LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHMCTARGETDESC_H

#include "llvm/Support/DataTypes.h"

#include <memory>

namespace llvm {
class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCObjectTargetWriter;
class MCRegisterInfo;
class MCSubtargetInfo;
class MCTargetOptions;
class StringRef;
class Target;
class Triple;
class raw_ostream;
class raw_pwrite_stream;

Target &getTheLoongArch32Target();
Target &getTheLoongArch64Target();

MCCodeEmitter *createLoongArchMCCodeEmitter(const MCInstrInfo &MCII,
                                            const MCRegisterInfo &MRI,
                                            MCContext &Ctx);

MCAsmBackend *createLoongArchAsmBackend(const Target &T,
                                        const MCSubtargetInfo &STI,
                                        const MCRegisterInfo &MRI,
                                        const MCTargetOptions &Options);

std::unique_ptr<MCObjectTargetWriter>
createLoongArchELFObjectWriter(const Triple &TT, bool IsLPX32);

namespace LoongArch_MC {
StringRef selectLoongArchCPU(const Triple &TT, StringRef CPU);
}

} // End llvm namespace

// Defines symbolic names for LoongArch registers.  This defines a mapping from
// register name to register number.
#define GET_REGINFO_ENUM
#include "LoongArchGenRegisterInfo.inc"

// Defines symbolic names for the LoongArch instructions.
#define GET_INSTRINFO_ENUM
#include "LoongArchGenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "LoongArchGenSubtargetInfo.inc"

#endif
