// RUN: %clang -target loongarch64-unknown-linux-gnu -mno-strict-align -### %s 2> %t
// RUN: FileCheck --check-prefix=CHECK-UNALIGNED < %t %s

// RUN: %clang -target loongarch64-unknown-linux-gnu -mstrict-align -### %s 2> %t
// RUN: FileCheck --check-prefix=CHECK-ALIGNED < %t %s

// CHECK-UNALIGNED: "-target-feature" "+unaligned-access"
// CHECK-ALIGNED: "-target-feature" "-unaligned-access"
