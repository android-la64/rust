# REQUIRES: loongarch
# Check la.got relocation calculation. In this case, la.global will be expanded to la.got.

# RUN: llvm-mc -filetype=obj -triple=loongarch64 %s -o %t.o
# RUN: llvm-readobj --relocations %t.o | FileCheck -check-prefix=RELOC %s
# RUN: ld.lld %t.o -o %t.exe
# RUN: llvm-objdump --section-headers -t %t.exe | FileCheck -check-prefix=EXE_SYM %s
# RUN: llvm-objdump -s --section=.got %t.exe | FileCheck -check-prefix=EXE_GOT %s
# RUN: llvm-objdump -d %t.exe | FileCheck -check-prefix=EXE_DIS %s
# RUN: llvm-readobj --relocations %t.exe | FileCheck -check-prefix=NORELOC %s

.text
.globl  _start
_start:
  la.global $r12, value

.data
value:
  .word 1

# RELOC:      Relocations [
# RELOC-NEXT:   Section (3) .rela.text {
# RELOC-NEXT:     0x0 R_LARCH_SOP_PUSH_PCREL _GLOBAL_OFFSET_TABLE_ 0x800
# RELOC-NEXT:     0x0 R_LARCH_SOP_PUSH_GPREL value 0x0
# RELOC-NEXT:     0x0 R_LARCH_SOP_ADD - 0x0
# RELOC-NEXT:     0x0 R_LARCH_SOP_PUSH_ABSOLUTE - 0xC
# RELOC-NEXT:     0x0 R_LARCH_SOP_SR - 0x0
# RELOC-NEXT:     0x0 R_LARCH_SOP_POP_32_S_5_20 - 0x0
# RELOC-NEXT:     0x4 R_LARCH_SOP_PUSH_PCREL _GLOBAL_OFFSET_TABLE_ 0x4
# RELOC-NEXT:     0x4 R_LARCH_SOP_PUSH_GPREL value 0x0
# RELOC-NEXT:     0x4 R_LARCH_SOP_ADD - 0x0
# RELOC-NEXT:     0x4 R_LARCH_SOP_PUSH_PCREL _GLOBAL_OFFSET_TABLE_ 0x804
# RELOC-NEXT:     0x4 R_LARCH_SOP_PUSH_GPREL value 0x0
# RELOC-NEXT:     0x4 R_LARCH_SOP_ADD - 0x0
# RELOC-NEXT:     0x4 R_LARCH_SOP_PUSH_ABSOLUTE - 0xC
# RELOC-NEXT:     0x4 R_LARCH_SOP_SR - 0x0
# RELOC-NEXT:     0x4 R_LARCH_SOP_PUSH_ABSOLUTE - 0xC
# RELOC-NEXT:     0x4 R_LARCH_SOP_SL - 0x0
# RELOC-NEXT:     0x4 R_LARCH_SOP_SUB - 0x0
# RELOC-NEXT:     0x4 R_LARCH_SOP_POP_32_S_10_12 - 0x0
# RELOC-NEXT:   }
# RELOC-NEXT: ]

# EXE_SYM: Sections:
# EXE_SYM: Idx Name          Size      VMA               Type
# EXE_SYM: 2   .got          00000010  00000001200201d8  DATA 
# EXE_SYM: SYMBOL TABLE:
# EXE_SYM: 00000001200201d8 l       .got	0000000000000000 .hidden _GLOBAL_OFFSET_TABLE_
#          ^---- .got

# EXE_GOT:      Contents of section .got:
# EXE_GOT-NEXT: 1200201d8 00000000 00000000 f0010320 01000000
#                         ^                 ^---------value
#                         +-- .dynamic address (if exist)

# pcaddu12i  rd,(%pcrel(_GLOBAL_OFFSET_TABLE_+0x800)+%gprel(symbol))>>12
# value_GotAddr=%gprel(synbol) = 0x1200201e0-0x1200201d8 = 8
# (0x1200201d8+0x800-0x1200101d0+8)>>12 = 16
# EXE_DIS:      1200101d0:      0c 02 00 1c     pcaddu12i       $r12, 16

# ld.d  rd,rd,%pcrel(_GLOBAL_OFFSET_TABLE_+4)+%gprel(symbol)-((%pcrel(
# _GLOBAL_OFFSET_TABLE_+4+0x800)+%gprel(symbol))>>12<<12)
# (0x1200201d8+4-0x1200101d4)+8-((0x1200201d8+4+0x800-0x1200101d4)+8)>>12<<12 = 8
# EXE_DIS-NEXT: 1200101d4:      8c 41 c0 28     ld.d    $r12, $r12, 16 

# NORELOC:      Relocations [
# NORELOC-NEXT: ]
