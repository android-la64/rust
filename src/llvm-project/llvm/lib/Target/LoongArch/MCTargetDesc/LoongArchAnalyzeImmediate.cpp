//===- LoongArchAnalyzeImmediate.cpp - Analyze Immediates -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "LoongArchAnalyzeImmediate.h"
#include "LoongArch.h"
#include "MCTargetDesc/LoongArchMCTargetDesc.h"
#include "llvm/Support/MathExtras.h"

using namespace llvm;

LoongArchAnalyzeImmediate::InstSeq
LoongArchAnalyzeImmediate::generateInstSeq(int64_t Val, bool Is64Bit) {
  // Val:
  // |             hi32              |              lo32            |
  // +------------+------------------+------------------+-----------+
  // | Bits_52_63 |    Bits_32_51    |    Bits_12_31    | Bits_0_11 |
  // +------------+------------------+------------------+-----------+
  //  63        52 51              32 31              12 11        0
  unsigned ORIOp = Is64Bit ? LoongArch::ORI : LoongArch::ORI32;
  unsigned LU12IOp = Is64Bit ? LoongArch::LU12I_W : LoongArch::LU12I_W32;
  unsigned ADDIOp = Is64Bit ? LoongArch::ADDI_W64 : LoongArch::ADDI_W;
  unsigned LU32IOp = LoongArch::LU32I_D_R2;
  unsigned LU52IOp = LoongArch::LU52I_D;

  int64_t Bits_52_63 = Val >> 52 & 0xFFF;
  int64_t Bits_32_51 = Val >> 32 & 0xFFFFF;
  int64_t Bits_12_31 = Val >> 12 & 0xFFFFF;
  int64_t Bits_0_11 = Val & 0xFFF;

  InstSeq Insts;

  if (isInt<12>(Val) && Is64Bit) {
    Insts.push_back(Inst(LoongArch::ADDI_D, SignExtend64<12>(Bits_0_11)));
    return Insts;
  }

  if (Bits_52_63 != 0 && SignExtend64<52>(Val) == 0) {
    Insts.push_back(Inst(LU52IOp, SignExtend64<12>(Bits_52_63)));
    return Insts;
  }

  if (Bits_12_31 == 0)
    Insts.push_back(Inst(ORIOp, Bits_0_11));
  else if (SignExtend32<1>(Bits_0_11 >> 11) == SignExtend32<20>(Bits_12_31))
    Insts.push_back(Inst(ADDIOp, SignExtend64<12>(Bits_0_11)));
  else {
    Insts.push_back(Inst(LU12IOp, SignExtend64<20>(Bits_12_31)));
    if (Bits_0_11 != 0)
      Insts.push_back(Inst(ORIOp, Bits_0_11));
  }

  if (SignExtend32<1>(Bits_12_31 >> 19) != SignExtend32<20>(Bits_32_51))
    Insts.push_back(Inst(LU32IOp, SignExtend64<20>(Bits_32_51)));

  if (SignExtend32<1>(Bits_32_51 >> 19) != SignExtend32<12>(Bits_52_63))
    Insts.push_back(Inst(LU52IOp, SignExtend64<12>(Bits_52_63)));

  return Insts;
}
