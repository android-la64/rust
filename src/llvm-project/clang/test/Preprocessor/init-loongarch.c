// RUN: %clang --target=loongarch64 -x c -E -dM %s -o - | grep loongarch | FileCheck %s

// CHECK: #define __loongarch64 1
// CHECK-NEXT: #define __loongarch__ 1
// CHECK-NEXT: #define __loongarch_double_float 1
// CHECK-NEXT: #define __loongarch_fpr 64
// CHECK-NEXT: #define __loongarch_frlen 64
// CHECK-NEXT: #define __loongarch_grlen 64
// CHECK-NEXT: #define __loongarch_hard_float 1
// CHECK-NEXT: #define __loongarch_lp64 1
