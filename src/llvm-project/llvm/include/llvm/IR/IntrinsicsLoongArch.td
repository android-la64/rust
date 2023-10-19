//===- IntrinsicsLoongArch.td - Defines LoongArch intrinsics ---------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the LoongArch-specific intrinsics.
//
//===----------------------------------------------------------------------===//

let TargetPrefix = "loongarch" in {  // All intrinsics start with "llvm.loongarch.".

//===----------------------------------------------------------------------===//
// LoongArch LSX

def int_loongarch_lsx_vclo_b : GCCBuiltin<"__builtin_lsx_vclo_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vclo_h : GCCBuiltin<"__builtin_lsx_vclo_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vclo_w : GCCBuiltin<"__builtin_lsx_vclo_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vclo_d : GCCBuiltin<"__builtin_lsx_vclo_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vflogb_s : GCCBuiltin<"__builtin_lsx_vflogb_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vflogb_d : GCCBuiltin<"__builtin_lsx_vflogb_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vpickve2gr_b : GCCBuiltin<"__builtin_lsx_vpickve2gr_b">,
  Intrinsic<[llvm_i32_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickve2gr_h : GCCBuiltin<"__builtin_lsx_vpickve2gr_h">,
  Intrinsic<[llvm_i32_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickve2gr_w : GCCBuiltin<"__builtin_lsx_vpickve2gr_w">,
  Intrinsic<[llvm_i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickve2gr_d : GCCBuiltin<"__builtin_lsx_vpickve2gr_d">,
  Intrinsic<[llvm_i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vpickve2gr_bu : GCCBuiltin<"__builtin_lsx_vpickve2gr_bu">,
  Intrinsic<[llvm_i32_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickve2gr_hu : GCCBuiltin<"__builtin_lsx_vpickve2gr_hu">,
  Intrinsic<[llvm_i32_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickve2gr_wu : GCCBuiltin<"__builtin_lsx_vpickve2gr_wu">,
  Intrinsic<[llvm_i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickve2gr_du : GCCBuiltin<"__builtin_lsx_vpickve2gr_du">,
  Intrinsic<[llvm_i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vreplvei_b : GCCBuiltin<"__builtin_lsx_vreplvei_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vreplvei_h : GCCBuiltin<"__builtin_lsx_vreplvei_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vreplvei_w : GCCBuiltin<"__builtin_lsx_vreplvei_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vreplvei_d : GCCBuiltin<"__builtin_lsx_vreplvei_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmskltz_b : GCCBuiltin<"__builtin_lsx_vmskltz_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmskltz_h : GCCBuiltin<"__builtin_lsx_vmskltz_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmskltz_w : GCCBuiltin<"__builtin_lsx_vmskltz_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmskltz_d : GCCBuiltin<"__builtin_lsx_vmskltz_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfmadd_s : GCCBuiltin<"__builtin_lsx_vfmadd_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfmadd_d : GCCBuiltin<"__builtin_lsx_vfmadd_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfmsub_s : GCCBuiltin<"__builtin_lsx_vfmsub_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfmsub_d : GCCBuiltin<"__builtin_lsx_vfmsub_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfnmadd_s : GCCBuiltin<"__builtin_lsx_vfnmadd_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfnmadd_d : GCCBuiltin<"__builtin_lsx_vfnmadd_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfnmsub_s : GCCBuiltin<"__builtin_lsx_vfnmsub_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfnmsub_d : GCCBuiltin<"__builtin_lsx_vfnmsub_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_caf_s : GCCBuiltin<"__builtin_lsx_vfcmp_caf_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_caf_d : GCCBuiltin<"__builtin_lsx_vfcmp_caf_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_cor_s : GCCBuiltin<"__builtin_lsx_vfcmp_cor_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_cor_d : GCCBuiltin<"__builtin_lsx_vfcmp_cor_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_cun_s : GCCBuiltin<"__builtin_lsx_vfcmp_cun_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_cun_d : GCCBuiltin<"__builtin_lsx_vfcmp_cun_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_cune_s : GCCBuiltin<"__builtin_lsx_vfcmp_cune_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_cune_d : GCCBuiltin<"__builtin_lsx_vfcmp_cune_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_cueq_s : GCCBuiltin<"__builtin_lsx_vfcmp_cueq_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_cueq_d : GCCBuiltin<"__builtin_lsx_vfcmp_cueq_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_ceq_s : GCCBuiltin<"__builtin_lsx_vfcmp_ceq_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_ceq_d : GCCBuiltin<"__builtin_lsx_vfcmp_ceq_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_cne_s : GCCBuiltin<"__builtin_lsx_vfcmp_cne_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_cne_d : GCCBuiltin<"__builtin_lsx_vfcmp_cne_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_clt_s : GCCBuiltin<"__builtin_lsx_vfcmp_clt_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_clt_d : GCCBuiltin<"__builtin_lsx_vfcmp_clt_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_cult_s : GCCBuiltin<"__builtin_lsx_vfcmp_cult_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_cult_d : GCCBuiltin<"__builtin_lsx_vfcmp_cult_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_cle_s : GCCBuiltin<"__builtin_lsx_vfcmp_cle_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_cle_d : GCCBuiltin<"__builtin_lsx_vfcmp_cle_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_cule_s : GCCBuiltin<"__builtin_lsx_vfcmp_cule_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_cule_d : GCCBuiltin<"__builtin_lsx_vfcmp_cule_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_saf_s : GCCBuiltin<"__builtin_lsx_vfcmp_saf_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_saf_d : GCCBuiltin<"__builtin_lsx_vfcmp_saf_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_sor_s : GCCBuiltin<"__builtin_lsx_vfcmp_sor_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_sor_d : GCCBuiltin<"__builtin_lsx_vfcmp_sor_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_sun_s : GCCBuiltin<"__builtin_lsx_vfcmp_sun_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_sun_d : GCCBuiltin<"__builtin_lsx_vfcmp_sun_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_sune_s : GCCBuiltin<"__builtin_lsx_vfcmp_sune_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_sune_d : GCCBuiltin<"__builtin_lsx_vfcmp_sune_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_sueq_s : GCCBuiltin<"__builtin_lsx_vfcmp_sueq_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_sueq_d : GCCBuiltin<"__builtin_lsx_vfcmp_sueq_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_seq_s : GCCBuiltin<"__builtin_lsx_vfcmp_seq_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_seq_d : GCCBuiltin<"__builtin_lsx_vfcmp_seq_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_sne_s : GCCBuiltin<"__builtin_lsx_vfcmp_sne_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_sne_d : GCCBuiltin<"__builtin_lsx_vfcmp_sne_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_slt_s : GCCBuiltin<"__builtin_lsx_vfcmp_slt_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_slt_d : GCCBuiltin<"__builtin_lsx_vfcmp_slt_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_sult_s : GCCBuiltin<"__builtin_lsx_vfcmp_sult_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_sult_d : GCCBuiltin<"__builtin_lsx_vfcmp_sult_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_sle_s : GCCBuiltin<"__builtin_lsx_vfcmp_sle_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_sle_d : GCCBuiltin<"__builtin_lsx_vfcmp_sle_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcmp_sule_s : GCCBuiltin<"__builtin_lsx_vfcmp_sule_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcmp_sule_d : GCCBuiltin<"__builtin_lsx_vfcmp_sule_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vbitsel_v : GCCBuiltin<"__builtin_lsx_vbitsel_v">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_vshuf_b : GCCBuiltin<"__builtin_lsx_vshuf_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_vldrepl_b : GCCBuiltin<"__builtin_lsx_vldrepl_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_ptr_ty, llvm_i32_ty], [IntrReadMem, IntrArgMemOnly]>;
def int_loongarch_lsx_vldrepl_h : GCCBuiltin<"__builtin_lsx_vldrepl_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_ptr_ty, llvm_i32_ty], [IntrReadMem, IntrArgMemOnly]>;
def int_loongarch_lsx_vldrepl_w : GCCBuiltin<"__builtin_lsx_vldrepl_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_ptr_ty, llvm_i32_ty], [IntrReadMem, IntrArgMemOnly]>;
def int_loongarch_lsx_vldrepl_d : GCCBuiltin<"__builtin_lsx_vldrepl_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_ptr_ty, llvm_i32_ty], [IntrReadMem, IntrArgMemOnly]>;

def int_loongarch_lsx_vstelm_b : GCCBuiltin<"__builtin_lsx_vstelm_b">,
  Intrinsic<[], [llvm_v16i8_ty, llvm_ptr_ty, llvm_i32_ty, llvm_i32_ty], [IntrArgMemOnly]>;
def int_loongarch_lsx_vstelm_h : GCCBuiltin<"__builtin_lsx_vstelm_h">,
  Intrinsic<[], [llvm_v8i16_ty, llvm_ptr_ty, llvm_i32_ty, llvm_i32_ty], [IntrArgMemOnly]>;
def int_loongarch_lsx_vstelm_w : GCCBuiltin<"__builtin_lsx_vstelm_w">,
  Intrinsic<[], [llvm_v4i32_ty, llvm_ptr_ty, llvm_i32_ty, llvm_i32_ty], [IntrArgMemOnly]>;
def int_loongarch_lsx_vstelm_d : GCCBuiltin<"__builtin_lsx_vstelm_d">,
  Intrinsic<[], [llvm_v2i64_ty, llvm_ptr_ty, llvm_i32_ty, llvm_i32_ty], [IntrArgMemOnly]>;

def int_loongarch_lsx_vldx : GCCBuiltin<"__builtin_lsx_vldx">,
  Intrinsic<[llvm_v16i8_ty], [llvm_ptr_ty, llvm_i64_ty],
  [IntrReadMem, IntrArgMemOnly]>;

def int_loongarch_lsx_vstx : GCCBuiltin<"__builtin_lsx_vstx">,
  Intrinsic<[], [llvm_v16i8_ty, llvm_ptr_ty, llvm_i64_ty],
  [IntrArgMemOnly]>;

def int_loongarch_lsx_vaddwev_d_w : GCCBuiltin<"__builtin_lsx_vaddwev_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwev_w_h : GCCBuiltin<"__builtin_lsx_vaddwev_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwev_h_b : GCCBuiltin<"__builtin_lsx_vaddwev_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwev_q_d : GCCBuiltin<"__builtin_lsx_vaddwev_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsubwev_d_w : GCCBuiltin<"__builtin_lsx_vsubwev_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwev_w_h : GCCBuiltin<"__builtin_lsx_vsubwev_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwev_h_b : GCCBuiltin<"__builtin_lsx_vsubwev_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwev_q_d : GCCBuiltin<"__builtin_lsx_vsubwev_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;


def int_loongarch_lsx_vaddwod_d_w : GCCBuiltin<"__builtin_lsx_vaddwod_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwod_w_h : GCCBuiltin<"__builtin_lsx_vaddwod_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwod_h_b : GCCBuiltin<"__builtin_lsx_vaddwod_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwod_q_d : GCCBuiltin<"__builtin_lsx_vaddwod_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsubwod_d_w : GCCBuiltin<"__builtin_lsx_vsubwod_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwod_w_h : GCCBuiltin<"__builtin_lsx_vsubwod_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwod_h_b : GCCBuiltin<"__builtin_lsx_vsubwod_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwod_q_d : GCCBuiltin<"__builtin_lsx_vsubwod_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vaddwev_d_wu : GCCBuiltin<"__builtin_lsx_vaddwev_d_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwev_w_hu : GCCBuiltin<"__builtin_lsx_vaddwev_w_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwev_h_bu : GCCBuiltin<"__builtin_lsx_vaddwev_h_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwev_q_du : GCCBuiltin<"__builtin_lsx_vaddwev_q_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsubwev_d_wu : GCCBuiltin<"__builtin_lsx_vsubwev_d_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwev_w_hu : GCCBuiltin<"__builtin_lsx_vsubwev_w_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwev_h_bu : GCCBuiltin<"__builtin_lsx_vsubwev_h_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwev_q_du : GCCBuiltin<"__builtin_lsx_vsubwev_q_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vaddwod_d_wu : GCCBuiltin<"__builtin_lsx_vaddwod_d_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwod_w_hu : GCCBuiltin<"__builtin_lsx_vaddwod_w_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwod_h_bu : GCCBuiltin<"__builtin_lsx_vaddwod_h_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwod_q_du : GCCBuiltin<"__builtin_lsx_vaddwod_q_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsubwod_d_wu : GCCBuiltin<"__builtin_lsx_vsubwod_d_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwod_w_hu : GCCBuiltin<"__builtin_lsx_vsubwod_w_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwod_h_bu : GCCBuiltin<"__builtin_lsx_vsubwod_h_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubwod_q_du : GCCBuiltin<"__builtin_lsx_vsubwod_q_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vaddwev_d_wu_w : GCCBuiltin<"__builtin_lsx_vaddwev_d_wu_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwev_w_hu_h : GCCBuiltin<"__builtin_lsx_vaddwev_w_hu_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwev_h_bu_b : GCCBuiltin<"__builtin_lsx_vaddwev_h_bu_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwev_q_du_d : GCCBuiltin<"__builtin_lsx_vaddwev_q_du_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vaddwod_d_wu_w : GCCBuiltin<"__builtin_lsx_vaddwod_d_wu_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwod_w_hu_h : GCCBuiltin<"__builtin_lsx_vaddwod_w_hu_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwod_h_bu_b : GCCBuiltin<"__builtin_lsx_vaddwod_h_bu_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vaddwod_q_du_d : GCCBuiltin<"__builtin_lsx_vaddwod_q_du_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vhaddw_qu_du : GCCBuiltin<"__builtin_lsx_vhaddw_qu_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;
def int_loongarch_lsx_vhsubw_qu_du : GCCBuiltin<"__builtin_lsx_vhsubw_qu_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vhaddw_q_d : GCCBuiltin<"__builtin_lsx_vhaddw_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;
def int_loongarch_lsx_vhsubw_q_d : GCCBuiltin<"__builtin_lsx_vhsubw_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmuh_b : GCCBuiltin<"__builtin_lsx_vmuh_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmuh_h : GCCBuiltin<"__builtin_lsx_vmuh_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmuh_w : GCCBuiltin<"__builtin_lsx_vmuh_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmuh_d : GCCBuiltin<"__builtin_lsx_vmuh_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmuh_bu : GCCBuiltin<"__builtin_lsx_vmuh_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmuh_hu : GCCBuiltin<"__builtin_lsx_vmuh_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmuh_wu : GCCBuiltin<"__builtin_lsx_vmuh_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmuh_du : GCCBuiltin<"__builtin_lsx_vmuh_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmulwev_d_w : GCCBuiltin<"__builtin_lsx_vmulwev_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwev_w_h : GCCBuiltin<"__builtin_lsx_vmulwev_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwev_h_b : GCCBuiltin<"__builtin_lsx_vmulwev_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwev_q_d : GCCBuiltin<"__builtin_lsx_vmulwev_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmulwod_d_w : GCCBuiltin<"__builtin_lsx_vmulwod_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwod_w_h : GCCBuiltin<"__builtin_lsx_vmulwod_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwod_h_b : GCCBuiltin<"__builtin_lsx_vmulwod_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwod_q_d : GCCBuiltin<"__builtin_lsx_vmulwod_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmulwev_d_wu : GCCBuiltin<"__builtin_lsx_vmulwev_d_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwev_w_hu : GCCBuiltin<"__builtin_lsx_vmulwev_w_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwev_h_bu : GCCBuiltin<"__builtin_lsx_vmulwev_h_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwev_q_du : GCCBuiltin<"__builtin_lsx_vmulwev_q_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmulwod_d_wu : GCCBuiltin<"__builtin_lsx_vmulwod_d_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwod_w_hu : GCCBuiltin<"__builtin_lsx_vmulwod_w_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwod_h_bu : GCCBuiltin<"__builtin_lsx_vmulwod_h_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwod_q_du : GCCBuiltin<"__builtin_lsx_vmulwod_q_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmulwev_d_wu_w : GCCBuiltin<"__builtin_lsx_vmulwev_d_wu_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwev_w_hu_h : GCCBuiltin<"__builtin_lsx_vmulwev_w_hu_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwev_h_bu_b : GCCBuiltin<"__builtin_lsx_vmulwev_h_bu_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwev_q_du_d : GCCBuiltin<"__builtin_lsx_vmulwev_q_du_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmulwod_d_wu_w : GCCBuiltin<"__builtin_lsx_vmulwod_d_wu_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwod_w_hu_h : GCCBuiltin<"__builtin_lsx_vmulwod_w_hu_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwod_h_bu_b : GCCBuiltin<"__builtin_lsx_vmulwod_h_bu_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmulwod_q_du_d : GCCBuiltin<"__builtin_lsx_vmulwod_q_du_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmaddwev_d_w : GCCBuiltin<"__builtin_lsx_vmaddwev_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwev_w_h : GCCBuiltin<"__builtin_lsx_vmaddwev_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwev_h_b : GCCBuiltin<"__builtin_lsx_vmaddwev_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwev_q_d : GCCBuiltin<"__builtin_lsx_vmaddwev_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmaddwod_d_w : GCCBuiltin<"__builtin_lsx_vmaddwod_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwod_w_h : GCCBuiltin<"__builtin_lsx_vmaddwod_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwod_h_b : GCCBuiltin<"__builtin_lsx_vmaddwod_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwod_q_d : GCCBuiltin<"__builtin_lsx_vmaddwod_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmaddwev_d_wu : GCCBuiltin<"__builtin_lsx_vmaddwev_d_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwev_w_hu : GCCBuiltin<"__builtin_lsx_vmaddwev_w_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwev_h_bu : GCCBuiltin<"__builtin_lsx_vmaddwev_h_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwev_q_du : GCCBuiltin<"__builtin_lsx_vmaddwev_q_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmaddwod_d_wu : GCCBuiltin<"__builtin_lsx_vmaddwod_d_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwod_w_hu : GCCBuiltin<"__builtin_lsx_vmaddwod_w_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwod_h_bu : GCCBuiltin<"__builtin_lsx_vmaddwod_h_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwod_q_du : GCCBuiltin<"__builtin_lsx_vmaddwod_q_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmaddwev_d_wu_w : GCCBuiltin<"__builtin_lsx_vmaddwev_d_wu_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwev_w_hu_h : GCCBuiltin<"__builtin_lsx_vmaddwev_w_hu_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwev_h_bu_b : GCCBuiltin<"__builtin_lsx_vmaddwev_h_bu_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwev_q_du_d : GCCBuiltin<"__builtin_lsx_vmaddwev_q_du_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmaddwod_d_wu_w : GCCBuiltin<"__builtin_lsx_vmaddwod_d_wu_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwod_w_hu_h : GCCBuiltin<"__builtin_lsx_vmaddwod_w_hu_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwod_h_bu_b : GCCBuiltin<"__builtin_lsx_vmaddwod_h_bu_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaddwod_q_du_d : GCCBuiltin<"__builtin_lsx_vmaddwod_q_du_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrln_b_h : GCCBuiltin<"__builtin_lsx_vsrln_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrln_h_w : GCCBuiltin<"__builtin_lsx_vsrln_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrln_w_d : GCCBuiltin<"__builtin_lsx_vsrln_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsran_b_h : GCCBuiltin<"__builtin_lsx_vsran_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsran_h_w : GCCBuiltin<"__builtin_lsx_vsran_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsran_w_d : GCCBuiltin<"__builtin_lsx_vsran_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrlrn_b_h : GCCBuiltin<"__builtin_lsx_vsrlrn_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlrn_h_w : GCCBuiltin<"__builtin_lsx_vsrlrn_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlrn_w_d : GCCBuiltin<"__builtin_lsx_vsrlrn_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrarn_b_h : GCCBuiltin<"__builtin_lsx_vsrarn_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrarn_h_w : GCCBuiltin<"__builtin_lsx_vsrarn_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrarn_w_d : GCCBuiltin<"__builtin_lsx_vsrarn_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrln_b_h : GCCBuiltin<"__builtin_lsx_vssrln_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrln_h_w : GCCBuiltin<"__builtin_lsx_vssrln_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrln_w_d : GCCBuiltin<"__builtin_lsx_vssrln_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssran_b_h : GCCBuiltin<"__builtin_lsx_vssran_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssran_h_w : GCCBuiltin<"__builtin_lsx_vssran_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssran_w_d : GCCBuiltin<"__builtin_lsx_vssran_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrlrn_b_h : GCCBuiltin<"__builtin_lsx_vssrlrn_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlrn_h_w : GCCBuiltin<"__builtin_lsx_vssrlrn_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlrn_w_d : GCCBuiltin<"__builtin_lsx_vssrlrn_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrarn_b_h : GCCBuiltin<"__builtin_lsx_vssrarn_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrarn_h_w : GCCBuiltin<"__builtin_lsx_vssrarn_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrarn_w_d : GCCBuiltin<"__builtin_lsx_vssrarn_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrln_bu_h : GCCBuiltin<"__builtin_lsx_vssrln_bu_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrln_hu_w : GCCBuiltin<"__builtin_lsx_vssrln_hu_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrln_wu_d : GCCBuiltin<"__builtin_lsx_vssrln_wu_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssran_bu_h : GCCBuiltin<"__builtin_lsx_vssran_bu_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssran_hu_w : GCCBuiltin<"__builtin_lsx_vssran_hu_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssran_wu_d : GCCBuiltin<"__builtin_lsx_vssran_wu_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrlrn_bu_h : GCCBuiltin<"__builtin_lsx_vssrlrn_bu_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlrn_hu_w : GCCBuiltin<"__builtin_lsx_vssrlrn_hu_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlrn_wu_d : GCCBuiltin<"__builtin_lsx_vssrlrn_wu_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrarn_bu_h : GCCBuiltin<"__builtin_lsx_vssrarn_bu_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrarn_hu_w : GCCBuiltin<"__builtin_lsx_vssrarn_hu_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrarn_wu_d : GCCBuiltin<"__builtin_lsx_vssrarn_wu_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vandn_v : GCCBuiltin<"__builtin_lsx_vandn_v">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_vorn_v : GCCBuiltin<"__builtin_lsx_vorn_v">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfrstp_b : GCCBuiltin<"__builtin_lsx_vfrstp_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_v16i8_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vfrstp_h : GCCBuiltin<"__builtin_lsx_vfrstp_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_v8i16_ty],
  [IntrNoMem]>;

def int_loongarch_lsx_vadd_q : GCCBuiltin<"__builtin_lsx_vadd_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsub_q : GCCBuiltin<"__builtin_lsx_vsub_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsigncov_b : GCCBuiltin<"__builtin_lsx_vsigncov_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vsigncov_h : GCCBuiltin<"__builtin_lsx_vsigncov_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vsigncov_w : GCCBuiltin<"__builtin_lsx_vsigncov_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vsigncov_d : GCCBuiltin<"__builtin_lsx_vsigncov_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty],
  [IntrNoMem]>;

def int_loongarch_lsx_vfcvt_h_s : GCCBuiltin<"__builtin_lsx_vfcvt_h_s">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcvt_s_d : GCCBuiltin<"__builtin_lsx_vfcvt_s_d">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vffint_s_l : GCCBuiltin<"__builtin_lsx_vffint_s_l">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftint_w_d : GCCBuiltin<"__builtin_lsx_vftint_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftintrz_w_d : GCCBuiltin<"__builtin_lsx_vftintrz_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrp_w_d : GCCBuiltin<"__builtin_lsx_vftintrp_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrm_w_d : GCCBuiltin<"__builtin_lsx_vftintrm_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrne_w_d : GCCBuiltin<"__builtin_lsx_vftintrne_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vbsrl_v : GCCBuiltin<"__builtin_lsx_vbsrl_v">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbsll_v : GCCBuiltin<"__builtin_lsx_vbsll_v">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfrstpi_b : GCCBuiltin<"__builtin_lsx_vfrstpi_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfrstpi_h : GCCBuiltin<"__builtin_lsx_vfrstpi_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vneg_b : GCCBuiltin<"__builtin_lsx_vneg_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vneg_h : GCCBuiltin<"__builtin_lsx_vneg_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vneg_w : GCCBuiltin<"__builtin_lsx_vneg_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vneg_d : GCCBuiltin<"__builtin_lsx_vneg_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmskgez_b : GCCBuiltin<"__builtin_lsx_vmskgez_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmsknz_b : GCCBuiltin<"__builtin_lsx_vmsknz_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfrintrm_s : GCCBuiltin<"__builtin_lsx_vfrintrm_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfrintrm_d : GCCBuiltin<"__builtin_lsx_vfrintrm_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfrintrp_s : GCCBuiltin<"__builtin_lsx_vfrintrp_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfrintrp_d : GCCBuiltin<"__builtin_lsx_vfrintrp_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfrintrz_s : GCCBuiltin<"__builtin_lsx_vfrintrz_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfrintrz_d : GCCBuiltin<"__builtin_lsx_vfrintrz_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfrintrne_s : GCCBuiltin<"__builtin_lsx_vfrintrne_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfrintrne_d : GCCBuiltin<"__builtin_lsx_vfrintrne_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vffinth_d_w : GCCBuiltin<"__builtin_lsx_vffinth_d_w">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vffintl_d_w : GCCBuiltin<"__builtin_lsx_vffintl_d_w">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v4i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftintrm_w_s : GCCBuiltin<"__builtin_lsx_vftintrm_w_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrm_l_d : GCCBuiltin<"__builtin_lsx_vftintrm_l_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftintrp_w_s : GCCBuiltin<"__builtin_lsx_vftintrp_w_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrp_l_d : GCCBuiltin<"__builtin_lsx_vftintrp_l_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftintrz_w_s : GCCBuiltin<"__builtin_lsx_vftintrz_w_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrz_l_d : GCCBuiltin<"__builtin_lsx_vftintrz_l_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftintrne_w_s : GCCBuiltin<"__builtin_lsx_vftintrne_w_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrne_l_d : GCCBuiltin<"__builtin_lsx_vftintrne_l_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftinth_l_s : GCCBuiltin<"__builtin_lsx_vftinth_l_s">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintl_l_s : GCCBuiltin<"__builtin_lsx_vftintl_l_s">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4f32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftintrmh_l_s : GCCBuiltin<"__builtin_lsx_vftintrmh_l_s">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrml_l_s : GCCBuiltin<"__builtin_lsx_vftintrml_l_s">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4f32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftintrph_l_s : GCCBuiltin<"__builtin_lsx_vftintrph_l_s">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrpl_l_s : GCCBuiltin<"__builtin_lsx_vftintrpl_l_s">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4f32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftintrzh_l_s : GCCBuiltin<"__builtin_lsx_vftintrzh_l_s">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrzl_l_s : GCCBuiltin<"__builtin_lsx_vftintrzl_l_s">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4f32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftintrneh_l_s : GCCBuiltin<"__builtin_lsx_vftintrneh_l_s">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrnel_l_s : GCCBuiltin<"__builtin_lsx_vftintrnel_l_s">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4f32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vexth_d_w : GCCBuiltin<"__builtin_lsx_vexth_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vexth_w_h : GCCBuiltin<"__builtin_lsx_vexth_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vexth_h_b : GCCBuiltin<"__builtin_lsx_vexth_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vexth_q_d : GCCBuiltin<"__builtin_lsx_vexth_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vexth_du_wu : GCCBuiltin<"__builtin_lsx_vexth_du_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vexth_wu_hu : GCCBuiltin<"__builtin_lsx_vexth_wu_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vexth_hu_bu : GCCBuiltin<"__builtin_lsx_vexth_hu_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vexth_qu_du : GCCBuiltin<"__builtin_lsx_vexth_qu_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvexth_du_wu : GCCBuiltin<"__builtin_lasx_xvexth_du_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvexth_wu_hu : GCCBuiltin<"__builtin_lasx_xvexth_wu_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvexth_hu_bu : GCCBuiltin<"__builtin_lasx_xvexth_hu_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvexth_qu_du : GCCBuiltin<"__builtin_lasx_xvexth_qu_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsllwil_d_w : GCCBuiltin<"__builtin_lsx_vsllwil_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsllwil_w_h : GCCBuiltin<"__builtin_lsx_vsllwil_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsllwil_h_b : GCCBuiltin<"__builtin_lsx_vsllwil_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vextl_q_d : GCCBuiltin<"__builtin_lsx_vextl_q_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsllwil_du_wu : GCCBuiltin<"__builtin_lsx_vsllwil_du_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsllwil_wu_hu : GCCBuiltin<"__builtin_lsx_vsllwil_wu_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsllwil_hu_bu : GCCBuiltin<"__builtin_lsx_vsllwil_hu_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vextl_qu_du : GCCBuiltin<"__builtin_lsx_vextl_qu_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vbitclri_b : GCCBuiltin<"__builtin_lsx_vbitclri_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitclri_h : GCCBuiltin<"__builtin_lsx_vbitclri_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitclri_w : GCCBuiltin<"__builtin_lsx_vbitclri_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitclri_d : GCCBuiltin<"__builtin_lsx_vbitclri_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vbitseti_b : GCCBuiltin<"__builtin_lsx_vbitseti_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitseti_h : GCCBuiltin<"__builtin_lsx_vbitseti_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitseti_w : GCCBuiltin<"__builtin_lsx_vbitseti_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitseti_d : GCCBuiltin<"__builtin_lsx_vbitseti_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vbitrevi_b : GCCBuiltin<"__builtin_lsx_vbitrevi_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitrevi_h : GCCBuiltin<"__builtin_lsx_vbitrevi_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitrevi_w : GCCBuiltin<"__builtin_lsx_vbitrevi_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitrevi_d : GCCBuiltin<"__builtin_lsx_vbitrevi_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrlrni_b_h : GCCBuiltin<"__builtin_lsx_vssrlrni_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlrni_h_w : GCCBuiltin<"__builtin_lsx_vssrlrni_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlrni_w_d : GCCBuiltin<"__builtin_lsx_vssrlrni_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlrni_d_q : GCCBuiltin<"__builtin_lsx_vssrlrni_d_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrani_b_h : GCCBuiltin<"__builtin_lsx_vsrani_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrani_h_w : GCCBuiltin<"__builtin_lsx_vsrani_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrani_w_d : GCCBuiltin<"__builtin_lsx_vsrani_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrani_d_q : GCCBuiltin<"__builtin_lsx_vsrani_d_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vextrins_b : GCCBuiltin<"__builtin_lsx_vextrins_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vextrins_h : GCCBuiltin<"__builtin_lsx_vextrins_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vextrins_w : GCCBuiltin<"__builtin_lsx_vextrins_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vextrins_d : GCCBuiltin<"__builtin_lsx_vextrins_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vbitseli_b : GCCBuiltin<"__builtin_lsx_vbitseli_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vandi_b : GCCBuiltin<"__builtin_lsx_vandi_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vori_b : GCCBuiltin<"__builtin_lsx_vori_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vxori_b : GCCBuiltin<"__builtin_lsx_vxori_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vnori_b : GCCBuiltin<"__builtin_lsx_vnori_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vldi : GCCBuiltin<"__builtin_lsx_vldi">,
  Intrinsic<[llvm_v2i64_ty], [llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vrepli_b : GCCBuiltin<"__builtin_lsx_vrepli_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vrepli_h : GCCBuiltin<"__builtin_lsx_vrepli_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vrepli_w : GCCBuiltin<"__builtin_lsx_vrepli_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vrepli_d : GCCBuiltin<"__builtin_lsx_vrepli_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vpermi_w : GCCBuiltin<"__builtin_lsx_vpermi_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsadd_b : GCCBuiltin<"__builtin_lsx_vsadd_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vsadd_h : GCCBuiltin<"__builtin_lsx_vsadd_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vsadd_w : GCCBuiltin<"__builtin_lsx_vsadd_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vsadd_d : GCCBuiltin<"__builtin_lsx_vsadd_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lsx_vssub_b : GCCBuiltin<"__builtin_lsx_vssub_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssub_h : GCCBuiltin<"__builtin_lsx_vssub_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssub_w : GCCBuiltin<"__builtin_lsx_vssub_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssub_d : GCCBuiltin<"__builtin_lsx_vssub_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsadd_bu : GCCBuiltin<"__builtin_lsx_vsadd_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vsadd_hu : GCCBuiltin<"__builtin_lsx_vsadd_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vsadd_wu : GCCBuiltin<"__builtin_lsx_vsadd_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vsadd_du : GCCBuiltin<"__builtin_lsx_vsadd_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lsx_vssub_bu : GCCBuiltin<"__builtin_lsx_vssub_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssub_hu : GCCBuiltin<"__builtin_lsx_vssub_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssub_wu : GCCBuiltin<"__builtin_lsx_vssub_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssub_du : GCCBuiltin<"__builtin_lsx_vssub_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vhaddw_h_b : GCCBuiltin<"__builtin_lsx_vhaddw_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vhaddw_w_h : GCCBuiltin<"__builtin_lsx_vhaddw_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vhaddw_d_w : GCCBuiltin<"__builtin_lsx_vhaddw_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vhsubw_h_b : GCCBuiltin<"__builtin_lsx_vhsubw_h_b">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vhsubw_w_h : GCCBuiltin<"__builtin_lsx_vhsubw_w_h">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vhsubw_d_w : GCCBuiltin<"__builtin_lsx_vhsubw_d_w">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vhaddw_hu_bu : GCCBuiltin<"__builtin_lsx_vhaddw_hu_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vhaddw_wu_hu : GCCBuiltin<"__builtin_lsx_vhaddw_wu_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vhaddw_du_wu : GCCBuiltin<"__builtin_lsx_vhaddw_du_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vhsubw_hu_bu : GCCBuiltin<"__builtin_lsx_vhsubw_hu_bu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vhsubw_wu_hu : GCCBuiltin<"__builtin_lsx_vhsubw_wu_hu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vhsubw_du_wu : GCCBuiltin<"__builtin_lsx_vhsubw_du_wu">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vadda_b : GCCBuiltin<"__builtin_lsx_vadda_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vadda_h : GCCBuiltin<"__builtin_lsx_vadda_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vadda_w : GCCBuiltin<"__builtin_lsx_vadda_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vadda_d : GCCBuiltin<"__builtin_lsx_vadda_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lsx_vabsd_b : GCCBuiltin<"__builtin_lsx_vabsd_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vabsd_h : GCCBuiltin<"__builtin_lsx_vabsd_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vabsd_w : GCCBuiltin<"__builtin_lsx_vabsd_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vabsd_d : GCCBuiltin<"__builtin_lsx_vabsd_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vabsd_bu : GCCBuiltin<"__builtin_lsx_vabsd_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vabsd_hu : GCCBuiltin<"__builtin_lsx_vabsd_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vabsd_wu : GCCBuiltin<"__builtin_lsx_vabsd_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vabsd_du : GCCBuiltin<"__builtin_lsx_vabsd_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vavg_b : GCCBuiltin<"__builtin_lsx_vavg_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavg_h : GCCBuiltin<"__builtin_lsx_vavg_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavg_w : GCCBuiltin<"__builtin_lsx_vavg_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavg_d : GCCBuiltin<"__builtin_lsx_vavg_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lsx_vavg_bu : GCCBuiltin<"__builtin_lsx_vavg_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavg_hu : GCCBuiltin<"__builtin_lsx_vavg_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavg_wu : GCCBuiltin<"__builtin_lsx_vavg_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavg_du : GCCBuiltin<"__builtin_lsx_vavg_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lsx_vavgr_b : GCCBuiltin<"__builtin_lsx_vavgr_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavgr_h : GCCBuiltin<"__builtin_lsx_vavgr_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavgr_w : GCCBuiltin<"__builtin_lsx_vavgr_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavgr_d : GCCBuiltin<"__builtin_lsx_vavgr_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lsx_vavgr_bu : GCCBuiltin<"__builtin_lsx_vavgr_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavgr_hu : GCCBuiltin<"__builtin_lsx_vavgr_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavgr_wu : GCCBuiltin<"__builtin_lsx_vavgr_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vavgr_du : GCCBuiltin<"__builtin_lsx_vavgr_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lsx_vsrlr_b : GCCBuiltin<"__builtin_lsx_vsrlr_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlr_h : GCCBuiltin<"__builtin_lsx_vsrlr_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlr_w : GCCBuiltin<"__builtin_lsx_vsrlr_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlr_d : GCCBuiltin<"__builtin_lsx_vsrlr_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrar_b : GCCBuiltin<"__builtin_lsx_vsrar_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrar_h : GCCBuiltin<"__builtin_lsx_vsrar_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrar_w : GCCBuiltin<"__builtin_lsx_vsrar_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrar_d : GCCBuiltin<"__builtin_lsx_vsrar_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfmax_s : GCCBuiltin<"__builtin_lsx_vfmax_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfmax_d : GCCBuiltin<"__builtin_lsx_vfmax_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfmin_s : GCCBuiltin<"__builtin_lsx_vfmin_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfmin_d : GCCBuiltin<"__builtin_lsx_vfmin_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfmaxa_s : GCCBuiltin<"__builtin_lsx_vfmaxa_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfmaxa_d : GCCBuiltin<"__builtin_lsx_vfmaxa_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfmina_s : GCCBuiltin<"__builtin_lsx_vfmina_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfmina_d : GCCBuiltin<"__builtin_lsx_vfmina_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfclass_s : GCCBuiltin<"__builtin_lsx_vfclass_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfclass_d : GCCBuiltin<"__builtin_lsx_vfclass_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfrecip_s : GCCBuiltin<"__builtin_lsx_vfrecip_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfrecip_d : GCCBuiltin<"__builtin_lsx_vfrecip_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfrsqrt_s : GCCBuiltin<"__builtin_lsx_vfrsqrt_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfrsqrt_d : GCCBuiltin<"__builtin_lsx_vfrsqrt_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcvtl_s_h : GCCBuiltin<"__builtin_lsx_vfcvtl_s_h">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcvtl_d_s : GCCBuiltin<"__builtin_lsx_vfcvtl_d_s">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v4f32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfcvth_s_h : GCCBuiltin<"__builtin_lsx_vfcvth_s_h">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfcvth_d_s : GCCBuiltin<"__builtin_lsx_vfcvth_d_s">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v4f32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftint_w_s : GCCBuiltin<"__builtin_lsx_vftint_w_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftint_l_d : GCCBuiltin<"__builtin_lsx_vftint_l_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftint_wu_s : GCCBuiltin<"__builtin_lsx_vftint_wu_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftint_lu_d : GCCBuiltin<"__builtin_lsx_vftint_lu_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrlri_b : GCCBuiltin<"__builtin_lsx_vsrlri_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlri_h : GCCBuiltin<"__builtin_lsx_vsrlri_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlri_w : GCCBuiltin<"__builtin_lsx_vsrlri_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlri_d : GCCBuiltin<"__builtin_lsx_vsrlri_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrari_b : GCCBuiltin<"__builtin_lsx_vsrari_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrari_h : GCCBuiltin<"__builtin_lsx_vsrari_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrari_w : GCCBuiltin<"__builtin_lsx_vsrari_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrari_d : GCCBuiltin<"__builtin_lsx_vsrari_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsat_b : GCCBuiltin<"__builtin_lsx_vsat_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsat_h : GCCBuiltin<"__builtin_lsx_vsat_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsat_w : GCCBuiltin<"__builtin_lsx_vsat_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsat_d : GCCBuiltin<"__builtin_lsx_vsat_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsat_bu : GCCBuiltin<"__builtin_lsx_vsat_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsat_hu : GCCBuiltin<"__builtin_lsx_vsat_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsat_wu : GCCBuiltin<"__builtin_lsx_vsat_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsat_du : GCCBuiltin<"__builtin_lsx_vsat_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrlni_b_h : GCCBuiltin<"__builtin_lsx_vsrlni_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlni_h_w : GCCBuiltin<"__builtin_lsx_vsrlni_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlni_w_d : GCCBuiltin<"__builtin_lsx_vsrlni_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlni_d_q : GCCBuiltin<"__builtin_lsx_vsrlni_d_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrlrni_b_h : GCCBuiltin<"__builtin_lsx_vsrlrni_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlrni_h_w : GCCBuiltin<"__builtin_lsx_vsrlrni_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlrni_w_d : GCCBuiltin<"__builtin_lsx_vsrlrni_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrlrni_d_q : GCCBuiltin<"__builtin_lsx_vsrlrni_d_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrlni_b_h : GCCBuiltin<"__builtin_lsx_vssrlni_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlni_h_w : GCCBuiltin<"__builtin_lsx_vssrlni_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlni_w_d : GCCBuiltin<"__builtin_lsx_vssrlni_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlni_d_q : GCCBuiltin<"__builtin_lsx_vssrlni_d_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrlrni_bu_h : GCCBuiltin<"__builtin_lsx_vssrlrni_bu_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlrni_hu_w : GCCBuiltin<"__builtin_lsx_vssrlrni_hu_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlrni_wu_d : GCCBuiltin<"__builtin_lsx_vssrlrni_wu_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlrni_du_q : GCCBuiltin<"__builtin_lsx_vssrlrni_du_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrarni_b_h : GCCBuiltin<"__builtin_lsx_vsrarni_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrarni_h_w : GCCBuiltin<"__builtin_lsx_vsrarni_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrarni_w_d : GCCBuiltin<"__builtin_lsx_vsrarni_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrarni_d_q : GCCBuiltin<"__builtin_lsx_vsrarni_d_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrani_b_h : GCCBuiltin<"__builtin_lsx_vssrani_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrani_h_w : GCCBuiltin<"__builtin_lsx_vssrani_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrani_w_d : GCCBuiltin<"__builtin_lsx_vssrani_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrani_d_q : GCCBuiltin<"__builtin_lsx_vssrani_d_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrani_bu_h : GCCBuiltin<"__builtin_lsx_vssrani_bu_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrani_hu_w : GCCBuiltin<"__builtin_lsx_vssrani_hu_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrani_wu_d : GCCBuiltin<"__builtin_lsx_vssrani_wu_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrani_du_q : GCCBuiltin<"__builtin_lsx_vssrani_du_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrarni_b_h : GCCBuiltin<"__builtin_lsx_vssrarni_b_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrarni_h_w : GCCBuiltin<"__builtin_lsx_vssrarni_h_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrarni_w_d : GCCBuiltin<"__builtin_lsx_vssrarni_w_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrarni_d_q : GCCBuiltin<"__builtin_lsx_vssrarni_d_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrarni_bu_h : GCCBuiltin<"__builtin_lsx_vssrarni_bu_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrarni_hu_w : GCCBuiltin<"__builtin_lsx_vssrarni_hu_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrarni_wu_d : GCCBuiltin<"__builtin_lsx_vssrarni_wu_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrarni_du_q : GCCBuiltin<"__builtin_lsx_vssrarni_du_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vssrlni_bu_h : GCCBuiltin<"__builtin_lsx_vssrlni_bu_h">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlni_hu_w : GCCBuiltin<"__builtin_lsx_vssrlni_hu_w">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlni_wu_d : GCCBuiltin<"__builtin_lsx_vssrlni_wu_d">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vssrlni_du_q : GCCBuiltin<"__builtin_lsx_vssrlni_du_q">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vseq_b : GCCBuiltin<"__builtin_lsx_vseq_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vseq_h : GCCBuiltin<"__builtin_lsx_vseq_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vseq_w : GCCBuiltin<"__builtin_lsx_vseq_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vseq_d : GCCBuiltin<"__builtin_lsx_vseq_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsle_b : GCCBuiltin<"__builtin_lsx_vsle_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsle_h : GCCBuiltin<"__builtin_lsx_vsle_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsle_w : GCCBuiltin<"__builtin_lsx_vsle_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsle_d : GCCBuiltin<"__builtin_lsx_vsle_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsle_bu : GCCBuiltin<"__builtin_lsx_vsle_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsle_hu : GCCBuiltin<"__builtin_lsx_vsle_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsle_wu : GCCBuiltin<"__builtin_lsx_vsle_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsle_du : GCCBuiltin<"__builtin_lsx_vsle_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vslt_b : GCCBuiltin<"__builtin_lsx_vslt_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslt_h : GCCBuiltin<"__builtin_lsx_vslt_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslt_w : GCCBuiltin<"__builtin_lsx_vslt_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslt_d : GCCBuiltin<"__builtin_lsx_vslt_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vslt_bu : GCCBuiltin<"__builtin_lsx_vslt_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslt_hu : GCCBuiltin<"__builtin_lsx_vslt_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslt_wu : GCCBuiltin<"__builtin_lsx_vslt_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslt_du : GCCBuiltin<"__builtin_lsx_vslt_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vadd_b : GCCBuiltin<"__builtin_lsx_vadd_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vadd_h : GCCBuiltin<"__builtin_lsx_vadd_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vadd_w : GCCBuiltin<"__builtin_lsx_vadd_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vadd_d : GCCBuiltin<"__builtin_lsx_vadd_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lsx_vsub_b : GCCBuiltin<"__builtin_lsx_vsub_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsub_h : GCCBuiltin<"__builtin_lsx_vsub_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsub_w : GCCBuiltin<"__builtin_lsx_vsub_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsub_d : GCCBuiltin<"__builtin_lsx_vsub_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmax_b : GCCBuiltin<"__builtin_lsx_vmax_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmax_h : GCCBuiltin<"__builtin_lsx_vmax_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmax_w : GCCBuiltin<"__builtin_lsx_vmax_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmax_d : GCCBuiltin<"__builtin_lsx_vmax_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmin_b : GCCBuiltin<"__builtin_lsx_vmin_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmin_h : GCCBuiltin<"__builtin_lsx_vmin_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmin_w : GCCBuiltin<"__builtin_lsx_vmin_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmin_d : GCCBuiltin<"__builtin_lsx_vmin_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmax_bu : GCCBuiltin<"__builtin_lsx_vmax_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmax_hu : GCCBuiltin<"__builtin_lsx_vmax_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmax_wu : GCCBuiltin<"__builtin_lsx_vmax_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmax_du : GCCBuiltin<"__builtin_lsx_vmax_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmin_bu : GCCBuiltin<"__builtin_lsx_vmin_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmin_hu : GCCBuiltin<"__builtin_lsx_vmin_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmin_wu : GCCBuiltin<"__builtin_lsx_vmin_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmin_du : GCCBuiltin<"__builtin_lsx_vmin_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmul_b : GCCBuiltin<"__builtin_lsx_vmul_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmul_h : GCCBuiltin<"__builtin_lsx_vmul_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmul_w : GCCBuiltin<"__builtin_lsx_vmul_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmul_d : GCCBuiltin<"__builtin_lsx_vmul_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmadd_b : GCCBuiltin<"__builtin_lsx_vmadd_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_v16i8_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vmadd_h : GCCBuiltin<"__builtin_lsx_vmadd_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_v8i16_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vmadd_w : GCCBuiltin<"__builtin_lsx_vmadd_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_v4i32_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vmadd_d : GCCBuiltin<"__builtin_lsx_vmadd_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_v2i64_ty],
  [IntrNoMem]>;

def int_loongarch_lsx_vmsub_b : GCCBuiltin<"__builtin_lsx_vmsub_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty, llvm_v16i8_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vmsub_h : GCCBuiltin<"__builtin_lsx_vmsub_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_v8i16_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vmsub_w : GCCBuiltin<"__builtin_lsx_vmsub_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_v4i32_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vmsub_d : GCCBuiltin<"__builtin_lsx_vmsub_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_v2i64_ty],
  [IntrNoMem]>;

def int_loongarch_lsx_vdiv_b : GCCBuiltin<"__builtin_lsx_vdiv_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vdiv_h : GCCBuiltin<"__builtin_lsx_vdiv_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vdiv_w : GCCBuiltin<"__builtin_lsx_vdiv_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vdiv_d : GCCBuiltin<"__builtin_lsx_vdiv_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmod_b : GCCBuiltin<"__builtin_lsx_vmod_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmod_h : GCCBuiltin<"__builtin_lsx_vmod_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmod_w : GCCBuiltin<"__builtin_lsx_vmod_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmod_d : GCCBuiltin<"__builtin_lsx_vmod_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vdiv_bu : GCCBuiltin<"__builtin_lsx_vdiv_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vdiv_hu : GCCBuiltin<"__builtin_lsx_vdiv_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vdiv_wu : GCCBuiltin<"__builtin_lsx_vdiv_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vdiv_du : GCCBuiltin<"__builtin_lsx_vdiv_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsll_b : GCCBuiltin<"__builtin_lsx_vsll_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsll_h : GCCBuiltin<"__builtin_lsx_vsll_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsll_w : GCCBuiltin<"__builtin_lsx_vsll_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsll_d : GCCBuiltin<"__builtin_lsx_vsll_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrl_b : GCCBuiltin<"__builtin_lsx_vsrl_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrl_h : GCCBuiltin<"__builtin_lsx_vsrl_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrl_w : GCCBuiltin<"__builtin_lsx_vsrl_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrl_d : GCCBuiltin<"__builtin_lsx_vsrl_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vbitclr_b : GCCBuiltin<"__builtin_lsx_vbitclr_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitclr_h : GCCBuiltin<"__builtin_lsx_vbitclr_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitclr_w : GCCBuiltin<"__builtin_lsx_vbitclr_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitclr_d : GCCBuiltin<"__builtin_lsx_vbitclr_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vbitset_b : GCCBuiltin<"__builtin_lsx_vbitset_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitset_h : GCCBuiltin<"__builtin_lsx_vbitset_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitset_w : GCCBuiltin<"__builtin_lsx_vbitset_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitset_d : GCCBuiltin<"__builtin_lsx_vbitset_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vpackev_b : GCCBuiltin<"__builtin_lsx_vpackev_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpackev_h : GCCBuiltin<"__builtin_lsx_vpackev_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpackev_w : GCCBuiltin<"__builtin_lsx_vpackev_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpackev_d : GCCBuiltin<"__builtin_lsx_vpackev_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vpackod_b : GCCBuiltin<"__builtin_lsx_vpackod_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpackod_h : GCCBuiltin<"__builtin_lsx_vpackod_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpackod_w : GCCBuiltin<"__builtin_lsx_vpackod_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpackod_d : GCCBuiltin<"__builtin_lsx_vpackod_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vilvl_b : GCCBuiltin<"__builtin_lsx_vilvl_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vilvl_h : GCCBuiltin<"__builtin_lsx_vilvl_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vilvl_w : GCCBuiltin<"__builtin_lsx_vilvl_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vilvl_d : GCCBuiltin<"__builtin_lsx_vilvl_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vilvh_b : GCCBuiltin<"__builtin_lsx_vilvh_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vilvh_h : GCCBuiltin<"__builtin_lsx_vilvh_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vilvh_w : GCCBuiltin<"__builtin_lsx_vilvh_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vilvh_d : GCCBuiltin<"__builtin_lsx_vilvh_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vpickev_b : GCCBuiltin<"__builtin_lsx_vpickev_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickev_h : GCCBuiltin<"__builtin_lsx_vpickev_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickev_w : GCCBuiltin<"__builtin_lsx_vpickev_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickev_d : GCCBuiltin<"__builtin_lsx_vpickev_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vand_v : GCCBuiltin<"__builtin_lsx_vand_v">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_vor_v : GCCBuiltin<"__builtin_lsx_vor_v">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_vbitrev_b : GCCBuiltin<"__builtin_lsx_vbitrev_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitrev_h : GCCBuiltin<"__builtin_lsx_vbitrev_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitrev_w : GCCBuiltin<"__builtin_lsx_vbitrev_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vbitrev_d : GCCBuiltin<"__builtin_lsx_vbitrev_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmod_bu : GCCBuiltin<"__builtin_lsx_vmod_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmod_hu : GCCBuiltin<"__builtin_lsx_vmod_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmod_wu : GCCBuiltin<"__builtin_lsx_vmod_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmod_du : GCCBuiltin<"__builtin_lsx_vmod_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vpickod_b : GCCBuiltin<"__builtin_lsx_vpickod_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickod_h : GCCBuiltin<"__builtin_lsx_vpickod_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickod_w : GCCBuiltin<"__builtin_lsx_vpickod_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpickod_d : GCCBuiltin<"__builtin_lsx_vpickod_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vreplve_b : GCCBuiltin<"__builtin_lsx_vreplve_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vreplve_h : GCCBuiltin<"__builtin_lsx_vreplve_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vreplve_w : GCCBuiltin<"__builtin_lsx_vreplve_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vreplve_d : GCCBuiltin<"__builtin_lsx_vreplve_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsra_b : GCCBuiltin<"__builtin_lsx_vsra_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsra_h : GCCBuiltin<"__builtin_lsx_vsra_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsra_w : GCCBuiltin<"__builtin_lsx_vsra_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsra_d : GCCBuiltin<"__builtin_lsx_vsra_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vxor_v : GCCBuiltin<"__builtin_lsx_vxor_v">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_vnor_v : GCCBuiltin<"__builtin_lsx_vnor_v">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfadd_s : GCCBuiltin<"__builtin_lsx_vfadd_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfadd_d : GCCBuiltin<"__builtin_lsx_vfadd_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfsub_s : GCCBuiltin<"__builtin_lsx_vfsub_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfsub_d : GCCBuiltin<"__builtin_lsx_vfsub_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfmul_s : GCCBuiltin<"__builtin_lsx_vfmul_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfmul_d : GCCBuiltin<"__builtin_lsx_vfmul_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vshuf_h : GCCBuiltin<"__builtin_lsx_vshuf_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty, llvm_v8i16_ty],
            [IntrNoMem]>;
def int_loongarch_lsx_vshuf_w : GCCBuiltin<"__builtin_lsx_vshuf_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_v4i32_ty],
            [IntrNoMem]>;
def int_loongarch_lsx_vshuf_d : GCCBuiltin<"__builtin_lsx_vshuf_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_v2i64_ty],
            [IntrNoMem]>;

def int_loongarch_lsx_vseqi_b : GCCBuiltin<"__builtin_lsx_vseqi_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vseqi_h : GCCBuiltin<"__builtin_lsx_vseqi_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vseqi_w : GCCBuiltin<"__builtin_lsx_vseqi_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vseqi_d : GCCBuiltin<"__builtin_lsx_vseqi_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vslei_b : GCCBuiltin<"__builtin_lsx_vslei_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslei_h : GCCBuiltin<"__builtin_lsx_vslei_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslei_w : GCCBuiltin<"__builtin_lsx_vslei_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslei_d : GCCBuiltin<"__builtin_lsx_vslei_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vslei_bu : GCCBuiltin<"__builtin_lsx_vslei_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslei_hu : GCCBuiltin<"__builtin_lsx_vslei_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslei_wu : GCCBuiltin<"__builtin_lsx_vslei_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslei_du : GCCBuiltin<"__builtin_lsx_vslei_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vslti_b : GCCBuiltin<"__builtin_lsx_vslti_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslti_h : GCCBuiltin<"__builtin_lsx_vslti_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslti_w : GCCBuiltin<"__builtin_lsx_vslti_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslti_d : GCCBuiltin<"__builtin_lsx_vslti_d">,
 Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;
 
def int_loongarch_lsx_vslti_bu : GCCBuiltin<"__builtin_lsx_vslti_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslti_hu : GCCBuiltin<"__builtin_lsx_vslti_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslti_wu : GCCBuiltin<"__builtin_lsx_vslti_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslti_du : GCCBuiltin<"__builtin_lsx_vslti_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vaddi_bu : GCCBuiltin<"__builtin_lsx_vaddi_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vaddi_hu : GCCBuiltin<"__builtin_lsx_vaddi_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vaddi_wu : GCCBuiltin<"__builtin_lsx_vaddi_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lsx_vaddi_du : GCCBuiltin<"__builtin_lsx_vaddi_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lsx_vsubi_bu : GCCBuiltin<"__builtin_lsx_vsubi_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubi_hu : GCCBuiltin<"__builtin_lsx_vsubi_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubi_wu : GCCBuiltin<"__builtin_lsx_vsubi_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsubi_du : GCCBuiltin<"__builtin_lsx_vsubi_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmaxi_b : GCCBuiltin<"__builtin_lsx_vmaxi_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaxi_h : GCCBuiltin<"__builtin_lsx_vmaxi_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaxi_w : GCCBuiltin<"__builtin_lsx_vmaxi_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaxi_d : GCCBuiltin<"__builtin_lsx_vmaxi_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmini_b : GCCBuiltin<"__builtin_lsx_vmini_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmini_h : GCCBuiltin<"__builtin_lsx_vmini_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmini_w : GCCBuiltin<"__builtin_lsx_vmini_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmini_d : GCCBuiltin<"__builtin_lsx_vmini_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmaxi_bu : GCCBuiltin<"__builtin_lsx_vmaxi_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaxi_hu : GCCBuiltin<"__builtin_lsx_vmaxi_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaxi_wu : GCCBuiltin<"__builtin_lsx_vmaxi_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmaxi_du : GCCBuiltin<"__builtin_lsx_vmaxi_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vmini_bu : GCCBuiltin<"__builtin_lsx_vmini_bu">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmini_hu : GCCBuiltin<"__builtin_lsx_vmini_hu">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmini_wu : GCCBuiltin<"__builtin_lsx_vmini_wu">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vmini_du : GCCBuiltin<"__builtin_lsx_vmini_du">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vclz_b : GCCBuiltin<"__builtin_lsx_vclz_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vclz_h : GCCBuiltin<"__builtin_lsx_vclz_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vclz_w : GCCBuiltin<"__builtin_lsx_vclz_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vclz_d : GCCBuiltin<"__builtin_lsx_vclz_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vpcnt_b : GCCBuiltin<"__builtin_lsx_vpcnt_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpcnt_h : GCCBuiltin<"__builtin_lsx_vpcnt_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpcnt_w : GCCBuiltin<"__builtin_lsx_vpcnt_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vpcnt_d : GCCBuiltin<"__builtin_lsx_vpcnt_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfsqrt_s : GCCBuiltin<"__builtin_lsx_vfsqrt_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfsqrt_d : GCCBuiltin<"__builtin_lsx_vfsqrt_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vfrint_s : GCCBuiltin<"__builtin_lsx_vfrint_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfrint_d : GCCBuiltin<"__builtin_lsx_vfrint_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vffint_s_w : GCCBuiltin<"__builtin_lsx_vffint_s_w">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vffint_d_l : GCCBuiltin<"__builtin_lsx_vffint_d_l">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vffint_s_wu : GCCBuiltin<"__builtin_lsx_vffint_s_wu">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vffint_d_lu : GCCBuiltin<"__builtin_lsx_vffint_d_lu">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vftintrz_wu_s : GCCBuiltin<"__builtin_lsx_vftintrz_wu_s">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vftintrz_lu_d : GCCBuiltin<"__builtin_lsx_vftintrz_lu_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vreplgr2vr_b : GCCBuiltin<"__builtin_lsx_vreplgr2vr_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vreplgr2vr_h : GCCBuiltin<"__builtin_lsx_vreplgr2vr_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vreplgr2vr_w : GCCBuiltin<"__builtin_lsx_vreplgr2vr_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vreplgr2vr_d : GCCBuiltin<"__builtin_lsx_vreplgr2vr_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vinsgr2vr_b : GCCBuiltin<"__builtin_lsx_vinsgr2vr_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vinsgr2vr_h : GCCBuiltin<"__builtin_lsx_vinsgr2vr_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vinsgr2vr_w : GCCBuiltin<"__builtin_lsx_vinsgr2vr_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_loongarch_lsx_vinsgr2vr_d : GCCBuiltin<"__builtin_lsx_vinsgr2vr_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i64_ty, llvm_i32_ty],
  [IntrNoMem]>;

def int_loongarch_lsx_vfdiv_s : GCCBuiltin<"__builtin_lsx_vfdiv_s">,
  Intrinsic<[llvm_v4f32_ty], [llvm_v4f32_ty, llvm_v4f32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vfdiv_d : GCCBuiltin<"__builtin_lsx_vfdiv_d">,
  Intrinsic<[llvm_v2f64_ty], [llvm_v2f64_ty, llvm_v2f64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vslli_b : GCCBuiltin<"__builtin_lsx_vslli_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslli_h : GCCBuiltin<"__builtin_lsx_vslli_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslli_w : GCCBuiltin<"__builtin_lsx_vslli_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vslli_d : GCCBuiltin<"__builtin_lsx_vslli_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrli_b : GCCBuiltin<"__builtin_lsx_vsrli_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrli_h : GCCBuiltin<"__builtin_lsx_vsrli_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrli_w : GCCBuiltin<"__builtin_lsx_vsrli_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrli_d : GCCBuiltin<"__builtin_lsx_vsrli_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vsrai_b : GCCBuiltin<"__builtin_lsx_vsrai_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrai_h : GCCBuiltin<"__builtin_lsx_vsrai_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrai_w : GCCBuiltin<"__builtin_lsx_vsrai_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vsrai_d : GCCBuiltin<"__builtin_lsx_vsrai_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vshuf4i_b : GCCBuiltin<"__builtin_lsx_vshuf4i_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vshuf4i_h : GCCBuiltin<"__builtin_lsx_vshuf4i_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vshuf4i_w : GCCBuiltin<"__builtin_lsx_vshuf4i_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vshuf4i_d : GCCBuiltin<"__builtin_lsx_vshuf4i_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vrotr_b : GCCBuiltin<"__builtin_lsx_vrotr_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_vrotr_h : GCCBuiltin<"__builtin_lsx_vrotr_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_vrotr_w : GCCBuiltin<"__builtin_lsx_vrotr_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vrotr_d : GCCBuiltin<"__builtin_lsx_vrotr_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_vrotri_b : GCCBuiltin<"__builtin_lsx_vrotri_b">,
  Intrinsic<[llvm_v16i8_ty], [llvm_v16i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vrotri_h : GCCBuiltin<"__builtin_lsx_vrotri_h">,
  Intrinsic<[llvm_v8i16_ty], [llvm_v8i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vrotri_w : GCCBuiltin<"__builtin_lsx_vrotri_w">,
  Intrinsic<[llvm_v4i32_ty], [llvm_v4i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_vrotri_d : GCCBuiltin<"__builtin_lsx_vrotri_d">,
  Intrinsic<[llvm_v2i64_ty], [llvm_v2i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lsx_vld : GCCBuiltin<"__builtin_lsx_vld">,
  Intrinsic<[llvm_v16i8_ty], [llvm_ptr_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;

def int_loongarch_lsx_vst : GCCBuiltin<"__builtin_lsx_vst">,
  Intrinsic<[], [llvm_v16i8_ty, llvm_ptr_ty, llvm_i32_ty],
  [IntrArgMemOnly]>;

def int_loongarch_lsx_bz_v : GCCBuiltin<"__builtin_lsx_bz_v">,
  Intrinsic<[llvm_i32_ty], [llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_bnz_v : GCCBuiltin<"__builtin_lsx_bnz_v">,
  Intrinsic<[llvm_i32_ty], [llvm_v16i8_ty], [IntrNoMem]>;

def int_loongarch_lsx_bz_b : GCCBuiltin<"__builtin_lsx_bz_b">,
  Intrinsic<[llvm_i32_ty], [llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_bz_h : GCCBuiltin<"__builtin_lsx_bz_h">,
  Intrinsic<[llvm_i32_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_bz_w : GCCBuiltin<"__builtin_lsx_bz_w">,
  Intrinsic<[llvm_i32_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_bz_d : GCCBuiltin<"__builtin_lsx_bz_d">,
  Intrinsic<[llvm_i32_ty], [llvm_v2i64_ty], [IntrNoMem]>;

def int_loongarch_lsx_bnz_b : GCCBuiltin<"__builtin_lsx_bnz_b">,
  Intrinsic<[llvm_i32_ty], [llvm_v16i8_ty], [IntrNoMem]>;
def int_loongarch_lsx_bnz_h : GCCBuiltin<"__builtin_lsx_bnz_h">,
  Intrinsic<[llvm_i32_ty], [llvm_v8i16_ty], [IntrNoMem]>;
def int_loongarch_lsx_bnz_w : GCCBuiltin<"__builtin_lsx_bnz_w">,
  Intrinsic<[llvm_i32_ty], [llvm_v4i32_ty], [IntrNoMem]>;
def int_loongarch_lsx_bnz_d : GCCBuiltin<"__builtin_lsx_bnz_d">,
  Intrinsic<[llvm_i32_ty], [llvm_v2i64_ty], [IntrNoMem]>;

//===----------------------------------------------------------------------===//
//LoongArch LASX

def int_loongarch_lasx_xvfmadd_s : GCCBuiltin<"__builtin_lasx_xvfmadd_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty, llvm_v8f32_ty],
            [IntrNoMem]>;
def int_loongarch_lasx_xvfmadd_d : GCCBuiltin<"__builtin_lasx_xvfmadd_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty, llvm_v4f64_ty],
            [IntrNoMem]>;

def int_loongarch_lasx_xvfmsub_s : GCCBuiltin<"__builtin_lasx_xvfmsub_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty, llvm_v8f32_ty],
            [IntrNoMem]>;
def int_loongarch_lasx_xvfmsub_d : GCCBuiltin<"__builtin_lasx_xvfmsub_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty, llvm_v4f64_ty],
            [IntrNoMem]>;


def int_loongarch_lasx_xvfnmadd_s : GCCBuiltin<"__builtin_lasx_xvfnmadd_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty, llvm_v8f32_ty],
            [IntrNoMem]>;
def int_loongarch_lasx_xvfnmadd_d : GCCBuiltin<"__builtin_lasx_xvfnmadd_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty, llvm_v4f64_ty],
            [IntrNoMem]>;

def int_loongarch_lasx_xvfnmsub_s : GCCBuiltin<"__builtin_lasx_xvfnmsub_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty, llvm_v8f32_ty],
            [IntrNoMem]>;
def int_loongarch_lasx_xvfnmsub_d : GCCBuiltin<"__builtin_lasx_xvfnmsub_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty, llvm_v4f64_ty],
            [IntrNoMem]>;

def int_loongarch_lasx_xvclo_b : GCCBuiltin<"__builtin_lasx_xvclo_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvclo_h : GCCBuiltin<"__builtin_lasx_xvclo_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvclo_w : GCCBuiltin<"__builtin_lasx_xvclo_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvclo_d : GCCBuiltin<"__builtin_lasx_xvclo_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvflogb_s : GCCBuiltin<"__builtin_lasx_xvflogb_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvflogb_d : GCCBuiltin<"__builtin_lasx_xvflogb_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpickve2gr_w : GCCBuiltin<"__builtin_lasx_xvpickve2gr_w">,
  Intrinsic<[llvm_i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpickve2gr_d : GCCBuiltin<"__builtin_lasx_xvpickve2gr_d">,
  Intrinsic<[llvm_i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpickve2gr_wu : GCCBuiltin<"__builtin_lasx_xvpickve2gr_wu">,
  Intrinsic<[llvm_i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpickve2gr_du : GCCBuiltin<"__builtin_lasx_xvpickve2gr_du">,
  Intrinsic<[llvm_i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmskltz_b : GCCBuiltin<"__builtin_lasx_xvmskltz_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmskltz_h : GCCBuiltin<"__builtin_lasx_xvmskltz_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmskltz_w : GCCBuiltin<"__builtin_lasx_xvmskltz_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmskltz_d : GCCBuiltin<"__builtin_lasx_xvmskltz_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_caf_s : GCCBuiltin<"__builtin_lasx_xvfcmp_caf_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_caf_d : GCCBuiltin<"__builtin_lasx_xvfcmp_caf_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_cor_s : GCCBuiltin<"__builtin_lasx_xvfcmp_cor_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_cor_d : GCCBuiltin<"__builtin_lasx_xvfcmp_cor_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_cun_s : GCCBuiltin<"__builtin_lasx_xvfcmp_cun_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_cun_d : GCCBuiltin<"__builtin_lasx_xvfcmp_cun_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_cune_s : GCCBuiltin<"__builtin_lasx_xvfcmp_cune_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_cune_d : GCCBuiltin<"__builtin_lasx_xvfcmp_cune_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_cueq_s : GCCBuiltin<"__builtin_lasx_xvfcmp_cueq_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_cueq_d : GCCBuiltin<"__builtin_lasx_xvfcmp_cueq_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_ceq_s : GCCBuiltin<"__builtin_lasx_xvfcmp_ceq_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_ceq_d : GCCBuiltin<"__builtin_lasx_xvfcmp_ceq_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_cne_s : GCCBuiltin<"__builtin_lasx_xvfcmp_cne_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_cne_d : GCCBuiltin<"__builtin_lasx_xvfcmp_cne_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_clt_s : GCCBuiltin<"__builtin_lasx_xvfcmp_clt_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_clt_d : GCCBuiltin<"__builtin_lasx_xvfcmp_clt_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_cult_s : GCCBuiltin<"__builtin_lasx_xvfcmp_cult_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_cult_d : GCCBuiltin<"__builtin_lasx_xvfcmp_cult_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_cle_s : GCCBuiltin<"__builtin_lasx_xvfcmp_cle_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_cle_d : GCCBuiltin<"__builtin_lasx_xvfcmp_cle_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_cule_s : GCCBuiltin<"__builtin_lasx_xvfcmp_cule_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_cule_d : GCCBuiltin<"__builtin_lasx_xvfcmp_cule_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_saf_s : GCCBuiltin<"__builtin_lasx_xvfcmp_saf_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_saf_d : GCCBuiltin<"__builtin_lasx_xvfcmp_saf_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_sor_s : GCCBuiltin<"__builtin_lasx_xvfcmp_sor_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_sor_d : GCCBuiltin<"__builtin_lasx_xvfcmp_sor_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_sun_s : GCCBuiltin<"__builtin_lasx_xvfcmp_sun_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_sun_d : GCCBuiltin<"__builtin_lasx_xvfcmp_sun_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_sune_s : GCCBuiltin<"__builtin_lasx_xvfcmp_sune_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_sune_d : GCCBuiltin<"__builtin_lasx_xvfcmp_sune_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_sueq_s : GCCBuiltin<"__builtin_lasx_xvfcmp_sueq_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_sueq_d : GCCBuiltin<"__builtin_lasx_xvfcmp_sueq_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_seq_s : GCCBuiltin<"__builtin_lasx_xvfcmp_seq_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_seq_d : GCCBuiltin<"__builtin_lasx_xvfcmp_seq_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_sne_s : GCCBuiltin<"__builtin_lasx_xvfcmp_sne_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_sne_d : GCCBuiltin<"__builtin_lasx_xvfcmp_sne_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_slt_s : GCCBuiltin<"__builtin_lasx_xvfcmp_slt_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_slt_d : GCCBuiltin<"__builtin_lasx_xvfcmp_slt_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_sult_s : GCCBuiltin<"__builtin_lasx_xvfcmp_sult_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_sult_d : GCCBuiltin<"__builtin_lasx_xvfcmp_sult_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_sle_s : GCCBuiltin<"__builtin_lasx_xvfcmp_sle_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_sle_d : GCCBuiltin<"__builtin_lasx_xvfcmp_sle_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcmp_sule_s : GCCBuiltin<"__builtin_lasx_xvfcmp_sule_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcmp_sule_d : GCCBuiltin<"__builtin_lasx_xvfcmp_sule_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvbitsel_v : GCCBuiltin<"__builtin_lasx_xvbitsel_v">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvshuf_b : GCCBuiltin<"__builtin_lasx_xvshuf_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvldrepl_b : GCCBuiltin<"__builtin_lasx_xvldrepl_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_ptr_ty, llvm_i32_ty], [IntrReadMem, IntrArgMemOnly]>;
def int_loongarch_lasx_xvldrepl_h : GCCBuiltin<"__builtin_lasx_xvldrepl_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_ptr_ty, llvm_i32_ty], [IntrReadMem, IntrArgMemOnly]>;
def int_loongarch_lasx_xvldrepl_w : GCCBuiltin<"__builtin_lasx_xvldrepl_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_ptr_ty, llvm_i32_ty], [IntrReadMem, IntrArgMemOnly]>;
def int_loongarch_lasx_xvldrepl_d : GCCBuiltin<"__builtin_lasx_xvldrepl_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_ptr_ty, llvm_i32_ty], [IntrReadMem, IntrArgMemOnly]>;

def int_loongarch_lasx_xvstelm_b : GCCBuiltin<"__builtin_lasx_xvstelm_b">,
  Intrinsic<[], [llvm_v32i8_ty, llvm_ptr_ty, llvm_i32_ty, llvm_i32_ty], [IntrArgMemOnly]>;
def int_loongarch_lasx_xvstelm_h : GCCBuiltin<"__builtin_lasx_xvstelm_h">,
  Intrinsic<[], [llvm_v16i16_ty, llvm_ptr_ty, llvm_i32_ty, llvm_i32_ty], [IntrArgMemOnly]>;
def int_loongarch_lasx_xvstelm_w : GCCBuiltin<"__builtin_lasx_xvstelm_w">,
  Intrinsic<[], [llvm_v8i32_ty, llvm_ptr_ty, llvm_i32_ty, llvm_i32_ty], [IntrArgMemOnly]>;
def int_loongarch_lasx_xvstelm_d : GCCBuiltin<"__builtin_lasx_xvstelm_d">,
  Intrinsic<[], [llvm_v4i64_ty, llvm_ptr_ty, llvm_i32_ty, llvm_i32_ty], [IntrArgMemOnly]>;

def int_loongarch_lasx_xvldx : GCCBuiltin<"__builtin_lasx_xvldx">,
  Intrinsic<[llvm_v32i8_ty], [llvm_ptr_ty, llvm_i64_ty],
  [IntrReadMem, IntrArgMemOnly]>;

def int_loongarch_lasx_xvstx : GCCBuiltin<"__builtin_lasx_xvstx">,
  Intrinsic<[], [llvm_v32i8_ty, llvm_ptr_ty, llvm_i64_ty],
  [IntrArgMemOnly]>;

def int_loongarch_lasx_xvaddwev_d_w : GCCBuiltin<"__builtin_lasx_xvaddwev_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwev_w_h : GCCBuiltin<"__builtin_lasx_xvaddwev_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwev_h_b : GCCBuiltin<"__builtin_lasx_xvaddwev_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwev_q_d : GCCBuiltin<"__builtin_lasx_xvaddwev_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsubwev_d_w : GCCBuiltin<"__builtin_lasx_xvsubwev_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwev_w_h : GCCBuiltin<"__builtin_lasx_xvsubwev_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwev_h_b : GCCBuiltin<"__builtin_lasx_xvsubwev_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwev_q_d : GCCBuiltin<"__builtin_lasx_xvsubwev_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvaddwod_d_w : GCCBuiltin<"__builtin_lasx_xvaddwod_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwod_w_h : GCCBuiltin<"__builtin_lasx_xvaddwod_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwod_h_b : GCCBuiltin<"__builtin_lasx_xvaddwod_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwod_q_d : GCCBuiltin<"__builtin_lasx_xvaddwod_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsubwod_d_w : GCCBuiltin<"__builtin_lasx_xvsubwod_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwod_w_h : GCCBuiltin<"__builtin_lasx_xvsubwod_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwod_h_b : GCCBuiltin<"__builtin_lasx_xvsubwod_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwod_q_d : GCCBuiltin<"__builtin_lasx_xvsubwod_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvaddwev_d_wu : GCCBuiltin<"__builtin_lasx_xvaddwev_d_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwev_w_hu : GCCBuiltin<"__builtin_lasx_xvaddwev_w_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwev_h_bu : GCCBuiltin<"__builtin_lasx_xvaddwev_h_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwev_q_du : GCCBuiltin<"__builtin_lasx_xvaddwev_q_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsubwev_d_wu : GCCBuiltin<"__builtin_lasx_xvsubwev_d_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwev_w_hu : GCCBuiltin<"__builtin_lasx_xvsubwev_w_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwev_h_bu : GCCBuiltin<"__builtin_lasx_xvsubwev_h_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwev_q_du : GCCBuiltin<"__builtin_lasx_xvsubwev_q_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvaddwod_d_wu : GCCBuiltin<"__builtin_lasx_xvaddwod_d_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwod_w_hu : GCCBuiltin<"__builtin_lasx_xvaddwod_w_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwod_h_bu : GCCBuiltin<"__builtin_lasx_xvaddwod_h_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwod_q_du : GCCBuiltin<"__builtin_lasx_xvaddwod_q_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsubwod_d_wu : GCCBuiltin<"__builtin_lasx_xvsubwod_d_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwod_w_hu : GCCBuiltin<"__builtin_lasx_xvsubwod_w_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwod_h_bu : GCCBuiltin<"__builtin_lasx_xvsubwod_h_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubwod_q_du : GCCBuiltin<"__builtin_lasx_xvsubwod_q_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvaddwev_d_wu_w : GCCBuiltin<"__builtin_lasx_xvaddwev_d_wu_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwev_w_hu_h : GCCBuiltin<"__builtin_lasx_xvaddwev_w_hu_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwev_h_bu_b : GCCBuiltin<"__builtin_lasx_xvaddwev_h_bu_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwev_q_du_d : GCCBuiltin<"__builtin_lasx_xvaddwev_q_du_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvaddwod_d_wu_w : GCCBuiltin<"__builtin_lasx_xvaddwod_d_wu_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwod_w_hu_h : GCCBuiltin<"__builtin_lasx_xvaddwod_w_hu_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwod_h_bu_b : GCCBuiltin<"__builtin_lasx_xvaddwod_h_bu_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvaddwod_q_du_d : GCCBuiltin<"__builtin_lasx_xvaddwod_q_du_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvhaddw_qu_du : GCCBuiltin<"__builtin_lasx_xvhaddw_qu_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvhsubw_qu_du : GCCBuiltin<"__builtin_lasx_xvhsubw_qu_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvhaddw_q_d : GCCBuiltin<"__builtin_lasx_xvhaddw_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvhsubw_q_d : GCCBuiltin<"__builtin_lasx_xvhsubw_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmuh_b : GCCBuiltin<"__builtin_lasx_xvmuh_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmuh_h : GCCBuiltin<"__builtin_lasx_xvmuh_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmuh_w : GCCBuiltin<"__builtin_lasx_xvmuh_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmuh_d : GCCBuiltin<"__builtin_lasx_xvmuh_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmuh_bu : GCCBuiltin<"__builtin_lasx_xvmuh_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmuh_hu : GCCBuiltin<"__builtin_lasx_xvmuh_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmuh_wu : GCCBuiltin<"__builtin_lasx_xvmuh_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmuh_du : GCCBuiltin<"__builtin_lasx_xvmuh_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmulwev_d_w : GCCBuiltin<"__builtin_lasx_xvmulwev_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwev_w_h : GCCBuiltin<"__builtin_lasx_xvmulwev_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwev_h_b : GCCBuiltin<"__builtin_lasx_xvmulwev_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwev_q_d : GCCBuiltin<"__builtin_lasx_xvmulwev_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmulwod_d_w : GCCBuiltin<"__builtin_lasx_xvmulwod_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwod_w_h : GCCBuiltin<"__builtin_lasx_xvmulwod_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwod_h_b : GCCBuiltin<"__builtin_lasx_xvmulwod_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwod_q_d : GCCBuiltin<"__builtin_lasx_xvmulwod_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmulwev_d_wu : GCCBuiltin<"__builtin_lasx_xvmulwev_d_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwev_w_hu : GCCBuiltin<"__builtin_lasx_xvmulwev_w_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwev_h_bu : GCCBuiltin<"__builtin_lasx_xvmulwev_h_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwev_q_du : GCCBuiltin<"__builtin_lasx_xvmulwev_q_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmulwod_d_wu : GCCBuiltin<"__builtin_lasx_xvmulwod_d_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwod_w_hu : GCCBuiltin<"__builtin_lasx_xvmulwod_w_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwod_h_bu : GCCBuiltin<"__builtin_lasx_xvmulwod_h_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwod_q_du : GCCBuiltin<"__builtin_lasx_xvmulwod_q_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmulwev_d_wu_w : GCCBuiltin<"__builtin_lasx_xvmulwev_d_wu_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwev_w_hu_h : GCCBuiltin<"__builtin_lasx_xvmulwev_w_hu_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwev_h_bu_b : GCCBuiltin<"__builtin_lasx_xvmulwev_h_bu_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwev_q_du_d : GCCBuiltin<"__builtin_lasx_xvmulwev_q_du_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmulwod_d_wu_w : GCCBuiltin<"__builtin_lasx_xvmulwod_d_wu_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwod_w_hu_h : GCCBuiltin<"__builtin_lasx_xvmulwod_w_hu_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwod_h_bu_b : GCCBuiltin<"__builtin_lasx_xvmulwod_h_bu_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmulwod_q_du_d : GCCBuiltin<"__builtin_lasx_xvmulwod_q_du_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmaddwev_d_w : GCCBuiltin<"__builtin_lasx_xvmaddwev_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwev_w_h : GCCBuiltin<"__builtin_lasx_xvmaddwev_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwev_h_b : GCCBuiltin<"__builtin_lasx_xvmaddwev_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwev_q_d : GCCBuiltin<"__builtin_lasx_xvmaddwev_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmaddwod_d_w : GCCBuiltin<"__builtin_lasx_xvmaddwod_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwod_w_h : GCCBuiltin<"__builtin_lasx_xvmaddwod_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwod_h_b : GCCBuiltin<"__builtin_lasx_xvmaddwod_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwod_q_d : GCCBuiltin<"__builtin_lasx_xvmaddwod_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmaddwev_d_wu : GCCBuiltin<"__builtin_lasx_xvmaddwev_d_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwev_w_hu : GCCBuiltin<"__builtin_lasx_xvmaddwev_w_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwev_h_bu : GCCBuiltin<"__builtin_lasx_xvmaddwev_h_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwev_q_du : GCCBuiltin<"__builtin_lasx_xvmaddwev_q_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmaddwod_d_wu : GCCBuiltin<"__builtin_lasx_xvmaddwod_d_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwod_w_hu : GCCBuiltin<"__builtin_lasx_xvmaddwod_w_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwod_h_bu : GCCBuiltin<"__builtin_lasx_xvmaddwod_h_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwod_q_du : GCCBuiltin<"__builtin_lasx_xvmaddwod_q_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmaddwev_d_wu_w : GCCBuiltin<"__builtin_lasx_xvmaddwev_d_wu_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwev_w_hu_h : GCCBuiltin<"__builtin_lasx_xvmaddwev_w_hu_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwev_h_bu_b : GCCBuiltin<"__builtin_lasx_xvmaddwev_h_bu_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwev_q_du_d : GCCBuiltin<"__builtin_lasx_xvmaddwev_q_du_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmaddwod_d_wu_w : GCCBuiltin<"__builtin_lasx_xvmaddwod_d_wu_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwod_w_hu_h : GCCBuiltin<"__builtin_lasx_xvmaddwod_w_hu_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwod_h_bu_b : GCCBuiltin<"__builtin_lasx_xvmaddwod_h_bu_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaddwod_q_du_d : GCCBuiltin<"__builtin_lasx_xvmaddwod_q_du_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrln_b_h : GCCBuiltin<"__builtin_lasx_xvsrln_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrln_h_w : GCCBuiltin<"__builtin_lasx_xvsrln_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrln_w_d : GCCBuiltin<"__builtin_lasx_xvsrln_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsran_b_h : GCCBuiltin<"__builtin_lasx_xvsran_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsran_h_w : GCCBuiltin<"__builtin_lasx_xvsran_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsran_w_d : GCCBuiltin<"__builtin_lasx_xvsran_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrlrn_b_h : GCCBuiltin<"__builtin_lasx_xvsrlrn_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlrn_h_w : GCCBuiltin<"__builtin_lasx_xvsrlrn_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlrn_w_d : GCCBuiltin<"__builtin_lasx_xvsrlrn_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrarn_b_h : GCCBuiltin<"__builtin_lasx_xvsrarn_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrarn_h_w : GCCBuiltin<"__builtin_lasx_xvsrarn_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrarn_w_d : GCCBuiltin<"__builtin_lasx_xvsrarn_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrln_b_h : GCCBuiltin<"__builtin_lasx_xvssrln_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrln_h_w : GCCBuiltin<"__builtin_lasx_xvssrln_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrln_w_d : GCCBuiltin<"__builtin_lasx_xvssrln_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssran_b_h : GCCBuiltin<"__builtin_lasx_xvssran_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssran_h_w : GCCBuiltin<"__builtin_lasx_xvssran_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssran_w_d : GCCBuiltin<"__builtin_lasx_xvssran_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrlrn_b_h : GCCBuiltin<"__builtin_lasx_xvssrlrn_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlrn_h_w : GCCBuiltin<"__builtin_lasx_xvssrlrn_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlrn_w_d : GCCBuiltin<"__builtin_lasx_xvssrlrn_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrarn_b_h : GCCBuiltin<"__builtin_lasx_xvssrarn_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrarn_h_w : GCCBuiltin<"__builtin_lasx_xvssrarn_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrarn_w_d : GCCBuiltin<"__builtin_lasx_xvssrarn_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrln_bu_h : GCCBuiltin<"__builtin_lasx_xvssrln_bu_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrln_hu_w : GCCBuiltin<"__builtin_lasx_xvssrln_hu_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrln_wu_d : GCCBuiltin<"__builtin_lasx_xvssrln_wu_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssran_bu_h : GCCBuiltin<"__builtin_lasx_xvssran_bu_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssran_hu_w : GCCBuiltin<"__builtin_lasx_xvssran_hu_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssran_wu_d : GCCBuiltin<"__builtin_lasx_xvssran_wu_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrlrn_bu_h : GCCBuiltin<"__builtin_lasx_xvssrlrn_bu_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlrn_hu_w : GCCBuiltin<"__builtin_lasx_xvssrlrn_hu_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlrn_wu_d : GCCBuiltin<"__builtin_lasx_xvssrlrn_wu_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrarn_bu_h : GCCBuiltin<"__builtin_lasx_xvssrarn_bu_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrarn_hu_w : GCCBuiltin<"__builtin_lasx_xvssrarn_hu_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrarn_wu_d : GCCBuiltin<"__builtin_lasx_xvssrarn_wu_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvandn_v : GCCBuiltin<"__builtin_lasx_xvandn_v">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvorn_v : GCCBuiltin<"__builtin_lasx_xvorn_v">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfrstp_b : GCCBuiltin<"__builtin_lasx_xvfrstp_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvfrstp_h : GCCBuiltin<"__builtin_lasx_xvfrstp_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;

def int_loongarch_lasx_xvadd_q : GCCBuiltin<"__builtin_lasx_xvadd_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsub_q : GCCBuiltin<"__builtin_lasx_xvsub_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsigncov_b : GCCBuiltin<"__builtin_lasx_xvsigncov_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvsigncov_h : GCCBuiltin<"__builtin_lasx_xvsigncov_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvsigncov_w : GCCBuiltin<"__builtin_lasx_xvsigncov_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvsigncov_d : GCCBuiltin<"__builtin_lasx_xvsigncov_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [IntrNoMem]>;

def int_loongarch_lasx_xvfcvt_h_s : GCCBuiltin<"__builtin_lasx_xvfcvt_h_s">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcvt_s_d : GCCBuiltin<"__builtin_lasx_xvfcvt_s_d">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvffint_s_l : GCCBuiltin<"__builtin_lasx_xvffint_s_l">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftint_w_d : GCCBuiltin<"__builtin_lasx_xvftint_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftintrz_w_d : GCCBuiltin<"__builtin_lasx_xvftintrz_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrp_w_d : GCCBuiltin<"__builtin_lasx_xvftintrp_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrm_w_d : GCCBuiltin<"__builtin_lasx_xvftintrm_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrne_w_d : GCCBuiltin<"__builtin_lasx_xvftintrne_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvbsrl_v : GCCBuiltin<"__builtin_lasx_xvbsrl_v">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbsll_v : GCCBuiltin<"__builtin_lasx_xvbsll_v">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfrstpi_b : GCCBuiltin<"__builtin_lasx_xvfrstpi_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfrstpi_h : GCCBuiltin<"__builtin_lasx_xvfrstpi_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvneg_b : GCCBuiltin<"__builtin_lasx_xvneg_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvneg_h : GCCBuiltin<"__builtin_lasx_xvneg_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvneg_w : GCCBuiltin<"__builtin_lasx_xvneg_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvneg_d : GCCBuiltin<"__builtin_lasx_xvneg_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmskgez_b : GCCBuiltin<"__builtin_lasx_xvmskgez_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmsknz_b : GCCBuiltin<"__builtin_lasx_xvmsknz_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfrintrm_s : GCCBuiltin<"__builtin_lasx_xvfrintrm_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfrintrm_d : GCCBuiltin<"__builtin_lasx_xvfrintrm_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfrintrp_s : GCCBuiltin<"__builtin_lasx_xvfrintrp_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfrintrp_d : GCCBuiltin<"__builtin_lasx_xvfrintrp_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfrintrz_s : GCCBuiltin<"__builtin_lasx_xvfrintrz_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfrintrz_d : GCCBuiltin<"__builtin_lasx_xvfrintrz_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfrintrne_s : GCCBuiltin<"__builtin_lasx_xvfrintrne_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfrintrne_d : GCCBuiltin<"__builtin_lasx_xvfrintrne_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvffinth_d_w : GCCBuiltin<"__builtin_lasx_xvffinth_d_w">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvffintl_d_w : GCCBuiltin<"__builtin_lasx_xvffintl_d_w">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v8i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftintrm_w_s : GCCBuiltin<"__builtin_lasx_xvftintrm_w_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrm_l_d : GCCBuiltin<"__builtin_lasx_xvftintrm_l_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftintrp_w_s : GCCBuiltin<"__builtin_lasx_xvftintrp_w_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrp_l_d : GCCBuiltin<"__builtin_lasx_xvftintrp_l_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftintrz_w_s : GCCBuiltin<"__builtin_lasx_xvftintrz_w_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrz_l_d : GCCBuiltin<"__builtin_lasx_xvftintrz_l_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftintrne_w_s : GCCBuiltin<"__builtin_lasx_xvftintrne_w_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrne_l_d : GCCBuiltin<"__builtin_lasx_xvftintrne_l_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftinth_l_s : GCCBuiltin<"__builtin_lasx_xvftinth_l_s">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintl_l_s : GCCBuiltin<"__builtin_lasx_xvftintl_l_s">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8f32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftintrmh_l_s : GCCBuiltin<"__builtin_lasx_xvftintrmh_l_s">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrml_l_s : GCCBuiltin<"__builtin_lasx_xvftintrml_l_s">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8f32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftintrph_l_s : GCCBuiltin<"__builtin_lasx_xvftintrph_l_s">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrpl_l_s : GCCBuiltin<"__builtin_lasx_xvftintrpl_l_s">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8f32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftintrzh_l_s : GCCBuiltin<"__builtin_lasx_xvftintrzh_l_s">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrzl_l_s : GCCBuiltin<"__builtin_lasx_xvftintrzl_l_s">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8f32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftintrneh_l_s : GCCBuiltin<"__builtin_lasx_xvftintrneh_l_s">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrnel_l_s : GCCBuiltin<"__builtin_lasx_xvftintrnel_l_s">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8f32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvexth_d_w : GCCBuiltin<"__builtin_lasx_xvexth_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvexth_w_h : GCCBuiltin<"__builtin_lasx_xvexth_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvexth_h_b : GCCBuiltin<"__builtin_lasx_xvexth_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvexth_q_d : GCCBuiltin<"__builtin_lasx_xvexth_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsllwil_d_w : GCCBuiltin<"__builtin_lasx_xvsllwil_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsllwil_w_h : GCCBuiltin<"__builtin_lasx_xvsllwil_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsllwil_h_b : GCCBuiltin<"__builtin_lasx_xvsllwil_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsllwil_du_wu : GCCBuiltin<"__builtin_lasx_xvsllwil_du_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsllwil_wu_hu : GCCBuiltin<"__builtin_lasx_xvsllwil_wu_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsllwil_hu_bu : GCCBuiltin<"__builtin_lasx_xvsllwil_hu_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvbitclri_b : GCCBuiltin<"__builtin_lasx_xvbitclri_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitclri_h : GCCBuiltin<"__builtin_lasx_xvbitclri_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitclri_w : GCCBuiltin<"__builtin_lasx_xvbitclri_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitclri_d : GCCBuiltin<"__builtin_lasx_xvbitclri_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvbitseti_b : GCCBuiltin<"__builtin_lasx_xvbitseti_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitseti_h : GCCBuiltin<"__builtin_lasx_xvbitseti_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitseti_w : GCCBuiltin<"__builtin_lasx_xvbitseti_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitseti_d : GCCBuiltin<"__builtin_lasx_xvbitseti_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvbitrevi_b : GCCBuiltin<"__builtin_lasx_xvbitrevi_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitrevi_h : GCCBuiltin<"__builtin_lasx_xvbitrevi_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitrevi_w : GCCBuiltin<"__builtin_lasx_xvbitrevi_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitrevi_d : GCCBuiltin<"__builtin_lasx_xvbitrevi_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrlrni_b_h : GCCBuiltin<"__builtin_lasx_xvssrlrni_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlrni_h_w : GCCBuiltin<"__builtin_lasx_xvssrlrni_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlrni_w_d : GCCBuiltin<"__builtin_lasx_xvssrlrni_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlrni_d_q : GCCBuiltin<"__builtin_lasx_xvssrlrni_d_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrani_b_h : GCCBuiltin<"__builtin_lasx_xvsrani_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrani_h_w : GCCBuiltin<"__builtin_lasx_xvsrani_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrani_w_d : GCCBuiltin<"__builtin_lasx_xvsrani_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrani_d_q : GCCBuiltin<"__builtin_lasx_xvsrani_d_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvextrins_b : GCCBuiltin<"__builtin_lasx_xvextrins_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvextrins_h : GCCBuiltin<"__builtin_lasx_xvextrins_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvextrins_w : GCCBuiltin<"__builtin_lasx_xvextrins_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvextrins_d : GCCBuiltin<"__builtin_lasx_xvextrins_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvbitseli_b : GCCBuiltin<"__builtin_lasx_xvbitseli_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvandi_b : GCCBuiltin<"__builtin_lasx_xvandi_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvori_b : GCCBuiltin<"__builtin_lasx_xvori_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvxori_b : GCCBuiltin<"__builtin_lasx_xvxori_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvnori_b : GCCBuiltin<"__builtin_lasx_xvnori_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvldi : GCCBuiltin<"__builtin_lasx_xvldi">,
  Intrinsic<[llvm_v4i64_ty], [llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvrepli_b : GCCBuiltin<"__builtin_lasx_xvrepli_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvrepli_h : GCCBuiltin<"__builtin_lasx_xvrepli_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvrepli_w : GCCBuiltin<"__builtin_lasx_xvrepli_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvrepli_d : GCCBuiltin<"__builtin_lasx_xvrepli_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpermi_w : GCCBuiltin<"__builtin_lasx_xvpermi_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsadd_b : GCCBuiltin<"__builtin_lasx_xvsadd_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvsadd_h : GCCBuiltin<"__builtin_lasx_xvsadd_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvsadd_w : GCCBuiltin<"__builtin_lasx_xvsadd_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvsadd_d : GCCBuiltin<"__builtin_lasx_xvsadd_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lasx_xvssub_b : GCCBuiltin<"__builtin_lasx_xvssub_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssub_h : GCCBuiltin<"__builtin_lasx_xvssub_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssub_w : GCCBuiltin<"__builtin_lasx_xvssub_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssub_d : GCCBuiltin<"__builtin_lasx_xvssub_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsadd_bu : GCCBuiltin<"__builtin_lasx_xvsadd_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvsadd_hu : GCCBuiltin<"__builtin_lasx_xvsadd_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvsadd_wu : GCCBuiltin<"__builtin_lasx_xvsadd_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvsadd_du : GCCBuiltin<"__builtin_lasx_xvsadd_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lasx_xvssub_bu : GCCBuiltin<"__builtin_lasx_xvssub_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssub_hu : GCCBuiltin<"__builtin_lasx_xvssub_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssub_wu : GCCBuiltin<"__builtin_lasx_xvssub_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssub_du : GCCBuiltin<"__builtin_lasx_xvssub_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvhaddw_h_b : GCCBuiltin<"__builtin_lasx_xvhaddw_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvhaddw_w_h : GCCBuiltin<"__builtin_lasx_xvhaddw_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvhaddw_d_w : GCCBuiltin<"__builtin_lasx_xvhaddw_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvhsubw_h_b : GCCBuiltin<"__builtin_lasx_xvhsubw_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvhsubw_w_h : GCCBuiltin<"__builtin_lasx_xvhsubw_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvhsubw_d_w : GCCBuiltin<"__builtin_lasx_xvhsubw_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvhaddw_hu_bu : GCCBuiltin<"__builtin_lasx_xvhaddw_hu_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvhaddw_wu_hu : GCCBuiltin<"__builtin_lasx_xvhaddw_wu_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvhaddw_du_wu : GCCBuiltin<"__builtin_lasx_xvhaddw_du_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvhsubw_hu_bu : GCCBuiltin<"__builtin_lasx_xvhsubw_hu_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvhsubw_wu_hu : GCCBuiltin<"__builtin_lasx_xvhsubw_wu_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvhsubw_du_wu : GCCBuiltin<"__builtin_lasx_xvhsubw_du_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvadda_b : GCCBuiltin<"__builtin_lasx_xvadda_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvadda_h : GCCBuiltin<"__builtin_lasx_xvadda_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvadda_w : GCCBuiltin<"__builtin_lasx_xvadda_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvadda_d : GCCBuiltin<"__builtin_lasx_xvadda_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lasx_xvabsd_b : GCCBuiltin<"__builtin_lasx_xvabsd_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvabsd_h : GCCBuiltin<"__builtin_lasx_xvabsd_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvabsd_w : GCCBuiltin<"__builtin_lasx_xvabsd_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvabsd_d : GCCBuiltin<"__builtin_lasx_xvabsd_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvabsd_bu : GCCBuiltin<"__builtin_lasx_xvabsd_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvabsd_hu : GCCBuiltin<"__builtin_lasx_xvabsd_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvabsd_wu : GCCBuiltin<"__builtin_lasx_xvabsd_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvabsd_du : GCCBuiltin<"__builtin_lasx_xvabsd_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvavg_b : GCCBuiltin<"__builtin_lasx_xvavg_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavg_h : GCCBuiltin<"__builtin_lasx_xvavg_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavg_w : GCCBuiltin<"__builtin_lasx_xvavg_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavg_d : GCCBuiltin<"__builtin_lasx_xvavg_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lasx_xvavg_bu : GCCBuiltin<"__builtin_lasx_xvavg_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavg_hu : GCCBuiltin<"__builtin_lasx_xvavg_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavg_wu : GCCBuiltin<"__builtin_lasx_xvavg_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavg_du : GCCBuiltin<"__builtin_lasx_xvavg_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lasx_xvavgr_b : GCCBuiltin<"__builtin_lasx_xvavgr_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavgr_h : GCCBuiltin<"__builtin_lasx_xvavgr_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavgr_w : GCCBuiltin<"__builtin_lasx_xvavgr_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavgr_d : GCCBuiltin<"__builtin_lasx_xvavgr_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lasx_xvavgr_bu : GCCBuiltin<"__builtin_lasx_xvavgr_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavgr_hu : GCCBuiltin<"__builtin_lasx_xvavgr_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavgr_wu : GCCBuiltin<"__builtin_lasx_xvavgr_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvavgr_du : GCCBuiltin<"__builtin_lasx_xvavgr_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lasx_xvsrlr_b : GCCBuiltin<"__builtin_lasx_xvsrlr_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlr_h : GCCBuiltin<"__builtin_lasx_xvsrlr_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlr_w : GCCBuiltin<"__builtin_lasx_xvsrlr_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlr_d : GCCBuiltin<"__builtin_lasx_xvsrlr_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrar_b : GCCBuiltin<"__builtin_lasx_xvsrar_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrar_h : GCCBuiltin<"__builtin_lasx_xvsrar_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrar_w : GCCBuiltin<"__builtin_lasx_xvsrar_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrar_d : GCCBuiltin<"__builtin_lasx_xvsrar_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfmax_s : GCCBuiltin<"__builtin_lasx_xvfmax_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfmax_d : GCCBuiltin<"__builtin_lasx_xvfmax_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfmin_s : GCCBuiltin<"__builtin_lasx_xvfmin_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfmin_d : GCCBuiltin<"__builtin_lasx_xvfmin_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfmaxa_s : GCCBuiltin<"__builtin_lasx_xvfmaxa_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfmaxa_d : GCCBuiltin<"__builtin_lasx_xvfmaxa_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfmina_s : GCCBuiltin<"__builtin_lasx_xvfmina_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfmina_d : GCCBuiltin<"__builtin_lasx_xvfmina_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfclass_s : GCCBuiltin<"__builtin_lasx_xvfclass_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfclass_d : GCCBuiltin<"__builtin_lasx_xvfclass_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfrecip_s : GCCBuiltin<"__builtin_lasx_xvfrecip_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfrecip_d : GCCBuiltin<"__builtin_lasx_xvfrecip_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfrsqrt_s : GCCBuiltin<"__builtin_lasx_xvfrsqrt_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfrsqrt_d : GCCBuiltin<"__builtin_lasx_xvfrsqrt_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcvtl_s_h : GCCBuiltin<"__builtin_lasx_xvfcvtl_s_h">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcvtl_d_s : GCCBuiltin<"__builtin_lasx_xvfcvtl_d_s">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v8f32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfcvth_s_h : GCCBuiltin<"__builtin_lasx_xvfcvth_s_h">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfcvth_d_s : GCCBuiltin<"__builtin_lasx_xvfcvth_d_s">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v8f32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftint_w_s : GCCBuiltin<"__builtin_lasx_xvftint_w_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftint_l_d : GCCBuiltin<"__builtin_lasx_xvftint_l_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftint_wu_s : GCCBuiltin<"__builtin_lasx_xvftint_wu_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftint_lu_d : GCCBuiltin<"__builtin_lasx_xvftint_lu_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrlri_b : GCCBuiltin<"__builtin_lasx_xvsrlri_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlri_h : GCCBuiltin<"__builtin_lasx_xvsrlri_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlri_w : GCCBuiltin<"__builtin_lasx_xvsrlri_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlri_d : GCCBuiltin<"__builtin_lasx_xvsrlri_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrari_b : GCCBuiltin<"__builtin_lasx_xvsrari_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrari_h : GCCBuiltin<"__builtin_lasx_xvsrari_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrari_w : GCCBuiltin<"__builtin_lasx_xvsrari_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrari_d : GCCBuiltin<"__builtin_lasx_xvsrari_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsat_b : GCCBuiltin<"__builtin_lasx_xvsat_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsat_h : GCCBuiltin<"__builtin_lasx_xvsat_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsat_w : GCCBuiltin<"__builtin_lasx_xvsat_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsat_d : GCCBuiltin<"__builtin_lasx_xvsat_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsat_bu : GCCBuiltin<"__builtin_lasx_xvsat_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsat_hu : GCCBuiltin<"__builtin_lasx_xvsat_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsat_wu : GCCBuiltin<"__builtin_lasx_xvsat_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsat_du : GCCBuiltin<"__builtin_lasx_xvsat_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrlni_b_h : GCCBuiltin<"__builtin_lasx_xvsrlni_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlni_h_w : GCCBuiltin<"__builtin_lasx_xvsrlni_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlni_w_d : GCCBuiltin<"__builtin_lasx_xvsrlni_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlni_d_q : GCCBuiltin<"__builtin_lasx_xvsrlni_d_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrlni_b_h : GCCBuiltin<"__builtin_lasx_xvssrlni_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlni_h_w : GCCBuiltin<"__builtin_lasx_xvssrlni_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlni_w_d : GCCBuiltin<"__builtin_lasx_xvssrlni_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlni_d_q : GCCBuiltin<"__builtin_lasx_xvssrlni_d_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrlrni_bu_h : GCCBuiltin<"__builtin_lasx_xvssrlrni_bu_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlrni_hu_w : GCCBuiltin<"__builtin_lasx_xvssrlrni_hu_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlrni_wu_d : GCCBuiltin<"__builtin_lasx_xvssrlrni_wu_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlrni_du_q : GCCBuiltin<"__builtin_lasx_xvssrlrni_du_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrarni_b_h : GCCBuiltin<"__builtin_lasx_xvsrarni_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrarni_h_w : GCCBuiltin<"__builtin_lasx_xvsrarni_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrarni_w_d : GCCBuiltin<"__builtin_lasx_xvsrarni_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrarni_d_q : GCCBuiltin<"__builtin_lasx_xvsrarni_d_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrani_b_h : GCCBuiltin<"__builtin_lasx_xvssrani_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrani_h_w : GCCBuiltin<"__builtin_lasx_xvssrani_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrani_w_d : GCCBuiltin<"__builtin_lasx_xvssrani_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrani_d_q : GCCBuiltin<"__builtin_lasx_xvssrani_d_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrani_bu_h : GCCBuiltin<"__builtin_lasx_xvssrani_bu_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrani_hu_w : GCCBuiltin<"__builtin_lasx_xvssrani_hu_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrani_wu_d : GCCBuiltin<"__builtin_lasx_xvssrani_wu_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrani_du_q : GCCBuiltin<"__builtin_lasx_xvssrani_du_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrarni_b_h : GCCBuiltin<"__builtin_lasx_xvssrarni_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrarni_h_w : GCCBuiltin<"__builtin_lasx_xvssrarni_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrarni_w_d : GCCBuiltin<"__builtin_lasx_xvssrarni_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrarni_d_q : GCCBuiltin<"__builtin_lasx_xvssrarni_d_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrarni_bu_h : GCCBuiltin<"__builtin_lasx_xvssrarni_bu_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrarni_hu_w : GCCBuiltin<"__builtin_lasx_xvssrarni_hu_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrarni_wu_d : GCCBuiltin<"__builtin_lasx_xvssrarni_wu_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrarni_du_q : GCCBuiltin<"__builtin_lasx_xvssrarni_du_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvssrlni_bu_h : GCCBuiltin<"__builtin_lasx_xvssrlni_bu_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlni_hu_w : GCCBuiltin<"__builtin_lasx_xvssrlni_hu_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlni_wu_d : GCCBuiltin<"__builtin_lasx_xvssrlni_wu_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvssrlni_du_q : GCCBuiltin<"__builtin_lasx_xvssrlni_du_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvseq_b : GCCBuiltin<"__builtin_lasx_xvseq_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvseq_h : GCCBuiltin<"__builtin_lasx_xvseq_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvseq_w : GCCBuiltin<"__builtin_lasx_xvseq_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvseq_d : GCCBuiltin<"__builtin_lasx_xvseq_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsle_b : GCCBuiltin<"__builtin_lasx_xvsle_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsle_h : GCCBuiltin<"__builtin_lasx_xvsle_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsle_w : GCCBuiltin<"__builtin_lasx_xvsle_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsle_d : GCCBuiltin<"__builtin_lasx_xvsle_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsle_bu : GCCBuiltin<"__builtin_lasx_xvsle_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsle_hu : GCCBuiltin<"__builtin_lasx_xvsle_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsle_wu : GCCBuiltin<"__builtin_lasx_xvsle_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsle_du : GCCBuiltin<"__builtin_lasx_xvsle_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvslt_b : GCCBuiltin<"__builtin_lasx_xvslt_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslt_h : GCCBuiltin<"__builtin_lasx_xvslt_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslt_w : GCCBuiltin<"__builtin_lasx_xvslt_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslt_d : GCCBuiltin<"__builtin_lasx_xvslt_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvslt_bu : GCCBuiltin<"__builtin_lasx_xvslt_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslt_hu : GCCBuiltin<"__builtin_lasx_xvslt_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslt_wu : GCCBuiltin<"__builtin_lasx_xvslt_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslt_du : GCCBuiltin<"__builtin_lasx_xvslt_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvadd_b : GCCBuiltin<"__builtin_lasx_xvadd_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvadd_h : GCCBuiltin<"__builtin_lasx_xvadd_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvadd_w : GCCBuiltin<"__builtin_lasx_xvadd_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvadd_d : GCCBuiltin<"__builtin_lasx_xvadd_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lasx_xvsub_b : GCCBuiltin<"__builtin_lasx_xvsub_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsub_h : GCCBuiltin<"__builtin_lasx_xvsub_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsub_w : GCCBuiltin<"__builtin_lasx_xvsub_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsub_d : GCCBuiltin<"__builtin_lasx_xvsub_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmax_b : GCCBuiltin<"__builtin_lasx_xvmax_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmax_h : GCCBuiltin<"__builtin_lasx_xvmax_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmax_w : GCCBuiltin<"__builtin_lasx_xvmax_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmax_d : GCCBuiltin<"__builtin_lasx_xvmax_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmin_b : GCCBuiltin<"__builtin_lasx_xvmin_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmin_h : GCCBuiltin<"__builtin_lasx_xvmin_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmin_w : GCCBuiltin<"__builtin_lasx_xvmin_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmin_d : GCCBuiltin<"__builtin_lasx_xvmin_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmax_bu : GCCBuiltin<"__builtin_lasx_xvmax_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmax_hu : GCCBuiltin<"__builtin_lasx_xvmax_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmax_wu : GCCBuiltin<"__builtin_lasx_xvmax_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmax_du : GCCBuiltin<"__builtin_lasx_xvmax_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmin_bu : GCCBuiltin<"__builtin_lasx_xvmin_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmin_hu : GCCBuiltin<"__builtin_lasx_xvmin_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmin_wu : GCCBuiltin<"__builtin_lasx_xvmin_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmin_du : GCCBuiltin<"__builtin_lasx_xvmin_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmul_b : GCCBuiltin<"__builtin_lasx_xvmul_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmul_h : GCCBuiltin<"__builtin_lasx_xvmul_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmul_w : GCCBuiltin<"__builtin_lasx_xvmul_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmul_d : GCCBuiltin<"__builtin_lasx_xvmul_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmadd_b : GCCBuiltin<"__builtin_lasx_xvmadd_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvmadd_h : GCCBuiltin<"__builtin_lasx_xvmadd_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvmadd_w : GCCBuiltin<"__builtin_lasx_xvmadd_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvmadd_d : GCCBuiltin<"__builtin_lasx_xvmadd_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty],
  [IntrNoMem]>;

def int_loongarch_lasx_xvmsub_b : GCCBuiltin<"__builtin_lasx_xvmsub_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_v32i8_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvmsub_h : GCCBuiltin<"__builtin_lasx_xvmsub_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_v16i16_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvmsub_w : GCCBuiltin<"__builtin_lasx_xvmsub_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_v8i32_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvmsub_d : GCCBuiltin<"__builtin_lasx_xvmsub_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty],
  [IntrNoMem]>;

def int_loongarch_lasx_xvdiv_b : GCCBuiltin<"__builtin_lasx_xvdiv_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvdiv_h : GCCBuiltin<"__builtin_lasx_xvdiv_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvdiv_w : GCCBuiltin<"__builtin_lasx_xvdiv_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvdiv_d : GCCBuiltin<"__builtin_lasx_xvdiv_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmod_b : GCCBuiltin<"__builtin_lasx_xvmod_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmod_h : GCCBuiltin<"__builtin_lasx_xvmod_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmod_w : GCCBuiltin<"__builtin_lasx_xvmod_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmod_d : GCCBuiltin<"__builtin_lasx_xvmod_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvdiv_bu : GCCBuiltin<"__builtin_lasx_xvdiv_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvdiv_hu : GCCBuiltin<"__builtin_lasx_xvdiv_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvdiv_wu : GCCBuiltin<"__builtin_lasx_xvdiv_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvdiv_du : GCCBuiltin<"__builtin_lasx_xvdiv_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsll_b : GCCBuiltin<"__builtin_lasx_xvsll_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsll_h : GCCBuiltin<"__builtin_lasx_xvsll_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsll_w : GCCBuiltin<"__builtin_lasx_xvsll_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsll_d : GCCBuiltin<"__builtin_lasx_xvsll_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrl_b : GCCBuiltin<"__builtin_lasx_xvsrl_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrl_h : GCCBuiltin<"__builtin_lasx_xvsrl_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrl_w : GCCBuiltin<"__builtin_lasx_xvsrl_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrl_d : GCCBuiltin<"__builtin_lasx_xvsrl_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvbitclr_b : GCCBuiltin<"__builtin_lasx_xvbitclr_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitclr_h : GCCBuiltin<"__builtin_lasx_xvbitclr_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitclr_w : GCCBuiltin<"__builtin_lasx_xvbitclr_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitclr_d : GCCBuiltin<"__builtin_lasx_xvbitclr_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvbitset_b : GCCBuiltin<"__builtin_lasx_xvbitset_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitset_h : GCCBuiltin<"__builtin_lasx_xvbitset_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitset_w : GCCBuiltin<"__builtin_lasx_xvbitset_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitset_d : GCCBuiltin<"__builtin_lasx_xvbitset_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpackev_b : GCCBuiltin<"__builtin_lasx_xvpackev_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpackev_h : GCCBuiltin<"__builtin_lasx_xvpackev_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpackev_w : GCCBuiltin<"__builtin_lasx_xvpackev_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpackev_d : GCCBuiltin<"__builtin_lasx_xvpackev_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpackod_b : GCCBuiltin<"__builtin_lasx_xvpackod_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpackod_h : GCCBuiltin<"__builtin_lasx_xvpackod_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpackod_w : GCCBuiltin<"__builtin_lasx_xvpackod_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpackod_d : GCCBuiltin<"__builtin_lasx_xvpackod_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvilvl_b : GCCBuiltin<"__builtin_lasx_xvilvl_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvilvl_h : GCCBuiltin<"__builtin_lasx_xvilvl_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvilvl_w : GCCBuiltin<"__builtin_lasx_xvilvl_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvilvl_d : GCCBuiltin<"__builtin_lasx_xvilvl_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvilvh_b : GCCBuiltin<"__builtin_lasx_xvilvh_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvilvh_h : GCCBuiltin<"__builtin_lasx_xvilvh_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvilvh_w : GCCBuiltin<"__builtin_lasx_xvilvh_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvilvh_d : GCCBuiltin<"__builtin_lasx_xvilvh_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpickev_b : GCCBuiltin<"__builtin_lasx_xvpickev_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpickev_h : GCCBuiltin<"__builtin_lasx_xvpickev_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpickev_w : GCCBuiltin<"__builtin_lasx_xvpickev_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpickev_d : GCCBuiltin<"__builtin_lasx_xvpickev_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvand_v : GCCBuiltin<"__builtin_lasx_xvand_v">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvor_v : GCCBuiltin<"__builtin_lasx_xvor_v">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvbitrev_b : GCCBuiltin<"__builtin_lasx_xvbitrev_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitrev_h : GCCBuiltin<"__builtin_lasx_xvbitrev_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitrev_w : GCCBuiltin<"__builtin_lasx_xvbitrev_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvbitrev_d : GCCBuiltin<"__builtin_lasx_xvbitrev_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmod_bu : GCCBuiltin<"__builtin_lasx_xvmod_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmod_hu : GCCBuiltin<"__builtin_lasx_xvmod_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmod_wu : GCCBuiltin<"__builtin_lasx_xvmod_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmod_du : GCCBuiltin<"__builtin_lasx_xvmod_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpickod_b : GCCBuiltin<"__builtin_lasx_xvpickod_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpickod_h : GCCBuiltin<"__builtin_lasx_xvpickod_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpickod_w : GCCBuiltin<"__builtin_lasx_xvpickod_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpickod_d : GCCBuiltin<"__builtin_lasx_xvpickod_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvreplve_b : GCCBuiltin<"__builtin_lasx_xvreplve_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvreplve_h : GCCBuiltin<"__builtin_lasx_xvreplve_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvreplve_w : GCCBuiltin<"__builtin_lasx_xvreplve_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvreplve_d : GCCBuiltin<"__builtin_lasx_xvreplve_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsra_b : GCCBuiltin<"__builtin_lasx_xvsra_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsra_h : GCCBuiltin<"__builtin_lasx_xvsra_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsra_w : GCCBuiltin<"__builtin_lasx_xvsra_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsra_d : GCCBuiltin<"__builtin_lasx_xvsra_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvxor_v : GCCBuiltin<"__builtin_lasx_xvxor_v">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvnor_v : GCCBuiltin<"__builtin_lasx_xvnor_v">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfadd_s : GCCBuiltin<"__builtin_lasx_xvfadd_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfadd_d : GCCBuiltin<"__builtin_lasx_xvfadd_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfsub_s : GCCBuiltin<"__builtin_lasx_xvfsub_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfsub_d : GCCBuiltin<"__builtin_lasx_xvfsub_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfmul_s : GCCBuiltin<"__builtin_lasx_xvfmul_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfmul_d : GCCBuiltin<"__builtin_lasx_xvfmul_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvshuf_h : GCCBuiltin<"__builtin_lasx_xvshuf_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_v16i16_ty],
            [IntrNoMem]>;
def int_loongarch_lasx_xvshuf_w : GCCBuiltin<"__builtin_lasx_xvshuf_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_v8i32_ty],
            [IntrNoMem]>;
def int_loongarch_lasx_xvshuf_d : GCCBuiltin<"__builtin_lasx_xvshuf_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_v4i64_ty],
            [IntrNoMem]>;

def int_loongarch_lasx_xvseqi_b : GCCBuiltin<"__builtin_lasx_xvseqi_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvseqi_h : GCCBuiltin<"__builtin_lasx_xvseqi_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvseqi_w : GCCBuiltin<"__builtin_lasx_xvseqi_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvseqi_d : GCCBuiltin<"__builtin_lasx_xvseqi_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvslei_b : GCCBuiltin<"__builtin_lasx_xvslei_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslei_h : GCCBuiltin<"__builtin_lasx_xvslei_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslei_w : GCCBuiltin<"__builtin_lasx_xvslei_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslei_d : GCCBuiltin<"__builtin_lasx_xvslei_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvslei_bu : GCCBuiltin<"__builtin_lasx_xvslei_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslei_hu : GCCBuiltin<"__builtin_lasx_xvslei_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslei_wu : GCCBuiltin<"__builtin_lasx_xvslei_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslei_du : GCCBuiltin<"__builtin_lasx_xvslei_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvslti_b : GCCBuiltin<"__builtin_lasx_xvslti_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslti_h : GCCBuiltin<"__builtin_lasx_xvslti_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslti_w : GCCBuiltin<"__builtin_lasx_xvslti_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslti_d : GCCBuiltin<"__builtin_lasx_xvslti_d">,
 Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;
 
def int_loongarch_lasx_xvslti_bu : GCCBuiltin<"__builtin_lasx_xvslti_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslti_hu : GCCBuiltin<"__builtin_lasx_xvslti_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslti_wu : GCCBuiltin<"__builtin_lasx_xvslti_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslti_du : GCCBuiltin<"__builtin_lasx_xvslti_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvaddi_bu : GCCBuiltin<"__builtin_lasx_xvaddi_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvaddi_hu : GCCBuiltin<"__builtin_lasx_xvaddi_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvaddi_wu : GCCBuiltin<"__builtin_lasx_xvaddi_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty],
  [Commutative, IntrNoMem]>;
def int_loongarch_lasx_xvaddi_du : GCCBuiltin<"__builtin_lasx_xvaddi_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty],
  [Commutative, IntrNoMem]>;

def int_loongarch_lasx_xvsubi_bu : GCCBuiltin<"__builtin_lasx_xvsubi_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubi_hu : GCCBuiltin<"__builtin_lasx_xvsubi_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubi_wu : GCCBuiltin<"__builtin_lasx_xvsubi_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsubi_du : GCCBuiltin<"__builtin_lasx_xvsubi_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmaxi_b : GCCBuiltin<"__builtin_lasx_xvmaxi_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaxi_h : GCCBuiltin<"__builtin_lasx_xvmaxi_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaxi_w : GCCBuiltin<"__builtin_lasx_xvmaxi_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaxi_d : GCCBuiltin<"__builtin_lasx_xvmaxi_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmini_b : GCCBuiltin<"__builtin_lasx_xvmini_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmini_h : GCCBuiltin<"__builtin_lasx_xvmini_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmini_w : GCCBuiltin<"__builtin_lasx_xvmini_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmini_d : GCCBuiltin<"__builtin_lasx_xvmini_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmaxi_bu : GCCBuiltin<"__builtin_lasx_xvmaxi_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaxi_hu : GCCBuiltin<"__builtin_lasx_xvmaxi_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaxi_wu : GCCBuiltin<"__builtin_lasx_xvmaxi_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmaxi_du : GCCBuiltin<"__builtin_lasx_xvmaxi_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvmini_bu : GCCBuiltin<"__builtin_lasx_xvmini_bu">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmini_hu : GCCBuiltin<"__builtin_lasx_xvmini_hu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmini_wu : GCCBuiltin<"__builtin_lasx_xvmini_wu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvmini_du : GCCBuiltin<"__builtin_lasx_xvmini_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvclz_b : GCCBuiltin<"__builtin_lasx_xvclz_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvclz_h : GCCBuiltin<"__builtin_lasx_xvclz_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvclz_w : GCCBuiltin<"__builtin_lasx_xvclz_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvclz_d : GCCBuiltin<"__builtin_lasx_xvclz_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpcnt_b : GCCBuiltin<"__builtin_lasx_xvpcnt_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpcnt_h : GCCBuiltin<"__builtin_lasx_xvpcnt_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpcnt_w : GCCBuiltin<"__builtin_lasx_xvpcnt_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpcnt_d : GCCBuiltin<"__builtin_lasx_xvpcnt_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfsqrt_s : GCCBuiltin<"__builtin_lasx_xvfsqrt_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfsqrt_d : GCCBuiltin<"__builtin_lasx_xvfsqrt_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvfrint_s : GCCBuiltin<"__builtin_lasx_xvfrint_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfrint_d : GCCBuiltin<"__builtin_lasx_xvfrint_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvffint_s_w : GCCBuiltin<"__builtin_lasx_xvffint_s_w">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvffint_d_l : GCCBuiltin<"__builtin_lasx_xvffint_d_l">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvffint_s_wu : GCCBuiltin<"__builtin_lasx_xvffint_s_wu">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvffint_d_lu : GCCBuiltin<"__builtin_lasx_xvffint_d_lu">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvftintrz_wu_s : GCCBuiltin<"__builtin_lasx_xvftintrz_wu_s">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvftintrz_lu_d : GCCBuiltin<"__builtin_lasx_xvftintrz_lu_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvreplgr2vr_b : GCCBuiltin<"__builtin_lasx_xvreplgr2vr_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvreplgr2vr_h : GCCBuiltin<"__builtin_lasx_xvreplgr2vr_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvreplgr2vr_w : GCCBuiltin<"__builtin_lasx_xvreplgr2vr_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvreplgr2vr_d : GCCBuiltin<"__builtin_lasx_xvreplgr2vr_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvinsgr2vr_w : GCCBuiltin<"__builtin_lasx_xvinsgr2vr_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty, llvm_i32_ty],
  [IntrNoMem]>;
def int_loongarch_lasx_xvinsgr2vr_d : GCCBuiltin<"__builtin_lasx_xvinsgr2vr_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i64_ty, llvm_i32_ty],
  [IntrNoMem]>;

def int_loongarch_lasx_xvfdiv_s : GCCBuiltin<"__builtin_lasx_xvfdiv_s">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_v8f32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvfdiv_d : GCCBuiltin<"__builtin_lasx_xvfdiv_d">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_v4f64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvslli_b : GCCBuiltin<"__builtin_lasx_xvslli_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslli_h : GCCBuiltin<"__builtin_lasx_xvslli_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslli_w : GCCBuiltin<"__builtin_lasx_xvslli_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvslli_d : GCCBuiltin<"__builtin_lasx_xvslli_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrli_b : GCCBuiltin<"__builtin_lasx_xvsrli_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrli_h : GCCBuiltin<"__builtin_lasx_xvsrli_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrli_w : GCCBuiltin<"__builtin_lasx_xvsrli_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrli_d : GCCBuiltin<"__builtin_lasx_xvsrli_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrai_b : GCCBuiltin<"__builtin_lasx_xvsrai_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrai_h : GCCBuiltin<"__builtin_lasx_xvsrai_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrai_w : GCCBuiltin<"__builtin_lasx_xvsrai_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrai_d : GCCBuiltin<"__builtin_lasx_xvsrai_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvshuf4i_b : GCCBuiltin<"__builtin_lasx_xvshuf4i_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvshuf4i_h : GCCBuiltin<"__builtin_lasx_xvshuf4i_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvshuf4i_w : GCCBuiltin<"__builtin_lasx_xvshuf4i_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvshuf4i_d : GCCBuiltin<"__builtin_lasx_xvshuf4i_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvrotr_b : GCCBuiltin<"__builtin_lasx_xvrotr_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvrotr_h : GCCBuiltin<"__builtin_lasx_xvrotr_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvrotr_w : GCCBuiltin<"__builtin_lasx_xvrotr_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvrotr_d : GCCBuiltin<"__builtin_lasx_xvrotr_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvrotri_b : GCCBuiltin<"__builtin_lasx_xvrotri_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvrotri_h : GCCBuiltin<"__builtin_lasx_xvrotri_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvrotri_w : GCCBuiltin<"__builtin_lasx_xvrotri_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvrotri_d : GCCBuiltin<"__builtin_lasx_xvrotri_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvld : GCCBuiltin<"__builtin_lasx_xvld">,
  Intrinsic<[llvm_v32i8_ty], [llvm_ptr_ty, llvm_i32_ty],
  [IntrReadMem, IntrArgMemOnly]>;

def int_loongarch_lasx_xvst : GCCBuiltin<"__builtin_lasx_xvst">,
  Intrinsic<[], [llvm_v32i8_ty, llvm_ptr_ty, llvm_i32_ty],
  [IntrArgMemOnly]>;

def int_loongarch_lasx_xvrepl128vei_b : GCCBuiltin<"__builtin_lasx_xvrepl128vei_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvrepl128vei_h : GCCBuiltin<"__builtin_lasx_xvrepl128vei_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvrepl128vei_w : GCCBuiltin<"__builtin_lasx_xvrepl128vei_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvrepl128vei_d : GCCBuiltin<"__builtin_lasx_xvrepl128vei_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvinsve0_w : GCCBuiltin<"__builtin_lasx_xvinsve0_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvinsve0_d : GCCBuiltin<"__builtin_lasx_xvinsve0_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpickve_w : GCCBuiltin<"__builtin_lasx_xvpickve_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpickve_d : GCCBuiltin<"__builtin_lasx_xvpickve_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpickve_w_f : GCCBuiltin<"__builtin_lasx_xvpickve_w_f">,
  Intrinsic<[llvm_v8f32_ty], [llvm_v8f32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpickve_d_f : GCCBuiltin<"__builtin_lasx_xvpickve_d_f">,
  Intrinsic<[llvm_v4f64_ty], [llvm_v4f64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvreplve0_b : GCCBuiltin<"__builtin_lasx_xvreplve0_b">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvreplve0_h : GCCBuiltin<"__builtin_lasx_xvreplve0_h">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvreplve0_w : GCCBuiltin<"__builtin_lasx_xvreplve0_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvreplve0_d : GCCBuiltin<"__builtin_lasx_xvreplve0_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvreplve0_q : GCCBuiltin<"__builtin_lasx_xvreplve0_q">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_vext2xv_d_w : GCCBuiltin<"__builtin_lasx_vext2xv_d_w">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_vext2xv_w_h : GCCBuiltin<"__builtin_lasx_vext2xv_w_h">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_vext2xv_h_b : GCCBuiltin<"__builtin_lasx_vext2xv_h_b">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_vext2xv_d_h : GCCBuiltin<"__builtin_lasx_vext2xv_d_h">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_vext2xv_w_b : GCCBuiltin<"__builtin_lasx_vext2xv_w_b">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_vext2xv_d_b : GCCBuiltin<"__builtin_lasx_vext2xv_d_b">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_vext2xv_du_wu : GCCBuiltin<"__builtin_lasx_vext2xv_du_wu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_vext2xv_wu_hu : GCCBuiltin<"__builtin_lasx_vext2xv_wu_hu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_vext2xv_hu_bu : GCCBuiltin<"__builtin_lasx_vext2xv_hu_bu">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_vext2xv_du_hu : GCCBuiltin<"__builtin_lasx_vext2xv_du_hu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_vext2xv_wu_bu : GCCBuiltin<"__builtin_lasx_vext2xv_wu_bu">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_vext2xv_du_bu : GCCBuiltin<"__builtin_lasx_vext2xv_du_bu">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvpermi_q : GCCBuiltin<"__builtin_lasx_xvpermi_q">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvpermi_d : GCCBuiltin<"__builtin_lasx_xvpermi_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvperm_w : GCCBuiltin<"__builtin_lasx_xvperm_w">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvsrlrni_b_h : GCCBuiltin<"__builtin_lasx_xvsrlrni_b_h">,
  Intrinsic<[llvm_v32i8_ty], [llvm_v32i8_ty, llvm_v32i8_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlrni_h_w : GCCBuiltin<"__builtin_lasx_xvsrlrni_h_w">,
  Intrinsic<[llvm_v16i16_ty], [llvm_v16i16_ty, llvm_v16i16_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlrni_w_d : GCCBuiltin<"__builtin_lasx_xvsrlrni_w_d">,
  Intrinsic<[llvm_v8i32_ty], [llvm_v8i32_ty, llvm_v8i32_ty, llvm_i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvsrlrni_d_q : GCCBuiltin<"__builtin_lasx_xvsrlrni_d_q">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty, llvm_v4i64_ty, llvm_i32_ty], [IntrNoMem]>;

def int_loongarch_lasx_xbz_v : GCCBuiltin<"__builtin_lasx_xbz_v">,
  Intrinsic<[llvm_i32_ty], [llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xbnz_v : GCCBuiltin<"__builtin_lasx_xbnz_v">,
  Intrinsic<[llvm_i32_ty], [llvm_v32i8_ty], [IntrNoMem]>;

def int_loongarch_lasx_xbz_b : GCCBuiltin<"__builtin_lasx_xbz_b">,
  Intrinsic<[llvm_i32_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xbz_h : GCCBuiltin<"__builtin_lasx_xbz_h">,
  Intrinsic<[llvm_i32_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xbz_w : GCCBuiltin<"__builtin_lasx_xbz_w">,
  Intrinsic<[llvm_i32_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xbz_d : GCCBuiltin<"__builtin_lasx_xbz_d">,
  Intrinsic<[llvm_i32_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xbnz_b : GCCBuiltin<"__builtin_lasx_xbnz_b">,
  Intrinsic<[llvm_i32_ty], [llvm_v32i8_ty], [IntrNoMem]>;
def int_loongarch_lasx_xbnz_h : GCCBuiltin<"__builtin_lasx_xbnz_h">,
  Intrinsic<[llvm_i32_ty], [llvm_v16i16_ty], [IntrNoMem]>;
def int_loongarch_lasx_xbnz_w : GCCBuiltin<"__builtin_lasx_xbnz_w">,
  Intrinsic<[llvm_i32_ty], [llvm_v8i32_ty], [IntrNoMem]>;
def int_loongarch_lasx_xbnz_d : GCCBuiltin<"__builtin_lasx_xbnz_d">,
  Intrinsic<[llvm_i32_ty], [llvm_v4i64_ty], [IntrNoMem]>;

def int_loongarch_lasx_xvextl_q_d : GCCBuiltin<"__builtin_lasx_xvextl_q_d">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty], [IntrNoMem]>;
def int_loongarch_lasx_xvextl_qu_du : GCCBuiltin<"__builtin_lasx_xvextl_qu_du">,
  Intrinsic<[llvm_v4i64_ty], [llvm_v4i64_ty], [IntrNoMem]>;

//===----------------------------------------------------------------------===//
// LoongArch BASE

def int_loongarch_cpucfg : GCCBuiltin<"__builtin_loongarch_cpucfg">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty], []>;

def int_loongarch_csrrd_w : GCCBuiltin<"__builtin_loongarch_csrrd_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty], []>;

def int_loongarch_csrrd_d : GCCBuiltin<"__builtin_loongarch_csrrd_d">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty], []>;

def int_loongarch_csrwr_w : GCCBuiltin<"__builtin_loongarch_csrwr_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_csrwr_d : GCCBuiltin<"__builtin_loongarch_csrwr_d">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty], []>;

def int_loongarch_csrxchg_w : GCCBuiltin<"__builtin_loongarch_csrxchg_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_csrxchg_d : GCCBuiltin<"__builtin_loongarch_csrxchg_d">,
  Intrinsic<[llvm_i64_ty], [llvm_i64_ty, llvm_i64_ty, llvm_i64_ty], []>;

def int_loongarch_iocsrrd_b : GCCBuiltin<"__builtin_loongarch_iocsrrd_b">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty], []>;

def int_loongarch_iocsrrd_h : GCCBuiltin<"__builtin_loongarch_iocsrrd_h">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty], []>;

def int_loongarch_iocsrrd_w : GCCBuiltin<"__builtin_loongarch_iocsrrd_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty], []>;

def int_loongarch_iocsrrd_d : GCCBuiltin<"__builtin_loongarch_iocsrrd_d">,
  Intrinsic<[llvm_i64_ty], [llvm_i32_ty], []>;

def int_loongarch_iocsrwr_b : GCCBuiltin<"__builtin_loongarch_iocsrwr_b">,
  Intrinsic<[], [llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_iocsrwr_h : GCCBuiltin<"__builtin_loongarch_iocsrwr_h">,
  Intrinsic<[], [llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_iocsrwr_w : GCCBuiltin<"__builtin_loongarch_iocsrwr_w">,
  Intrinsic<[], [llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_iocsrwr_d : GCCBuiltin<"__builtin_loongarch_iocsrwr_d">,
  Intrinsic<[], [llvm_i64_ty, llvm_i32_ty], []>;

def int_loongarch_cacop_w : GCCBuiltin<"__builtin_loongarch_cacop_w">,
  Intrinsic<[], [llvm_i32_ty, llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_cacop_d : GCCBuiltin<"__builtin_loongarch_cacop_d">,
  Intrinsic<[], [llvm_i32_ty, llvm_i64_ty, llvm_i64_ty], []>;

def int_loongarch_crc_w_b_w : GCCBuiltin<"__builtin_loongarch_crc_w_b_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_crc_w_h_w : GCCBuiltin<"__builtin_loongarch_crc_w_h_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_crc_w_w_w : GCCBuiltin<"__builtin_loongarch_crc_w_w_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_crc_w_d_w : GCCBuiltin<"__builtin_loongarch_crc_w_d_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i64_ty, llvm_i32_ty], []>;

def int_loongarch_crcc_w_b_w : GCCBuiltin<"__builtin_loongarch_crcc_w_b_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_crcc_w_h_w : GCCBuiltin<"__builtin_loongarch_crcc_w_h_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_crcc_w_w_w : GCCBuiltin<"__builtin_loongarch_crcc_w_w_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], []>;

def int_loongarch_crcc_w_d_w : GCCBuiltin<"__builtin_loongarch_crcc_w_d_w">,
  Intrinsic<[llvm_i32_ty], [llvm_i64_ty, llvm_i32_ty], []>;

def int_loongarch_tlbclr : GCCBuiltin<"__builtin_loongarch_tlbclr">,
  Intrinsic<[], [], []>;

def int_loongarch_tlbflush : GCCBuiltin<"__builtin_loongarch_tlbflush">,
  Intrinsic<[], [], []>;

def int_loongarch_tlbfill : GCCBuiltin<"__builtin_loongarch_tlbfill">,
  Intrinsic<[], [], []>;

def int_loongarch_tlbrd : GCCBuiltin<"__builtin_loongarch_tlbrd">,
  Intrinsic<[], [], []>;

def int_loongarch_tlbwr : GCCBuiltin<"__builtin_loongarch_tlbwr">,
  Intrinsic<[], [], []>;

def int_loongarch_tlbsrch : GCCBuiltin<"__builtin_loongarch_tlbsrch">,
  Intrinsic<[], [], []>;

def int_loongarch_syscall : GCCBuiltin<"__builtin_loongarch_syscall">,
  Intrinsic<[], [llvm_i64_ty], []>;

def int_loongarch_break : GCCBuiltin<"__builtin_loongarch_break">,
  Intrinsic<[], [llvm_i64_ty], []>;

def int_loongarch_asrtle_d : GCCBuiltin<"__builtin_loongarch_asrtle_d">,
  Intrinsic<[], [llvm_i64_ty, llvm_i64_ty], []>;

def int_loongarch_asrtgt_d : GCCBuiltin<"__builtin_loongarch_asrtgt_d">,
  Intrinsic<[], [llvm_i64_ty, llvm_i64_ty], []>;

def int_loongarch_dbar : GCCBuiltin<"__builtin_loongarch_dbar">,
  Intrinsic<[], [llvm_i64_ty], []>;

def int_loongarch_ibar : GCCBuiltin<"__builtin_loongarch_ibar">,
  Intrinsic<[], [llvm_i64_ty], []>;

}
