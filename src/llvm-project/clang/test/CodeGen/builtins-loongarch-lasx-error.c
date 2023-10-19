// REQUIRES: loongarch-registered-target
// RUN: %clang_cc1 -triple loongarch64-unknown-linux-gnu -fsyntax-only %s \
// RUN:            -target-feature +lasx \
// RUN:            -verify -o - 2>&1

#include <lasxintrin.h>

void test() {
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
  unsigned long long u64_r;
  unsigned long long u64_a = 1;
  unsigned long long u64_b = 2;
  unsigned long long u64_c = 3;

  v32i8_r = __lasx_xvslli_b(v32i8_a, 8);                    // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16i16_r = __lasx_xvslli_h(v16i16_a, 16);                 // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i32_r = __lasx_xvslli_w(v8i32_a, 32);                   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvslli_d(v4i64_a, 64);                   // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32i8_r = __lasx_xvsrai_b(v32i8_a, 8);                    // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16i16_r = __lasx_xvsrai_h(v16i16_a, 16);                 // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i32_r = __lasx_xvsrai_w(v8i32_a, 32);                   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvsrai_d(v4i64_a, 64);                   // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32i8_r = __lasx_xvsrari_b(v32i8_a, 8);                   // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16i16_r = __lasx_xvsrari_h(v16i16_a, 16);                // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i32_r = __lasx_xvsrari_w(v8i32_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvsrari_d(v4i64_a, 64);                  // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32i8_r = __lasx_xvsrli_b(v32i8_a, 8);                    // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16i16_r = __lasx_xvsrli_h(v16i16_a, 16);                 // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i32_r = __lasx_xvsrli_w(v8i32_a, 32);                   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvsrli_d(v4i64_a, 64);                   // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32i8_r = __lasx_xvsrlri_b(v32i8_a, 8);                   // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16i16_r = __lasx_xvsrlri_h(v16i16_a, 16);                // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i32_r = __lasx_xvsrlri_w(v8i32_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvsrlri_d(v4i64_a, 64);                  // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32u8_r = __lasx_xvbitclri_b(v32u8_a, 8);                 // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16u16_r = __lasx_xvbitclri_h(v16u16_a, 16);              // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8u32_r = __lasx_xvbitclri_w(v8u32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u64_r = __lasx_xvbitclri_d(v4u64_a, 64);                // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32u8_r = __lasx_xvbitseti_b(v32u8_a, 8);                 // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16u16_r = __lasx_xvbitseti_h(v16u16_a, 16);              // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8u32_r = __lasx_xvbitseti_w(v8u32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u64_r = __lasx_xvbitseti_d(v4u64_a, 64);                // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32u8_r = __lasx_xvbitrevi_b(v32u8_a, 8);                 // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16u16_r = __lasx_xvbitrevi_h(v16u16_a, 16);              // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8u32_r = __lasx_xvbitrevi_w(v8u32_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u64_r = __lasx_xvbitrevi_d(v4u64_a, 64);                // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32i8_r = __lasx_xvaddi_bu(v32i8_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i16_r = __lasx_xvaddi_hu(v16i16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvaddi_wu(v8i32_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvaddi_du(v4i64_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v32i8_r = __lasx_xvsubi_bu(v32i8_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i16_r = __lasx_xvsubi_hu(v16i16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvsubi_wu(v8i32_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvsubi_du(v4i64_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v32i8_r = __lasx_xvmaxi_b(v32i8_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v16i16_r = __lasx_xvmaxi_h(v16i16_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v8i32_r = __lasx_xvmaxi_w(v8i32_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v4i64_r = __lasx_xvmaxi_d(v4i64_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v32u8_r = __lasx_xvmaxi_bu(v32u8_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16u16_r = __lasx_xvmaxi_hu(v16u16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8u32_r = __lasx_xvmaxi_wu(v8u32_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u64_r = __lasx_xvmaxi_du(v4u64_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v32i8_r = __lasx_xvmini_b(v32i8_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v16i16_r = __lasx_xvmini_h(v16i16_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v8i32_r = __lasx_xvmini_w(v8i32_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v4i64_r = __lasx_xvmini_d(v4i64_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v32u8_r = __lasx_xvmini_bu(v32u8_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16u16_r = __lasx_xvmini_hu(v16u16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8u32_r = __lasx_xvmini_wu(v8u32_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u64_r = __lasx_xvmini_du(v4u64_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v32i8_r = __lasx_xvseqi_b(v32i8_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v16i16_r = __lasx_xvseqi_h(v16i16_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v8i32_r = __lasx_xvseqi_w(v8i32_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v4i64_r = __lasx_xvseqi_d(v4i64_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v32i8_r = __lasx_xvslti_b(v32i8_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v16i16_r = __lasx_xvslti_h(v16i16_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v8i32_r = __lasx_xvslti_w(v8i32_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v4i64_r = __lasx_xvslti_d(v4i64_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v32i8_r = __lasx_xvslti_bu(v32u8_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i16_r = __lasx_xvslti_hu(v16u16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvslti_wu(v8u32_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvslti_du(v4u64_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v32i8_r = __lasx_xvslei_b(v32i8_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v16i16_r = __lasx_xvslei_h(v16i16_a, -17);                // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v8i32_r = __lasx_xvslei_w(v8i32_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v4i64_r = __lasx_xvslei_d(v4i64_a, -17);                  // expected-error {{argument value -17 is outside the valid range [-16, 15]}}
  v32i8_r = __lasx_xvslei_bu(v32u8_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i16_r = __lasx_xvslei_hu(v16u16_a, 32);                // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvslei_wu(v8u32_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvslei_du(v4u64_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v32i8_r = __lasx_xvsat_b(v32i8_a, 8);                     // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16i16_r = __lasx_xvsat_h(v16i16_a, 16);                  // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i32_r = __lasx_xvsat_w(v8i32_a, 32);                    // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvsat_d(v4i64_a, 64);                    // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32u8_r = __lasx_xvsat_bu(v32u8_a, 8);                    // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16u16_r = __lasx_xvsat_hu(v16u16_a, 16);                 // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8u32_r = __lasx_xvsat_wu(v8u32_a, 32);                   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4u64_r = __lasx_xvsat_du(v4u64_a, 64);                   // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32i8_r = __lasx_xvrepl128vei_b(v32i8_a, 16);             // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16i16_r = __lasx_xvrepl128vei_h(v16i16_a, 8);            // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8i32_r = __lasx_xvrepl128vei_w(v8i32_a, 4);              // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  v4i64_r = __lasx_xvrepl128vei_d(v4i64_a, 2);              // expected-error {{argument value 2 is outside the valid range [0, 1]}}
  v32u8_r = __lasx_xvandi_b(v32u8_a, 256);                  // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v32u8_r = __lasx_xvori_b(v32u8_a, 256);                   // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v32u8_r = __lasx_xvnori_b(v32u8_a, 256);                  // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v32u8_r = __lasx_xvxori_b(v32u8_a, 256);                  // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v32u8_r = __lasx_xvbitseli_b(v32u8_a, v32u8_b, 256);      // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v32i8_r = __lasx_xvshuf4i_b(v32i8_a, 256);                // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v16i16_r = __lasx_xvshuf4i_h(v16i16_a, 256);              // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v8i32_r = __lasx_xvshuf4i_w(v8i32_a, 256);                // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v8i32_r = __lasx_xvpermi_w(v8i32_a, v8i32_b, 256);        // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v16i16_r = __lasx_xvsllwil_h_b(v32i8_a, 8);               // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8i32_r = __lasx_xvsllwil_w_h(v16i16_a, 16);              // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4i64_r = __lasx_xvsllwil_d_w(v8i32_a, 32);               // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16u16_r = __lasx_xvsllwil_hu_bu(v32u8_a, 8);             // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v8u32_r = __lasx_xvsllwil_wu_hu(v16u16_a, 16);            // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v4u64_r = __lasx_xvsllwil_du_wu(v8u32_a, 32);             // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v32i8_r = __lasx_xvfrstpi_b(v32i8_a, v32i8_b, 32);        // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v16i16_r = __lasx_xvfrstpi_h(v16i16_a, v16i16_b, 32);     // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvshuf4i_d(v4i64_a, v4i64_b, 256);       // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v32i8_r = __lasx_xvbsrl_v(v32i8_a, 32);                   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v32i8_r = __lasx_xvbsll_v(v32i8_a, 32);                   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v32i8_r = __lasx_xvextrins_b(v32i8_a, v32i8_b, 256);      // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v16i16_r = __lasx_xvextrins_h(v16i16_a, v16i16_b, 256);   // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v8i32_r = __lasx_xvextrins_w(v8i32_a, v8i32_b, 256);      // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v4i64_r = __lasx_xvextrins_d(v4i64_a, v4i64_b, 256);      // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v32i8_r = __lasx_xvld(&v32i8_a, -2049);                   // expected-error {{argument value -2049 is outside the valid range [-2048, 2047]}}
  __lasx_xvst(v32i8_a, &v32i8_b, -2049);                    // expected-error {{argument value -2049 is outside the valid range [-2048, 2047]}}
  __lasx_xvstelm_b(v32i8_a, &v32i8_b, 0, 32);               // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  __lasx_xvstelm_h(v16i16_a, &v16i16_b, 0, 16);             // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  __lasx_xvstelm_w(v8i32_a, &v8i32_b, 0, 8);                // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  __lasx_xvstelm_d(v4i64_a, &v4i64_b, 0, 4);                // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  v8i32_r = __lasx_xvinsve0_w(v8i32_a, v8i32_b, 8);         // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v4i64_r = __lasx_xvinsve0_d(v4i64_a, v4i64_b, 4);         // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  v8i32_r = __lasx_xvpickve_w(v8i32_b, 8);                  // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v4i64_r = __lasx_xvpickve_d(v4i64_b, 4);                  // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  v4i64_r = __lasx_xvldi(-4097);                            // expected-error {{argument value -4097 is outside the valid range [-4096, 4095]}}
  v8i32_r = __lasx_xvinsgr2vr_w(v8i32_a, i32_b, 8);         // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v4i64_r = __lasx_xvinsgr2vr_d(v4i64_a, i64_b, 4);         // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  v32i8_r = __lasx_xvpermi_q(v32i8_a, v32i8_b, 256);        // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v4i64_r = __lasx_xvpermi_d(v4i64_a, 256);                 // expected-error {{argument value 256 is outside the valid range [0, 255]}}
  v32i8_r = __lasx_xvldrepl_b(&v32i8_a, -2049);             // expected-error {{argument value -2049 is outside the valid range [-2048, 2047]}}
  v16i16_r = __lasx_xvldrepl_h(&v16i16_a, -1025);           // expected-error {{argument value -1025 is outside the valid range [-1024, 1023]}}
  v8i32_r = __lasx_xvldrepl_w(&v8i32_a, -513);              // expected-error {{argument value -513 is outside the valid range [-512, 511]}}
  v4i64_r = __lasx_xvldrepl_d(&v4i64_a, -257);              // expected-error {{argument value -257 is outside the valid range [-256, 255]}}
  i32_r = __lasx_xvpickve2gr_w(v8i32_a, 8);                 // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  u32_r = __lasx_xvpickve2gr_wu(v8i32_a, 8);                // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  i64_r = __lasx_xvpickve2gr_d(v4i64_a, 4);                 // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  u64_r = __lasx_xvpickve2gr_du(v4i64_a, 4);                // expected-error {{argument value 4 is outside the valid range [0, 3]}}
  v32i8_r = __lasx_xvrotri_b(v32i8_a, 8);                   // expected-error {{argument value 8 is outside the valid range [0, 7]}}
  v16i16_r = __lasx_xvrotri_h(v16i16_a, 16);                // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v8i32_r = __lasx_xvrotri_w(v8i32_a, 32);                  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v4i64_r = __lasx_xvrotri_d(v4i64_a, 64);                  // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v32i8_r = __lasx_xvsrlni_b_h(v32i8_a, v32i8_b, 16);       // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16i16_r = __lasx_xvsrlni_h_w(v16i16_a, v16i16_b, 32);    // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvsrlni_w_d(v8i32_a, v8i32_b, 64);       // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4i64_r = __lasx_xvsrlni_d_q(v4i64_a, v4i64_b, 128);      // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32i8_r = __lasx_xvsrlrni_b_h(v32i8_a, v32i8_b, 16);      // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16i16_r = __lasx_xvsrlrni_h_w(v16i16_a, v16i16_b, 32);   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvsrlrni_w_d(v8i32_a, v8i32_b, 64);      // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4i64_r = __lasx_xvsrlrni_d_q(v4i64_a, v4i64_b, 128);     // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32i8_r = __lasx_xvssrlni_b_h(v32i8_a, v32i8_b, 16);      // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16i16_r = __lasx_xvssrlni_h_w(v16i16_a, v16i16_b, 32);   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvssrlni_w_d(v8i32_a, v8i32_b, 64);      // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4i64_r = __lasx_xvssrlni_d_q(v4i64_a, v4i64_b, 128);     // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32u8_r = __lasx_xvssrlni_bu_h(v32u8_a, v32i8_b, 16);     // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16u16_r = __lasx_xvssrlni_hu_w(v16u16_a, v16i16_b, 32);  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8u32_r = __lasx_xvssrlni_wu_d(v8u32_a, v8i32_b, 64);     // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4u64_r = __lasx_xvssrlni_du_q(v4u64_a, v4i64_b, 128);    // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32i8_r = __lasx_xvssrlrni_b_h(v32i8_a, v32i8_b, 16);     // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16i16_r = __lasx_xvssrlrni_h_w(v16i16_a, v16i16_b, 32);  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvssrlrni_w_d(v8i32_a, v8i32_b, 64);     // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4i64_r = __lasx_xvssrlrni_d_q(v4i64_a, v4i64_b, 128);    // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32u8_r = __lasx_xvssrlrni_bu_h(v32u8_a, v32i8_b, 16);    // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16u16_r = __lasx_xvssrlrni_hu_w(v16u16_a, v16i16_b, 32); // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8u32_r = __lasx_xvssrlrni_wu_d(v8u32_a, v8i32_b, 64);    // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4u64_r = __lasx_xvssrlrni_du_q(v4u64_a, v4i64_b, 128);   // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32i8_r = __lasx_xvsrani_b_h(v32i8_a, v32i8_b, 16);       // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16i16_r = __lasx_xvsrani_h_w(v16i16_a, v16i16_b, 32);    // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvsrani_w_d(v8i32_a, v8i32_b, 64);       // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4i64_r = __lasx_xvsrani_d_q(v4i64_a, v4i64_b, 128);      // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32i8_r = __lasx_xvsrarni_b_h(v32i8_a, v32i8_b, 16);      // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16i16_r = __lasx_xvsrarni_h_w(v16i16_a, v16i16_b, 32);   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvsrarni_w_d(v8i32_a, v8i32_b, 64);      // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4i64_r = __lasx_xvsrarni_d_q(v4i64_a, v4i64_b, 128);     // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32i8_r = __lasx_xvssrani_b_h(v32i8_a, v32i8_b, 16);      // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16i16_r = __lasx_xvssrani_h_w(v16i16_a, v16i16_b, 32);   // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvssrani_w_d(v8i32_a, v8i32_b, 64);      // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4i64_r = __lasx_xvssrani_d_q(v4i64_a, v4i64_b, 128);     // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32u8_r = __lasx_xvssrani_bu_h(v32u8_a, v32i8_b, 16);     // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16u16_r = __lasx_xvssrani_hu_w(v16u16_a, v16i16_b, 32);  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8u32_r = __lasx_xvssrani_wu_d(v8u32_a, v8i32_b, 64);     // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4u64_r = __lasx_xvssrani_du_q(v4u64_a, v4i64_b, 128);    // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32i8_r = __lasx_xvssrarni_b_h(v32i8_a, v32i8_b, 16);     // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16i16_r = __lasx_xvssrarni_h_w(v16i16_a, v16i16_b, 32);  // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8i32_r = __lasx_xvssrarni_w_d(v8i32_a, v8i32_b, 64);     // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4i64_r = __lasx_xvssrarni_d_q(v4i64_a, v4i64_b, 128);    // expected-error {{argument value 128 is outside the valid range [0, 127]}}
  v32u8_r = __lasx_xvssrarni_bu_h(v32u8_a, v32i8_b, 16);    // expected-error {{argument value 16 is outside the valid range [0, 15]}}
  v16u16_r = __lasx_xvssrarni_hu_w(v16u16_a, v16i16_b, 32); // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  v8u32_r = __lasx_xvssrarni_wu_d(v8u32_a, v8i32_b, 64);    // expected-error {{argument value 64 is outside the valid range [0, 63]}}
  v4u64_r = __lasx_xvssrarni_du_q(v4u64_a, v4i64_b, 128);   // expected-error {{argument value 128 is outside the valid range [0, 127]}}
}
