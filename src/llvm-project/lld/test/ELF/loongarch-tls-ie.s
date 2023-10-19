# REQUIRES: loongarch

# RUN: llvm-mc -filetype=obj -triple=loongarch64 %s -o %t.64.o
# RUN: llvm-objdump -r %t.64.o | FileCheck --check-prefix=RELOCS %s
## loongarch64 IE
# RUN: ld.lld -shared %t.64.o -o %t.64.so
# RUN: llvm-readobj -r -d %t.64.so | FileCheck --check-prefix=IE64-REL %s
# RUN: llvm-objdump -d --no-show-raw-insn %t.64.so | FileCheck --check-prefixes=IE,IE64 %s

# RELOCS: RELOCATION RECORDS FOR [.text]:
# RELOCS-NEXT: OFFSET           TYPE                         VALUE
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_PUSH_PCREL       _GLOBAL_OFFSET_TABLE_+0x800
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_PUSH_TLS_GOT     y
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_ADD      *ABS*
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_PUSH_ABSOLUTE    *ABS*+0xc
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_SR       *ABS*
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_POP_32_S_5_20    *ABS*
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_PUSH_PCREL       _GLOBAL_OFFSET_TABLE_+0x4
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_PUSH_TLS_GOT     y
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_ADD      *ABS*
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_PUSH_PCREL       _GLOBAL_OFFSET_TABLE_+0x804
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_PUSH_TLS_GOT     y
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_ADD      *ABS*
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_PUSH_ABSOLUTE    *ABS*+0xc
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_SR       *ABS*
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_PUSH_ABSOLUTE    *ABS*+0xc
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_SL       *ABS*
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_SUB      *ABS*
# RELOCS-NEXT: {{[0-9abcdef]*}} R_LARCH_SOP_POP_32_S_10_12   *ABS*

# IE64-REL:      .rela.dyn {
# IE64-REL-NEXT:   0x203B0 R_LARCH_TLS_TPREL64 - 0x4
# IE64-REL-NEXT:   0x203A8 R_LARCH_TLS_TPREL64 y 0x0
# IE64-REL-NEXT: }

## loongarch64: &.got[y] - . = 0x203A8 - . = 0x100C8 = 4096*16+200
# IE:  102e0: pcaddu12i $r4, 16
# IE64-NEXT:  ld.d      $r4, $r4, 200
# IE-NEXT:    addi.w    $r5, $zero, 10
# IE-NEXT:    stx.w     $r5, $tp, $r4
## loongarch64: &.got[z] - . = 0x203B0 - . = 0x100C0 = 4096*16+192
# IE:  102f0: pcaddu12i $r6, 16
# IE64-NEXT:  ld.d      $r6, $r6, 192
# IE-NEXT:    addi.w    $r7, $zero, 100
# IE-NEXT:    stx.w     $r7, $tp, $r6

la.tls.ie $r4, y
addi.w    $r5, $zero, 10
stx.w     $r5, $tp, $r4
la.tls.ie $r6, z
addi.w    $r7, $zero, 100
stx.w     $r7, $tp, $r6

.section .tbss
.globl y
y:
.word   0
.size   y, 4
z:
.word   0
.size   z, 4
