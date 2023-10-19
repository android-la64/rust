//===-- LoongArchMCAsmInfo.cpp - LoongArch Asm Properties ---------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the declarations of the LoongArchMCAsmInfo properties.
//
//===----------------------------------------------------------------------===//

#include "LoongArchMCAsmInfo.h"
#include "llvm/ADT/Triple.h"

using namespace llvm;

void LoongArchMCAsmInfo::anchor() { }

LoongArchMCAsmInfo::LoongArchMCAsmInfo(const Triple &TheTriple,
                                       const MCTargetOptions &Options) {

  if (TheTriple.isLoongArch64()
      && TheTriple.getEnvironment() != Triple::GNUABILPX32)
    CodePointerSize = CalleeSaveStackSlotSize = 8;

  AlignmentIsInBytes          = false;
  Data16bitsDirective         = "\t.half\t";
  Data32bitsDirective         = "\t.word\t";
  Data64bitsDirective         = "\t.dword\t";
  CommentString               = "#";
  ZeroDirective               = "\t.space\t";
  SupportsDebugInformation = true;
  ExceptionsType = ExceptionHandling::DwarfCFI;
  DwarfRegNumForCFI = true;
  //HasLoongArchExpressions = true;
  UseIntegratedAssembler = true;
  UsesELFSectionDirectiveForBSS = true;
}
