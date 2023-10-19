// REQUIRES: loongarch-registered-target
// RUN: %clang_cc1 -triple loongarch64-unknown-linux-gnu -fsyntax-only %s \
// RUN:            -target-feature +lsx \
// RUN:            -verify -o - 2>&1

#include <lsxintrin.h>

void test() {
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
  unsigned long long u64_r;
  unsigned long long u64_a = 1;
  unsigned long long u64_b = 2;
  unsigned long long u64_c = 3;

  v16i8_r = __lsx_vslli_b(v16i8_a, 8);                  // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8i16_r = __lsx_vslli_h(v8i16_a, 16);                 // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4i32_r = __lsx_vslli_w(v4i32_a, 32);                 // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vslli_d(v2i64_a, 64);                 // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16i8_r = __lsx_vsrai_b(v16i8_a, 8);                  // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8i16_r = __lsx_vsrai_h(v8i16_a, 16);                 // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4i32_r = __lsx_vsrai_w(v4i32_a, 32);                 // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vsrai_d(v2i64_a, 64);                 // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16i8_r = __lsx_vsrari_b(v16i8_a, 8);                 // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8i16_r = __lsx_vsrari_h(v8i16_a, 16);                // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4i32_r = __lsx_vsrari_w(v4i32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vsrari_d(v2i64_a, 64);                // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16i8_r = __lsx_vsrli_b(v16i8_a, 8);                  // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8i16_r = __lsx_vsrli_h(v8i16_a, 16);                 // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4i32_r = __lsx_vsrli_w(v4i32_a, 32);                 // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vsrli_d(v2i64_a, 64);                 // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16i8_r = __lsx_vsrlri_b(v16i8_a, 8);                 // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8i16_r = __lsx_vsrlri_h(v8i16_a, 16);                // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4i32_r = __lsx_vsrlri_w(v4i32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vsrlri_d(v2i64_a, 64);                // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16u8_r = __lsx_vbitclri_b(v16u8_a, 8);               // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8u16_r = __lsx_vbitclri_h(v8u16_a, 16);              // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4u32_r = __lsx_vbitclri_w(v4u32_a, 32);              // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2u64_r = __lsx_vbitclri_d(v2u64_a, 64);              // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16u8_r = __lsx_vbitseti_b(v16u8_a, 8);               // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8u16_r = __lsx_vbitseti_h(v8u16_a, 16);              // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4u32_r = __lsx_vbitseti_w(v4u32_a, 32);              // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2u64_r = __lsx_vbitseti_d(v2u64_a, 64);              // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16u8_r = __lsx_vbitrevi_b(v16u8_a, 8);               // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8u16_r = __lsx_vbitrevi_h(v8u16_a, 16);              // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4u32_r = __lsx_vbitrevi_w(v4u32_a, 32);              // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2u64_r = __lsx_vbitrevi_d(v2u64_a, 64);              // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16i8_r = __lsx_vaddi_bu(v16i8_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i16_r = __lsx_vaddi_hu(v8i16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vaddi_wu(v4i32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vaddi_du(v2i64_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i8_r = __lsx_vsubi_bu(v16i8_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i16_r = __lsx_vsubi_hu(v8i16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vsubi_wu(v4i32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vsubi_du(v2i64_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i8_r = __lsx_vmaxi_b(v16i8_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v8i16_r = __lsx_vmaxi_h(v8i16_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v4i32_r = __lsx_vmaxi_w(v4i32_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v2i64_r = __lsx_vmaxi_d(v2i64_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v16u8_r = __lsx_vmaxi_bu(v16u8_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8u16_r = __lsx_vmaxi_hu(v8u16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u32_r = __lsx_vmaxi_wu(v4u32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2u64_r = __lsx_vmaxi_du(v2u64_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i8_r = __lsx_vmini_b(v16i8_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v8i16_r = __lsx_vmini_h(v8i16_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v4i32_r = __lsx_vmini_w(v4i32_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v2i64_r = __lsx_vmini_d(v2i64_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v16u8_r = __lsx_vmini_bu(v16u8_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8u16_r = __lsx_vmini_hu(v8u16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u32_r = __lsx_vmini_wu(v4u32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2u64_r = __lsx_vmini_du(v2u64_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i8_r = __lsx_vseqi_b(v16i8_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v8i16_r = __lsx_vseqi_h(v8i16_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v4i32_r = __lsx_vseqi_w(v4i32_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v2i64_r = __lsx_vseqi_d(v2i64_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v16i8_r = __lsx_vslti_b(v16i8_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v8i16_r = __lsx_vslti_h(v8i16_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v4i32_r = __lsx_vslti_w(v4i32_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v2i64_r = __lsx_vslti_d(v2i64_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v16i8_r = __lsx_vslti_bu(v16u8_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i16_r = __lsx_vslti_hu(v8u16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vslti_wu(v4u32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vslti_du(v2u64_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i8_r = __lsx_vslei_b(v16i8_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v8i16_r = __lsx_vslei_h(v8i16_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v4i32_r = __lsx_vslei_w(v4i32_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v2i64_r = __lsx_vslei_d(v2i64_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v16i8_r = __lsx_vslei_bu(v16u8_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i16_r = __lsx_vslei_hu(v8u16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vslei_wu(v4u32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vslei_du(v2u64_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i8_r = __lsx_vsat_b(v16i8_a, 8);                   // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8i16_r = __lsx_vsat_h(v8i16_a, 16);                  // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4i32_r = __lsx_vsat_w(v4i32_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vsat_d(v2i64_a, 64);                  // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16u8_r = __lsx_vsat_bu(v16u8_a, 8);                  // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8u16_r = __lsx_vsat_hu(v8u16_a, 16);                 // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4u32_r = __lsx_vsat_wu(v4u32_a, 32);                 // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2u64_r = __lsx_vsat_du(v2u64_a, 64);                 // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16i8_r = __lsx_vreplvei_b(v16i8_a, 16);              // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i16_r = __lsx_vreplvei_h(v8i16_a, 8);               // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v4i32_r = __lsx_vreplvei_w(v4i32_a, 4);               // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  v2i64_r = __lsx_vreplvei_d(v2i64_a, 2);               // expected-error {{argument value 2 is outside the valid range [0, 1]}}
  v16u8_r = __lsx_vandi_b(v16u8_a, 256);                // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v16u8_r = __lsx_vori_b(v16u8_a, 256);                 // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v16u8_r = __lsx_vnori_b(v16u8_a, 256);                // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v16u8_r = __lsx_vxori_b(v16u8_a, 256);                // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v16u8_r = __lsx_vbitseli_b(v16u8_a, v16u8_b, 256);    // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v16i8_r = __lsx_vshuf4i_b(v16i8_a, 256);              // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v8i16_r = __lsx_vshuf4i_h(v8i16_a, 256);              // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v4i32_r = __lsx_vshuf4i_w(v4i32_a, 256);              // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  i32_r = __lsx_vpickve2gr_b(v16i8_a, 16);              // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  i32_r = __lsx_vpickve2gr_h(v8i16_a, 8);               // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  i32_r = __lsx_vpickve2gr_w(v4i32_a, 4);               // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  i64_r = __lsx_vpickve2gr_d(v2i64_a, 2);               // expected-error {{argument value 2 is outside the valid range [0, 1]}}
  u32_r = __lsx_vpickve2gr_bu(v16i8_a, 16);             // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  u32_r = __lsx_vpickve2gr_hu(v8i16_a, 8);              // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  u32_r = __lsx_vpickve2gr_wu(v4i32_a, 4);              // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  u64_r = __lsx_vpickve2gr_du(v2i64_a, 2);              // expected-error {{argument value 2 is outside the valid range [0, 1]}}
  v16i8_r = __lsx_vinsgr2vr_b(v16i8_a, i32_b, 16);      // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i16_r = __lsx_vinsgr2vr_h(v8i16_a, i32_b, 8);       // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v4i32_r = __lsx_vinsgr2vr_w(v4i32_a, i32_b, 4);       // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  v2i64_r = __lsx_vinsgr2vr_d(v2i64_a, i32_b, 2);       // expected-error {{argument value 2 is outside the valid range [0, 1]}}
  v8i16_r = __lsx_vsllwil_h_b(v16i8_a, 8);              // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v4i32_r = __lsx_vsllwil_w_h(v8i16_a, 16);             // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v2i64_r = __lsx_vsllwil_d_w(v4i32_a, 32);             // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8u16_r = __lsx_vsllwil_hu_bu(v16u8_a, 8);            // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v4u32_r = __lsx_vsllwil_wu_hu(v8u16_a, 16);           // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v2u64_r = __lsx_vsllwil_du_wu(v4u32_a, 32);           // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i8_r = __lsx_vfrstpi_b(v16i8_a, v16i8_b, 32);      // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i16_r = __lsx_vfrstpi_h(v8i16_a, v8i16_b, 32);      // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vshuf4i_d(v2i64_a, v2i64_b, 256);     // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v16i8_r = __lsx_vbsrl_v(v16i8_a, 32);                 // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i8_r = __lsx_vbsll_v(v16i8_a, 32);                 // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i8_r = __lsx_vextrins_b(v16i8_a, v16i8_b, 256);    // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v8i16_r = __lsx_vextrins_h(v8i16_a, v8i16_b, 256);    // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v4i32_r = __lsx_vextrins_w(v4i32_a, v4i32_b, 256);    // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v2i64_r = __lsx_vextrins_d(v2i64_a, v2i64_b, 256);    // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  __lsx_vstelm_b(v16i8_a, &v16i8_b, 0, 16);             // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  __lsx_vstelm_h(v8i16_a, &v8i16_b, 0, 8);              // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  __lsx_vstelm_w(v4i32_a, &v4i32_b, 0, 4);              // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  __lsx_vstelm_d(v2i64_a, &v2i64_b, 0, 2);              // expected-error {{argument value 2 is outside the valid range [0, 1]}}
  v16i8_r = __lsx_vldrepl_b(&v16i8_a, -2049);           // expected-error {{argument value -2049 is outside the valid range [-2048, 2047]}}
  v8i16_r = __lsx_vldrepl_h(&v8i16_a, -1025);           // expected-error {{argument value -1025 is outside the valid range [-1024, 1023]}}
  v4i32_r = __lsx_vldrepl_w(&v4i32_a, -513);            // expected-error {{argument value -513 is outside the valid range [-512, 511]}}
  v2i64_r = __lsx_vldrepl_d(&v2i64_a, -257);            // expected-error {{argument value -257 is outside the valid range [-256, 255]}}
  v16i8_r = __lsx_vrotri_b(v16i8_a, 8);                 // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8i16_r = __lsx_vrotri_h(v8i16_a, 16);                // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4i32_r = __lsx_vrotri_w(v4i32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v2i64_r = __lsx_vrotri_d(v2i64_a, 64);                // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v16i8_r = __lsx_vsrlni_b_h(v16i8_a, v16i8_b, 16);     // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i16_r = __lsx_vsrlni_h_w(v8i16_a, v8i16_b, 32);     // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vsrlni_w_d(v4i32_a, v4i32_b, 64);     // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2i64_r = __lsx_vsrlni_d_q(v2i64_a, v2i64_b, 128);    // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v16i8_r = __lsx_vssrlni_b_h(v16i8_a, v16i8_b, 16);    // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i16_r = __lsx_vssrlni_h_w(v8i16_a, v8i16_b, 32);    // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vssrlni_w_d(v4i32_a, v4i32_b, 64);    // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2i64_r = __lsx_vssrlni_d_q(v2i64_a, v2i64_b, 128);   // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v16u8_r = __lsx_vssrlni_bu_h(v16u8_a, v16i8_b, 16);   // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8u16_r = __lsx_vssrlni_hu_w(v8u16_a, v8i16_b, 32);   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u32_r = __lsx_vssrlni_wu_d(v4u32_a, v4i32_b, 64);   // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2u64_r = __lsx_vssrlni_du_q(v2u64_a, v2i64_b, 128);  // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v16i8_r = __lsx_vssrlrni_b_h(v16i8_a, v16i8_b, 16);   // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i16_r = __lsx_vssrlrni_h_w(v8i16_a, v8i16_b, 32);   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vssrlrni_w_d(v4i32_a, v4i32_b, 64);   // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2i64_r = __lsx_vssrlrni_d_q(v2i64_a, v2i64_b, 128);  // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v16u8_r = __lsx_vssrlrni_bu_h(v16u8_a, v16i8_b, 16);  // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8u16_r = __lsx_vssrlrni_hu_w(v8u16_a, v8i16_b, 32);  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u32_r = __lsx_vssrlrni_wu_d(v4u32_a, v4i32_b, 64);  // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2u64_r = __lsx_vssrlrni_du_q(v2u64_a, v2i64_b, 128); // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v16i8_r = __lsx_vsrani_b_h(v16i8_a, v16i8_b, 16);     // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i16_r = __lsx_vsrani_h_w(v8i16_a, v8i16_b, 32);     // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vsrani_w_d(v4i32_a, v4i32_b, 64);     // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2i64_r = __lsx_vsrani_d_q(v2i64_a, v2i64_b, 128);    // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v16i8_r = __lsx_vsrarni_b_h(v16i8_a, v16i8_b, 16);    // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i16_r = __lsx_vsrarni_h_w(v8i16_a, v8i16_b, 32);    // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vsrarni_w_d(v4i32_a, v4i32_b, 64);    // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2i64_r = __lsx_vsrarni_d_q(v2i64_a, v2i64_b, 128);   // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v16i8_r = __lsx_vssrani_b_h(v16i8_a, v16i8_b, 16);    // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i16_r = __lsx_vssrani_h_w(v8i16_a, v8i16_b, 32);    // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vssrani_w_d(v4i32_a, v4i32_b, 64);    // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2i64_r = __lsx_vssrani_d_q(v2i64_a, v2i64_b, 128);   // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v16u8_r = __lsx_vssrani_bu_h(v16u8_a, v16i8_b, 16);   // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8u16_r = __lsx_vssrani_hu_w(v8u16_a, v8i16_b, 32);   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u32_r = __lsx_vssrani_wu_d(v4u32_a, v4i32_b, 64);   // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2u64_r = __lsx_vssrani_du_q(v2u64_a, v2i64_b, 128);  // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v16i8_r = __lsx_vssrarni_b_h(v16i8_a, v16i8_b, 16);   // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i16_r = __lsx_vssrarni_h_w(v8i16_a, v8i16_b, 32);   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i32_r = __lsx_vssrarni_w_d(v4i32_a, v4i32_b, 64);   // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2i64_r = __lsx_vssrarni_d_q(v2i64_a, v2i64_b, 128);  // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v16u8_r = __lsx_vssrarni_bu_h(v16u8_a, v16i8_b, 16);  // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8u16_r = __lsx_vssrarni_hu_w(v8u16_a, v8i16_b, 32);  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u32_r = __lsx_vssrarni_wu_d(v4u32_a, v4i32_b, 64);  // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v2u64_r = __lsx_vssrarni_du_q(v2u64_a, v2i64_b, 128); // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v4i32_r = __lsx_vpermi_w(v4i32_a, v4i32_b, 256);      // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v16i8_r = __lsx_vld(&v16i8_a, -2049);                 // expected-error {{argument value -2049 is outside the valid range [-2048, 2047]}}
  __lsx_vst(v16i8_a, &v16i8_b, -2049);                  // expected-error {{argument value -2049 is outside the valid range [-2048, 2047]}}
  v2i64_r = __lsx_vldi(-4097);                          // expected-error {{argument value -4097 is outside the valid range [-4096, 4095]}}
}
