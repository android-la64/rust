/// This test checks the valid cpu model which is supported by LoongArch.

// RUN: %clang --target=loongarch64 -march=la264 -emit-llvm -### %s 2> %t
//  | FileCheck -check-prefix=LA264 %t %s
// RUN: %clang --target=loongarch64 -march=la364 -emit-llvm -### %s 2> %t
//  | FileCheck -check-prefix=LA364 %t %s
// RUN: %clang --target=loongarch64 -march=la464 -emit-llvm -### %s 2> %t
//  | FileCheck -check-prefix=LA464 %t %s
// RUN: %clang --target=loongarch64 -march=xxx -emit-llvm -### %s 2> %t
//  | FileCheck -check-prefix=INVALID %t %s

// LA264: "-target-cpu la264" "-target-abi lp64"
// LA364: "-target-cpu la364" "-target-abi lp64"
// LA464: "-target-cpu la464" "-target-abi lp64"
// INVALID: error: unknown target CPU 'xxx'
