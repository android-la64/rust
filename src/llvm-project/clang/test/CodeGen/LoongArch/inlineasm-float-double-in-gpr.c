// RUN: %clang_cc1 -triple loongarch64 -O2 -emit-llvm %s -o - \
// RUN:   | FileCheck %s

float f;
double d;

// CHECK-LABEL: @reg_float(
// CHECK: [[FLT_ARG:%.*]] = load float, float* @f
// CHECK: call void asm sideeffect "", "r"(float [[FLT_ARG]])
// CHECK: ret void
void reg_float() {
  float a = f;
  asm volatile(""
               :
               : "r"(a));
}

// CHECK-LABEL: @r4_float(
// CHECK: [[FLT_ARG:%.*]] = load float, float* @f
// CHECK: call void asm sideeffect "", "{$r4}"(float [[FLT_ARG]])
// CHECK: ret void
void r4_float() {
  register float a asm("$r4") = f;
  asm volatile(""
               :
               : "r"(a));
}

// CHECK-LABEL: @reg_double(
// CHECK: [[DBL_ARG:%.*]] = load double, double* @d
// CHECK: call void asm sideeffect "", "r"(double [[DBL_ARG]])
// CHECK: ret void
void reg_double() {
  double a = d;
  asm volatile(""
               :
               : "r"(a));
}

// CHECK-LABEL: @r4_double(
// CHECK: [[DBL_ARG:%.*]] = load double, double* @d
// CHECK: call void asm sideeffect "", "{$r4}"(double [[DBL_ARG]])
// CHECK: ret void
void r4_double() {
  register double a asm("$r4") = d;
  asm volatile(""
               :
               : "r"(a));
}
