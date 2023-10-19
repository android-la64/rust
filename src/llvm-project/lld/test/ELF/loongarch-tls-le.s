# REQUIRES: loongarch

# RUN: llvm-mc -filetype=obj -triple=loongarch64 %s -o %t.o
# RUN: llvm-readobj --relocations %t.o | FileCheck -check-prefix=InputRelocs %s
# RUN: ld.lld %t.o -o %t
# RUN: llvm-readobj --relocations %t | FileCheck -check-prefix=OutputRelocs %s
# RUN: llvm-objdump --section-headers -t %t | FileCheck -check-prefix=SO_SYM %s
# RUN: llvm-objdump -d %t | FileCheck --check-prefixes=DIS %s

# Test the handling of the Local-Exec TLS model. TLS can be resolved
# statically for an application.

.globl _start
_start:
  la.tls.le $r12, x
  la.tls.le $r13, y
  la.tls.le $r15, z + 0x100

.section .tdata
.local x
x:
.byte 10

.globl y
y:
.word 10

.local z
z:
.long 10

# InputRelocs:      Relocations [
# InputRelocs-NEXT:   Section (3) .rela.text {
# InputRelocs-NEXT:     0x0 R_LARCH_SOP_PUSH_TLS_TPREL x 0x0
# InputRelocs-NEXT:     0x0 R_LARCH_SOP_PUSH_ABSOLUTE - 0x20
# InputRelocs-NEXT:     0x0 R_LARCH_SOP_SL - 0x0
# InputRelocs-NEXT:     0x0 R_LARCH_SOP_PUSH_ABSOLUTE - 0x2C
# InputRelocs-NEXT:     0x0 R_LARCH_SOP_SR - 0x0
# InputRelocs-NEXT:     0x0 R_LARCH_SOP_POP_32_S_5_20 - 0x0
# InputRelocs-NEXT:     0x4 R_LARCH_SOP_PUSH_TLS_TPREL x 0x0
# InputRelocs-NEXT:     0x4 R_LARCH_SOP_PUSH_ABSOLUTE - 0xFFF
# InputRelocs-NEXT:     0x4 R_LARCH_SOP_AND - 0x0
# InputRelocs-NEXT:     0x4 R_LARCH_SOP_POP_32_U_10_12 - 0x0
# InputRelocs-NEXT:     0x8 R_LARCH_SOP_PUSH_TLS_TPREL x 0x0
# InputRelocs-NEXT:     0x8 R_LARCH_SOP_PUSH_ABSOLUTE - 0xC
# InputRelocs-NEXT:     0x8 R_LARCH_SOP_SL - 0x0
# InputRelocs-NEXT:     0x8 R_LARCH_SOP_PUSH_ABSOLUTE - 0x2C
# InputRelocs-NEXT:     0x8 R_LARCH_SOP_SR - 0x0
# InputRelocs-NEXT:     0x8 R_LARCH_SOP_POP_32_S_5_20 - 0x0
# InputRelocs-NEXT:     0xC R_LARCH_SOP_PUSH_TLS_TPREL x 0x0
# InputRelocs-NEXT:     0xC R_LARCH_SOP_PUSH_ABSOLUTE - 0x34
# InputRelocs-NEXT:     0xC R_LARCH_SOP_SR - 0x0
# InputRelocs-NEXT:     0xC R_LARCH_SOP_POP_32_S_10_12 - 0x0
# InputRelocs-NEXT:     0x10 R_LARCH_SOP_PUSH_TLS_TPREL y 0x0
# InputRelocs-NEXT:     0x10 R_LARCH_SOP_PUSH_ABSOLUTE - 0x20
# InputRelocs-NEXT:     0x10 R_LARCH_SOP_SL - 0x0
# InputRelocs-NEXT:     0x10 R_LARCH_SOP_PUSH_ABSOLUTE - 0x2C
# InputRelocs-NEXT:     0x10 R_LARCH_SOP_SR - 0x0
# InputRelocs-NEXT:     0x10 R_LARCH_SOP_POP_32_S_5_20 - 0x0
# InputRelocs-NEXT:     0x14 R_LARCH_SOP_PUSH_TLS_TPREL y 0x0
# InputRelocs-NEXT:     0x14 R_LARCH_SOP_PUSH_ABSOLUTE - 0xFFF
# InputRelocs-NEXT:     0x14 R_LARCH_SOP_AND - 0x0
# InputRelocs-NEXT:     0x14 R_LARCH_SOP_POP_32_U_10_12 - 0x0
# InputRelocs-NEXT:     0x18 R_LARCH_SOP_PUSH_TLS_TPREL y 0x0
# InputRelocs-NEXT:     0x18 R_LARCH_SOP_PUSH_ABSOLUTE - 0xC
# InputRelocs-NEXT:     0x18 R_LARCH_SOP_SL - 0x0
# InputRelocs-NEXT:     0x18 R_LARCH_SOP_PUSH_ABSOLUTE - 0x2C
# InputRelocs-NEXT:     0x18 R_LARCH_SOP_SR - 0x0
# InputRelocs-NEXT:     0x18 R_LARCH_SOP_POP_32_S_5_20 - 0x0
# InputRelocs-NEXT:     0x1C R_LARCH_SOP_PUSH_TLS_TPREL y 0x0
# InputRelocs-NEXT:     0x1C R_LARCH_SOP_PUSH_ABSOLUTE - 0x34
# InputRelocs-NEXT:     0x1C R_LARCH_SOP_SR - 0x0
# InputRelocs-NEXT:     0x1C R_LARCH_SOP_POP_32_S_10_12 - 0x0
# InputRelocs-NEXT:     0x20 R_LARCH_SOP_PUSH_TLS_TPREL z 0x100
# InputRelocs-NEXT:     0x20 R_LARCH_SOP_PUSH_ABSOLUTE - 0x20
# InputRelocs-NEXT:     0x20 R_LARCH_SOP_SL - 0x0
# InputRelocs-NEXT:     0x20 R_LARCH_SOP_PUSH_ABSOLUTE - 0x2C
# InputRelocs-NEXT:     0x20 R_LARCH_SOP_SR - 0x0
# InputRelocs-NEXT:     0x20 R_LARCH_SOP_POP_32_S_5_20 - 0x0
# InputRelocs-NEXT:     0x24 R_LARCH_SOP_PUSH_TLS_TPREL z 0x100
# InputRelocs-NEXT:     0x24 R_LARCH_SOP_PUSH_ABSOLUTE - 0xFFF
# InputRelocs-NEXT:     0x24 R_LARCH_SOP_AND - 0x0
# InputRelocs-NEXT:     0x24 R_LARCH_SOP_POP_32_U_10_12 - 0x0
# InputRelocs-NEXT:     0x28 R_LARCH_SOP_PUSH_TLS_TPREL z 0x100
# InputRelocs-NEXT:     0x28 R_LARCH_SOP_PUSH_ABSOLUTE - 0xC
# InputRelocs-NEXT:     0x28 R_LARCH_SOP_SL - 0x0
# InputRelocs-NEXT:     0x28 R_LARCH_SOP_PUSH_ABSOLUTE - 0x2C
# InputRelocs-NEXT:     0x28 R_LARCH_SOP_SR - 0x0
# InputRelocs-NEXT:     0x28 R_LARCH_SOP_POP_32_S_5_20 - 0x0
# InputRelocs-NEXT:     0x2C R_LARCH_SOP_PUSH_TLS_TPREL z 0x100
# InputRelocs-NEXT:     0x2C R_LARCH_SOP_PUSH_ABSOLUTE - 0x34
# InputRelocs-NEXT:     0x2C R_LARCH_SOP_SR - 0x0
# InputRelocs-NEXT:     0x2C R_LARCH_SOP_POP_32_S_10_12 - 0x0
# InputRelocs-NEXT:   }
# InputRelocs-NEXT: ]

