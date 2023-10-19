// REQUIRES: loongarch-registered-target
// RUN: %clang_cc1 -triple loongarch64-unknown-linux-gnu -emit-llvm %s \
// RUN:            -target-feature +lsx \
// RUN:            -o - | FileCheck %s

#include <lsxintrin.h>

#define ui1 0
#define ui2 1
#define ui3 4
#define ui4 7
#define ui5 25
#define ui6 44
#define ui7 100
#define ui8 127 //200
#define si5 -4
#define si8 -100
#define si9 0
#define si10 0
#define si11 0
#define si12 0
#define i10 500
#define i13 4000
#define mode 11
#define idx1 1
#define idx2 2
#define idx3 4
#define idx4 8

void test(void) {
  v16i8 v16i8_a = (v16i8){0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
  v16i8 v16i8_b = (v16i8){1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
  v16i8 v16i8_c = (v16i8){2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17};
  v16i8 v16i8_r;
  v8i16 v8i16_a = (v8i16){0, 1, 2, 3, 4, 5, 6, 7};
  v8i16 v8i16_b = (v8i16){1, 2, 3, 4, 5, 6, 7, 8};
  v8i16 v8i16_c = (v8i16){2, 3, 4, 5, 6, 7, 8, 9};
  v8i16 v8i16_r;
  v4i32 v4i32_a = (v4i32){0, 1, 2, 3};
  v4i32 v4i32_b = (v4i32){1, 2, 3, 4};
  v4i32 v4i32_c = (v4i32){2, 3, 4, 5};
  v4i32 v4i32_r;
  v2i64 v2i64_a = (v2i64){0, 1};
  v2i64 v2i64_b = (v2i64){1, 2};
  v2i64 v2i64_c = (v2i64){2, 3};
  v2i64 v2i64_r;

  v16u8 v16u8_a = (v16u8){0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
  v16u8 v16u8_b = (v16u8){1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
  v16u8 v16u8_c = (v16u8){2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17};
  v16u8 v16u8_r;
  v8u16 v8u16_a = (v8u16){0, 1, 2, 3, 4, 5, 6, 7};
  v8u16 v8u16_b = (v8u16){1, 2, 3, 4, 5, 6, 7, 8};
  v8u16 v8u16_c = (v8u16){2, 3, 4, 5, 6, 7, 8, 9};
  v8u16 v8u16_r;
  v4u32 v4u32_a = (v4u32){0, 1, 2, 3};
  v4u32 v4u32_b = (v4u32){1, 2, 3, 4};
  v4u32 v4u32_c = (v4u32){2, 3, 4, 5};
  v4u32 v4u32_r;
  v2u64 v2u64_a = (v2u64){0, 1};
  v2u64 v2u64_b = (v2u64){1, 2};
  v2u64 v2u64_c = (v2u64){2, 3};
  v2u64 v2u64_r;

  v4f32 v4f32_a = (v4f32){0.5, 1, 2, 3};
  v4f32 v4f32_b = (v4f32){1.5, 2, 3, 4};
  v4f32 v4f32_c = (v4f32){2.5, 3, 4, 5};
  v4f32 v4f32_r;
  v2f64 v2f64_a = (v2f64){0.5, 1};
  v2f64 v2f64_b = (v2f64){1.5, 2};
  v2f64 v2f64_c = (v2f64){2.5, 3};
  v2f64 v2f64_r;

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

  // __lsx_vsll_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vsll_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsll.b(

  // __lsx_vsll_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vsll_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsll.h(

  // __lsx_vsll_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vsll_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsll.w(

  // __lsx_vsll_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsll_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsll.d(

  // __lsx_vslli_b
  // vd, vj, ui3
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vslli_b(v16i8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vslli.b(

  // __lsx_vslli_h
  // vd, vj, ui4
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vslli_h(v8i16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vslli.h(

  // __lsx_vslli_w
  // vd, vj, ui5
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vslli_w(v4i32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vslli.w(

  // __lsx_vslli_d
  // vd, vj, ui6
  // V2DI, V2DI, UQI
  v2i64_r = __lsx_vslli_d(v2i64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vslli.d(

  // __lsx_vsra_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vsra_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsra.b(

  // __lsx_vsra_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vsra_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsra.h(

  // __lsx_vsra_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vsra_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsra.w(

  // __lsx_vsra_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsra_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsra.d(

  // __lsx_vsrai_b
  // vd, vj, ui3
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vsrai_b(v16i8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrai.b(

  // __lsx_vsrai_h
  // vd, vj, ui4
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vsrai_h(v8i16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrai.h(

  // __lsx_vsrai_w
  // vd, vj, ui5
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vsrai_w(v4i32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrai.w(

  // __lsx_vsrai_d
  // vd, vj, ui6
  // V2DI, V2DI, UQI
  v2i64_r = __lsx_vsrai_d(v2i64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrai.d(

  // __lsx_vsrar_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vsrar_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrar.b(

  // __lsx_vsrar_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vsrar_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrar.h(

  // __lsx_vsrar_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vsrar_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrar.w(

  // __lsx_vsrar_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsrar_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrar.d(

  // __lsx_vsrari_b
  // vd, vj, ui3
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vsrari_b(v16i8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrari.b(

  // __lsx_vsrari_h
  // vd, vj, ui4
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vsrari_h(v8i16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrari.h(

  // __lsx_vsrari_w
  // vd, vj, ui5
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vsrari_w(v4i32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrari.w(

  // __lsx_vsrari_d
  // vd, vj, ui6
  // V2DI, V2DI, UQI
  v2i64_r = __lsx_vsrari_d(v2i64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrari.d(

  // __lsx_vsrl_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vsrl_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrl.b(

  // __lsx_vsrl_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vsrl_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrl.h(

  // __lsx_vsrl_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vsrl_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrl.w(

  // __lsx_vsrl_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsrl_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrl.d(

  // __lsx_vsrli_b
  // vd, vj, ui3
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vsrli_b(v16i8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrli.b(

  // __lsx_vsrli_h
  // vd, vj, ui4
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vsrli_h(v8i16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrli.h(

  // __lsx_vsrli_w
  // vd, vj, ui5
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vsrli_w(v4i32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrli.w(

  // __lsx_vsrli_d
  // vd, vj, ui6
  // V2DI, V2DI, UQI
  v2i64_r = __lsx_vsrli_d(v2i64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrli.d(

  // __lsx_vsrlr_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vsrlr_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrlr.b(

  // __lsx_vsrlr_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vsrlr_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrlr.h(

  // __lsx_vsrlr_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vsrlr_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrlr.w(

  // __lsx_vsrlr_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsrlr_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrlr.d(

  // __lsx_vsrlri_b
  // vd, vj, ui3
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vsrlri_b(v16i8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrlri.b(

  // __lsx_vsrlri_h
  // vd, vj, ui4
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vsrlri_h(v8i16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrlri.h(

  // __lsx_vsrlri_w
  // vd, vj, ui5
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vsrlri_w(v4i32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrlri.w(

  // __lsx_vsrlri_d
  // vd, vj, ui6
  // V2DI, V2DI, UQI
  v2i64_r = __lsx_vsrlri_d(v2i64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrlri.d(

  // __lsx_vbitclr_b
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vbitclr_b(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vbitclr.b(

  // __lsx_vbitclr_h
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vbitclr_h(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vbitclr.h(

  // __lsx_vbitclr_w
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vbitclr_w(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vbitclr.w(

  // __lsx_vbitclr_d
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vbitclr_d(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vbitclr.d(

  // __lsx_vbitclri_b
  // vd, vj, ui3
  // UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vbitclri_b(v16u8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vbitclri.b(

  // __lsx_vbitclri_h
  // vd, vj, ui4
  // UV8HI, UV8HI, UQI
  v8u16_r = __lsx_vbitclri_h(v8u16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vbitclri.h(

  // __lsx_vbitclri_w
  // vd, vj, ui5
  // UV4SI, UV4SI, UQI
  v4u32_r = __lsx_vbitclri_w(v4u32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vbitclri.w(

  // __lsx_vbitclri_d
  // vd, vj, ui6
  // UV2DI, UV2DI, UQI
  v2u64_r = __lsx_vbitclri_d(v2u64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vbitclri.d(

  // __lsx_vbitset_b
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vbitset_b(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vbitset.b(

  // __lsx_vbitset_h
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vbitset_h(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vbitset.h(

  // __lsx_vbitset_w
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vbitset_w(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vbitset.w(

  // __lsx_vbitset_d
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vbitset_d(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vbitset.d(

  // __lsx_vbitseti_b
  // vd, vj, ui3
  // UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vbitseti_b(v16u8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vbitseti.b(

  // __lsx_vbitseti_h
  // vd, vj, ui4
  // UV8HI, UV8HI, UQI
  v8u16_r = __lsx_vbitseti_h(v8u16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vbitseti.h(

  // __lsx_vbitseti_w
  // vd, vj, ui5
  // UV4SI, UV4SI, UQI
  v4u32_r = __lsx_vbitseti_w(v4u32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vbitseti.w(

  // __lsx_vbitseti_d
  // vd, vj, ui6
  // UV2DI, UV2DI, UQI
  v2u64_r = __lsx_vbitseti_d(v2u64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vbitseti.d(

  // __lsx_vbitrev_b
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vbitrev_b(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vbitrev.b(

  // __lsx_vbitrev_h
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vbitrev_h(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vbitrev.h(

  // __lsx_vbitrev_w
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vbitrev_w(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vbitrev.w(

  // __lsx_vbitrev_d
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vbitrev_d(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vbitrev.d(

  // __lsx_vbitrevi_b
  // vd, vj, ui3
  // UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vbitrevi_b(v16u8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vbitrevi.b(

  // __lsx_vbitrevi_h
  // vd, vj, ui4
  // UV8HI, UV8HI, UQI
  v8u16_r = __lsx_vbitrevi_h(v8u16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vbitrevi.h(

  // __lsx_vbitrevi_w
  // vd, vj, ui5
  // UV4SI, UV4SI, UQI
  v4u32_r = __lsx_vbitrevi_w(v4u32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vbitrevi.w(

  // __lsx_vbitrevi_d
  // vd, vj, ui6
  // UV2DI, UV2DI, UQI
  v2u64_r = __lsx_vbitrevi_d(v2u64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vbitrevi.d(

  // __lsx_vadd_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vadd_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vadd.b(

  // __lsx_vadd_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vadd_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vadd.h(

  // __lsx_vadd_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vadd_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vadd.w(

  // __lsx_vadd_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vadd_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vadd.d(

  // __lsx_vaddi_bu
  // vd, vj, ui5
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vaddi_bu(v16i8_a, ui5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vaddi.bu(

  // __lsx_vaddi_hu
  // vd, vj, ui5
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vaddi_hu(v8i16_a, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vaddi.hu(

  // __lsx_vaddi_wu
  // vd, vj, ui5
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vaddi_wu(v4i32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vaddi.wu(

  // __lsx_vaddi_du
  // vd, vj, ui5
  // V2DI, V2DI, UQI
  v2i64_r = __lsx_vaddi_du(v2i64_a, ui5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddi.du(

  // __lsx_vsub_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vsub_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsub.b(

  // __lsx_vsub_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vsub_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsub.h(

  // __lsx_vsub_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vsub_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsub.w(

  // __lsx_vsub_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsub_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsub.d(

  // __lsx_vsubi_bu
  // vd, vj, ui5
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vsubi_bu(v16i8_a, ui5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsubi.bu(

  // __lsx_vsubi_hu
  // vd, vj, ui5
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vsubi_hu(v8i16_a, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsubi.hu(

  // __lsx_vsubi_wu
  // vd, vj, ui5
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vsubi_wu(v4i32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsubi.wu(

  // __lsx_vsubi_du
  // vd, vj, ui5
  // V2DI, V2DI, UQI
  v2i64_r = __lsx_vsubi_du(v2i64_a, ui5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsubi.du(

  // __lsx_vmax_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vmax_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmax.b(

  // __lsx_vmax_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vmax_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmax.h(

  // __lsx_vmax_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vmax_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmax.w(

  // __lsx_vmax_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmax_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmax.d(

  // __lsx_vmaxi_b
  // vd, vj, si5
  // V16QI, V16QI, QI
  v16i8_r = __lsx_vmaxi_b(v16i8_a, si5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmaxi.b(

  // __lsx_vmaxi_h
  // vd, vj, si5
  // V8HI, V8HI, QI
  v8i16_r = __lsx_vmaxi_h(v8i16_a, si5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmaxi.h(

  // __lsx_vmaxi_w
  // vd, vj, si5
  // V4SI, V4SI, QI
  v4i32_r = __lsx_vmaxi_w(v4i32_a, si5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmaxi.w(

  // __lsx_vmaxi_d
  // vd, vj, si5
  // V2DI, V2DI, QI
  v2i64_r = __lsx_vmaxi_d(v2i64_a, si5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaxi.d(

  // __lsx_vmax_bu
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vmax_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmax.bu(

  // __lsx_vmax_hu
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vmax_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmax.hu(

  // __lsx_vmax_wu
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vmax_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmax.wu(

  // __lsx_vmax_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vmax_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmax.du(

  // __lsx_vmaxi_bu
  // vd, vj, ui5
  // UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vmaxi_bu(v16u8_a, ui5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmaxi.bu(

  // __lsx_vmaxi_hu
  // vd, vj, ui5
  // UV8HI, UV8HI, UQI
  v8u16_r = __lsx_vmaxi_hu(v8u16_a, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmaxi.hu(

  // __lsx_vmaxi_wu
  // vd, vj, ui5
  // UV4SI, UV4SI, UQI
  v4u32_r = __lsx_vmaxi_wu(v4u32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmaxi.wu(

  // __lsx_vmaxi_du
  // vd, vj, ui5
  // UV2DI, UV2DI, UQI
  v2u64_r = __lsx_vmaxi_du(v2u64_a, ui5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaxi.du(

  // __lsx_vmin_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vmin_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmin.b(

  // __lsx_vmin_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vmin_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmin.h(

  // __lsx_vmin_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vmin_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmin.w(

  // __lsx_vmin_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmin_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmin.d(

  // __lsx_vmini_b
  // vd, vj, si5
  // V16QI, V16QI, QI
  v16i8_r = __lsx_vmini_b(v16i8_a, si5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmini.b(

  // __lsx_vmini_h
  // vd, vj, si5
  // V8HI, V8HI, QI
  v8i16_r = __lsx_vmini_h(v8i16_a, si5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmini.h(

  // __lsx_vmini_w
  // vd, vj, si5
  // V4SI, V4SI, QI
  v4i32_r = __lsx_vmini_w(v4i32_a, si5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmini.w(

  // __lsx_vmini_d
  // vd, vj, si5
  // V2DI, V2DI, QI
  v2i64_r = __lsx_vmini_d(v2i64_a, si5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmini.d(

  // __lsx_vmin_bu
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vmin_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmin.bu(

  // __lsx_vmin_hu
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vmin_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmin.hu(

  // __lsx_vmin_wu
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vmin_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmin.wu(

  // __lsx_vmin_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vmin_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmin.du(

  // __lsx_vmini_bu
  // vd, vj, ui5
  // UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vmini_bu(v16u8_a, ui5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmini.bu(

  // __lsx_vmini_hu
  // vd, vj, ui5
  // UV8HI, UV8HI, UQI
  v8u16_r = __lsx_vmini_hu(v8u16_a, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmini.hu(

  // __lsx_vmini_wu
  // vd, vj, ui5
  // UV4SI, UV4SI, UQI
  v4u32_r = __lsx_vmini_wu(v4u32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmini.wu(

  // __lsx_vmini_du
  // vd, vj, ui5
  // UV2DI, UV2DI, UQI
  v2u64_r = __lsx_vmini_du(v2u64_a, ui5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmini.du(

  // __lsx_vseq_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vseq_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vseq.b(

  // __lsx_vseq_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vseq_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vseq.h(

  // __lsx_vseq_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vseq_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vseq.w(

  // __lsx_vseq_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vseq_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vseq.d(

  // __lsx_vseqi_b
  // vd, vj, si5
  // V16QI, V16QI, QI
  v16i8_r = __lsx_vseqi_b(v16i8_a, si5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vseqi.b(

  // __lsx_vseqi_h
  // vd, vj, si5
  // V8HI, V8HI, QI
  v8i16_r = __lsx_vseqi_h(v8i16_a, si5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vseqi.h(

  // __lsx_vseqi_w
  // vd, vj, si5
  // V4SI, V4SI, QI
  v4i32_r = __lsx_vseqi_w(v4i32_a, si5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vseqi.w(

  // __lsx_vseqi_d
  // vd, vj, si5
  // V2DI, V2DI, QI
  v2i64_r = __lsx_vseqi_d(v2i64_a, si5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vseqi.d(

  // __lsx_vslti_b
  // vd, vj, si5
  // V16QI, V16QI, QI
  v16i8_r = __lsx_vslti_b(v16i8_a, si5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vslti.b(

  // __lsx_vslt_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vslt_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vslt.b(

  // __lsx_vslt_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vslt_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vslt.h(

  // __lsx_vslt_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vslt_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vslt.w(

  // __lsx_vslt_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vslt_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vslt.d(

  // __lsx_vslti_h
  // vd, vj, si5
  // V8HI, V8HI, QI
  v8i16_r = __lsx_vslti_h(v8i16_a, si5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vslti.h(

  // __lsx_vslti_w
  // vd, vj, si5
  // V4SI, V4SI, QI
  v4i32_r = __lsx_vslti_w(v4i32_a, si5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vslti.w(

  // __lsx_vslti_d
  // vd, vj, si5
  // V2DI, V2DI, QI
  v2i64_r = __lsx_vslti_d(v2i64_a, si5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vslti.d(

  // __lsx_vslt_bu
  // vd, vj, vk
  // V16QI, UV16QI, UV16QI
  v16i8_r = __lsx_vslt_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vslt.bu(

  // __lsx_vslt_hu
  // vd, vj, vk
  // V8HI, UV8HI, UV8HI
  v8i16_r = __lsx_vslt_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vslt.hu(

  // __lsx_vslt_wu
  // vd, vj, vk
  // V4SI, UV4SI, UV4SI
  v4i32_r = __lsx_vslt_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vslt.wu(

  // __lsx_vslt_du
  // vd, vj, vk
  // V2DI, UV2DI, UV2DI
  v2i64_r = __lsx_vslt_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vslt.du(

  // __lsx_vslti_bu
  // vd, vj, ui5
  // V16QI, UV16QI, UQI
  v16i8_r = __lsx_vslti_bu(v16u8_a, ui5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vslti.bu(

  // __lsx_vslti_hu
  // vd, vj, ui5
  // V8HI, UV8HI, UQI
  v8i16_r = __lsx_vslti_hu(v8u16_a, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vslti.hu(

  // __lsx_vslti_wu
  // vd, vj, ui5
  // V4SI, UV4SI, UQI
  v4i32_r = __lsx_vslti_wu(v4u32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vslti.wu(

  // __lsx_vslti_du
  // vd, vj, ui5
  // V2DI, UV2DI, UQI
  v2i64_r = __lsx_vslti_du(v2u64_a, ui5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vslti.du(

  // __lsx_vsle_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vsle_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsle.b(

  // __lsx_vsle_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vsle_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsle.h(

  // __lsx_vsle_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vsle_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsle.w(

  // __lsx_vsle_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsle_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsle.d(

  // __lsx_vslei_b
  // vd, vj, si5
  // V16QI, V16QI, QI
  v16i8_r = __lsx_vslei_b(v16i8_a, si5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vslei.b(

  // __lsx_vslei_h
  // vd, vj, si5
  // V8HI, V8HI, QI
  v8i16_r = __lsx_vslei_h(v8i16_a, si5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vslei.h(

  // __lsx_vslei_w
  // vd, vj, si5
  // V4SI, V4SI, QI
  v4i32_r = __lsx_vslei_w(v4i32_a, si5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vslei.w(

  // __lsx_vslei_d
  // vd, vj, si5
  // V2DI, V2DI, QI
  v2i64_r = __lsx_vslei_d(v2i64_a, si5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vslei.d(

  // __lsx_vsle_bu
  // vd, vj, vk
  // V16QI, UV16QI, UV16QI
  v16i8_r = __lsx_vsle_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsle.bu(

  // __lsx_vsle_hu
  // vd, vj, vk
  // V8HI, UV8HI, UV8HI
  v8i16_r = __lsx_vsle_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsle.hu(

  // __lsx_vsle_wu
  // vd, vj, vk
  // V4SI, UV4SI, UV4SI
  v4i32_r = __lsx_vsle_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsle.wu(

  // __lsx_vsle_du
  // vd, vj, vk
  // V2DI, UV2DI, UV2DI
  v2i64_r = __lsx_vsle_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsle.du(

  // __lsx_vslei_bu
  // vd, vj, ui5
  // V16QI, UV16QI, UQI
  v16i8_r = __lsx_vslei_bu(v16u8_a, ui5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vslei.bu(

  // __lsx_vslei_hu
  // vd, vj, ui5
  // V8HI, UV8HI, UQI
  v8i16_r = __lsx_vslei_hu(v8u16_a, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vslei.hu(

  // __lsx_vslei_wu
  // vd, vj, ui5
  // V4SI, UV4SI, UQI
  v4i32_r = __lsx_vslei_wu(v4u32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vslei.wu(

  // __lsx_vslei_du
  // vd, vj, ui5
  // V2DI, UV2DI, UQI
  v2i64_r = __lsx_vslei_du(v2u64_a, ui5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vslei.du(

  // __lsx_vsat_b
  // vd, vj, ui3
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vsat_b(v16i8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsat.b(

  // __lsx_vsat_h
  // vd, vj, ui4
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vsat_h(v8i16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsat.h(

  // __lsx_vsat_w
  // vd, vj, ui5
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vsat_w(v4i32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsat.w(

  // __lsx_vsat_d
  // vd, vj, ui6
  // V2DI, V2DI, UQI
  v2i64_r = __lsx_vsat_d(v2i64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsat.d(

  // __lsx_vsat_bu
  // vd, vj, ui3
  // UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vsat_bu(v16u8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsat.bu(

  // __lsx_vsat_hu
  // vd, vj, ui4
  // UV8HI, UV8HI, UQI
  v8u16_r = __lsx_vsat_hu(v8u16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsat.hu(

  // __lsx_vsat_wu
  // vd, vj, ui5
  // UV4SI, UV4SI, UQI
  v4u32_r = __lsx_vsat_wu(v4u32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsat.wu(

  // __lsx_vsat_du
  // vd, vj, ui6
  // UV2DI, UV2DI, UQI
  v2u64_r = __lsx_vsat_du(v2u64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsat.du(

  // __lsx_vadda_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vadda_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vadda.b(

  // __lsx_vadda_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vadda_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vadda.h(

  // __lsx_vadda_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vadda_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vadda.w(

  // __lsx_vadda_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vadda_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vadda.d(

  // __lsx_vsadd_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vsadd_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsadd.b(

  // __lsx_vsadd_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vsadd_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsadd.h(

  // __lsx_vsadd_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vsadd_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsadd.w(

  // __lsx_vsadd_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsadd_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsadd.d(

  // __lsx_vsadd_bu
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vsadd_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsadd.bu(

  // __lsx_vsadd_hu
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vsadd_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsadd.hu(

  // __lsx_vsadd_wu
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vsadd_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsadd.wu(

  // __lsx_vsadd_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vsadd_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsadd.du(

  // __lsx_vavg_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vavg_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vavg.b(

  // __lsx_vavg_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vavg_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vavg.h(

  // __lsx_vavg_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vavg_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vavg.w(

  // __lsx_vavg_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vavg_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vavg.d(

  // __lsx_vavg_bu
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vavg_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vavg.bu(

  // __lsx_vavg_hu
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vavg_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vavg.hu(

  // __lsx_vavg_wu
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vavg_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vavg.wu(

  // __lsx_vavg_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vavg_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vavg.du(

  // __lsx_vavgr_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vavgr_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vavgr.b(

  // __lsx_vavgr_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vavgr_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vavgr.h(

  // __lsx_vavgr_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vavgr_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vavgr.w(

  // __lsx_vavgr_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vavgr_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vavgr.d(

  // __lsx_vavgr_bu
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vavgr_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vavgr.bu(

  // __lsx_vavgr_hu
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vavgr_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vavgr.hu(

  // __lsx_vavgr_wu
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vavgr_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vavgr.wu(

  // __lsx_vavgr_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vavgr_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vavgr.du(

  // __lsx_vssub_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vssub_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssub.b(

  // __lsx_vssub_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vssub_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssub.h(

  // __lsx_vssub_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vssub_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssub.w(

  // __lsx_vssub_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vssub_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vssub.d(

  // __lsx_vssub_bu
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vssub_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssub.bu(

  // __lsx_vssub_hu
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vssub_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssub.hu(

  // __lsx_vssub_wu
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vssub_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssub.wu(

  // __lsx_vssub_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vssub_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vssub.du(

  // __lsx_vabsd_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vabsd_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vabsd.b(

  // __lsx_vabsd_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vabsd_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vabsd.h(

  // __lsx_vabsd_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vabsd_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vabsd.w(

  // __lsx_vabsd_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vabsd_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vabsd.d(

  // __lsx_vabsd_bu
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vabsd_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vabsd.bu(

  // __lsx_vabsd_hu
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vabsd_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vabsd.hu(

  // __lsx_vabsd_wu
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vabsd_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vabsd.wu(

  // __lsx_vabsd_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vabsd_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vabsd.du(

  // __lsx_vmul_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vmul_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmul.b(

  // __lsx_vmul_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vmul_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmul.h(

  // __lsx_vmul_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vmul_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmul.w(

  // __lsx_vmul_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmul_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmul.d(

  // __lsx_vmadd_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI, V16QI
  v16i8_r = __lsx_vmadd_b(v16i8_a, v16i8_b, v16i8_c); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmadd.b(

  // __lsx_vmadd_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI, V8HI
  v8i16_r = __lsx_vmadd_h(v8i16_a, v8i16_b, v8i16_c); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmadd.h(

  // __lsx_vmadd_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI, V4SI
  v4i32_r = __lsx_vmadd_w(v4i32_a, v4i32_b, v4i32_c); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmadd.w(

  // __lsx_vmadd_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmadd_d(v2i64_a, v2i64_b, v2i64_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmadd.d(

  // __lsx_vmsub_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI, V16QI
  v16i8_r = __lsx_vmsub_b(v16i8_a, v16i8_b, v16i8_c); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmsub.b(

  // __lsx_vmsub_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI, V8HI
  v8i16_r = __lsx_vmsub_h(v8i16_a, v8i16_b, v8i16_c); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmsub.h(

  // __lsx_vmsub_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI, V4SI
  v4i32_r = __lsx_vmsub_w(v4i32_a, v4i32_b, v4i32_c); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmsub.w(

  // __lsx_vmsub_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmsub_d(v2i64_a, v2i64_b, v2i64_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmsub.d(

  // __lsx_vdiv_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vdiv_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vdiv.b(

  // __lsx_vdiv_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vdiv_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vdiv.h(

  // __lsx_vdiv_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vdiv_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vdiv.w(

  // __lsx_vdiv_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vdiv_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vdiv.d(

  // __lsx_vdiv_bu
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vdiv_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vdiv.bu(

  // __lsx_vdiv_hu
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vdiv_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vdiv.hu(

  // __lsx_vdiv_wu
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vdiv_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vdiv.wu(

  // __lsx_vdiv_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vdiv_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vdiv.du(

  // __lsx_vhaddw_h_b
  // vd, vj, vk
  // V8HI, V16QI, V16QI
  v8i16_r = __lsx_vhaddw_h_b(v16i8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vhaddw.h.b(

  // __lsx_vhaddw_w_h
  // vd, vj, vk
  // V4SI, V8HI, V8HI
  v4i32_r = __lsx_vhaddw_w_h(v8i16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vhaddw.w.h(

  // __lsx_vhaddw_d_w
  // vd, vj, vk
  // V2DI, V4SI, V4SI
  v2i64_r = __lsx_vhaddw_d_w(v4i32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vhaddw.d.w(

  // __lsx_vhaddw_hu_bu
  // vd, vj, vk
  // UV8HI, UV16QI, UV16QI
  v8u16_r = __lsx_vhaddw_hu_bu(v16u8_a, v16u8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vhaddw.hu.bu(

  // __lsx_vhaddw_wu_hu
  // vd, vj, vk
  // UV4SI, UV8HI, UV8HI
  v4u32_r = __lsx_vhaddw_wu_hu(v8u16_a, v8u16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vhaddw.wu.hu(

  // __lsx_vhaddw_du_wu
  // vd, vj, vk
  // UV2DI, UV4SI, UV4SI
  v2u64_r = __lsx_vhaddw_du_wu(v4u32_a, v4u32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vhaddw.du.wu(

  // __lsx_vhsubw_h_b
  // vd, vj, vk
  // V8HI, V16QI, V16QI
  v8i16_r = __lsx_vhsubw_h_b(v16i8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vhsubw.h.b(

  // __lsx_vhsubw_w_h
  // vd, vj, vk
  // V4SI, V8HI, V8HI
  v4i32_r = __lsx_vhsubw_w_h(v8i16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vhsubw.w.h(

  // __lsx_vhsubw_d_w
  // vd, vj, vk
  // V2DI, V4SI, V4SI
  v2i64_r = __lsx_vhsubw_d_w(v4i32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vhsubw.d.w(

  // __lsx_vhsubw_hu_bu
  // vd, vj, vk
  // V8HI, UV16QI, UV16QI
  v8i16_r = __lsx_vhsubw_hu_bu(v16u8_a, v16u8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vhsubw.hu.bu(

  // __lsx_vhsubw_wu_hu
  // vd, vj, vk
  // V4SI, UV8HI, UV8HI
  v4i32_r = __lsx_vhsubw_wu_hu(v8u16_a, v8u16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vhsubw.wu.hu(

  // __lsx_vhsubw_du_wu
  // vd, vj, vk
  // V2DI, UV4SI, UV4SI
  v2i64_r = __lsx_vhsubw_du_wu(v4u32_a, v4u32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vhsubw.du.wu(

  // __lsx_vmod_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vmod_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmod.b(

  // __lsx_vmod_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vmod_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmod.h(

  // __lsx_vmod_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vmod_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmod.w(

  // __lsx_vmod_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmod_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmod.d(

  // __lsx_vmod_bu
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vmod_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmod.bu(

  // __lsx_vmod_hu
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vmod_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmod.hu(

  // __lsx_vmod_wu
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vmod_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmod.wu(

  // __lsx_vmod_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vmod_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmod.du(

  // __lsx_vreplve_b
  // vd, vj, rk
  // V16QI, V16QI, SI
  v16i8_r = __lsx_vreplve_b(v16i8_a, i32_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vreplve.b(

  // __lsx_vreplve_h
  // vd, vj, rk
  // V8HI, V8HI, SI
  v8i16_r = __lsx_vreplve_h(v8i16_a, i32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vreplve.h(

  // __lsx_vreplve_w
  // vd, vj, rk
  // V4SI, V4SI, SI
  v4i32_r = __lsx_vreplve_w(v4i32_a, i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vreplve.w(

  // __lsx_vreplve_d
  // vd, vj, rk
  // V2DI, V2DI, SI
  v2i64_r = __lsx_vreplve_d(v2i64_a, i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vreplve.d(

  // __lsx_vreplvei_b
  // vd, vj, ui4
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vreplvei_b(v16i8_a, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vreplvei.b(

  // __lsx_vreplvei_h
  // vd, vj, ui3
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vreplvei_h(v8i16_a, ui3); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vreplvei.h(

  // __lsx_vreplvei_w
  // vd, vj, ui2
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vreplvei_w(v4i32_a, ui2); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vreplvei.w(

  // __lsx_vreplvei_d
  // vd, vj, ui1
  // V2DI, V2DI, UQI
  v2i64_r = __lsx_vreplvei_d(v2i64_a, ui1); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vreplvei.d(

  // __lsx_vpickev_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vpickev_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vpickev.b(

  // __lsx_vpickev_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vpickev_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vpickev.h(

  // __lsx_vpickev_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vpickev_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vpickev.w(

  // __lsx_vpickev_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vpickev_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vpickev.d(

  // __lsx_vpickod_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vpickod_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vpickod.b(

  // __lsx_vpickod_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vpickod_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vpickod.h(

  // __lsx_vpickod_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vpickod_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vpickod.w(

  // __lsx_vpickod_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vpickod_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vpickod.d(

  // __lsx_vilvh_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vilvh_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vilvh.b(

  // __lsx_vilvh_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vilvh_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vilvh.h(

  // __lsx_vilvh_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vilvh_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vilvh.w(

  // __lsx_vilvh_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vilvh_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vilvh.d(

  // __lsx_vilvl_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vilvl_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vilvl.b(

  // __lsx_vilvl_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vilvl_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vilvl.h(

  // __lsx_vilvl_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vilvl_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vilvl.w(

  // __lsx_vilvl_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vilvl_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vilvl.d(

  // __lsx_vpackev_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vpackev_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vpackev.b(

  // __lsx_vpackev_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vpackev_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vpackev.h(

  // __lsx_vpackev_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vpackev_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vpackev.w(

  // __lsx_vpackev_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vpackev_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vpackev.d(

  // __lsx_vpackod_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vpackod_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vpackod.b(

  // __lsx_vpackod_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vpackod_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vpackod.h(

  // __lsx_vpackod_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vpackod_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vpackod.w(

  // __lsx_vpackod_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vpackod_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vpackod.d(

  // __lsx_vshuf_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI, V8HI
  v8i16_r = __lsx_vshuf_h(v8i16_a, v8i16_b, v8i16_c); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vshuf.h(

  // __lsx_vshuf_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI, V4SI
  v4i32_r = __lsx_vshuf_w(v4i32_a, v4i32_b, v4i32_c); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vshuf.w(

  // __lsx_vshuf_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI, V2DI
  v2i64_r = __lsx_vshuf_d(v2i64_a, v2i64_b, v2i64_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vshuf.d(

  // __lsx_vand_v
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vand_v(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vand.v(

  // __lsx_vandi_b
  // vd, vj, ui8
  // UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vandi_b(v16u8_a, ui8); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vandi.b(

  // __lsx_vor_v
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vor_v(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vor.v(

  // __lsx_vori_b
  // vd, vj, ui8
  // UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vori_b(v16u8_a, ui8); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vori.b(

  // __lsx_vnor_v
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vnor_v(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vnor.v(

  // __lsx_vnori_b
  // vd, vj, ui8
  // UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vnori_b(v16u8_a, ui8); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vnori.b(

  // __lsx_vxor_v
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vxor_v(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vxor.v(

  // __lsx_vxori_b
  // vd, vj, ui8
  // UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vxori_b(v16u8_a, ui8); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vxori.b(

  // __lsx_vbitsel_v
  // vd, vj, vk, va
  // UV16QI, UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vbitsel_v(v16u8_a, v16u8_b, v16u8_c); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vbitsel.v(

  // __lsx_vbitseli_b
  // vd, vj, ui8
  // UV16QI, UV16QI, UV16QI, UQI
  v16u8_r = __lsx_vbitseli_b(v16u8_a, v16u8_b, ui8); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vbitseli.b(

  // __lsx_vshuf4i_b
  // vd, vj, ui8
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vshuf4i_b(v16i8_a, ui8); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vshuf4i.b(

  // __lsx_vshuf4i_h
  // vd, vj, ui8
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vshuf4i_h(v8i16_a, ui8); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vshuf4i.h(

  // __lsx_vshuf4i_w
  // vd, vj, ui8
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vshuf4i_w(v4i32_a, ui8); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vshuf4i.w(

  // __lsx_vreplgr2vr_b
  // vd, rj
  // V16QI, SI
  v16i8_r = __lsx_vreplgr2vr_b(i32_a); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vreplgr2vr.b(

  // __lsx_vreplgr2vr_h
  // vd, rj
  // V8HI, SI
  v8i16_r = __lsx_vreplgr2vr_h(i32_a); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vreplgr2vr.h(

  // __lsx_vreplgr2vr_w
  // vd, rj
  // V4SI, SI
  v4i32_r = __lsx_vreplgr2vr_w(i32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vreplgr2vr.w(

  // __lsx_vreplgr2vr_d
  // vd, rj
  // V2DI, DI
  v2i64_r = __lsx_vreplgr2vr_d(i64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vreplgr2vr.d(

  // __lsx_vpcnt_b
  // vd, vj
  // V16QI, V16QI
  v16i8_r = __lsx_vpcnt_b(v16i8_a); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vpcnt.b(

  // __lsx_vpcnt_h
  // vd, vj
  // V8HI, V8HI
  v8i16_r = __lsx_vpcnt_h(v8i16_a); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vpcnt.h(

  // __lsx_vpcnt_w
  // vd, vj
  // V4SI, V4SI
  v4i32_r = __lsx_vpcnt_w(v4i32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vpcnt.w(

  // __lsx_vpcnt_d
  // vd, vj
  // V2DI, V2DI
  v2i64_r = __lsx_vpcnt_d(v2i64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vpcnt.d(

  // __lsx_vclo_b
  // vd, vj
  // V16QI, V16QI
  v16i8_r = __lsx_vclo_b(v16i8_a); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vclo.b(

  // __lsx_vclo_h
  // vd, vj
  // V8HI, V8HI
  v8i16_r = __lsx_vclo_h(v8i16_a); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vclo.h(

  // __lsx_vclo_w
  // vd, vj
  // V4SI, V4SI
  v4i32_r = __lsx_vclo_w(v4i32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vclo.w(

  // __lsx_vclo_d
  // vd, vj
  // V2DI, V2DI
  v2i64_r = __lsx_vclo_d(v2i64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vclo.d(

  // __lsx_vclz_b
  // vd, vj
  // V16QI, V16QI
  v16i8_r = __lsx_vclz_b(v16i8_a); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vclz.b(

  // __lsx_vclz_h
  // vd, vj
  // V8HI, V8HI
  v8i16_r = __lsx_vclz_h(v8i16_a); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vclz.h(

  // __lsx_vclz_w
  // vd, vj
  // V4SI, V4SI
  v4i32_r = __lsx_vclz_w(v4i32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vclz.w(

  // __lsx_vclz_d
  // vd, vj
  // V2DI, V2DI
  v2i64_r = __lsx_vclz_d(v2i64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vclz.d(

  // __lsx_vpickve2gr_b
  // rd, vj, ui4
  // SI, V16QI, UQI
  i32_r = __lsx_vpickve2gr_b(v16i8_a, ui4); // CHECK: call i32 @llvm.loongarch.lsx.vpickve2gr.b(

  // __lsx_vpickve2gr_h
  // rd, vj, ui3
  // SI, V8HI, UQI
  i32_r = __lsx_vpickve2gr_h(v8i16_a, ui3); // CHECK: call i32 @llvm.loongarch.lsx.vpickve2gr.h(

  // __lsx_vpickve2gr_w
  // rd, vj, ui2
  // SI, V4SI, UQI
  i32_r = __lsx_vpickve2gr_w(v4i32_a, ui2); // CHECK: call i32 @llvm.loongarch.lsx.vpickve2gr.w(

  // __lsx_vpickve2gr_d
  // rd, vj, ui1
  // DI, V2DI, UQI
  i64_r = __lsx_vpickve2gr_d(v2i64_a, ui1); // CHECK: call i64 @llvm.loongarch.lsx.vpickve2gr.d(

  // __lsx_vpickve2gr_bu
  // rd, vj, ui4
  // USI, V16QI, UQI
  u32_r = __lsx_vpickve2gr_bu(v16i8_a, ui4); // CHECK: call i32 @llvm.loongarch.lsx.vpickve2gr.bu(

  // __lsx_vpickve2gr_hu
  // rd, vj, ui3
  // USI, V8HI, UQI
  u32_r = __lsx_vpickve2gr_hu(v8i16_a, ui3); // CHECK: call i32 @llvm.loongarch.lsx.vpickve2gr.hu(

  // __lsx_vpickve2gr_wu
  // rd, vj, ui2
  // USI, V4SI, UQI
  u32_r = __lsx_vpickve2gr_wu(v4i32_a, ui2); // CHECK: call i32 @llvm.loongarch.lsx.vpickve2gr.wu(

  // __lsx_vpickve2gr_du
  // rd, vj, ui1
  // UDI, V2DI, UQI
  u64_r = __lsx_vpickve2gr_du(v2i64_a, ui1); // CHECK: call i64 @llvm.loongarch.lsx.vpickve2gr.du(

  // __lsx_vinsgr2vr_b
  // vd, rj, ui4
  // V16QI, V16QI, SI, UQI
  v16i8_r = __lsx_vinsgr2vr_b(v16i8_a, i32_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vinsgr2vr.b(

  // __lsx_vinsgr2vr_h
  // vd, rj, ui3
  // V8HI, V8HI, SI, UQI
  v8i16_r = __lsx_vinsgr2vr_h(v8i16_a, i32_b, ui3); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vinsgr2vr.h(

  // __lsx_vinsgr2vr_w
  // vd, rj, ui2
  // V4SI, V4SI, SI, UQI
  v4i32_r = __lsx_vinsgr2vr_w(v4i32_a, i32_b, ui2); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vinsgr2vr.w(

  // __lsx_vinsgr2vr_d
  // vd, rj, ui1
  // V2DI, V2DI, SI, UQI
  v2i64_r = __lsx_vinsgr2vr_d(v2i64_a, i32_b, ui1); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vinsgr2vr.d(

  // __lsx_vfcmp_caf_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_caf_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.caf.s(

  // __lsx_vfcmp_caf_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_caf_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.caf.d(

  // __lsx_vfcmp_cor_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_cor_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.cor.s(

  // __lsx_vfcmp_cor_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_cor_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.cor.d(

  // __lsx_vfcmp_cun_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_cun_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.cun.s(

  // __lsx_vfcmp_cun_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_cun_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.cun.d(

  // __lsx_vfcmp_cune_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_cune_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.cune.s(

  // __lsx_vfcmp_cune_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_cune_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.cune.d(

  // __lsx_vfcmp_cueq_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_cueq_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.cueq.s(

  // __lsx_vfcmp_cueq_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_cueq_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.cueq.d(

  // __lsx_vfcmp_ceq_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_ceq_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.ceq.s(

  // __lsx_vfcmp_ceq_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_ceq_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.ceq.d(

  // __lsx_vfcmp_cne_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_cne_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.cne.s(

  // __lsx_vfcmp_cne_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_cne_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.cne.d(

  // __lsx_vfcmp_clt_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_clt_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.clt.s(

  // __lsx_vfcmp_clt_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_clt_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.clt.d(

  // __lsx_vfcmp_cult_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_cult_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.cult.s(

  // __lsx_vfcmp_cult_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_cult_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.cult.d(

  // __lsx_vfcmp_cle_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_cle_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.cle.s(

  // __lsx_vfcmp_cle_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_cle_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.cle.d(

  // __lsx_vfcmp_cule_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_cule_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.cule.s(

  // __lsx_vfcmp_cule_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_cule_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.cule.d(

  // __lsx_vfcmp_saf_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_saf_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.saf.s(

  // __lsx_vfcmp_saf_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_saf_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.saf.d(

  // __lsx_vfcmp_sor_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_sor_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.sor.s(

  // __lsx_vfcmp_sor_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_sor_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.sor.d(

  // __lsx_vfcmp_sun_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_sun_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.sun.s(

  // __lsx_vfcmp_sun_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_sun_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.sun.d(

  // __lsx_vfcmp_sune_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_sune_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.sune.s(

  // __lsx_vfcmp_sune_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_sune_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.sune.d(

  // __lsx_vfcmp_sueq_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_sueq_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.sueq.s(

  // __lsx_vfcmp_sueq_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_sueq_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.sueq.d(

  // __lsx_vfcmp_seq_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_seq_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.seq.s(

  // __lsx_vfcmp_seq_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_seq_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.seq.d(

  // __lsx_vfcmp_sne_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_sne_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.sne.s(

  // __lsx_vfcmp_sne_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_sne_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.sne.d(

  // __lsx_vfcmp_slt_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_slt_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.slt.s(

  // __lsx_vfcmp_slt_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_slt_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.slt.d(

  // __lsx_vfcmp_sult_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_sult_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.sult.s(

  // __lsx_vfcmp_sult_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_sult_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.sult.d(

  // __lsx_vfcmp_sle_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_sle_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.sle.s(

  // __lsx_vfcmp_sle_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_sle_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.sle.d(

  // __lsx_vfcmp_sule_s
  // vd, vj, vk
  // V4SI, V4SF, V4SF
  v4i32_r = __lsx_vfcmp_sule_s(v4f32_a, v4f32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfcmp.sule.s(

  // __lsx_vfcmp_sule_d
  // vd, vj, vk
  // V2DI, V2DF, V2DF
  v2i64_r = __lsx_vfcmp_sule_d(v2f64_a, v2f64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfcmp.sule.d(

  // __lsx_vfadd_s
  // vd, vj, vk
  // V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfadd_s(v4f32_a, v4f32_b); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfadd.s(
  // __lsx_vfadd_d
  // vd, vj, vk
  // V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfadd_d(v2f64_a, v2f64_b); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfadd.d(

  // __lsx_vfsub_s
  // vd, vj, vk
  // V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfsub_s(v4f32_a, v4f32_b); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfsub.s(

  // __lsx_vfsub_d
  // vd, vj, vk
  // V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfsub_d(v2f64_a, v2f64_b); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfsub.d(

  // __lsx_vfmul_s
  // vd, vj, vk
  // V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfmul_s(v4f32_a, v4f32_b); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfmul.s(

  // __lsx_vfmul_d
  // vd, vj, vk
  // V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfmul_d(v2f64_a, v2f64_b); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfmul.d(

  // __lsx_vfdiv_s
  // vd, vj, vk
  // V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfdiv_s(v4f32_a, v4f32_b); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfdiv.s(

  // __lsx_vfdiv_d
  // vd, vj, vk
  // V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfdiv_d(v2f64_a, v2f64_b); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfdiv.d(

  // __lsx_vfcvt_h_s
  // vd, vj, vk
  // V8HI, V4SF, V4SF
  v8i16_r = __lsx_vfcvt_h_s(v4f32_a, v4f32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vfcvt.h.s(

  // __lsx_vfcvt_s_d
  // vd, vj, vk
  // V4SF, V2DF, V2DF
  v4f32_r = __lsx_vfcvt_s_d(v2f64_a, v2f64_b); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfcvt.s.d(

  // __lsx_vfmin_s
  // vd, vj, vk
  // V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfmin_s(v4f32_a, v4f32_b); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfmin.s(

  // __lsx_vfmin_d
  // vd, vj, vk
  // V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfmin_d(v2f64_a, v2f64_b); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfmin.d(

  // __lsx_vfmina_s
  // vd, vj, vk
  // V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfmina_s(v4f32_a, v4f32_b); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfmina.s(

  // __lsx_vfmina_d
  // vd, vj, vk
  // V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfmina_d(v2f64_a, v2f64_b); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfmina.d(

  // __lsx_vfmax_s
  // vd, vj, vk
  // V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfmax_s(v4f32_a, v4f32_b); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfmax.s(

  // __lsx_vfmax_d
  // vd, vj, vk
  // V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfmax_d(v2f64_a, v2f64_b); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfmax.d(

  // __lsx_vfmaxa_s
  // vd, vj, vk
  // V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfmaxa_s(v4f32_a, v4f32_b); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfmaxa.s(

  // __lsx_vfmaxa_d
  // vd, vj, vk
  // V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfmaxa_d(v2f64_a, v2f64_b); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfmaxa.d(

  // __lsx_vfclass_s
  // vd, vj
  // V4SI, V4SF
  v4i32_r = __lsx_vfclass_s(v4f32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vfclass.s(

  // __lsx_vfclass_d
  // vd, vj
  // V2DI, V2DF
  v2i64_r = __lsx_vfclass_d(v2f64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vfclass.d(

  // __lsx_vfsqrt_s
  // vd, vj
  // V4SF, V4SF
  v4f32_r = __lsx_vfsqrt_s(v4f32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfsqrt.s(

  // __lsx_vfsqrt_d
  // vd, vj
  // V2DF, V2DF
  v2f64_r = __lsx_vfsqrt_d(v2f64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfsqrt.d(

  // __lsx_vfrecip_s
  // vd, vj
  // V4SF, V4SF
  v4f32_r = __lsx_vfrecip_s(v4f32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfrecip.s(

  // __lsx_vfrecip_d
  // vd, vj
  // V2DF, V2DF
  v2f64_r = __lsx_vfrecip_d(v2f64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfrecip.d(

  // __lsx_vfrint_s
  // vd, vj
  // V4SF, V4SF
  v4f32_r = __lsx_vfrint_s(v4f32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfrint.s(

  // __lsx_vfrint_d
  // vd, vj
  // V2DF, V2DF
  v2f64_r = __lsx_vfrint_d(v2f64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfrint.d(

  // __lsx_vfrsqrt_s
  // vd, vj
  // V4SF, V4SF
  v4f32_r = __lsx_vfrsqrt_s(v4f32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfrsqrt.s(

  // __lsx_vfrsqrt_d
  // vd, vj
  // V2DF, V2DF
  v2f64_r = __lsx_vfrsqrt_d(v2f64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfrsqrt.d(

  // __lsx_vflogb_s
  // vd, vj
  // V4SF, V4SF
  v4f32_r = __lsx_vflogb_s(v4f32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vflogb.s(

  // __lsx_vflogb_d
  // vd, vj
  // V2DF, V2DF
  v2f64_r = __lsx_vflogb_d(v2f64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vflogb.d(

  // __lsx_vfcvth_s_h
  // vd, vj
  // V4SF, V8HI
  v4f32_r = __lsx_vfcvth_s_h(v8i16_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfcvth.s.h(

  // __lsx_vfcvth_d_s
  // vd, vj
  // V2DF, V4SF
  v2f64_r = __lsx_vfcvth_d_s(v4f32_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfcvth.d.s(

  //gcc build fail

  // __lsx_vfcvtl_s_h
  // vd, vj
  // V4SF, V8HI
  v4f32_r = __lsx_vfcvtl_s_h(v8i16_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfcvtl.s.h(

  // __lsx_vfcvtl_d_s
  // vd, vj
  // V2DF, V4SF
  v2f64_r = __lsx_vfcvtl_d_s(v4f32_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfcvtl.d.s(

  // __lsx_vftint_w_s
  // vd, vj
  // V4SI, V4SF
  v4i32_r = __lsx_vftint_w_s(v4f32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftint.w.s(

  // __lsx_vftint_l_d
  // vd, vj
  // V2DI, V2DF
  v2i64_r = __lsx_vftint_l_d(v2f64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftint.l.d(

  // __lsx_vftint_wu_s
  // vd, vj
  // UV4SI, V4SF
  v4u32_r = __lsx_vftint_wu_s(v4f32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftint.wu.s(

  // __lsx_vftint_lu_d
  // vd, vj
  // UV2DI, V2DF
  v2u64_r = __lsx_vftint_lu_d(v2f64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftint.lu.d(

  // __lsx_vftintrz_w_s
  // vd, vj
  // V4SI, V4SF
  v4i32_r = __lsx_vftintrz_w_s(v4f32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftintrz.w.s(

  // __lsx_vftintrz_l_d
  // vd, vj
  // V2DI, V2DF
  v2i64_r = __lsx_vftintrz_l_d(v2f64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrz.l.d(

  // __lsx_vftintrz_wu_s
  // vd, vj
  // UV4SI, V4SF
  v4u32_r = __lsx_vftintrz_wu_s(v4f32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftintrz.wu.s(

  // __lsx_vftintrz_lu_d
  // vd, vj
  // UV2DI, V2DF
  v2u64_r = __lsx_vftintrz_lu_d(v2f64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrz.lu.d(

  // __lsx_vffint_s_w
  // vd, vj
  // V4SF, V4SI
  v4f32_r = __lsx_vffint_s_w(v4i32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vffint.s.w(

  // __lsx_vffint_d_l
  // vd, vj
  // V2DF, V2DI
  v2f64_r = __lsx_vffint_d_l(v2i64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vffint.d.l(

  // __lsx_vffint_s_wu
  // vd, vj
  // V4SF, UV4SI
  v4f32_r = __lsx_vffint_s_wu(v4u32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vffint.s.wu(

  // __lsx_vffint_d_lu
  // vd, vj
  // V2DF, UV2DI
  v2f64_r = __lsx_vffint_d_lu(v2u64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vffint.d.lu(

  // __lsx_vandn_v
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vandn_v(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vandn.v(

  // __lsx_vneg_b
  // vd, vj
  // V16QI, V16QI
  v16i8_r = __lsx_vneg_b(v16i8_a); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vneg.b(

  // __lsx_vneg_h
  // vd, vj
  // V8HI, V8HI
  v8i16_r = __lsx_vneg_h(v8i16_a); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vneg.h(

  // __lsx_vneg_w
  // vd, vj
  // V4SI, V4SI
  v4i32_r = __lsx_vneg_w(v4i32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vneg.w(

  // __lsx_vneg_d
  // vd, vj
  // V2DI, V2DI
  v2i64_r = __lsx_vneg_d(v2i64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vneg.d(

  // __lsx_vmuh_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vmuh_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmuh.b(

  // __lsx_vmuh_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vmuh_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmuh.h(

  // __lsx_vmuh_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vmuh_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmuh.w(

  // __lsx_vmuh_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmuh_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmuh.d(

  // __lsx_vmuh_bu
  // vd, vj, vk
  // UV16QI, UV16QI, UV16QI
  v16u8_r = __lsx_vmuh_bu(v16u8_a, v16u8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmuh.bu(

  // __lsx_vmuh_hu
  // vd, vj, vk
  // UV8HI, UV8HI, UV8HI
  v8u16_r = __lsx_vmuh_hu(v8u16_a, v8u16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmuh.hu(

  // __lsx_vmuh_wu
  // vd, vj, vk
  // UV4SI, UV4SI, UV4SI
  v4u32_r = __lsx_vmuh_wu(v4u32_a, v4u32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmuh.wu(

  // __lsx_vmuh_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vmuh_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmuh.du(

  // __lsx_vsllwil_h_b
  // vd, vj, ui3
  // V8HI, V16QI, UQI
  v8i16_r = __lsx_vsllwil_h_b(v16i8_a, ui3); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsllwil.h.b(

  // __lsx_vsllwil_w_h
  // vd, vj, ui4
  // V4SI, V8HI, UQI
  v4i32_r = __lsx_vsllwil_w_h(v8i16_a, ui4); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsllwil.w.h(

  // __lsx_vsllwil_d_w
  // vd, vj, ui5
  // V2DI, V4SI, UQI
  v2i64_r = __lsx_vsllwil_d_w(v4i32_a, ui5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsllwil.d.w(

  // __lsx_vsllwil_hu_bu
  // vd, vj, ui3
  // UV8HI, UV16QI, UQI
  v8u16_r = __lsx_vsllwil_hu_bu(v16u8_a, ui3); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsllwil.hu.bu(

  // __lsx_vsllwil_wu_hu
  // vd, vj, ui4
  // UV4SI, UV8HI, UQI
  v4u32_r = __lsx_vsllwil_wu_hu(v8u16_a, ui4); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsllwil.wu.hu(

  // __lsx_vsllwil_du_wu
  // vd, vj, ui5
  // UV2DI, UV4SI, UQI
  v2u64_r = __lsx_vsllwil_du_wu(v4u32_a, ui5); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsllwil.du.wu(

  // __lsx_vsran_b_h
  // vd, vj, vk
  // V16QI, V8HI, V8HI
  v16i8_r = __lsx_vsran_b_h(v8i16_a, v8i16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsran.b.h(

  // __lsx_vsran_h_w
  // vd, vj, vk
  // V8HI, V4SI, V4SI
  v8i16_r = __lsx_vsran_h_w(v4i32_a, v4i32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsran.h.w(

  // __lsx_vsran_w_d
  // vd, vj, vk
  // V4SI, V2DI, V2DI
  v4i32_r = __lsx_vsran_w_d(v2i64_a, v2i64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsran.w.d(

  // __lsx_vssran_b_h
  // vd, vj, vk
  // V16QI, V8HI, V8HI
  v16i8_r = __lsx_vssran_b_h(v8i16_a, v8i16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssran.b.h(

  // __lsx_vssran_h_w
  // vd, vj, vk
  // V8HI, V4SI, V4SI
  v8i16_r = __lsx_vssran_h_w(v4i32_a, v4i32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssran.h.w(

  // __lsx_vssran_w_d
  // vd, vj, vk
  // V4SI, V2DI, V2DI
  v4i32_r = __lsx_vssran_w_d(v2i64_a, v2i64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssran.w.d(

  // __lsx_vssran_bu_h
  // vd, vj, vk
  // UV16QI, UV8HI, UV8HI
  v16u8_r = __lsx_vssran_bu_h(v8u16_a, v8u16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssran.bu.h(

  // __lsx_vssran_hu_w
  // vd, vj, vk
  // UV8HI, UV4SI, UV4SI
  v8u16_r = __lsx_vssran_hu_w(v4u32_a, v4u32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssran.hu.w(

  // __lsx_vssran_wu_d
  // vd, vj, vk
  // UV4SI, UV2DI, UV2DI
  v4u32_r = __lsx_vssran_wu_d(v2u64_a, v2u64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssran.wu.d(

  // __lsx_vsrarn_b_h
  // vd, vj, vk
  // V16QI, V8HI, V8HI
  v16i8_r = __lsx_vsrarn_b_h(v8i16_a, v8i16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrarn.b.h(

  // __lsx_vsrarn_h_w
  // vd, vj, vk
  // V8HI, V4SI, V4SI
  v8i16_r = __lsx_vsrarn_h_w(v4i32_a, v4i32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrarn.h.w(

  // __lsx_vsrarn_w_d
  // vd, vj, vk
  // V4SI, V2DI, V2DI
  v4i32_r = __lsx_vsrarn_w_d(v2i64_a, v2i64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrarn.w.d(

  // __lsx_vssrarn_b_h
  // vd, vj, vk
  // V16QI, V8HI, V8HI
  v16i8_r = __lsx_vssrarn_b_h(v8i16_a, v8i16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrarn.b.h(

  // __lsx_vssrarn_h_w
  // vd, vj, vk
  // V8HI, V4SI, V4SI
  v8i16_r = __lsx_vssrarn_h_w(v4i32_a, v4i32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrarn.h.w(

  // __lsx_vssrarn_w_d
  // vd, vj, vk
  // V4SI, V2DI, V2DI
  v4i32_r = __lsx_vssrarn_w_d(v2i64_a, v2i64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrarn.w.d(

  // __lsx_vssrarn_bu_h
  // vd, vj, vk
  // UV16QI, UV8HI, UV8HI
  v16u8_r = __lsx_vssrarn_bu_h(v8u16_a, v8u16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrarn.bu.h(

  // __lsx_vssrarn_hu_w
  // vd, vj, vk
  // UV8HI, UV4SI, UV4SI
  v8u16_r = __lsx_vssrarn_hu_w(v4u32_a, v4u32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrarn.hu.w(

  // __lsx_vssrarn_wu_d
  // vd, vj, vk
  // UV4SI, UV2DI, UV2DI
  v4u32_r = __lsx_vssrarn_wu_d(v2u64_a, v2u64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrarn.wu.d(

  // __lsx_vsrln_b_h
  // vd, vj, vk
  // V16QI, V8HI, V8HI
  v16i8_r = __lsx_vsrln_b_h(v8i16_a, v8i16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrln.b.h(

  // __lsx_vsrln_h_w
  // vd, vj, vk
  // V8HI, V4SI, V4SI
  v8i16_r = __lsx_vsrln_h_w(v4i32_a, v4i32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrln.h.w(

  // __lsx_vsrln_w_d
  // vd, vj, vk
  // V4SI, V2DI, V2DI
  v4i32_r = __lsx_vsrln_w_d(v2i64_a, v2i64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrln.w.d(

  // __lsx_vssrln_bu_h
  // vd, vj, vk
  // UV16QI, UV8HI, UV8HI
  v16u8_r = __lsx_vssrln_bu_h(v8u16_a, v8u16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrln.bu.h(

  // __lsx_vssrln_hu_w
  // vd, vj, vk
  // UV8HI, UV4SI, UV4SI
  v8u16_r = __lsx_vssrln_hu_w(v4u32_a, v4u32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrln.hu.w(

  // __lsx_vssrln_wu_d
  // vd, vj, vk
  // UV4SI, UV2DI, UV2DI
  v4u32_r = __lsx_vssrln_wu_d(v2u64_a, v2u64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrln.wu.d(

  // __lsx_vsrlrn_b_h
  // vd, vj, vk
  // V16QI, V8HI, V8HI
  v16i8_r = __lsx_vsrlrn_b_h(v8i16_a, v8i16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrlrn.b.h(

  // __lsx_vsrlrn_h_w
  // vd, vj, vk
  // V8HI, V4SI, V4SI
  v8i16_r = __lsx_vsrlrn_h_w(v4i32_a, v4i32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrlrn.h.w(

  // __lsx_vsrlrn_w_d
  // vd, vj, vk
  // V4SI, V2DI, V2DI
  v4i32_r = __lsx_vsrlrn_w_d(v2i64_a, v2i64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrlrn.w.d(

  // __lsx_vssrlrn_bu_h
  // vd, vj, vk
  // UV16QI, UV8HI, UV8HI
  v16u8_r = __lsx_vssrlrn_bu_h(v8u16_a, v8u16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrlrn.bu.h(

  // __lsx_vssrlrn_hu_w
  // vd, vj, vk
  // UV8HI, UV4SI, UV4SI
  v8u16_r = __lsx_vssrlrn_hu_w(v4u32_a, v4u32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrlrn.hu.w(

  // __lsx_vssrlrn_wu_d
  // vd, vj, vk
  // UV4SI, UV2DI, UV2DI
  v4u32_r = __lsx_vssrlrn_wu_d(v2u64_a, v2u64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrlrn.wu.d(

  // __lsx_vfrstpi_b
  // vd, vj, ui5
  // V16QI, V16QI, V16QI, UQI
  v16i8_r = __lsx_vfrstpi_b(v16i8_a, v16i8_b, ui5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vfrstpi.b(

  // __lsx_vfrstpi_h
  // vd, vj, ui5
  // V8HI, V8HI, V8HI, UQI
  v8i16_r = __lsx_vfrstpi_h(v8i16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vfrstpi.h(

  // __lsx_vfrstp_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI, V16QI
  v16i8_r = __lsx_vfrstp_b(v16i8_a, v16i8_b, v16i8_c); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vfrstp.b(

  // __lsx_vfrstp_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI, V8HI
  v8i16_r = __lsx_vfrstp_h(v8i16_a, v8i16_b, v8i16_c); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vfrstp.h(

  // __lsx_vshuf4i_d
  // vd, vj, ui8
  // V2DI, V2DI, V2DI, USI
  v2i64_r = __lsx_vshuf4i_d(v2i64_a, v2i64_b, ui8); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vshuf4i.d(

  // __lsx_vbsrl_v
  // vd, vj, ui5
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vbsrl_v(v16i8_a, ui5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vbsrl.v(

  // __lsx_vbsll_v
  // vd, vj, ui5
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vbsll_v(v16i8_a, ui5); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vbsll.v(

  // __lsx_vextrins_b
  // vd, vj, ui8
  // V16QI, V16QI, V16QI, UQI
  v16i8_r = __lsx_vextrins_b(v16i8_a, v16i8_b, ui8); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vextrins.b(

  // __lsx_vextrins_h
  // vd, vj, ui8
  // V8HI, V8HI, V8HI, UQI
  v8i16_r = __lsx_vextrins_h(v8i16_a, v8i16_b, ui8); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vextrins.h(

  // __lsx_vextrins_w
  // vd, vj, ui8
  // V4SI, V4SI, V4SI, UQI
  v4i32_r = __lsx_vextrins_w(v4i32_a, v4i32_b, ui8); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vextrins.w(

  // __lsx_vextrins_d
  // vd, vj, ui8
  // V2DI, V2DI, V2DI, UQI
  v2i64_r = __lsx_vextrins_d(v2i64_a, v2i64_b, ui8); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vextrins.d(

  // __lsx_vmskltz_b
  // vd, vj
  // V16QI, V16QI
  v16i8_r = __lsx_vmskltz_b(v16i8_a); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmskltz.b(

  // __lsx_vmskltz_h
  // vd, vj
  // V8HI, V8HI
  v8i16_r = __lsx_vmskltz_h(v8i16_a); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmskltz.h(

  // __lsx_vmskltz_w
  // vd, vj
  // V4SI, V4SI
  v4i32_r = __lsx_vmskltz_w(v4i32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmskltz.w(

  // __lsx_vmskltz_d
  // vd, vj
  // V2DI, V2DI
  v2i64_r = __lsx_vmskltz_d(v2i64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmskltz.d(

  // __lsx_vsigncov_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vsigncov_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsigncov.b(

  // __lsx_vsigncov_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vsigncov_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsigncov.h(

  // __lsx_vsigncov_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vsigncov_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsigncov.w(

  // __lsx_vsigncov_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsigncov_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsigncov.d(

  // __lsx_vfmadd_s
  // vd, vj, vk, va
  // V4SF, V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfmadd_s(v4f32_a, v4f32_b, v4f32_c); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfmadd.s(

  // __lsx_vfmadd_d
  // vd, vj, vk, va
  // V2DF, V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfmadd_d(v2f64_a, v2f64_b, v2f64_c); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfmadd.d(

  // __lsx_vfmsub_s
  // vd, vj, vk, va
  // V4SF, V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfmsub_s(v4f32_a, v4f32_b, v4f32_c); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfmsub.s(

  // __lsx_vfmsub_d
  // vd, vj, vk, va
  // V2DF, V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfmsub_d(v2f64_a, v2f64_b, v2f64_c); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfmsub.d(

  // __lsx_vfnmadd_s
  // vd, vj, vk, va
  // V4SF, V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfnmadd_s(v4f32_a, v4f32_b, v4f32_c); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfnmadd.s(

  // __lsx_vfnmadd_d
  // vd, vj, vk, va
  // V2DF, V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfnmadd_d(v2f64_a, v2f64_b, v2f64_c); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfnmadd.d(

  // __lsx_vfnmsub_s
  // vd, vj, vk, va
  // V4SF, V4SF, V4SF, V4SF
  v4f32_r = __lsx_vfnmsub_s(v4f32_a, v4f32_b, v4f32_c); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfnmsub.s(

  // __lsx_vfnmsub_d
  // vd, vj, vk, va
  // V2DF, V2DF, V2DF, V2DF
  v2f64_r = __lsx_vfnmsub_d(v2f64_a, v2f64_b, v2f64_c); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfnmsub.d(

  // __lsx_vftintrne_w_s
  // vd, vj
  // V4SI, V4SF
  v4i32_r = __lsx_vftintrne_w_s(v4f32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftintrne.w.s(

  // __lsx_vftintrne_l_d
  // vd, vj
  // V2DI, V2DF
  v2i64_r = __lsx_vftintrne_l_d(v2f64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrne.l.d(

  // __lsx_vftintrp_w_s
  // vd, vj
  // V4SI, V4SF
  v4i32_r = __lsx_vftintrp_w_s(v4f32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftintrp.w.s(

  // __lsx_vftintrp_l_d
  // vd, vj
  // V2DI, V2DF
  v2i64_r = __lsx_vftintrp_l_d(v2f64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrp.l.d(

  // __lsx_vftintrm_w_s
  // vd, vj
  // V4SI, V4SF
  v4i32_r = __lsx_vftintrm_w_s(v4f32_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftintrm.w.s(

  // __lsx_vftintrm_l_d
  // vd, vj
  // V2DI, V2DF
  v2i64_r = __lsx_vftintrm_l_d(v2f64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrm.l.d(

  // __lsx_vftint_w_d
  // vd, vj, vk
  // V4SI, V2DF, V2DF
  v4i32_r = __lsx_vftint_w_d(v2f64_a, v2f64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftint.w.d(

  // __lsx_vffint_s_l
  // vd, vj, vk
  // V4SF, V2DI, V2DI
  v4f32_r = __lsx_vffint_s_l(v2i64_a, v2i64_b); // CHECK: call <4 x float> @llvm.loongarch.lsx.vffint.s.l(

  // __lsx_vftintrz_w_d
  // vd, vj, vk
  // V4SI, V2DF, V2DF
  v4i32_r = __lsx_vftintrz_w_d(v2f64_a, v2f64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftintrz.w.d(

  // __lsx_vftintrp_w_d
  // vd, vj, vk
  // V4SI, V2DF, V2DF
  v4i32_r = __lsx_vftintrp_w_d(v2f64_a, v2f64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftintrp.w.d(

  // __lsx_vftintrm_w_d
  // vd, vj, vk
  // V4SI, V2DF, V2DF
  v4i32_r = __lsx_vftintrm_w_d(v2f64_a, v2f64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftintrm.w.d(

  // __lsx_vftintrne_w_d
  // vd, vj, vk
  // V4SI, V2DF, V2DF
  v4i32_r = __lsx_vftintrne_w_d(v2f64_a, v2f64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vftintrne.w.d(

  // __lsx_vftintl_l_s
  // vd, vj
  // V2DI, V4SF
  v2i64_r = __lsx_vftintl_l_s(v4f32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintl.l.s(

  // __lsx_vftinth_l_s
  // vd, vj
  // V2DI, V4SF
  v2i64_r = __lsx_vftinth_l_s(v4f32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftinth.l.s(

  // __lsx_vffinth_d_w
  // vd, vj
  // V2DF, V4SI
  v2f64_r = __lsx_vffinth_d_w(v4i32_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vffinth.d.w(

  // __lsx_vffintl_d_w
  // vd, vj
  // V2DF, V4SI
  v2f64_r = __lsx_vffintl_d_w(v4i32_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vffintl.d.w(

  // __lsx_vftintrzl_l_s
  // vd, vj
  // V2DI, V4SF
  v2i64_r = __lsx_vftintrzl_l_s(v4f32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrzl.l.s(

  // __lsx_vftintrzh_l_s
  // vd, vj
  // V2DI, V4SF
  v2i64_r = __lsx_vftintrzh_l_s(v4f32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrzh.l.s(

  // __lsx_vftintrpl_l_s
  // vd, vj
  // V2DI, V4SF
  v2i64_r = __lsx_vftintrpl_l_s(v4f32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrpl.l.s(

  // __lsx_vftintrph_l_s
  // vd, vj
  // V2DI, V4SF
  v2i64_r = __lsx_vftintrph_l_s(v4f32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrph.l.s(

  // __lsx_vftintrml_l_s
  // vd, vj
  // V2DI, V4SF
  v2i64_r = __lsx_vftintrml_l_s(v4f32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrml.l.s(

  // __lsx_vftintrmh_l_s
  // vd, vj
  // V2DI, V4SF
  v2i64_r = __lsx_vftintrmh_l_s(v4f32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrmh.l.s(

  // __lsx_vftintrnel_l_s
  // vd, vj
  // V2DI, V4SF
  v2i64_r = __lsx_vftintrnel_l_s(v4f32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrnel.l.s(

  // __lsx_vftintrneh_l_s
  // vd, vj
  // V2DI, V4SF
  v2i64_r = __lsx_vftintrneh_l_s(v4f32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vftintrneh.l.s(

  // __lsx_vfrintrne_s
  // vd, vj
  // V4SF, V4SF
  v4f32_r = __lsx_vfrintrne_s(v4f32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfrintrne.s(

  // __lsx_vfrintrne_d
  // vd, vj
  // V2DF, V2DF
  v2f64_r = __lsx_vfrintrne_d(v2f64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfrintrne.d(

  // __lsx_vfrintrz_s
  // vd, vj
  // V4SF, V4SF
  v4f32_r = __lsx_vfrintrz_s(v4f32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfrintrz.s(

  // __lsx_vfrintrz_d
  // vd, vj
  // V2DF, V2DF
  v2f64_r = __lsx_vfrintrz_d(v2f64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfrintrz.d(

  // __lsx_vfrintrp_s
  // vd, vj
  // V4SF, V4SF
  v4f32_r = __lsx_vfrintrp_s(v4f32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfrintrp.s(

  // __lsx_vfrintrp_d
  // vd, vj
  // V2DF, V2DF
  v2f64_r = __lsx_vfrintrp_d(v2f64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfrintrp.d(

  // __lsx_vfrintrm_s
  // vd, vj
  // V4SF, V4SF
  v4f32_r = __lsx_vfrintrm_s(v4f32_a); // CHECK: call <4 x float> @llvm.loongarch.lsx.vfrintrm.s(

  // __lsx_vfrintrm_d
  // vd, vj
  // V2DF, V2DF
  v2f64_r = __lsx_vfrintrm_d(v2f64_a); // CHECK: call <2 x double> @llvm.loongarch.lsx.vfrintrm.d(

  // __lsx_vstelm_b
  // vd, rj, si8, idx
  // VOID, V16QI, CVPOINTER, SI, UQI
  __lsx_vstelm_b(v16i8_a, &v16i8_b, 0, idx4); // CHECK: call void @llvm.loongarch.lsx.vstelm.b(
  // __lsx_vstelm_h
  // vd, rj, si8, idx
  // VOID, V8HI, CVPOINTER, SI, UQI
  __lsx_vstelm_h(v8i16_a, &v8i16_b, 0, idx3); // CHECK: call void @llvm.loongarch.lsx.vstelm.h(

  // __lsx_vstelm_w
  // vd, rj, si8, idx
  // VOID, V4SI, CVPOINTER, SI, UQI
  __lsx_vstelm_w(v4i32_a, &v4i32_b, 0, idx2); // CHECK: call void @llvm.loongarch.lsx.vstelm.w(

  // __lsx_vstelm_d
  // vd, rj, si8, idx
  // VOID, V2DI, CVPOINTER, SI, UQI
  __lsx_vstelm_d(v2i64_a, &v2i64_b, 0, idx1); // CHECK: call void @llvm.loongarch.lsx.vstelm.d(

  // __lsx_vaddwev_d_w
  // vd, vj, vk
  // V2DI, V4SI, V4SI
  v2i64_r = __lsx_vaddwev_d_w(v4i32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwev.d.w(

  // __lsx_vaddwev_w_h
  // vd, vj, vk
  // V4SI, V8HI, V8HI
  v4i32_r = __lsx_vaddwev_w_h(v8i16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vaddwev.w.h(

  // __lsx_vaddwev_h_b
  // vd, vj, vk
  // V8HI, V16QI, V16QI
  v8i16_r = __lsx_vaddwev_h_b(v16i8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vaddwev.h.b(

  // __lsx_vaddwod_d_w
  // vd, vj, vk
  // V2DI, V4SI, V4SI
  v2i64_r = __lsx_vaddwod_d_w(v4i32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwod.d.w(

  // __lsx_vaddwod_w_h
  // vd, vj, vk
  // V4SI, V8HI, V8HI
  v4i32_r = __lsx_vaddwod_w_h(v8i16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vaddwod.w.h(

  // __lsx_vaddwod_h_b
  // vd, vj, vk
  // V8HI, V16QI, V16QI
  v8i16_r = __lsx_vaddwod_h_b(v16i8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vaddwod.h.b(

  // __lsx_vaddwev_d_wu
  // vd, vj, vk
  // V2DI, UV4SI, UV4SI
  v2i64_r = __lsx_vaddwev_d_wu(v4u32_a, v4u32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwev.d.wu(

  // __lsx_vaddwev_w_hu
  // vd, vj, vk
  // V4SI, UV8HI, UV8HI
  v4i32_r = __lsx_vaddwev_w_hu(v8u16_a, v8u16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vaddwev.w.hu(

  // __lsx_vaddwev_h_bu
  // vd, vj, vk
  // V8HI, UV16QI, UV16QI
  v8i16_r = __lsx_vaddwev_h_bu(v16u8_a, v16u8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vaddwev.h.bu(

  // __lsx_vaddwod_d_wu
  // vd, vj, vk
  // V2DI, UV4SI, UV4SI
  v2i64_r = __lsx_vaddwod_d_wu(v4u32_a, v4u32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwod.d.wu(

  // __lsx_vaddwod_w_hu
  // vd, vj, vk
  // V4SI, UV8HI, UV8HI
  v4i32_r = __lsx_vaddwod_w_hu(v8u16_a, v8u16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vaddwod.w.hu(

  // __lsx_vaddwod_h_bu
  // vd, vj, vk
  // V8HI, UV16QI, UV16QI
  v8i16_r = __lsx_vaddwod_h_bu(v16u8_a, v16u8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vaddwod.h.bu(

  // __lsx_vaddwev_d_wu_w
  // vd, vj, vk
  // V2DI, UV4SI, V4SI
  v2i64_r = __lsx_vaddwev_d_wu_w(v4u32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwev.d.wu.w(

  // __lsx_vaddwev_w_hu_h
  // vd, vj, vk
  // V4SI, UV8HI, V8HI
  v4i32_r = __lsx_vaddwev_w_hu_h(v8u16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vaddwev.w.hu.h(

  // __lsx_vaddwev_h_bu_b
  // vd, vj, vk
  // V8HI, UV16QI, V16QI
  v8i16_r = __lsx_vaddwev_h_bu_b(v16u8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vaddwev.h.bu.b(

  // __lsx_vaddwod_d_wu_w
  // vd, vj, vk
  // V2DI, UV4SI, V4SI
  v2i64_r = __lsx_vaddwod_d_wu_w(v4u32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwod.d.wu.w(

  // __lsx_vaddwod_w_hu_h
  // vd, vj, vk
  // V4SI, UV8HI, V8HI
  v4i32_r = __lsx_vaddwod_w_hu_h(v8u16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vaddwod.w.hu.h(

  // __lsx_vaddwod_h_bu_b
  // vd, vj, vk
  // V8HI, UV16QI, V16QI
  v8i16_r = __lsx_vaddwod_h_bu_b(v16u8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vaddwod.h.bu.b(

  // __lsx_vsubwev_d_w
  // vd, vj, vk
  // V2DI, V4SI, V4SI
  v2i64_r = __lsx_vsubwev_d_w(v4i32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsubwev.d.w(

  // __lsx_vsubwev_w_h
  // vd, vj, vk
  // V4SI, V8HI, V8HI
  v4i32_r = __lsx_vsubwev_w_h(v8i16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsubwev.w.h(

  // __lsx_vsubwev_h_b
  // vd, vj, vk
  // V8HI, V16QI, V16QI
  v8i16_r = __lsx_vsubwev_h_b(v16i8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsubwev.h.b(

  // __lsx_vsubwod_d_w
  // vd, vj, vk
  // V2DI, V4SI, V4SI
  v2i64_r = __lsx_vsubwod_d_w(v4i32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsubwod.d.w(

  // __lsx_vsubwod_w_h
  // vd, vj, vk
  // V4SI, V8HI, V8HI
  v4i32_r = __lsx_vsubwod_w_h(v8i16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsubwod.w.h(

  // __lsx_vsubwod_h_b
  // vd, vj, vk
  // V8HI, V16QI, V16QI
  v8i16_r = __lsx_vsubwod_h_b(v16i8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsubwod.h.b(

  // __lsx_vsubwev_d_wu
  // vd, vj, vk
  // V2DI, UV4SI, UV4SI
  v2i64_r = __lsx_vsubwev_d_wu(v4u32_a, v4u32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsubwev.d.wu(

  // __lsx_vsubwev_w_hu
  // vd, vj, vk
  // V4SI, UV8HI, UV8HI
  v4i32_r = __lsx_vsubwev_w_hu(v8u16_a, v8u16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsubwev.w.hu(

  // __lsx_vsubwev_h_bu
  // vd, vj, vk
  // V8HI, UV16QI, UV16QI
  v8i16_r = __lsx_vsubwev_h_bu(v16u8_a, v16u8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsubwev.h.bu(

  // __lsx_vsubwod_d_wu
  // vd, vj, vk
  // V2DI, UV4SI, UV4SI
  v2i64_r = __lsx_vsubwod_d_wu(v4u32_a, v4u32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsubwod.d.wu(

  // __lsx_vsubwod_w_hu
  // vd, vj, vk
  // V4SI, UV8HI, UV8HI
  v4i32_r = __lsx_vsubwod_w_hu(v8u16_a, v8u16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsubwod.w.hu(

  // __lsx_vsubwod_h_bu
  // vd, vj, vk
  // V8HI, UV16QI, UV16QI
  v8i16_r = __lsx_vsubwod_h_bu(v16u8_a, v16u8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsubwod.h.bu(

  // __lsx_vaddwev_q_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vaddwev_q_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwev.q.d(

  // __lsx_vaddwod_q_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vaddwod_q_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwod.q.d(

  // __lsx_vaddwev_q_du
  // vd, vj, vk
  // V2DI, UV2DI, UV2DI
  v2i64_r = __lsx_vaddwev_q_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwev.q.du(

  // __lsx_vaddwod_q_du
  // vd, vj, vk
  // V2DI, UV2DI, UV2DI
  v2i64_r = __lsx_vaddwod_q_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwod.q.du(

  // __lsx_vsubwev_q_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsubwev_q_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsubwev.q.d(

  // __lsx_vsubwod_q_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsubwod_q_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsubwod.q.d(

  // __lsx_vsubwev_q_du
  // vd, vj, vk
  // V2DI, UV2DI, UV2DI
  v2i64_r = __lsx_vsubwev_q_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsubwev.q.du(

  // __lsx_vsubwod_q_du
  // vd, vj, vk
  // V2DI, UV2DI, UV2DI
  v2i64_r = __lsx_vsubwod_q_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsubwod.q.du(

  // __lsx_vaddwev_q_du_d
  // vd, vj, vk
  // V2DI, UV2DI, V2DI
  v2i64_r = __lsx_vaddwev_q_du_d(v2u64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwev.q.du.d(

  // __lsx_vaddwod_q_du_d
  // vd, vj, vk
  // V2DI, UV2DI, V2DI
  v2i64_r = __lsx_vaddwod_q_du_d(v2u64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vaddwod.q.du.d(

  // __lsx_vmulwev_d_w
  // vd, vj, vk
  // V2DI, V4SI, V4SI
  v2i64_r = __lsx_vmulwev_d_w(v4i32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwev.d.w(

  // __lsx_vmulwev_w_h
  // vd, vj, vk
  // V4SI, V8HI, V8HI
  v4i32_r = __lsx_vmulwev_w_h(v8i16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmulwev.w.h(

  // __lsx_vmulwev_h_b
  // vd, vj, vk
  // V8HI, V16QI, V16QI
  v8i16_r = __lsx_vmulwev_h_b(v16i8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmulwev.h.b(

  // __lsx_vmulwod_d_w
  // vd, vj, vk
  // V2DI, V4SI, V4SI
  v2i64_r = __lsx_vmulwod_d_w(v4i32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwod.d.w(

  // __lsx_vmulwod_w_h
  // vd, vj, vk
  // V4SI, V8HI, V8HI
  v4i32_r = __lsx_vmulwod_w_h(v8i16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmulwod.w.h(

  // __lsx_vmulwod_h_b
  // vd, vj, vk
  // V8HI, V16QI, V16QI
  v8i16_r = __lsx_vmulwod_h_b(v16i8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmulwod.h.b(

  // __lsx_vmulwev_d_wu
  // vd, vj, vk
  // V2DI, UV4SI, UV4SI
  v2i64_r = __lsx_vmulwev_d_wu(v4u32_a, v4u32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwev.d.wu(

  // __lsx_vmulwev_w_hu
  // vd, vj, vk
  // V4SI, UV8HI, UV8HI
  v4i32_r = __lsx_vmulwev_w_hu(v8u16_a, v8u16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmulwev.w.hu(

  // __lsx_vmulwev_h_bu
  // vd, vj, vk
  // V8HI, UV16QI, UV16QI
  v8i16_r = __lsx_vmulwev_h_bu(v16u8_a, v16u8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmulwev.h.bu(

  // __lsx_vmulwod_d_wu
  // vd, vj, vk
  // V2DI, UV4SI, UV4SI
  v2i64_r = __lsx_vmulwod_d_wu(v4u32_a, v4u32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwod.d.wu(

  // __lsx_vmulwod_w_hu
  // vd, vj, vk
  // V4SI, UV8HI, UV8HI
  v4i32_r = __lsx_vmulwod_w_hu(v8u16_a, v8u16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmulwod.w.hu(

  // __lsx_vmulwod_h_bu
  // vd, vj, vk
  // V8HI, UV16QI, UV16QI
  v8i16_r = __lsx_vmulwod_h_bu(v16u8_a, v16u8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmulwod.h.bu(

  // __lsx_vmulwev_d_wu_w
  // vd, vj, vk
  // V2DI, UV4SI, V4SI
  v2i64_r = __lsx_vmulwev_d_wu_w(v4u32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwev.d.wu.w(

  // __lsx_vmulwev_w_hu_h
  // vd, vj, vk
  // V4SI, UV8HI, V8HI
  v4i32_r = __lsx_vmulwev_w_hu_h(v8u16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmulwev.w.hu.h(

  // __lsx_vmulwev_h_bu_b
  // vd, vj, vk
  // V8HI, UV16QI, V16QI
  v8i16_r = __lsx_vmulwev_h_bu_b(v16u8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmulwev.h.bu.b(

  // __lsx_vmulwod_d_wu_w
  // vd, vj, vk
  // V2DI, UV4SI, V4SI
  v2i64_r = __lsx_vmulwod_d_wu_w(v4u32_a, v4i32_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwod.d.wu.w(

  // __lsx_vmulwod_w_hu_h
  // vd, vj, vk
  // V4SI, UV8HI, V8HI
  v4i32_r = __lsx_vmulwod_w_hu_h(v8u16_a, v8i16_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmulwod.w.hu.h(

  // __lsx_vmulwod_h_bu_b
  // vd, vj, vk
  // V8HI, UV16QI, V16QI
  v8i16_r = __lsx_vmulwod_h_bu_b(v16u8_a, v16i8_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmulwod.h.bu.b(

  // __lsx_vmulwev_q_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmulwev_q_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwev.q.d(

  // __lsx_vmulwod_q_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmulwod_q_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwod.q.d(

  // __lsx_vmulwev_q_du
  // vd, vj, vk
  // V2DI, UV2DI, UV2DI
  v2i64_r = __lsx_vmulwev_q_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwev.q.du(

  // __lsx_vmulwod_q_du
  // vd, vj, vk
  // V2DI, UV2DI, UV2DI
  v2i64_r = __lsx_vmulwod_q_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwod.q.du(

  // __lsx_vmulwev_q_du_d
  // vd, vj, vk
  // V2DI, UV2DI, V2DI
  v2i64_r = __lsx_vmulwev_q_du_d(v2u64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwev.q.du.d(

  // __lsx_vmulwod_q_du_d
  // vd, vj, vk
  // V2DI, UV2DI, V2DI
  v2i64_r = __lsx_vmulwod_q_du_d(v2u64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmulwod.q.du.d(

  // __lsx_vhaddw_q_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vhaddw_q_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vhaddw.q.d(

  // __lsx_vhaddw_qu_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vhaddw_qu_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vhaddw.qu.du(

  // __lsx_vhsubw_q_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vhsubw_q_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vhsubw.q.d(

  // __lsx_vhsubw_qu_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vhsubw_qu_du(v2u64_a, v2u64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vhsubw.qu.du(

  // __lsx_vmaddwev_d_w
  // vd, vj, vk
  // V2DI, V2DI, V4SI, V4SI
  v2i64_r = __lsx_vmaddwev_d_w(v2i64_a, v4i32_b, v4i32_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwev.d.w(

  // __lsx_vmaddwev_w_h
  // vd, vj, vk
  // V4SI, V4SI, V8HI, V8HI
  v4i32_r = __lsx_vmaddwev_w_h(v4i32_a, v8i16_b, v8i16_c); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmaddwev.w.h(

  // __lsx_vmaddwev_h_b
  // vd, vj, vk
  // V8HI, V8HI, V16QI, V16QI
  v8i16_r = __lsx_vmaddwev_h_b(v8i16_a, v16i8_b, v16i8_c); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmaddwev.h.b(

  // __lsx_vmaddwev_d_wu
  // vd, vj, vk
  // UV2DI, UV2DI, UV4SI, UV4SI
  v2u64_r = __lsx_vmaddwev_d_wu(v2u64_a, v4u32_b, v4u32_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwev.d.wu(

  // __lsx_vmaddwev_w_hu
  // vd, vj, vk
  // UV4SI, UV4SI, UV8HI, UV8HI
  v4u32_r = __lsx_vmaddwev_w_hu(v4u32_a, v8u16_b, v8u16_c); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmaddwev.w.hu(

  // __lsx_vmaddwev_h_bu
  // vd, vj, vk
  // UV8HI, UV8HI, UV16QI, UV16QI
  v8u16_r = __lsx_vmaddwev_h_bu(v8u16_a, v16u8_b, v16u8_c); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmaddwev.h.bu(

  // __lsx_vmaddwod_d_w
  // vd, vj, vk
  // V2DI, V2DI, V4SI, V4SI
  v2i64_r = __lsx_vmaddwod_d_w(v2i64_a, v4i32_b, v4i32_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwod.d.w(

  // __lsx_vmaddwod_w_h
  // vd, vj, vk
  // V4SI, V4SI, V8HI, V8HI
  v4i32_r = __lsx_vmaddwod_w_h(v4i32_a, v8i16_b, v8i16_c); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmaddwod.w.h(

  // __lsx_vmaddwod_h_b
  // vd, vj, vk
  // V8HI, V8HI, V16QI, V16QI
  v8i16_r = __lsx_vmaddwod_h_b(v8i16_a, v16i8_b, v16i8_c); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmaddwod.h.b(

  // __lsx_vmaddwod_d_wu
  // vd, vj, vk
  // UV2DI, UV2DI, UV4SI, UV4SI
  v2u64_r = __lsx_vmaddwod_d_wu(v2u64_a, v4u32_b, v4u32_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwod.d.wu(

  // __lsx_vmaddwod_w_hu
  // vd, vj, vk
  // UV4SI, UV4SI, UV8HI, UV8HI
  v4u32_r = __lsx_vmaddwod_w_hu(v4u32_a, v8u16_b, v8u16_c); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmaddwod.w.hu(

  // __lsx_vmaddwod_h_bu
  // vd, vj, vk
  // UV8HI, UV8HI, UV16QI, UV16QI
  v8u16_r = __lsx_vmaddwod_h_bu(v8u16_a, v16u8_b, v16u8_c); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmaddwod.h.bu(

  // __lsx_vmaddwev_d_wu_w
  // vd, vj, vk
  // V2DI, V2DI, UV4SI, V4SI
  v2i64_r = __lsx_vmaddwev_d_wu_w(v2i64_a, v4u32_b, v4i32_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwev.d.wu.w(

  // __lsx_vmaddwev_w_hu_h
  // vd, vj, vk
  // V4SI, V4SI, UV8HI, V8HI
  v4i32_r = __lsx_vmaddwev_w_hu_h(v4i32_a, v8u16_b, v8i16_c); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmaddwev.w.hu.h(

  // __lsx_vmaddwev_h_bu_b
  // vd, vj, vk
  // V8HI, V8HI, UV16QI, V16QI
  v8i16_r = __lsx_vmaddwev_h_bu_b(v8i16_a, v16u8_b, v16i8_c); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmaddwev.h.bu.b(

  // __lsx_vmaddwod_d_wu_w
  // vd, vj, vk
  // V2DI, V2DI, UV4SI, V4SI
  v2i64_r = __lsx_vmaddwod_d_wu_w(v2i64_a, v4u32_b, v4i32_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwod.d.wu.w(

  // __lsx_vmaddwod_w_hu_h
  // vd, vj, vk
  // V4SI, V4SI, UV8HI, V8HI
  v4i32_r = __lsx_vmaddwod_w_hu_h(v4i32_a, v8u16_b, v8i16_c); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vmaddwod.w.hu.h(

  // __lsx_vmaddwod_h_bu_b
  // vd, vj, vk
  // V8HI, V8HI, UV16QI, V16QI
  v8i16_r = __lsx_vmaddwod_h_bu_b(v8i16_a, v16u8_b, v16i8_c); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vmaddwod.h.bu.b(

  // __lsx_vmaddwev_q_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmaddwev_q_d(v2i64_a, v2i64_b, v2i64_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwev.q.d(

  // __lsx_vmaddwod_q_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI, V2DI
  v2i64_r = __lsx_vmaddwod_q_d(v2i64_a, v2i64_b, v2i64_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwod.q.d(

  // __lsx_vmaddwev_q_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vmaddwev_q_du(v2u64_a, v2u64_b, v2u64_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwev.q.du(

  // __lsx_vmaddwod_q_du
  // vd, vj, vk
  // UV2DI, UV2DI, UV2DI, UV2DI
  v2u64_r = __lsx_vmaddwod_q_du(v2u64_a, v2u64_b, v2u64_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwod.q.du(

  // __lsx_vmaddwev_q_du_d
  // vd, vj, vk
  // V2DI, V2DI, UV2DI, V2DI
  v2i64_r = __lsx_vmaddwev_q_du_d(v2i64_a, v2u64_b, v2i64_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwev.q.du.d(

  // __lsx_vmaddwod_q_du_d
  // vd, vj, vk
  // V2DI, V2DI, UV2DI, V2DI
  v2i64_r = __lsx_vmaddwod_q_du_d(v2i64_a, v2u64_b, v2i64_c); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vmaddwod.q.du.d(

  // __lsx_vrotr_b
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vrotr_b(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vrotr.b(

  // __lsx_vrotr_h
  // vd, vj, vk
  // V8HI, V8HI, V8HI
  v8i16_r = __lsx_vrotr_h(v8i16_a, v8i16_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vrotr.h(

  // __lsx_vrotr_w
  // vd, vj, vk
  // V4SI, V4SI, V4SI
  v4i32_r = __lsx_vrotr_w(v4i32_a, v4i32_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vrotr.w(

  // __lsx_vrotr_d
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vrotr_d(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vrotr.d(

  // __lsx_vadd_q
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vadd_q(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vadd.q(

  // __lsx_vsub_q
  // vd, vj, vk
  // V2DI, V2DI, V2DI
  v2i64_r = __lsx_vsub_q(v2i64_a, v2i64_b); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsub.q(

  // __lsx_vldrepl_b
  // vd, rj, si12
  // V16QI, CVPOINTER, SI
  v16i8_r = __lsx_vldrepl_b(&v16i8_a, si12); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vldrepl.b(

  // __lsx_vldrepl_h
  // vd, rj, si11
  // V8HI, CVPOINTER, SI
  v8i16_r = __lsx_vldrepl_h(&v8i16_a, si11); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vldrepl.h(

  // __lsx_vldrepl_w
  // vd, rj, si10
  // V4SI, CVPOINTER, SI
  v4i32_r = __lsx_vldrepl_w(&v4i32_a, si10); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vldrepl.w(

  // __lsx_vldrepl_d
  // vd, rj, si9
  // V2DI, CVPOINTER, SI
  v2i64_r = __lsx_vldrepl_d(&v2i64_a, si9); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vldrepl.d(

  // __lsx_vmskgez_b
  // vd, vj
  // V16QI, V16QI
  v16i8_r = __lsx_vmskgez_b(v16i8_a); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmskgez.b(

  // __lsx_vmsknz_b
  // vd, vj
  // V16QI, V16QI
  v16i8_r = __lsx_vmsknz_b(v16i8_a); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vmsknz.b(

  // __lsx_vexth_h_b
  // vd, vj
  // V8HI, V16QI
  v8i16_r = __lsx_vexth_h_b(v16i8_a); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vexth.h.b(

  // __lsx_vexth_w_h
  // vd, vj
  // V4SI, V8HI
  v4i32_r = __lsx_vexth_w_h(v8i16_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vexth.w.h(

  // __lsx_vexth_d_w
  // vd, vj
  // V2DI, V4SI
  v2i64_r = __lsx_vexth_d_w(v4i32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vexth.d.w(

  // __lsx_vexth_q_d
  // vd, vj
  // V2DI, V2DI
  v2i64_r = __lsx_vexth_q_d(v2i64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vexth.q.d(

  // __lsx_vexth_hu_bu
  // vd, vj
  // UV8HI, UV16QI
  v8u16_r = __lsx_vexth_hu_bu(v16u8_a); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vexth.hu.bu(

  // __lsx_vexth_wu_hu
  // vd, vj
  // UV4SI, UV8HI
  v4u32_r = __lsx_vexth_wu_hu(v8u16_a); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vexth.wu.hu(

  // __lsx_vexth_du_wu
  // vd, vj
  // UV2DI, UV4SI
  v2u64_r = __lsx_vexth_du_wu(v4u32_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vexth.du.wu(

  // __lsx_vexth_qu_du
  // vd, vj
  // UV2DI, UV2DI
  v2u64_r = __lsx_vexth_qu_du(v2u64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vexth.qu.du(

  // __lsx_vrotri_b
  // vd, vj, ui3
  // V16QI, V16QI, UQI
  v16i8_r = __lsx_vrotri_b(v16i8_a, ui3); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vrotri.b(

  // __lsx_vrotri_h
  // vd, vj, ui4
  // V8HI, V8HI, UQI
  v8i16_r = __lsx_vrotri_h(v8i16_a, ui4); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vrotri.h(

  // __lsx_vrotri_w
  // vd, vj, ui5
  // V4SI, V4SI, UQI
  v4i32_r = __lsx_vrotri_w(v4i32_a, ui5); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vrotri.w(

  // __lsx_vrotri_d
  // vd, vj, ui6
  // V2DI, V2DI, UQI
  v2i64_r = __lsx_vrotri_d(v2i64_a, ui6); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vrotri.d(

  // __lsx_vextl_q_d
  // vd, vj
  // V2DI, V2DI
  v2i64_r = __lsx_vextl_q_d(v2i64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vextl.q.d(

  // __lsx_vsrlni_b_h
  // vd, vj, ui4
  // V16QI, V16QI, V16QI, USI
  v16i8_r = __lsx_vsrlni_b_h(v16i8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrlni.b.h(

  // __lsx_vsrlni_h_w
  // vd, vj, ui5
  // V8HI, V8HI, V8HI, USI
  v8i16_r = __lsx_vsrlni_h_w(v8i16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrlni.h.w(

  // __lsx_vsrlni_w_d
  // vd, vj, ui6
  // V4SI, V4SI, V4SI, USI
  v4i32_r = __lsx_vsrlni_w_d(v4i32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrlni.w.d(

  // __lsx_vsrlni_d_q
  // vd, vj, ui7
  // V2DI, V2DI, V2DI, USI
  v2i64_r = __lsx_vsrlni_d_q(v2i64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrlni.d.q(

  // __lsx_vssrlni_b_h
  // vd, vj, ui4
  // V16QI, V16QI, V16QI, USI
  v16i8_r = __lsx_vssrlni_b_h(v16i8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrlni.b.h(

  // __lsx_vssrlni_h_w
  // vd, vj, ui5
  // V8HI, V8HI, V8HI, USI
  v8i16_r = __lsx_vssrlni_h_w(v8i16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrlni.h.w(

  // __lsx_vssrlni_w_d
  // vd, vj, ui6
  // V4SI, V4SI, V4SI, USI
  v4i32_r = __lsx_vssrlni_w_d(v4i32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrlni.w.d(

  // __lsx_vssrlni_d_q
  // vd, vj, ui7
  // V2DI, V2DI, V2DI, USI
  v2i64_r = __lsx_vssrlni_d_q(v2i64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vssrlni.d.q(

  // __lsx_vssrlni_bu_h
  // vd, vj, ui4
  // UV16QI, UV16QI, V16QI, USI
  v16u8_r = __lsx_vssrlni_bu_h(v16u8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrlni.bu.h(

  // __lsx_vssrlni_hu_w
  // vd, vj, ui5
  // UV8HI, UV8HI, V8HI, USI
  v8u16_r = __lsx_vssrlni_hu_w(v8u16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrlni.hu.w(

  // __lsx_vssrlni_wu_d
  // vd, vj, ui6
  // UV4SI, UV4SI, V4SI, USI
  v4u32_r = __lsx_vssrlni_wu_d(v4u32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrlni.wu.d(

  // __lsx_vssrlni_du_q
  // vd, vj, ui7
  // UV2DI, UV2DI, V2DI, USI
  v2u64_r = __lsx_vssrlni_du_q(v2u64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vssrlni.du.q(

  // __lsx_vssrlrni_b_h
  // vd, vj, ui4
  // V16QI, V16QI, V16QI, USI
  v16i8_r = __lsx_vssrlrni_b_h(v16i8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrlrni.b.h(

  // __lsx_vssrlrni_h_w
  // vd, vj, ui5
  // V8HI, V8HI, V8HI, USI
  v8i16_r = __lsx_vssrlrni_h_w(v8i16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrlrni.h.w(

  // __lsx_vssrlrni_w_d
  // vd, vj, ui6
  // V4SI, V4SI, V4SI, USI
  v4i32_r = __lsx_vssrlrni_w_d(v4i32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrlrni.w.d(

  // __lsx_vssrlrni_d_q
  // vd, vj, ui7
  // V2DI, V2DI, V2DI, USI
  v2i64_r = __lsx_vssrlrni_d_q(v2i64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vssrlrni.d.q(

  // __lsx_vssrlrni_bu_h
  // vd, vj, ui4
  // UV16QI, UV16QI, V16QI, USI
  v16u8_r = __lsx_vssrlrni_bu_h(v16u8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrlrni.bu.h(

  // __lsx_vssrlrni_hu_w
  // vd, vj, ui5
  // UV8HI, UV8HI, V8HI, USI
  v8u16_r = __lsx_vssrlrni_hu_w(v8u16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrlrni.hu.w(

  // __lsx_vssrlrni_wu_d
  // vd, vj, ui6
  // UV4SI, UV4SI, V4SI, USI
  v4u32_r = __lsx_vssrlrni_wu_d(v4u32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrlrni.wu.d(

  // __lsx_vssrlrni_du_q
  // vd, vj, ui7
  // UV2DI, UV2DI, V2DI, USI
  v2u64_r = __lsx_vssrlrni_du_q(v2u64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vssrlrni.du.q(

  // __lsx_vsrani_b_h
  // vd, vj, ui4
  // V16QI, V16QI, V16QI, USI
  v16i8_r = __lsx_vsrani_b_h(v16i8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrani.b.h(

  // __lsx_vsrani_h_w
  // vd, vj, ui5
  // V8HI, V8HI, V8HI, USI
  v8i16_r = __lsx_vsrani_h_w(v8i16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrani.h.w(

  // __lsx_vsrani_w_d
  // vd, vj, ui6
  // V4SI, V4SI, V4SI, USI
  v4i32_r = __lsx_vsrani_w_d(v4i32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrani.w.d(

  // __lsx_vsrani_d_q
  // vd, vj, ui7
  // V2DI, V2DI, V2DI, USI
  v2i64_r = __lsx_vsrani_d_q(v2i64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrani.d.q(

  // __lsx_vsrarni_b_h
  // vd, vj, ui4
  // V16QI, V16QI, V16QI, USI
  v16i8_r = __lsx_vsrarni_b_h(v16i8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrarni.b.h(

  // __lsx_vsrarni_h_w
  // vd, vj, ui5
  // V8HI, V8HI, V8HI, USI
  v8i16_r = __lsx_vsrarni_h_w(v8i16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrarni.h.w(

  // __lsx_vsrarni_w_d
  // vd, vj, ui6
  // V4SI, V4SI, V4SI, USI
  v4i32_r = __lsx_vsrarni_w_d(v4i32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrarni.w.d(

  // __lsx_vsrarni_d_q
  // vd, vj, ui7
  // V2DI, V2DI, V2DI, USI
  v2i64_r = __lsx_vsrarni_d_q(v2i64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrarni.d.q(

  // __lsx_vssrani_b_h
  // vd, vj, ui4
  // V16QI, V16QI, V16QI, USI
  v16i8_r = __lsx_vssrani_b_h(v16i8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrani.b.h(

  // __lsx_vssrani_h_w
  // vd, vj, ui5
  // V8HI, V8HI, V8HI, USI
  v8i16_r = __lsx_vssrani_h_w(v8i16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrani.h.w(

  // __lsx_vssrani_w_d
  // vd, vj, ui6
  // V4SI, V4SI, V4SI, USI
  v4i32_r = __lsx_vssrani_w_d(v4i32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrani.w.d(

  // __lsx_vssrani_d_q
  // vd, vj, ui7
  // V2DI, V2DI, V2DI, USI
  v2i64_r = __lsx_vssrani_d_q(v2i64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vssrani.d.q(

  // __lsx_vssrani_bu_h
  // vd, vj, ui4
  // UV16QI, UV16QI, V16QI, USI
  v16u8_r = __lsx_vssrani_bu_h(v16u8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrani.bu.h(

  // __lsx_vssrani_hu_w
  // vd, vj, ui5
  // UV8HI, UV8HI, V8HI, USI
  v8u16_r = __lsx_vssrani_hu_w(v8u16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrani.hu.w(

  // __lsx_vssrani_wu_d
  // vd, vj, ui6
  // UV4SI, UV4SI, V4SI, USI
  v4u32_r = __lsx_vssrani_wu_d(v4u32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrani.wu.d(

  // __lsx_vssrani_du_q
  // vd, vj, ui7
  // UV2DI, UV2DI, V2DI, USI
  v2u64_r = __lsx_vssrani_du_q(v2u64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vssrani.du.q(

  // __lsx_vssrarni_b_h
  // vd, vj, ui4
  // V16QI, V16QI, V16QI, USI
  v16i8_r = __lsx_vssrarni_b_h(v16i8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrarni.b.h(

  // __lsx_vssrarni_h_w
  // vd, vj, ui5
  // V8HI, V8HI, V8HI, USI
  v8i16_r = __lsx_vssrarni_h_w(v8i16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrarni.h.w(

  // __lsx_vssrarni_w_d
  // vd, vj, ui6
  // V4SI, V4SI, V4SI, USI
  v4i32_r = __lsx_vssrarni_w_d(v4i32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrarni.w.d(

  // __lsx_vssrarni_d_q
  // vd, vj, ui7
  // V2DI, V2DI, V2DI, USI
  v2i64_r = __lsx_vssrarni_d_q(v2i64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vssrarni.d.q(

  // __lsx_vssrarni_bu_h
  // vd, vj, ui4
  // UV16QI, UV16QI, V16QI, USI
  v16u8_r = __lsx_vssrarni_bu_h(v16u8_a, v16i8_b, ui4); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrarni.bu.h(

  // __lsx_vssrarni_hu_w
  // vd, vj, ui5
  // UV8HI, UV8HI, V8HI, USI
  v8u16_r = __lsx_vssrarni_hu_w(v8u16_a, v8i16_b, ui5); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrarni.hu.w(

  // __lsx_vssrarni_wu_d
  // vd, vj, ui6
  // UV4SI, UV4SI, V4SI, USI
  v4u32_r = __lsx_vssrarni_wu_d(v4u32_a, v4i32_b, ui6); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrarni.wu.d(

  // __lsx_vssrarni_du_q
  // vd, vj, ui7
  // UV2DI, UV2DI, V2DI, USI
  v2u64_r = __lsx_vssrarni_du_q(v2u64_a, v2i64_b, ui7); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vssrarni.du.q(

  // __lsx_vpermi_w
  // vd, vj, ui8
  // V4SI, V4SI, V4SI, USI
  v4i32_r = __lsx_vpermi_w(v4i32_a, v4i32_b, ui8); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vpermi.w(

  // __lsx_vld
  // vd, rj, si12
  // V16QI, CVPOINTER, SI
  v16i8_r = __lsx_vld(&v16i8_a, si12); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vld(

  // __lsx_vst
  // vd, rj, si12
  // VOID, V16QI, CVPOINTER, SI
  __lsx_vst(v16i8_a, &v16i8_b, 0); // CHECK: call void @llvm.loongarch.lsx.vst(

  // __lsx_vssrlrn_b_h
  // vd, vj, vk
  // V16QI, V8HI, V8HI
  v16i8_r = __lsx_vssrlrn_b_h(v8i16_a, v8i16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrlrn.b.h(

  // __lsx_vssrlrn_h_w
  // vd, vj, vk
  // V8HI, V4SI, V4SI
  v8i16_r = __lsx_vssrlrn_h_w(v4i32_a, v4i32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrlrn.h.w(

  // __lsx_vssrlrn_w_d
  // vd, vj, vk
  // V4SI, V2DI, V2DI
  v4i32_r = __lsx_vssrlrn_w_d(v2i64_a, v2i64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrlrn.w.d(

  // __lsx_vssrln_b_h
  // vd, vj, vk
  // V16QI, V8HI, V8HI
  v16i8_r = __lsx_vssrln_b_h(v8i16_a, v8i16_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vssrln.b.h(

  // __lsx_vssrln_h_w
  // vd, vj, vk
  // V8HI, V4SI, V4SI
  v8i16_r = __lsx_vssrln_h_w(v4i32_a, v4i32_b); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vssrln.h.w(

  // __lsx_vssrln_w_d
  // vd, vj, vk
  // V4SI, V2DI, V2DI
  v4i32_r = __lsx_vssrln_w_d(v2i64_a, v2i64_b); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vssrln.w.d(

  // __lsx_vorn_v
  // vd, vj, vk
  // V16QI, V16QI, V16QI
  v16i8_r = __lsx_vorn_v(v16i8_a, v16i8_b); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vorn.v(

  // __lsx_vldi
  // vd, i13
  // V2DI, HI
  v2i64_r = __lsx_vldi(i13); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vldi(

  // __lsx_vshuf_b
  // vd, vj, vk, va
  // V16QI, V16QI, V16QI, V16QI
  v16i8_r = __lsx_vshuf_b(v16i8_a, v16i8_b, v16i8_c); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vshuf.b(

  // __lsx_vldx
  // vd, rj, rk
  // V16QI, CVPOINTER, DI
  v16i8_r = __lsx_vldx(&v16i8_a, i64_d); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vldx(

  // __lsx_vstx
  // vd, rj, rk
  // VOID, V16QI, CVPOINTER, DI
  __lsx_vstx(v16i8_a, &v16i8_b, i64_d); // CHECK: call void @llvm.loongarch.lsx.vstx(

  // __lsx_vextl_qu_du
  // vd, vj
  // UV2DI, UV2DI
  v2u64_r = __lsx_vextl_qu_du(v2u64_a); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vextl.qu.du(

  // __lsx_bnz_v
  // rd, vj
  // SI, UV16QI
  i32_r = __lsx_bnz_v(v16u8_a); // CHECK: call i32 @llvm.loongarch.lsx.bnz.v(

  // __lsx_bz_v
  // rd, vj
  // SI, UV16QI
  i32_r = __lsx_bz_v(v16u8_a); // CHECK: call i32 @llvm.loongarch.lsx.bz.v(

  // __lsx_bnz_b
  // rd, vj
  // SI, UV16QI
  i32_r = __lsx_bnz_b(v16u8_a); // CHECK: call i32 @llvm.loongarch.lsx.bnz.b(

  // __lsx_bnz_h
  // rd, vj
  // SI, UV8HI
  i32_r = __lsx_bnz_h(v8u16_a); // CHECK: call i32 @llvm.loongarch.lsx.bnz.h(

  // __lsx_bnz_w
  // rd, vj
  // SI, UV4SI
  i32_r = __lsx_bnz_w(v4u32_a); // CHECK: call i32 @llvm.loongarch.lsx.bnz.w(

  // __lsx_bnz_d
  // rd, vj
  // SI, UV2DI
  i32_r = __lsx_bnz_d(v2u64_a); // CHECK: call i32 @llvm.loongarch.lsx.bnz.d(

  // __lsx_bz_b
  // rd, vj
  // SI, UV16QI
  i32_r = __lsx_bz_b(v16u8_a); // CHECK: call i32 @llvm.loongarch.lsx.bz.b(

  // __lsx_bz_h
  // rd, vj
  // SI, UV8HI
  i32_r = __lsx_bz_h(v8u16_a); // CHECK: call i32 @llvm.loongarch.lsx.bz.h(

  // __lsx_bz_w
  // rd, vj
  // SI, UV4SI
  i32_r = __lsx_bz_w(v4u32_a); // CHECK: call i32 @llvm.loongarch.lsx.bz.w(

  // __lsx_bz_d
  // rd, vj
  // SI, UV2DI
  i32_r = __lsx_bz_d(v2u64_a); // CHECK: call i32 @llvm.loongarch.lsx.bz.d(

  v16i8_r = __lsx_vsrlrni_b_h(v16i8_a, v16i8_b, 2); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vsrlrni.b.h(

  v8i16_r = __lsx_vsrlrni_h_w(v8i16_a, v8i16_b, 2); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vsrlrni.h.w(

  v4i32_r = __lsx_vsrlrni_w_d(v4i32_a, v4i32_b, 2); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vsrlrni.w.d(

  v2i64_r = __lsx_vsrlrni_d_q(v2i64_a, v2i64_b, 2); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vsrlrni.d.q(

  v16i8_r = __lsx_vrepli_b(2); // CHECK: call <16 x i8> @llvm.loongarch.lsx.vrepli.b(

  v8i16_r = __lsx_vrepli_h(2); // CHECK: call <8 x i16> @llvm.loongarch.lsx.vrepli.h(

  v4i32_r = __lsx_vrepli_w(2); // CHECK: call <4 x i32> @llvm.loongarch.lsx.vrepli.w(

  v2i64_r = __lsx_vrepli_d(2); // CHECK: call <2 x i64> @llvm.loongarch.lsx.vrepli.d(
}
