#include "../sanitizer_common/sanitizer_asm.h"

//===-- xray_trampoline_loongarch.s -----------------------------*- ASM -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of XRay, a dynamic runtime instrumentation system.
//
// This implements the loongarch-specific assembler for the trampolines.
//
//===----------------------------------------------------------------------===//

  .text
  .file "xray_trampoline_loongarch.S"
  .globl __xray_FunctionEntry
  .p2align 2
  .type __xray_FunctionEntry,@function
__xray_FunctionEntry:
  .cfi_startproc
  // Save argument registers before doing any actual work.
  .cfi_def_cfa_offset 136
  addi.d  $sp, $sp, -136
  st.d    $ra, $sp, 128
  .cfi_offset 1, -8
  st.d     $a7, $sp, 120
  st.d     $a6, $sp, 112
  st.d     $a5, $sp, 104
  st.d     $a4, $sp, 96
  st.d     $a3, $sp, 88
  st.d     $a2, $sp, 80
  st.d     $a1, $sp, 72
  st.d     $a0, $sp, 64
  fst.d    $f7, $sp, 56
  fst.d    $f6, $sp, 48
  fst.d    $f5, $sp, 40
  fst.d    $f4, $sp, 32
  fst.d    $f3, $sp, 24
  fst.d    $f2, $sp, 16
  fst.d    $f1, $sp, 8
  fst.d    $f0, $sp, 0


  la.got $t2, _ZN6__xray19XRayPatchedFunctionE
  ld.d $t2, $t2, 0

  beqz    $t2, FunctionEntry_restore

  // a1=0 means that we are tracing an entry event
  move    $a1, $zero
  // Function ID is in t1 (the first parameter).
  move    $a0, $t1
  jirl    $ra, $t2, 0

FunctionEntry_restore:
  // Restore argument registers
  fld.d    $f0, $sp, 0
  fld.d    $f1, $sp, 8
  fld.d    $f2, $sp, 16
  fld.d    $f3, $sp, 24
  fld.d    $f4, $sp, 32
  fld.d    $f5, $sp, 40
  fld.d    $f6, $sp, 48
  fld.d    $f7, $sp, 56
  ld.d     $a0, $sp, 64
  ld.d     $a1, $sp, 72
  ld.d     $a2, $sp, 80
  ld.d     $a3, $sp, 88
  ld.d     $a4, $sp, 96
  ld.d     $a5, $sp, 104
  ld.d     $a6, $sp, 112
  ld.d     $a7, $sp, 120
  ld.d     $ra, $sp, 128
  addi.d  $sp, $sp, 136
  jr      $ra
FunctionEntry_end:
  .size __xray_FunctionEntry, FunctionEntry_end-__xray_FunctionEntry
  .cfi_endproc

  .text
  .globl __xray_FunctionExit
  .p2align 2
  .type __xray_FunctionExit,@function
__xray_FunctionExit:
  .cfi_startproc
  // Save return registers before doing any actual work.
  .cfi_def_cfa_offset 48
  addi.d  $sp, $sp, -48
  st.d      $ra, $sp, 40
  .cfi_offset 1, -8
  st.d    $fp, $sp, 32
  st.d    $a1, $sp, 24
  st.d    $a0, $sp, 16
  fst.d   $f1, $sp, 8
  fst.d   $f0, $sp, 0

  la.got $t2, _ZN6__xray19XRayPatchedFunctionE
  ld.d $t2, $t2, 0

  beqz    $t2, FunctionExit_restore

  // a1=1 means that we are tracing an exit event
  ori      $a1, $zero, 1
  // Function ID is in t1 (the first parameter).
  move    $a0, $t1
  jirl    $ra, $t2, 0

FunctionExit_restore:
  // Restore return registers
  fld.d   $f0, $sp, 0
  fld.d   $f1, $sp, 8
  ld.d    $a1, $sp, 24
  ld.d    $a0, $sp, 16
  ld.d    $fp, $sp, 32
  ld.d    $ra, $sp, 40
  addi.d  $sp, $sp, 48
  jr      $ra

FunctionExit_end:
  .size __xray_FunctionExit, FunctionExit_end-__xray_FunctionExit
  .cfi_endproc

NO_EXEC_STACK_DIRECTIVE
