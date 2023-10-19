# REQUIRES: loongarch
# RUN: echo '.globl bar, weak; .type bar,@function; .type weak,@function; bar: weak:' > %t1.s

# RUN: llvm-mc -filetype=obj -triple=loongarch64 %t1.s -o %t1.64.o
# RUN: ld.lld -shared %t1.64.o -soname=t1.64.so -o %t1.64.so
# RUN: llvm-mc -filetype=obj -triple=loongarch64 %s -o %t.64.o
# RUN: ld.lld %t.64.o %t1.64.so -o %t.64
# RUN: llvm-readelf -S -s %t.64 | FileCheck --check-prefixes=SEC,NM %s
# RUN: llvm-readobj -r %t.64 | FileCheck --check-prefix=RELOC64 %s
# RUN: llvm-readelf -x .got.plt %t.64 | FileCheck --check-prefix=GOTPLT64 %s
# RUN: llvm-objdump -d --no-show-raw-insn %t.64 | FileCheck --check-prefixes=DIS,DIS64 %s

# SEC: .plt PROGBITS {{0*}}1200102f0

## A canonical PLT has a non-zero st_value. bar and weak are called but their
## addresses are not taken, so a canonical PLT is not necessary.
# NM: {{0*}}00000000 0 FUNC GLOBAL DEFAULT UND bar
# NM: {{0*}}00000000 0 FUNC WEAK   DEFAULT UND weak

## The .got.plt slots relocated by .rela.plt point to .plt
## This is required by glibc.
# RELOC64:      .rela.plt {
# RELOC64-NEXT:   0x120030410 R_LARCH_JUMP_SLOT bar 0x0
# RELOC64-NEXT:   0x120030418 R_LARCH_JUMP_SLOT weak 0x0
# RELOC64-NEXT: }
# GOTPLT64:      section '.got.plt'
# GOTPLT64-NEXT: 0x120030400 00000000 00000000 00000000 00000000
# GOTPLT64-NEXT: 0x120030410 f0020120 01000000 f0020120 01000000

# DIS:      <_start>:
## foo - . = 0x1200102e0-0x1200102d0 = 16
# DIS-NEXT:   1200102d0:     	bl	16 <foo>
## bar@plt - . = 0x120010310-0x1200102d4 = 60
# DIS-NEXT:   1200102d4:     	bl	60 <weak+0x120010310>
## bar@plt - . = 0x120010310-0x1200102d8 = 56
# DIS-NEXT:   1200102d8:     	bl	56 <weak+0x120010310>
## weak@plt - . = 0x120010320-0x1200102dc = 68
# DIS-NEXT:   1200102dc:     	bl	68 <weak+0x120010320>
# DIS:      <foo>:
# DIS-NEXT: 1200102e0:     	jirl	$zero, $ra, 0

## 120030400 .got.plt
## 1200102f0 .plt
# DIS:      Disassembly of section .plt:
# DIS:      <.plt>:
## hi20(.got.plt - .plt + 0x800) = (0x120030400 - 0x1200102f0 + 0x800)>>12 = 0x20910 >> 12 = 0x20
# DIS-NEXT:              pcaddu12i $r14, 32
# DIS-NEXT:              sub.d     $r13, $r13, $r15
## lo12(.got.plt - .plt) = (0x120030400 - 0x1200102f0) & 0xfff = 0x20110 & 0xfff = 0x110
# DIS64-NEXT:            ld.d      $r15, $r14, 272
# DIS64-NEXT:            addi.d    $r13, $r13, -40
## lo12(.got.plt - .plt) = (0x120030400 - 0x1200102f0) & 0xfff = 0x20110 & 0xfff = 0x110
# DIS64-NEXT:            addi.d    $r12, $r14, 272
# DIS64-NEXT:            srli.d    $r13, $r13, 1
# DIS64-NEXT:            ld.d      $r12, $r12, 8
# DIS-NEXT:              jirl      $zero, $r15, 0

## hi20(&.got.plt[bar]-.) = (0x120030410 - 0x120010310 + 0x800) >> 12 = 0x20900 >> 12 = 0x20
# DIS:        120010310: pcaddu12i $r15, 32
## lo12(&.got.plt[bar]-.) = (0x120030410 - 0x120010310) & 0xfff = 0x20100 & 0xfff = 0x100
# DIS64-NEXT:            ld.d      $r15, $r15, 256
# DIS-NEXT:              pcaddu12i $r13, 0
# DIS-NEXT:              jirl      $zero, $r15, 0

## hi20(&.got.plt[weak]-.) = (0x120030418 - 0x120010320 + 0x800) >> 12 = 0x208f8 >> 12 = 0x20
# DIS:        120010320: pcaddu12i $r15, 32
## lo12(&.got.plt[weak]-.) = (0x120030418 - 0x120010320) & 0xfff = 0x200f8 & 0xfff = 0xf8
# DIS64-NEXT:            ld.d      $r15, $r15, 248
# DIS-NEXT:              pcaddu12i $r13, 0
# DIS-NEXT:              jirl      $zero, $r15, 0

.global _start, foo, bar
.weak weak

_start:
  bl foo
  bl bar
  bl bar@plt
  bl weak

## foo is local and non-preemptale, no PLT is generated.
foo:
  jr $ra
