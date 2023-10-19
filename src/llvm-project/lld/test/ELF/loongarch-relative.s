// XFAIL: loongarch
// REQUIRES: loongarch
// Test that we create R_LARCH_RELATIVE relocations for the dynamic linker
// but don't put any symbols in the dynamic symbol table.

// RUN: llvm-mc -filetype=obj -triple=loongarch64 %s -o %t.o
// RUN: ld.lld -shared %t.o -o %t.so
// RUN: llvm-readobj -t -r -dyn-symbols %t.so | FileCheck %s

// CHECK:      Relocations [
// CHECK-NEXT:   Section ({{.*}}) .rela.dyn {
// CHECK-NEXT:     0x[[FOO_ADDR:.*]] R_LARCH_RELATIVE - 0x[[FOO_ADDR]]
// CHECK-NEXT:     0x[[BAR_ADDR:.*]] R_LARCH_RELATIVE - 0x[[BAR_ADDR]]
// CHECK-NEXT:     0x10008 R_LARCH_RELATIVE - 0x10005
// CHECK-NEXT:     0x{{.*}} R_LARCH_RELATIVE - 0x[[FOO_ADDR]]
// CHECK-NEXT:     0x{{.*}} R_LARCH_32 external 0x0
// CHECK-NEXT:   }
// CHECK-NEXT: ]

// CHECK:      Symbols [
// CHECK:          Name: foo
// CHECK-NEXT:     Value: 0x[[FOO_ADDR]]
// CHECK:          Name: bar
// CHECK-NEXT:     Value: 0x[[BAR_ADDR]]
// CHECK:      ]

// CHECK:      DynamicSymbols [
// CHECK-NEXT:   Symbol {
// CHECK-NEXT:     Name:
// CHECK-NEXT:     Value: 0x0
// CHECK-NEXT:     Size: 0
// CHECK-NEXT:     Binding: Local
// CHECK-NEXT:     Type: None
// CHECK-NEXT:     Other: 0
// CHECK-NEXT:     Section: Undefined
// CHECK-NEXT:   }
// CHECK-NEXT:   Symbol {
// CHECK-NEXT:     Name: external
// CHECK-NEXT:     Value: 0x0
// CHECK-NEXT:     Size: 0
// CHECK-NEXT:     Binding: Global
// CHECK-NEXT:     Type: None
// CHECK-NEXT:     Other: 0
// CHECK-NEXT:     Section: Undefined
// CHECK-NEXT:   }
// CHECK-NEXT: ]

     .data
foo:
     .long foo

     .hidden bar
     .globl bar
bar:
     .long bar
     .long bar + 1
     .long foo

     .long external
