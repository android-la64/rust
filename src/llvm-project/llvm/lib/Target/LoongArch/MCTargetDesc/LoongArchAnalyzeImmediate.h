//===- LoongArchAnalyzeImmediate.h - Analyze Immediates --------*- C++ -*--===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHANALYZEIMMEDIATE_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHANALYZEIMMEDIATE_H

#include "llvm/ADT/SmallVector.h"

namespace llvm {
namespace LoongArchAnalyzeImmediate {
struct Inst {
  unsigned Opc;
  int64_t Imm;
  Inst(unsigned Opc, int64_t Imm) : Opc(Opc), Imm(Imm) {}
};
using InstSeq = SmallVector<Inst, 4>;

// Helper to generate an instruction sequence that will materialise the given
// immediate value into a register.
InstSeq generateInstSeq(int64_t Val, bool Is64Bit);
} // end namespace LoongArchAnalyzeImmediate
} // end namespace llvm

#endif // LLVM_LIB_TARGET_LOONGARCH_LOONGARCHANALYZEIMMEDIATE_H
