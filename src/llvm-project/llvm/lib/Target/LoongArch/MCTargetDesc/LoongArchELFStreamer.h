//===- LoongArchELFStreamer.h - ELF Object Output --------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This is a custom MCELFStreamer which allows us to insert some hooks before
// emitting data into an actual object file.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHELFSTREAMER_H
#define LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHELFSTREAMER_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/MC/MCELFStreamer.h"
#include <memory>

namespace llvm {

class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCSubtargetInfo;
struct MCDwarfFrameInfo;

class LoongArchELFStreamer : public MCELFStreamer {

public:
  LoongArchELFStreamer(MCContext &Context, std::unique_ptr<MCAsmBackend> MAB,
                  std::unique_ptr<MCObjectWriter> OW,
                  std::unique_ptr<MCCodeEmitter> Emitter);

  /// Overriding these functions allows us to dismiss all labels.
  void emitValueImpl(const MCExpr *Value, unsigned Size, SMLoc Loc) override;

  // Overriding these functions allows us to avoid recording of these labels
  // in emitLabel.
  void emitCFIStartProcImpl(MCDwarfFrameInfo &Frame) override;
  void emitCFIEndProcImpl(MCDwarfFrameInfo &Frame) override;
  MCSymbol *emitCFILabel() override;
};

MCELFStreamer *createLoongArchELFStreamer(MCContext &Context,
                                     std::unique_ptr<MCAsmBackend> MAB,
                                     std::unique_ptr<MCObjectWriter> OW,
                                     std::unique_ptr<MCCodeEmitter> Emitter,
                                     bool RelaxAll);
} // end namespace llvm

#endif // LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHELFSTREAMER_H