# Local-Exec creates no
# OutputRelocs:      Relocations [
# OutputRelocs-NEXT: ]

# SO_SYM: Sections:
# SO_SYM: Idx Name          Size     VMA              Type
# SO_SYM:   2 .tdata        00000009 0000000120020230 DATA
# SO_SYM: SYMBOL TABLE:
# SO_SYM: 0000000000000000 l     .tdata {{0*}} x
# SO_SYM: 0000000000000005 l     .tdata {{0*}} z
# SO_SYM: 0000000000000001 g     .tdata {{0*}} y

# %tprel(x+addend)=0 ; %tprel(y+addend)=1 ; %tprel(z+0x100)=0x105=261

# la.tls.le rd, symbol + addend
#    Load $tp-relative offset of TLS symbol
# will be expanded to such instructions:
# lu12i.w  rd,%tprel(symbol + addend)<<32>>44
# ori  rd,rd,%tprel(symbol + addend)&0xfff
# lu32i.d  rd,%tprel(symbol + addend)<<12>>44
# lu52i.d  rd,rd,%tprel(symbol + addend)>>52

# DIS:      120010200: 0c 00 00 14    lu12i.w $r12, 0
# DIS-NEXT: 120010204: 8c 01 80 03    ori     $r12, $r12, 0
# DIS-NEXT: 120010208: 0c 00 00 16    lu32i.d $r12, 0
# DIS-NEXT: 12001020c: 8c 01 00 03    lu52i.d $r12, $r12, 0
# DIS-NEXT: 120010210: 0d 00 00 14    lu12i.w $r13, 0
# DIS-NEXT: 120010214: ad 05 80 03    ori     $r13, $r13, 1
# DIS-NEXT: 120010218: 0d 00 00 16    lu32i.d $r13, 0
# DIS-NEXT: 12001021c: ad 01 00 03    lu52i.d $r13, $r13, 0
# DIS-NEXT: 120010220: 0f 00 00 14    lu12i.w $r15, 0
# DIS-NEXT: 120010224: ef 15 84 03    ori     $r15, $r15, 261
# DIS-NEXT: 120010228: 0f 00 00 16    lu32i.d $r15, 0
# DIS-NEXT: 12001022c: ef 01 00 03    lu52i.d $r15, $r15, 0
