# REQUIRES: loongarch

# RUN: llvm-mc -filetype=obj -triple=loongarch64 %s -o %t.o
# RUN: obj2yaml %t.o | FileCheck %s --check-prefix=CHECK-RELOC

# CHECK-RELOC:    Relocations:
# CHECK-RELOC:      - Symbol:          foo
# CHECK-RELOC:        Type:            R_LARCH_SOP_PUSH_PCREL
# CHECK-RELOC:      - Type:            R_LARCH_SOP_POP_32_S_10_16_S2
# CHECK-RELOC:      - Offset:          0x4
# CHECK-RELOC:        Symbol:          bar
# CHECK-RELOC:        Type:            R_LARCH_SOP_PUSH_PCREL
# CHECK-RELOC:      - Offset:          0x4
# CHECK-RELOC:        Type:            R_LARCH_SOP_POP_32_S_10_16_S2

# RUN: ld.lld %t.o --defsym foo=_start+0x4 --defsym bar=_start -o %t
# RUN: llvm-objdump -d %t | FileCheck %s --check-prefix=OBJ

# OBJ: 00 04 00 58  beq $zero, $zero, 4
# OBJ: 00 fc ff 5f  bne $zero, $zero, -4

# RUN: ld.lld %t.o --defsym foo=_start+0x1FFFC --defsym bar=_start+4-0x20000 \
# RUN:    -o %t.limits
# RUN: llvm-objdump -d %t.limits | FileCheck --check-prefix=LIMITS %s
# LIMITS:      00 fc ff 59  beq $zero, $zero, 131068
# LIMITS-NEXT: 00 00 00 5e  bne $zero, $zero, -131072

# RUN: not ld.lld %t.o --defsym foo=_start+0x20000 \
# RUN:     --defsym bar=_start+4-0x20004 -o /dev/null 2>&1 \
# RUN:     | FileCheck --check-prefix=ERROR-RANGE %s
# ERROR-RANGE: relocation R_LARCH_SOP_POP_32_S_10_16_S2 out of range: 131072 is not in [-131072, 131071]
# ERROR-RANGE: relocation R_LARCH_SOP_POP_32_S_10_16_S2 out of range: -131076 is not in [-131072, 131071]

# RUN: not ld.lld %t.o --defsym foo=_start+1 --defsym bar=_start-1 \
# RUN:     -o /dev/null 2>&1 | FileCheck --check-prefix=ERROR-ALIGN %s
# ERROR-ALIGN:      improper alignment for relocation R_LARCH_SOP_POP_32_S_10_16_S2: 0x1 is not aligned to 4 bytes
# ERROR-ALIGN-NEXT: improper alignment for relocation R_LARCH_SOP_POP_32_S_10_16_S2: 0xFFFFFFFFFFFFFFFB is not aligned to 4 bytes

.global _start
_start:
     beq $r0, $r0, foo
     bne $r0, $r0, bar
