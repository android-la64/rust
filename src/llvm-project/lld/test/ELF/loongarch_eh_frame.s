# REQUIRES: loongarch

# RUN: llvm-mc -filetype=obj -triple=loongarch64 %s -o %t.o
# RUN: ld.lld -shared  %t.o -o %t.so

.globl _start
_start:
 nop

.section foo,"ax",@progbits
.cfi_startproc
 nop
.cfi_endproc

.section bar,"ax",@progbits
.cfi_startproc
 nop
.cfi_endproc

.section dah,"ax",@progbits
.cfi_startproc
 nop
.cfi_endproc
