// REQUIRES: loongarch-registered-target
// RUN: %clang_cc1 -triple loongarch64-unknown-linux-gnu -emit-llvm %s \
// RUN:            -target-feature +lasx \
// RUN:            -o - | FileCheck %s

#include <lasxintrin.h>

#define ui1_b 1
#define ui2 1
#define ui2_b ui2
#define ui3 4
#define ui3_b ui3
#define ui4 7
#define ui4_b ui4
#define ui5 25
#define ui5_b ui5
#define ui6 44
#define ui6_b ui6
#define ui7 100
#define ui7_b ui7
#define ui8 127 //200
#define ui8_b ui8
#define si5_b -4
#define si8 -100
#define si9 0
#define si10 0
#define si11 0
#define si12 0
#define i10 500
#define i13 4000
#define mode 0
#define idx1 1
#define idx2 2
#define idx3 4
#define idx4 8

void test(void) {
  v32i8 v32i8_a = (v32i8){0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                          16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
  v32i8 v32i8_b = (v32i8){1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
                          17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32};
  v32i8 v32i8_c = (v32i8){2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
                          18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33};
  v32i8 v32i8_r;

  v16i16 v16i16_a = (v16i16){0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
  v16i16 v16i16_b = (v16i16){1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
  v16i16 v16i16_c = (v16i16){2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17};
  v16i16 v16i16_r;

  v8i32 v8i32_a = (v8i32){0, 1, 2, 3, 4, 5, 6, 7};
  v8i32 v8i32_b = (v8i32){1, 2, 3, 4, 5, 6, 7, 8};
  v8i32 v8i32_c = (v8i32){2, 3, 4, 5, 6, 7, 8, 9};
  v8i32 v8i32_r;

  v4i64 v4i64_a = (v4i64){0, 1, 2, 3};
  v4i64 v4i64_b = (v4i64){1, 2, 3, 4};
  v4i64 v4i64_c = (v4i64){2, 3, 4, 5};
  v4i64 v4i64_r;

  v32u8 v32u8_a = (v32u8){0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                          16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
  v32u8 v32u8_b = (v32u8){1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
                          17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32};
  v32u8 v32u8_c = (v32u8){2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
                          18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33};
  v32u8 v32u8_r;

  v16u16 v16u16_a = (v16u16){0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
  v16u16 v16u16_b = (v16u16){1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
  v16u16 v16u16_c = (v16u16){2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17};
  v16u16 v16u16_r;

  v8u32 v8u32_a = (v8u32){0, 1, 2, 3, 4, 5, 6, 7};
  v8u32 v8u32_b = (v8u32){1, 2, 3, 4, 5, 6, 7, 8};
  v8u32 v8u32_c = (v8u32){2, 3, 4, 5, 6, 7, 8, 9};
  v8u32 v8u32_r;

  v4u64 v4u64_a = (v4u64){0, 1, 2, 3};
  v4u64 v4u64_b = (v4u64){1, 2, 3, 4};
  v4u64 v4u64_c = (v4u64){2, 3, 4, 5};
  v4u64 v4u64_r;

  v8f32 v8f32_a = (v8f32){0.5, 1, 2, 3, 4, 5, 6, 7};
  v8f32 v8f32_b = (v8f32){1.5, 2, 3, 4, 5, 6, 7, 8};
  v8f32 v8f32_c = (v8f32){2.5, 3, 4, 5, 6, 7, 8, 9};
  v8f32 v8f32_r;
  v4f64 v4f64_a = (v4f64){0.5, 1, 2, 3};
  v4f64 v4f64_b = (v4f64){1.5, 2, 3, 4};
  v4f64 v4f64_c = (v4f64){2.5, 3, 4, 5};
  v4f64 v4f64_r;

  int i32_r;
  int i32_a = 1;
  int i32_b = 2;
  unsigned int u32_r;
  unsigned int u32_a = 1;
  unsigned int u32_b = 2;
  long long i64_r;
  long long i64_a = 1;
  long long i64_b = 2;
  long long i64_c = 3;
  long int i64_d = 0;
  unsigned long long u64_r;
  unsigned long long u64_a = 1;
  unsigned long long u64_b = 2;
  unsigned long long u64_c = 3;

  // __lasx_xvsll_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvsll_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsll.b(

  // __lasx_xvsll_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvsll_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsll.h(

  // __lasx_xvsll_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvsll_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsll.w(

  // __lasx_xvsll_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsll_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsll.d(

  // __lasx_xvslli_b
  // xd, xj, ui3
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvslli_b(v32i8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvslli.b(

  // __lasx_xvslli_h
  // xd, xj, ui4
  // V16HI, V16HI, UQI
  v16i16_r = __lasx_xvslli_h(v16i16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvslli.h(

  // __lasx_xvslli_w
  // xd, xj, ui5
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvslli_w(v8i32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvslli.w(

  // __lasx_xvslli_d
  // xd, xj, ui6
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvslli_d(v4i64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvslli.d(

  // __lasx_xvsra_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvsra_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsra.b(

  // __lasx_xvsra_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvsra_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsra.h(

  // __lasx_xvsra_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvsra_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsra.w(

  // __lasx_xvsra_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsra_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsra.d(

  // __lasx_xvsrai_b
  // xd, xj, ui3
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvsrai_b(v32i8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrai.b(

  // __lasx_xvsrai_h
  // xd, xj, ui4
  // V16HI, V16HI, UQI
  v16i16_r = __lasx_xvsrai_h(v16i16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrai.h(

  // __lasx_xvsrai_w
  // xd, xj, ui5
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvsrai_w(v8i32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrai.w(

  // __lasx_xvsrai_d
  // xd, xj, ui6
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvsrai_d(v4i64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrai.d(

  // __lasx_xvsrar_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvsrar_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrar.b(

  // __lasx_xvsrar_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvsrar_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrar.h(

  // __lasx_xvsrar_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvsrar_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrar.w(

  // __lasx_xvsrar_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsrar_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrar.d(

  // __lasx_xvsrari_b
  // xd, xj, ui3
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvsrari_b(v32i8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrari.b(

  // __lasx_xvsrari_h
  // xd, xj, ui4
  // V16HI, V16HI, UQI
  v16i16_r = __lasx_xvsrari_h(v16i16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrari.h(

  // __lasx_xvsrari_w
  // xd, xj, ui5
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvsrari_w(v8i32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrari.w(

  // __lasx_xvsrari_d
  // xd, xj, ui6
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvsrari_d(v4i64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrari.d(

  // __lasx_xvsrl_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvsrl_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrl.b(

  // __lasx_xvsrl_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvsrl_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrl.h(

  // __lasx_xvsrl_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvsrl_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrl.w(

  // __lasx_xvsrl_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsrl_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrl.d(

  // __lasx_xvsrli_b
  // xd, xj, ui3
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvsrli_b(v32i8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrli.b(

  // __lasx_xvsrli_h
  // xd, xj, ui4
  // V16HI, V16HI, UQI
  v16i16_r = __lasx_xvsrli_h(v16i16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrli.h(

  // __lasx_xvsrli_w
  // xd, xj, ui5
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvsrli_w(v8i32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrli.w(

  // __lasx_xvsrli_d
  // xd, xj, ui6
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvsrli_d(v4i64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrli.d(

  // __lasx_xvsrlr_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvsrlr_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrlr.b(

  // __lasx_xvsrlr_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvsrlr_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrlr.h(

  // __lasx_xvsrlr_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvsrlr_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrlr.w(

  // __lasx_xvsrlr_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsrlr_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrlr.d(

  // __lasx_xvsrlri_b
  // xd, xj, ui3
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvsrlri_b(v32i8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrlri.b(

  // __lasx_xvsrlri_h
  // xd, xj, ui4
  // V16HI, V16HI, UQI
  v16i16_r = __lasx_xvsrlri_h(v16i16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrlri.h(

  // __lasx_xvsrlri_w
  // xd, xj, ui5
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvsrlri_w(v8i32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrlri.w(

  // __lasx_xvsrlri_d
  // xd, xj, ui6
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvsrlri_d(v4i64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrlri.d(

  // __lasx_xvbitclr_b
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvbitclr_b(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvbitclr.b(

  // __lasx_xvbitclr_h
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvbitclr_h(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvbitclr.h(

  // __lasx_xvbitclr_w
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvbitclr_w(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvbitclr.w(

  // __lasx_xvbitclr_d
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvbitclr_d(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvbitclr.d(

  // __lasx_xvbitclri_b
  // xd, xj, ui3
  // UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvbitclri_b(v32u8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvbitclri.b(

  // __lasx_xvbitclri_h
  // xd, xj, ui4
  // UV16HI, UV16HI, UQI
  v16u16_r = __lasx_xvbitclri_h(v16u16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvbitclri.h(

  // __lasx_xvbitclri_w
  // xd, xj, ui5
  // UV8SI, UV8SI, UQI
  v8u32_r = __lasx_xvbitclri_w(v8u32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvbitclri.w(

  // __lasx_xvbitclri_d
  // xd, xj, ui6
  // UV4DI, UV4DI, UQI
  v4u64_r = __lasx_xvbitclri_d(v4u64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvbitclri.d(

  // __lasx_xvbitset_b
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvbitset_b(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvbitset.b(

  // __lasx_xvbitset_h
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvbitset_h(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvbitset.h(

  // __lasx_xvbitset_w
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvbitset_w(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvbitset.w(

  // __lasx_xvbitset_d
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvbitset_d(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvbitset.d(

  // __lasx_xvbitseti_b
  // xd, xj, ui3
  // UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvbitseti_b(v32u8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvbitseti.b(

  // __lasx_xvbitseti_h
  // xd, xj, ui4
  // UV16HI, UV16HI, UQI
  v16u16_r = __lasx_xvbitseti_h(v16u16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvbitseti.h(

  // __lasx_xvbitseti_w
  // xd, xj, ui5
  // UV8SI, UV8SI, UQI
  v8u32_r = __lasx_xvbitseti_w(v8u32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvbitseti.w(

  // __lasx_xvbitseti_d
  // xd, xj, ui6
  // UV4DI, UV4DI, UQI
  v4u64_r = __lasx_xvbitseti_d(v4u64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvbitseti.d(

  // __lasx_xvbitrev_b
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvbitrev_b(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvbitrev.b(

  // __lasx_xvbitrev_h
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvbitrev_h(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvbitrev.h(

  // __lasx_xvbitrev_w
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvbitrev_w(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvbitrev.w(

  // __lasx_xvbitrev_d
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvbitrev_d(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvbitrev.d(

  // __lasx_xvbitrevi_b
  // xd, xj, ui3
  // UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvbitrevi_b(v32u8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvbitrevi.b(

  // __lasx_xvbitrevi_h
  // xd, xj, ui4
  // UV16HI, UV16HI, UQI
  v16u16_r = __lasx_xvbitrevi_h(v16u16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvbitrevi.h(

  // __lasx_xvbitrevi_w
  // xd, xj, ui5
  // UV8SI, UV8SI, UQI
  v8u32_r = __lasx_xvbitrevi_w(v8u32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvbitrevi.w(

  // __lasx_xvbitrevi_d
  // xd, xj, ui6
  // UV4DI, UV4DI, UQI
  v4u64_r = __lasx_xvbitrevi_d(v4u64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvbitrevi.d(

  // __lasx_xvadd_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvadd_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvadd.b(

  // __lasx_xvadd_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvadd_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvadd.h(

  // __lasx_xvadd_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvadd_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvadd.w(

  // __lasx_xvadd_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvadd_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvadd.d(

  // __lasx_xvaddi_bu
  // xd, xj, ui5
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvaddi_bu(v32i8_a, ui5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvaddi.bu(

  // __lasx_xvaddi_hu
  // xd, xj, ui5
  // V16HI, V16HI, UQI
  v16i16_r = __lasx_xvaddi_hu(v16i16_a, ui5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvaddi.hu(

  // __lasx_xvaddi_wu
  // xd, xj, ui5
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvaddi_wu(v8i32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvaddi.wu(

  // __lasx_xvaddi_du
  // xd, xj, ui5
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvaddi_du(v4i64_a, ui5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddi.du(

  // __lasx_xvsub_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvsub_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsub.b(

  // __lasx_xvsub_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvsub_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsub.h(

  // __lasx_xvsub_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvsub_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsub.w(

  // __lasx_xvsub_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsub_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsub.d(

  // __lasx_xvsubi_bu
  // xd, xj, ui5
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvsubi_bu(v32i8_a, ui5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsubi.bu(

  // __lasx_xvsubi_hu
  // xd, xj, ui5
  // V16HI, V16HI, UQI
  v16i16_r = __lasx_xvsubi_hu(v16i16_a, ui5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsubi.hu(

  // __lasx_xvsubi_wu
  // xd, xj, ui5
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvsubi_wu(v8i32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsubi.wu(

  // __lasx_xvsubi_du
  // xd, xj, ui5
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvsubi_du(v4i64_a, ui5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsubi.du(

  // __lasx_xvmax_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvmax_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmax.b(

  // __lasx_xvmax_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvmax_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmax.h(

  // __lasx_xvmax_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvmax_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmax.w(

  // __lasx_xvmax_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmax_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmax.d(

  // __lasx_xvmaxi_b
  // xd, xj, si5
  // V32QI, V32QI, QI
  v32i8_r = __lasx_xvmaxi_b(v32i8_a, si5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmaxi.b(

  // __lasx_xvmaxi_h
  // xd, xj, si5
  // V16HI, V16HI, QI
  v16i16_r = __lasx_xvmaxi_h(v16i16_a, si5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmaxi.h(

  // __lasx_xvmaxi_w
  // xd, xj, si5
  // V8SI, V8SI, QI
  v8i32_r = __lasx_xvmaxi_w(v8i32_a, si5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmaxi.w(

  // __lasx_xvmaxi_d
  // xd, xj, si5
  // V4DI, V4DI, QI
  v4i64_r = __lasx_xvmaxi_d(v4i64_a, si5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaxi.d(

  // __lasx_xvmax_bu
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvmax_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmax.bu(

  // __lasx_xvmax_hu
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvmax_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmax.hu(

  // __lasx_xvmax_wu
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvmax_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmax.wu(

  // __lasx_xvmax_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvmax_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmax.du(

  // __lasx_xvmaxi_bu
  // xd, xj, ui5
  // UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvmaxi_bu(v32u8_a, ui5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmaxi.bu(

  // __lasx_xvmaxi_hu
  // xd, xj, ui5
  // UV16HI, UV16HI, UQI
  v16u16_r = __lasx_xvmaxi_hu(v16u16_a, ui5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmaxi.hu(

  // __lasx_xvmaxi_wu
  // xd, xj, ui5
  // UV8SI, UV8SI, UQI
  v8u32_r = __lasx_xvmaxi_wu(v8u32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmaxi.wu(

  // __lasx_xvmaxi_du
  // xd, xj, ui5
  // UV4DI, UV4DI, UQI
  v4u64_r = __lasx_xvmaxi_du(v4u64_a, ui5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaxi.du(

  // __lasx_xvmin_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvmin_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmin.b(

  // __lasx_xvmin_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvmin_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmin.h(

  // __lasx_xvmin_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvmin_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmin.w(

  // __lasx_xvmin_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmin_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmin.d(

  // __lasx_xvmini_b
  // xd, xj, si5
  // V32QI, V32QI, QI
  v32i8_r = __lasx_xvmini_b(v32i8_a, si5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmini.b(

  // __lasx_xvmini_h
  // xd, xj, si5
  // V16HI, V16HI, QI
  v16i16_r = __lasx_xvmini_h(v16i16_a, si5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmini.h(

  // __lasx_xvmini_w
  // xd, xj, si5
  // V8SI, V8SI, QI
  v8i32_r = __lasx_xvmini_w(v8i32_a, si5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmini.w(

  // __lasx_xvmini_d
  // xd, xj, si5
  // V4DI, V4DI, QI
  v4i64_r = __lasx_xvmini_d(v4i64_a, si5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmini.d(

  // __lasx_xvmin_bu
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvmin_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmin.bu(

  // __lasx_xvmin_hu
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvmin_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmin.hu(

  // __lasx_xvmin_wu
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvmin_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmin.wu(

  // __lasx_xvmin_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvmin_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmin.du(

  // __lasx_xvmini_bu
  // xd, xj, ui5
  // UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvmini_bu(v32u8_a, ui5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmini.bu(

  // __lasx_xvmini_hu
  // xd, xj, ui5
  // UV16HI, UV16HI, UQI
  v16u16_r = __lasx_xvmini_hu(v16u16_a, ui5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmini.hu(

  // __lasx_xvmini_wu
  // xd, xj, ui5
  // UV8SI, UV8SI, UQI
  v8u32_r = __lasx_xvmini_wu(v8u32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmini.wu(

  // __lasx_xvmini_du
  // xd, xj, ui5
  // UV4DI, UV4DI, UQI
  v4u64_r = __lasx_xvmini_du(v4u64_a, ui5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmini.du(

  // __lasx_xvseq_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvseq_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvseq.b(

  // __lasx_xvseq_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvseq_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvseq.h(

  // __lasx_xvseq_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvseq_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvseq.w(

  // __lasx_xvseq_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvseq_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvseq.d(

  // __lasx_xvseqi_b
  // xd, xj, si5
  // V32QI, V32QI, QI
  v32i8_r = __lasx_xvseqi_b(v32i8_a, si5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvseqi.b(

  // __lasx_xvseqi_h
  // xd, xj, si5
  // V16HI, V16HI, QI
  v16i16_r = __lasx_xvseqi_h(v16i16_a, si5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvseqi.h(

  // __lasx_xvseqi_w
  // xd, xj, si5
  // V8SI, V8SI, QI
  v8i32_r = __lasx_xvseqi_w(v8i32_a, si5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvseqi.w(

  // __lasx_xvseqi_d
  // xd, xj, si5
  // V4DI, V4DI, QI
  v4i64_r = __lasx_xvseqi_d(v4i64_a, si5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvseqi.d(

  // __lasx_xvslt_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvslt_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvslt.b(

  // __lasx_xvslt_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvslt_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvslt.h(

  // __lasx_xvslt_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvslt_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvslt.w(

  // __lasx_xvslt_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvslt_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvslt.d(

  // __lasx_xvslti_b
  // xd, xj, si5
  // V32QI, V32QI, QI
  v32i8_r = __lasx_xvslti_b(v32i8_a, si5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvslti.b(

  // __lasx_xvslti_h
  // xd, xj, si5
  // V16HI, V16HI, QI
  v16i16_r = __lasx_xvslti_h(v16i16_a, si5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvslti.h(

  // __lasx_xvslti_w
  // xd, xj, si5
  // V8SI, V8SI, QI
  v8i32_r = __lasx_xvslti_w(v8i32_a, si5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvslti.w(

  // __lasx_xvslti_d
  // xd, xj, si5
  // V4DI, V4DI, QI
  v4i64_r = __lasx_xvslti_d(v4i64_a, si5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvslti.d(

  // __lasx_xvslt_bu
  // xd, xj, xk
  // V32QI, UV32QI, UV32QI
  v32i8_r = __lasx_xvslt_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvslt.bu(

  // __lasx_xvslt_hu
  // xd, xj, xk
  // V16HI, UV16HI, UV16HI
  v16i16_r = __lasx_xvslt_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvslt.hu(

  // __lasx_xvslt_wu
  // xd, xj, xk
  // V8SI, UV8SI, UV8SI
  v8i32_r = __lasx_xvslt_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvslt.wu(

  // __lasx_xvslt_du
  // xd, xj, xk
  // V4DI, UV4DI, UV4DI
  v4i64_r = __lasx_xvslt_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvslt.du(

  // __lasx_xvslti_bu
  // xd, xj, ui5
  // V32QI, UV32QI, UQI
  v32i8_r = __lasx_xvslti_bu(v32u8_a, ui5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvslti.bu(

  // __lasx_xvslti_hu
  // xd, xj, ui5
  // V16HI, UV16HI, UQI
  v16i16_r = __lasx_xvslti_hu(v16u16_a, ui5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvslti.hu(

  // __lasx_xvslti_wu
  // xd, xj, ui5
  // V8SI, UV8SI, UQI
  v8i32_r = __lasx_xvslti_wu(v8u32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvslti.wu(

  // __lasx_xvslti_du
  // xd, xj, ui5
  // V4DI, UV4DI, UQI
  v4i64_r = __lasx_xvslti_du(v4u64_a, ui5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvslti.du(

  // __lasx_xvsle_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvsle_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsle.b(

  // __lasx_xvsle_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvsle_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsle.h(

  // __lasx_xvsle_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvsle_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsle.w(

  // __lasx_xvsle_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsle_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsle.d(

  // __lasx_xvslei_b
  // xd, xj, si5
  // V32QI, V32QI, QI
  v32i8_r = __lasx_xvslei_b(v32i8_a, si5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvslei.b(

  // __lasx_xvslei_h
  // xd, xj, si5
  // V16HI, V16HI, QI
  v16i16_r = __lasx_xvslei_h(v16i16_a, si5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvslei.h(

  // __lasx_xvslei_w
  // xd, xj, si5
  // V8SI, V8SI, QI
  v8i32_r = __lasx_xvslei_w(v8i32_a, si5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvslei.w(

  // __lasx_xvslei_d
  // xd, xj, si5
  // V4DI, V4DI, QI
  v4i64_r = __lasx_xvslei_d(v4i64_a, si5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvslei.d(

  // __lasx_xvsle_bu
  // xd, xj, xk
  // V32QI, UV32QI, UV32QI
  v32i8_r = __lasx_xvsle_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsle.bu(

  // __lasx_xvsle_hu
  // xd, xj, xk
  // V16HI, UV16HI, UV16HI
  v16i16_r = __lasx_xvsle_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsle.hu(

  // __lasx_xvsle_wu
  // xd, xj, xk
  // V8SI, UV8SI, UV8SI
  v8i32_r = __lasx_xvsle_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsle.wu(

  // __lasx_xvsle_du
  // xd, xj, xk
  // V4DI, UV4DI, UV4DI
  v4i64_r = __lasx_xvsle_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsle.du(

  // __lasx_xvslei_bu
  // xd, xj, ui5
  // V32QI, UV32QI, UQI
  v32i8_r = __lasx_xvslei_bu(v32u8_a, ui5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvslei.bu(

  // __lasx_xvslei_hu
  // xd, xj, ui5
  // V16HI, UV16HI, UQI
  v16i16_r = __lasx_xvslei_hu(v16u16_a, ui5_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvslei.hu(

  // __lasx_xvslei_wu
  // xd, xj, ui5
  // V8SI, UV8SI, UQI
  v8i32_r = __lasx_xvslei_wu(v8u32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvslei.wu(

  // __lasx_xvslei_du
  // xd, xj, ui5
  // V4DI, UV4DI, UQI
  v4i64_r = __lasx_xvslei_du(v4u64_a, ui5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvslei.du(

  // __lasx_xvsat_b
  // xd, xj, ui3
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvsat_b(v32i8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsat.b(

  // __lasx_xvsat_h
  // xd, xj, ui4
  // V16HI, V16HI, UQI
  v16i16_r = __lasx_xvsat_h(v16i16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsat.h(

  // __lasx_xvsat_w
  // xd, xj, ui5
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvsat_w(v8i32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsat.w(

  // __lasx_xvsat_d
  // xd, xj, ui6
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvsat_d(v4i64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsat.d(

  // __lasx_xvsat_bu
  // xd, xj, ui3
  // UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvsat_bu(v32u8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsat.bu(

  // __lasx_xvsat_hu
  // xd, xj, ui4
  // UV16HI, UV16HI, UQI
  v16u16_r = __lasx_xvsat_hu(v16u16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsat.hu(

  // __lasx_xvsat_wu
  // xd, xj, ui5
  // UV8SI, UV8SI, UQI
  v8u32_r = __lasx_xvsat_wu(v8u32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsat.wu(

  // __lasx_xvsat_du
  // xd, xj, ui6
  // UV4DI, UV4DI, UQI
  v4u64_r = __lasx_xvsat_du(v4u64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsat.du(

  // __lasx_xvadda_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvadda_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvadda.b(

  // __lasx_xvadda_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvadda_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvadda.h(

  // __lasx_xvadda_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvadda_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvadda.w(

  // __lasx_xvadda_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvadda_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvadda.d(

  // __lasx_xvsadd_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvsadd_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsadd.b(

  // __lasx_xvsadd_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvsadd_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsadd.h(

  // __lasx_xvsadd_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvsadd_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsadd.w(

  // __lasx_xvsadd_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsadd_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsadd.d(

  // __lasx_xvsadd_bu
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvsadd_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsadd.bu(

  // __lasx_xvsadd_hu
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvsadd_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsadd.hu(

  // __lasx_xvsadd_wu
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvsadd_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsadd.wu(

  // __lasx_xvsadd_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvsadd_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsadd.du(

  // __lasx_xvavg_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvavg_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvavg.b(

  // __lasx_xvavg_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvavg_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvavg.h(

  // __lasx_xvavg_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvavg_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvavg.w(

  // __lasx_xvavg_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvavg_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvavg.d(

  // __lasx_xvavg_bu
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvavg_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvavg.bu(

  // __lasx_xvavg_hu
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvavg_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvavg.hu(

  // __lasx_xvavg_wu
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvavg_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvavg.wu(

  // __lasx_xvavg_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvavg_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvavg.du(

  // __lasx_xvavgr_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvavgr_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvavgr.b(

  // __lasx_xvavgr_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvavgr_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvavgr.h(

  // __lasx_xvavgr_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvavgr_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvavgr.w(

  // __lasx_xvavgr_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvavgr_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvavgr.d(

  // __lasx_xvavgr_bu
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvavgr_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvavgr.bu(

  // __lasx_xvavgr_hu
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvavgr_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvavgr.hu(

  // __lasx_xvavgr_wu
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvavgr_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvavgr.wu(

  // __lasx_xvavgr_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvavgr_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvavgr.du(

  // __lasx_xvssub_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvssub_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssub.b(

  // __lasx_xvssub_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvssub_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssub.h(

  // __lasx_xvssub_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvssub_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssub.w(

  // __lasx_xvssub_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvssub_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvssub.d(

  // __lasx_xvssub_bu
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvssub_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssub.bu(

  // __lasx_xvssub_hu
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvssub_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssub.hu(

  // __lasx_xvssub_wu
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvssub_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssub.wu(

  // __lasx_xvssub_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvssub_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvssub.du(

  // __lasx_xvabsd_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvabsd_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvabsd.b(

  // __lasx_xvabsd_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvabsd_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvabsd.h(

  // __lasx_xvabsd_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvabsd_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvabsd.w(

  // __lasx_xvabsd_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvabsd_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvabsd.d(

  // __lasx_xvabsd_bu
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvabsd_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvabsd.bu(

  // __lasx_xvabsd_hu
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvabsd_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvabsd.hu(

  // __lasx_xvabsd_wu
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvabsd_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvabsd.wu(

  // __lasx_xvabsd_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvabsd_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvabsd.du(

  // __lasx_xvmul_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvmul_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmul.b(

  // __lasx_xvmul_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvmul_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmul.h(

  // __lasx_xvmul_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvmul_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmul.w(

  // __lasx_xvmul_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmul_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmul.d(

  // __lasx_xvmadd_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvmadd_b(v32i8_a, v32i8_b, v32i8_c); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmadd.b(

  // __lasx_xvmadd_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvmadd_h(v16i16_a, v16i16_b, v16i16_c); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmadd.h(

  // __lasx_xvmadd_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvmadd_w(v8i32_a, v8i32_b, v8i32_c); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmadd.w(

  // __lasx_xvmadd_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmadd_d(v4i64_a, v4i64_b, v4i64_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmadd.d(

  // __lasx_xvmsub_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvmsub_b(v32i8_a, v32i8_b, v32i8_c); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmsub.b(

  // __lasx_xvmsub_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvmsub_h(v16i16_a, v16i16_b, v16i16_c); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmsub.h(

  // __lasx_xvmsub_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvmsub_w(v8i32_a, v8i32_b, v8i32_c); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmsub.w(

  // __lasx_xvmsub_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmsub_d(v4i64_a, v4i64_b, v4i64_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmsub.d(

  // __lasx_xvdiv_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvdiv_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvdiv.b(

  // __lasx_xvdiv_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvdiv_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvdiv.h(

  // __lasx_xvdiv_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvdiv_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvdiv.w(

  // __lasx_xvdiv_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvdiv_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvdiv.d(

  // __lasx_xvdiv_bu
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvdiv_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvdiv.bu(

  // __lasx_xvdiv_hu
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvdiv_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvdiv.hu(

  // __lasx_xvdiv_wu
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvdiv_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvdiv.wu(

  // __lasx_xvdiv_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvdiv_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvdiv.du(

  // __lasx_xvhaddw_h_b
  // xd, xj, xk
  // V16HI, V32QI, V32QI
  v16i16_r = __lasx_xvhaddw_h_b(v32i8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvhaddw.h.b(

  // __lasx_xvhaddw_w_h
  // xd, xj, xk
  // V8SI, V16HI, V16HI
  v8i32_r = __lasx_xvhaddw_w_h(v16i16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvhaddw.w.h(

  // __lasx_xvhaddw_d_w
  // xd, xj, xk
  // V4DI, V8SI, V8SI
  v4i64_r = __lasx_xvhaddw_d_w(v8i32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvhaddw.d.w(

  // __lasx_xvhaddw_hu_bu
  // xd, xj, xk
  // UV16HI, UV32QI, UV32QI
  v16u16_r = __lasx_xvhaddw_hu_bu(v32u8_a, v32u8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvhaddw.hu.bu(

  // __lasx_xvhaddw_wu_hu
  // xd, xj, xk
  // UV8SI, UV16HI, UV16HI
  v8u32_r = __lasx_xvhaddw_wu_hu(v16u16_a, v16u16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvhaddw.wu.hu(

  // __lasx_xvhaddw_du_wu
  // xd, xj, xk
  // UV4DI, UV8SI, UV8SI
  v4u64_r = __lasx_xvhaddw_du_wu(v8u32_a, v8u32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvhaddw.du.wu(

  // __lasx_xvhsubw_h_b
  // xd, xj, xk
  // V16HI, V32QI, V32QI
  v16i16_r = __lasx_xvhsubw_h_b(v32i8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvhsubw.h.b(

  // __lasx_xvhsubw_w_h
  // xd, xj, xk
  // V8SI, V16HI, V16HI
  v8i32_r = __lasx_xvhsubw_w_h(v16i16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvhsubw.w.h(

  // __lasx_xvhsubw_d_w
  // xd, xj, xk
  // V4DI, V8SI, V8SI
  v4i64_r = __lasx_xvhsubw_d_w(v8i32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvhsubw.d.w(

  // __lasx_xvhsubw_hu_bu
  // xd, xj, xk
  // V16HI, UV32QI, UV32QI
  v16i16_r = __lasx_xvhsubw_hu_bu(v32u8_a, v32u8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvhsubw.hu.bu(

  // __lasx_xvhsubw_wu_hu
  // xd, xj, xk
  // V8SI, UV16HI, UV16HI
  v8i32_r = __lasx_xvhsubw_wu_hu(v16u16_a, v16u16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvhsubw.wu.hu(

  // __lasx_xvhsubw_du_wu
  // xd, xj, xk
  // V4DI, UV8SI, UV8SI
  v4i64_r = __lasx_xvhsubw_du_wu(v8u32_a, v8u32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvhsubw.du.wu(

  // __lasx_xvmod_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvmod_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmod.b(

  // __lasx_xvmod_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvmod_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmod.h(

  // __lasx_xvmod_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvmod_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmod.w(

  // __lasx_xvmod_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmod_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmod.d(

  // __lasx_xvmod_bu
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvmod_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmod.bu(

  // __lasx_xvmod_hu
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvmod_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmod.hu(

  // __lasx_xvmod_wu
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvmod_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmod.wu(

  // __lasx_xvmod_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvmod_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmod.du(

  // __lasx_xvrepl128vei_b
  // xd, xj, ui4
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvrepl128vei_b(v32i8_a, ui4_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvrepl128vei.b(

  // __lasx_xvrepl128vei_h
  // xd, xj, ui3
  // V16HI, V16HI, UQI
  v16i16_r = __lasx_xvrepl128vei_h(v16i16_a, ui3_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvrepl128vei.h(

  // __lasx_xvrepl128vei_w
  // xd, xj, ui2
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvrepl128vei_w(v8i32_a, ui2_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvrepl128vei.w(

  // __lasx_xvrepl128vei_d
  // xd, xj, ui1
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvrepl128vei_d(v4i64_a, ui1_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvrepl128vei.d(

  // __lasx_xvpickev_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvpickev_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvpickev.b(

  // __lasx_xvpickev_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvpickev_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvpickev.h(

  // __lasx_xvpickev_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvpickev_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvpickev.w(

  // __lasx_xvpickev_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvpickev_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvpickev.d(

  // __lasx_xvpickod_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvpickod_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvpickod.b(

  // __lasx_xvpickod_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvpickod_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvpickod.h(

  // __lasx_xvpickod_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvpickod_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvpickod.w(

  // __lasx_xvpickod_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvpickod_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvpickod.d(

  // __lasx_xvilvh_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvilvh_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvilvh.b(

  // __lasx_xvilvh_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvilvh_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvilvh.h(

  // __lasx_xvilvh_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvilvh_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvilvh.w(

  // __lasx_xvilvh_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvilvh_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvilvh.d(

  // __lasx_xvilvl_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvilvl_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvilvl.b(

  // __lasx_xvilvl_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvilvl_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvilvl.h(

  // __lasx_xvilvl_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvilvl_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvilvl.w(

  // __lasx_xvilvl_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvilvl_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvilvl.d(

  // __lasx_xvpackev_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvpackev_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvpackev.b(

  // __lasx_xvpackev_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvpackev_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvpackev.h(

  // __lasx_xvpackev_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvpackev_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvpackev.w(

  // __lasx_xvpackev_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvpackev_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvpackev.d(

  // __lasx_xvpackod_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvpackod_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvpackod.b(

  // __lasx_xvpackod_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvpackod_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvpackod.h(

  // __lasx_xvpackod_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvpackod_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvpackod.w(

  // __lasx_xvpackod_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvpackod_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvpackod.d(

  // __lasx_xvshuf_b
  // xd, xj, xk, xa
  // V32QI, V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvshuf_b(v32i8_a, v32i8_b, v32i8_c); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvshuf.b(

  // __lasx_xvshuf_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvshuf_h(v16i16_a, v16i16_b, v16i16_c); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvshuf.h(

  // __lasx_xvshuf_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvshuf_w(v8i32_a, v8i32_b, v8i32_c); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvshuf.w(

  // __lasx_xvshuf_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvshuf_d(v4i64_a, v4i64_b, v4i64_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvshuf.d(

  // __lasx_xvand_v
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvand_v(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvand.v(

  // __lasx_xvandi_b
  // xd, xj, ui8
  // UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvandi_b(v32u8_a, ui8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvandi.b(

  // __lasx_xvor_v
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvor_v(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvor.v(

  // __lasx_xvori_b
  // xd, xj, ui8
  // UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvori_b(v32u8_a, ui8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvori.b(

  // __lasx_xvnor_v
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvnor_v(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvnor.v(

  // __lasx_xvnori_b
  // xd, xj, ui8
  // UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvnori_b(v32u8_a, ui8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvnori.b(

  // __lasx_xvxor_v
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvxor_v(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvxor.v(

  // __lasx_xvxori_b
  // xd, xj, ui8
  // UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvxori_b(v32u8_a, ui8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvxori.b(

  // __lasx_xvbitsel_v
  // xd, xj, xk, xa
  // UV32QI, UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvbitsel_v(v32u8_a, v32u8_b, v32u8_c); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvbitsel.v(

  // __lasx_xvbitseli_b
  // xd, xj, ui8
  // UV32QI, UV32QI, UV32QI, UQI
  v32u8_r = __lasx_xvbitseli_b(v32u8_a, v32u8_b, ui8); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvbitseli.b(

  // __lasx_xvshuf4i_b
  // xd, xj, ui8
  // V32QI, V32QI, USI
  v32i8_r = __lasx_xvshuf4i_b(v32i8_a, ui8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvshuf4i.b(

  // __lasx_xvshuf4i_h
  // xd, xj, ui8
  // V16HI, V16HI, USI
  v16i16_r = __lasx_xvshuf4i_h(v16i16_a, ui8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvshuf4i.h(

  // __lasx_xvshuf4i_w
  // xd, xj, ui8
  // V8SI, V8SI, USI
  v8i32_r = __lasx_xvshuf4i_w(v8i32_a, ui8_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvshuf4i.w(

  // __lasx_xvreplgr2vr_b
  // xd, rj
  // V32QI, SI
  v32i8_r = __lasx_xvreplgr2vr_b(i32_a); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvreplgr2vr.b(

  // __lasx_xvreplgr2vr_h
  // xd, rj
  // V16HI, SI
  v16i16_r = __lasx_xvreplgr2vr_h(i32_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvreplgr2vr.h(

  // __lasx_xvreplgr2vr_w
  // xd, rj
  // V8SI, SI
  v8i32_r = __lasx_xvreplgr2vr_w(i32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvreplgr2vr.w(

  // __lasx_xvreplgr2vr_d
  // xd, rj
  // V4DI, DI
  v4i64_r = __lasx_xvreplgr2vr_d(i64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvreplgr2vr.d(

  // __lasx_xvpcnt_b
  // xd, xj
  // V32QI, V32QI
  v32i8_r = __lasx_xvpcnt_b(v32i8_a); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvpcnt.b(

  // __lasx_xvpcnt_h
  // xd, xj
  // V16HI, V16HI
  v16i16_r = __lasx_xvpcnt_h(v16i16_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvpcnt.h(

  // __lasx_xvpcnt_w
  // xd, xj
  // V8SI, V8SI
  v8i32_r = __lasx_xvpcnt_w(v8i32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvpcnt.w(

  // __lasx_xvpcnt_d
  // xd, xj
  // V4DI, V4DI
  v4i64_r = __lasx_xvpcnt_d(v4i64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvpcnt.d(

  // __lasx_xvclo_b
  // xd, xj
  // V32QI, V32QI
  v32i8_r = __lasx_xvclo_b(v32i8_a); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvclo.b(

  // __lasx_xvclo_h
  // xd, xj
  // V16HI, V16HI
  v16i16_r = __lasx_xvclo_h(v16i16_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvclo.h(

  // __lasx_xvclo_w
  // xd, xj
  // V8SI, V8SI
  v8i32_r = __lasx_xvclo_w(v8i32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvclo.w(

  // __lasx_xvclo_d
  // xd, xj
  // V4DI, V4DI
  v4i64_r = __lasx_xvclo_d(v4i64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvclo.d(

  // __lasx_xvclz_b
  // xd, xj
  // V32QI, V32QI
  v32i8_r = __lasx_xvclz_b(v32i8_a); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvclz.b(

  // __lasx_xvclz_h
  // xd, xj
  // V16HI, V16HI
  v16i16_r = __lasx_xvclz_h(v16i16_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvclz.h(

  // __lasx_xvclz_w
  // xd, xj
  // V8SI, V8SI
  v8i32_r = __lasx_xvclz_w(v8i32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvclz.w(

  // __lasx_xvclz_d
  // xd, xj
  // V4DI, V4DI
  v4i64_r = __lasx_xvclz_d(v4i64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvclz.d(

  // __lasx_xvfcmp_caf_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_caf_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.caf.s(

  // __lasx_xvfcmp_caf_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_caf_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.caf.d(

  // __lasx_xvfcmp_cor_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_cor_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.cor.s(

  // __lasx_xvfcmp_cor_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_cor_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.cor.d(

  // __lasx_xvfcmp_cun_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_cun_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.cun.s(

  // __lasx_xvfcmp_cun_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_cun_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.cun.d(

  // __lasx_xvfcmp_cune_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_cune_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.cune.s(

  // __lasx_xvfcmp_cune_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_cune_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.cune.d(

  // __lasx_xvfcmp_cueq_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_cueq_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.cueq.s(

  // __lasx_xvfcmp_cueq_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_cueq_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.cueq.d(

  // __lasx_xvfcmp_ceq_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_ceq_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.ceq.s(

  // __lasx_xvfcmp_ceq_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_ceq_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.ceq.d(

  // __lasx_xvfcmp_cne_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_cne_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.cne.s(

  // __lasx_xvfcmp_cne_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_cne_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.cne.d(

  // __lasx_xvfcmp_clt_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_clt_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.clt.s(

  // __lasx_xvfcmp_clt_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_clt_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.clt.d(

  // __lasx_xvfcmp_cult_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_cult_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.cult.s(

  // __lasx_xvfcmp_cult_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_cult_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.cult.d(

  // __lasx_xvfcmp_cle_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_cle_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.cle.s(

  // __lasx_xvfcmp_cle_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_cle_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.cle.d(

  // __lasx_xvfcmp_cule_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_cule_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.cule.s(

  // __lasx_xvfcmp_cule_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_cule_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.cule.d(

  // __lasx_xvfcmp_saf_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_saf_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.saf.s(

  // __lasx_xvfcmp_saf_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_saf_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.saf.d(

  // __lasx_xvfcmp_sor_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_sor_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.sor.s(

  // __lasx_xvfcmp_sor_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_sor_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.sor.d(

  // __lasx_xvfcmp_sun_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_sun_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.sun.s(

  // __lasx_xvfcmp_sun_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_sun_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.sun.d(

  // __lasx_xvfcmp_sune_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_sune_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.sune.s(

  // __lasx_xvfcmp_sune_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_sune_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.sune.d(

  // __lasx_xvfcmp_sueq_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_sueq_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.sueq.s(

  // __lasx_xvfcmp_sueq_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_sueq_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.sueq.d(

  // __lasx_xvfcmp_seq_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_seq_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.seq.s(

  // __lasx_xvfcmp_seq_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_seq_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.seq.d(

  // __lasx_xvfcmp_sne_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_sne_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.sne.s(

  // __lasx_xvfcmp_sne_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_sne_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.sne.d(

  // __lasx_xvfcmp_slt_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_slt_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.slt.s(

  // __lasx_xvfcmp_slt_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_slt_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.slt.d(

  // __lasx_xvfcmp_sult_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_sult_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.sult.s(

  // __lasx_xvfcmp_sult_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_sult_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.sult.d(

  // __lasx_xvfcmp_sle_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_sle_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.sle.s(

  // __lasx_xvfcmp_sle_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_sle_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.sle.d(

  // __lasx_xvfcmp_sule_s
  // xd, xj, xk
  // V8SI, V8SF, V8SF
  v8i32_r = __lasx_xvfcmp_sule_s(v8f32_a, v8f32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfcmp.sule.s(

  // __lasx_xvfcmp_sule_d
  // xd, xj, xk
  // V4DI, V4DF, V4DF
  v4i64_r = __lasx_xvfcmp_sule_d(v4f64_a, v4f64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfcmp.sule.d(

  // __lasx_xvfadd_s
  // xd, xj, xk
  // V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfadd_s(v8f32_a, v8f32_b); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfadd.s(

  // __lasx_xvfadd_d
  // xd, xj, xk
  // V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfadd_d(v4f64_a, v4f64_b); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfadd.d(

  // __lasx_xvfsub_s
  // xd, xj, xk
  // V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfsub_s(v8f32_a, v8f32_b); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfsub.s(

  // __lasx_xvfsub_d
  // xd, xj, xk
  // V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfsub_d(v4f64_a, v4f64_b); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfsub.d(

  // __lasx_xvfmul_s
  // xd, xj, xk
  // V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfmul_s(v8f32_a, v8f32_b); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfmul.s(

  // __lasx_xvfmul_d
  // xd, xj, xk
  // V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfmul_d(v4f64_a, v4f64_b); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfmul.d(

  // __lasx_xvfdiv_s
  // xd, xj, xk
  // V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfdiv_s(v8f32_a, v8f32_b); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfdiv.s(

  // __lasx_xvfdiv_d
  // xd, xj, xk
  // V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfdiv_d(v4f64_a, v4f64_b); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfdiv.d(

  // __lasx_xvfcvt_h_s
  // xd, xj, xk
  // V16HI, V8SF, V8SF
  v16i16_r = __lasx_xvfcvt_h_s(v8f32_a, v8f32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvfcvt.h.s(

  // __lasx_xvfcvt_s_d
  // xd, xj, xk
  // V8SF, V4DF, V4DF
  v8f32_r = __lasx_xvfcvt_s_d(v4f64_a, v4f64_b); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfcvt.s.d(

  // __lasx_xvfmin_s
  // xd, xj, xk
  // V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfmin_s(v8f32_a, v8f32_b); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfmin.s(

  // __lasx_xvfmin_d
  // xd, xj, xk
  // V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfmin_d(v4f64_a, v4f64_b); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfmin.d(

  // __lasx_xvfmina_s
  // xd, xj, xk
  // V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfmina_s(v8f32_a, v8f32_b); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfmina.s(

  // __lasx_xvfmina_d
  // xd, xj, xk
  // V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfmina_d(v4f64_a, v4f64_b); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfmina.d(

  // __lasx_xvfmax_s
  // xd, xj, xk
  // V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfmax_s(v8f32_a, v8f32_b); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfmax.s(

  // __lasx_xvfmax_d
  // xd, xj, xk
  // V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfmax_d(v4f64_a, v4f64_b); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfmax.d(

  // __lasx_xvfmaxa_s
  // xd, xj, xk
  // V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfmaxa_s(v8f32_a, v8f32_b); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfmaxa.s(

  // __lasx_xvfmaxa_d
  // xd, xj, xk
  // V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfmaxa_d(v4f64_a, v4f64_b); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfmaxa.d(

  // __lasx_xvfclass_s
  // xd, xj
  // V8SI, V8SF
  v8i32_r = __lasx_xvfclass_s(v8f32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvfclass.s(

  // __lasx_xvfclass_d
  // xd, xj
  // V4DI, V4DF
  v4i64_r = __lasx_xvfclass_d(v4f64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvfclass.d(

  // __lasx_xvfsqrt_s
  // xd, xj
  // V8SF, V8SF
  v8f32_r = __lasx_xvfsqrt_s(v8f32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfsqrt.s(

  // __lasx_xvfsqrt_d
  // xd, xj
  // V4DF, V4DF
  v4f64_r = __lasx_xvfsqrt_d(v4f64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfsqrt.d(

  // __lasx_xvfrecip_s
  // xd, xj
  // V8SF, V8SF
  v8f32_r = __lasx_xvfrecip_s(v8f32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfrecip.s(

  // __lasx_xvfrecip_d
  // xd, xj
  // V4DF, V4DF
  v4f64_r = __lasx_xvfrecip_d(v4f64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfrecip.d(

  // __lasx_xvfrint_s
  // xd, xj
  // V8SF, V8SF
  v8f32_r = __lasx_xvfrint_s(v8f32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfrint.s(

  // __lasx_xvfrint_d
  // xd, xj
  // V4DF, V4DF
  v4f64_r = __lasx_xvfrint_d(v4f64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfrint.d(

  // __lasx_xvfrsqrt_s
  // xd, xj
  // V8SF, V8SF
  v8f32_r = __lasx_xvfrsqrt_s(v8f32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfrsqrt.s(

  // __lasx_xvfrsqrt_d
  // xd, xj
  // V4DF, V4DF
  v4f64_r = __lasx_xvfrsqrt_d(v4f64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfrsqrt.d(

  // __lasx_xvflogb_s
  // xd, xj
  // V8SF, V8SF
  v8f32_r = __lasx_xvflogb_s(v8f32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvflogb.s(

  // __lasx_xvflogb_d
  // xd, xj
  // V4DF, V4DF
  v4f64_r = __lasx_xvflogb_d(v4f64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvflogb.d(

  // __lasx_xvfcvth_s_h
  // xd, xj
  // V8SF, V16HI
  v8f32_r = __lasx_xvfcvth_s_h(v16i16_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfcvth.s.h(

  // __lasx_xvfcvth_d_s
  // xd, xj
  // V4DF, V8SF
  v4f64_r = __lasx_xvfcvth_d_s(v8f32_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfcvth.d.s(

  // __lasx_xvfcvtl_s_h
  // xd, xj
  // V8SF, V16HI
  v8f32_r = __lasx_xvfcvtl_s_h(v16i16_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfcvtl.s.h(

  // __lasx_xvfcvtl_d_s
  // xd, xj
  // V4DF, V8SF
  v4f64_r = __lasx_xvfcvtl_d_s(v8f32_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfcvtl.d.s(

  // __lasx_xvftint_w_s
  // xd, xj
  // V8SI, V8SF
  v8i32_r = __lasx_xvftint_w_s(v8f32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftint.w.s(

  // __lasx_xvftint_l_d
  // xd, xj
  // V4DI, V4DF
  v4i64_r = __lasx_xvftint_l_d(v4f64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftint.l.d(

  // __lasx_xvftint_wu_s
  // xd, xj
  // UV8SI, V8SF
  v8u32_r = __lasx_xvftint_wu_s(v8f32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftint.wu.s(

  // __lasx_xvftint_lu_d
  // xd, xj
  // UV4DI, V4DF
  v4u64_r = __lasx_xvftint_lu_d(v4f64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftint.lu.d(

  // __lasx_xvftintrz_w_s
  // xd, xj
  // V8SI, V8SF
  v8i32_r = __lasx_xvftintrz_w_s(v8f32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftintrz.w.s(

  // __lasx_xvftintrz_l_d
  // xd, xj
  // V4DI, V4DF
  v4i64_r = __lasx_xvftintrz_l_d(v4f64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrz.l.d(

  // __lasx_xvftintrz_wu_s
  // xd, xj
  // UV8SI, V8SF
  v8u32_r = __lasx_xvftintrz_wu_s(v8f32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftintrz.wu.s(

  // __lasx_xvftintrz_lu_d
  // xd, xj
  // UV4DI, V4DF
  v4u64_r = __lasx_xvftintrz_lu_d(v4f64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrz.lu.d(

  // __lasx_xvffint_s_w
  // xd, xj
  // V8SF, V8SI
  v8f32_r = __lasx_xvffint_s_w(v8i32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvffint.s.w(

  // __lasx_xvffint_d_l
  // xd, xj
  // V4DF, V4DI
  v4f64_r = __lasx_xvffint_d_l(v4i64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvffint.d.l(

  // __lasx_xvffint_s_wu
  // xd, xj
  // V8SF, UV8SI
  v8f32_r = __lasx_xvffint_s_wu(v8u32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvffint.s.wu(

  // __lasx_xvffint_d_lu
  // xd, xj
  // V4DF, UV4DI
  v4f64_r = __lasx_xvffint_d_lu(v4u64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvffint.d.lu(

  // __lasx_xvreplve_b
  // xd, xj, rk
  // V32QI, V32QI, SI
  v32i8_r = __lasx_xvreplve_b(v32i8_a, i32_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvreplve.b(

  // __lasx_xvreplve_h
  // xd, xj, rk
  // V16HI, V16HI, SI
  v16i16_r = __lasx_xvreplve_h(v16i16_a, i32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvreplve.h(

  // __lasx_xvreplve_w
  // xd, xj, rk
  // V8SI, V8SI, SI
  v8i32_r = __lasx_xvreplve_w(v8i32_a, i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvreplve.w(

  // __lasx_xvreplve_d
  // xd, xj, rk
  // V4DI, V4DI, SI
  v4i64_r = __lasx_xvreplve_d(v4i64_a, i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvreplve.d(

  // __lasx_xvpermi_w
  // xd, xj, ui8
  // V8SI, V8SI, V8SI, USI
  v8i32_r = __lasx_xvpermi_w(v8i32_a, v8i32_b, ui8); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvpermi.w(

  // __lasx_xvandn_v
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvandn_v(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvandn.v(

  // __lasx_xvneg_b
  // xd, xj
  // V32QI, V32QI
  v32i8_r = __lasx_xvneg_b(v32i8_a); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvneg.b(

  // __lasx_xvneg_h
  // xd, xj
  // V16HI, V16HI
  v16i16_r = __lasx_xvneg_h(v16i16_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvneg.h(

  // __lasx_xvneg_w
  // xd, xj
  // V8SI, V8SI
  v8i32_r = __lasx_xvneg_w(v8i32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvneg.w(

  // __lasx_xvneg_d
  // xd, xj
  // V4DI, V4DI
  v4i64_r = __lasx_xvneg_d(v4i64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvneg.d(

  // __lasx_xvmuh_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvmuh_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmuh.b(

  // __lasx_xvmuh_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvmuh_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmuh.h(

  // __lasx_xvmuh_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvmuh_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmuh.w(

  // __lasx_xvmuh_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmuh_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmuh.d(

  // __lasx_xvmuh_bu
  // xd, xj, xk
  // UV32QI, UV32QI, UV32QI
  v32u8_r = __lasx_xvmuh_bu(v32u8_a, v32u8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmuh.bu(

  // __lasx_xvmuh_hu
  // xd, xj, xk
  // UV16HI, UV16HI, UV16HI
  v16u16_r = __lasx_xvmuh_hu(v16u16_a, v16u16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmuh.hu(

  // __lasx_xvmuh_wu
  // xd, xj, xk
  // UV8SI, UV8SI, UV8SI
  v8u32_r = __lasx_xvmuh_wu(v8u32_a, v8u32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmuh.wu(

  // __lasx_xvmuh_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvmuh_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmuh.du(

  // __lasx_xvsllwil_h_b
  // xd, xj, ui3
  // V16HI, V32QI, UQI
  v16i16_r = __lasx_xvsllwil_h_b(v32i8_a, ui3_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsllwil.h.b(

  // __lasx_xvsllwil_w_h
  // xd, xj, ui4
  // V8SI, V16HI, UQI
  v8i32_r = __lasx_xvsllwil_w_h(v16i16_a, ui4_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsllwil.w.h(

  // __lasx_xvsllwil_d_w
  // xd, xj, ui5
  // V4DI, V8SI, UQI
  v4i64_r = __lasx_xvsllwil_d_w(v8i32_a, ui5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsllwil.d.w(

  // __lasx_xvsllwil_hu_bu
  // xd, xj, ui3
  // UV16HI, UV32QI, UQI
  v16u16_r = __lasx_xvsllwil_hu_bu(v32u8_a, ui3_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsllwil.hu.bu(

  // __lasx_xvsllwil_wu_hu
  // xd, xj, ui4
  // UV8SI, UV16HI, UQI
  v8u32_r = __lasx_xvsllwil_wu_hu(v16u16_a, ui4_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsllwil.wu.hu(

  // __lasx_xvsllwil_du_wu
  // xd, xj, ui5
  // UV4DI, UV8SI, UQI
  v4u64_r = __lasx_xvsllwil_du_wu(v8u32_a, ui5_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsllwil.du.wu(

  // __lasx_xvsran_b_h
  // xd, xj, xk
  // V32QI, V16HI, V16HI
  v32i8_r = __lasx_xvsran_b_h(v16i16_a, v16i16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsran.b.h(

  // __lasx_xvsran_h_w
  // xd, xj, xk
  // V16HI, V8SI, V8SI
  v16i16_r = __lasx_xvsran_h_w(v8i32_a, v8i32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsran.h.w(

  // __lasx_xvsran_w_d
  // xd, xj, xk
  // V8SI, V4DI, V4DI
  v8i32_r = __lasx_xvsran_w_d(v4i64_a, v4i64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsran.w.d(

  // __lasx_xvssran_b_h
  // xd, xj, xk
  // V32QI, V16HI, V16HI
  v32i8_r = __lasx_xvssran_b_h(v16i16_a, v16i16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssran.b.h(

  // __lasx_xvssran_h_w
  // xd, xj, xk
  // V16HI, V8SI, V8SI
  v16i16_r = __lasx_xvssran_h_w(v8i32_a, v8i32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssran.h.w(

  // __lasx_xvssran_w_d
  // xd, xj, xk
  // V8SI, V4DI, V4DI
  v8i32_r = __lasx_xvssran_w_d(v4i64_a, v4i64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssran.w.d(

  // __lasx_xvssran_bu_h
  // xd, xj, xk
  // UV32QI, UV16HI, UV16HI
  v32u8_r = __lasx_xvssran_bu_h(v16u16_a, v16u16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssran.bu.h(

  // __lasx_xvssran_hu_w
  // xd, xj, xk
  // UV16HI, UV8SI, UV8SI
  v16u16_r = __lasx_xvssran_hu_w(v8u32_a, v8u32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssran.hu.w(

  // __lasx_xvssran_wu_d
  // xd, xj, xk
  // UV8SI, UV4DI, UV4DI
  v8u32_r = __lasx_xvssran_wu_d(v4u64_a, v4u64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssran.wu.d(

  // __lasx_xvsrarn_b_h
  // xd, xj, xk
  // V32QI, V16HI, V16HI
  v32i8_r = __lasx_xvsrarn_b_h(v16i16_a, v16i16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrarn.b.h(

  // __lasx_xvsrarn_h_w
  // xd, xj, xk
  // V16HI, V8SI, V8SI
  v16i16_r = __lasx_xvsrarn_h_w(v8i32_a, v8i32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrarn.h.w(

  // __lasx_xvsrarn_w_d
  // xd, xj, xk
  // V8SI, V4DI, V4DI
  v8i32_r = __lasx_xvsrarn_w_d(v4i64_a, v4i64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrarn.w.d(

  // __lasx_xvssrarn_b_h
  // xd, xj, xk
  // V32QI, V16HI, V16HI
  v32i8_r = __lasx_xvssrarn_b_h(v16i16_a, v16i16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrarn.b.h(

  // __lasx_xvssrarn_h_w
  // xd, xj, xk
  // V16HI, V8SI, V8SI
  v16i16_r = __lasx_xvssrarn_h_w(v8i32_a, v8i32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrarn.h.w(

  // __lasx_xvssrarn_w_d
  // xd, xj, xk
  // V8SI, V4DI, V4DI
  v8i32_r = __lasx_xvssrarn_w_d(v4i64_a, v4i64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrarn.w.d(

  // __lasx_xvssrarn_bu_h
  // xd, xj, xk
  // UV32QI, UV16HI, UV16HI
  v32u8_r = __lasx_xvssrarn_bu_h(v16u16_a, v16u16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrarn.bu.h(

  // __lasx_xvssrarn_hu_w
  // xd, xj, xk
  // UV16HI, UV8SI, UV8SI
  v16u16_r = __lasx_xvssrarn_hu_w(v8u32_a, v8u32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrarn.hu.w(

  // __lasx_xvssrarn_wu_d
  // xd, xj, xk
  // UV8SI, UV4DI, UV4DI
  v8u32_r = __lasx_xvssrarn_wu_d(v4u64_a, v4u64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrarn.wu.d(

  // __lasx_xvsrln_b_h
  // xd, xj, xk
  // V32QI, V16HI, V16HI
  v32i8_r = __lasx_xvsrln_b_h(v16i16_a, v16i16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrln.b.h(

  // __lasx_xvsrln_h_w
  // xd, xj, xk
  // V16HI, V8SI, V8SI
  v16i16_r = __lasx_xvsrln_h_w(v8i32_a, v8i32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrln.h.w(

  // __lasx_xvsrln_w_d
  // xd, xj, xk
  // V8SI, V4DI, V4DI
  v8i32_r = __lasx_xvsrln_w_d(v4i64_a, v4i64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrln.w.d(

  // __lasx_xvssrln_bu_h
  // xd, xj, xk
  // UV32QI, UV16HI, UV16HI
  v32u8_r = __lasx_xvssrln_bu_h(v16u16_a, v16u16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrln.bu.h(

  // __lasx_xvssrln_hu_w
  // xd, xj, xk
  // UV16HI, UV8SI, UV8SI
  v16u16_r = __lasx_xvssrln_hu_w(v8u32_a, v8u32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrln.hu.w(

  // __lasx_xvssrln_wu_d
  // xd, xj, xk
  // UV8SI, UV4DI, UV4DI
  v8u32_r = __lasx_xvssrln_wu_d(v4u64_a, v4u64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrln.wu.d(

  // __lasx_xvsrlrn_b_h
  // xd, xj, xk
  // V32QI, V16HI, V16HI
  v32i8_r = __lasx_xvsrlrn_b_h(v16i16_a, v16i16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrlrn.b.h(

  // __lasx_xvsrlrn_h_w
  // xd, xj, xk
  // V16HI, V8SI, V8SI
  v16i16_r = __lasx_xvsrlrn_h_w(v8i32_a, v8i32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrlrn.h.w(

  // __lasx_xvsrlrn_w_d
  // xd, xj, xk
  // V8SI, V4DI, V4DI
  v8i32_r = __lasx_xvsrlrn_w_d(v4i64_a, v4i64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrlrn.w.d(

  // __lasx_xvssrlrn_bu_h
  // xd, xj, xk
  // UV32QI, UV16HI, UV16HI
  v32u8_r = __lasx_xvssrlrn_bu_h(v16u16_a, v16u16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrlrn.bu.h(

  // __lasx_xvssrlrn_hu_w
  // xd, xj, xk
  // UV16HI, UV8SI, UV8SI
  v16u16_r = __lasx_xvssrlrn_hu_w(v8u32_a, v8u32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrlrn.hu.w(

  // __lasx_xvssrlrn_wu_d
  // xd, xj, xk
  // UV8SI, UV4DI, UV4DI
  v8u32_r = __lasx_xvssrlrn_wu_d(v4u64_a, v4u64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrlrn.wu.d(

  // __lasx_xvfrstpi_b
  // xd, xj, ui5
  // V32QI, V32QI, V32QI, UQI
  v32i8_r = __lasx_xvfrstpi_b(v32i8_a, v32i8_b, ui5); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvfrstpi.b(

  // __lasx_xvfrstpi_h
  // xd, xj, ui5
  // V16HI, V16HI, V16HI, UQI
  v16i16_r = __lasx_xvfrstpi_h(v16i16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvfrstpi.h(

  // __lasx_xvfrstp_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvfrstp_b(v32i8_a, v32i8_b, v32i8_c); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvfrstp.b(

  // __lasx_xvfrstp_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvfrstp_h(v16i16_a, v16i16_b, v16i16_c); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvfrstp.h(

  // __lasx_xvshuf4i_d
  // xd, xj, ui8
  // V4DI, V4DI, V4DI, USI
  v4i64_r = __lasx_xvshuf4i_d(v4i64_a, v4i64_b, ui8); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvshuf4i.d(

  // __lasx_xvbsrl_v
  // xd, xj, ui5
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvbsrl_v(v32i8_a, ui5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvbsrl.v(

  // __lasx_xvbsll_v
  // xd, xj, ui5
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvbsll_v(v32i8_a, ui5_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvbsll.v(

  // __lasx_xvextrins_b
  // xd, xj, ui8
  // V32QI, V32QI, V32QI, UQI
  v32i8_r = __lasx_xvextrins_b(v32i8_a, v32i8_b, ui8); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvextrins.b(

  // __lasx_xvextrins_h
  // xd, xj, ui8
  // V16HI, V16HI, V16HI, UQI
  v16i16_r = __lasx_xvextrins_h(v16i16_a, v16i16_b, ui8); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvextrins.h(

  // __lasx_xvextrins_w
  // xd, xj, ui8
  // V8SI, V8SI, V8SI, UQI
  v8i32_r = __lasx_xvextrins_w(v8i32_a, v8i32_b, ui8); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvextrins.w(

  // __lasx_xvextrins_d
  // xd, xj, ui8
  // V4DI, V4DI, V4DI, UQI
  v4i64_r = __lasx_xvextrins_d(v4i64_a, v4i64_b, ui8); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvextrins.d(

  // __lasx_xvmskltz_b
  // xd, xj
  // V32QI, V32QI
  v32i8_r = __lasx_xvmskltz_b(v32i8_a); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmskltz.b(

  // __lasx_xvmskltz_h
  // xd, xj
  // V16HI, V16HI
  v16i16_r = __lasx_xvmskltz_h(v16i16_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmskltz.h(

  // __lasx_xvmskltz_w
  // xd, xj
  // V8SI, V8SI
  v8i32_r = __lasx_xvmskltz_w(v8i32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmskltz.w(

  // __lasx_xvmskltz_d
  // xd, xj
  // V4DI, V4DI
  v4i64_r = __lasx_xvmskltz_d(v4i64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmskltz.d(

  // __lasx_xvsigncov_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvsigncov_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsigncov.b(

  // __lasx_xvsigncov_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvsigncov_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsigncov.h(

  // __lasx_xvsigncov_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvsigncov_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsigncov.w(

  // __lasx_xvsigncov_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsigncov_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsigncov.d(

  // __lasx_xvfmadd_s
  // xd, xj, xk, xa
  // V8SF, V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfmadd_s(v8f32_a, v8f32_b, v8f32_c); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfmadd.s(

  // __lasx_xvfmadd_d
  // xd, xj, xk, xa
  // V4DF, V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfmadd_d(v4f64_a, v4f64_b, v4f64_c); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfmadd.d(

  // __lasx_xvfmsub_s
  // xd, xj, xk, xa
  // V8SF, V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfmsub_s(v8f32_a, v8f32_b, v8f32_c); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfmsub.s(

  // __lasx_xvfmsub_d
  // xd, xj, xk, xa
  // V4DF, V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfmsub_d(v4f64_a, v4f64_b, v4f64_c); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfmsub.d(

  // __lasx_xvfnmadd_s
  // xd, xj, xk, xa
  // V8SF, V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfnmadd_s(v8f32_a, v8f32_b, v8f32_c); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfnmadd.s(

  // __lasx_xvfnmadd_d
  // xd, xj, xk, xa
  // V4DF, V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfnmadd_d(v4f64_a, v4f64_b, v4f64_c); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfnmadd.d(

  // __lasx_xvfnmsub_s
  // xd, xj, xk, xa
  // V8SF, V8SF, V8SF, V8SF
  v8f32_r = __lasx_xvfnmsub_s(v8f32_a, v8f32_b, v8f32_c); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfnmsub.s(

  // __lasx_xvfnmsub_d
  // xd, xj, xk, xa
  // V4DF, V4DF, V4DF, V4DF
  v4f64_r = __lasx_xvfnmsub_d(v4f64_a, v4f64_b, v4f64_c); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfnmsub.d(

  // __lasx_xvftintrne_w_s
  // xd, xj
  // V8SI, V8SF
  v8i32_r = __lasx_xvftintrne_w_s(v8f32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftintrne.w.s(

  // __lasx_xvftintrne_l_d
  // xd, xj
  // V4DI, V4DF
  v4i64_r = __lasx_xvftintrne_l_d(v4f64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrne.l.d(

  // __lasx_xvftintrp_w_s
  // xd, xj
  // V8SI, V8SF
  v8i32_r = __lasx_xvftintrp_w_s(v8f32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftintrp.w.s(

  // __lasx_xvftintrp_l_d
  // xd, xj
  // V4DI, V4DF
  v4i64_r = __lasx_xvftintrp_l_d(v4f64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrp.l.d(

  // __lasx_xvftintrm_w_s
  // xd, xj
  // V8SI, V8SF
  v8i32_r = __lasx_xvftintrm_w_s(v8f32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftintrm.w.s(

  // __lasx_xvftintrm_l_d
  // xd, xj
  // V4DI, V4DF
  v4i64_r = __lasx_xvftintrm_l_d(v4f64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrm.l.d(

  // __lasx_xvftint_w_d
  // xd, xj, xk
  // V8SI, V4DF, V4DF
  v8i32_r = __lasx_xvftint_w_d(v4f64_a, v4f64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftint.w.d(

  // __lasx_xvffint_s_l
  // xd, xj, xk
  // V8SF, V4DI, V4DI
  v8f32_r = __lasx_xvffint_s_l(v4i64_a, v4i64_b); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvffint.s.l(

  // __lasx_xvftintrz_w_d
  // xd, xj, xk
  // V8SI, V4DF, V4DF
  v8i32_r = __lasx_xvftintrz_w_d(v4f64_a, v4f64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftintrz.w.d(

  // __lasx_xvftintrp_w_d
  // xd, xj, xk
  // V8SI, V4DF, V4DF
  v8i32_r = __lasx_xvftintrp_w_d(v4f64_a, v4f64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftintrp.w.d(

  // __lasx_xvftintrm_w_d
  // xd, xj, xk
  // V8SI, V4DF, V4DF
  v8i32_r = __lasx_xvftintrm_w_d(v4f64_a, v4f64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftintrm.w.d(

  // __lasx_xvftintrne_w_d
  // xd, xj, xk
  // V8SI, V4DF, V4DF
  v8i32_r = __lasx_xvftintrne_w_d(v4f64_a, v4f64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvftintrne.w.d(

  // __lasx_xvftinth_l_s
  // xd, xj
  // V4DI, V8SF
  v4i64_r = __lasx_xvftinth_l_s(v8f32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftinth.l.s(

  // __lasx_xvftintl_l_s
  // xd, xj
  // V4DI, V8SF
  v4i64_r = __lasx_xvftintl_l_s(v8f32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintl.l.s(

  // __lasx_xvffinth_d_w
  // xd, xj
  // V4DF, V8SI
  v4f64_r = __lasx_xvffinth_d_w(v8i32_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvffinth.d.w(

  // __lasx_xvffintl_d_w
  // xd, xj
  // V4DF, V8SI
  v4f64_r = __lasx_xvffintl_d_w(v8i32_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvffintl.d.w(

  // __lasx_xvftintrzh_l_s
  // xd, xj
  // V4DI, V8SF
  v4i64_r = __lasx_xvftintrzh_l_s(v8f32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrzh.l.s(

  // __lasx_xvftintrzl_l_s
  // xd, xj
  // V4DI, V8SF
  v4i64_r = __lasx_xvftintrzl_l_s(v8f32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrzl.l.s(

  // __lasx_xvftintrph_l_s
  // xd, xj
  // V4DI, V8SF
  v4i64_r = __lasx_xvftintrph_l_s(v8f32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrph.l.s(

  // __lasx_xvftintrpl_l_s
  // xd, xj
  // V4DI, V8SF
  v4i64_r = __lasx_xvftintrpl_l_s(v8f32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrpl.l.s(

  // __lasx_xvftintrmh_l_s
  // xd, xj
  // V4DI, V8SF
  v4i64_r = __lasx_xvftintrmh_l_s(v8f32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrmh.l.s(

  // __lasx_xvftintrml_l_s
  // xd, xj
  // V4DI, V8SF
  v4i64_r = __lasx_xvftintrml_l_s(v8f32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrml.l.s(

  // __lasx_xvftintrneh_l_s
  // xd, xj
  // V4DI, V8SF
  v4i64_r = __lasx_xvftintrneh_l_s(v8f32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrneh.l.s(

  // __lasx_xvftintrnel_l_s
  // xd, xj
  // V4DI, V8SF
  v4i64_r = __lasx_xvftintrnel_l_s(v8f32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvftintrnel.l.s(

  // __lasx_xvfrintrne_s
  // xd, xj
  // V8SF, V8SF
  v8f32_r = __lasx_xvfrintrne_s(v8f32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfrintrne.s(

  // __lasx_xvfrintrne_d
  // xd, xj
  // V4DF, V4DF
  v4f64_r = __lasx_xvfrintrne_d(v4f64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfrintrne.d(

  // __lasx_xvfrintrz_s
  // xd, xj
  // V8SF, V8SF
  v8f32_r = __lasx_xvfrintrz_s(v8f32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfrintrz.s(

  // __lasx_xvfrintrz_d
  // xd, xj
  // V4DF, V4DF
  v4f64_r = __lasx_xvfrintrz_d(v4f64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfrintrz.d(

  // __lasx_xvfrintrp_s
  // xd, xj
  // V8SF, V8SF
  v8f32_r = __lasx_xvfrintrp_s(v8f32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfrintrp.s(

  // __lasx_xvfrintrp_d
  // xd, xj
  // V4DF, V4DF
  v4f64_r = __lasx_xvfrintrp_d(v4f64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfrintrp.d(

  // __lasx_xvfrintrm_s
  // xd, xj
  // V8SF, V8SF
  v8f32_r = __lasx_xvfrintrm_s(v8f32_a); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvfrintrm.s(

  // __lasx_xvfrintrm_d
  // xd, xj
  // V4DF, V4DF
  v4f64_r = __lasx_xvfrintrm_d(v4f64_a); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvfrintrm.d(

  // __lasx_xvld
  // xd, rj, si12
  // V32QI, CVPOINTER, SI
  v32i8_r = __lasx_xvld(&v32i8_a, si12); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvld(

  // __lasx_xvst
  // xd, rj, si12
  // VOID, V32QI, CVPOINTER, SI
  __lasx_xvst(v32i8_a, &v32i8_b, si12); // CHECK: call void @llvm.loongarch.lasx.xvst(

  // __lasx_xvstelm_b
  // xd, rj, si8, idx
  // VOID, V32QI, CVPOINTER, SI, UQI
  __lasx_xvstelm_b(v32i8_a, &v32i8_b, 0, idx4); // CHECK: call void @llvm.loongarch.lasx.xvstelm.b(

  // __lasx_xvstelm_h
  // xd, rj, si8, idx
  // VOID, V16HI, CVPOINTER, SI, UQI
  __lasx_xvstelm_h(v16i16_a, &v16i16_b, 0, idx3); // CHECK: call void @llvm.loongarch.lasx.xvstelm.h(

  // __lasx_xvstelm_w
  // xd, rj, si8, idx
  // VOID, V8SI, CVPOINTER, SI, UQI
  __lasx_xvstelm_w(v8i32_a, &v8i32_b, 0, idx2); // CHECK: call void @llvm.loongarch.lasx.xvstelm.w(

  // __lasx_xvstelm_d
  // xd, rj, si8, idx
  // VOID, V4DI, CVPOINTER, SI, UQI
  __lasx_xvstelm_d(v4i64_a, &v4i64_b, 0, idx1); // CHECK: call void @llvm.loongarch.lasx.xvstelm.d(

  // __lasx_xvinsve0_w
  // xd, xj, ui3
  // V8SI, V8SI, V8SI, UQI
  v8i32_r = __lasx_xvinsve0_w(v8i32_a, v8i32_b, 2); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvinsve0.w(

  // __lasx_xvinsve0_d
  // xd, xj, ui2
  // V4DI, V4DI, V4DI, UQI
  v4i64_r = __lasx_xvinsve0_d(v4i64_a, v4i64_b, ui2); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvinsve0.d(

  // __lasx_xvpickve_w
  // xd, xj, ui3
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvpickve_w(v8i32_b, 2); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvpickve.w(

  // __lasx_xvpickve_d
  // xd, xj, ui2
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvpickve_d(v4i64_b, ui2); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvpickve.d(

  // __lasx_xvssrlrn_b_h
  // xd, xj, xk
  // V32QI, V16HI, V16HI
  v32i8_r = __lasx_xvssrlrn_b_h(v16i16_a, v16i16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrlrn.b.h(

  // __lasx_xvssrlrn_h_w
  // xd, xj, xk
  // V16HI, V8SI, V8SI
  v16i16_r = __lasx_xvssrlrn_h_w(v8i32_a, v8i32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrlrn.h.w(

  // __lasx_xvssrlrn_w_d
  // xd, xj, xk
  // V8SI, V4DI, V4DI
  v8i32_r = __lasx_xvssrlrn_w_d(v4i64_a, v4i64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrlrn.w.d(

  // __lasx_xvssrln_b_h
  // xd, xj, xk
  // V32QI, V16HI, V16HI
  v32i8_r = __lasx_xvssrln_b_h(v16i16_a, v16i16_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrln.b.h(

  // __lasx_xvssrln_h_w
  // xd, xj, xk
  // V16HI, V8SI, V8SI
  v16i16_r = __lasx_xvssrln_h_w(v8i32_a, v8i32_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrln.h.w(

  // __lasx_xvssrln_w_d
  // xd, xj, xk
  // V8SI, V4DI, V4DI
  v8i32_r = __lasx_xvssrln_w_d(v4i64_a, v4i64_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrln.w.d(

  // __lasx_xvorn_v
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvorn_v(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvorn.v(

  // __lasx_xvldi
  // xd, i13
  // V4DI, HI
  v4i64_r = __lasx_xvldi(i13); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvldi(

  // __lasx_xvldx
  // xd, rj, rk
  // V32QI, CVPOINTER, DI
  v32i8_r = __lasx_xvldx(&v32i8_a, i64_d); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvldx(

  // __lasx_xvstx
  // xd, rj, rk
  // VOID, V32QI, CVPOINTER, DI
  __lasx_xvstx(v32i8_a, &v32i8_b, i64_d); // CHECK: call void @llvm.loongarch.lasx.xvstx(

  // __lasx_xvinsgr2vr_w
  // xd, rj, ui3
  // V8SI, V8SI, SI, UQI
  v8i32_r = __lasx_xvinsgr2vr_w(v8i32_a, i32_b, ui3); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvinsgr2vr.w(

  // __lasx_xvinsgr2vr_d
  // xd, rj, ui2
  // V4DI, V4DI, DI, UQI
  v4i64_r = __lasx_xvinsgr2vr_d(v4i64_a, i64_b, ui2); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvinsgr2vr.d(

  // __lasx_xvreplve0_b
  // xd, xj
  // V32QI, V32QI
  v32i8_r = __lasx_xvreplve0_b(v32i8_a); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvreplve0.b(

  // __lasx_xvreplve0_h
  // xd, xj
  // V16HI, V16HI
  v16i16_r = __lasx_xvreplve0_h(v16i16_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvreplve0.h(

  // __lasx_xvreplve0_w
  // xd, xj
  // V8SI, V8SI
  v8i32_r = __lasx_xvreplve0_w(v8i32_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvreplve0.w(

  // __lasx_xvreplve0_d
  // xd, xj
  // V4DI, V4DI
  v4i64_r = __lasx_xvreplve0_d(v4i64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvreplve0.d(

  // __lasx_xvreplve0_q
  // xd, xj
  // V32QI, V32QI
  v32i8_r = __lasx_xvreplve0_q(v32i8_a); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvreplve0.q(

  // __lasx_vext2xv_h_b
  // xd, xj
  // V16HI, V32QI
  v16i16_r = __lasx_vext2xv_h_b(v32i8_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.vext2xv.h.b(

  // __lasx_vext2xv_w_h
  // xd, xj
  // V8SI, V16HI
  v8i32_r = __lasx_vext2xv_w_h(v16i16_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.vext2xv.w.h(

  // __lasx_vext2xv_d_w
  // xd, xj
  // V4DI, V8SI
  v4i64_r = __lasx_vext2xv_d_w(v8i32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.vext2xv.d.w(

  // __lasx_vext2xv_w_b
  // xd, xj
  // V8SI, V32QI
  v8i32_r = __lasx_vext2xv_w_b(v32i8_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.vext2xv.w.b(

  //gcc build fail
  // __lasx_vext2xv_d_h
  // xd, xj
  // V4DI, V16HI
  v4i64_r = __lasx_vext2xv_d_h(v16i16_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.vext2xv.d.h(

  // __lasx_vext2xv_d_b
  // xd, xj
  // V4DI, V32QI
  v4i64_r = __lasx_vext2xv_d_b(v32i8_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.vext2xv.d.b(

  // __lasx_vext2xv_hu_bu
  // xd, xj
  // V16HI, V32QI
  v16i16_r = __lasx_vext2xv_hu_bu(v32i8_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.vext2xv.hu.bu(

  // __lasx_vext2xv_wu_hu
  // xd, xj
  // V8SI, V16HI
  v8i32_r = __lasx_vext2xv_wu_hu(v16i16_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.vext2xv.wu.hu(

  // __lasx_vext2xv_du_wu
  // xd, xj
  // V4DI, V8SI
  v4i64_r = __lasx_vext2xv_du_wu(v8i32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.vext2xv.du.wu(

  // __lasx_vext2xv_wu_bu
  // xd, xj
  // V8SI, V32QI
  v8i32_r = __lasx_vext2xv_wu_bu(v32i8_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.vext2xv.wu.bu(

  //gcc build fail
  // __lasx_vext2xv_du_hu
  // xd, xj
  // V4DI, V16HI
  v4i64_r = __lasx_vext2xv_du_hu(v16i16_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.vext2xv.du.hu(

  // __lasx_vext2xv_du_bu
  // xd, xj
  // V4DI, V32QI
  v4i64_r = __lasx_vext2xv_du_bu(v32i8_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.vext2xv.du.bu(

  // __lasx_xvpermi_q
  // xd, xj, ui8
  // V32QI, V32QI, V32QI, USI
  v32i8_r = __lasx_xvpermi_q(v32i8_a, v32i8_b, ui8); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvpermi.q(

  // __lasx_xvpermi_d
  // xd, xj, ui8
  // V4DI, V4DI, USI
  v4i64_r = __lasx_xvpermi_d(v4i64_a, ui8); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvpermi.d(

  // __lasx_xvperm_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvperm_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvperm.w(

  // __lasx_xvldrepl_b
  // xd, rj, si12
  // V32QI, CVPOINTER, SI
  v32i8_r = __lasx_xvldrepl_b(&v32i8_a, si12); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvldrepl.b(

  // __lasx_xvldrepl_h
  // xd, rj, si11
  // V16HI, CVPOINTER, SI
  v16i16_r = __lasx_xvldrepl_h(&v16i16_a, si11); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvldrepl.h(

  // __lasx_xvldrepl_w
  // xd, rj, si10
  // V8SI, CVPOINTER, SI
  v8i32_r = __lasx_xvldrepl_w(&v8i32_a, si10); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvldrepl.w(

  // __lasx_xvldrepl_d
  // xd, rj, si9
  // V4DI, CVPOINTER, SI
  v4i64_r = __lasx_xvldrepl_d(&v4i64_a, si9); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvldrepl.d(

  // __lasx_xvpickve2gr_w
  // rd, xj, ui3
  // SI, V8SI, UQI
  i32_r = __lasx_xvpickve2gr_w(v8i32_a, ui3_b); // CHECK: call i32 @llvm.loongarch.lasx.xvpickve2gr.w(

  // __lasx_xvpickve2gr_wu
  // rd, xj, ui3
  // USI, V8SI, UQI
  u32_r = __lasx_xvpickve2gr_wu(v8i32_a, ui3_b); // CHECK: call i32 @llvm.loongarch.lasx.xvpickve2gr.wu(

  // __lasx_xvpickve2gr_d
  // rd, xj, ui2
  // DI, V4DI, UQI
  i64_r = __lasx_xvpickve2gr_d(v4i64_a, ui2_b); // CHECK: call i64 @llvm.loongarch.lasx.xvpickve2gr.d(

  // __lasx_xvpickve2gr_du
  // rd, xj, ui2
  // UDI, V4DI, UQI
  u64_r = __lasx_xvpickve2gr_du(v4i64_a, ui2_b); // CHECK: call i64 @llvm.loongarch.lasx.xvpickve2gr.du(

  // __lasx_xvaddwev_q_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvaddwev_q_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwev.q.d(

  // __lasx_xvaddwev_d_w
  // xd, xj, xk
  // V4DI, V8SI, V8SI
  v4i64_r = __lasx_xvaddwev_d_w(v8i32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwev.d.w(

  // __lasx_xvaddwev_w_h
  // xd, xj, xk
  // V8SI, V16HI, V16HI
  v8i32_r = __lasx_xvaddwev_w_h(v16i16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvaddwev.w.h(

  // __lasx_xvaddwev_h_b
  // xd, xj, xk
  // V16HI, V32QI, V32QI
  v16i16_r = __lasx_xvaddwev_h_b(v32i8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvaddwev.h.b(

  // __lasx_xvaddwev_q_du
  // xd, xj, xk
  // V4DI, UV4DI, UV4DI
  v4i64_r = __lasx_xvaddwev_q_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwev.q.du(

  // __lasx_xvaddwev_d_wu
  // xd, xj, xk
  // V4DI, UV8SI, UV8SI
  v4i64_r = __lasx_xvaddwev_d_wu(v8u32_a, v8u32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwev.d.wu(

  // __lasx_xvaddwev_w_hu
  // xd, xj, xk
  // V8SI, UV16HI, UV16HI
  v8i32_r = __lasx_xvaddwev_w_hu(v16u16_a, v16u16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvaddwev.w.hu(

  // __lasx_xvaddwev_h_bu
  // xd, xj, xk
  // V16HI, UV32QI, UV32QI
  v16i16_r = __lasx_xvaddwev_h_bu(v32u8_a, v32u8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvaddwev.h.bu(

  // __lasx_xvsubwev_q_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsubwev_q_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsubwev.q.d(

  // __lasx_xvsubwev_d_w
  // xd, xj, xk
  // V4DI, V8SI, V8SI
  v4i64_r = __lasx_xvsubwev_d_w(v8i32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsubwev.d.w(

  // __lasx_xvsubwev_w_h
  // xd, xj, xk
  // V8SI, V16HI, V16HI
  v8i32_r = __lasx_xvsubwev_w_h(v16i16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsubwev.w.h(

  // __lasx_xvsubwev_h_b
  // xd, xj, xk
  // V16HI, V32QI, V32QI
  v16i16_r = __lasx_xvsubwev_h_b(v32i8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsubwev.h.b(

  // __lasx_xvsubwev_q_du
  // xd, xj, xk
  // V4DI, UV4DI, UV4DI
  v4i64_r = __lasx_xvsubwev_q_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsubwev.q.du(

  // __lasx_xvsubwev_d_wu
  // xd, xj, xk
  // V4DI, UV8SI, UV8SI
  v4i64_r = __lasx_xvsubwev_d_wu(v8u32_a, v8u32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsubwev.d.wu(

  // __lasx_xvsubwev_w_hu
  // xd, xj, xk
  // V8SI, UV16HI, UV16HI
  v8i32_r = __lasx_xvsubwev_w_hu(v16u16_a, v16u16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsubwev.w.hu(

  // __lasx_xvsubwev_h_bu
  // xd, xj, xk
  // V16HI, UV32QI, UV32QI
  v16i16_r = __lasx_xvsubwev_h_bu(v32u8_a, v32u8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsubwev.h.bu(

  // __lasx_xvmulwev_q_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmulwev_q_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwev.q.d(

  // __lasx_xvmulwev_d_w
  // xd, xj, xk
  // V4DI, V8SI, V8SI
  v4i64_r = __lasx_xvmulwev_d_w(v8i32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwev.d.w(

  // __lasx_xvmulwev_w_h
  // xd, xj, xk
  // V8SI, V16HI, V16HI
  v8i32_r = __lasx_xvmulwev_w_h(v16i16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmulwev.w.h(

  // __lasx_xvmulwev_h_b
  // xd, xj, xk
  // V16HI, V32QI, V32QI
  v16i16_r = __lasx_xvmulwev_h_b(v32i8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmulwev.h.b(

  // __lasx_xvmulwev_q_du
  // xd, xj, xk
  // V4DI, UV4DI, UV4DI
  v4i64_r = __lasx_xvmulwev_q_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwev.q.du(

  // __lasx_xvmulwev_d_wu
  // xd, xj, xk
  // V4DI, UV8SI, UV8SI
  v4i64_r = __lasx_xvmulwev_d_wu(v8u32_a, v8u32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwev.d.wu(

  // __lasx_xvmulwev_w_hu
  // xd, xj, xk
  // V8SI, UV16HI, UV16HI
  v8i32_r = __lasx_xvmulwev_w_hu(v16u16_a, v16u16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmulwev.w.hu(

  // __lasx_xvmulwev_h_bu
  // xd, xj, xk
  // V16HI, UV32QI, UV32QI
  v16i16_r = __lasx_xvmulwev_h_bu(v32u8_a, v32u8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmulwev.h.bu(

  // __lasx_xvaddwod_q_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvaddwod_q_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwod.q.d(

  // __lasx_xvaddwod_d_w
  // xd, xj, xk
  // V4DI, V8SI, V8SI
  v4i64_r = __lasx_xvaddwod_d_w(v8i32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwod.d.w(

  // __lasx_xvaddwod_w_h
  // xd, xj, xk
  // V8SI, V16HI, V16HI
  v8i32_r = __lasx_xvaddwod_w_h(v16i16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvaddwod.w.h(

  // __lasx_xvaddwod_h_b
  // xd, xj, xk
  // V16HI, V32QI, V32QI
  v16i16_r = __lasx_xvaddwod_h_b(v32i8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvaddwod.h.b(

  // __lasx_xvaddwod_q_du
  // xd, xj, xk
  // V4DI, UV4DI, UV4DI
  v4i64_r = __lasx_xvaddwod_q_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwod.q.du(

  // __lasx_xvaddwod_d_wu
  // xd, xj, xk
  // V4DI, UV8SI, UV8SI
  v4i64_r = __lasx_xvaddwod_d_wu(v8u32_a, v8u32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwod.d.wu(

  // __lasx_xvaddwod_w_hu
  // xd, xj, xk
  // V8SI, UV16HI, UV16HI
  v8i32_r = __lasx_xvaddwod_w_hu(v16u16_a, v16u16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvaddwod.w.hu(

  // __lasx_xvaddwod_h_bu
  // xd, xj, xk
  // V16HI, UV32QI, UV32QI
  v16i16_r = __lasx_xvaddwod_h_bu(v32u8_a, v32u8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvaddwod.h.bu(

  // __lasx_xvsubwod_q_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsubwod_q_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsubwod.q.d(

  // __lasx_xvsubwod_d_w
  // xd, xj, xk
  // V4DI, V8SI, V8SI
  v4i64_r = __lasx_xvsubwod_d_w(v8i32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsubwod.d.w(

  // __lasx_xvsubwod_w_h
  // xd, xj, xk
  // V8SI, V16HI, V16HI
  v8i32_r = __lasx_xvsubwod_w_h(v16i16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsubwod.w.h(

  // __lasx_xvsubwod_h_b
  // xd, xj, xk
  // V16HI, V32QI, V32QI
  v16i16_r = __lasx_xvsubwod_h_b(v32i8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsubwod.h.b(

  // __lasx_xvsubwod_q_du
  // xd, xj, xk
  // V4DI, UV4DI, UV4DI
  v4i64_r = __lasx_xvsubwod_q_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsubwod.q.du(

  // __lasx_xvsubwod_d_wu
  // xd, xj, xk
  // V4DI, UV8SI, UV8SI
  v4i64_r = __lasx_xvsubwod_d_wu(v8u32_a, v8u32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsubwod.d.wu(

  // __lasx_xvsubwod_w_hu
  // xd, xj, xk
  // V8SI, UV16HI, UV16HI
  v8i32_r = __lasx_xvsubwod_w_hu(v16u16_a, v16u16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsubwod.w.hu(

  // __lasx_xvsubwod_h_bu
  // xd, xj, xk
  // V16HI, UV32QI, UV32QI
  v16i16_r = __lasx_xvsubwod_h_bu(v32u8_a, v32u8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsubwod.h.bu(

  // __lasx_xvmulwod_q_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmulwod_q_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwod.q.d(

  // __lasx_xvmulwod_d_w
  // xd, xj, xk
  // V4DI, V8SI, V8SI
  v4i64_r = __lasx_xvmulwod_d_w(v8i32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwod.d.w(

  // __lasx_xvmulwod_w_h
  // xd, xj, xk
  // V8SI, V16HI, V16HI
  v8i32_r = __lasx_xvmulwod_w_h(v16i16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmulwod.w.h(

  // __lasx_xvmulwod_h_b
  // xd, xj, xk
  // V16HI, V32QI, V32QI
  v16i16_r = __lasx_xvmulwod_h_b(v32i8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmulwod.h.b(

  // __lasx_xvmulwod_q_du
  // xd, xj, xk
  // V4DI, UV4DI, UV4DI
  v4i64_r = __lasx_xvmulwod_q_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwod.q.du(

  // __lasx_xvmulwod_d_wu
  // xd, xj, xk
  // V4DI, UV8SI, UV8SI
  v4i64_r = __lasx_xvmulwod_d_wu(v8u32_a, v8u32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwod.d.wu(

  // __lasx_xvmulwod_w_hu
  // xd, xj, xk
  // V8SI, UV16HI, UV16HI
  v8i32_r = __lasx_xvmulwod_w_hu(v16u16_a, v16u16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmulwod.w.hu(

  // __lasx_xvmulwod_h_bu
  // xd, xj, xk
  // V16HI, UV32QI, UV32QI
  v16i16_r = __lasx_xvmulwod_h_bu(v32u8_a, v32u8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmulwod.h.bu(

  // __lasx_xvaddwev_d_wu_w
  // xd, xj, xk
  // V4DI, UV8SI, V8SI
  v4i64_r = __lasx_xvaddwev_d_wu_w(v8u32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwev.d.wu.w(

  // __lasx_xvaddwev_w_hu_h
  // xd, xj, xk
  // V8SI, UV16HI, V16HI
  v8i32_r = __lasx_xvaddwev_w_hu_h(v16u16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvaddwev.w.hu.h(

  // __lasx_xvaddwev_h_bu_b
  // xd, xj, xk
  // V16HI, UV32QI, V32QI
  v16i16_r = __lasx_xvaddwev_h_bu_b(v32u8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvaddwev.h.bu.b(

  // __lasx_xvmulwev_d_wu_w
  // xd, xj, xk
  // V4DI, UV8SI, V8SI
  v4i64_r = __lasx_xvmulwev_d_wu_w(v8u32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwev.d.wu.w(

  // __lasx_xvmulwev_w_hu_h
  // xd, xj, xk
  // V8SI, UV16HI, V16HI
  v8i32_r = __lasx_xvmulwev_w_hu_h(v16u16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmulwev.w.hu.h(

  // __lasx_xvmulwev_h_bu_b
  // xd, xj, xk
  // V16HI, UV32QI, V32QI
  v16i16_r = __lasx_xvmulwev_h_bu_b(v32u8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmulwev.h.bu.b(

  // __lasx_xvaddwod_d_wu_w
  // xd, xj, xk
  // V4DI, UV8SI, V8SI
  v4i64_r = __lasx_xvaddwod_d_wu_w(v8u32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwod.d.wu.w(

  // __lasx_xvaddwod_w_hu_h
  // xd, xj, xk
  // V8SI, UV16HI, V16HI
  v8i32_r = __lasx_xvaddwod_w_hu_h(v16u16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvaddwod.w.hu.h(

  // __lasx_xvaddwod_h_bu_b
  // xd, xj, xk
  // V16HI, UV32QI, V32QI
  v16i16_r = __lasx_xvaddwod_h_bu_b(v32u8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvaddwod.h.bu.b(

  // __lasx_xvmulwod_d_wu_w
  // xd, xj, xk
  // V4DI, UV8SI, V8SI
  v4i64_r = __lasx_xvmulwod_d_wu_w(v8u32_a, v8i32_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwod.d.wu.w(

  // __lasx_xvmulwod_w_hu_h
  // xd, xj, xk
  // V8SI, UV16HI, V16HI
  v8i32_r = __lasx_xvmulwod_w_hu_h(v16u16_a, v16i16_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmulwod.w.hu.h(

  // __lasx_xvmulwod_h_bu_b
  // xd, xj, xk
  // V16HI, UV32QI, V32QI
  v16i16_r = __lasx_xvmulwod_h_bu_b(v32u8_a, v32i8_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmulwod.h.bu.b(

  // __lasx_xvhaddw_q_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvhaddw_q_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvhaddw.q.d(

  // __lasx_xvhaddw_qu_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvhaddw_qu_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvhaddw.qu.du(

  // __lasx_xvhsubw_q_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvhsubw_q_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvhsubw.q.d(

  // __lasx_xvhsubw_qu_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvhsubw_qu_du(v4u64_a, v4u64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvhsubw.qu.du(

  // __lasx_xvmaddwev_q_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmaddwev_q_d(v4i64_a, v4i64_b, v4i64_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwev.q.d(

  // __lasx_xvmaddwev_d_w
  // xd, xj, xk
  // V4DI, V4DI, V8SI, V8SI
  v4i64_r = __lasx_xvmaddwev_d_w(v4i64_a, v8i32_b, v8i32_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwev.d.w(

  // __lasx_xvmaddwev_w_h
  // xd, xj, xk
  // V8SI, V8SI, V16HI, V16HI
  v8i32_r = __lasx_xvmaddwev_w_h(v8i32_a, v16i16_b, v16i16_c); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmaddwev.w.h(

  // __lasx_xvmaddwev_h_b
  // xd, xj, xk
  // V16HI, V16HI, V32QI, V32QI
  v16i16_r = __lasx_xvmaddwev_h_b(v16i16_a, v32i8_b, v32i8_c); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmaddwev.h.b(

  // __lasx_xvmaddwev_q_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvmaddwev_q_du(v4u64_a, v4u64_b, v4u64_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwev.q.du(

  // __lasx_xvmaddwev_d_wu
  // xd, xj, xk
  // UV4DI, UV4DI, UV8SI, UV8SI
  v4u64_r = __lasx_xvmaddwev_d_wu(v4u64_a, v8u32_b, v8u32_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwev.d.wu(

  // __lasx_xvmaddwev_w_hu
  // xd, xj, xk
  // UV8SI, UV8SI, UV16HI, UV16HI
  v8u32_r = __lasx_xvmaddwev_w_hu(v8u32_a, v16u16_b, v16u16_c); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmaddwev.w.hu(

  // __lasx_xvmaddwev_h_bu
  // xd, xj, xk
  // UV16HI, UV16HI, UV32QI, UV32QI
  v16u16_r = __lasx_xvmaddwev_h_bu(v16u16_a, v32u8_b, v32u8_c); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmaddwev.h.bu(

  // __lasx_xvmaddwod_q_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvmaddwod_q_d(v4i64_a, v4i64_b, v4i64_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwod.q.d(

  // __lasx_xvmaddwod_d_w
  // xd, xj, xk
  // V4DI, V4DI, V8SI, V8SI
  v4i64_r = __lasx_xvmaddwod_d_w(v4i64_a, v8i32_b, v8i32_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwod.d.w(

  // __lasx_xvmaddwod_w_h
  // xd, xj, xk
  // V8SI, V8SI, V16HI, V16HI
  v8i32_r = __lasx_xvmaddwod_w_h(v8i32_a, v16i16_b, v16i16_c); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmaddwod.w.h(

  // __lasx_xvmaddwod_h_b
  // xd, xj, xk
  // V16HI, V16HI, V32QI, V32QI
  v16i16_r = __lasx_xvmaddwod_h_b(v16i16_a, v32i8_b, v32i8_c); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmaddwod.h.b(

  // __lasx_xvmaddwod_q_du
  // xd, xj, xk
  // UV4DI, UV4DI, UV4DI, UV4DI
  v4u64_r = __lasx_xvmaddwod_q_du(v4u64_a, v4u64_b, v4u64_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwod.q.du(

  // __lasx_xvmaddwod_d_wu
  // xd, xj, xk
  // UV4DI, UV4DI, UV8SI, UV8SI
  v4u64_r = __lasx_xvmaddwod_d_wu(v4u64_a, v8u32_b, v8u32_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwod.d.wu(

  // __lasx_xvmaddwod_w_hu
  // xd, xj, xk
  // UV8SI, UV8SI, UV16HI, UV16HI
  v8u32_r = __lasx_xvmaddwod_w_hu(v8u32_a, v16u16_b, v16u16_c); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmaddwod.w.hu(

  // __lasx_xvmaddwod_h_bu
  // xd, xj, xk
  // UV16HI, UV16HI, UV32QI, UV32QI
  v16u16_r = __lasx_xvmaddwod_h_bu(v16u16_a, v32u8_b, v32u8_c); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmaddwod.h.bu(

  // __lasx_xvmaddwev_q_du_d
  // xd, xj, xk
  // V4DI, V4DI, UV4DI, V4DI
  v4i64_r = __lasx_xvmaddwev_q_du_d(v4i64_a, v4u64_b, v4i64_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwev.q.du.d(

  // __lasx_xvmaddwev_d_wu_w
  // xd, xj, xk
  // V4DI, V4DI, UV8SI, V8SI
  v4i64_r = __lasx_xvmaddwev_d_wu_w(v4i64_a, v8u32_b, v8i32_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwev.d.wu.w(

  // __lasx_xvmaddwev_w_hu_h
  // xd, xj, xk
  // V8SI, V8SI, UV16HI, V16HI
  v8i32_r = __lasx_xvmaddwev_w_hu_h(v8i32_a, v16u16_b, v16i16_c); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmaddwev.w.hu.h(

  // __lasx_xvmaddwev_h_bu_b
  // xd, xj, xk
  // V16HI, V16HI, UV32QI, V32QI
  v16i16_r = __lasx_xvmaddwev_h_bu_b(v16i16_a, v32u8_b, v32i8_c); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmaddwev.h.bu.b(

  // __lasx_xvmaddwod_q_du_d
  // xd, xj, xk
  // V4DI, V4DI, UV4DI, V4DI
  v4i64_r = __lasx_xvmaddwod_q_du_d(v4i64_a, v4u64_b, v4i64_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwod.q.du.d(

  // __lasx_xvmaddwod_d_wu_w
  // xd, xj, xk
  // V4DI, V4DI, UV8SI, V8SI
  v4i64_r = __lasx_xvmaddwod_d_wu_w(v4i64_a, v8u32_b, v8i32_c); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmaddwod.d.wu.w(

  // __lasx_xvmaddwod_w_hu_h
  // xd, xj, xk
  // V8SI, V8SI, UV16HI, V16HI
  v8i32_r = __lasx_xvmaddwod_w_hu_h(v8i32_a, v16u16_b, v16i16_c); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvmaddwod.w.hu.h(

  // __lasx_xvmaddwod_h_bu_b
  // xd, xj, xk
  // V16HI, V16HI, UV32QI, V32QI
  v16i16_r = __lasx_xvmaddwod_h_bu_b(v16i16_a, v32u8_b, v32i8_c); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvmaddwod.h.bu.b(

  // __lasx_xvrotr_b
  // xd, xj, xk
  // V32QI, V32QI, V32QI
  v32i8_r = __lasx_xvrotr_b(v32i8_a, v32i8_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvrotr.b(

  // __lasx_xvrotr_h
  // xd, xj, xk
  // V16HI, V16HI, V16HI
  v16i16_r = __lasx_xvrotr_h(v16i16_a, v16i16_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvrotr.h(

  // __lasx_xvrotr_w
  // xd, xj, xk
  // V8SI, V8SI, V8SI
  v8i32_r = __lasx_xvrotr_w(v8i32_a, v8i32_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvrotr.w(

  // __lasx_xvrotr_d
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvrotr_d(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvrotr.d(

  // __lasx_xvadd_q
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvadd_q(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvadd.q(

  // __lasx_xvsub_q
  // xd, xj, xk
  // V4DI, V4DI, V4DI
  v4i64_r = __lasx_xvsub_q(v4i64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsub.q(

  // __lasx_xvaddwev_q_du_d
  // xd, xj, xk
  // V4DI, UV4DI, V4DI
  v4i64_r = __lasx_xvaddwev_q_du_d(v4u64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwev.q.du.d(

  // __lasx_xvaddwod_q_du_d
  // xd, xj, xk
  // V4DI, UV4DI, V4DI
  v4i64_r = __lasx_xvaddwod_q_du_d(v4u64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvaddwod.q.du.d(

  // __lasx_xvmulwev_q_du_d
  // xd, xj, xk
  // V4DI, UV4DI, V4DI
  v4i64_r = __lasx_xvmulwev_q_du_d(v4u64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwev.q.du.d(

  // __lasx_xvmulwod_q_du_d
  // xd, xj, xk
  // V4DI, UV4DI, V4DI
  v4i64_r = __lasx_xvmulwod_q_du_d(v4u64_a, v4i64_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvmulwod.q.du.d(

  // __lasx_xvmskgez_b
  // xd, xj
  // V32QI, V32QI
  v32i8_r = __lasx_xvmskgez_b(v32i8_a); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmskgez.b(

  // __lasx_xvmsknz_b
  // xd, xj
  // V32QI, V32QI
  v32i8_r = __lasx_xvmsknz_b(v32i8_a); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvmsknz.b(

  // __lasx_xvexth_h_b
  // xd, xj
  // V16HI, V32QI
  v16i16_r = __lasx_xvexth_h_b(v32i8_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvexth.h.b(

  // __lasx_xvexth_w_h
  // xd, xj
  // V8SI, V16HI
  v8i32_r = __lasx_xvexth_w_h(v16i16_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvexth.w.h(

  // __lasx_xvexth_d_w
  // xd, xj
  // V4DI, V8SI
  v4i64_r = __lasx_xvexth_d_w(v8i32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvexth.d.w(

  // __lasx_xvexth_q_d
  // xd, xj
  // V4DI, V4DI
  v4i64_r = __lasx_xvexth_q_d(v4i64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvexth.q.d(

  // __lasx_xvexth_hu_bu
  // xd, xj
  // UV16HI, UV32QI
  v16u16_r = __lasx_xvexth_hu_bu(v32u8_a); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvexth.hu.bu(

  // __lasx_xvexth_wu_hu
  // xd, xj
  // UV8SI, UV16HI
  v8u32_r = __lasx_xvexth_wu_hu(v16u16_a); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvexth.wu.hu(

  // __lasx_xvexth_du_wu
  // xd, xj
  // UV4DI, UV8SI
  v4u64_r = __lasx_xvexth_du_wu(v8u32_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvexth.du.wu(

  // __lasx_xvexth_qu_du
  // xd, xj
  // UV4DI, UV4DI
  v4u64_r = __lasx_xvexth_qu_du(v4u64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvexth.qu.du(

  // __lasx_xvextl_q_d
  // xd, xj
  // V4DI, V4DI
  v4i64_r = __lasx_xvextl_q_d(v4i64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvextl.q.d(

  // __lasx_xvextl_qu_du
  // xd, xj
  // UV4DI, UV4DI
  v4u64_r = __lasx_xvextl_qu_du(v4u64_a); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvextl.qu.du(

  // __lasx_xvrotri_b
  // xd, xj, ui3
  // V32QI, V32QI, UQI
  v32i8_r = __lasx_xvrotri_b(v32i8_a, ui3_b); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvrotri.b(

  // __lasx_xvrotri_h
  // xd, xj, ui4
  // V16HI, V16HI, UQI
  v16i16_r = __lasx_xvrotri_h(v16i16_a, ui4_b); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvrotri.h(

  // __lasx_xvrotri_w
  // xd, xj, ui5
  // V8SI, V8SI, UQI
  v8i32_r = __lasx_xvrotri_w(v8i32_a, ui5_b); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvrotri.w(

  // __lasx_xvrotri_d
  // xd, xj, ui6
  // V4DI, V4DI, UQI
  v4i64_r = __lasx_xvrotri_d(v4i64_a, ui6_b); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvrotri.d(

  // __lasx_xvsrlni_b_h
  // xd, xj, ui4
  // V32QI, V32QI, V32QI, USI
  v32i8_r = __lasx_xvsrlni_b_h(v32i8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrlni.b.h(

  // __lasx_xvsrlni_h_w
  // xd, xj, ui5
  // V16HI, V16HI, V16HI, USI
  v16i16_r = __lasx_xvsrlni_h_w(v16i16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrlni.h.w(

  // __lasx_xvsrlni_w_d
  // xd, xj, ui6
  // V8SI, V8SI, V8SI, USI
  v8i32_r = __lasx_xvsrlni_w_d(v8i32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrlni.w.d(

  // __lasx_xvsrlni_d_q
  // xd, xj, ui7
  // V4DI, V4DI, V4DI, USI
  v4i64_r = __lasx_xvsrlni_d_q(v4i64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrlni.d.q(

  // __lasx_xvsrlrni_b_h
  // xd, xj, ui4
  // V32QI, V32QI, V32QI, USI
  v32i8_r = __lasx_xvsrlrni_b_h(v32i8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrlrni.b.h(

  // __lasx_xvsrlrni_h_w
  // xd, xj, ui5
  // V16HI, V16HI, V16HI, USI
  v16i16_r = __lasx_xvsrlrni_h_w(v16i16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrlrni.h.w(

  // __lasx_xvsrlrni_w_d
  // xd, xj, ui6
  // V8SI, V8SI, V8SI, USI
  v8i32_r = __lasx_xvsrlrni_w_d(v8i32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrlrni.w.d(

  // __lasx_xvsrlrni_d_q
  // xd, xj, ui7
  // V4DI, V4DI, V4DI, USI
  v4i64_r = __lasx_xvsrlrni_d_q(v4i64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrlrni.d.q(

  // __lasx_xvssrlni_b_h
  // xd, xj, ui4
  // V32QI, V32QI, V32QI, USI
  v32i8_r = __lasx_xvssrlni_b_h(v32i8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrlni.b.h(

  // __lasx_xvssrlni_h_w
  // xd, xj, ui5
  // V16HI, V16HI, V16HI, USI
  v16i16_r = __lasx_xvssrlni_h_w(v16i16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrlni.h.w(

  // __lasx_xvssrlni_w_d
  // xd, xj, ui6
  // V8SI, V8SI, V8SI, USI
  v8i32_r = __lasx_xvssrlni_w_d(v8i32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrlni.w.d(

  // __lasx_xvssrlni_d_q
  // xd, xj, ui7
  // V4DI, V4DI, V4DI, USI
  v4i64_r = __lasx_xvssrlni_d_q(v4i64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvssrlni.d.q(

  // __lasx_xvssrlni_bu_h
  // xd, xj, ui4
  // UV32QI, UV32QI, V32QI, USI
  v32u8_r = __lasx_xvssrlni_bu_h(v32u8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrlni.bu.h(

  // __lasx_xvssrlni_hu_w
  // xd, xj, ui5
  // UV16HI, UV16HI, V16HI, USI
  v16u16_r = __lasx_xvssrlni_hu_w(v16u16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrlni.hu.w(

  // __lasx_xvssrlni_wu_d
  // xd, xj, ui6
  // UV8SI, UV8SI, V8SI, USI
  v8u32_r = __lasx_xvssrlni_wu_d(v8u32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrlni.wu.d(

  // __lasx_xvssrlni_du_q
  // xd, xj, ui7
  // UV4DI, UV4DI, V4DI, USI
  v4u64_r = __lasx_xvssrlni_du_q(v4u64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvssrlni.du.q(

  // __lasx_xvssrlrni_b_h
  // xd, xj, ui4
  // V32QI, V32QI, V32QI, USI
  v32i8_r = __lasx_xvssrlrni_b_h(v32i8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrlrni.b.h(

  // __lasx_xvssrlrni_h_w
  // xd, xj, ui5
  // V16HI, V16HI, V16HI, USI
  v16i16_r = __lasx_xvssrlrni_h_w(v16i16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrlrni.h.w(

  // __lasx_xvssrlrni_w_d
  // xd, xj, ui6
  // V8SI, V8SI, V8SI, USI
  v8i32_r = __lasx_xvssrlrni_w_d(v8i32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrlrni.w.d(

  // __lasx_xvssrlrni_d_q
  // xd, xj, ui7
  // V4DI, V4DI, V4DI, USI
  v4i64_r = __lasx_xvssrlrni_d_q(v4i64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvssrlrni.d.q(

  // __lasx_xvssrlrni_bu_h
  // xd, xj, ui4
  // UV32QI, UV32QI, V32QI, USI
  v32u8_r = __lasx_xvssrlrni_bu_h(v32u8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrlrni.bu.h(

  // __lasx_xvssrlrni_hu_w
  // xd, xj, ui5
  // UV16HI, UV16HI, V16HI, USI
  v16u16_r = __lasx_xvssrlrni_hu_w(v16u16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrlrni.hu.w(

  // __lasx_xvssrlrni_wu_d
  // xd, xj, ui6
  // UV8SI, UV8SI, V8SI, USI
  v8u32_r = __lasx_xvssrlrni_wu_d(v8u32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrlrni.wu.d(

  // __lasx_xvssrlrni_du_q
  // xd, xj, ui7
  // UV4DI, UV4DI, V4DI, USI
  v4u64_r = __lasx_xvssrlrni_du_q(v4u64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvssrlrni.du.q(

  // __lasx_xvsrani_b_h
  // xd, xj, ui4
  // V32QI, V32QI, V32QI, USI
  v32i8_r = __lasx_xvsrani_b_h(v32i8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrani.b.h(

  // __lasx_xvsrani_h_w
  // xd, xj, ui5
  // V16HI, V16HI, V16HI, USI
  v16i16_r = __lasx_xvsrani_h_w(v16i16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrani.h.w(

  // __lasx_xvsrani_w_d
  // xd, xj, ui6
  // V8SI, V8SI, V8SI, USI
  v8i32_r = __lasx_xvsrani_w_d(v8i32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrani.w.d(

  // __lasx_xvsrani_d_q
  // xd, xj, ui7
  // V4DI, V4DI, V4DI, USI
  v4i64_r = __lasx_xvsrani_d_q(v4i64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrani.d.q(

  // __lasx_xvsrarni_b_h
  // xd, xj, ui4
  // V32QI, V32QI, V32QI, USI
  v32i8_r = __lasx_xvsrarni_b_h(v32i8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvsrarni.b.h(

  // __lasx_xvsrarni_h_w
  // xd, xj, ui5
  // V16HI, V16HI, V16HI, USI
  v16i16_r = __lasx_xvsrarni_h_w(v16i16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvsrarni.h.w(

  // __lasx_xvsrarni_w_d
  // xd, xj, ui6
  // V8SI, V8SI, V8SI, USI
  v8i32_r = __lasx_xvsrarni_w_d(v8i32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvsrarni.w.d(

  // __lasx_xvsrarni_d_q
  // xd, xj, ui7
  // V4DI, V4DI, V4DI, USI
  v4i64_r = __lasx_xvsrarni_d_q(v4i64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvsrarni.d.q(

  // __lasx_xvssrani_b_h
  // xd, xj, ui4
  // V32QI, V32QI, V32QI, USI
  v32i8_r = __lasx_xvssrani_b_h(v32i8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrani.b.h(

  // __lasx_xvssrani_h_w
  // xd, xj, ui5
  // V16HI, V16HI, V16HI, USI
  v16i16_r = __lasx_xvssrani_h_w(v16i16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrani.h.w(

  // __lasx_xvssrani_w_d
  // xd, xj, ui6
  // V8SI, V8SI, V8SI, USI
  v8i32_r = __lasx_xvssrani_w_d(v8i32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrani.w.d(

  // __lasx_xvssrani_d_q
  // xd, xj, ui7
  // V4DI, V4DI, V4DI, USI
  v4i64_r = __lasx_xvssrani_d_q(v4i64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvssrani.d.q(

  // __lasx_xvssrani_bu_h
  // xd, xj, ui4
  // UV32QI, UV32QI, V32QI, USI
  v32u8_r = __lasx_xvssrani_bu_h(v32u8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrani.bu.h(

  // __lasx_xvssrani_hu_w
  // xd, xj, ui5
  // UV16HI, UV16HI, V16HI, USI
  v16u16_r = __lasx_xvssrani_hu_w(v16u16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrani.hu.w(

  // __lasx_xvssrani_wu_d
  // xd, xj, ui6
  // UV8SI, UV8SI, V8SI, USI
  v8u32_r = __lasx_xvssrani_wu_d(v8u32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrani.wu.d(

  // __lasx_xvssrani_du_q
  // xd, xj, ui7
  // UV4DI, UV4DI, V4DI, USI
  v4u64_r = __lasx_xvssrani_du_q(v4u64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvssrani.du.q(

  // __lasx_xvssrarni_b_h
  // xd, xj, ui4
  // V32QI, V32QI, V32QI, USI
  v32i8_r = __lasx_xvssrarni_b_h(v32i8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrarni.b.h(

  // __lasx_xvssrarni_h_w
  // xd, xj, ui5
  // V16HI, V16HI, V16HI, USI
  v16i16_r = __lasx_xvssrarni_h_w(v16i16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrarni.h.w(

  // __lasx_xvssrarni_w_d
  // xd, xj, ui6
  // V8SI, V8SI, V8SI, USI
  v8i32_r = __lasx_xvssrarni_w_d(v8i32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrarni.w.d(

  // __lasx_xvssrarni_d_q
  // xd, xj, ui7
  // V4DI, V4DI, V4DI, USI
  v4i64_r = __lasx_xvssrarni_d_q(v4i64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvssrarni.d.q(

  // __lasx_xvssrarni_bu_h
  // xd, xj, ui4
  // UV32QI, UV32QI, V32QI, USI
  v32u8_r = __lasx_xvssrarni_bu_h(v32u8_a, v32i8_b, ui4); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvssrarni.bu.h(

  // __lasx_xvssrarni_hu_w
  // xd, xj, ui5
  // UV16HI, UV16HI, V16HI, USI
  v16u16_r = __lasx_xvssrarni_hu_w(v16u16_a, v16i16_b, ui5); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvssrarni.hu.w(

  // __lasx_xvssrarni_wu_d
  // xd, xj, ui6
  // UV8SI, UV8SI, V8SI, USI
  v8u32_r = __lasx_xvssrarni_wu_d(v8u32_a, v8i32_b, ui6); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvssrarni.wu.d(

  // __lasx_xvssrarni_du_q
  // xd, xj, ui7
  // UV4DI, UV4DI, V4DI, USI
  v4u64_r = __lasx_xvssrarni_du_q(v4u64_a, v4i64_b, ui7); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvssrarni.du.q(

  // __lasx_xbnz_v
  // rd, xj
  // SI, UV32QI
  i32_r = __lasx_xbnz_v(v32u8_a); // CHECK: call i32 @llvm.loongarch.lasx.xbnz.v(

  // __lasx_xbz_v
  // rd, xj
  // SI, UV32QI
  i32_r = __lasx_xbz_v(v32u8_a); // CHECK: call i32 @llvm.loongarch.lasx.xbz.v(

  // __lasx_xbnz_b
  // rd, xj
  // SI, UV32QI
  i32_r = __lasx_xbnz_b(v32u8_a); // CHECK: call i32 @llvm.loongarch.lasx.xbnz.b(

  // __lasx_xbnz_h
  // rd, xj
  // SI, UV16HI
  i32_r = __lasx_xbnz_h(v16u16_a); // CHECK: call i32 @llvm.loongarch.lasx.xbnz.h(

  // __lasx_xbnz_w
  // rd, xj
  // SI, UV8SI
  i32_r = __lasx_xbnz_w(v8u32_a); // CHECK: call i32 @llvm.loongarch.lasx.xbnz.w(

  // __lasx_xbnz_d
  // rd, xj
  // SI, UV4DI
  i32_r = __lasx_xbnz_d(v4u64_a); // CHECK: call i32 @llvm.loongarch.lasx.xbnz.d(

  // __lasx_xbz_b
  // rd, xj
  // SI, UV32QI
  i32_r = __lasx_xbz_b(v32u8_a); // CHECK: call i32 @llvm.loongarch.lasx.xbz.b(

  // __lasx_xbz_h
  // rd, xj
  // SI, UV16HI
  i32_r = __lasx_xbz_h(v16u16_a); // CHECK: call i32 @llvm.loongarch.lasx.xbz.h(

  // __lasx_xbz_w
  // rd, xj
  // SI, UV8SI
  i32_r = __lasx_xbz_w(v8u32_a); // CHECK: call i32 @llvm.loongarch.lasx.xbz.w(

  // __lasx_xbz_d
  // rd, xj
  // SI, UV4DI
  i32_r = __lasx_xbz_d(v4u64_a); // CHECK: call i32 @llvm.loongarch.lasx.xbz.d(

  v32i8_r = __lasx_xvrepli_b(2); // CHECK: call <32 x i8> @llvm.loongarch.lasx.xvrepli.b(

  v16i16_r = __lasx_xvrepli_h(2); // CHECK: call <16 x i16> @llvm.loongarch.lasx.xvrepli.h(

  v8i32_r = __lasx_xvrepli_w(2); // CHECK: call <8 x i32> @llvm.loongarch.lasx.xvrepli.w(

  v4i64_r = __lasx_xvrepli_d(2); // CHECK: call <4 x i64> @llvm.loongarch.lasx.xvrepli.d(

  v4f64_r = __lasx_xvpickve_d_f(v4f64_a, 2); // CHECK: call <4 x double> @llvm.loongarch.lasx.xvpickve.d.f(

  v8f32_r = __lasx_xvpickve_w_f(v8f32_a, 2); // CHECK: call <8 x float> @llvm.loongarch.lasx.xvpickve.w.f(
}
