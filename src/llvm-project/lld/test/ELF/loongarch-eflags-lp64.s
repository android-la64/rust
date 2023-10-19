# REQUIRES: loongarch

# RUN: llvm-mc -filetype=obj -triple=loongarch64 %s -o %t
# RUN: llvm-mc -filetype=obj -triple=loongarch64 %S/Inputs/loongarch.s -o %t2
# RUN: ld.lld %t2 %t  -o %t3
# RUN: llvm-readelf -h  %t3 | FileCheck %s
# Verify the LoongArch LP64 ABI.
# CHECK: Flags: 0x3, LP64
