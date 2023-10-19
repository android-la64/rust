# REQUIRES: loongarch

# RUN: llvm-mc -filetype=obj -triple=loongarch64 %s -o %t.o
# RUN: ld.lld -pie  %t.o -o %t.so

# CHECK-NOT: error: cannot preempt symbol: hidden

.globl hidden
.hidden hidden
hidden:
.rodata
.long hidden
