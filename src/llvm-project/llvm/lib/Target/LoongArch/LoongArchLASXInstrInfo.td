//===- LoongArchLASXInstrInfo.td - loongson LASX instructions -*- tablegen ------------*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes loongson ASX instructions.
//
//===----------------------------------------------------------------------===//
def SDT_XVPERMI : SDTypeProfile<1, 2, [SDTCisVec<0>, SDTCisInt<0>,
                                       SDTCisSameAs<0, 1>,
                                       SDTCisVT<2, i32>]>;
def SDT_XVSHFI : SDTypeProfile<1, 3, [SDTCisInt<0>, SDTCisVec<0>,
                                      SDTCisSameAs<0, 1>, SDTCisSameAs<1, 2>,
                                      SDTCisVT<3, i32>]>;
def SDT_XVBROADCAST : SDTypeProfile<1, 1, [SDTCisVec<0>]>;

def SDT_INSVE : SDTypeProfile<1, 3, [SDTCisVec<0>, SDTCisSameAs<0, 1>,
                                     SDTCisSameAs<1, 2>,
                                     SDTCisVT<3, i32>]>;

def SDT_XVPICKVE : SDTypeProfile<1, 3, [SDTCisVec<0>, SDTCisSameAs<0, 1>,
                                        SDTCisSameAs<1, 2>,
                                        SDTCisVT<3, i32>]>;

def SDT_XVSHUF4I : SDTypeProfile<1, 3, [SDTCisVec<0>, SDTCisInt<0>,
                                        SDTCisSameAs<0, 1>,
                                        SDTCisSameAs<0, 2>,
                                        SDTCisVT<3, i32>]>;

def LoongArchXVSHUFI : SDNode<"LoongArchISD::XVSHFI", SDT_XVSHFI>;

def LoongArchXVSELI  : SDNode<"LoongArchISD::XVSELI", SDT_XVSHFI>;

def LoongArchXVPERMI : SDNode<"LoongArchISD::XVPERMI", SDT_XVPERMI>;

def LoongArchXVBROADCAST : SDNode<"LoongArchISD::XVBROADCAST", SDT_XVBROADCAST>;

def LoongArchINSVE : SDNode<"LoongArchISD::INSVE", SDT_INSVE>;

def LoongArchXVSHUF4I : SDNode<"LoongArchISD::XVSHUF4I", SDT_XVSHUF4I>;

def LoongArchXVPICKVE : SDNode<"LoongArchISD::XVPICKVE", SDT_INSVE>;

def xvbroadcast_v32i8  : PatFrag<(ops node:$v1),
                                  (v32i8 (LoongArchXVBROADCAST node:$v1))>;
def xvbroadcast_v16i16  : PatFrag<(ops node:$v1),
                                  (v16i16 (LoongArchXVBROADCAST node:$v1))>;
def xvbroadcast_v8i32  : PatFrag<(ops node:$v1),
                                  (v8i32 (LoongArchXVBROADCAST node:$v1))>;
def xvbroadcast_v4i64  : PatFrag<(ops node:$v1),
                                  (v4i64 (LoongArchXVBROADCAST node:$v1))>;


def vfseteq_v8f32 : vfsetcc_type<v8i32, v8f32, SETEQ>;
def vfseteq_v4f64 : vfsetcc_type<v4i64, v4f64, SETEQ>;
def vfsetge_v8f32 : vfsetcc_type<v8i32, v8f32, SETGE>;
def vfsetge_v4f64 : vfsetcc_type<v4i64, v4f64, SETGE>;
def vfsetgt_v8f32 : vfsetcc_type<v8i32, v8f32, SETGT>;
def vfsetgt_v4f64 : vfsetcc_type<v4i64, v4f64, SETGT>;
def vfsetle_v8f32 : vfsetcc_type<v8i32, v8f32, SETLE>;
def vfsetle_v4f64 : vfsetcc_type<v4i64, v4f64, SETLE>;
def vfsetlt_v8f32 : vfsetcc_type<v8i32, v8f32, SETLT>;
def vfsetlt_v4f64 : vfsetcc_type<v4i64, v4f64, SETLT>;
def vfsetne_v8f32 : vfsetcc_type<v8i32, v8f32, SETNE>;
def vfsetne_v4f64 : vfsetcc_type<v2i64, v4f64, SETNE>;
def vfsetoeq_v8f32 : vfsetcc_type<v8i32, v8f32, SETOEQ>;
def vfsetoeq_v4f64 : vfsetcc_type<v4i64, v4f64, SETOEQ>;
def vfsetoge_v8f32 : vfsetcc_type<v8i32, v8f32, SETOGE>;
def vfsetoge_v4f64 : vfsetcc_type<v4i64, v4f64, SETOGE>;
def vfsetogt_v8f32 : vfsetcc_type<v8i32, v8f32, SETOGT>;
def vfsetogt_v4f64 : vfsetcc_type<v4i64, v4f64, SETOGT>;
def vfsetole_v8f32 : vfsetcc_type<v8i32, v8f32, SETOLE>;
def vfsetole_v4f64 : vfsetcc_type<v4i64, v4f64, SETOLE>;
def vfsetolt_v8f32 : vfsetcc_type<v8i32, v8f32, SETOLT>;
def vfsetolt_v4f64 : vfsetcc_type<v4i64, v4f64, SETOLT>;
def vfsetone_v8f32 : vfsetcc_type<v8i32, v8f32, SETONE>;
def vfsetone_v4f64 : vfsetcc_type<v4i64, v4f64, SETONE>;
def vfsetord_v8f32 : vfsetcc_type<v8i32, v8f32, SETO>;
def vfsetord_v4f64 : vfsetcc_type<v4i64, v4f64, SETO>;
def vfsetun_v8f32  : vfsetcc_type<v8i32, v8f32, SETUO>;
def vfsetun_v4f64  : vfsetcc_type<v4i64, v4f64, SETUO>;
def vfsetueq_v8f32 : vfsetcc_type<v8i32, v8f32, SETUEQ>;
def vfsetueq_v4f64 : vfsetcc_type<v4i64, v4f64, SETUEQ>;
def vfsetuge_v8f32 : vfsetcc_type<v8i32, v8f32, SETUGE>;
def vfsetuge_v4f64 : vfsetcc_type<v4i64, v4f64, SETUGE>;
def vfsetugt_v8f32 : vfsetcc_type<v8i32, v8f32, SETUGT>;
def vfsetugt_v4f64 : vfsetcc_type<v4i64, v4f64, SETUGT>;
def vfsetule_v8f32 : vfsetcc_type<v8i32, v8f32, SETULE>;
def vfsetule_v4f64 : vfsetcc_type<v4i64, v4f64, SETULE>;
def vfsetult_v8f32 : vfsetcc_type<v8i32, v8f32, SETULT>;
def vfsetult_v4f64 : vfsetcc_type<v4i64, v4f64, SETULT>;
def vfsetune_v8f32 : vfsetcc_type<v8i32, v8f32, SETUNE>;
def vfsetune_v4f64 : vfsetcc_type<v4i64, v4f64, SETUNE>;

def xvsplati8  : PatFrag<(ops node:$e0),
                          (v32i8 (build_vector
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0))>;
def xvsplati16  : PatFrag<(ops node:$e0),
                           (v16i16 (build_vector
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0))>;
def xvsplati32  : PatFrag<(ops node:$e0),
                           (v8i32 (build_vector
                                node:$e0, node:$e0, node:$e0, node:$e0,
                                node:$e0, node:$e0, node:$e0, node:$e0))>;
def xvsplati64  : PatFrag<(ops node:$e0),
                           (v4i64 (build_vector
                                node:$e0, node:$e0, node:$e0, node:$e0))>;
def xvsplatf32 : PatFrag<(ops node:$e0),
                          (v8f32 (build_vector node:$e0, node:$e0,
                                             node:$e0, node:$e0))>;
def xvsplatf64 : PatFrag<(ops node:$e0),
                          (v4f64 (build_vector node:$e0, node:$e0))>;

def xvsplati8_uimm3 : SplatComplexPattern<vsplat_uimm3, v32i8, 1,
                                         "selectVSplatUimm3",
                                         [build_vector, bitconvert]>;
def xvsplati16_uimm4 : SplatComplexPattern<vsplat_uimm4, v16i16, 1,
                                          "selectVSplatUimm4",
                                          [build_vector, bitconvert]>;

def xvsplati64_uimm6 : SplatComplexPattern<vsplat_uimm6, v4i64, 1,
                                          "selectVSplatUimm6",
                                          [build_vector, bitconvert]>;

def xvsplati8_simm5 : SplatComplexPattern<vsplat_simm5, v32i8, 1,
                                          "selectVSplatSimm5",
                                          [build_vector, bitconvert]>;
def xvsplati16_simm5 : SplatComplexPattern<vsplat_simm5, v16i16, 1,
                                          "selectVSplatSimm5",
                                          [build_vector, bitconvert]>;
def xvsplati32_simm5 : SplatComplexPattern<vsplat_simm5, v8i32, 1,
                                          "selectVSplatSimm5",
                                          [build_vector, bitconvert]>;
def xvsplati64_simm5 : SplatComplexPattern<vsplat_simm5, v4i64, 1,
                                          "selectVSplatSimm5",
                                          [build_vector, bitconvert]>;

def xvsplat_imm_eq_1 : PatLeaf<(build_vector), [{
  APInt Imm;
  EVT EltTy = N->getValueType(0).getVectorElementType();
  return selectVSplat(N, Imm, EltTy.getSizeInBits()) &&
         Imm.getBitWidth() == EltTy.getSizeInBits() && Imm == 1;
}]>;

def xvsplati64_imm_eq_1 : PatLeaf<(bitconvert (v8i32 (build_vector))), [{
  APInt Imm;
  SDNode *BV = N->getOperand(0).getNode();
  EVT EltTy = N->getValueType(0).getVectorElementType();

  return selectVSplat(BV, Imm, EltTy.getSizeInBits()) &&
         Imm.getBitWidth() == EltTy.getSizeInBits() && Imm == 1;
}]>;

def xvbitclr_b : PatFrag<(ops node:$xk, node:$xa),
                         (and node:$xk, (xor (shl vsplat_imm_eq_1, node:$xa),
                                          immAllOnesV))>;
def xvbitclr_h : PatFrag<(ops node:$xk, node:$xa),
                         (and node:$xk, (xor (shl vsplat_imm_eq_1, node:$xa),
                                          immAllOnesV))>;
def xvbitclr_w : PatFrag<(ops node:$xk, node:$xa),
                         (and node:$xk, (xor (shl vsplat_imm_eq_1, node:$xa),
                                          immAllOnesV))>;
def xvbitclr_d : PatFrag<(ops node:$xk, node:$xa),
                         (and node:$xk, (xor (shl (v4i64 vsplati64_imm_eq_1),
                                               node:$xa),
                                          (bitconvert (v8i32 immAllOnesV))))>;



def xvsplati8_uimm5 : SplatComplexPattern<vsplat_uimm5, v32i8, 1,
                                         "selectVSplatUimm5",
                                         [build_vector, bitconvert]>;
def xvsplati16_uimm5 : SplatComplexPattern<vsplat_uimm5, v16i16, 1,
                                         "selectVSplatUimm5",
                                         [build_vector, bitconvert]>;
def xvsplati32_uimm5 : SplatComplexPattern<vsplat_uimm5, v8i32, 1,
                                         "selectVSplatUimm5",
                                         [build_vector, bitconvert]>;
def xvsplati64_uimm5 : SplatComplexPattern<vsplat_uimm5, v4i64, 1,
                                         "selectVSplatUimm5",
                                         [build_vector, bitconvert]>;
def xvsplati8_uimm8 : SplatComplexPattern<vsplat_uimm8, v32i8, 1,
                                         "selectVSplatUimm8",
                                         [build_vector, bitconvert]>;
def xvsplati16_uimm8 : SplatComplexPattern<vsplat_uimm8, v16i16, 1,
                                         "selectVSplatUimm8",
                                         [build_vector, bitconvert]>;
def xvsplati32_uimm8 : SplatComplexPattern<vsplat_uimm8, v8i32, 1,
                                         "selectVSplatUimm8",
                                         [build_vector, bitconvert]>;
def xvsplati64_uimm8 : SplatComplexPattern<vsplat_uimm8, v4i64, 1,
                                         "selectVSplatUimm8",
                                         [build_vector, bitconvert]>;



def xvsplati8_uimm4 : SplatComplexPattern<vsplat_uimm4, v32i8, 1,
                                         "selectVSplatUimm4",
                                         [build_vector, bitconvert]>;
def xvsplati16_uimm3 : SplatComplexPattern<vsplat_uimm3, v16i16, 1,
                                          "selectVSplatUimm3",
                                          [build_vector, bitconvert]>;
def xvsplati32_uimm2 : SplatComplexPattern<vsplat_uimm2, v8i32, 1,
                                          "selectVSplatUimm2",
                                          [build_vector, bitconvert]>;
def xvsplati64_uimm1 : SplatComplexPattern<vsplat_uimm1, v4i64, 1,
                                          "selectVSplatUimm1",
                                          [build_vector, bitconvert]>;


// Patterns.
class LASXPat<dag pattern, dag result, list<Predicate> pred = [HasLASX]> :
  Pat<pattern, result>, Requires<pred>;

class LASX_4RF<string instr_asm,
                       SDPatternOperator OpNode,
                       RegisterOperand ROXJ, RegisterOperand ROXA = ROXJ,
                       RegisterOperand ROXK = ROXA, RegisterOperand ROXD = ROXK> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ROXK:$xk, ROXA:$xa);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $xk, $xa");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, ROXK:$xk, ROXA:$xa))];
}

class LASX_3RF<string instr_asm,
                       SDPatternOperator OpNode,
                       RegisterOperand ROXJ,
                       RegisterOperand ROXK = ROXJ, RegisterOperand ROXD = ROXK> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ROXK:$xk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $xk");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, ROXK:$xk))];
}

class LASX_3R_SETCC_DESC_BASE<string instr_asm, CondCode CC, ValueType VT, RegisterOperand ROXD,
                                RegisterOperand ROXJ = ROXD, RegisterOperand ROXK = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ROXK:$xk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $xk");
  list<dag> Pattern = [(set ROXD:$xd, (VT (vsetcc ROXJ:$xj, ROXK:$xk, CC)))];
}

class LASX_LD<string instr_asm, SDPatternOperator OpNode,
                   ValueType TyNode, RegisterOperand ROXD,
                   Operand MemOpnd, ComplexPattern Addr = addr> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins MemOpnd:$addr);
  string AsmString = !strconcat(instr_asm, "\t$xd, $addr");
  list<dag> Pattern = [(set ROXD:$xd, (TyNode (OpNode Addr:$addr)))];
  string DecoderMethod = "DecodeLASX256Mem";
}

class LASX_ST<string instr_asm, SDPatternOperator OpNode,
                   ValueType TyNode, RegisterOperand ROXD,
                   Operand MemOpnd, ComplexPattern Addr = addrimm12> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROXD:$xd, MemOpnd:$addr);
  string AsmString = !strconcat(instr_asm, "\t$xd, $addr");
  list<dag> Pattern = [(OpNode (TyNode ROXD:$xd), Addr:$addr)];
  string DecoderMethod = "DecodeLASX256Mem";
}

class LASX_I8_U5_DESC_BASE<string instr_asm,
                       SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROXD,
                       RegisterOperand ROXJ> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROXD:$xd, PtrRC:$rj, ImmOp:$si8, uimm5:$idx);
  string AsmString = !strconcat(instr_asm, "\t$xd, $rj, $si8, $idx");
  list<dag> Pattern = [(OpNode ROXD:$xd, iPTR:$rj, Imm:$si8, immZExt5:$idx)];
  string DecoderMethod = "DecodeLASX256memstl";
}

class LASX_I8_U2_DESC_BASE<string instr_asm,
                       SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROXD,
                       RegisterOperand ROXJ> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROXD:$xd, PtrRC:$rj, ImmOp:$si8, uimm2:$idx);
  string AsmString = !strconcat(instr_asm, "\t$xd, $rj, $si8, $idx");
  list<dag> Pattern = [(OpNode ROXD:$xd, iPTR:$rj, Imm:$si8, immZExt2:$idx)];
  string DecoderMethod = "DecodeLASX256memstl";
}

class LASX_I8_U3_DESC_BASE<string instr_asm,
                       SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROXD,
                       RegisterOperand ROXJ> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROXD:$xd, PtrRC:$rj, ImmOp:$si8, uimm3:$idx);
  string AsmString = !strconcat(instr_asm, "\t$xd, $rj, $si8, $idx");
  list<dag> Pattern = [(OpNode ROXD:$xd, iPTR:$rj, Imm:$si8, immZExt3:$idx)];
  string DecoderMethod = "DecodeLASX256memstl";
}

class LASX_I8_U4_DESC_BASE<string instr_asm,
                       SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROXD,
                       RegisterOperand ROXJ> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROXD:$xd, PtrRC:$rj, ImmOp:$si8, uimm4:$idx);
  string AsmString = !strconcat(instr_asm, "\t$xd, $rj, $si8, $idx");
  list<dag> Pattern = [(OpNode ROXD:$xd, iPTR:$rj, Imm:$si8, immZExt4:$idx)];
  string DecoderMethod = "DecodeLASX256memstl";
}

class LASX_SDX_LA<string instr_asm,
                  SDPatternOperator OpNode,
                  RegisterOperand RORK,
                  RegisterOperand ROXD> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROXD:$xd, PtrRC:$rj, RORK:$rk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $rj, $rk");
  list<dag> Pattern = [(OpNode ROXD:$xd, iPTR:$rj, RORK:$rk)];
}

class LASX_3R_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       RegisterOperand ROXD, RegisterOperand ROXJ = ROXD,
                       RegisterOperand ROXK = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ROXK:$xk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $xk");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, ROXK:$xk))];
}

class LASX_LDX_LA<string instr_asm,
                  SDPatternOperator OpNode,
                  RegisterOperand RORK,
                  RegisterOperand ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins PtrRC:$rj, RORK:$rk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $rj, $rk");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode iPTR:$rj, RORK:$rk))];
}

class LASX_3R_4R_DESC_BASE<string instr_asm,
                          SDPatternOperator OpNode,
                          RegisterOperand ROXD, RegisterOperand ROXJ = ROXD,
                          RegisterOperand ROXK = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, ROXK:$xk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $xk");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXD:$xd_in, ROXJ:$xj,
                                              ROXK:$xk))];
  string Constraints = "$xd = $xd_in";
}


class LASX_3R_VREPLVE_DESC_BASE<string instr_asm,
                             SDPatternOperator OpNode,
                             RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, GPR32Opnd:$rk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $rk");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, GPR32Opnd:$rk))];
}


class LASX_3R_VREPLVE_DESC_BASE_N<string instr_asm,
                                RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, GPR64Opnd:$rk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $rk");
  list<dag> Pattern = [];
}


class LASX_VEC_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                        RegisterOperand ROXD, RegisterOperand ROXJ = ROXD,
                        RegisterOperand ROXK = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ROXK:$xk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $xk");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, ROXK:$xk))];
}



class LASX_3RF_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                        RegisterOperand ROXD, RegisterOperand ROXJ = ROXD,
                        RegisterOperand ROXK = ROXD> :
  LASX_3R_DESC_BASE<instr_asm, OpNode, ROXD, ROXJ, ROXK>;


class LASX_3R_DESC_BASE1<string instr_asm,
                       SDPatternOperator OpNode,
                       RegisterOperand ROXD, RegisterOperand ROXJ = ROXD,
                       RegisterOperand ROXK = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ROXK:$xk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $xk");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xk, ROXK:$xj))];
}

class LASX_3RF_DESC_BASE1<string instr_asm,
                        SDPatternOperator OpNode,
                        RegisterOperand ROXD, RegisterOperand ROXJ = ROXD,
                        RegisterOperand ROXK = ROXD> :
  LASX_3R_DESC_BASE1<instr_asm, OpNode, ROXD, ROXJ, ROXK>;



class LASX_3R_VSHF_DESC_BASE<string instr_asm, RegisterOperand ROXD,
                            RegisterOperand ROXJ = ROXD,
                            RegisterOperand ROXK = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, ROXK:$xk);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $xk");
  list<dag> Pattern = [(set ROXD:$xd, (LoongArchVSHF ROXD:$xd_in, ROXJ:$xj,
                                       ROXK:$xk))];
  string Constraints = "$xd = $xd_in";
}

class LASX_I5_SETCC_DESC_BASE<string instr_asm, CondCode CC, ValueType VT,
                                SplatComplexPattern SplatImm, RegisterOperand ROXD,
                                RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, SplatImm.OpClass:$si5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $si5");
  list<dag> Pattern = [(set ROXD:$xd, (VT (vsetcc ROXJ:$xj, SplatImm:$si5, CC)))];
}

class LASX_I5_SETCC_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                       RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$si5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $si5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$si5))];
}


class LASX_I5_U_SETCC_DESC_BASE<string instr_asm, CondCode CC, ValueType VT,
                                SplatComplexPattern SplatImm, RegisterOperand ROXD,
                                RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, SplatImm.OpClass:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (VT (vsetcc ROXJ:$xj, SplatImm:$ui5, CC)))];
}

class LASX_I5_U_SETCC_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                       RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui5))];
}

class LASX_VEC_PSEUDO_BASE<SDPatternOperator OpNode, RegisterOperand ROXD,
                          RegisterOperand ROXJ = ROXD,
                          RegisterOperand ROXK = ROXD> :
      LASXPseudo<(outs ROXD:$xd), (ins ROXJ:$xj, ROXK:$xk),
                [(set ROXD:$xd, (OpNode ROXJ:$xj, ROXK:$xk))]>;


class LASX_I5_U_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       SplatComplexPattern SplatImm, RegisterOperand ROXD,
                       RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, SplatImm.OpClass:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, SplatImm:$ui5))];
}


class LASX_I5_U_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                       RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui5))];
}

class LASX_U5_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       RegisterOperand ROXD,
                       RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, uimm5:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, immZExt5:$ui5))];
}

class LASX_U5N_DESC_BASE<string instr_asm, RegisterOperand ROXD,
                         RegisterOperand ROXJ = ROXD> :
  LASX_U5_DESC_BASE<instr_asm, null_frag, ROXD, ROXJ>;

class LASX_U5_4R_DESC_BASE<string instr_asm,
                          SDPatternOperator OpNode,
                          RegisterOperand ROXD,
                          RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, uimm5:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXD:$xd_in, ROXJ:$xj, immZExt5:$ui5))];
  string Constraints = "$xd = $xd_in";
}

class LASX_2R_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj))];
}

class LASX_SET_DESC_BASE<string instr_asm, RegisterOperand ROXD> {
  dag OutOperandList = (outs FCFROpnd:$cd);
  dag InOperandList = (ins ROXD:$xj);
  string AsmString = !strconcat(instr_asm, "\t$cd, $xj");
  list<dag> Pattern = [];
}

class LASX_2RF_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                        RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj))];
}

class LASX_I5_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       SplatComplexPattern SplatImm, RegisterOperand ROXD,
                       RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, SplatImm.OpClass:$si5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $si5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, SplatImm:$si5))];
}

class LASX_I5_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                       RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$si5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $si5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$si5))];
}


class LASX_2R_REPL_DESC_BASE<string instr_asm, ValueType VT,
                            SDPatternOperator OpNode, RegisterOperand ROXD,
                            RegisterOperand ROS = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROS:$rj);
  string AsmString = !strconcat(instr_asm, "\t$xd, $rj");
  list<dag> Pattern = [(set ROXD:$xd, (VT (OpNode ROS:$rj)))];
}

class LASX_XVEXTEND_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                             ValueType STy, ValueType DTy,
                                     RegisterOperand ROXJ,
                             RegisterOperand ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj");
  list<dag> Pattern = [(set ROXD:$xd, (DTy (OpNode (STy ROXJ:$xj))))];
}

class LASX_RORI_U3_DESC_BASE_Intrinsic <string instr_asm,
                              SDPatternOperator OpNode,
                              Operand ImmOp, ImmLeaf Imm,
                              RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui3");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui3))];
}

class LASX_RORI_U4_DESC_BASE_Intrinsic <string instr_asm,
                              SDPatternOperator OpNode,
                              Operand ImmOp, ImmLeaf Imm,
                              RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui4");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui4))];
}

class LASX_RORI_U5_DESC_BASE_Intrinsic <string instr_asm,
                              SDPatternOperator OpNode,
                              Operand ImmOp, ImmLeaf Imm,
                              RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui5))];
}

class LASX_RORI_U6_DESC_BASE_Intrinsic <string instr_asm,
                              SDPatternOperator OpNode,
                              Operand ImmOp, ImmLeaf Imm,
                              RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui6");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui6))];
}

class LASX_BIT_3_DESC_BASE<string instr_asm,
                          SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                          RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui3");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui3))];
}

class LASX_BIT_4_DESC_BASE<string instr_asm,
                          SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                          RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui4");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui4))];
}

class LASX_BIT_5_DESC_BASE<string instr_asm,
                          SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                          RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui5))];
}

class LASX_BIT_6_DESC_BASE<string instr_asm,
                          SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                          RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui6");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui6))];
}

class LASX_BIT_2_4O_DESC_BASE<string instr_asm,
                              SDPatternOperator OpNode,
                              Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                              RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, ImmOp:$ui2);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui2");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXD:$xd_in, ROXJ:$xj, Imm:$ui2))];
  string Constraints = "$xd = $xd_in";
}

class LASX_BIT_2_4ON<string instr_asm,
                     Operand ImmOp, ImmLeaf Imm,
                     RegisterOperand ROXD,
                     RegisterOperand ROXJ = ROXD> :
  LASX_BIT_2_4O_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROXD, ROXJ>;

class LASX_BIT_3_4O_DESC_BASE<string instr_asm,
                              SDPatternOperator OpNode,
                              Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                              RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui3");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXD:$xd_in, ROXJ:$xj, Imm:$ui3))];
  string Constraints = "$xd = $xd_in";
}

class LASX_BIT_3_4ON<string instr_asm,
                     Operand ImmOp, ImmLeaf Imm,
                     RegisterOperand ROXD,
                     RegisterOperand ROXJ = ROXD> :
  LASX_BIT_3_4O_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROXD, ROXJ>;

class LASX_INSERT_U3_DESC_BASE<string instr_asm, ValueType VTy,
                           Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                           RegisterOperand ROS> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROS:$rj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$xd, $rj, $ui3");
  list<dag> Pattern = [(set ROXD:$xd, (VTy (insertelt (VTy ROXD:$xd_in), ROS:$rj, Imm:$ui3)))];
  string Constraints = "$xd = $xd_in";
}

class LASX_INSERT_U2_DESC_BASE<string instr_asm, ValueType VTy,
                           Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                           RegisterOperand ROS> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROS:$rj, ImmOp:$ui2);
  string AsmString = !strconcat(instr_asm, "\t$xd, $rj, $ui2");
  list<dag> Pattern = [(set ROXD:$xd, (VTy (insertelt (VTy ROXD:$xd_in), ROS:$rj, Imm:$ui2)))];
  string Constraints = "$xd = $xd_in";
}

class LASX_COPY_U2_DESC_BASE<string instr_asm,
                         SDPatternOperator OpNode,
                         ValueType VecTy, Operand ImmOp, ImmLeaf Imm,
                         RegisterOperand ROD, RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROD:$rd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui2);
  string AsmString = !strconcat(instr_asm, "\t$rd, $xj, $ui2");
  list<dag> Pattern = [(set ROD:$rd, (OpNode (VecTy ROXJ:$xj), Imm:$ui2))];
}

class LASX_COPY_U3_DESC_BASE<string instr_asm,
                         SDPatternOperator OpNode,
                         ValueType VecTy, Operand ImmOp, ImmLeaf Imm,
                         RegisterOperand ROD, RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROD:$rd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$rd, $xj, $ui3");
  list<dag> Pattern = [(set ROD:$rd, (OpNode (VecTy ROXJ:$xj), Imm:$ui3))];
}

class LASX_ELM_U4_VREPLVE_DESC_BASE_Intrinsic<string instr_asm,
                                 SDPatternOperator OpNode,
                                 RegisterOperand ROXD,
                                 RegisterOperand ROXJ = ROXD> {
 dag OutOperandList = (outs ROXD:$xd);
 dag InOperandList = (ins ROXJ:$xj, uimm4:$ui4);
 string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui4");
 list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, immZExt4:$ui4))];
}

class LASX_ELM_U3_VREPLVE_DESC_BASE_Intrinsic<string instr_asm,
                                 SDPatternOperator OpNode,
                                 RegisterOperand ROXD,
                                 RegisterOperand ROXJ = ROXD> {
 dag OutOperandList = (outs ROXD:$xd);
 dag InOperandList = (ins ROXJ:$xj, uimm3:$ui3);
 string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui3");
 list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, immZExt3:$ui3))];
}

class LASX_ELM_U2_VREPLVE_DESC_BASE_Intrinsic<string instr_asm,
                                 SDPatternOperator OpNode,
                                 RegisterOperand ROXD,
                                 RegisterOperand ROXJ = ROXD> {
 dag OutOperandList = (outs ROXD:$xd);
 dag InOperandList = (ins ROXJ:$xj, uimm2:$ui2);
 string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui2");
 list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, immZExt2:$ui2))];
}

class LASX_ELM_U1_VREPLVE_DESC_BASE_Intrinsic<string instr_asm,
                                 SDPatternOperator OpNode,
                                 RegisterOperand ROXD,
                                 RegisterOperand ROXJ = ROXD> {
 dag OutOperandList = (outs ROXD:$xd);
 dag InOperandList = (ins ROXJ:$xj, uimm1:$ui1);
 string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui1");
 list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, immZExt1:$ui1))];
}

class LASX_XVBROADCAST_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                                ValueType TyNode,
                                        RegisterOperand ROXJ,
                                        RegisterOperand ROXD = ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode (TyNode ROXJ:$xj)))];
}

class LASX_2R_U3_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, uimm3:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui3");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXJ:$xj, immZExt3:$ui3))];
}

class LASX_2R_U4_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, uimm4:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui4");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXJ:$xj, immZExt4:$ui4))];
}

class LASX_2R_U5_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, uimm5:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXJ:$xj, immZExt5:$ui5))];
}

class LASX_2R_U6_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, uimm6:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui6");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXJ:$xj, immZExt6:$ui6))];
}

class LASX_BIT_U3_VREPLVE_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                                 SplatComplexPattern SplatImm,
                                 RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, SplatImm.OpClass:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui3");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, SplatImm:$ui3))];
}

class LASX_BIT_U4_VREPLVE_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                                 SplatComplexPattern SplatImm,
                                 RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, SplatImm.OpClass:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui4");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, SplatImm:$ui4))];
}

class LASX_BIT_U5_VREPLVE_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                                 SplatComplexPattern SplatImm,
                                 RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, SplatImm.OpClass:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, SplatImm:$ui5))];
}

class LASX_BIT_U6_VREPLVE_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                                 SplatComplexPattern SplatImm,
                                 RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, SplatImm.OpClass:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui6");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, SplatImm:$ui6))];
}

class LASX_BIT_U3_VREPLVE_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                                 Operand ImmOp, ImmLeaf Imm,
                                 RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui3");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui3))];
}

class LASX_BIT_U4_VREPLVE_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                                 Operand ImmOp, ImmLeaf Imm,
                                 RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui4");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui4))];
}

class LASX_BIT_U5_VREPLVE_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                                 Operand ImmOp, ImmLeaf Imm,
                                 RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui5))];
}

class LASX_BIT_U6_VREPLVE_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                                 Operand ImmOp, ImmLeaf Imm,
                                 RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, ImmOp:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui6");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, Imm:$ui6))];
}

class LASX_U4_DESC_BASE<string instr_asm,
                          SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                          RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in,ROXJ:$xj, ImmOp:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui4");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXD:$xd_in,ROXJ:$xj, Imm:$ui4))];
  string Constraints = "$xd = $xd_in";
}

class LASX_N4_U5_DESC_BASE<string instr_asm,
                          SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                          RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, ImmOp:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXD:$xd_in, ROXJ:$xj, Imm:$ui5))];
  string Constraints = "$xd = $xd_in";
}

class LASX_U6_DESC_BASE<string instr_asm,
                          SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                          RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, ImmOp:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui6");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXD:$xd_in, ROXJ:$xj, Imm:$ui6))];
  string Constraints = "$xd = $xd_in";
}

class LASX_D_DESC_BASE<string instr_asm,
                            SDPatternOperator OpNode,
                            RegisterOperand ROXD,
                            RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, uimm7:$ui7);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui7");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXD:$xd_in, ROXJ:$xj, immZExt7:$ui7))];
  string Constraints = "$xd = $xd_in";
}

class LASX_2R_3R_U4_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, uimm4:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui4");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXD:$xd_in, ROXJ:$xj, immZExt4:$ui4))];
  string Constraints = "$xd = $xd_in";
}

class LASX_2R_3R_U5_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, uimm5:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui5");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXD:$xd_in, ROXJ:$xj, immZExt5:$ui5))];
  string Constraints = "$xd = $xd_in";
}

class LASX_2R_3R_U6_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, uimm6:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui6");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXD:$xd_in, ROXJ:$xj, immZExt6:$ui6))];
  string Constraints = "$xd = $xd_in";
}

class LASX_2R_3R_U7_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, uimm7:$ui7);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui7");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXD:$xd_in, ROXJ:$xj, immZExt7:$ui7))];
  string Constraints = "$xd = $xd_in";
}

class LASX_2R_3R_U8_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui8");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXD:$xd_in, ROXJ:$xj, immZExt8:$ui8))];
  string Constraints = "$xd = $xd_in";
}

class LASX_2R_3R_U8_SELECT<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, vsplat_uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui8");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXD:$xd_in, xvsplati8_uimm8:$ui8, ROXJ:$xj))];
  string Constraints = "$xd = $xd_in";
}

class LASX_I8_O4_SHF_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui8");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXD:$xd_in, ROXJ:$xj, immZExt8:$ui8))];
  string Constraints = "$xd = $xd_in";
}

class LASX_I8_SHF_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui8");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, immZExt8:$ui8))];
}

class LASX_2R_U8_DESC_BASE<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROXD,
                           RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui8");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode  ROXJ:$xj, immZExt8:$ui8))];
}

class LASX_I13_DESC_BASE<string instr_asm,
                       SDPatternOperator OpNode,
                       ValueType Ty, Operand immOp,
                       RegisterOperand ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins immOp:$i13);
  string AsmString = !strconcat(instr_asm, "\t$xd, $i13");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode (Ty simm13:$i13)))];
  string DecoderMethod = "DecodeLASX256Mem13";
}

class LASX_I13_DESC_BASE_10<string instr_asm, SDPatternOperator OpNode,
                            Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                            RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ImmOp:$i10);
  string AsmString = !strconcat(instr_asm, "\t$xd, $i10");
  bit hasSideEffects = 0;
  string DecoderMethod = "DecodeLASX256Mem10";
  list<dag> Pattern = [(set ROXD:$xd, (OpNode Imm:$i10))];
 }

class LASX_BIT_U8_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                            SplatComplexPattern SplatImm,
                            RegisterOperand ROXD, RegisterOperand ROXJ = ROXD> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXJ:$xj, SplatImm.OpClass:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui8");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode ROXJ:$xj, SplatImm:$ui8))];
}

class LASX_2RN_3R_U8_DESC_BASE<string instr_asm,
                                 RegisterOperand ROXD,
                                 RegisterOperand ROXJ> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins ROXD:$xd_in, ROXJ:$xj, uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$xd, $xj, $ui8");
  list<dag> Pattern = [];
  string Constraints = "$xd = $xd_in";
}


//encoding

def XVFMADD_S : LASX_4R<0b000010100001>,
                LASX_4RF<"xvfmadd.s", int_loongarch_lasx_xvfmadd_s, LASX256WOpnd>;

def XVFMADD_D : LASX_4R<0b000010100010>,
                LASX_4RF<"xvfmadd.d", int_loongarch_lasx_xvfmadd_d, LASX256DOpnd>;


def XVFMSUB_S : LASX_4R<0b000010100101>,
                LASX_4RF<"xvfmsub.s", int_loongarch_lasx_xvfmsub_s, LASX256WOpnd>;

def XVFMSUB_D : LASX_4R<0b000010100110>,
                LASX_4RF<"xvfmsub.d", int_loongarch_lasx_xvfmsub_d, LASX256DOpnd>;


def XVFNMADD_S : LASX_4R<0b000010101001>,
                 LASX_4RF<"xvfnmadd.s", int_loongarch_lasx_xvfnmadd_s, LASX256WOpnd>;

def XVFNMADD_D : LASX_4R<0b000010101010>,
                 LASX_4RF<"xvfnmadd.d", int_loongarch_lasx_xvfnmadd_d, LASX256DOpnd>;


def XVFNMSUB_S : LASX_4R<0b000010101101>,
                 LASX_4RF<"xvfnmsub.s", int_loongarch_lasx_xvfnmsub_s, LASX256WOpnd>;

def XVFNMSUB_D : LASX_4R<0b000010101110>,
                 LASX_4RF<"xvfnmsub.d", int_loongarch_lasx_xvfnmsub_d, LASX256DOpnd>;


// xvfmadd: xj * xk + xa
def : LASXPat<(fma v4f64:$xj, v4f64:$xk, v4f64:$xa),
              (XVFMADD_D $xj, $xk, $xa)>;

def : LASXPat<(fma v8f32:$xj, v8f32:$xk, v8f32:$xa),
              (XVFMADD_S $xj, $xk, $xa)>;


// xvfmsub: xj * xk - xa
def : LASXPat<(fma v4f64:$xj, v4f64:$xk, (fneg v4f64:$xa)),
              (XVFMSUB_D v4f64:$xj, v4f64:$xk, v4f64:$xa)>;

def : LASXPat<(fma v8f32:$xj, v8f32:$xk, (fneg v8f32:$xa)),
              (XVFMSUB_S v8f32:$xj, v8f32:$xk, v8f32:$xa)>;


// xvfnmadd: -(xj * xk + xa)
def : LASXPat<(fma (fneg v4f64:$xj), v4f64:$xk, (fneg v4f64:$xa)),
              (XVFNMADD_D v4f64:$xj, v4f64:$xk, v4f64:$xa)>;

def : LASXPat<(fma (fneg v8f32:$xj), v8f32:$xk, (fneg v8f32:$xa)),
              (XVFNMADD_S v8f32:$xj, v8f32:$xk, v8f32:$xa)>;

// xvfnmsub: -(xj * xk - xa)
def : LASXPat<(fma (fneg v4f64:$xj), v4f64:$xk, v4f64:$xa),
              (XVFNMSUB_D v4f64:$xj, v4f64:$xk, v4f64:$xa)>;

def : LASXPat<(fma (fneg v8f32:$xj), v8f32:$xk, v8f32:$xa),
              (XVFNMSUB_S v8f32:$xj, v8f32:$xk, v8f32:$xa)>;


def XVFCMP_CAF_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.caf.s", int_loongarch_lasx_xvfcmp_caf_s, LASX256WOpnd>{
                    bits<5> cond=0x0;
                  }

def XVFCMP_CAF_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.caf.d", int_loongarch_lasx_xvfcmp_caf_d, LASX256DOpnd>{
                    bits<5> cond=0x0;
                  }

def XVFCMP_COR_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.cor.s", vfsetord_v8f32, LASX256WOpnd>{
                    bits<5> cond=0x14;
                  }

def XVFCMP_COR_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.cor.d", vfsetord_v4f64, LASX256DOpnd>{
                    bits<5> cond=0x14;
                  }

def XVFCMP_CUN_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.cun.s", vfsetun_v8f32, LASX256WOpnd>{
                    bits<5> cond=0x8;
                  }

def XVFCMP_CUN_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.cun.d", vfsetun_v4f64, LASX256DOpnd>{
                    bits<5> cond=0x8;
                  }

def XVFCMP_CUNE_S : LASX_XVFCMP<0b000011001001>,
                    LASX_3RF<"xvfcmp.cune.s", vfsetune_v8f32, LASX256WOpnd>{
                    bits<5> cond=0x18;
                  }

def XVFCMP_CUNE_D : LASX_XVFCMP<0b000011001010>,
                    LASX_3RF<"xvfcmp.cune.d", vfsetune_v4f64, LASX256DOpnd>{
                    bits<5> cond=0x18;
                  }

def XVFCMP_CUEQ_S : LASX_XVFCMP<0b000011001001>,
                    LASX_3RF<"xvfcmp.cueq.s", vfsetueq_v8f32, LASX256WOpnd>{
                    bits<5> cond=0xc;
                  }

def XVFCMP_CUEQ_D : LASX_XVFCMP<0b000011001010>,
                    LASX_3RF<"xvfcmp.cueq.d", vfsetueq_v4f64, LASX256DOpnd>{
                    bits<5> cond=0xc;
                  }

def XVFCMP_CEQ_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.ceq.s", vfsetoeq_v8f32, LASX256WOpnd>{
                    bits<5> cond=0x4;
                  }

def XVFCMP_CEQ_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.ceq.d", vfsetoeq_v4f64, LASX256DOpnd>{
                    bits<5> cond=0x4;
                  }

def XVFCMP_CNE_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.cne.s", vfsetone_v8f32, LASX256WOpnd>{
                    bits<5> cond=0x10;
                  }

def XVFCMP_CNE_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.cne.d", vfsetone_v4f64, LASX256DOpnd>{
                    bits<5> cond=0x10;
                  }

def XVFCMP_CLT_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.clt.s", vfsetolt_v8f32, LASX256WOpnd>{
                    bits<5> cond=0x2;
                  }

def XVFCMP_CLT_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.clt.d", vfsetolt_v4f64, LASX256DOpnd>{
                    bits<5> cond=0x2;
                  }

def XVFCMP_CULT_S : LASX_XVFCMP<0b000011001001>,
                    LASX_3RF<"xvfcmp.cult.s", vfsetult_v8f32, LASX256WOpnd>{
                    bits<5> cond=0xa;
                  }

def XVFCMP_CULT_D : LASX_XVFCMP<0b000011001010>,
                    LASX_3RF<"xvfcmp.cult.d", vfsetult_v4f64, LASX256DOpnd>{
                    bits<5> cond=0xa;
                  }

def XVFCMP_CLE_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.cle.s", vfsetole_v8f32, LASX256WOpnd>{
                    bits<5> cond=0x6;
                  }

def XVFCMP_CLE_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.cle.d", vfsetole_v4f64, LASX256DOpnd>{
                    bits<5> cond=0x6;
                  }

def XVFCMP_CULE_S : LASX_XVFCMP<0b000011001001>,
                    LASX_3RF<"xvfcmp.cule.s", vfsetule_v8f32, LASX256WOpnd>{
                    bits<5> cond=0xe;
                  }

def XVFCMP_CULE_D : LASX_XVFCMP<0b000011001010>,
                    LASX_3RF<"xvfcmp.cule.d", vfsetule_v4f64, LASX256DOpnd>{
                    bits<5> cond=0xe;
                  }

def XVFCMP_SAF_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.saf.s", int_loongarch_lasx_xvfcmp_saf_s, LASX256WOpnd>{
                    bits<5> cond=0x1;
                  }

def XVFCMP_SAF_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.saf.d", int_loongarch_lasx_xvfcmp_saf_d, LASX256DOpnd>{
                    bits<5> cond=0x1;
                  }

def XVFCMP_SOR_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.sor.s", int_loongarch_lasx_xvfcmp_sor_s, LASX256WOpnd>{
                    bits<5> cond=0x15;
                  }

def XVFCMP_SOR_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.sor.d", int_loongarch_lasx_xvfcmp_sor_d, LASX256DOpnd>{
                    bits<5> cond=0x15;
                  }

def XVFCMP_SUN_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.sun.s", int_loongarch_lasx_xvfcmp_sun_s, LASX256WOpnd>{
                    bits<5> cond=0x9;
                  }

def XVFCMP_SUN_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.sun.d", int_loongarch_lasx_xvfcmp_sun_d, LASX256DOpnd>{
                    bits<5> cond=0x9;
                  }

def XVFCMP_SUNE_S : LASX_XVFCMP<0b000011001001>,
                    LASX_3RF<"xvfcmp.sune.s", int_loongarch_lasx_xvfcmp_sune_s, LASX256WOpnd>{
                    bits<5> cond=0x19;
                  }

def XVFCMP_SUNE_D : LASX_XVFCMP<0b000011001010>,
                    LASX_3RF<"xvfcmp.sune.d", int_loongarch_lasx_xvfcmp_sune_d, LASX256DOpnd>{
                    bits<5> cond=0x19;
                  }

def XVFCMP_SUEQ_S : LASX_XVFCMP<0b000011001001>,
                    LASX_3RF<"xvfcmp.sueq.s", int_loongarch_lasx_xvfcmp_sueq_s, LASX256WOpnd>{
                    bits<5> cond=0xd;
                  }

def XVFCMP_SUEQ_D : LASX_XVFCMP<0b000011001010>,
                    LASX_3RF<"xvfcmp.sueq.d", int_loongarch_lasx_xvfcmp_sueq_d, LASX256DOpnd>{
                    bits<5> cond=0xd;
                  }

def XVFCMP_SEQ_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.seq.s", int_loongarch_lasx_xvfcmp_seq_s, LASX256WOpnd>{
                    bits<5> cond=0x5;
                  }

def XVFCMP_SEQ_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.seq.d", int_loongarch_lasx_xvfcmp_seq_d, LASX256DOpnd>{
                    bits<5> cond=0x5;
                  }

def XVFCMP_SNE_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.sne.s", int_loongarch_lasx_xvfcmp_sne_s, LASX256WOpnd>{
                    bits<5> cond=0x11;
                  }

def XVFCMP_SNE_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.sne.d", int_loongarch_lasx_xvfcmp_sne_d, LASX256DOpnd>{
                    bits<5> cond=0x11;
                  }

def XVFCMP_SLT_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.slt.s", int_loongarch_lasx_xvfcmp_slt_s, LASX256WOpnd>{
                    bits<5> cond=0x3;
                  }

def XVFCMP_SLT_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.slt.d", int_loongarch_lasx_xvfcmp_slt_d, LASX256DOpnd>{
                    bits<5> cond=0x3;
                  }

def XVFCMP_SULT_S : LASX_XVFCMP<0b000011001001>,
                    LASX_3RF<"xvfcmp.sult.s", int_loongarch_lasx_xvfcmp_sult_s, LASX256WOpnd>{
                    bits<5> cond=0xb;
                  }

def XVFCMP_SULT_D : LASX_XVFCMP<0b000011001010>,
                    LASX_3RF<"xvfcmp.sult.d", int_loongarch_lasx_xvfcmp_sult_d, LASX256DOpnd>{
                    bits<5> cond=0xb;
                  }

def XVFCMP_SLE_S : LASX_XVFCMP<0b000011001001>,
                   LASX_3RF<"xvfcmp.sle.s", int_loongarch_lasx_xvfcmp_sle_s, LASX256WOpnd>{
                    bits<5> cond=0x7;
                  }

def XVFCMP_SLE_D : LASX_XVFCMP<0b000011001010>,
                   LASX_3RF<"xvfcmp.sle.d", int_loongarch_lasx_xvfcmp_sle_d, LASX256DOpnd>{
                    bits<5> cond=0x7;
                  }

def XVFCMP_SULE_S : LASX_XVFCMP<0b000011001001>,
                    LASX_3RF<"xvfcmp.sule.s", int_loongarch_lasx_xvfcmp_sule_s, LASX256WOpnd>{
                    bits<5> cond=0xf;
                  }

def XVFCMP_SULE_D : LASX_XVFCMP<0b000011001010>,
                    LASX_3RF<"xvfcmp.sule.d", int_loongarch_lasx_xvfcmp_sule_d, LASX256DOpnd>{
                    bits<5> cond=0xf;
                  }


def XVBITSEL_V : LASX_4R<0b000011010010>,
                 LASX_4RF<"xvbitsel.v", int_loongarch_lasx_xvbitsel_v, LASX256BOpnd>;

class LASX_BSEL_PSEUDO_BASE<RegisterOperand RO, ValueType Ty> :
            LASXPseudo<(outs RO:$xd), (ins RO:$xd_in, RO:$xs, RO:$xt),
            [(set RO:$xd, (Ty (vselect RO:$xd_in, RO:$xt, RO:$xs)))]>,
            PseudoInstExpansion<(XVBITSEL_V LASX256BOpnd:$xd, LASX256BOpnd:$xs,
                                 LASX256BOpnd:$xt, LASX256BOpnd:$xd_in)> {
  let Constraints = "$xd_in = $xd";
}

def XBSEL_B_PSEUDO  : LASX_BSEL_PSEUDO_BASE<LASX256BOpnd, v32i8>;
def XBSEL_H_PSEUDO  : LASX_BSEL_PSEUDO_BASE<LASX256HOpnd, v16i16>;
def XBSEL_W_PSEUDO  : LASX_BSEL_PSEUDO_BASE<LASX256WOpnd, v8i32>;
def XBSEL_D_PSEUDO  : LASX_BSEL_PSEUDO_BASE<LASX256DOpnd, v4i64>;
def XBSEL_FW_PSEUDO : LASX_BSEL_PSEUDO_BASE<LASX256WOpnd, v8f32>;
def XBSEL_FD_PSEUDO : LASX_BSEL_PSEUDO_BASE<LASX256DOpnd, v4f64>;



def XVSHUF_B : LASX_4R<0b000011010110>,
               LASX_4RF<"xvshuf.b", int_loongarch_lasx_xvshuf_b, LASX256BOpnd>;


def XVLD : LASX_I12_S<0b0010110010>,
           LASX_LD<"xvld", load, v32i8, LASX256BOpnd, mem>;

def XVST : LASX_I12_S<0b0010110011>,
           LASX_ST<"xvst", store, v32i8, LASX256BOpnd, mem_simm12>;


class LASX_LD_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                         ValueType TyNode, RegisterOperand ROXD,
                                 Operand MemOpnd = mem,
                                 ComplexPattern Addr = addr> {
  dag OutOperandList = (outs ROXD:$xd);
  dag InOperandList = (ins MemOpnd:$addr);
  string AsmString = !strconcat(instr_asm, "\t$xd, $addr");
  list<dag> Pattern = [(set ROXD:$xd, (OpNode (TyNode (load Addr:$addr))))];
  string DecoderMethod = "DecodeLASX256memlsl";
}


def XVLDREPL_B : LASX_SI12_S<0b0011001010>,
                 LASX_LD_DESC_BASE<"xvldrepl.b", xvbroadcast_v32i8,  v32i8, LASX256BOpnd>;

def XVLDREPL_H : LASX_SI11_S<0b00110010010>,
                 LASX_LD_DESC_BASE<"xvldrepl.h", xvbroadcast_v16i16, v16i16, LASX256HOpnd, mem_simm11_lsl1, addrimm11lsl1>;

def XVLDREPL_W : LASX_SI10_S<0b001100100010>,
                 LASX_LD_DESC_BASE<"xvldrepl.w", xvbroadcast_v8i32, v8i32, LASX256WOpnd, mem_simm10_lsl2, addrimm10lsl2>;

def XVLDREPL_D : LASX_SI9_S<0b0011001000010>,
                 LASX_LD_DESC_BASE<"xvldrepl.d", xvbroadcast_v4i64,  v4i64, LASX256DOpnd,  mem_simm9_lsl3, addrimm9lsl3>;


def XVSTELM_B : LASX_SI8_idx5<0b001100111>,
                LASX_I8_U5_DESC_BASE<"xvstelm.b", int_loongarch_lasx_xvstelm_b, simm8_32, immSExt8, LASX256BOpnd, GPR32Opnd>;

def XVSTELM_H : LASX_SI8_idx4<0b0011001101>,
                LASX_I8_U4_DESC_BASE<"xvstelm.h", int_loongarch_lasx_xvstelm_h, immSExt8_1_O, immSExt8, LASX256HOpnd, GPR32Opnd>;

def XVSTELM_W : LASX_SI8_idx3<0b00110011001>,
                LASX_I8_U3_DESC_BASE<"xvstelm.w", int_loongarch_lasx_xvstelm_w, immSExt8_2_O, immSExt8, LASX256WOpnd, GPR32Opnd>;

def XVSTELM_D : LASX_SI8_idx2<0b001100110001>,
                LASX_I8_U2_DESC_BASE<"xvstelm.d", int_loongarch_lasx_xvstelm_d, immSExt8_3_O, immSExt8, LASX256DOpnd, GPR32Opnd>;

let mayLoad = 1, canFoldAsLoad = 1 in {
  def XVLDX : LASX_3R_2GP<0b00111000010010000>,
              LASX_LDX_LA<"xvldx", int_loongarch_lasx_xvldx, GPR64Opnd, LASX256BOpnd>;
}

let mayStore = 1 in{
  def XVSTX : LASX_3R_2GP<0b00111000010011000>,
              LASX_SDX_LA<"xvstx", int_loongarch_lasx_xvstx, GPR64Opnd, LASX256BOpnd>;
}


def XVSEQ_B : LASX_3R<0b01110100000000000>, IsCommutable,
              LASX_3R_SETCC_DESC_BASE<"xvseq.b", SETEQ, v32i8, LASX256BOpnd>;

def XVSEQ_H : LASX_3R<0b01110100000000001>, IsCommutable,
              LASX_3R_SETCC_DESC_BASE<"xvseq.h", SETEQ, v16i16, LASX256HOpnd>;

def XVSEQ_W : LASX_3R<0b01110100000000010>, IsCommutable,
              LASX_3R_SETCC_DESC_BASE<"xvseq.w", SETEQ, v8i32, LASX256WOpnd> ;

def XVSEQ_D : LASX_3R<0b01110100000000011>, IsCommutable,
              LASX_3R_SETCC_DESC_BASE<"xvseq.d", SETEQ, v4i64, LASX256DOpnd>;


def XVSLE_B : LASX_3R<0b01110100000000100>,
              LASX_3R_SETCC_DESC_BASE<"xvsle.b", SETLE, v32i8, LASX256BOpnd>;

def XVSLE_H : LASX_3R<0b01110100000000101>,
              LASX_3R_SETCC_DESC_BASE<"xvsle.h", SETLE, v16i16, LASX256HOpnd>;

def XVSLE_W : LASX_3R<0b01110100000000110>,
              LASX_3R_SETCC_DESC_BASE<"xvsle.w", SETLE, v8i32, LASX256WOpnd>;

def XVSLE_D : LASX_3R<0b01110100000000111>,
              LASX_3R_SETCC_DESC_BASE<"xvsle.d", SETLE, v4i64, LASX256DOpnd>;


def XVSLE_BU : LASX_3R<0b01110100000001000>,
               LASX_3R_SETCC_DESC_BASE<"xvsle.bu", SETULE, v32i8, LASX256BOpnd>;

def XVSLE_HU : LASX_3R<0b01110100000001001>,
               LASX_3R_SETCC_DESC_BASE<"xvsle.hu", SETULE, v16i16, LASX256HOpnd>;

def XVSLE_WU : LASX_3R<0b01110100000001010>,
               LASX_3R_SETCC_DESC_BASE<"xvsle.wu", SETULE, v8i32, LASX256WOpnd>;

def XVSLE_DU : LASX_3R<0b01110100000001011>,
               LASX_3R_SETCC_DESC_BASE<"xvsle.du", SETULE, v4i64, LASX256DOpnd>;


def XVSLT_B : LASX_3R<0b01110100000001100>,
              LASX_3R_SETCC_DESC_BASE<"xvslt.b", SETLT, v32i8, LASX256BOpnd>;

def XVSLT_H : LASX_3R<0b01110100000001101>,
              LASX_3R_SETCC_DESC_BASE<"xvslt.h", SETLT, v16i16, LASX256HOpnd>;

def XVSLT_W : LASX_3R<0b01110100000001110>,
              LASX_3R_SETCC_DESC_BASE<"xvslt.w", SETLT, v8i32, LASX256WOpnd>;

def XVSLT_D : LASX_3R<0b01110100000001111>,
              LASX_3R_SETCC_DESC_BASE<"xvslt.d", SETLT, v4i64, LASX256DOpnd>;


def XVSLT_BU : LASX_3R<0b01110100000010000>,
               LASX_3R_SETCC_DESC_BASE<"xvslt.bu", SETULT, v32i8, LASX256BOpnd>;

def XVSLT_HU : LASX_3R<0b01110100000010001>,
               LASX_3R_SETCC_DESC_BASE<"xvslt.hu", SETULT, v16i16, LASX256HOpnd>;

def XVSLT_WU : LASX_3R<0b01110100000010010>,
               LASX_3R_SETCC_DESC_BASE<"xvslt.wu", SETULT, v8i32, LASX256WOpnd>;

def XVSLT_DU : LASX_3R<0b01110100000010011>,
               LASX_3R_SETCC_DESC_BASE<"xvslt.du", SETULT, v4i64, LASX256DOpnd>;


def XVADD_B : LASX_3R<0b01110100000010100>, IsCommutable,
              LASX_3R_DESC_BASE<"xvadd.b", add, LASX256BOpnd>;

def XVADD_H : LASX_3R<0b01110100000010101>, IsCommutable,
              LASX_3R_DESC_BASE<"xvadd.h", add, LASX256HOpnd>;

def XVADD_W : LASX_3R<0b01110100000010110>, IsCommutable,
              LASX_3R_DESC_BASE<"xvadd.w", add, LASX256WOpnd>;

def XVADD_D : LASX_3R<0b01110100000010111>, IsCommutable,
              LASX_3R_DESC_BASE<"xvadd.d", add, LASX256DOpnd>;


def XVSUB_B : LASX_3R<0b01110100000011000>,
              LASX_3R_DESC_BASE<"xvsub.b", sub, LASX256BOpnd>;

def XVSUB_H : LASX_3R<0b01110100000011001>,
              LASX_3R_DESC_BASE<"xvsub.h", sub, LASX256HOpnd>;

def XVSUB_W : LASX_3R<0b01110100000011010>,
              LASX_3R_DESC_BASE<"xvsub.w", sub, LASX256WOpnd>;

def XVSUB_D : LASX_3R<0b01110100000011011>,
              LASX_3R_DESC_BASE<"xvsub.d", sub, LASX256DOpnd>;


def XVADDWEV_H_B : LASX_3R<0b01110100000111100>,
                   LASX_3R_DESC_BASE<"xvaddwev.h.b", int_loongarch_lasx_xvaddwev_h_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVADDWEV_W_H : LASX_3R<0b01110100000111101>,
                   LASX_3R_DESC_BASE<"xvaddwev.w.h", int_loongarch_lasx_xvaddwev_w_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVADDWEV_D_W : LASX_3R<0b01110100000111110>,
                   LASX_3R_DESC_BASE<"xvaddwev.d.w", int_loongarch_lasx_xvaddwev_d_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVADDWEV_Q_D : LASX_3R<0b01110100000111111>,
                   LASX_3R_DESC_BASE<"xvaddwev.q.d", int_loongarch_lasx_xvaddwev_q_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSUBWEV_H_B : LASX_3R<0b01110100001000000>,
                   LASX_3R_DESC_BASE<"xvsubwev.h.b", int_loongarch_lasx_xvsubwev_h_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVSUBWEV_W_H : LASX_3R<0b01110100001000001>,
                   LASX_3R_DESC_BASE<"xvsubwev.w.h", int_loongarch_lasx_xvsubwev_w_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSUBWEV_D_W : LASX_3R<0b01110100001000010>,
                   LASX_3R_DESC_BASE<"xvsubwev.d.w", int_loongarch_lasx_xvsubwev_d_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVSUBWEV_Q_D : LASX_3R<0b01110100001000011>,
                   LASX_3R_DESC_BASE<"xvsubwev.q.d", int_loongarch_lasx_xvsubwev_q_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVADDWOD_H_B : LASX_3R<0b01110100001000100>,
                   LASX_3R_DESC_BASE<"xvaddwod.h.b", int_loongarch_lasx_xvaddwod_h_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVADDWOD_W_H : LASX_3R<0b01110100001000101>,
                   LASX_3R_DESC_BASE<"xvaddwod.w.h", int_loongarch_lasx_xvaddwod_w_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVADDWOD_D_W : LASX_3R<0b01110100001000110>,
                   LASX_3R_DESC_BASE<"xvaddwod.d.w", int_loongarch_lasx_xvaddwod_d_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVADDWOD_Q_D : LASX_3R<0b01110100001000111>,
                   LASX_3R_DESC_BASE<"xvaddwod.q.d", int_loongarch_lasx_xvaddwod_q_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSUBWOD_H_B : LASX_3R<0b01110100001001000>,
                   LASX_3R_DESC_BASE<"xvsubwod.h.b", int_loongarch_lasx_xvsubwod_h_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVSUBWOD_W_H : LASX_3R<0b01110100001001001>,
                   LASX_3R_DESC_BASE<"xvsubwod.w.h", int_loongarch_lasx_xvsubwod_w_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSUBWOD_D_W : LASX_3R<0b01110100001001010>,
                   LASX_3R_DESC_BASE<"xvsubwod.d.w", int_loongarch_lasx_xvsubwod_d_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVSUBWOD_Q_D : LASX_3R<0b01110100001001011>,
                   LASX_3R_DESC_BASE<"xvsubwod.q.d", int_loongarch_lasx_xvsubwod_q_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVADDWEV_H_BU : LASX_3R<0b01110100001011100>,
                    LASX_3R_DESC_BASE<"xvaddwev.h.bu", int_loongarch_lasx_xvaddwev_h_bu, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVADDWEV_W_HU : LASX_3R<0b01110100001011101>,
                    LASX_3R_DESC_BASE<"xvaddwev.w.hu", int_loongarch_lasx_xvaddwev_w_hu, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVADDWEV_D_WU : LASX_3R<0b01110100001011110>,
                    LASX_3R_DESC_BASE<"xvaddwev.d.wu", int_loongarch_lasx_xvaddwev_d_wu, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVADDWEV_Q_DU : LASX_3R<0b01110100001011111>,
                    LASX_3R_DESC_BASE<"xvaddwev.q.du", int_loongarch_lasx_xvaddwev_q_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSUBWEV_H_BU : LASX_3R<0b01110100001100000>,
                    LASX_3R_DESC_BASE<"xvsubwev.h.bu", int_loongarch_lasx_xvsubwev_h_bu, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVSUBWEV_W_HU : LASX_3R<0b01110100001100001>,
                    LASX_3R_DESC_BASE<"xvsubwev.w.hu", int_loongarch_lasx_xvsubwev_w_hu, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSUBWEV_D_WU : LASX_3R<0b01110100001100010>,
                    LASX_3R_DESC_BASE<"xvsubwev.d.wu", int_loongarch_lasx_xvsubwev_d_wu, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVSUBWEV_Q_DU : LASX_3R<0b01110100001100011>,
                    LASX_3R_DESC_BASE<"xvsubwev.q.du", int_loongarch_lasx_xvsubwev_q_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVADDWOD_H_BU : LASX_3R<0b01110100001100100>,
                    LASX_3R_DESC_BASE<"xvaddwod.h.bu", int_loongarch_lasx_xvaddwod_h_bu, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVADDWOD_W_HU : LASX_3R<0b01110100001100101>,
                    LASX_3R_DESC_BASE<"xvaddwod.w.hu", int_loongarch_lasx_xvaddwod_w_hu, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVADDWOD_D_WU : LASX_3R<0b01110100001100110>,
                    LASX_3R_DESC_BASE<"xvaddwod.d.wu", int_loongarch_lasx_xvaddwod_d_wu, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVADDWOD_Q_DU : LASX_3R<0b01110100001100111>,
                    LASX_3R_DESC_BASE<"xvaddwod.q.du", int_loongarch_lasx_xvaddwod_q_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSUBWOD_H_BU : LASX_3R<0b01110100001101000>,
                    LASX_3R_DESC_BASE<"xvsubwod.h.bu", int_loongarch_lasx_xvsubwod_h_bu, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVSUBWOD_W_HU : LASX_3R<0b01110100001101001>,
                    LASX_3R_DESC_BASE<"xvsubwod.w.hu", int_loongarch_lasx_xvsubwod_w_hu, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSUBWOD_D_WU : LASX_3R<0b01110100001101010>,
                    LASX_3R_DESC_BASE<"xvsubwod.d.wu", int_loongarch_lasx_xvsubwod_d_wu, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVSUBWOD_Q_DU : LASX_3R<0b01110100001101011>,
                    LASX_3R_DESC_BASE<"xvsubwod.q.du", int_loongarch_lasx_xvsubwod_q_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVADDWEV_H_BU_B : LASX_3R<0b01110100001111100>,
                      LASX_3R_DESC_BASE<"xvaddwev.h.bu.b", int_loongarch_lasx_xvaddwev_h_bu_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVADDWEV_W_HU_H : LASX_3R<0b01110100001111101>,
                      LASX_3R_DESC_BASE<"xvaddwev.w.hu.h", int_loongarch_lasx_xvaddwev_w_hu_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVADDWEV_D_WU_W : LASX_3R<0b01110100001111110>,
                      LASX_3R_DESC_BASE<"xvaddwev.d.wu.w", int_loongarch_lasx_xvaddwev_d_wu_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVADDWEV_Q_DU_D : LASX_3R<0b01110100001111111>,
                      LASX_3R_DESC_BASE<"xvaddwev.q.du.d", int_loongarch_lasx_xvaddwev_q_du_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVADDWOD_H_BU_B : LASX_3R<0b01110100010000000>,
                      LASX_3R_DESC_BASE<"xvaddwod.h.bu.b", int_loongarch_lasx_xvaddwod_h_bu_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVADDWOD_W_HU_H : LASX_3R<0b01110100010000001>,
                      LASX_3R_DESC_BASE<"xvaddwod.w.hu.h", int_loongarch_lasx_xvaddwod_w_hu_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVADDWOD_D_WU_W : LASX_3R<0b01110100010000010>,
                      LASX_3R_DESC_BASE<"xvaddwod.d.wu.w", int_loongarch_lasx_xvaddwod_d_wu_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVADDWOD_Q_DU_D : LASX_3R<0b01110100010000011>,
                      LASX_3R_DESC_BASE<"xvaddwod.q.du.d", int_loongarch_lasx_xvaddwod_q_du_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSADD_B : LASX_3R<0b01110100010001100>, IsCommutable,
               LASX_3R_DESC_BASE<"xvsadd.b", saddsat, LASX256BOpnd>;

def XVSADD_H : LASX_3R<0b01110100010001101>, IsCommutable,
               LASX_3R_DESC_BASE<"xvsadd.h", saddsat, LASX256HOpnd>;

def XVSADD_W : LASX_3R<0b01110100010001110>, IsCommutable,
               LASX_3R_DESC_BASE<"xvsadd.w", saddsat, LASX256WOpnd>;

def XVSADD_D : LASX_3R<0b01110100010001111>, IsCommutable,
               LASX_3R_DESC_BASE<"xvsadd.d", saddsat, LASX256DOpnd>;


def XVSSUB_B : LASX_3R<0b01110100010010000>,
               LASX_3R_DESC_BASE<"xvssub.b", ssubsat, LASX256BOpnd>;

def XVSSUB_H : LASX_3R<0b01110100010010001>,
               LASX_3R_DESC_BASE<"xvssub.h", ssubsat, LASX256HOpnd>;

def XVSSUB_W : LASX_3R<0b01110100010010010>,
               LASX_3R_DESC_BASE<"xvssub.w", ssubsat, LASX256WOpnd>;

def XVSSUB_D : LASX_3R<0b01110100010010011>,
               LASX_3R_DESC_BASE<"xvssub.d", ssubsat, LASX256DOpnd>;


def XVSADD_BU : LASX_3R<0b01110100010010100>, IsCommutable,
                LASX_3R_DESC_BASE<"xvsadd.bu", uaddsat, LASX256BOpnd>;

def XVSADD_HU : LASX_3R<0b01110100010010101>, IsCommutable,
                LASX_3R_DESC_BASE<"xvsadd.hu", uaddsat, LASX256HOpnd>;

def XVSADD_WU : LASX_3R<0b01110100010010110>, IsCommutable,
                LASX_3R_DESC_BASE<"xvsadd.wu", uaddsat, LASX256WOpnd>;

def XVSADD_DU : LASX_3R<0b01110100010010111>, IsCommutable,
                LASX_3R_DESC_BASE<"xvsadd.du", uaddsat, LASX256DOpnd>;


def XVSSUB_BU : LASX_3R<0b01110100010011000>,
                LASX_3R_DESC_BASE<"xvssub.bu", usubsat, LASX256BOpnd>;

def XVSSUB_HU : LASX_3R<0b01110100010011001>,
                LASX_3R_DESC_BASE<"xvssub.hu", usubsat, LASX256HOpnd>;

def XVSSUB_WU : LASX_3R<0b01110100010011010>,
                LASX_3R_DESC_BASE<"xvssub.wu", usubsat, LASX256WOpnd>;

def XVSSUB_DU : LASX_3R<0b01110100010011011>,
                LASX_3R_DESC_BASE<"xvssub.du", usubsat, LASX256DOpnd>;


def XVHADDW_H_B : LASX_3R<0b01110100010101000>,
                  LASX_3R_DESC_BASE<"xvhaddw.h.b", int_loongarch_lasx_xvhaddw_h_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVHADDW_W_H : LASX_3R<0b01110100010101001>,
                  LASX_3R_DESC_BASE<"xvhaddw.w.h", int_loongarch_lasx_xvhaddw_w_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVHADDW_D_W : LASX_3R<0b01110100010101010>,
                  LASX_3R_DESC_BASE<"xvhaddw.d.w", int_loongarch_lasx_xvhaddw_d_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVHADDW_Q_D : LASX_3R<0b01110100010101011>,
                  LASX_3R_DESC_BASE<"xvhaddw.q.d", int_loongarch_lasx_xvhaddw_q_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;



def XVHSUBW_H_B : LASX_3R<0b01110100010101100>,
                  LASX_3R_DESC_BASE<"xvhsubw.h.b", int_loongarch_lasx_xvhsubw_h_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVHSUBW_W_H : LASX_3R<0b01110100010101101>,
                  LASX_3R_DESC_BASE<"xvhsubw.w.h", int_loongarch_lasx_xvhsubw_w_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVHSUBW_D_W : LASX_3R<0b01110100010101110>,
                  LASX_3R_DESC_BASE<"xvhsubw.d.w", int_loongarch_lasx_xvhsubw_d_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVHSUBW_Q_D : LASX_3R<0b01110100010101111>,
                  LASX_3R_DESC_BASE<"xvhsubw.q.d", int_loongarch_lasx_xvhsubw_q_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVHADDW_HU_BU : LASX_3R<0b01110100010110000>,
                    LASX_3R_DESC_BASE<"xvhaddw.hu.bu", int_loongarch_lasx_xvhaddw_hu_bu, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVHADDW_WU_HU : LASX_3R<0b01110100010110001>,
                    LASX_3R_DESC_BASE<"xvhaddw.wu.hu", int_loongarch_lasx_xvhaddw_wu_hu, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVHADDW_DU_WU : LASX_3R<0b01110100010110010>,
                    LASX_3R_DESC_BASE<"xvhaddw.du.wu", int_loongarch_lasx_xvhaddw_du_wu, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVHADDW_QU_DU : LASX_3R<0b01110100010110011>,
                    LASX_3R_DESC_BASE<"xvhaddw.qu.du", int_loongarch_lasx_xvhaddw_qu_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;



def XVHSUBW_HU_BU : LASX_3R<0b01110100010110100>,
                    LASX_3R_DESC_BASE<"xvhsubw.hu.bu", int_loongarch_lasx_xvhsubw_hu_bu, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVHSUBW_WU_HU : LASX_3R<0b01110100010110101>,
                    LASX_3R_DESC_BASE<"xvhsubw.wu.hu", int_loongarch_lasx_xvhsubw_wu_hu, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVHSUBW_DU_WU : LASX_3R<0b01110100010110110>,
                    LASX_3R_DESC_BASE<"xvhsubw.du.wu", int_loongarch_lasx_xvhsubw_du_wu, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVHSUBW_QU_DU : LASX_3R<0b01110100010110111>,
                    LASX_3R_DESC_BASE<"xvhsubw.qu.du", int_loongarch_lasx_xvhsubw_qu_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVADDA_B : LASX_3R<0b01110100010111000>, IsCommutable,
               LASX_3R_DESC_BASE<"xvadda.b", int_loongarch_lasx_xvadda_b, LASX256BOpnd>;

def XVADDA_H : LASX_3R<0b01110100010111001>, IsCommutable,
               LASX_3R_DESC_BASE<"xvadda.h", int_loongarch_lasx_xvadda_h, LASX256HOpnd>;

def XVADDA_W : LASX_3R<0b01110100010111010>, IsCommutable,
               LASX_3R_DESC_BASE<"xvadda.w", int_loongarch_lasx_xvadda_w, LASX256WOpnd>;

def XVADDA_D : LASX_3R<0b01110100010111011>, IsCommutable,
               LASX_3R_DESC_BASE<"xvadda.d", int_loongarch_lasx_xvadda_d, LASX256DOpnd>;


def XVABSD_B : LASX_3R<0b01110100011000000>,
               LASX_3R_DESC_BASE<"xvabsd.b", int_loongarch_lasx_xvabsd_b, LASX256BOpnd>;

def XVABSD_H : LASX_3R<0b01110100011000001>,
               LASX_3R_DESC_BASE<"xvabsd.h", int_loongarch_lasx_xvabsd_h, LASX256HOpnd>;

def XVABSD_W : LASX_3R<0b01110100011000010>,
               LASX_3R_DESC_BASE<"xvabsd.w", int_loongarch_lasx_xvabsd_w, LASX256WOpnd>;

def XVABSD_D : LASX_3R<0b01110100011000011>,
               LASX_3R_DESC_BASE<"xvabsd.d", int_loongarch_lasx_xvabsd_d, LASX256DOpnd>;


def XVABSD_BU : LASX_3R<0b01110100011000100>,
                LASX_3R_DESC_BASE<"xvabsd.bu", int_loongarch_lasx_xvabsd_bu, LASX256BOpnd>;

def XVABSD_HU : LASX_3R<0b01110100011000101>,
                LASX_3R_DESC_BASE<"xvabsd.hu", int_loongarch_lasx_xvabsd_hu, LASX256HOpnd>;

def XVABSD_WU : LASX_3R<0b01110100011000110>,
                LASX_3R_DESC_BASE<"xvabsd.wu", int_loongarch_lasx_xvabsd_wu, LASX256WOpnd>;

def XVABSD_DU : LASX_3R<0b01110100011000111>,
                LASX_3R_DESC_BASE<"xvabsd.du", int_loongarch_lasx_xvabsd_du, LASX256DOpnd>;


def XVAVG_B : LASX_3R<0b01110100011001000>, IsCommutable,
              LASX_3R_DESC_BASE<"xvavg.b", int_loongarch_lasx_xvavg_b, LASX256BOpnd>;

def XVAVG_H : LASX_3R<0b01110100011001001>, IsCommutable,
              LASX_3R_DESC_BASE<"xvavg.h", int_loongarch_lasx_xvavg_h, LASX256HOpnd>;

def XVAVG_W : LASX_3R<0b01110100011001010>, IsCommutable,
              LASX_3R_DESC_BASE<"xvavg.w", int_loongarch_lasx_xvavg_w, LASX256WOpnd>;

def XVAVG_D : LASX_3R<0b01110100011001011>, IsCommutable,
              LASX_3R_DESC_BASE<"xvavg.d", int_loongarch_lasx_xvavg_d, LASX256DOpnd>;


def XVAVG_BU : LASX_3R<0b01110100011001100>, IsCommutable,
               LASX_3R_DESC_BASE<"xvavg.bu", int_loongarch_lasx_xvavg_bu, LASX256BOpnd>;

def XVAVG_HU : LASX_3R<0b01110100011001101>, IsCommutable,
               LASX_3R_DESC_BASE<"xvavg.hu", int_loongarch_lasx_xvavg_hu, LASX256HOpnd>;

def XVAVG_WU : LASX_3R<0b01110100011001110>, IsCommutable,
               LASX_3R_DESC_BASE<"xvavg.wu", int_loongarch_lasx_xvavg_wu, LASX256WOpnd>;

def XVAVG_DU : LASX_3R<0b01110100011001111>, IsCommutable,
               LASX_3R_DESC_BASE<"xvavg.du", int_loongarch_lasx_xvavg_du, LASX256DOpnd>;


def XVAVGR_B : LASX_3R<0b01110100011010000>, IsCommutable,
               LASX_3R_DESC_BASE<"xvavgr.b", int_loongarch_lasx_xvavgr_b, LASX256BOpnd>;

def XVAVGR_H : LASX_3R<0b01110100011010001>, IsCommutable,
               LASX_3R_DESC_BASE<"xvavgr.h", int_loongarch_lasx_xvavgr_h, LASX256HOpnd>;

def XVAVGR_W : LASX_3R<0b01110100011010010>, IsCommutable,
               LASX_3R_DESC_BASE<"xvavgr.w", int_loongarch_lasx_xvavgr_w, LASX256WOpnd>;

def XVAVGR_D : LASX_3R<0b01110100011010011>, IsCommutable,
               LASX_3R_DESC_BASE<"xvavgr.d", int_loongarch_lasx_xvavgr_d, LASX256DOpnd>;


def XVAVGR_BU : LASX_3R<0b01110100011010100>, IsCommutable,
                LASX_3R_DESC_BASE<"xvavgr.bu", int_loongarch_lasx_xvavgr_bu, LASX256BOpnd>;

def XVAVGR_HU : LASX_3R<0b01110100011010101>, IsCommutable,
                LASX_3R_DESC_BASE<"xvavgr.hu", int_loongarch_lasx_xvavgr_hu, LASX256HOpnd>;

def XVAVGR_WU : LASX_3R<0b01110100011010110>, IsCommutable,
                LASX_3R_DESC_BASE<"xvavgr.wu", int_loongarch_lasx_xvavgr_wu, LASX256WOpnd>;

def XVAVGR_DU : LASX_3R<0b01110100011010111>, IsCommutable,
                LASX_3R_DESC_BASE<"xvavgr.du", int_loongarch_lasx_xvavgr_du, LASX256DOpnd>;


def XVMAX_B : LASX_3R<0b01110100011100000>,
              LASX_3R_DESC_BASE<"xvmax.b", smax, LASX256BOpnd>;

def XVMAX_H : LASX_3R<0b01110100011100001>,
              LASX_3R_DESC_BASE<"xvmax.h", smax, LASX256HOpnd>;

def XVMAX_W : LASX_3R<0b01110100011100010>,
              LASX_3R_DESC_BASE<"xvmax.w", smax, LASX256WOpnd>;

def XVMAX_D : LASX_3R<0b01110100011100011>,
              LASX_3R_DESC_BASE<"xvmax.d", smax, LASX256DOpnd>;


def XVMIN_B : LASX_3R<0b01110100011100100>,
              LASX_3R_DESC_BASE<"xvmin.b", smin, LASX256BOpnd>;

def XVMIN_H : LASX_3R<0b01110100011100101>,
              LASX_3R_DESC_BASE<"xvmin.h", smin, LASX256HOpnd>;

def XVMIN_W : LASX_3R<0b01110100011100110>,
              LASX_3R_DESC_BASE<"xvmin.w", smin, LASX256WOpnd>;

def XVMIN_D : LASX_3R<0b01110100011100111>,
              LASX_3R_DESC_BASE<"xvmin.d", smin, LASX256DOpnd>;


def XVMAX_BU : LASX_3R<0b01110100011101000>,
               LASX_3R_DESC_BASE<"xvmax.bu", umax, LASX256BOpnd>;

def XVMAX_HU : LASX_3R<0b01110100011101001>,
               LASX_3R_DESC_BASE<"xvmax.hu", umax, LASX256HOpnd>;

def XVMAX_WU : LASX_3R<0b01110100011101010>,
               LASX_3R_DESC_BASE<"xvmax.wu", umax, LASX256WOpnd>;

def XVMAX_DU : LASX_3R<0b01110100011101011>,
               LASX_3R_DESC_BASE<"xvmax.du", umax, LASX256DOpnd>;


def XVMIN_BU : LASX_3R<0b01110100011101100>,
               LASX_3R_DESC_BASE<"xvmin.bu", umin, LASX256BOpnd>;

def XVMIN_HU : LASX_3R<0b01110100011101101>,
               LASX_3R_DESC_BASE<"xvmin.hu", umin, LASX256HOpnd>;

def XVMIN_WU : LASX_3R<0b01110100011101110>,
               LASX_3R_DESC_BASE<"xvmin.wu", umin, LASX256WOpnd>;

def XVMIN_DU : LASX_3R<0b01110100011101111>,
               LASX_3R_DESC_BASE<"xvmin.du", umin, LASX256DOpnd>;


def XVMUL_B : LASX_3R<0b01110100100001000>,
              LASX_3R_DESC_BASE<"xvmul.b", mul, LASX256BOpnd>, IsCommutable;

def XVMUL_H : LASX_3R<0b01110100100001001>,
              LASX_3R_DESC_BASE<"xvmul.h", mul, LASX256HOpnd>, IsCommutable;

def XVMUL_W : LASX_3R<0b01110100100001010>,
              LASX_3R_DESC_BASE<"xvmul.w", mul, LASX256WOpnd>, IsCommutable;

def XVMUL_D : LASX_3R<0b01110100100001011>,
              LASX_3R_DESC_BASE<"xvmul.d", mul, LASX256DOpnd>, IsCommutable;


def XVMUH_B : LASX_3R<0b01110100100001100>,
              LASX_3R_DESC_BASE<"xvmuh.b", int_loongarch_lasx_xvmuh_b, LASX256BOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMUH_H : LASX_3R<0b01110100100001101>,
              LASX_3R_DESC_BASE<"xvmuh.h", int_loongarch_lasx_xvmuh_h, LASX256HOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMUH_W : LASX_3R<0b01110100100001110>,
              LASX_3R_DESC_BASE<"xvmuh.w", int_loongarch_lasx_xvmuh_w, LASX256WOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVMUH_D : LASX_3R<0b01110100100001111>,
              LASX_3R_DESC_BASE<"xvmuh.d", int_loongarch_lasx_xvmuh_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMUH_BU : LASX_3R<0b01110100100010000>,
               LASX_3R_DESC_BASE<"xvmuh.bu", int_loongarch_lasx_xvmuh_bu, LASX256BOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMUH_HU : LASX_3R<0b01110100100010001>,
               LASX_3R_DESC_BASE<"xvmuh.hu", int_loongarch_lasx_xvmuh_hu, LASX256HOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMUH_WU : LASX_3R<0b01110100100010010>,
               LASX_3R_DESC_BASE<"xvmuh.wu", int_loongarch_lasx_xvmuh_wu, LASX256WOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVMUH_DU : LASX_3R<0b01110100100010011>,
               LASX_3R_DESC_BASE<"xvmuh.du", int_loongarch_lasx_xvmuh_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMULWEV_H_B : LASX_3R<0b01110100100100000>,
                   LASX_3R_DESC_BASE<"xvmulwev.h.b", int_loongarch_lasx_xvmulwev_h_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMULWEV_W_H : LASX_3R<0b01110100100100001>,
                   LASX_3R_DESC_BASE<"xvmulwev.w.h", int_loongarch_lasx_xvmulwev_w_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMULWEV_D_W : LASX_3R<0b01110100100100010>,
                   LASX_3R_DESC_BASE<"xvmulwev.d.w", int_loongarch_lasx_xvmulwev_d_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVMULWEV_Q_D : LASX_3R<0b01110100100100011>,
                   LASX_3R_DESC_BASE<"xvmulwev.q.d", int_loongarch_lasx_xvmulwev_q_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMULWOD_H_B : LASX_3R<0b01110100100100100>,
                   LASX_3R_DESC_BASE<"xvmulwod.h.b", int_loongarch_lasx_xvmulwod_h_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMULWOD_W_H : LASX_3R<0b01110100100100101>,
                   LASX_3R_DESC_BASE<"xvmulwod.w.h", int_loongarch_lasx_xvmulwod_w_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMULWOD_D_W : LASX_3R<0b01110100100100110>,
                   LASX_3R_DESC_BASE<"xvmulwod.d.w", int_loongarch_lasx_xvmulwod_d_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVMULWOD_Q_D : LASX_3R<0b01110100100100111>,
                   LASX_3R_DESC_BASE<"xvmulwod.q.d", int_loongarch_lasx_xvmulwod_q_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMULWEV_H_BU : LASX_3R<0b01110100100110000>,
                    LASX_3R_DESC_BASE<"xvmulwev.h.bu", int_loongarch_lasx_xvmulwev_h_bu, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMULWEV_W_HU : LASX_3R<0b01110100100110001>,
                    LASX_3R_DESC_BASE<"xvmulwev.w.hu", int_loongarch_lasx_xvmulwev_w_hu, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMULWEV_D_WU : LASX_3R<0b01110100100110010>,
                    LASX_3R_DESC_BASE<"xvmulwev.d.wu", int_loongarch_lasx_xvmulwev_d_wu, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVMULWEV_Q_DU : LASX_3R<0b01110100100110011>,
                    LASX_3R_DESC_BASE<"xvmulwev.q.du", int_loongarch_lasx_xvmulwev_q_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMULWOD_H_BU : LASX_3R<0b01110100100110100>,
                    LASX_3R_DESC_BASE<"xvmulwod.h.bu", int_loongarch_lasx_xvmulwod_h_bu, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMULWOD_W_HU : LASX_3R<0b01110100100110101>,
                    LASX_3R_DESC_BASE<"xvmulwod.w.hu", int_loongarch_lasx_xvmulwod_w_hu, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMULWOD_D_WU : LASX_3R<0b01110100100110110>,
                    LASX_3R_DESC_BASE<"xvmulwod.d.wu", int_loongarch_lasx_xvmulwod_d_wu, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVMULWOD_Q_DU : LASX_3R<0b01110100100110111>,
                    LASX_3R_DESC_BASE<"xvmulwod.q.du", int_loongarch_lasx_xvmulwod_q_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMULWEV_H_BU_B : LASX_3R<0b01110100101000000>,
                      LASX_3R_DESC_BASE<"xvmulwev.h.bu.b", int_loongarch_lasx_xvmulwev_h_bu_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMULWEV_W_HU_H : LASX_3R<0b01110100101000001>,
                      LASX_3R_DESC_BASE<"xvmulwev.w.hu.h", int_loongarch_lasx_xvmulwev_w_hu_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMULWEV_D_WU_W : LASX_3R<0b01110100101000010>,
                      LASX_3R_DESC_BASE<"xvmulwev.d.wu.w", int_loongarch_lasx_xvmulwev_d_wu_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVMULWEV_Q_DU_D : LASX_3R<0b01110100101000011>,
                      LASX_3R_DESC_BASE<"xvmulwev.q.du.d", int_loongarch_lasx_xvmulwev_q_du_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMULWOD_H_BU_B : LASX_3R<0b01110100101000100>,
                      LASX_3R_DESC_BASE<"xvmulwod.h.bu.b", int_loongarch_lasx_xvmulwod_h_bu_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMULWOD_W_HU_H : LASX_3R<0b01110100101000101>,
                      LASX_3R_DESC_BASE<"xvmulwod.w.hu.h", int_loongarch_lasx_xvmulwod_w_hu_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMULWOD_D_WU_W : LASX_3R<0b01110100101000110>,
                      LASX_3R_DESC_BASE<"xvmulwod.d.wu.w", int_loongarch_lasx_xvmulwod_d_wu_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd> ;

def XVMULWOD_Q_DU_D : LASX_3R<0b01110100101000111>,
                      LASX_3R_DESC_BASE<"xvmulwod.q.du.d", int_loongarch_lasx_xvmulwod_q_du_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMADD_B : LASX_3R<0b01110100101010000>,
               LASX_3R_4R_DESC_BASE<"xvmadd.b", muladd, LASX256BOpnd>;

def XVMADD_H : LASX_3R<0b01110100101010001>,
               LASX_3R_4R_DESC_BASE<"xvmadd.h", muladd, LASX256HOpnd>;

def XVMADD_W : LASX_3R<0b01110100101010010>,
               LASX_3R_4R_DESC_BASE<"xvmadd.w", muladd, LASX256WOpnd>;

def XVMADD_D : LASX_3R<0b01110100101010011>,
               LASX_3R_4R_DESC_BASE<"xvmadd.d", muladd, LASX256DOpnd>;


def XVMSUB_B : LASX_3R<0b01110100101010100>,
               LASX_3R_4R_DESC_BASE<"xvmsub.b", mulsub, LASX256BOpnd>;

def XVMSUB_H : LASX_3R<0b01110100101010101>,
               LASX_3R_4R_DESC_BASE<"xvmsub.h", mulsub, LASX256HOpnd>;

def XVMSUB_W : LASX_3R<0b01110100101010110>,
               LASX_3R_4R_DESC_BASE<"xvmsub.w", mulsub, LASX256WOpnd>;

def XVMSUB_D : LASX_3R<0b01110100101010111>,
               LASX_3R_4R_DESC_BASE<"xvmsub.d", mulsub, LASX256DOpnd>;


def XVMADDWEV_H_B : LASX_3R<0b01110100101011000>,
                    LASX_3R_4R_DESC_BASE<"xvmaddwev.h.b", int_loongarch_lasx_xvmaddwev_h_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMADDWEV_W_H : LASX_3R<0b01110100101011001>,
                    LASX_3R_4R_DESC_BASE<"xvmaddwev.w.h", int_loongarch_lasx_xvmaddwev_w_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMADDWEV_D_W : LASX_3R<0b01110100101011010>,
                    LASX_3R_4R_DESC_BASE<"xvmaddwev.d.w", int_loongarch_lasx_xvmaddwev_d_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVMADDWEV_Q_D : LASX_3R<0b01110100101011011>,
                    LASX_3R_4R_DESC_BASE<"xvmaddwev.q.d", int_loongarch_lasx_xvmaddwev_q_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMADDWOD_H_B : LASX_3R<0b01110100101011100>,
                    LASX_3R_4R_DESC_BASE<"xvmaddwod.h.b", int_loongarch_lasx_xvmaddwod_h_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMADDWOD_W_H : LASX_3R<0b01110100101011101>,
                    LASX_3R_4R_DESC_BASE<"xvmaddwod.w.h", int_loongarch_lasx_xvmaddwod_w_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMADDWOD_D_W : LASX_3R<0b01110100101011110>,
                    LASX_3R_4R_DESC_BASE<"xvmaddwod.d.w", int_loongarch_lasx_xvmaddwod_d_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVMADDWOD_Q_D : LASX_3R<0b01110100101011111>,
                    LASX_3R_4R_DESC_BASE<"xvmaddwod.q.d", int_loongarch_lasx_xvmaddwod_q_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMADDWEV_H_BU : LASX_3R<0b01110100101101000>,
                     LASX_3R_4R_DESC_BASE<"xvmaddwev.h.bu", int_loongarch_lasx_xvmaddwev_h_bu, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMADDWEV_W_HU : LASX_3R<0b01110100101101001>,
                     LASX_3R_4R_DESC_BASE<"xvmaddwev.w.hu", int_loongarch_lasx_xvmaddwev_w_hu, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMADDWEV_D_WU : LASX_3R<0b01110100101101010>,
                     LASX_3R_4R_DESC_BASE<"xvmaddwev.d.wu", int_loongarch_lasx_xvmaddwev_d_wu, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVMADDWEV_Q_DU : LASX_3R<0b01110100101101011>,
                     LASX_3R_4R_DESC_BASE<"xvmaddwev.q.du", int_loongarch_lasx_xvmaddwev_q_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMADDWOD_H_BU : LASX_3R<0b01110100101101100>,
                     LASX_3R_4R_DESC_BASE<"xvmaddwod.h.bu", int_loongarch_lasx_xvmaddwod_h_bu, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMADDWOD_W_HU : LASX_3R<0b01110100101101101>,
                     LASX_3R_4R_DESC_BASE<"xvmaddwod.w.hu", int_loongarch_lasx_xvmaddwod_w_hu, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMADDWOD_D_WU : LASX_3R<0b01110100101101110>,
                     LASX_3R_4R_DESC_BASE<"xvmaddwod.d.wu", int_loongarch_lasx_xvmaddwod_d_wu, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVMADDWOD_Q_DU : LASX_3R<0b01110100101101111>,
                     LASX_3R_4R_DESC_BASE<"xvmaddwod.q.du", int_loongarch_lasx_xvmaddwod_q_du, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMADDWEV_H_BU_B : LASX_3R<0b01110100101111000>,
                       LASX_3R_4R_DESC_BASE<"xvmaddwev.h.bu.b", int_loongarch_lasx_xvmaddwev_h_bu_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMADDWEV_W_HU_H : LASX_3R<0b01110100101111001>,
                       LASX_3R_4R_DESC_BASE<"xvmaddwev.w.hu.h", int_loongarch_lasx_xvmaddwev_w_hu_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMADDWEV_D_WU_W : LASX_3R<0b01110100101111010>,
                       LASX_3R_4R_DESC_BASE<"xvmaddwev.d.wu.w", int_loongarch_lasx_xvmaddwev_d_wu_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVMADDWEV_Q_DU_D : LASX_3R<0b01110100101111011>,
                       LASX_3R_4R_DESC_BASE<"xvmaddwev.q.du.d", int_loongarch_lasx_xvmaddwev_q_du_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVMADDWOD_H_BU_B : LASX_3R<0b01110100101111100>,
                       LASX_3R_4R_DESC_BASE<"xvmaddwod.h.bu.b", int_loongarch_lasx_xvmaddwod_h_bu_b, LASX256HOpnd, LASX256BOpnd, LASX256BOpnd>;

def XVMADDWOD_W_HU_H : LASX_3R<0b01110100101111101>,
                       LASX_3R_4R_DESC_BASE<"xvmaddwod.w.hu.h", int_loongarch_lasx_xvmaddwod_w_hu_h, LASX256WOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVMADDWOD_D_WU_W : LASX_3R<0b01110100101111110>,
                       LASX_3R_4R_DESC_BASE<"xvmaddwod.d.wu.w", int_loongarch_lasx_xvmaddwod_d_wu_w, LASX256DOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVMADDWOD_Q_DU_D : LASX_3R<0b01110100101111111>,
                       LASX_3R_4R_DESC_BASE<"xvmaddwod.q.du.d", int_loongarch_lasx_xvmaddwod_q_du_d, LASX256DOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVDIV_B : LASX_3R<0b01110100111000000>,
              LASX_3R_DESC_BASE<"xvdiv.b", sdiv, LASX256BOpnd>;

def XVDIV_H : LASX_3R<0b01110100111000001>,
              LASX_3R_DESC_BASE<"xvdiv.h", sdiv, LASX256HOpnd>;

def XVDIV_W : LASX_3R<0b01110100111000010>,
              LASX_3R_DESC_BASE<"xvdiv.w", sdiv, LASX256WOpnd>;

def XVDIV_D : LASX_3R<0b01110100111000011>,
              LASX_3R_DESC_BASE<"xvdiv.d", sdiv, LASX256DOpnd>;


def XVMOD_B : LASX_3R<0b01110100111000100>,
              LASX_3R_DESC_BASE<"xvmod.b", srem, LASX256BOpnd>;

def XVMOD_H : LASX_3R<0b01110100111000101>,
              LASX_3R_DESC_BASE<"xvmod.h", srem, LASX256HOpnd>;

def XVMOD_W : LASX_3R<0b01110100111000110>,
              LASX_3R_DESC_BASE<"xvmod.w", srem, LASX256WOpnd>;

def XVMOD_D : LASX_3R<0b01110100111000111>,
              LASX_3R_DESC_BASE<"xvmod.d", srem, LASX256DOpnd>;


def XVDIV_BU : LASX_3R<0b01110100111001000>,
               LASX_3R_DESC_BASE<"xvdiv.bu", udiv, LASX256BOpnd>;

def XVDIV_HU : LASX_3R<0b01110100111001001>,
               LASX_3R_DESC_BASE<"xvdiv.hu", udiv, LASX256HOpnd>;

def XVDIV_WU : LASX_3R<0b01110100111001010>,
               LASX_3R_DESC_BASE<"xvdiv.wu", udiv, LASX256WOpnd>;

def XVDIV_DU : LASX_3R<0b01110100111001011>,
               LASX_3R_DESC_BASE<"xvdiv.du", udiv, LASX256DOpnd>;


def XVMOD_BU : LASX_3R<0b01110100111001100>,
               LASX_3R_DESC_BASE<"xvmod.bu", urem, LASX256BOpnd>;

def XVMOD_HU : LASX_3R<0b01110100111001101>,
               LASX_3R_DESC_BASE<"xvmod.hu", urem, LASX256HOpnd>;

def XVMOD_WU : LASX_3R<0b01110100111001110>,
               LASX_3R_DESC_BASE<"xvmod.wu", urem, LASX256WOpnd>;

def XVMOD_DU : LASX_3R<0b01110100111001111>,
               LASX_3R_DESC_BASE<"xvmod.du", urem, LASX256DOpnd>;


def XVSLL_B : LASX_3R<0b01110100111010000>,
              LASX_3R_DESC_BASE<"xvsll.b", shl, LASX256BOpnd>;

def XVSLL_H : LASX_3R<0b01110100111010001>,
              LASX_3R_DESC_BASE<"xvsll.h", shl, LASX256HOpnd>;

def XVSLL_W : LASX_3R<0b01110100111010010>,
              LASX_3R_DESC_BASE<"xvsll.w", shl, LASX256WOpnd>;

def XVSLL_D : LASX_3R<0b01110100111010011>,
              LASX_3R_DESC_BASE<"xvsll.d", shl, LASX256DOpnd>;


def XVSRL_B : LASX_3R<0b01110100111010100>,
              LASX_3R_DESC_BASE<"xvsrl.b", srl, LASX256BOpnd>;

def XVSRL_H : LASX_3R<0b01110100111010101>,
              LASX_3R_DESC_BASE<"xvsrl.h", srl, LASX256HOpnd>;

def XVSRL_W : LASX_3R<0b01110100111010110>,
              LASX_3R_DESC_BASE<"xvsrl.w", srl, LASX256WOpnd>;

def XVSRL_D : LASX_3R<0b01110100111010111>,
              LASX_3R_DESC_BASE<"xvsrl.d", srl, LASX256DOpnd>;


def XVSRA_B : LASX_3R<0b01110100111011000>,
              LASX_3R_DESC_BASE<"xvsra.b", sra, LASX256BOpnd>;

def XVSRA_H : LASX_3R<0b01110100111011001>,
              LASX_3R_DESC_BASE<"xvsra.h", sra, LASX256HOpnd>;

def XVSRA_W : LASX_3R<0b01110100111011010>,
              LASX_3R_DESC_BASE<"xvsra.w", sra, LASX256WOpnd>;

def XVSRA_D : LASX_3R<0b01110100111011011>,
              LASX_3R_DESC_BASE<"xvsra.d", sra, LASX256DOpnd>;


def XVROTR_B : LASX_3R<0b01110100111011100>,
               LASX_3R_DESC_BASE<"xvrotr.b", int_loongarch_lasx_xvrotr_b, LASX256BOpnd>;

def XVROTR_H : LASX_3R<0b01110100111011101>,
               LASX_3R_DESC_BASE<"xvrotr.h", int_loongarch_lasx_xvrotr_h, LASX256HOpnd>;

def XVROTR_W : LASX_3R<0b01110100111011110>,
               LASX_3R_DESC_BASE<"xvrotr.w", int_loongarch_lasx_xvrotr_w, LASX256WOpnd>;

def XVROTR_D : LASX_3R<0b01110100111011111>,
               LASX_3R_DESC_BASE<"xvrotr.d", int_loongarch_lasx_xvrotr_d, LASX256DOpnd>;


def XVSRLR_B : LASX_3R<0b01110100111100000>,
               LASX_3R_DESC_BASE<"xvsrlr.b", int_loongarch_lasx_xvsrlr_b, LASX256BOpnd>;

def XVSRLR_H : LASX_3R<0b01110100111100001>,
               LASX_3R_DESC_BASE<"xvsrlr.h", int_loongarch_lasx_xvsrlr_h, LASX256HOpnd>;

def XVSRLR_W : LASX_3R<0b01110100111100010>,
               LASX_3R_DESC_BASE<"xvsrlr.w", int_loongarch_lasx_xvsrlr_w, LASX256WOpnd>;

def XVSRLR_D : LASX_3R<0b01110100111100011>,
               LASX_3R_DESC_BASE<"xvsrlr.d", int_loongarch_lasx_xvsrlr_d, LASX256DOpnd>;


def XVSRAR_B : LASX_3R<0b01110100111100100>,
               LASX_3R_DESC_BASE<"xvsrar.b", int_loongarch_lasx_xvsrar_b, LASX256BOpnd>;

def XVSRAR_H : LASX_3R<0b01110100111100101>,
               LASX_3R_DESC_BASE<"xvsrar.h", int_loongarch_lasx_xvsrar_h, LASX256HOpnd>;

def XVSRAR_W : LASX_3R<0b01110100111100110>,
               LASX_3R_DESC_BASE<"xvsrar.w", int_loongarch_lasx_xvsrar_w, LASX256WOpnd>;

def XVSRAR_D : LASX_3R<0b01110100111100111>,
               LASX_3R_DESC_BASE<"xvsrar.d", int_loongarch_lasx_xvsrar_d, LASX256DOpnd>;


def XVSRLN_B_H : LASX_3R<0b01110100111101001>,
                 LASX_3R_DESC_BASE<"xvsrln.b.h", int_loongarch_lasx_xvsrln_b_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSRLN_H_W : LASX_3R<0b01110100111101010>,
                 LASX_3R_DESC_BASE<"xvsrln.h.w", int_loongarch_lasx_xvsrln_h_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSRLN_W_D : LASX_3R<0b01110100111101011>,
                 LASX_3R_DESC_BASE<"xvsrln.w.d", int_loongarch_lasx_xvsrln_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSRAN_B_H : LASX_3R<0b01110100111101101>,
                 LASX_3R_DESC_BASE<"xvsran.b.h", int_loongarch_lasx_xvsran_b_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSRAN_H_W : LASX_3R<0b01110100111101110>,
                 LASX_3R_DESC_BASE<"xvsran.h.w", int_loongarch_lasx_xvsran_h_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSRAN_W_D : LASX_3R<0b01110100111101111>,
                 LASX_3R_DESC_BASE<"xvsran.w.d", int_loongarch_lasx_xvsran_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSRLRN_B_H : LASX_3R<0b01110100111110001>,
                  LASX_3R_DESC_BASE<"xvsrlrn.b.h", int_loongarch_lasx_xvsrlrn_b_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSRLRN_H_W : LASX_3R<0b01110100111110010>,
                  LASX_3R_DESC_BASE<"xvsrlrn.h.w", int_loongarch_lasx_xvsrlrn_h_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSRLRN_W_D : LASX_3R<0b01110100111110011>,
                  LASX_3R_DESC_BASE<"xvsrlrn.w.d", int_loongarch_lasx_xvsrlrn_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSRARN_B_H : LASX_3R<0b01110100111110101>,
                  LASX_3R_DESC_BASE<"xvsrarn.b.h", int_loongarch_lasx_xvsrarn_b_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSRARN_H_W : LASX_3R<0b01110100111110110>,
                  LASX_3R_DESC_BASE<"xvsrarn.h.w", int_loongarch_lasx_xvsrarn_h_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSRARN_W_D : LASX_3R<0b01110100111110111>,
                  LASX_3R_DESC_BASE<"xvsrarn.w.d", int_loongarch_lasx_xvsrarn_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSSRLN_B_H : LASX_3R<0b01110100111111001>,
                  LASX_3R_DESC_BASE<"xvssrln.b.h", int_loongarch_lasx_xvssrln_b_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSSRLN_H_W : LASX_3R<0b01110100111111010>,
                  LASX_3R_DESC_BASE<"xvssrln.h.w", int_loongarch_lasx_xvssrln_h_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSSRLN_W_D : LASX_3R<0b01110100111111011>,
                  LASX_3R_DESC_BASE<"xvssrln.w.d", int_loongarch_lasx_xvssrln_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSSRAN_B_H : LASX_3R<0b01110100111111101>,
                  LASX_3R_DESC_BASE<"xvssran.b.h", int_loongarch_lasx_xvssran_b_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSSRAN_H_W : LASX_3R<0b01110100111111110>,
                  LASX_3R_DESC_BASE<"xvssran.h.w", int_loongarch_lasx_xvssran_h_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSSRAN_W_D : LASX_3R<0b01110100111111111>,
                  LASX_3R_DESC_BASE<"xvssran.w.d", int_loongarch_lasx_xvssran_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSSRLRN_B_H : LASX_3R<0b01110101000000001>,
                   LASX_3R_DESC_BASE<"xvssrlrn.b.h", int_loongarch_lasx_xvssrlrn_b_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSSRLRN_H_W : LASX_3R<0b01110101000000010>,
                   LASX_3R_DESC_BASE<"xvssrlrn.h.w", int_loongarch_lasx_xvssrlrn_h_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSSRLRN_W_D : LASX_3R<0b01110101000000011>,
                   LASX_3R_DESC_BASE<"xvssrlrn.w.d", int_loongarch_lasx_xvssrlrn_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSSRARN_B_H : LASX_3R<0b01110101000000101>,
                   LASX_3R_DESC_BASE<"xvssrarn.b.h", int_loongarch_lasx_xvssrarn_b_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSSRARN_H_W : LASX_3R<0b01110101000000110>,
                   LASX_3R_DESC_BASE<"xvssrarn.h.w", int_loongarch_lasx_xvssrarn_h_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSSRARN_W_D : LASX_3R<0b01110101000000111>,
                   LASX_3R_DESC_BASE<"xvssrarn.w.d", int_loongarch_lasx_xvssrarn_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSSRLN_BU_H : LASX_3R<0b01110101000001001>,
                   LASX_3R_DESC_BASE<"xvssrln.bu.h", int_loongarch_lasx_xvssrln_bu_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSSRLN_HU_W : LASX_3R<0b01110101000001010>,
                   LASX_3R_DESC_BASE<"xvssrln.hu.w", int_loongarch_lasx_xvssrln_hu_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSSRLN_WU_D : LASX_3R<0b01110101000001011>,
                   LASX_3R_DESC_BASE<"xvssrln.wu.d", int_loongarch_lasx_xvssrln_wu_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSSRAN_BU_H : LASX_3R<0b01110101000001101>,
                   LASX_3R_DESC_BASE<"xvssran.bu.h", int_loongarch_lasx_xvssran_bu_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSSRAN_HU_W : LASX_3R<0b01110101000001110>,
                   LASX_3R_DESC_BASE<"xvssran.hu.w", int_loongarch_lasx_xvssran_hu_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSSRAN_WU_D : LASX_3R<0b01110101000001111>,
                   LASX_3R_DESC_BASE<"xvssran.wu.d", int_loongarch_lasx_xvssran_wu_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSSRLRN_BU_H : LASX_3R<0b01110101000010001>,
                    LASX_3R_DESC_BASE<"xvssrlrn.bu.h", int_loongarch_lasx_xvssrlrn_bu_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSSRLRN_HU_W : LASX_3R<0b01110101000010010>,
                    LASX_3R_DESC_BASE<"xvssrlrn.hu.w", int_loongarch_lasx_xvssrlrn_hu_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSSRLRN_WU_D : LASX_3R<0b01110101000010011>,
                    LASX_3R_DESC_BASE<"xvssrlrn.wu.d", int_loongarch_lasx_xvssrlrn_wu_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSSRARN_BU_H : LASX_3R<0b01110101000010101>,
                    LASX_3R_DESC_BASE<"xvssrarn.bu.h", int_loongarch_lasx_xvssrarn_bu_h, LASX256BOpnd, LASX256HOpnd, LASX256HOpnd>;

def XVSSRARN_HU_W : LASX_3R<0b01110101000010110>,
                    LASX_3R_DESC_BASE<"xvssrarn.hu.w", int_loongarch_lasx_xvssrarn_hu_w, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVSSRARN_WU_D : LASX_3R<0b01110101000010111>,
                    LASX_3R_DESC_BASE<"xvssrarn.wu.d", int_loongarch_lasx_xvssrarn_wu_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVBITCLR_B : LASX_3R<0b01110101000011000>,
                 LASX_3R_DESC_BASE<"xvbitclr.b", xvbitclr_b, LASX256BOpnd>;

def XVBITCLR_H : LASX_3R<0b01110101000011001>,
                 LASX_3R_DESC_BASE<"xvbitclr.h", xvbitclr_h, LASX256HOpnd>;

def XVBITCLR_W : LASX_3R<0b01110101000011010>,
                 LASX_3R_DESC_BASE<"xvbitclr.w", xvbitclr_w, LASX256WOpnd>;

def XVBITCLR_D : LASX_3R<0b01110101000011011>,
                 LASX_3R_DESC_BASE<"xvbitclr.d", xvbitclr_d, LASX256DOpnd>;


def XVBITSET_B : LASX_3R<0b01110101000011100>,
                 LASX_3R_DESC_BASE<"xvbitset.b", int_loongarch_lasx_xvbitset_b, LASX256BOpnd>;

def XVBITSET_H : LASX_3R<0b01110101000011101>,
                 LASX_3R_DESC_BASE<"xvbitset.h", int_loongarch_lasx_xvbitset_h, LASX256HOpnd>;

def XVBITSET_W : LASX_3R<0b01110101000011110>,
                 LASX_3R_DESC_BASE<"xvbitset.w", int_loongarch_lasx_xvbitset_w, LASX256WOpnd>;

def XVBITSET_D : LASX_3R<0b01110101000011111>,
                 LASX_3R_DESC_BASE<"xvbitset.d", int_loongarch_lasx_xvbitset_d, LASX256DOpnd>;


def XVBITREV_B : LASX_3R<0b01110101000100000>,
                 LASX_3R_DESC_BASE<"xvbitrev.b", int_loongarch_lasx_xvbitrev_b, LASX256BOpnd>;

def XVBITREV_H : LASX_3R<0b01110101000100001>,
                 LASX_3R_DESC_BASE<"xvbitrev.h", int_loongarch_lasx_xvbitrev_h, LASX256HOpnd>;

def XVBITREV_W : LASX_3R<0b01110101000100010>,
                 LASX_3R_DESC_BASE<"xvbitrev.w", int_loongarch_lasx_xvbitrev_w, LASX256WOpnd>;

def XVBITREV_D : LASX_3R<0b01110101000100011>,
                 LASX_3R_DESC_BASE<"xvbitrev.d", int_loongarch_lasx_xvbitrev_d, LASX256DOpnd>;


def XVPACKEV_B : LASX_3R<0b01110101000101100>,
                 LASX_3R_DESC_BASE<"xvpackev.b", LoongArchVPACKEV, LASX256BOpnd>;

def XVPACKEV_H : LASX_3R<0b01110101000101101>,
                 LASX_3R_DESC_BASE<"xvpackev.h", LoongArchVPACKEV, LASX256HOpnd>;

def XVPACKEV_W : LASX_3R<0b01110101000101110>,
                 LASX_3R_DESC_BASE<"xvpackev.w", LoongArchVPACKEV, LASX256WOpnd>;

def XVPACKEV_D : LASX_3R<0b01110101000101111>,
                 LASX_3R_DESC_BASE<"xvpackev.d", LoongArchVPACKEV, LASX256DOpnd>;


def XVPACKOD_B : LASX_3R<0b01110101000110000>,
                 LASX_3R_DESC_BASE<"xvpackod.b", LoongArchVPACKOD, LASX256BOpnd>;

def XVPACKOD_H : LASX_3R<0b01110101000110001>,
                 LASX_3R_DESC_BASE<"xvpackod.h", LoongArchVPACKOD, LASX256HOpnd>;

def XVPACKOD_W : LASX_3R<0b01110101000110010>,
                 LASX_3R_DESC_BASE<"xvpackod.w", LoongArchVPACKOD, LASX256WOpnd>;

def XVPACKOD_D : LASX_3R<0b01110101000110011>,
                 LASX_3R_DESC_BASE<"xvpackod.d", LoongArchVPACKOD, LASX256DOpnd>;


def XVILVL_B : LASX_3R<0b01110101000110100>,
               LASX_3R_DESC_BASE<"xvilvl.b", LoongArchVILVL, LASX256BOpnd>;

def XVILVL_H : LASX_3R<0b01110101000110101>,
               LASX_3R_DESC_BASE<"xvilvl.h", LoongArchVILVL, LASX256HOpnd>;

def XVILVL_W : LASX_3R<0b01110101000110110>,
               LASX_3R_DESC_BASE<"xvilvl.w", LoongArchVILVL, LASX256WOpnd>;

def XVILVL_D : LASX_3R<0b01110101000110111>,
               LASX_3R_DESC_BASE<"xvilvl.d", LoongArchVILVL, LASX256DOpnd>;


def XVILVH_B : LASX_3R<0b01110101000111000>,
               LASX_3R_DESC_BASE<"xvilvh.b", LoongArchVILVH, LASX256BOpnd>;

def XVILVH_H : LASX_3R<0b01110101000111001>,
               LASX_3R_DESC_BASE<"xvilvh.h", LoongArchVILVH, LASX256HOpnd>;

def XVILVH_W : LASX_3R<0b01110101000111010>,
               LASX_3R_DESC_BASE<"xvilvh.w", LoongArchVILVH, LASX256WOpnd>;

def XVILVH_D : LASX_3R<0b01110101000111011>,
               LASX_3R_DESC_BASE<"xvilvh.d", LoongArchVILVH, LASX256DOpnd>;


def XVPICKEV_B : LASX_3R<0b01110101000111100>,
                 LASX_3R_DESC_BASE<"xvpickev.b", LoongArchVPICKEV, LASX256BOpnd>;

def XVPICKEV_H : LASX_3R<0b01110101000111101>,
                 LASX_3R_DESC_BASE<"xvpickev.h", LoongArchVPICKEV, LASX256HOpnd>;

def XVPICKEV_W : LASX_3R<0b01110101000111110>,
                 LASX_3R_DESC_BASE<"xvpickev.w", LoongArchVPICKEV, LASX256WOpnd>;

def XVPICKEV_D : LASX_3R<0b01110101000111111>,
                 LASX_3R_DESC_BASE<"xvpickev.d", LoongArchVPICKEV, LASX256DOpnd>;


def XVPICKOD_B : LASX_3R<0b01110101001000000>,
                 LASX_3R_DESC_BASE<"xvpickod.b", LoongArchVPICKOD, LASX256BOpnd>;

def XVPICKOD_H : LASX_3R<0b01110101001000001>,
                 LASX_3R_DESC_BASE<"xvpickod.h", LoongArchVPICKOD, LASX256HOpnd>;

def XVPICKOD_W : LASX_3R<0b01110101001000010>,
                 LASX_3R_DESC_BASE<"xvpickod.w", LoongArchVPICKOD, LASX256WOpnd>;

def XVPICKOD_D : LASX_3R<0b01110101001000011>,
                 LASX_3R_DESC_BASE<"xvpickod.d", LoongArchVPICKOD, LASX256DOpnd>;


def XVREPLVE_B : LASX_3R_1GP<0b01110101001000100>,
                 LASX_3R_VREPLVE_DESC_BASE<"xvreplve.b", int_loongarch_lasx_xvreplve_b, LASX256BOpnd>;

def XVREPLVE_H : LASX_3R_1GP<0b01110101001000101>,
                 LASX_3R_VREPLVE_DESC_BASE<"xvreplve.h", int_loongarch_lasx_xvreplve_h, LASX256HOpnd>;

def XVREPLVE_W : LASX_3R_1GP<0b01110101001000110>,
                 LASX_3R_VREPLVE_DESC_BASE<"xvreplve.w", int_loongarch_lasx_xvreplve_w, LASX256WOpnd>;

def XVREPLVE_D : LASX_3R_1GP<0b01110101001000111>,
                 LASX_3R_VREPLVE_DESC_BASE<"xvreplve.d", int_loongarch_lasx_xvreplve_d, LASX256DOpnd>;


def XVAND_V : LASX_3R<0b01110101001001100>,
              LASX_VEC_DESC_BASE<"xvand.v", and, LASX256BOpnd>;
class XAND_V_H_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<and, LASX256HOpnd>;
class XAND_V_W_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<and, LASX256WOpnd>;
class XAND_V_D_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<and, LASX256DOpnd>;

def XAND_V_H_PSEUDO : XAND_V_H_PSEUDO_DESC,
                      PseudoInstExpansion<(XVAND_V LASX256BOpnd:$xd,
                                                   LASX256BOpnd:$xj,
                                                   LASX256BOpnd:$xk)>;
def XAND_V_W_PSEUDO : XAND_V_W_PSEUDO_DESC,
                      PseudoInstExpansion<(XVAND_V LASX256BOpnd:$xd,
                                                   LASX256BOpnd:$xj,
                                                   LASX256BOpnd:$xk)>;
def XAND_V_D_PSEUDO : XAND_V_D_PSEUDO_DESC,
                      PseudoInstExpansion<(XVAND_V LASX256BOpnd:$xd,
                                                   LASX256BOpnd:$xj,
                                                   LASX256BOpnd:$xk)>;


def XVOR_V : LASX_3R<0b01110101001001101>,
            LASX_VEC_DESC_BASE<"xvor.v", or, LASX256BOpnd>;
class X_OR_V_H_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<or, LASX256HOpnd>;
class X_OR_V_W_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<or, LASX256WOpnd>;
class X_OR_V_D_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<or, LASX256DOpnd>;

def X_OR_V_H_PSEUDO : X_OR_V_H_PSEUDO_DESC,
                      PseudoInstExpansion<(XVOR_V LASX256BOpnd:$xd,
                                                  LASX256BOpnd:$xj,
                                                  LASX256BOpnd:$xk)>;
def X_OR_V_W_PSEUDO : X_OR_V_W_PSEUDO_DESC,
                      PseudoInstExpansion<(XVOR_V LASX256BOpnd:$xd,
                                                  LASX256BOpnd:$xj,
                                                  LASX256BOpnd:$xk)>;
def X_OR_V_D_PSEUDO : X_OR_V_D_PSEUDO_DESC,
                      PseudoInstExpansion<(XVOR_V LASX256BOpnd:$xd,
                                                  LASX256BOpnd:$xj,
                                                  LASX256BOpnd:$xk)>;


def XVXOR_V : LASX_3R<0b01110101001001110>,
              LASX_VEC_DESC_BASE<"xvxor.v", xor, LASX256BOpnd>;
class XXOR_V_H_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<xor, LASX256HOpnd>;
class XXOR_V_W_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<xor, LASX256WOpnd>;
class XXOR_V_D_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<xor, LASX256DOpnd>;

def XXOR_V_H_PSEUDO : XXOR_V_H_PSEUDO_DESC,
                      PseudoInstExpansion<(XVXOR_V LASX256BOpnd:$xd,
                                                   LASX256BOpnd:$xj,
                                                   LASX256BOpnd:$xk)>;
def XXOR_V_W_PSEUDO : XXOR_V_W_PSEUDO_DESC,
                      PseudoInstExpansion<(XVXOR_V LASX256BOpnd:$xd,
                                                   LASX256BOpnd:$xj,
                                                   LASX256BOpnd:$xk)>;
def XXOR_V_D_PSEUDO : XXOR_V_D_PSEUDO_DESC,
                      PseudoInstExpansion<(XVXOR_V LASX256BOpnd:$xd,
                                                   LASX256BOpnd:$xj,
                                                   LASX256BOpnd:$xk)>;


def XVNOR_V : LASX_3R<0b01110101001001111>,
              LASX_VEC_DESC_BASE<"xvnor.v", LoongArchVNOR, LASX256BOpnd>;

class XNOR_V_H_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<LoongArchVNOR, LASX256HOpnd>;
class XNOR_V_W_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<LoongArchVNOR, LASX256WOpnd>;
class XNOR_V_D_PSEUDO_DESC : LASX_VEC_PSEUDO_BASE<LoongArchVNOR, LASX256DOpnd>;

def XNOR_V_H_PSEUDO : XNOR_V_H_PSEUDO_DESC,
                      PseudoInstExpansion<(XVNOR_V LASX256BOpnd:$xd,
                                                   LASX256BOpnd:$xj,
                                                   LASX256BOpnd:$xk)>;
def XNOR_V_W_PSEUDO : XNOR_V_W_PSEUDO_DESC,
                      PseudoInstExpansion<(XVNOR_V LASX256BOpnd:$xd,
                                                   LASX256BOpnd:$xj,
                                                   LASX256BOpnd:$xk)>;
def XNOR_V_D_PSEUDO : XNOR_V_D_PSEUDO_DESC,
                      PseudoInstExpansion<(XVNOR_V LASX256BOpnd:$xd,
                                                   LASX256BOpnd:$xj,
                                                   LASX256BOpnd:$xk)>;


def XVANDN_V : LASX_3R<0b01110101001010000>,
               LASX_3R_DESC_BASE<"xvandn.v", int_loongarch_lasx_xvandn_v, LASX256BOpnd>;


class LASX_ANDN_PSEUDO_BASE<RegisterOperand RO> :
                            LASXPseudo<(outs RO:$xd), (ins RO:$xj, RO:$xk),
                            []>,
                            PseudoInstExpansion<(XVANDN_V LASX256BOpnd:$xd,
                                                          LASX256BOpnd:$xj,
                                                          LASX256BOpnd:$xk)>;

def XVANDN_H_PSEUDO  : LASX_ANDN_PSEUDO_BASE<LASX256HOpnd>;
def XVANDN_W_PSEUDO  : LASX_ANDN_PSEUDO_BASE<LASX256WOpnd>;
def XVANDN_D_PSEUDO  : LASX_ANDN_PSEUDO_BASE<LASX256DOpnd>;


def XVORN_V : LASX_3R<0b01110101001010001>,
              LASX_3R_DESC_BASE<"xvorn.v", int_loongarch_lasx_xvorn_v, LASX256BOpnd>;


class LASX_ORN_PSEUDO_BASE<RegisterOperand RO> :
                            LASXPseudo<(outs RO:$xd), (ins RO:$xj, RO:$xk),
                            []>,
                            PseudoInstExpansion<(XVORN_V LASX256BOpnd:$xd,
                                                         LASX256BOpnd:$xj,
                                                         LASX256BOpnd:$xk)>;

def XVORN_H_PSEUDO  : LASX_ORN_PSEUDO_BASE<LASX256HOpnd>;
def XVORN_W_PSEUDO  : LASX_ORN_PSEUDO_BASE<LASX256WOpnd>;
def XVORN_D_PSEUDO  : LASX_ORN_PSEUDO_BASE<LASX256DOpnd>;


def XVFRSTP_B : LASX_3R<0b01110101001010110>,
                LASX_3R_4R_DESC_BASE<"xvfrstp.b", int_loongarch_lasx_xvfrstp_b, LASX256BOpnd>;

def XVFRSTP_H : LASX_3R<0b01110101001010111>,
                LASX_3R_4R_DESC_BASE<"xvfrstp.h", int_loongarch_lasx_xvfrstp_h, LASX256HOpnd>;


def XVADD_Q : LASX_3R<0b01110101001011010>, IsCommutable,
              LASX_3R_DESC_BASE<"xvadd.q", int_loongarch_lasx_xvadd_q, LASX256DOpnd>;

def XVSUB_Q : LASX_3R<0b01110101001011011>,
              LASX_3R_DESC_BASE<"xvsub.q", int_loongarch_lasx_xvsub_q, LASX256DOpnd>;


def XVSIGNCOV_B : LASX_3R<0b01110101001011100>,
                  LASX_3R_DESC_BASE<"xvsigncov.b", int_loongarch_lasx_xvsigncov_b, LASX256BOpnd>;

def XVSIGNCOV_H : LASX_3R<0b01110101001011101>,
                  LASX_3R_DESC_BASE<"xvsigncov.h", int_loongarch_lasx_xvsigncov_h, LASX256HOpnd>;

def XVSIGNCOV_W : LASX_3R<0b01110101001011110>,
                  LASX_3R_DESC_BASE<"xvsigncov.w", int_loongarch_lasx_xvsigncov_w, LASX256WOpnd>;

def XVSIGNCOV_D : LASX_3R<0b01110101001011111>,
                  LASX_3R_DESC_BASE<"xvsigncov.d", int_loongarch_lasx_xvsigncov_d, LASX256DOpnd>;


def XVFADD_S : LASX_3R<0b01110101001100001>, IsCommutable,
               LASX_3RF_DESC_BASE<"xvfadd.s", fadd, LASX256WOpnd>;

def XVFADD_D : LASX_3R<0b01110101001100010>, IsCommutable,
               LASX_3RF_DESC_BASE<"xvfadd.d", fadd, LASX256DOpnd>;


def XVFSUB_S : LASX_3R<0b01110101001100101>,
               LASX_3RF_DESC_BASE<"xvfsub.s", fsub, LASX256WOpnd>;

def XVFSUB_D : LASX_3R<0b01110101001100110>,
               LASX_3RF_DESC_BASE<"xvfsub.d", fsub, LASX256DOpnd>;


def XVFMUL_S : LASX_3R<0b01110101001110001>,
               LASX_3RF_DESC_BASE<"xvfmul.s", fmul, LASX256WOpnd>;

def XVFMUL_D : LASX_3R<0b01110101001110010>,
               LASX_3RF_DESC_BASE<"xvfmul.d", fmul, LASX256DOpnd>;


def XVFDIV_S : LASX_3R<0b01110101001110101>,
               LASX_3RF_DESC_BASE<"xvfdiv.s", fdiv, LASX256WOpnd>;

def XVFDIV_D : LASX_3R<0b01110101001110110>,
               LASX_3RF_DESC_BASE<"xvfdiv.d", fdiv, LASX256DOpnd>;


def XVFMAX_S : LASX_3R<0b01110101001111001>,
               LASX_3RF_DESC_BASE<"xvfmax.s", int_loongarch_lasx_xvfmax_s, LASX256WOpnd>;

def XVFMAX_D : LASX_3R<0b01110101001111010>,
               LASX_3RF_DESC_BASE<"xvfmax.d", int_loongarch_lasx_xvfmax_d, LASX256DOpnd>;


def XVFMIN_S : LASX_3R<0b01110101001111101>,
               LASX_3RF_DESC_BASE<"xvfmin.s", int_loongarch_lasx_xvfmin_s, LASX256WOpnd>;

def XVFMIN_D : LASX_3R<0b01110101001111110>,
               LASX_3RF_DESC_BASE<"xvfmin.d", int_loongarch_lasx_xvfmin_d, LASX256DOpnd>;


def XVFMAXA_S : LASX_3R<0b01110101010000001>,
                LASX_3RF_DESC_BASE<"xvfmaxa.s", int_loongarch_lasx_xvfmaxa_s, LASX256WOpnd>;

def XVFMAXA_D : LASX_3R<0b01110101010000010>,
                LASX_3RF_DESC_BASE<"xvfmaxa.d", int_loongarch_lasx_xvfmaxa_d, LASX256DOpnd>;


def XVFMINA_S : LASX_3R<0b01110101010000101>,
                LASX_3RF_DESC_BASE<"xvfmina.s", int_loongarch_lasx_xvfmina_s, LASX256WOpnd>;

def XVFMINA_D : LASX_3R<0b01110101010000110>,
                LASX_3RF_DESC_BASE<"xvfmina.d", int_loongarch_lasx_xvfmina_d, LASX256DOpnd>;


def XVFCVT_H_S : LASX_3R<0b01110101010001100>,
                 LASX_3RF_DESC_BASE<"xvfcvt.h.s", int_loongarch_lasx_xvfcvt_h_s, LASX256HOpnd, LASX256WOpnd, LASX256WOpnd>;

def XVFCVT_S_D : LASX_3R<0b01110101010001101>,
                 LASX_3RF_DESC_BASE1<"xvfcvt.s.d", int_loongarch_lasx_xvfcvt_s_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVFFINT_S_L : LASX_3R<0b01110101010010000>,
                  LASX_3RF_DESC_BASE<"xvffint.s.l", int_loongarch_lasx_xvffint_s_l, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;

def XVFTINT_W_D : LASX_3R<0b01110101010010011>,
                  LASX_3RF_DESC_BASE<"xvftint.w.d", int_loongarch_lasx_xvftint_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVFTINTRM_W_D : LASX_3R<0b01110101010010100>,
                    LASX_3RF_DESC_BASE<"xvftintrm.w.d", int_loongarch_lasx_xvftintrm_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;

def XVFTINTRP_W_D : LASX_3R<0b01110101010010101>,
                    LASX_3RF_DESC_BASE<"xvftintrp.w.d", int_loongarch_lasx_xvftintrp_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;

def XVFTINTRZ_W_D : LASX_3R<0b01110101010010110>,
                    LASX_3RF_DESC_BASE<"xvftintrz.w.d", int_loongarch_lasx_xvftintrz_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;

def XVFTINTRNE_W_D : LASX_3R<0b01110101010010111>,
                     LASX_3RF_DESC_BASE<"xvftintrne.w.d", int_loongarch_lasx_xvftintrne_w_d, LASX256WOpnd, LASX256DOpnd, LASX256DOpnd>;


def XVSHUF_H : LASX_3R<0b01110101011110101>,
               LASX_3R_VSHF_DESC_BASE<"xvshuf.h", LASX256HOpnd>;

def XVSHUF_W : LASX_3R<0b01110101011110110>,
               LASX_3R_VSHF_DESC_BASE<"xvshuf.w", LASX256WOpnd>;

def XVSHUF_D : LASX_3R<0b01110101011110111>,
               LASX_3R_VSHF_DESC_BASE<"xvshuf.d", LASX256DOpnd>;


def XVPERM_W : LASX_3R<0b01110101011111010>,
               LASX_3R_DESC_BASE<"xvperm.w", int_loongarch_lasx_xvperm_w, LASX256WOpnd>;


def XVSEQI_B : LASX_I5<0b01110110100000000>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvseqi.b", int_loongarch_lasx_xvseqi_b, simm5_32, immSExt5, LASX256BOpnd>;

def XVSEQI_H : LASX_I5<0b01110110100000001>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvseqi.h", int_loongarch_lasx_xvseqi_h, simm5_32, immSExt5, LASX256HOpnd>;

def XVSEQI_W : LASX_I5<0b01110110100000010>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvseqi.w", int_loongarch_lasx_xvseqi_w, simm5_32, immSExt5, LASX256WOpnd>;

def XVSEQI_D : LASX_I5<0b01110110100000011>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvseqi.d", int_loongarch_lasx_xvseqi_d, simm5_32, immSExt5, LASX256DOpnd>;


def XVSLEI_B : LASX_I5<0b01110110100000100>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvslei.b", int_loongarch_lasx_xvslei_b, simm5_32, immSExt5, LASX256BOpnd>;

def XVSLEI_H : LASX_I5<0b01110110100000101>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvslei.h", int_loongarch_lasx_xvslei_h, simm5_32, immSExt5, LASX256HOpnd>;

def XVSLEI_W : LASX_I5<0b01110110100000110>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvslei.w", int_loongarch_lasx_xvslei_w, simm5_32, immSExt5, LASX256WOpnd>;

def XVSLEI_D : LASX_I5<0b01110110100000111>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvslei.d", int_loongarch_lasx_xvslei_d, simm5_32, immSExt5, LASX256DOpnd>;


def XVSLEI_BU : LASX_I5_U<0b01110110100001000>,
                LASX_I5_U_SETCC_DESC_BASE_Intrinsic<"xvslei.bu", int_loongarch_lasx_xvslei_bu, uimm5, immZExt5, LASX256BOpnd>;

def XVSLEI_HU : LASX_I5_U<0b01110110100001001>,
                LASX_I5_U_SETCC_DESC_BASE_Intrinsic<"xvslei.hu", int_loongarch_lasx_xvslei_hu, uimm5, immZExt5, LASX256HOpnd>;

def XVSLEI_WU : LASX_I5_U<0b01110110100001010>,
                LASX_I5_U_SETCC_DESC_BASE_Intrinsic<"xvslei.wu", int_loongarch_lasx_xvslei_wu, uimm5, immZExt5, LASX256WOpnd>;

def XVSLEI_DU : LASX_I5_U<0b01110110100001011>,
                LASX_I5_U_SETCC_DESC_BASE_Intrinsic<"xvslei.du", int_loongarch_lasx_xvslei_du, uimm5, immZExt5, LASX256DOpnd>;


def XVSLTI_B : LASX_I5<0b01110110100001100>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvslti.b", int_loongarch_lasx_xvslti_b, simm5_32, immSExt5, LASX256BOpnd>;

def XVSLTI_H : LASX_I5<0b01110110100001101>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvslti.h", int_loongarch_lasx_xvslti_h, simm5_32, immSExt5, LASX256HOpnd>;

def XVSLTI_W : LASX_I5<0b01110110100001110>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvslti.w", int_loongarch_lasx_xvslti_w, simm5_32, immSExt5, LASX256WOpnd>;

def XVSLTI_D : LASX_I5<0b01110110100001111>,
               LASX_I5_SETCC_DESC_BASE_Intrinsic<"xvslti.d", int_loongarch_lasx_xvslti_d, simm5_32, immSExt5, LASX256DOpnd>;


def XVSLTI_BU : LASX_I5_U<0b01110110100010000>,
                LASX_I5_U_SETCC_DESC_BASE_Intrinsic<"xvslti.bu", int_loongarch_lasx_xvslti_bu, uimm5, immZExt5, LASX256BOpnd>;

def XVSLTI_HU : LASX_I5_U<0b01110110100010001>,
                LASX_I5_U_SETCC_DESC_BASE_Intrinsic<"xvslti.hu", int_loongarch_lasx_xvslti_hu, uimm5, immZExt5, LASX256HOpnd>;

def XVSLTI_WU : LASX_I5_U<0b01110110100010010>,
                LASX_I5_U_SETCC_DESC_BASE_Intrinsic<"xvslti.wu", int_loongarch_lasx_xvslti_wu, uimm5, immZExt5, LASX256WOpnd>;

def XVSLTI_DU : LASX_I5_U<0b01110110100010011>,
                LASX_I5_U_SETCC_DESC_BASE_Intrinsic<"xvslti.du", int_loongarch_lasx_xvslti_du, uimm5, immZExt5, LASX256DOpnd>;


def XVADDI_BU : LASX_I5_U<0b01110110100010100>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvaddi.bu", int_loongarch_lasx_xvaddi_bu, uimm5, immZExt5, LASX256BOpnd>;

def XVADDI_HU : LASX_I5_U<0b01110110100010101>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvaddi.hu", int_loongarch_lasx_xvaddi_hu, uimm5, immZExt5, LASX256HOpnd>;

def XVADDI_WU : LASX_I5_U<0b01110110100010110>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvaddi.wu", int_loongarch_lasx_xvaddi_wu, uimm5, immZExt5, LASX256WOpnd>;

def XVADDI_DU : LASX_I5_U<0b01110110100010111>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvaddi.du", int_loongarch_lasx_xvaddi_du, uimm5, immZExt5, LASX256DOpnd>;


def XVSUBI_BU : LASX_I5_U<0b01110110100011000>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvsubi.bu", int_loongarch_lasx_xvsubi_bu, uimm5, immZExt5, LASX256BOpnd>;

def XVSUBI_HU : LASX_I5_U<0b01110110100011001>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvsubi.hu", int_loongarch_lasx_xvsubi_hu, uimm5, immZExt5, LASX256HOpnd>;

def XVSUBI_WU : LASX_I5_U<0b01110110100011010>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvsubi.wu", int_loongarch_lasx_xvsubi_wu, uimm5, immZExt5, LASX256WOpnd>;

def XVSUBI_DU : LASX_I5_U<0b01110110100011011>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvsubi.du", int_loongarch_lasx_xvsubi_du, uimm5, immZExt5, LASX256DOpnd>;


def XVBSLL_V : LASX_I5_U<0b01110110100011100>,
               LASX_U5_DESC_BASE<"xvbsll.v", int_loongarch_lasx_xvbsll_v, LASX256BOpnd>;

def XVBSRL_V : LASX_I5_U<0b01110110100011101>,
               LASX_U5_DESC_BASE<"xvbsrl.v", int_loongarch_lasx_xvbsrl_v, LASX256BOpnd>;


def XVMAXI_B : LASX_I5<0b01110110100100000>,
               LASX_I5_DESC_BASE_Intrinsic<"xvmaxi.b", int_loongarch_lasx_xvmaxi_b, simm5_32, immSExt5, LASX256BOpnd>;

def XVMAXI_H : LASX_I5<0b01110110100100001>,
               LASX_I5_DESC_BASE_Intrinsic<"xvmaxi.h", int_loongarch_lasx_xvmaxi_h, simm5_32, immSExt5, LASX256HOpnd>;

def XVMAXI_W : LASX_I5<0b01110110100100010>,
               LASX_I5_DESC_BASE_Intrinsic<"xvmaxi.w", int_loongarch_lasx_xvmaxi_w, simm5_32, immSExt5, LASX256WOpnd>;

def XVMAXI_D : LASX_I5<0b01110110100100011>,
               LASX_I5_DESC_BASE_Intrinsic<"xvmaxi.d", int_loongarch_lasx_xvmaxi_d, simm5_32, immSExt5, LASX256DOpnd>;


def XVMINI_B : LASX_I5<0b01110110100100100>,
               LASX_I5_DESC_BASE_Intrinsic<"xvmini.b", int_loongarch_lasx_xvmini_b, simm5_32, immSExt5, LASX256BOpnd>;

def XVMINI_H : LASX_I5<0b01110110100100101>,
               LASX_I5_DESC_BASE_Intrinsic<"xvmini.h", int_loongarch_lasx_xvmini_h, simm5_32, immSExt5, LASX256HOpnd>;

def XVMINI_W : LASX_I5<0b01110110100100110>,
               LASX_I5_DESC_BASE_Intrinsic<"xvmini.w", int_loongarch_lasx_xvmini_w, simm5_32, immSExt5, LASX256WOpnd>;

def XVMINI_D : LASX_I5<0b01110110100100111>,
               LASX_I5_DESC_BASE_Intrinsic<"xvmini.d", int_loongarch_lasx_xvmini_d, simm5_32, immSExt5, LASX256DOpnd>;


def XVMAXI_BU : LASX_I5_U<0b01110110100101000>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvmaxi.bu", int_loongarch_lasx_xvmaxi_bu, uimm5, immZExt5, LASX256BOpnd>;

def XVMAXI_HU : LASX_I5_U<0b01110110100101001>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvmaxi.hu", int_loongarch_lasx_xvmaxi_hu, uimm5, immZExt5, LASX256HOpnd>;

def XVMAXI_WU : LASX_I5_U<0b01110110100101010>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvmaxi.wu", int_loongarch_lasx_xvmaxi_wu, uimm5, immZExt5, LASX256WOpnd>;

def XVMAXI_DU : LASX_I5_U<0b01110110100101011>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvmaxi.du", int_loongarch_lasx_xvmaxi_du, uimm5, immZExt5, LASX256DOpnd>;


def XVMINI_BU : LASX_I5_U<0b01110110100101100>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvmini.bu", int_loongarch_lasx_xvmini_bu, uimm5, immZExt5, LASX256BOpnd>;

def XVMINI_HU : LASX_I5_U<0b01110110100101101>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvmini.hu", int_loongarch_lasx_xvmini_hu, uimm5, immZExt5, LASX256HOpnd>;

def XVMINI_WU : LASX_I5_U<0b01110110100101110>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvmini.wu", int_loongarch_lasx_xvmini_wu, uimm5, immZExt5, LASX256WOpnd>;

def XVMINI_DU : LASX_I5_U<0b01110110100101111>,
                LASX_I5_U_DESC_BASE_Intrinsic<"xvmini.du", int_loongarch_lasx_xvmini_du, uimm5, immZExt5, LASX256DOpnd>;


def XVFRSTPI_B : LASX_I5_U<0b01110110100110100>,
                 LASX_U5_4R_DESC_BASE<"xvfrstpi.b", int_loongarch_lasx_xvfrstpi_b, LASX256BOpnd>;

def XVFRSTPI_H : LASX_I5_U<0b01110110100110101>,
                 LASX_U5_4R_DESC_BASE<"xvfrstpi.h", int_loongarch_lasx_xvfrstpi_h, LASX256HOpnd>;


def XVCLO_B : LASX_2R<0b0111011010011100000000>,
              LASX_2R_DESC_BASE<"xvclo.b", int_loongarch_lasx_xvclo_b, LASX256BOpnd>;

def XVCLO_H : LASX_2R<0b0111011010011100000001>,
              LASX_2R_DESC_BASE<"xvclo.h", int_loongarch_lasx_xvclo_h, LASX256HOpnd>;

def XVCLO_W : LASX_2R<0b0111011010011100000010>,
              LASX_2R_DESC_BASE<"xvclo.w", int_loongarch_lasx_xvclo_w, LASX256WOpnd>;

def XVCLO_D : LASX_2R<0b0111011010011100000011>,
              LASX_2R_DESC_BASE<"xvclo.d", int_loongarch_lasx_xvclo_d, LASX256DOpnd>;


def XVCLZ_B : LASX_2R<0b0111011010011100000100>,
              LASX_2R_DESC_BASE<"xvclz.b", ctlz, LASX256BOpnd>;

def XVCLZ_H : LASX_2R<0b0111011010011100000101>,
              LASX_2R_DESC_BASE<"xvclz.h", ctlz, LASX256HOpnd>;

def XVCLZ_W : LASX_2R<0b0111011010011100000110>,
              LASX_2R_DESC_BASE<"xvclz.w", ctlz, LASX256WOpnd>;

def XVCLZ_D : LASX_2R<0b0111011010011100000111>,
              LASX_2R_DESC_BASE<"xvclz.d", ctlz, LASX256DOpnd>;


def XVPCNT_B : LASX_2R<0b0111011010011100001000>,
               LASX_2R_DESC_BASE<"xvpcnt.b", ctpop, LASX256BOpnd>;

def XVPCNT_H : LASX_2R<0b0111011010011100001001>,
               LASX_2R_DESC_BASE<"xvpcnt.h", ctpop, LASX256HOpnd>;

def XVPCNT_W : LASX_2R<0b0111011010011100001010>,
               LASX_2R_DESC_BASE<"xvpcnt.w", ctpop, LASX256WOpnd>;

def XVPCNT_D : LASX_2R<0b0111011010011100001011>,
               LASX_2R_DESC_BASE<"xvpcnt.d", ctpop, LASX256DOpnd>;


def XVNEG_B : LASX_2R<0b0111011010011100001100>,
              LASX_2R_DESC_BASE<"xvneg.b", int_loongarch_lasx_xvneg_b, LASX256BOpnd>;

def XVNEG_H : LASX_2R<0b0111011010011100001101>,
              LASX_2R_DESC_BASE<"xvneg.h", int_loongarch_lasx_xvneg_h, LASX256HOpnd>;

def XVNEG_W : LASX_2R<0b0111011010011100001110>,
              LASX_2R_DESC_BASE<"xvneg.w", int_loongarch_lasx_xvneg_w, LASX256WOpnd>;

def XVNEG_D : LASX_2R<0b0111011010011100001111>,
              LASX_2R_DESC_BASE<"xvneg.d", int_loongarch_lasx_xvneg_d, LASX256DOpnd>;


def XVMSKLTZ_B : LASX_2R<0b0111011010011100010000>,
                 LASX_2R_DESC_BASE<"xvmskltz.b", int_loongarch_lasx_xvmskltz_b, LASX256BOpnd>;

def XVMSKLTZ_H : LASX_2R<0b0111011010011100010001>,
                 LASX_2R_DESC_BASE<"xvmskltz.h", int_loongarch_lasx_xvmskltz_h, LASX256HOpnd>;

def XVMSKLTZ_W : LASX_2R<0b0111011010011100010010>,
                 LASX_2R_DESC_BASE<"xvmskltz.w", int_loongarch_lasx_xvmskltz_w, LASX256WOpnd>;

def XVMSKLTZ_D : LASX_2R<0b0111011010011100010011>,
                 LASX_2R_DESC_BASE<"xvmskltz.d", int_loongarch_lasx_xvmskltz_d, LASX256DOpnd>;


def XVMSKGEZ_B : LASX_2R<0b0111011010011100010100>,
                 LASX_2R_DESC_BASE<"xvmskgez.b", int_loongarch_lasx_xvmskgez_b, LASX256BOpnd>;

def XVMSKNZ_B : LASX_2R<0b0111011010011100011000>,
                LASX_2R_DESC_BASE<"xvmsknz.b", int_loongarch_lasx_xvmsknz_b, LASX256BOpnd>;


def XVSETEQZ_V : LASX_SET<0b0111011010011100100110>,
                 LASX_SET_DESC_BASE<"xvseteqz.v", LASX256BOpnd>;

def XVSETNEZ_V : LASX_SET<0b0111011010011100100111>,
                 LASX_SET_DESC_BASE<"xvsetnez.v", LASX256BOpnd>;


def XVSETANYEQZ_B : LASX_SET<0b0111011010011100101000>,
                    LASX_SET_DESC_BASE<"xvsetanyeqz.b", LASX256BOpnd>;

def XVSETANYEQZ_H : LASX_SET<0b0111011010011100101001>,
                    LASX_SET_DESC_BASE<"xvsetanyeqz.h", LASX256HOpnd>;

def XVSETANYEQZ_W : LASX_SET<0b0111011010011100101010>,
                    LASX_SET_DESC_BASE<"xvsetanyeqz.w", LASX256WOpnd>;

def XVSETANYEQZ_D : LASX_SET<0b0111011010011100101011>,
                    LASX_SET_DESC_BASE<"xvsetanyeqz.d", LASX256DOpnd>;


def XVSETALLNEZ_B : LASX_SET<0b0111011010011100101100>,
                    LASX_SET_DESC_BASE<"xvsetallnez.b", LASX256BOpnd>;

def XVSETALLNEZ_H : LASX_SET<0b0111011010011100101101>,
                    LASX_SET_DESC_BASE<"xvsetallnez.h", LASX256HOpnd>;

def XVSETALLNEZ_W : LASX_SET<0b0111011010011100101110>,
                    LASX_SET_DESC_BASE<"xvsetallnez.w", LASX256WOpnd>;

def XVSETALLNEZ_D : LASX_SET<0b0111011010011100101111>,
                    LASX_SET_DESC_BASE<"xvsetallnez.d", LASX256DOpnd>;

class LASX_CBRANCH_PSEUDO_DESC_BASE<SDPatternOperator OpNode, ValueType TyNode,
                                  RegisterClass RCWS> :
      LoongArchPseudo<(outs GPR32:$dst),
                (ins RCWS:$xj),
                [(set GPR32:$dst, (OpNode (TyNode RCWS:$xj)))]> {
  bit usesCustomInserter = 1;
}

def XSNZ_B_PSEUDO : LASX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lasx_xbnz_b, v32i8,
                                                 LASX256B>;
def XSNZ_H_PSEUDO : LASX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lasx_xbnz_h, v16i16,
                                                 LASX256H>;
def XSNZ_W_PSEUDO : LASX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lasx_xbnz_w, v8i32,
                                                 LASX256W>;
def XSNZ_D_PSEUDO : LASX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lasx_xbnz_d, v4i64,
                                                 LASX256D>;
def XSNZ_V_PSEUDO : LASX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lasx_xbnz_v, v32i8,
                                                 LASX256B>;

def XSZ_B_PSEUDO : LASX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lasx_xbz_b, v32i8,
                                                 LASX256B>;
def XSZ_H_PSEUDO : LASX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lasx_xbz_h, v16i16,
                                                 LASX256H>;
def XSZ_W_PSEUDO : LASX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lasx_xbz_w, v8i32,
                                                 LASX256W>;
def XSZ_D_PSEUDO : LASX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lasx_xbz_d, v4i64,
                                                 LASX256D>;
def XSZ_V_PSEUDO : LASX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lasx_xbz_v, v32i8,
                                                 LASX256B>;


def XVFLOGB_S : LASX_2R<0b0111011010011100110001>,
                LASX_2RF_DESC_BASE<"xvflogb.s", int_loongarch_lasx_xvflogb_s, LASX256WOpnd>;

def XVFLOGB_D : LASX_2R<0b0111011010011100110010>,
                LASX_2RF_DESC_BASE<"xvflogb.d", int_loongarch_lasx_xvflogb_d, LASX256DOpnd>;


def XVFCLASS_S : LASX_2R<0b0111011010011100110101>,
                 LASX_2RF_DESC_BASE<"xvfclass.s", int_loongarch_lasx_xvfclass_s, LASX256WOpnd>;

def XVFCLASS_D : LASX_2R<0b0111011010011100110110>,
                 LASX_2RF_DESC_BASE<"xvfclass.d", int_loongarch_lasx_xvfclass_d, LASX256DOpnd>;


def XVFSQRT_S : LASX_2R<0b0111011010011100111001>,
                LASX_2RF_DESC_BASE<"xvfsqrt.s", fsqrt, LASX256WOpnd>;

def XVFSQRT_D : LASX_2R<0b0111011010011100111010>,
                LASX_2RF_DESC_BASE<"xvfsqrt.d", fsqrt, LASX256DOpnd>;


def XVFRECIP_S : LASX_2R<0b0111011010011100111101>,
                 LASX_2RF_DESC_BASE<"xvfrecip.s", int_loongarch_lasx_xvfrecip_s, LASX256WOpnd>;

def XVFRECIP_D : LASX_2R<0b0111011010011100111110>,
                 LASX_2RF_DESC_BASE<"xvfrecip.d", int_loongarch_lasx_xvfrecip_d, LASX256DOpnd>;


def XVFRSQRT_S : LASX_2R<0b0111011010011101000001>,
                 LASX_2RF_DESC_BASE<"xvfrsqrt.s", int_loongarch_lasx_xvfrsqrt_s, LASX256WOpnd>;

def XVFRSQRT_D : LASX_2R<0b0111011010011101000010>,
                 LASX_2RF_DESC_BASE<"xvfrsqrt.d", int_loongarch_lasx_xvfrsqrt_d, LASX256DOpnd>;


def XVFRINT_S : LASX_2R<0b0111011010011101001101>,
                LASX_2RF_DESC_BASE<"xvfrint.s", frint, LASX256WOpnd>;

def XVFRINT_D : LASX_2R<0b0111011010011101001110>,
                LASX_2RF_DESC_BASE<"xvfrint.d", frint, LASX256DOpnd>;


def XVFRINTRM_S : LASX_2R<0b0111011010011101010001>,
                  LASX_2RF_DESC_BASE<"xvfrintrm.s", int_loongarch_lasx_xvfrintrm_s, LASX256WOpnd>;

def XVFRINTRM_D : LASX_2R<0b0111011010011101010010>,
                  LASX_2RF_DESC_BASE<"xvfrintrm.d", int_loongarch_lasx_xvfrintrm_d, LASX256DOpnd>;


def XVFRINTRP_S : LASX_2R<0b0111011010011101010101>,
                  LASX_2RF_DESC_BASE<"xvfrintrp.s", int_loongarch_lasx_xvfrintrp_s, LASX256WOpnd>;

def XVFRINTRP_D : LASX_2R<0b0111011010011101010110>,
                  LASX_2RF_DESC_BASE<"xvfrintrp.d", int_loongarch_lasx_xvfrintrp_d, LASX256DOpnd>;


def XVFRINTRZ_S : LASX_2R<0b0111011010011101011001>,
                  LASX_2RF_DESC_BASE<"xvfrintrz.s", int_loongarch_lasx_xvfrintrz_s, LASX256WOpnd>;

def XVFRINTRZ_D : LASX_2R<0b0111011010011101011010>,
                  LASX_2RF_DESC_BASE<"xvfrintrz.d", int_loongarch_lasx_xvfrintrz_d, LASX256DOpnd>;


def XVFRINTRNE_S : LASX_2R<0b0111011010011101011101>,
                   LASX_2RF_DESC_BASE<"xvfrintrne.s", int_loongarch_lasx_xvfrintrne_s, LASX256WOpnd>;

def XVFRINTRNE_D : LASX_2R<0b0111011010011101011110>,
                   LASX_2RF_DESC_BASE<"xvfrintrne.d", int_loongarch_lasx_xvfrintrne_d, LASX256DOpnd>;


def XVFCVTL_S_H : LASX_2R<0b0111011010011101111010>,
                  LASX_2RF_DESC_BASE<"xvfcvtl.s.h", int_loongarch_lasx_xvfcvtl_s_h, LASX256WOpnd, LASX256HOpnd>;

def XVFCVTH_S_H : LASX_2R<0b0111011010011101111011>,
                  LASX_2RF_DESC_BASE<"xvfcvth.s.h", int_loongarch_lasx_xvfcvth_s_h, LASX256WOpnd, LASX256HOpnd>;


def XVFCVTL_D_S : LASX_2R<0b0111011010011101111100>,
                  LASX_2RF_DESC_BASE<"xvfcvtl.d.s", int_loongarch_lasx_xvfcvtl_d_s, LASX256DOpnd, LASX256WOpnd>;

def XVFCVTH_D_S : LASX_2R<0b0111011010011101111101>,
                  LASX_2RF_DESC_BASE<"xvfcvth.d.s", int_loongarch_lasx_xvfcvth_d_s, LASX256DOpnd, LASX256WOpnd>;


def XVFFINT_S_W : LASX_2R<0b0111011010011110000000>,
                  LASX_2RF_DESC_BASE<"xvffint.s.w", sint_to_fp, LASX256WOpnd>;

def XVFFINT_S_WU : LASX_2R<0b0111011010011110000001>,
                   LASX_2RF_DESC_BASE<"xvffint.s.wu", uint_to_fp, LASX256WOpnd>;


def XVFFINT_D_L : LASX_2R<0b0111011010011110000010>,
                  LASX_2RF_DESC_BASE<"xvffint.d.l", sint_to_fp, LASX256DOpnd>;

def XVFFINT_D_LU : LASX_2R<0b0111011010011110000011>,
                   LASX_2RF_DESC_BASE<"xvffint.d.lu", uint_to_fp, LASX256DOpnd>;


def XVFFINTL_D_W : LASX_2R<0b0111011010011110000100>,
                   LASX_2RF_DESC_BASE<"xvffintl.d.w", int_loongarch_lasx_xvffintl_d_w, LASX256DOpnd, LASX256WOpnd>;

def XVFFINTH_D_W : LASX_2R<0b0111011010011110000101>,
                   LASX_2RF_DESC_BASE<"xvffinth.d.w", int_loongarch_lasx_xvffinth_d_w, LASX256DOpnd, LASX256WOpnd>;


def XVFTINT_W_S : LASX_2R<0b0111011010011110001100>,
                  LASX_2RF_DESC_BASE<"xvftint.w.s", int_loongarch_lasx_xvftint_w_s, LASX256WOpnd>;

def XVFTINT_L_D : LASX_2R<0b0111011010011110001101>,
                  LASX_2RF_DESC_BASE<"xvftint.l.d", int_loongarch_lasx_xvftint_l_d, LASX256DOpnd>;


def XVFTINTRM_W_S : LASX_2R<0b0111011010011110001110>,
                    LASX_2RF_DESC_BASE<"xvftintrm.w.s", int_loongarch_lasx_xvftintrm_w_s, LASX256WOpnd>;

def XVFTINTRM_L_D : LASX_2R<0b0111011010011110001111>,
                    LASX_2RF_DESC_BASE<"xvftintrm.l.d", int_loongarch_lasx_xvftintrm_l_d, LASX256DOpnd>;


def XVFTINTRP_W_S : LASX_2R<0b0111011010011110010000>,
                    LASX_2RF_DESC_BASE<"xvftintrp.w.s", int_loongarch_lasx_xvftintrp_w_s, LASX256WOpnd>;

def XVFTINTRP_L_D : LASX_2R<0b0111011010011110010001>,
                    LASX_2RF_DESC_BASE<"xvftintrp.l.d", int_loongarch_lasx_xvftintrp_l_d, LASX256DOpnd>;


def XVFTINTRZ_W_S : LASX_2R<0b0111011010011110010010>,
                    LASX_2RF_DESC_BASE<"xvftintrz.w.s", fp_to_sint, LASX256WOpnd>;

def XVFTINTRZ_L_D : LASX_2R<0b0111011010011110010011>,
                    LASX_2RF_DESC_BASE<"xvftintrz.l.d", fp_to_sint, LASX256DOpnd>;


def XVFTINTRNE_W_S : LASX_2R<0b0111011010011110010100>,
                     LASX_2RF_DESC_BASE<"xvftintrne.w.s", int_loongarch_lasx_xvftintrne_w_s, LASX256WOpnd>;

def XVFTINTRNE_L_D : LASX_2R<0b0111011010011110010101>,
                     LASX_2RF_DESC_BASE<"xvftintrne.l.d", int_loongarch_lasx_xvftintrne_l_d, LASX256DOpnd>;


def XVFTINT_WU_S : LASX_2R<0b0111011010011110010110>,
                   LASX_2RF_DESC_BASE<"xvftint.wu.s", int_loongarch_lasx_xvftint_wu_s, LASX256WOpnd>;

def XVFTINT_LU_D : LASX_2R<0b0111011010011110010111>,
                   LASX_2RF_DESC_BASE<"xvftint.lu.d", int_loongarch_lasx_xvftint_lu_d, LASX256DOpnd>;


def XVFTINTRZ_WU_S : LASX_2R<0b0111011010011110011100>,
                     LASX_2RF_DESC_BASE<"xvftintrz.wu.s", fp_to_uint, LASX256WOpnd>;

def XVFTINTRZ_LU_D : LASX_2R<0b0111011010011110011101>,
                     LASX_2RF_DESC_BASE<"xvftintrz.lu.d", fp_to_uint, LASX256DOpnd>;


def XVFTINTL_L_S : LASX_2R<0b0111011010011110100000>,
                   LASX_2RF_DESC_BASE<"xvftintl.l.s", int_loongarch_lasx_xvftintl_l_s, LASX256DOpnd, LASX256WOpnd>;

def XVFTINTH_L_S : LASX_2R<0b0111011010011110100001>,
                   LASX_2RF_DESC_BASE<"xvftinth.l.s", int_loongarch_lasx_xvftinth_l_s, LASX256DOpnd, LASX256WOpnd>;


def XVFTINTRML_L_S : LASX_2R<0b0111011010011110100010>,
                     LASX_2RF_DESC_BASE<"xvftintrml.l.s", int_loongarch_lasx_xvftintrml_l_s, LASX256DOpnd, LASX256WOpnd>;

def XVFTINTRMH_L_S : LASX_2R<0b0111011010011110100011>,
                     LASX_2RF_DESC_BASE<"xvftintrmh.l.s", int_loongarch_lasx_xvftintrmh_l_s, LASX256DOpnd, LASX256WOpnd>;


def XVFTINTRPL_L_S : LASX_2R<0b0111011010011110100100>,
                     LASX_2RF_DESC_BASE<"xvftintrpl.l.s", int_loongarch_lasx_xvftintrpl_l_s, LASX256DOpnd, LASX256WOpnd>;

def XVFTINTRPH_L_S : LASX_2R<0b0111011010011110100101>,
                     LASX_2RF_DESC_BASE<"xvftintrph.l.s", int_loongarch_lasx_xvftintrph_l_s, LASX256DOpnd, LASX256WOpnd>;


def XVFTINTRZL_L_S : LASX_2R<0b0111011010011110100110>,
                     LASX_2RF_DESC_BASE<"xvftintrzl.l.s", int_loongarch_lasx_xvftintrzl_l_s, LASX256DOpnd, LASX256WOpnd>;

def XVFTINTRZH_L_S : LASX_2R<0b0111011010011110100111>,
                     LASX_2RF_DESC_BASE<"xvftintrzh.l.s", int_loongarch_lasx_xvftintrzh_l_s, LASX256DOpnd, LASX256WOpnd>;


def XVFTINTRNEL_L_S : LASX_2R<0b0111011010011110101000>,
                      LASX_2RF_DESC_BASE<"xvftintrnel.l.s", int_loongarch_lasx_xvftintrnel_l_s, LASX256DOpnd, LASX256WOpnd>;

def XVFTINTRNEH_L_S : LASX_2R<0b0111011010011110101001>,
                      LASX_2RF_DESC_BASE<"xvftintrneh.l.s", int_loongarch_lasx_xvftintrneh_l_s, LASX256DOpnd, LASX256WOpnd>;


def XVEXTH_H_B : LASX_2R<0b0111011010011110111000>,
                 LASX_2R_DESC_BASE<"xvexth.h.b", int_loongarch_lasx_xvexth_h_b, LASX256HOpnd, LASX256BOpnd>;

def XVEXTH_W_H : LASX_2R<0b0111011010011110111001>,
                 LASX_2R_DESC_BASE<"xvexth.w.h", int_loongarch_lasx_xvexth_w_h, LASX256WOpnd, LASX256HOpnd>;

def XVEXTH_D_W : LASX_2R<0b0111011010011110111010>,
                 LASX_2R_DESC_BASE<"xvexth.d.w", int_loongarch_lasx_xvexth_d_w, LASX256DOpnd, LASX256WOpnd> ;

def XVEXTH_Q_D : LASX_2R<0b0111011010011110111011>,
                 LASX_2R_DESC_BASE<"xvexth.q.d", int_loongarch_lasx_xvexth_q_d, LASX256DOpnd, LASX256DOpnd>;


def XVEXTH_HU_BU : LASX_2R<0b0111011010011110111100>,
                   LASX_2R_DESC_BASE<"xvexth.hu.bu", int_loongarch_lasx_xvexth_hu_bu, LASX256HOpnd, LASX256BOpnd>;

def XVEXTH_WU_HU : LASX_2R<0b0111011010011110111101>,
                   LASX_2R_DESC_BASE<"xvexth.wu.hu", int_loongarch_lasx_xvexth_wu_hu, LASX256WOpnd, LASX256HOpnd>;

def XVEXTH_DU_WU : LASX_2R<0b0111011010011110111110>,
                   LASX_2R_DESC_BASE<"xvexth.du.wu", int_loongarch_lasx_xvexth_du_wu, LASX256DOpnd, LASX256WOpnd> ;

def XVEXTH_QU_DU : LASX_2R<0b0111011010011110111111>,
                   LASX_2R_DESC_BASE<"xvexth.qu.du", int_loongarch_lasx_xvexth_qu_du, LASX256DOpnd, LASX256DOpnd>;


def XVREPLGR2VR_B : LASX_2R_1GP<0b0111011010011111000000>,
                    LASX_2R_REPL_DESC_BASE<"xvreplgr2vr.b", v32i8, xvsplati8, LASX256BOpnd, GPR32Opnd>;

def XVREPLGR2VR_H : LASX_2R_1GP<0b0111011010011111000001>,
                    LASX_2R_REPL_DESC_BASE<"xvreplgr2vr.h", v16i16, xvsplati16, LASX256HOpnd, GPR32Opnd>;

def XVREPLGR2VR_W : LASX_2R_1GP<0b0111011010011111000010>,
                    LASX_2R_REPL_DESC_BASE<"xvreplgr2vr.w", v8i32, xvsplati32, LASX256WOpnd, GPR32Opnd>;

def XVREPLGR2VR_D : LASX_2R_1GP<0b0111011010011111000011>,
                    LASX_2R_REPL_DESC_BASE<"xvreplgr2vr.d", v4i64, xvsplati64, LASX256DOpnd, GPR64Opnd>;


def VEXT2XV_H_B : LASX_2R<0b0111011010011111000100>,
                  LASX_XVEXTEND_DESC_BASE<"vext2xv.h.b", int_loongarch_lasx_vext2xv_h_b, v32i8, v16i16, LASX256BOpnd, LASX256HOpnd>;

def VEXT2XV_W_B : LASX_2R<0b0111011010011111000101>,
                  LASX_XVEXTEND_DESC_BASE<"vext2xv.w.b", int_loongarch_lasx_vext2xv_w_b, v32i8, v8i32, LASX256BOpnd, LASX256WOpnd>;

def VEXT2XV_D_B : LASX_2R<0b0111011010011111000110>,
                  LASX_XVEXTEND_DESC_BASE<"vext2xv.d.b", int_loongarch_lasx_vext2xv_d_b, v32i8, v4i64, LASX256BOpnd, LASX256DOpnd> ;

def VEXT2XV_W_H : LASX_2R<0b0111011010011111000111>,
                  LASX_XVEXTEND_DESC_BASE<"vext2xv.w.h", int_loongarch_lasx_vext2xv_w_h, v16i16, v8i32, LASX256HOpnd, LASX256WOpnd>;

def VEXT2XV_D_H : LASX_2R<0b0111011010011111001000>,
                  LASX_XVEXTEND_DESC_BASE<"vext2xv.d.h", int_loongarch_lasx_vext2xv_d_h, v16i16, v4i64, LASX256HOpnd, LASX256DOpnd> ;

def VEXT2XV_D_W : LASX_2R<0b0111011010011111001001>,
                  LASX_XVEXTEND_DESC_BASE<"vext2xv.d.w", int_loongarch_lasx_vext2xv_d_w, v8i32, v4i64, LASX256WOpnd, LASX256DOpnd>;


def VEXT2XV_HU_BU : LASX_2R<0b0111011010011111001010>,
                    LASX_XVEXTEND_DESC_BASE<"vext2xv.hu.bu", int_loongarch_lasx_vext2xv_hu_bu, v32i8, v16i16, LASX256BOpnd, LASX256HOpnd>;

def VEXT2XV_WU_BU : LASX_2R<0b0111011010011111001011>,
                    LASX_XVEXTEND_DESC_BASE<"vext2xv.wu.bu", int_loongarch_lasx_vext2xv_wu_bu, v32i8, v8i32, LASX256BOpnd, LASX256WOpnd>;

def VEXT2XV_DU_BU : LASX_2R<0b0111011010011111001100>,
                    LASX_XVEXTEND_DESC_BASE<"vext2xv.du.bu", int_loongarch_lasx_vext2xv_du_bu, v32i8, v4i64, LASX256BOpnd, LASX256DOpnd> ;

def VEXT2XV_WU_HU : LASX_2R<0b0111011010011111001101>,
                    LASX_XVEXTEND_DESC_BASE<"vext2xv.wu.hu", int_loongarch_lasx_vext2xv_wu_hu, v16i16, v8i32, LASX256HOpnd, LASX256WOpnd>;

def VEXT2XV_DU_HU : LASX_2R<0b0111011010011111001110>,
                    LASX_XVEXTEND_DESC_BASE<"vext2xv.du.hu", int_loongarch_lasx_vext2xv_du_hu, v16i16, v4i64, LASX256HOpnd, LASX256DOpnd> ;

def VEXT2XV_DU_WU : LASX_2R<0b0111011010011111001111>,
                    LASX_XVEXTEND_DESC_BASE<"vext2xv.du.wu", int_loongarch_lasx_vext2xv_du_wu, v8i32, v4i64, LASX256WOpnd, LASX256DOpnd>;


def XVHSELI_D : LASX_I5_U<0b01110110100111111>,
                LASX_U5N_DESC_BASE<"xvhseli.d", LASX256DOpnd>;


def XVROTRI_B : LASX_I3_U<0b0111011010100000001>,
                LASX_RORI_U3_DESC_BASE_Intrinsic<"xvrotri.b", int_loongarch_lasx_xvrotri_b, uimm3, immZExt3, LASX256BOpnd>;

def XVROTRI_H : LASX_I4_U<0b011101101010000001>,
                LASX_RORI_U4_DESC_BASE_Intrinsic<"xvrotri.h", int_loongarch_lasx_xvrotri_h, uimm4, immZExt4, LASX256HOpnd>;

def XVROTRI_W : LASX_I5_U<0b01110110101000001>,
                LASX_RORI_U5_DESC_BASE_Intrinsic<"xvrotri.w", int_loongarch_lasx_xvrotri_w, uimm5, immZExt5, LASX256WOpnd>;

def XVROTRI_D : LASX_I6_U<0b0111011010100001>,
                LASX_RORI_U6_DESC_BASE_Intrinsic<"xvrotri.d", int_loongarch_lasx_xvrotri_d, uimm6, immZExt6, LASX256DOpnd>;


def XVSRLRI_B : LASX_I3_U<0b0111011010100100001>,
                LASX_BIT_3_DESC_BASE<"xvsrlri.b", int_loongarch_lasx_xvsrlri_b, uimm3, immZExt3, LASX256BOpnd>;

def XVSRLRI_H : LASX_I4_U<0b011101101010010001>,
                LASX_BIT_4_DESC_BASE<"xvsrlri.h", int_loongarch_lasx_xvsrlri_h, uimm4, immZExt4, LASX256HOpnd>;

def XVSRLRI_W : LASX_I5_U<0b01110110101001001>,
                LASX_BIT_5_DESC_BASE<"xvsrlri.w", int_loongarch_lasx_xvsrlri_w, uimm5, immZExt5, LASX256WOpnd>;

def XVSRLRI_D : LASX_I6_U<0b0111011010100101>,
                LASX_BIT_6_DESC_BASE<"xvsrlri.d", int_loongarch_lasx_xvsrlri_d, uimm6, immZExt6, LASX256DOpnd>;


def XVSRARI_B : LASX_I3_U<0b0111011010101000001>,
                LASX_BIT_3_DESC_BASE<"xvsrari.b", int_loongarch_lasx_xvsrari_b, uimm3, immZExt3, LASX256BOpnd>;

def XVSRARI_H : LASX_I4_U<0b011101101010100001>,
                LASX_BIT_4_DESC_BASE<"xvsrari.h", int_loongarch_lasx_xvsrari_h, uimm4, immZExt4, LASX256HOpnd>;

def XVSRARI_W : LASX_I5_U<0b01110110101010001>,
                LASX_BIT_5_DESC_BASE<"xvsrari.w", int_loongarch_lasx_xvsrari_w, uimm5, immZExt5, LASX256WOpnd>;

def XVSRARI_D : LASX_I6_U<0b0111011010101001>,
                LASX_BIT_6_DESC_BASE<"xvsrari.d", int_loongarch_lasx_xvsrari_d, uimm6, immZExt6, LASX256DOpnd>;


def XVINSGR2VR_W : LASX_I3_R_U<0b0111011011101011110>,
                   LASX_INSERT_U3_DESC_BASE<"xvinsgr2vr.w", v8i32, uimm3_ptr, immZExt3Ptr, LASX256WOpnd, GPR32Opnd>;

def XVINSGR2VR_D : LASX_I2_R_U<0b01110110111010111110>,
                   LASX_INSERT_U2_DESC_BASE<"xvinsgr2vr.d", v4i64, uimm2_ptr, immZExt2Ptr, LASX256DOpnd, GPR64Opnd>;


def XVPICKVE2GR_W : LASX_ELM_COPY_U3<0b0111011011101111110>,
                    LASX_COPY_U3_DESC_BASE<"xvpickve2gr.w", vextract_sext_i32, v8i32, uimm3_ptr, immZExt3Ptr, GPR32Opnd, LASX256WOpnd>;

def XVPICKVE2GR_D : LASX_ELM_COPY_U2<0b01110110111011111110>,
                    LASX_COPY_U2_DESC_BASE<"xvpickve2gr.d", vextract_sext_i64, v4i64, uimm2_ptr, immZExt2Ptr, GPR64Opnd, LASX256DOpnd>;


def XVPICKVE2GR_WU : LASX_ELM_COPY_U3<0b0111011011110011110>,
                     LASX_COPY_U3_DESC_BASE<"xvpickve2gr.wu", vextract_zext_i32, v8i32, uimm3_ptr, immZExt3Ptr, GPR32Opnd, LASX256WOpnd>;

def XVPICKVE2GR_DU : LASX_ELM_COPY_U2<0b01110110111100111110>,
                     LASX_COPY_U2_DESC_BASE<"xvpickve2gr.du", vextract_zext_i64, v4i64, uimm2_ptr, immZExt2Ptr, GPR64Opnd, LASX256DOpnd>;


def XVREPL128VEI_B : LASX_I4_U<0b011101101111011110>,
                     LASX_ELM_U4_VREPLVE_DESC_BASE_Intrinsic<"xvrepl128vei.b", int_loongarch_lasx_xvrepl128vei_b, LASX256BOpnd>;

def XVREPL128VEI_H : LASX_I3_U<0b0111011011110111110>,
                     LASX_ELM_U3_VREPLVE_DESC_BASE_Intrinsic<"xvrepl128vei.h", int_loongarch_lasx_xvrepl128vei_h, LASX256HOpnd>;

def XVREPL128VEI_W : LASX_I2_U<0b01110110111101111110>,
                     LASX_ELM_U2_VREPLVE_DESC_BASE_Intrinsic<"xvrepl128vei.w", int_loongarch_lasx_xvrepl128vei_w, LASX256WOpnd>;

def XVREPL128VEI_D : LASX_I1_U<0b011101101111011111110>,
                     LASX_ELM_U1_VREPLVE_DESC_BASE_Intrinsic<"xvrepl128vei.d", int_loongarch_lasx_xvrepl128vei_d, LASX256DOpnd>;


def XVINSVE0_W : LASX_I3_U<0b0111011011111111110>,
                 LASX_BIT_3_4O_DESC_BASE<"xvinsve0.w", int_loongarch_lasx_xvinsve0_w, uimm3, immZExt3, LASX256WOpnd>;

def XVINSVE0_D : LASX_I2_U<0b01110110111111111110>,
                 LASX_BIT_2_4O_DESC_BASE<"xvinsve0.d", int_loongarch_lasx_xvinsve0_d, uimm2, immZExt2, LASX256DOpnd>;


def XVPICKVE_W : LASX_I3_U<0b0111011100000011110>,
                 LASX_BIT_3_4ON<"xvpickve.w", uimm3, immZExt3, LASX256WOpnd>;

def XVPICKVE_D : LASX_I2_U<0b01110111000000111110>,
                 LASX_BIT_2_4ON<"xvpickve.d", uimm2, immZExt2, LASX256DOpnd>;


def XVREPLVE0_B : LASX_2R<0b0111011100000111000000>,
                  LASX_XVBROADCAST_DESC_BASE<"xvreplve0.b", int_loongarch_lasx_xvreplve0_b, v32i8, LASX256BOpnd>;

def XVREPLVE0_H : LASX_2R<0b0111011100000111100000>,
                  LASX_XVBROADCAST_DESC_BASE<"xvreplve0.h", int_loongarch_lasx_xvreplve0_h, v16i16, LASX256HOpnd>;

def XVREPLVE0_W : LASX_2R<0b0111011100000111110000>,
                  LASX_XVBROADCAST_DESC_BASE<"xvreplve0.w", int_loongarch_lasx_xvreplve0_w, v8i32, LASX256WOpnd> ;

def XVREPLVE0_D : LASX_2R<0b0111011100000111111000>,
                  LASX_XVBROADCAST_DESC_BASE<"xvreplve0.d", xvbroadcast_v4i64, v4i64, LASX256DOpnd>;

def XVREPLVE0_Q : LASX_2R<0b0111011100000111111100>,
                  LASX_XVBROADCAST_DESC_BASE<"xvreplve0.q", int_loongarch_lasx_xvreplve0_q, v32i8, LASX256BOpnd>;


def XVSLLWIL_H_B : LASX_I3_U<0b0111011100001000001>,
                   LASX_2R_U3_DESC_BASE<"xvsllwil.h.b", int_loongarch_lasx_xvsllwil_h_b, LASX256HOpnd, LASX256BOpnd>;

def XVSLLWIL_W_H : LASX_I4_U<0b011101110000100001>,
                   LASX_2R_U4_DESC_BASE<"xvsllwil.w.h", int_loongarch_lasx_xvsllwil_w_h, LASX256WOpnd, LASX256HOpnd>;

def XVSLLWIL_D_W : LASX_I5_U<0b01110111000010001>,
                   LASX_2R_U5_DESC_BASE<"xvsllwil.d.w", int_loongarch_lasx_xvsllwil_d_w, LASX256DOpnd, LASX256WOpnd> ;


def XVEXTL_Q_D : LASX_2R<0b0111011100001001000000>,
                 LASX_2R_DESC_BASE<"xvextl.q.d", int_loongarch_lasx_xvextl_q_d, LASX256DOpnd, LASX256DOpnd>;


def XVSLLWIL_HU_BU : LASX_I3_U<0b0111011100001100001>,
                     LASX_2R_U3_DESC_BASE<"xvsllwil.hu.bu", int_loongarch_lasx_xvsllwil_hu_bu, LASX256HOpnd, LASX256BOpnd>;

def XVSLLWIL_WU_HU : LASX_I4_U<0b011101110000110001>,
                     LASX_2R_U4_DESC_BASE<"xvsllwil.wu.hu", int_loongarch_lasx_xvsllwil_wu_hu, LASX256WOpnd, LASX256HOpnd>;

def XVSLLWIL_DU_WU : LASX_I5_U<0b01110111000011001>,
                     LASX_2R_U5_DESC_BASE<"xvsllwil.du.wu", int_loongarch_lasx_xvsllwil_du_wu, LASX256DOpnd, LASX256WOpnd> ;


def XVEXTL_QU_DU : LASX_2R<0b0111011100001101000000>,
                   LASX_2R_DESC_BASE<"xvextl.qu.du", int_loongarch_lasx_xvextl_qu_du, LASX256DOpnd, LASX256DOpnd>;


def XVBITCLRI_B : LASX_I3_U<0b0111011100010000001>,
                  LASX_2R_U3_DESC_BASE<"xvbitclri.b", int_loongarch_lasx_xvbitclri_b, LASX256BOpnd, LASX256BOpnd>;

def XVBITCLRI_H : LASX_I4_U<0b011101110001000001>,
                  LASX_2R_U4_DESC_BASE<"xvbitclri.h", int_loongarch_lasx_xvbitclri_h, LASX256HOpnd, LASX256HOpnd>;

def XVBITCLRI_W : LASX_I5_U<0b01110111000100001>,
                  LASX_2R_U5_DESC_BASE<"xvbitclri.w", int_loongarch_lasx_xvbitclri_w, LASX256WOpnd, LASX256WOpnd>;

def XVBITCLRI_D : LASX_I6_U<0b0111011100010001>,
                  LASX_2R_U6_DESC_BASE<"xvbitclri.d", int_loongarch_lasx_xvbitclri_d, LASX256DOpnd, LASX256DOpnd>;


def XVBITSETI_B : LASX_I3_U<0b0111011100010100001>,
                  LASX_2R_U3_DESC_BASE<"xvbitseti.b", int_loongarch_lasx_xvbitseti_b, LASX256BOpnd, LASX256BOpnd>;

def XVBITSETI_H : LASX_I4_U<0b011101110001010001>,
                  LASX_2R_U4_DESC_BASE<"xvbitseti.h", int_loongarch_lasx_xvbitseti_h, LASX256HOpnd, LASX256HOpnd>;

def XVBITSETI_W : LASX_I5_U<0b01110111000101001>,
                  LASX_2R_U5_DESC_BASE<"xvbitseti.w", int_loongarch_lasx_xvbitseti_w, LASX256WOpnd, LASX256WOpnd>;

def XVBITSETI_D : LASX_I6_U<0b0111011100010101>,
                  LASX_2R_U6_DESC_BASE<"xvbitseti.d", int_loongarch_lasx_xvbitseti_d, LASX256DOpnd, LASX256DOpnd>;


def XVBITREVI_B : LASX_I3_U<0b0111011100011000001>,
                  LASX_2R_U3_DESC_BASE<"xvbitrevi.b", int_loongarch_lasx_xvbitrevi_b, LASX256BOpnd, LASX256BOpnd>;

def XVBITREVI_H : LASX_I4_U<0b011101110001100001>,
                  LASX_2R_U4_DESC_BASE<"xvbitrevi.h", int_loongarch_lasx_xvbitrevi_h, LASX256HOpnd, LASX256HOpnd>;

def XVBITREVI_W : LASX_I5_U<0b01110111000110001>,
                  LASX_2R_U5_DESC_BASE<"xvbitrevi.w", int_loongarch_lasx_xvbitrevi_w, LASX256WOpnd, LASX256WOpnd>;

def XVBITREVI_D : LASX_I6_U<0b0111011100011001>,
                  LASX_2R_U6_DESC_BASE<"xvbitrevi.d", int_loongarch_lasx_xvbitrevi_d, LASX256DOpnd, LASX256DOpnd>;


def XVSAT_B : LASX_I3_U<0b0111011100100100001>,
              LASX_BIT_3_DESC_BASE<"xvsat.b", int_loongarch_lasx_xvsat_b, uimm3, immZExt3, LASX256BOpnd>;

def XVSAT_H : LASX_I4_U<0b011101110010010001>,
              LASX_BIT_4_DESC_BASE<"xvsat.h", int_loongarch_lasx_xvsat_h, uimm4, immZExt4, LASX256HOpnd>;

def XVSAT_W : LASX_I5_U<0b01110111001001001>,
              LASX_BIT_5_DESC_BASE<"xvsat.w", int_loongarch_lasx_xvsat_w, uimm5, immZExt5, LASX256WOpnd>;

def XVSAT_D : LASX_I6_U<0b0111011100100101>,
              LASX_BIT_6_DESC_BASE<"xvsat.d", int_loongarch_lasx_xvsat_d, uimm6, immZExt6, LASX256DOpnd>;


def XVSAT_BU : LASX_I3_U<0b0111011100101000001>,
               LASX_BIT_3_DESC_BASE<"xvsat.bu", int_loongarch_lasx_xvsat_bu, uimm3, immZExt3, LASX256BOpnd>;

def XVSAT_HU : LASX_I4_U<0b011101110010100001>,
               LASX_BIT_4_DESC_BASE<"xvsat.hu", int_loongarch_lasx_xvsat_hu, uimm4, immZExt4, LASX256HOpnd>;

def XVSAT_WU : LASX_I5_U<0b01110111001010001>,
               LASX_BIT_5_DESC_BASE<"xvsat.wu", int_loongarch_lasx_xvsat_wu, uimm5, immZExt5, LASX256WOpnd>;

def XVSAT_DU : LASX_I6_U<0b0111011100101001>,
               LASX_BIT_6_DESC_BASE<"xvsat.du", int_loongarch_lasx_xvsat_du, uimm6, immZExt6, LASX256DOpnd>;


def XVSLLI_B : LASX_I3_U<0b0111011100101100001>,
               LASX_BIT_U3_VREPLVE_DESC_BASE_Intrinsic<"xvslli.b", int_loongarch_lasx_xvslli_b, uimm3, immZExt3, LASX256BOpnd>;

def XVSLLI_H : LASX_I4_U<0b011101110010110001>,
               LASX_BIT_U4_VREPLVE_DESC_BASE_Intrinsic<"xvslli.h", int_loongarch_lasx_xvslli_h, uimm4, immZExt4, LASX256HOpnd>;

def XVSLLI_W : LASX_I5_U<0b01110111001011001>,
               LASX_BIT_U5_VREPLVE_DESC_BASE_Intrinsic<"xvslli.w", int_loongarch_lasx_xvslli_w, uimm5, immZExt5, LASX256WOpnd>;

def XVSLLI_D : LASX_I6_U<0b0111011100101101>,
               LASX_BIT_U6_VREPLVE_DESC_BASE_Intrinsic<"xvslli.d", int_loongarch_lasx_xvslli_d, uimm6, immZExt6, LASX256DOpnd>;


def XVSRLI_B : LASX_I3_U<0b0111011100110000001>,
               LASX_BIT_U3_VREPLVE_DESC_BASE_Intrinsic<"xvsrli.b", int_loongarch_lasx_xvsrli_b, uimm3, immZExt3, LASX256BOpnd>;

def XVSRLI_H : LASX_I4_U<0b011101110011000001>,
               LASX_BIT_U4_VREPLVE_DESC_BASE_Intrinsic<"xvsrli.h", int_loongarch_lasx_xvsrli_h, uimm4, immZExt4, LASX256HOpnd>;

def XVSRLI_W : LASX_I5_U<0b01110111001100001>,
               LASX_BIT_U5_VREPLVE_DESC_BASE_Intrinsic<"xvsrli.w", int_loongarch_lasx_xvsrli_w, uimm5, immZExt5, LASX256WOpnd>;

def XVSRLI_D : LASX_I6_U<0b0111011100110001>,
               LASX_BIT_U6_VREPLVE_DESC_BASE_Intrinsic<"xvsrli.d", int_loongarch_lasx_xvsrli_d, uimm6, immZExt6, LASX256DOpnd>;


def XVSRAI_B : LASX_I3_U<0b0111011100110100001>,
               LASX_BIT_U3_VREPLVE_DESC_BASE_Intrinsic<"xvsrai.b", int_loongarch_lasx_xvsrai_b, uimm3, immZExt3, LASX256BOpnd>;

def XVSRAI_H : LASX_I4_U<0b011101110011010001>,
               LASX_BIT_U4_VREPLVE_DESC_BASE_Intrinsic<"xvsrai.h", int_loongarch_lasx_xvsrai_h, uimm4, immZExt4, LASX256HOpnd>;

def XVSRAI_W : LASX_I5_U<0b01110111001101001>,
               LASX_BIT_U5_VREPLVE_DESC_BASE_Intrinsic<"xvsrai.w", int_loongarch_lasx_xvsrai_w, uimm5, immZExt5, LASX256WOpnd>;

def XVSRAI_D : LASX_I6_U<0b0111011100110101>,
               LASX_BIT_U6_VREPLVE_DESC_BASE_Intrinsic<"xvsrai.d", int_loongarch_lasx_xvsrai_d, uimm6, immZExt6, LASX256DOpnd>;


def XVSRLNI_B_H : LASX_I4_U<0b011101110100000001>,
                  LASX_U4_DESC_BASE<"xvsrlni.b.h", int_loongarch_lasx_xvsrlni_b_h, uimm4, immZExt4, LASX256BOpnd>;

def XVSRLNI_H_W : LASX_I5_U<0b01110111010000001>,
                  LASX_N4_U5_DESC_BASE<"xvsrlni.h.w", int_loongarch_lasx_xvsrlni_h_w, uimm5, immZExt5, LASX256HOpnd>;

def XVSRLNI_W_D : LASX_I6_U<0b0111011101000001>,
                  LASX_U6_DESC_BASE<"xvsrlni.w.d", int_loongarch_lasx_xvsrlni_w_d, uimm6, immZExt6, LASX256WOpnd>;

def XVSRLNI_D_Q : LASX_I7_U<0b011101110100001>,
                  LASX_D_DESC_BASE<"xvsrlni.d.q", int_loongarch_lasx_xvsrlni_d_q, LASX256DOpnd>;


def XVSRLRNI_B_H : LASX_I4_U<0b011101110100010001>,
                   LASX_U4_DESC_BASE<"xvsrlrni.b.h", int_loongarch_lasx_xvsrlrni_b_h, uimm4, immZExt4, LASX256BOpnd>;

def XVSRLRNI_H_W : LASX_I5_U<0b01110111010001001>,
                   LASX_N4_U5_DESC_BASE<"xvsrlrni.h.w", int_loongarch_lasx_xvsrlrni_h_w, uimm5, immZExt5, LASX256HOpnd>;

def XVSRLRNI_W_D : LASX_I6_U<0b0111011101000101>,
                   LASX_U6_DESC_BASE<"xvsrlrni.w.d", int_loongarch_lasx_xvsrlrni_w_d, uimm6, immZExt6, LASX256WOpnd>;

def XVSRLRNI_D_Q : LASX_I7_U<0b011101110100011>,
                   LASX_D_DESC_BASE<"xvsrlrni.d.q", int_loongarch_lasx_xvsrlrni_d_q, LASX256DOpnd>;


def XVSSRLNI_B_H : LASX_I4_U<0b011101110100100001>,
                   LASX_U4_DESC_BASE<"xvssrlni.b.h", int_loongarch_lasx_xvssrlni_b_h, uimm4, immZExt4, LASX256BOpnd>;

def XVSSRLNI_H_W : LASX_I5_U<0b01110111010010001>,
                   LASX_N4_U5_DESC_BASE<"xvssrlni.h.w", int_loongarch_lasx_xvssrlni_h_w, uimm5, immZExt5, LASX256HOpnd>;

def XVSSRLNI_W_D : LASX_I6_U<0b0111011101001001>,
                   LASX_U6_DESC_BASE<"xvssrlni.w.d", int_loongarch_lasx_xvssrlni_w_d, uimm6, immZExt6, LASX256WOpnd>;

def XVSSRLNI_D_Q : LASX_I7_U<0b011101110100101>,
                   LASX_D_DESC_BASE<"xvssrlni.d.q", int_loongarch_lasx_xvssrlni_d_q, LASX256DOpnd>;


def XVSSRLNI_BU_H : LASX_I4_U<0b011101110100110001>,
                    LASX_U4_DESC_BASE<"xvssrlni.bu.h", int_loongarch_lasx_xvssrlni_bu_h, uimm4, immZExt4, LASX256BOpnd>;

def XVSSRLNI_HU_W : LASX_I5_U<0b01110111010011001>,
                    LASX_N4_U5_DESC_BASE<"xvssrlni.hu.w", int_loongarch_lasx_xvssrlni_hu_w, uimm5, immZExt5, LASX256HOpnd>;

def XVSSRLNI_WU_D : LASX_I6_U<0b0111011101001101>,
                    LASX_U6_DESC_BASE<"xvssrlni.wu.d", int_loongarch_lasx_xvssrlni_wu_d, uimm6, immZExt6, LASX256WOpnd>;

def XVSSRLNI_DU_Q : LASX_I7_U<0b011101110100111>,
                    LASX_D_DESC_BASE<"xvssrlni.du.q", int_loongarch_lasx_xvssrlni_du_q, LASX256DOpnd>;


def XVSSRLRNI_B_H : LASX_I4_U<0b011101110101000001>,
                    LASX_2R_3R_U4_DESC_BASE<"xvssrlrni.b.h", int_loongarch_lasx_xvssrlrni_b_h, LASX256BOpnd, LASX256BOpnd>;

def XVSSRLRNI_H_W : LASX_I5_U<0b01110111010100001>,
                    LASX_2R_3R_U5_DESC_BASE<"xvssrlrni.h.w", int_loongarch_lasx_xvssrlrni_h_w, LASX256HOpnd, LASX256HOpnd>;

def XVSSRLRNI_W_D : LASX_I6_U<0b0111011101010001>,
                    LASX_2R_3R_U6_DESC_BASE<"xvssrlrni.w.d", int_loongarch_lasx_xvssrlrni_w_d, LASX256WOpnd, LASX256WOpnd>;

def XVSSRLRNI_D_Q : LASX_I7_U<0b011101110101001>,
                    LASX_2R_3R_U7_DESC_BASE<"xvssrlrni.d.q", int_loongarch_lasx_xvssrlrni_d_q, LASX256DOpnd, LASX256DOpnd>;


def XVSSRLRNI_BU_H : LASX_I4_U<0b011101110101010001>,
                     LASX_U4_DESC_BASE<"xvssrlrni.bu.h", int_loongarch_lasx_xvssrlrni_bu_h, uimm4, immZExt4, LASX256BOpnd>;

def XVSSRLRNI_HU_W : LASX_I5_U<0b01110111010101001>,
                     LASX_N4_U5_DESC_BASE<"xvssrlrni.hu.w", int_loongarch_lasx_xvssrlrni_hu_w, uimm5, immZExt5, LASX256HOpnd>;

def XVSSRLRNI_WU_D : LASX_I6_U<0b0111011101010101>,
                     LASX_U6_DESC_BASE<"xvssrlrni.wu.d", int_loongarch_lasx_xvssrlrni_wu_d, uimm6, immZExt6, LASX256WOpnd>;

def XVSSRLRNI_DU_Q : LASX_I7_U<0b011101110101011>,
                     LASX_D_DESC_BASE<"xvssrlrni.du.q", int_loongarch_lasx_xvssrlrni_du_q, LASX256DOpnd>;


def XVSRANI_B_H : LASX_I4_U<0b011101110101100001>,
                  LASX_2R_3R_U4_DESC_BASE<"xvsrani.b.h", int_loongarch_lasx_xvsrani_b_h, LASX256BOpnd, LASX256BOpnd>;

def XVSRANI_H_W : LASX_I5_U<0b01110111010110001>,
                  LASX_2R_3R_U5_DESC_BASE<"xvsrani.h.w", int_loongarch_lasx_xvsrani_h_w, LASX256HOpnd, LASX256HOpnd>;

def XVSRANI_W_D : LASX_I6_U<0b0111011101011001>,
                  LASX_2R_3R_U6_DESC_BASE<"xvsrani.w.d", int_loongarch_lasx_xvsrani_w_d, LASX256WOpnd, LASX256WOpnd>;

def XVSRANI_D_Q : LASX_I7_U<0b011101110101101>,
                  LASX_2R_3R_U7_DESC_BASE<"xvsrani.d.q", int_loongarch_lasx_xvsrani_d_q, LASX256DOpnd, LASX256DOpnd>;


def XVSRARNI_B_H : LASX_I4_U<0b011101110101110001>,
                   LASX_U4_DESC_BASE<"xvsrarni.b.h", int_loongarch_lasx_xvsrarni_b_h, uimm4, immZExt4, LASX256BOpnd>;

def XVSRARNI_H_W : LASX_I5_U<0b01110111010111001>,
                   LASX_N4_U5_DESC_BASE<"xvsrarni.h.w", int_loongarch_lasx_xvsrarni_h_w, uimm5, immZExt5, LASX256HOpnd>;

def XVSRARNI_W_D : LASX_I6_U<0b0111011101011101>,
                   LASX_U6_DESC_BASE<"xvsrarni.w.d", int_loongarch_lasx_xvsrarni_w_d, uimm6, immZExt6, LASX256WOpnd>;

def XVSRARNI_D_Q : LASX_I7_U<0b011101110101111>,
                   LASX_D_DESC_BASE<"xvsrarni.d.q", int_loongarch_lasx_xvsrarni_d_q, LASX256DOpnd>;


def XVSSRANI_B_H : LASX_I4_U<0b011101110110000001>,
                   LASX_U4_DESC_BASE<"xvssrani.b.h", int_loongarch_lasx_xvssrani_b_h, uimm4, immZExt4, LASX256BOpnd>;

def XVSSRANI_H_W : LASX_I5_U<0b01110111011000001>,
                   LASX_N4_U5_DESC_BASE<"xvssrani.h.w", int_loongarch_lasx_xvssrani_h_w, uimm5, immZExt5, LASX256HOpnd>;

def XVSSRANI_W_D : LASX_I6_U<0b0111011101100001>,
                   LASX_U6_DESC_BASE<"xvssrani.w.d", int_loongarch_lasx_xvssrani_w_d, uimm6, immZExt6, LASX256WOpnd>;

def XVSSRANI_D_Q : LASX_I7_U<0b011101110110001>,
                   LASX_D_DESC_BASE<"xvssrani.d.q", int_loongarch_lasx_xvssrani_d_q, LASX256DOpnd>;


def XVSSRANI_BU_H : LASX_I4_U<0b011101110110010001>,
                    LASX_U4_DESC_BASE<"xvssrani.bu.h", int_loongarch_lasx_xvssrani_bu_h, uimm4, immZExt4, LASX256BOpnd>;

def XVSSRANI_HU_W : LASX_I5_U<0b01110111011001001>,
                    LASX_N4_U5_DESC_BASE<"xvssrani.hu.w", int_loongarch_lasx_xvssrani_hu_w, uimm5, immZExt5, LASX256HOpnd>;

def XVSSRANI_WU_D : LASX_I6_U<0b0111011101100101>,
                    LASX_U6_DESC_BASE<"xvssrani.wu.d", int_loongarch_lasx_xvssrani_wu_d, uimm6, immZExt6, LASX256WOpnd>;

def XVSSRANI_DU_Q : LASX_I7_U<0b011101110110011>,
                    LASX_D_DESC_BASE<"xvssrani.du.q", int_loongarch_lasx_xvssrani_du_q, LASX256DOpnd>;


def XVSSRARNI_B_H : LASX_I4_U<0b011101110110100001>,
                    LASX_U4_DESC_BASE<"xvssrarni.b.h", int_loongarch_lasx_xvssrarni_b_h, uimm4, immZExt4, LASX256BOpnd>;

def XVSSRARNI_H_W : LASX_I5_U<0b01110111011010001>,
                    LASX_N4_U5_DESC_BASE<"xvssrarni.h.w", int_loongarch_lasx_xvssrarni_h_w, uimm5, immZExt5, LASX256HOpnd>;

def XVSSRARNI_W_D : LASX_I6_U<0b0111011101101001>,
                    LASX_U6_DESC_BASE<"xvssrarni.w.d", int_loongarch_lasx_xvssrarni_w_d, uimm6, immZExt6, LASX256WOpnd>;

def XVSSRARNI_D_Q : LASX_I7_U<0b011101110110101>,
                    LASX_D_DESC_BASE<"xvssrarni.d.q", int_loongarch_lasx_xvssrarni_d_q, LASX256DOpnd>;


def XVSSRARNI_BU_H : LASX_I4_U<0b011101110110110001>,
                     LASX_U4_DESC_BASE<"xvssrarni.bu.h", int_loongarch_lasx_xvssrarni_bu_h, uimm4, immZExt4, LASX256BOpnd>;

def XVSSRARNI_HU_W : LASX_I5_U<0b01110111011011001>,
                     LASX_N4_U5_DESC_BASE<"xvssrarni.hu.w", int_loongarch_lasx_xvssrarni_hu_w, uimm5, immZExt5, LASX256HOpnd>;

def XVSSRARNI_WU_D : LASX_I6_U<0b0111011101101101>,
                     LASX_U6_DESC_BASE<"xvssrarni.wu.d", int_loongarch_lasx_xvssrarni_wu_d, uimm6, immZExt6, LASX256WOpnd>;

def XVSSRARNI_DU_Q : LASX_I7_U<0b011101110110111>,
                     LASX_D_DESC_BASE<"xvssrarni.du.q", int_loongarch_lasx_xvssrarni_du_q, LASX256DOpnd>;


def XVEXTRINS_B : LASX_I8_U<0b01110111100011>,
                  LASX_2R_3R_U8_DESC_BASE<"xvextrins.b", int_loongarch_lasx_xvextrins_b, LASX256BOpnd, LASX256BOpnd>;

def XVEXTRINS_H : LASX_I8_U<0b01110111100010>,
                  LASX_2R_3R_U8_DESC_BASE<"xvextrins.h", int_loongarch_lasx_xvextrins_h, LASX256HOpnd, LASX256HOpnd>;

def XVEXTRINS_W : LASX_I8_U<0b01110111100001>,
                  LASX_2R_3R_U8_DESC_BASE<"xvextrins.w", int_loongarch_lasx_xvextrins_w, LASX256WOpnd, LASX256WOpnd>;

def XVEXTRINS_D : LASX_I8_U<0b01110111100000>,
                  LASX_2R_3R_U8_DESC_BASE<"xvextrins.d", int_loongarch_lasx_xvextrins_d, LASX256DOpnd, LASX256DOpnd>;


def XVSHUF4I_B : LASX_I8_U<0b01110111100100>,
                 LASX_I8_SHF_DESC_BASE<"xvshuf4i.b", int_loongarch_lasx_xvshuf4i_b, LASX256BOpnd>;

def XVSHUF4I_H : LASX_I8_U<0b01110111100101>,
                 LASX_I8_SHF_DESC_BASE<"xvshuf4i.h", int_loongarch_lasx_xvshuf4i_h, LASX256HOpnd>;

def XVSHUF4I_W : LASX_I8_U<0b01110111100110>,
                 LASX_I8_SHF_DESC_BASE<"xvshuf4i.w", int_loongarch_lasx_xvshuf4i_w, LASX256WOpnd>;

def XVSHUF4I_D : LASX_I8_U<0b01110111100111>,
                 LASX_I8_O4_SHF_DESC_BASE<"xvshuf4i.d", int_loongarch_lasx_xvshuf4i_d, LASX256DOpnd>;


def XVBITSELI_B : LASX_I8_U<0b01110111110001>,
                  LASX_2R_3R_U8_DESC_BASE<"xvbitseli.b", int_loongarch_lasx_xvbitseli_b, LASX256BOpnd, LASX256BOpnd>;


def XVANDI_B : LASX_I8_U<0b01110111110100>,
               LASX_2R_U8_DESC_BASE<"xvandi.b", int_loongarch_lasx_xvandi_b, LASX256BOpnd, LASX256BOpnd>;


def XVORI_B : LASX_I8_U<0b01110111110101>,
              LASX_2R_U8_DESC_BASE<"xvori.b", int_loongarch_lasx_xvori_b, LASX256BOpnd, LASX256BOpnd>;


def XVXORI_B : LASX_I8_U<0b01110111110110>,
               LASX_2R_U8_DESC_BASE<"xvxori.b", int_loongarch_lasx_xvxori_b, LASX256BOpnd, LASX256BOpnd>;


def XVNORI_B : LASX_I8_U<0b01110111110111>,
               LASX_2R_U8_DESC_BASE<"xvnori.b", int_loongarch_lasx_xvnori_b, LASX256BOpnd, LASX256BOpnd>;


def XVLDI : LASX_1R_I13<0b01110111111000>,
            LASX_I13_DESC_BASE<"xvldi", int_loongarch_lasx_xvldi, i32, simm13Op, LASX256DOpnd>;


def XVLDI_B : LASX_1R_I13_I10<0b01110111111000000>,
              LASX_I13_DESC_BASE_10<"xvldi", int_loongarch_lasx_xvrepli_b, simm10, immZExt10, LASX256BOpnd>;

def XVLDI_H : LASX_1R_I13_I10<0b01110111111000001>,
              LASX_I13_DESC_BASE_10<"xvldi", int_loongarch_lasx_xvrepli_h, simm10, immZExt10, LASX256HOpnd>;

def XVLDI_W : LASX_1R_I13_I10<0b01110111111000010>,
              LASX_I13_DESC_BASE_10<"xvldi", int_loongarch_lasx_xvrepli_w, simm10, immZExt10, LASX256WOpnd>;

def XVLDI_D : LASX_1R_I13_I10<0b01110111111000011>,
              LASX_I13_DESC_BASE_10<"xvldi", int_loongarch_lasx_xvrepli_d, simm10, immZExt10, LASX256DOpnd>;


def XVPERMI_W : LASX_I8_U<0b01110111111001>,
                LASX_2R_3R_U8_DESC_BASE<"xvpermi.w", int_loongarch_lasx_xvpermi_w, LASX256WOpnd, LASX256WOpnd>;

def XVPERMI_D : LASX_I8_U<0b01110111111010>,
                LASX_2R_U8_DESC_BASE<"xvpermi.d", int_loongarch_lasx_xvpermi_d, LASX256DOpnd, LASX256DOpnd>;

def XVPERMI_Q : LASX_I8_U<0b01110111111011>,
                LASX_2R_3R_U8_DESC_BASE<"xvpermi.q", int_loongarch_lasx_xvpermi_q, LASX256BOpnd, LASX256BOpnd>;


//Pat

class LASXBitconvertPat<ValueType DstVT, ValueType SrcVT,
                       RegisterClass DstRC, list<Predicate> preds = [HasLASX]> :
   LASXPat<(DstVT (bitconvert SrcVT:$src)),
          (COPY_TO_REGCLASS SrcVT:$src, DstRC), preds>;

// These are endian-independent because the element size doesnt change
def : LASXBitconvertPat<v8i32,  v8f32,  LASX256W>;
def : LASXBitconvertPat<v4i64,  v4f64,  LASX256D>;
def : LASXBitconvertPat<v8f32,  v8i32,  LASX256W>;
def : LASXBitconvertPat<v4f64,  v4i64,  LASX256D>;

def : LASXBitconvertPat<v32i8, v16i16, LASX256B, [HasLASX]>;
def : LASXBitconvertPat<v32i8, v8i32,  LASX256B, [HasLASX]>;
def : LASXBitconvertPat<v32i8, v4i64,  LASX256B, [HasLASX]>;
def : LASXBitconvertPat<v32i8, v8f32,  LASX256B, [HasLASX]>;
def : LASXBitconvertPat<v32i8, v4f64,  LASX256B, [HasLASX]>;

def : LASXBitconvertPat<v16i16, v32i8,  LASX256H, [HasLASX]>;
def : LASXBitconvertPat<v16i16, v8i32,  LASX256H, [HasLASX]>;
def : LASXBitconvertPat<v16i16, v4i64,  LASX256H, [HasLASX]>;
def : LASXBitconvertPat<v16i16, v8f32,  LASX256H, [HasLASX]>;
def : LASXBitconvertPat<v16i16, v4f64,  LASX256H, [HasLASX]>;

def : LASXBitconvertPat<v8i32, v32i8,  LASX256W, [HasLASX]>;
def : LASXBitconvertPat<v8i32, v16i16, LASX256W, [HasLASX]>;
def : LASXBitconvertPat<v8i32, v4i64,  LASX256W, [HasLASX]>;
def : LASXBitconvertPat<v8i32, v4f64,  LASX256W, [HasLASX]>;

def : LASXBitconvertPat<v4i64, v32i8,  LASX256D, [HasLASX]>;
def : LASXBitconvertPat<v4i64, v16i16, LASX256D, [HasLASX]>;
def : LASXBitconvertPat<v4i64, v8i32,  LASX256D, [HasLASX]>;
def : LASXBitconvertPat<v4i64, v8f32,  LASX256D, [HasLASX]>;

def : LASXBitconvertPat<v8f32, v32i8,  LASX256W, [HasLASX]>;
def : LASXBitconvertPat<v8f32, v16i16, LASX256W, [HasLASX]>;
def : LASXBitconvertPat<v8f32, v4i64,  LASX256W, [HasLASX]>;
def : LASXBitconvertPat<v8f32, v4f64,  LASX256W, [HasLASX]>;

def : LASXBitconvertPat<v4f64, v32i8,  LASX256D, [HasLASX]>;
def : LASXBitconvertPat<v4f64, v16i16, LASX256D, [HasLASX]>;
def : LASXBitconvertPat<v4f64, v8i32,  LASX256D, [HasLASX]>;
def : LASXBitconvertPat<v4f64, v8f32,  LASX256D, [HasLASX]>;

class LASX_XINSERT_PSEUDO_BASE<SDPatternOperator OpNode, ValueType Ty,
                             Operand ImmOp, ImmLeaf Imm, RegisterOperand ROXD,
                             RegisterOperand ROFS> :
      LASXPseudo<(outs ROXD:$xd), (ins ROXD:$xd_in, ImmOp:$n, ROFS:$fs),
                [(set ROXD:$xd, (OpNode (Ty ROXD:$xd_in), ROFS:$fs, Imm:$n))]> {
  bit usesCustomInserter = 1;
  string Constraints = "$xd = $xd_in";
}

class XINSERT_H_PSEUDO_DESC : LASX_XINSERT_PSEUDO_BASE<vector_insert, v16i16,
                                                     uimm4_ptr, immZExt4Ptr,
                                                     LASX256HOpnd, GPR32Opnd>;

class XINSERT_H64_PSEUDO_DESC : LASX_XINSERT_PSEUDO_BASE<vector_insert, v16i16,
                                                     uimm4_ptr, immZExt4Ptr,
                                                     LASX256HOpnd, GPR64Opnd>;

def XINSERT_H_PSEUDO : XINSERT_H_PSEUDO_DESC;
def XINSERT_H64_PSEUDO : XINSERT_H64_PSEUDO_DESC;

class XINSERT_B_PSEUDO_DESC : LASX_XINSERT_PSEUDO_BASE<vector_insert, v32i8,
                                                     uimm5_ptr, immZExt5Ptr,
                                                     LASX256BOpnd, GPR32Opnd>;
def XINSERT_B_PSEUDO : XINSERT_B_PSEUDO_DESC;


class LASX_COPY_PSEUDO_BASE<SDPatternOperator OpNode, ValueType VecTy,
                           Operand ImmOp, ImmLeaf Imm, RegisterClass RCD,
                           RegisterClass RCWS> :
      LASXPseudo<(outs RCD:$xd), (ins RCWS:$xj, ImmOp:$n),
                [(set RCD:$xd, (OpNode (VecTy RCWS:$xj), Imm:$n))]> {
  bit usesCustomInserter = 1;
}

class XCOPY_FW_PSEUDO_DESC : LASX_COPY_PSEUDO_BASE<vector_extract, v8f32,
                                                 uimm3_ptr, immZExt3Ptr, FGR32,
                                                 LASX256W>;
class XCOPY_FD_PSEUDO_DESC : LASX_COPY_PSEUDO_BASE<vector_extract, v4f64,
                                                 uimm2_ptr, immZExt2Ptr, FGR64,
                                                 LASX256D>;
def XCOPY_FW_PSEUDO : XCOPY_FW_PSEUDO_DESC;
def XCOPY_FD_PSEUDO : XCOPY_FD_PSEUDO_DESC;



class LASX_XINSERT_VIDX_PSEUDO_BASE<SDPatternOperator OpNode, ValueType Ty,
                                  RegisterOperand ROXD, RegisterOperand ROFS,
                                  RegisterOperand ROIdx> :
      LASXPseudo<(outs ROXD:$xd), (ins ROXD:$xd_in, ROIdx:$n, ROFS:$fs),
                 [(set ROXD:$xd, (OpNode (Ty ROXD:$xd_in), ROFS:$fs, ROIdx:$n))]> {
  bit usesCustomInserter = 1;
  string Constraints = "$xd = $xd_in";
}


class XINSERT_FW_PSEUDO_DESC : LASX_XINSERT_PSEUDO_BASE<insertelt, v8f32,
                                                     uimm3_ptr, immZExt3Ptr,
                                                     LASX256WOpnd, FGR32Opnd>;
def XINSERT_FW_PSEUDO : XINSERT_FW_PSEUDO_DESC;

class XINSERT_FW_VIDX_PSEUDO_DESC :
    LASX_XINSERT_VIDX_PSEUDO_BASE<insertelt, v8f32, LASX256WOpnd, FGR32Opnd, GPR32Opnd>;
class XINSERT_FW_VIDX64_PSEUDO_DESC :
    LASX_XINSERT_VIDX_PSEUDO_BASE<insertelt, v8f32, LASX256WOpnd, FGR32Opnd, GPR64Opnd>;

def XINSERT_FW_VIDX_PSEUDO : XINSERT_FW_VIDX_PSEUDO_DESC;
def XINSERT_FW_VIDX64_PSEUDO : XINSERT_FW_VIDX64_PSEUDO_DESC;

class XINSERT_B_VIDX64_PSEUDO_DESC :
    LASX_XINSERT_VIDX_PSEUDO_BASE<vector_insert, v32i8, LASX256BOpnd, GPR32Opnd, GPR64Opnd>;

def XINSERT_B_VIDX64_PSEUDO : XINSERT_B_VIDX64_PSEUDO_DESC;


class XINSERT_B_VIDX_PSEUDO_DESC :
    LASX_XINSERT_VIDX_PSEUDO_BASE<vector_insert, v32i8, LASX256BOpnd, GPR32Opnd, GPR32Opnd>;

def XINSERT_B_VIDX_PSEUDO : XINSERT_B_VIDX_PSEUDO_DESC;


class XINSERTPostRA<RegisterClass RC, RegisterClass RD, RegisterClass RE> :
  LoongArchPseudo<(outs RC:$xd), (ins RC:$xd_in, RD:$n, RE:$fs), []> {
  let mayLoad = 1;
  let mayStore = 1;
}

def XINSERT_B_VIDX_PSEUDO_POSTRA  : XINSERTPostRA<LASX256B, GPR32, GPR32>;
def XINSERT_B_VIDX64_PSEUDO_POSTRA  : XINSERTPostRA<LASX256B, GPR64, GPR32>;
def XINSERT_FW_VIDX_PSEUDO_POSTRA  : XINSERTPostRA<LASX256W, GPR32, GPR32>;
def XINSERT_FW_VIDX64_PSEUDO_POSTRA  : XINSERTPostRA<LASX256W, GPR64, GPR32>;

class XINSERT_FD_PSEUDO_DESC : LASX_XINSERT_PSEUDO_BASE<insertelt, v4f64,
                                                     uimm2_ptr, immZExt2Ptr,
                                                     LASX256DOpnd, FGR64Opnd>;

def XINSERT_FD_PSEUDO : XINSERT_FD_PSEUDO_DESC;

class LASX_2R_FILL_PSEUDO_BASE<ValueType VT, SDPatternOperator OpNode,
                              RegisterClass RCWD, RegisterClass RCWS = RCWD> :
      LASXPseudo<(outs RCWD:$xd), (ins RCWS:$fs),
                [(set RCWD:$xd, (OpNode RCWS:$fs))]> {
  let usesCustomInserter = 1;
}

class XFILL_FW_PSEUDO_DESC : LASX_2R_FILL_PSEUDO_BASE<v8f32, xvsplatf32, LASX256W,
                                                   FGR32>;
class XFILL_FD_PSEUDO_DESC : LASX_2R_FILL_PSEUDO_BASE<v4f64, xvsplatf64, LASX256D,
                                                    FGR64>;
def XFILL_FW_PSEUDO : XFILL_FW_PSEUDO_DESC;
def XFILL_FD_PSEUDO : XFILL_FD_PSEUDO_DESC;

class LASX_CONCAT_VECTORS_PSEUDO_BASE<ValueType Ty, ValueType SubTy,
                                  RegisterOperand ROXD, RegisterOperand ROXJ,
                                  RegisterOperand ROXK = ROXJ> :
      LASXPseudo<(outs ROXD:$xd), (ins ROXJ:$xs, ROXK:$xt),
                [(set ROXD:$xd, (Ty (concat_vectors (SubTy ROXJ:$xs), (SubTy ROXK:$xt))))]> {
  bit usesCustomInserter = 1;
}

class CONCAT_VECTORS_B_PSEUDO_DESC :
    LASX_CONCAT_VECTORS_PSEUDO_BASE<v32i8, v16i8, LASX256BOpnd, LSX128BOpnd>;
class CONCAT_VECTORS_H_PSEUDO_DESC :
    LASX_CONCAT_VECTORS_PSEUDO_BASE<v16i16, v8i16, LASX256HOpnd, LSX128HOpnd>;
class CONCAT_VECTORS_W_PSEUDO_DESC :
    LASX_CONCAT_VECTORS_PSEUDO_BASE<v8i32, v4i32, LASX256WOpnd, LSX128WOpnd>;
class CONCAT_VECTORS_D_PSEUDO_DESC :
    LASX_CONCAT_VECTORS_PSEUDO_BASE<v4i64, v2i64, LASX256DOpnd, LSX128DOpnd>;

class CONCAT_VECTORS_FW_PSEUDO_DESC :
    LASX_CONCAT_VECTORS_PSEUDO_BASE<v8f32, v4f32, LASX256WOpnd, LSX128WOpnd>;
class CONCAT_VECTORS_FD_PSEUDO_DESC :
    LASX_CONCAT_VECTORS_PSEUDO_BASE<v4f64, v2f64, LASX256DOpnd, LSX128DOpnd>;

def CONCAT_VECTORS_B_PSEUDO : CONCAT_VECTORS_B_PSEUDO_DESC;
def CONCAT_VECTORS_H_PSEUDO : CONCAT_VECTORS_H_PSEUDO_DESC;
def CONCAT_VECTORS_W_PSEUDO : CONCAT_VECTORS_W_PSEUDO_DESC;
def CONCAT_VECTORS_D_PSEUDO : CONCAT_VECTORS_D_PSEUDO_DESC;
def CONCAT_VECTORS_FW_PSEUDO : CONCAT_VECTORS_FW_PSEUDO_DESC;
def CONCAT_VECTORS_FD_PSEUDO : CONCAT_VECTORS_FD_PSEUDO_DESC;


class LASX_COPY_GPR_PSEUDO_BASE<SDPatternOperator OpNode, ValueType VecTy,
                           RegisterOperand ROXD, RegisterOperand ROFS,
                           RegisterOperand ROIdx> :
      LASXPseudo<(outs ROXD:$xd), (ins ROFS:$xj, ROIdx:$n),
                [(set ROXD:$xd, (OpNode (VecTy ROFS:$xj), ROIdx:$n))]> {
  bit usesCustomInserter = 1;
}

class XCOPY_FW_GPR_PSEUDO_DESC : LASX_COPY_GPR_PSEUDO_BASE<vector_extract, v8f32,
                                                           FGR32Opnd, LASX256WOpnd, GPR64Opnd>;
def XCOPY_FW_GPR_PSEUDO : XCOPY_FW_GPR_PSEUDO_DESC;


let isCodeGenOnly = 1 in {

def XVLD_H : LASX_I12_S<0b0010110010>,
             LASX_LD<"xvld", load, v16i16, LASX256HOpnd, mem>;

def XVLD_W : LASX_I12_S<0b0010110010>,
             LASX_LD<"xvld", load, v8i32, LASX256WOpnd, mem>;

def XVLD_D : LASX_I12_S<0b0010110010>,
             LASX_LD<"xvld", load, v4i64, LASX256DOpnd, mem>;


def XVST_H : LASX_I12_S<0b0010110011>,
             LASX_ST<"xvst", store, v16i16, LASX256HOpnd, mem_simm12>;

def XVST_W : LASX_I12_S<0b0010110011>,
             LASX_ST<"xvst", store, v8i32, LASX256WOpnd, mem_simm12>;

def XVST_D : LASX_I12_S<0b0010110011>,
             LASX_ST<"xvst", store, v4i64, LASX256DOpnd, mem_simm12>;


def XVREPLVE_W_N : LASX_3R_1GP<0b01110101001000110>,
                   LASX_3R_VREPLVE_DESC_BASE_N<"xvreplve.w", LASX256WOpnd>;


def XVANDI_B_N : LASX_I8_U<0b01110111110100>,
                 LASX_BIT_U8_DESC_BASE<"xvandi.b", and, xvsplati8_uimm8, LASX256BOpnd>;


def XVXORI_B_N : LASX_I8_U<0b01110111110110>,
                 LASX_BIT_U8_DESC_BASE<"xvxori.b", xor, xvsplati8_uimm8, LASX256BOpnd>;


def XVSRAI_B_N : LASX_I3_U<0b0111011100110100001>,
                 LASX_BIT_U3_VREPLVE_DESC_BASE<"xvsrai.b", sra, xvsplati8_uimm3, LASX256BOpnd>;

def XVSRAI_H_N : LASX_I4_U<0b011101110011010001>,
                 LASX_BIT_U4_VREPLVE_DESC_BASE<"xvsrai.h", sra, xvsplati16_uimm4, LASX256HOpnd>;

def XVSRAI_W_N : LASX_I5_U<0b01110111001101001>,
                 LASX_BIT_U5_VREPLVE_DESC_BASE<"xvsrai.w", sra, xvsplati32_uimm5, LASX256WOpnd>;

def XVSRAI_D_N : LASX_I6_U<0b0111011100110101>,
                 LASX_BIT_U6_VREPLVE_DESC_BASE<"xvsrai.d", sra, xvsplati64_uimm6,  LASX256DOpnd>;


def XVSLLI_B_N : LASX_I3_U<0b0111011100101100001>,
                 LASX_BIT_U3_VREPLVE_DESC_BASE<"xvslli.b", shl, xvsplati8_uimm3, LASX256BOpnd>;

def XVSLLI_H_N : LASX_I4_U<0b011101110010110001>,
                 LASX_BIT_U4_VREPLVE_DESC_BASE<"xvslli.h", shl, xvsplati16_uimm4, LASX256HOpnd>;

def XVSLLI_W_N : LASX_I5_U<0b01110111001011001>,
                 LASX_BIT_U5_VREPLVE_DESC_BASE<"xvslli.w", shl, xvsplati32_uimm5, LASX256WOpnd>;

def XVSLLI_D_N : LASX_I6_U<0b0111011100101101>,
                 LASX_BIT_U6_VREPLVE_DESC_BASE<"xvslli.d", shl, xvsplati64_uimm6, LASX256DOpnd>;


def XVSRLI_B_N : LASX_I3_U<0b0111011100110000001>,
                 LASX_BIT_U3_VREPLVE_DESC_BASE<"xvsrli.b", srl, xvsplati8_uimm3, LASX256BOpnd>;

def XVSRLI_H_N : LASX_I4_U<0b011101110011000001>,
                 LASX_BIT_U4_VREPLVE_DESC_BASE<"xvsrli.h", srl, xvsplati16_uimm4, LASX256HOpnd>;

def XVSRLI_W_N : LASX_I5_U<0b01110111001100001>,
                 LASX_BIT_U5_VREPLVE_DESC_BASE<"xvsrli.w", srl, xvsplati32_uimm5, LASX256WOpnd>;

def XVSRLI_D_N : LASX_I6_U<0b0111011100110001>,
                 LASX_BIT_U6_VREPLVE_DESC_BASE<"xvsrli.d", srl, xvsplati64_uimm6, LASX256DOpnd>;


def XVMAXI_B_N : LASX_I5<0b01110110100100000>,
                 LASX_I5_DESC_BASE<"xvmaxi.b", smax, xvsplati8_simm5, LASX256BOpnd>;

def XVMAXI_H_N : LASX_I5<0b01110110100100001>,
                 LASX_I5_DESC_BASE<"xvmaxi.h", smax, xvsplati16_simm5, LASX256HOpnd>;

def XVMAXI_W_N : LASX_I5<0b01110110100100010>,
                 LASX_I5_DESC_BASE<"xvmaxi.w", smax, xvsplati32_simm5, LASX256WOpnd>;

def XVMAXI_D_N : LASX_I5<0b01110110100100011>,
                 LASX_I5_DESC_BASE<"xvmaxi.d", smax, xvsplati64_simm5, LASX256DOpnd>;


def XVMINI_B_N : LASX_I5<0b01110110100100100>,
                 LASX_I5_DESC_BASE<"xvmini.b", smin, xvsplati8_simm5, LASX256BOpnd>;

def XVMINI_H_N : LASX_I5<0b01110110100100101>,
                 LASX_I5_DESC_BASE<"xvmini.h", smin, xvsplati16_simm5, LASX256HOpnd>;

def XVMINI_W_N : LASX_I5<0b01110110100100110>,
                 LASX_I5_DESC_BASE<"xvmini.w", smin, xvsplati32_simm5, LASX256WOpnd>;

def XVMINI_D_N : LASX_I5<0b01110110100100111>,
                 LASX_I5_DESC_BASE<"xvmini.d", smin, xvsplati64_simm5, LASX256DOpnd>;


def XVMAXI_BU_N : LASX_I5_U<0b01110110100101000>,
                  LASX_I5_U_DESC_BASE<"xvmaxi.bu", umax, xvsplati8_uimm5, LASX256BOpnd>;

def XVMAXI_HU_N : LASX_I5_U<0b01110110100101001>,
                  LASX_I5_U_DESC_BASE<"xvmaxi.hu", umax, xvsplati16_uimm5, LASX256HOpnd>;

def XVMAXI_WU_N : LASX_I5_U<0b01110110100101010>,
                  LASX_I5_U_DESC_BASE<"xvmaxi.wu", umax, xvsplati32_uimm5, LASX256WOpnd>;

def XVMAXI_DU_N : LASX_I5_U<0b01110110100101011>,
                  LASX_I5_U_DESC_BASE<"xvmaxi.du", umax, xvsplati64_uimm5, LASX256DOpnd>;


def XVMINI_BU_N : LASX_I5_U<0b01110110100101100>,
                  LASX_I5_U_DESC_BASE<"xvmini.bu", umin, xvsplati8_uimm5, LASX256BOpnd>;

def XVMINI_HU_N : LASX_I5_U<0b01110110100101101>,
                  LASX_I5_U_DESC_BASE<"xvmini.hu", umin, xvsplati16_uimm5, LASX256HOpnd>;

def XVMINI_WU_N : LASX_I5_U<0b01110110100101110>,
                  LASX_I5_U_DESC_BASE<"xvmini.wu", umin, xvsplati32_uimm5, LASX256WOpnd>;

def XVMINI_DU_N : LASX_I5_U<0b01110110100101111>,
                  LASX_I5_U_DESC_BASE<"xvmini.du", umin, xvsplati64_uimm5, LASX256DOpnd>;


def XVSEQI_B_N : LASX_I5<0b01110110100000000>,
                 LASX_I5_SETCC_DESC_BASE<"xvseqi.b", SETEQ, v32i8, xvsplati8_simm5, LASX256BOpnd>;

def XVSEQI_H_N : LASX_I5<0b01110110100000001>,
                 LASX_I5_SETCC_DESC_BASE<"xvseqi.h", SETEQ, v16i16, xvsplati16_simm5, LASX256HOpnd>;

def XVSEQI_W_N : LASX_I5<0b01110110100000010>,
                 LASX_I5_SETCC_DESC_BASE<"xvseqi.w", SETEQ, v8i32, xvsplati32_simm5, LASX256WOpnd>;

def XVSEQI_D_N : LASX_I5<0b01110110100000011>,
                 LASX_I5_SETCC_DESC_BASE<"xvseqi.d", SETEQ, v4i64, xvsplati64_simm5, LASX256DOpnd>;


def XVSLEI_B_N : LASX_I5<0b01110110100000100>,
                 LASX_I5_SETCC_DESC_BASE<"xvslei.b", SETLE, v32i8, xvsplati8_simm5, LASX256BOpnd>;

def XVSLEI_H_N : LASX_I5<0b01110110100000101>,
                 LASX_I5_SETCC_DESC_BASE<"xvslei.h", SETLE, v16i16, xvsplati16_simm5, LASX256HOpnd>;

def XVSLEI_W_N : LASX_I5<0b01110110100000110>,
                 LASX_I5_SETCC_DESC_BASE<"xvslei.w", SETLE, v8i32, xvsplati32_simm5, LASX256WOpnd>;

def XVSLEI_D_N : LASX_I5<0b01110110100000111>,
                 LASX_I5_SETCC_DESC_BASE<"xvslei.d", SETLE, v4i64, xvsplati64_simm5, LASX256DOpnd>;


def XVSLEI_BU_N : LASX_I5_U<0b01110110100001000>,
                  LASX_I5_U_SETCC_DESC_BASE<"xvslei.bu", SETULE, v32i8, xvsplati8_uimm5, LASX256BOpnd>;

def XVSLEI_HU_N : LASX_I5_U<0b01110110100001001>,
                  LASX_I5_U_SETCC_DESC_BASE<"xvslei.hu", SETULE, v16i16, xvsplati16_uimm5, LASX256HOpnd>;

def XVSLEI_WU_N : LASX_I5_U<0b01110110100001010>,
                  LASX_I5_U_SETCC_DESC_BASE<"xvslei.wu", SETULE, v8i32, xvsplati32_uimm5, LASX256WOpnd>;

def XVSLEI_DU_N : LASX_I5_U<0b01110110100001011>,
                  LASX_I5_U_SETCC_DESC_BASE<"xvslei.du", SETULE, v4i64, xvsplati64_uimm5, LASX256DOpnd>;


def XVSLTI_B_N : LASX_I5<0b01110110100001100>,
                 LASX_I5_SETCC_DESC_BASE<"xvslti.b", SETLT, v32i8, xvsplati8_simm5, LASX256BOpnd>;

def XVSLTI_H_N : LASX_I5<0b01110110100001101>,
                 LASX_I5_SETCC_DESC_BASE<"xvslti.h", SETLT, v16i16, xvsplati16_simm5, LASX256HOpnd>;

def XVSLTI_W_N : LASX_I5<0b01110110100001110>,
                 LASX_I5_SETCC_DESC_BASE<"xvslti.w", SETLT, v8i32, xvsplati32_simm5, LASX256WOpnd>;

def XVSLTI_D_N : LASX_I5<0b01110110100001111>,
                 LASX_I5_SETCC_DESC_BASE<"xvslti.d", SETLT, v4i64, xvsplati64_simm5, LASX256DOpnd>;


def XVSLTI_BU_N : LASX_I5_U<0b01110110100010000>,
                  LASX_I5_U_SETCC_DESC_BASE<"xvslti.bu", SETULT, v32i8, xvsplati8_uimm5, LASX256BOpnd>;

def XVSLTI_HU_N : LASX_I5_U<0b01110110100010001>,
                  LASX_I5_U_SETCC_DESC_BASE<"xvslti.hu", SETULT, v16i16, xvsplati16_uimm5, LASX256HOpnd>;

def XVSLTI_WU_N : LASX_I5_U<0b01110110100010010>,
                  LASX_I5_U_SETCC_DESC_BASE<"xvslti.wu", SETULT, v8i32, xvsplati32_uimm5, LASX256WOpnd>;

def XVSLTI_DU_N : LASX_I5_U<0b01110110100010011>,
                  LASX_I5_U_SETCC_DESC_BASE<"xvslti.du", SETULT, v4i64, xvsplati64_uimm5, LASX256DOpnd>;


def XVADDI_BU_N : LASX_I5_U<0b01110110100010100>,
                  LASX_I5_U_DESC_BASE<"xvaddi.bu", add, xvsplati8_uimm5, LASX256BOpnd>;

def XVADDI_HU_N : LASX_I5_U<0b01110110100010101>,
                  LASX_I5_U_DESC_BASE<"xvaddi.hu", add, xvsplati16_uimm5, LASX256HOpnd>;

def XVADDI_WU_N : LASX_I5_U<0b01110110100010110>,
                  LASX_I5_U_DESC_BASE<"xvaddi.wu", add, xvsplati32_uimm5, LASX256WOpnd>;

def XVADDI_DU_N : LASX_I5_U<0b01110110100010111>,
                  LASX_I5_U_DESC_BASE<"xvaddi.du", add, xvsplati64_uimm5, LASX256DOpnd>;


def XVSUBI_BU_N : LASX_I5_U<0b01110110100011000>,
                  LASX_I5_U_DESC_BASE<"xvsubi.bu", sub, xvsplati8_uimm5, LASX256BOpnd>;

def XVSUBI_HU_N : LASX_I5_U<0b01110110100011001>,
                  LASX_I5_U_DESC_BASE<"xvsubi.hu", sub, xvsplati16_uimm5, LASX256HOpnd>;

def XVSUBI_WU_N : LASX_I5_U<0b01110110100011010>,
                  LASX_I5_U_DESC_BASE<"xvsubi.wu", sub, xvsplati32_uimm5, LASX256WOpnd>;

def XVSUBI_DU_N : LASX_I5_U<0b01110110100011011>,
                  LASX_I5_U_DESC_BASE<"xvsubi.du", sub, xvsplati64_uimm5, LASX256DOpnd>;


def XVPERMI_QH : LASX_I8_U<0b01110111111011>,
                 LASX_2RN_3R_U8_DESC_BASE<"xvpermi.q", LASX256HOpnd, LASX256HOpnd>;

def XVPERMI_QW : LASX_I8_U<0b01110111111011>,
                 LASX_2RN_3R_U8_DESC_BASE<"xvpermi.q", LASX256WOpnd, LASX256WOpnd>;

def XVPERMI_QD : LASX_I8_U<0b01110111111011>,
                 LASX_2RN_3R_U8_DESC_BASE<"xvpermi.q", LASX256DOpnd, LASX256DOpnd>;


def XVBITSELI_B_N : LASX_I8_U<0b01110111110001>,
                    LASX_2R_3R_U8_SELECT<"xvbitseli.b", vselect, LASX256BOpnd, LASX256BOpnd>;

}


def : LASXPat<(v8f32 (load addrimm12:$addr)), (XVLD_W addrimm12:$addr)>;
def : LASXPat<(v4f64 (load addrimm12:$addr)), (XVLD_D addrimm12:$addr)>;

def XVST_FW : LASXPat<(store (v8f32 LASX256W:$xj), addrimm12:$addr),
                      (XVST_W LASX256W:$xj, addrimm12:$addr)>;
def XVST_FD : LASXPat<(store (v4f64 LASX256D:$xj), addrimm12:$addr),
                      (XVST_D LASX256D:$xj, addrimm12:$addr)>;

def XVNEG_FW : LASXPat<(fneg (v8f32 LASX256W:$xj)),
                       (XVBITREVI_W LASX256W:$xj, 31)>;
def XVNEG_FD : LASXPat<(fneg (v4f64 LASX256D:$xj)),
                       (XVBITREVI_D LASX256D:$xj, 63)>;


def : LASXPat<(v4i64 (LoongArchVABSD v4i64:$xj, v4i64:$xk, (i32 0))),
              (v4i64 (XVABSD_D $xj, $xk))>;

def : LASXPat<(v8i32 (LoongArchVABSD v8i32:$xj, v8i32:$xk, (i32 0))),
              (v8i32 (XVABSD_W $xj, $xk))>;

def : LASXPat<(v16i16 (LoongArchVABSD v16i16:$xj, v16i16:$xk, (i32 0))),
              (v16i16 (XVABSD_H $xj, $xk))>;

def : LASXPat<(v32i8 (LoongArchVABSD v32i8:$xj, v32i8:$xk, (i32 0))),
              (v32i8 (XVABSD_B $xj, $xk))>;

def : LASXPat<(v4i64 (LoongArchUVABSD v4i64:$xj, v4i64:$xk, (i32 0))),
              (v4i64 (XVABSD_DU $xj, $xk))>;

def : LASXPat<(v8i32 (LoongArchUVABSD v8i32:$xj, v8i32:$xk, (i32 0))),
              (v8i32 (XVABSD_WU $xj, $xk))>;

def : LASXPat<(v16i16 (LoongArchUVABSD v16i16:$xj, v16i16:$xk, (i32 0))),
              (v16i16 (XVABSD_HU $xj, $xk))>;

def : LASXPat<(v32i8 (LoongArchUVABSD v32i8:$xj, v32i8:$xk, (i32 0))),
              (v32i8 (XVABSD_BU $xj, $xk))>;


def : LASXPat<(or v32i8:$vj, (shl vsplat_imm_eq_1, v32i8:$vk)),
              (XVBITSET_B v32i8:$vj, v32i8:$vk)>;
def : LASXPat<(or v16i16:$vj, (shl vsplat_imm_eq_1, v16i16:$vk)),
              (XVBITSET_H v16i16:$vj, v16i16:$vk)>;
def : LASXPat<(or v8i32:$vj, (shl vsplat_imm_eq_1, v8i32:$vk)),
              (XVBITSET_W v8i32:$vj, v8i32:$vk)>;
def : LASXPat<(or v4i64:$vj, (shl vsplat_imm_eq_1, v4i64:$vk)),
              (XVBITSET_D v4i64:$vj, v4i64:$vk)>;

def : LASXPat<(xor v32i8:$vj, (shl xvsplat_imm_eq_1, v32i8:$vk)),
              (XVBITREV_B v32i8:$vj, v32i8:$vk)>;
def : LASXPat<(xor v16i16:$vj, (shl xvsplat_imm_eq_1, v16i16:$vk)),
              (XVBITREV_H v16i16:$vj, v16i16:$vk)>;
def : LASXPat<(xor v8i32:$vj, (shl xvsplat_imm_eq_1, v8i32:$vk)),
              (XVBITREV_W v8i32:$vj, v8i32:$vk)>;
def : LASXPat<(xor v4i64:$vj, (shl (v4i64 xvsplati64_imm_eq_1), v4i64:$vk)),
              (XVBITREV_D v4i64:$vj, v4i64:$vk)>;

def : LASXPat<(and v32i8:$vj, (xor (shl vsplat_imm_eq_1, v32i8:$vk), immAllOnesV)),
              (XVBITCLR_B v32i8:$vj, v32i8:$vk)>;
def : LASXPat<(and v16i16:$vj, (xor (shl vsplat_imm_eq_1, v16i16:$vk), immAllOnesV)),
              (XVBITCLR_H v16i16:$vj, v16i16:$vk)>;
def : LASXPat<(and v8i32:$vj, (xor (shl vsplat_imm_eq_1, v8i32:$vk), immAllOnesV)),
              (XVBITCLR_W v8i32:$vj, v8i32:$vk)>;
def : LASXPat<(and v4i64:$vj, (xor (shl (v4i64 vsplati64_imm_eq_1), v4i64:$vk), (bitconvert (v8i32 immAllOnesV)))),
              (XVBITCLR_D v4i64:$vj, v4i64:$vk)>;

def xvsplati64_imm_eq_63 : PatLeaf<(bitconvert (v8i32 (build_vector))), [{
  APInt Imm;
  SDNode *BV = N->getOperand(0).getNode();
  EVT EltTy = N->getValueType(0).getVectorElementType();

  return selectVSplat(BV, Imm, EltTy.getSizeInBits()) &&
         Imm.getBitWidth() == EltTy.getSizeInBits() && Imm == 63;
}]>;

def xvsplati8imm7 :   PatFrag<(ops node:$wt),
                              (and node:$wt, (xvsplati8 immi32Cst7))>;
def xvsplati16imm15 : PatFrag<(ops node:$wt),
                              (and node:$wt, (xvsplati16 immi32Cst15))>;
def xvsplati32imm31 : PatFrag<(ops node:$wt),
                              (and node:$wt, (xvsplati32 immi32Cst31))>;
def xvsplati64imm63 : PatFrag<(ops node:$wt),
                              (and node:$wt, xvsplati64_imm_eq_63)>;


class LASXShiftPat<SDNode Node, ValueType VT, LASXInst Insn, dag Vec> :
  LASXPat<(VT (Node VT:$vs, (VT (and VT:$vt, Vec)))),
         (VT (Insn VT:$vs, VT:$vt))>;

class LASXBitPat<SDNode Node, ValueType VT, LASXInst Insn, PatFrag Frag> :
  LASXPat<(VT (Node VT:$vs, (shl vsplat_imm_eq_1, (Frag VT:$vt)))),
         (VT (Insn VT:$vs, VT:$vt))>;

multiclass LASXShiftPats<SDNode Node, string Insn> {
  def : LASXShiftPat<Node, v32i8, !cast<LASXInst>(Insn#_B),
                    (xvsplati8 immi32Cst7)>;
  def : LASXShiftPat<Node, v16i16, !cast<LASXInst>(Insn#_H),
                    (xvsplati16 immi32Cst15)>;
  def : LASXShiftPat<Node, v8i32, !cast<LASXInst>(Insn#_W),
                    (xvsplati32 immi32Cst31)>;
  def : LASXPat<(v4i64 (Node v4i64:$vs, (v4i64 (and v4i64:$vt,
                                                    xvsplati64_imm_eq_63)))),
               (v4i64 (!cast<LASXInst>(Insn#_D) v4i64:$vs, v4i64:$vt))>;
}

multiclass LASXBitPats<SDNode Node, string Insn> {
  def : LASXBitPat<Node, v32i8, !cast<LASXInst>(Insn#_B), xvsplati8imm7>;
  def : LASXBitPat<Node, v16i16, !cast<LASXInst>(Insn#_H), xvsplati16imm15>;
  def : LASXBitPat<Node, v8i32, !cast<LASXInst>(Insn#_W), xvsplati32imm31>;
  def : LASXPat<(Node v4i64:$vs, (shl (v4i64 xvsplati64_imm_eq_1),
                                     (xvsplati64imm63 v4i64:$vt))),
               (v4i64 (!cast<LASXInst>(Insn#_D) v4i64:$vs, v4i64:$vt))>;
}

defm : LASXShiftPats<shl, "XVSLL">;
defm : LASXShiftPats<srl, "XVSRL">;
defm : LASXShiftPats<sra, "XVSRA">;
defm : LASXBitPats<xor, "XVBITREV">;
defm : LASXBitPats<or, "XVBITSET">;

def : LASXPat<(and v32i8:$vs, (xor (shl xvsplat_imm_eq_1,
                                       (xvsplati8imm7 v32i8:$vt)),
                                       immAllOnesV)),
              (v32i8 (XVBITCLR_B v32i8:$vs, v32i8:$vt))>;
def : LASXPat<(and v16i16:$vs, (xor (shl xvsplat_imm_eq_1,
                                       (xvsplati16imm15 v16i16:$vt)),
                                       immAllOnesV)),
              (v16i16 (XVBITCLR_H v16i16:$vs, v16i16:$vt))>;
def : LASXPat<(and v8i32:$vs, (xor (shl xvsplat_imm_eq_1,
                                       (xvsplati32imm31 v8i32:$vt)),
                                       immAllOnesV)),
              (v8i32 (XVBITCLR_W v8i32:$vs, v8i32:$vt))>;
def : LASXPat<(and v4i64:$vs, (xor (shl (v4i64 xvsplati64_imm_eq_1),
                                       (xvsplati64imm63 v4i64:$vt)),
                                       (bitconvert (v8i32 immAllOnesV)))),
              (v4i64 (XVBITCLR_D v4i64:$vs, v4i64:$vt))>;


def : LASXPat<(fdiv (v8f32 (build_vector (f32 fpimm1), (f32 fpimm1), (f32 fpimm1),
              (f32 fpimm1),(f32 fpimm1), (f32 fpimm1), (f32 fpimm1), (f32 fpimm1))), v8f32:$v),
              (XVFRECIP_S v8f32:$v)>;

def : LASXPat<(fdiv (v4f64 (build_vector (f64 fpimm1), (f64 fpimm1), (f64 fpimm1), (f64 fpimm1))), v4f64:$v),
              (XVFRECIP_D v4f64:$v)>;

def : LASXPat<(fdiv (v8f32 fpimm1), v8f32:$v),
              (XVFRECIP_S v8f32:$v)>;

def : LASXPat<(fdiv (v4f64 fpimm1), v4f64:$v),
              (XVFRECIP_D v4f64:$v)>;


def : LASXPat<(fdiv (v8f32 (build_vector (f32 fpimm1), (f32 fpimm1), (f32 fpimm1), (f32 fpimm1),
              (f32 fpimm1), (f32 fpimm1), (f32 fpimm1), (f32 fpimm1))), (fsqrt v8f32:$v)),
              (XVFRSQRT_S v8f32:$v)>;

def : LASXPat<(fdiv (v4f64 (build_vector (f64 fpimm1), (f64 fpimm1), (f64 fpimm1), (f64 fpimm1))), (fsqrt v4f64:$v)),
              (XVFRSQRT_D v4f64:$v)>;

def : LASXPat<(fdiv (v8f32 fpimm1), (fsqrt v8f32:$v)),
              (XVFRSQRT_S v8f32:$v)>;

def : LASXPat<(fdiv (v4f64 fpimm1), (fsqrt v4f64:$v)),
              (XVFRSQRT_D v4f64:$v)>;


def : LASXPat <(extract_subvector v4f64:$vec, (i32 0)),
               (v2f64 (EXTRACT_SUBREG v4f64:$vec, sub_128))>;

def : LASXPat <(extract_subvector v8f32:$vec, (i32 0)),
               (v4f32 (EXTRACT_SUBREG v8f32:$vec, sub_128))>;

def : LASXPat <(extract_subvector v4i64:$vec, (i32 0)),
               (v2i64 (EXTRACT_SUBREG v4i64:$vec, sub_128))>;

def : LASXPat <(extract_subvector v8i32:$vec, (i32 0)),
               (v4i32 (EXTRACT_SUBREG v8i32:$vec, sub_128))>;

def : LASXPat <(extract_subvector v16i16:$vec, (i32 0)),
               (v8i16 (EXTRACT_SUBREG v16i16:$vec, sub_128))>;

def : LASXPat <(extract_subvector v32i8:$vec, (i32 0)),
               (v16i8 (EXTRACT_SUBREG v32i8:$vec, sub_128))>;



def : LASXPat <(extract_subvector v4f64:$vec, (i64 0)),
               (v2f64 (EXTRACT_SUBREG v4f64:$vec, sub_128))>;

def : LASXPat <(extract_subvector v8f32:$vec, (i64 0)),
               (v4f32 (EXTRACT_SUBREG v8f32:$vec, sub_128))>;

def : LASXPat <(extract_subvector v4i64:$vec, (i64 0)),
               (v2i64 (EXTRACT_SUBREG v4i64:$vec, sub_128))>;

def : LASXPat <(extract_subvector v8i32:$vec, (i64 0)),
               (v4i32 (EXTRACT_SUBREG v8i32:$vec, sub_128))>;

def : LASXPat <(extract_subvector v16i16:$vec, (i64 0)),
               (v8i16 (EXTRACT_SUBREG v16i16:$vec, sub_128))>;

def : LASXPat <(extract_subvector v32i8:$vec, (i64 0)),
               (v16i8 (EXTRACT_SUBREG v32i8:$vec, sub_128))>;


def : LASXPat <(extract_subvector v4i64:$vec, (i32 2)),
               (v2i64 (EXTRACT_SUBREG (v4i64 (XVPERMI_QD v4i64:$vec, v4i64:$vec, (i32 1))), sub_128))>;

def : LASXPat <(extract_subvector v8i32:$vec, (i32 4)),
               (v4i32 (EXTRACT_SUBREG (v8i32 (XVPERMI_QW v8i32:$vec, v8i32:$vec, (i32 1))), sub_128))>;

def : LASXPat <(extract_subvector v16i16:$vec, (i32 8)),
               (v8i16 (EXTRACT_SUBREG (v16i16 (XVPERMI_QH v16i16:$vec, v16i16:$vec, (i32 1))), sub_128))>;

def : LASXPat <(extract_subvector v32i8:$vec, (i32 16)),
               (v16i8 (EXTRACT_SUBREG (v32i8 (XVPERMI_Q v32i8:$vec, v32i8:$vec, (i32 1))), sub_128))>;


def : LASXPat <(extract_subvector v4i64:$vec, (i64 2)),
               (v2i64 (EXTRACT_SUBREG (v4i64 (XVPERMI_QD v4i64:$vec, v4i64:$vec, (i32 1))), sub_128))>;

def : LASXPat <(extract_subvector v8i32:$vec, (i64 4)),
               (v4i32 (EXTRACT_SUBREG (v8i32 (XVPERMI_QW v8i32:$vec, v8i32:$vec, (i32 1))), sub_128))>;

def : LASXPat <(extract_subvector v16i16:$vec, (i64 8)),
               (v8i16 (EXTRACT_SUBREG (v16i16 (XVPERMI_QH v16i16:$vec, v16i16:$vec, (i32 1))), sub_128))>;

def : LASXPat <(extract_subvector v32i8:$vec, (i64 16)),
               (v16i8 (EXTRACT_SUBREG (v32i8 (XVPERMI_Q v32i8:$vec, v32i8:$vec, (i32 1))), sub_128))>;


def : LASXPat<(abs v4i64:$v),
              (XVMAX_D v4i64:$v, (XVNEG_D v4i64:$v))>;

def : LASXPat<(abs v8i32:$v),
              (XVMAX_W v8i32:$v, (XVNEG_W v8i32:$v))>;

def : LASXPat<(abs v16i16:$v),
              (XVMAX_H v16i16:$v, (XVNEG_H v16i16:$v))>;

def : LASXPat<(abs v32i8:$v),
              (XVMAX_B v32i8:$v, (XVNEG_B v32i8:$v))>;


def : LASXPat<(sub (v32i8 immAllZerosV), v32i8:$v),
              (XVNEG_B v32i8:$v)>;

def : LASXPat<(sub (v16i16 immAllZerosV), v16i16:$v),
              (XVNEG_H v16i16:$v)>;

def : LASXPat<(sub (v8i32 immAllZerosV), v8i32:$v),
              (XVNEG_W v8i32:$v)>;

def : LASXPat<(sub (v4i64 immAllZerosV), v4i64:$v),
              (XVNEG_D v4i64:$v)>;



def : LASXPat<(insert_subvector undef, (v2i64 LSX128D:$src), (i32 0)),
              (INSERT_SUBREG (v4i64 (IMPLICIT_DEF)), LSX128D:$src, sub_128)>;

def : LASXPat<(insert_subvector undef, (v4i32 LSX128W:$src), (i32 0)),
              (INSERT_SUBREG (v8i32 (IMPLICIT_DEF)), LSX128W:$src, sub_128)>;

def : LASXPat<(insert_subvector undef, (v8i16 LSX128H:$src), (i32 0)),
              (INSERT_SUBREG (v16i16 (IMPLICIT_DEF)), LSX128H:$src, sub_128)>;

def : LASXPat<(insert_subvector undef, (v16i8 LSX128B:$src), (i32 0)),
              (INSERT_SUBREG (v32i8 (IMPLICIT_DEF)), LSX128B:$src, sub_128)>;


def : LASXPat<(insert_subvector undef, (v2i64 LSX128D:$src), (i64 0)),
              (INSERT_SUBREG (v4i64 (IMPLICIT_DEF)), LSX128D:$src, sub_128)>;

def : LASXPat<(insert_subvector undef, (v4i32 LSX128W:$src), (i64 0)),
              (INSERT_SUBREG (v8i32 (IMPLICIT_DEF)), LSX128W:$src, sub_128)>;

def : LASXPat<(insert_subvector undef, (v8i16 LSX128H:$src), (i64 0)),
              (INSERT_SUBREG (v16i16 (IMPLICIT_DEF)), LSX128H:$src, sub_128)>;

def : LASXPat<(insert_subvector undef, (v16i8 LSX128B:$src), (i64 0)),
              (INSERT_SUBREG (v32i8 (IMPLICIT_DEF)), LSX128B:$src, sub_128)>;


def : LASXPat<(insert_subvector
                (v4i64 immAllZerosV), (v2i64 LSX128D:$src), (i32 0)),
              (INSERT_SUBREG (v4i64 (IMPLICIT_DEF)), LSX128D:$src, sub_128)>;

def : LASXPat<(insert_subvector
                (v8i32 immAllZerosV), (v4i32 LSX128W:$src), (i32 0)),
              (INSERT_SUBREG (v8i32 (IMPLICIT_DEF)), LSX128W:$src, sub_128)>;

def : LASXPat<(insert_subvector
                (v16i16 immAllZerosV), (v8i16 LSX128H:$src), (i32 0)),
              (INSERT_SUBREG (v16i16 (IMPLICIT_DEF)), LSX128H:$src, sub_128)>;

def : LASXPat<(insert_subvector
                (v32i8 immAllZerosV), (v16i8 LSX128B:$src), (i32 0)),
              (INSERT_SUBREG (v32i8 (IMPLICIT_DEF)), LSX128B:$src, sub_128)>;

def : LASXPat<(insert_subvector
                (v4i64 immAllZerosV), (v2i64 LSX128D:$src), (i64 0)),
              (INSERT_SUBREG (v4i64 (IMPLICIT_DEF)), LSX128D:$src, sub_128)>;

def : LASXPat<(insert_subvector
                (v8i32 immAllZerosV), (v4i32 LSX128W:$src), (i64 0)),
              (INSERT_SUBREG (v8i32 (IMPLICIT_DEF)), LSX128W:$src, sub_128)>;

def : LASXPat<(insert_subvector
                (v16i16 immAllZerosV), (v8i16 LSX128H:$src), (i64 0)),
              (INSERT_SUBREG (v16i16 (IMPLICIT_DEF)), LSX128H:$src, sub_128)>;

def : LASXPat<(insert_subvector
                (v32i8 immAllZerosV), (v16i8 LSX128B:$src), (i64 0)),
              (INSERT_SUBREG (v32i8 (IMPLICIT_DEF)), LSX128B:$src, sub_128)>;


def : LASXPat<(insert_subvector
                (v4i64 immAllZerosV), (v2i64 LSX128D:$src), (i32 2)),
              (XVPERMI_QD (v4i64 (XVREPLGR2VR_D ZERO_64)),
                (v4i64 (INSERT_SUBREG (v4i64 (IMPLICIT_DEF)),
                 LSX128D:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector (v8i32 immAllZerosV),
                (v4i32 LSX128W:$src), (i32 4)),
              (XVPERMI_QW (v8i32 (XVREPLGR2VR_W ZERO)),
                (v8i32 (INSERT_SUBREG (v8i32 (IMPLICIT_DEF)),
                LSX128W:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector
                (v16i16 immAllZerosV), (v8i16 LSX128H:$src), (i32 8)),
              (XVPERMI_QH (v16i16 (XVREPLGR2VR_H ZERO)),
                (v16i16 (INSERT_SUBREG (v16i16 (IMPLICIT_DEF)),
                LSX128H:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector
               (v32i8 immAllZerosV), (v16i8 LSX128B:$src), (i32 16)),
             (XVPERMI_Q (v32i8 (XVREPLGR2VR_B ZERO)),
               (v32i8 (INSERT_SUBREG (v32i8 (IMPLICIT_DEF)),
               LSX128B:$src, sub_128)), (i32 32))>;


def : LASXPat<(insert_subvector
                (v4i64 immAllZerosV), (v2i64 LSX128D:$src), (i64 2)),
              (XVPERMI_QD (v4i64 (XVREPLGR2VR_D ZERO_64)),
                (v4i64 (INSERT_SUBREG (v4i64 (IMPLICIT_DEF)),
                LSX128D:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector
                (v8i32 immAllZerosV), (v4i32 LSX128W:$src), (i64 4)),
              (XVPERMI_QW (v8i32 (XVREPLGR2VR_W ZERO)),
                (v8i32 (INSERT_SUBREG (v8i32 (IMPLICIT_DEF)),
                LSX128W:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector
                (v16i16 immAllZerosV), (v8i16 LSX128H:$src), (i64 8)),
              (XVPERMI_QH (v16i16 (XVREPLGR2VR_H ZERO)),
                (v16i16 (INSERT_SUBREG (v16i16 (IMPLICIT_DEF)),
                LSX128H:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector
                (v32i8 immAllZerosV), (v16i8 LSX128B:$src), (i64 16)),
              (XVPERMI_Q (v32i8 (XVREPLGR2VR_B ZERO)),
                (v32i8 (INSERT_SUBREG (v32i8 (IMPLICIT_DEF)),
                LSX128B:$src, sub_128)), (i32 32))>;


def : LASXPat<(insert_subvector undef, (v2i64 LSX128D:$src), (i32 2)),
              (XVPERMI_QD (v4i64 (IMPLICIT_DEF)),
                (v4i64 (INSERT_SUBREG (v4i64 (IMPLICIT_DEF)),
                LSX128D:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector undef, (v4i32 LSX128W:$src), (i32 4)),
              (XVPERMI_QW (v8i32 (IMPLICIT_DEF)),
                (v8i32 (INSERT_SUBREG (v8i32 (IMPLICIT_DEF)),
                LSX128W:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector undef, (v8i16 LSX128H:$src), (i32 8)),
              (XVPERMI_QH (v16i16 (IMPLICIT_DEF)),
                (v16i16 (INSERT_SUBREG (v16i16 (IMPLICIT_DEF)),
                LSX128H:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector undef, (v16i8 LSX128B:$src), (i32 16)),
              (XVPERMI_Q (v32i8 (IMPLICIT_DEF)),
                (v32i8 (INSERT_SUBREG (v32i8 (IMPLICIT_DEF)),
                LSX128B:$src, sub_128)), (i32 32))>;


def : LASXPat<(insert_subvector undef, (v2i64 LSX128D:$src), (i64 2)),
              (XVPERMI_QD (v4i64 (IMPLICIT_DEF)),
                (v4i64 (INSERT_SUBREG (v4i64 (IMPLICIT_DEF)),
                LSX128D:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector undef, (v4i32 LSX128W:$src), (i64 4)),
              (XVPERMI_QW (v8i32 (IMPLICIT_DEF)),
                (v8i32 (INSERT_SUBREG (v8i32 (IMPLICIT_DEF)),
                LSX128W:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector undef, (v8i16 LSX128H:$src), (i64 8)),
              (XVPERMI_QH (v16i16 (IMPLICIT_DEF)),
                (v16i16 (INSERT_SUBREG (v16i16 (IMPLICIT_DEF)),
                LSX128H:$src, sub_128)), (i32 32))>;

def : LASXPat<(insert_subvector undef, (v16i8 LSX128B:$src), (i64 16)),
              (XVPERMI_Q (v32i8 (IMPLICIT_DEF)),
                (v32i8 (INSERT_SUBREG (v32i8 (IMPLICIT_DEF)),
                LSX128B:$src, sub_128)), (i32 32))>;


def : LASXPat<(sra
              (v32i8 (add
                      (v32i8 (add LASX256B:$a, LASX256B:$b)),
                      (v32i8 (srl
                             (v32i8 (add LASX256B:$a, LASX256B:$b)),
                             (v32i8 (build_vector (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7))
                             )
                         )
                   )
                   )
              ),
            (v32i8 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1)
            ))),
            (XVAVG_B  (v32i8 LASX256B:$a), (v32i8 LASX256B:$b))>;

def : LASXPat<(sra
              (v16i16 (add
                      (v16i16 (add LASX256H:$a, LASX256H:$b)),
                      (v16i16 (srl
                             (v16i16 (add LASX256H:$a, LASX256H:$b)),
                             (v16i16 (build_vector (i32 15),(i32 15),(i32 15),(i32 15),
                                                  (i32 15),(i32 15),(i32 15),(i32 15),
                                                  (i32 15),(i32 15),(i32 15),(i32 15),
                                                  (i32 15),(i32 15),(i32 15),(i32 15))
                             )
                         )
                   )
                   )
              ),
            (v16i16 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1)
            ))),
            (XVAVG_H  (v16i16 LASX256H:$a), (v16i16 LASX256H:$b))>;

def : LASXPat<(sra
              (v8i32 (add
                      (v8i32 (add LASX256W:$a, LASX256W:$b)),
                      (v8i32 (srl
                             (v8i32 (add LASX256W:$a, LASX256W:$b)),
                             (v8i32 (build_vector (i32 31),(i32 31),(i32 31),(i32 31),
                                                  (i32 31),(i32 31),(i32 31),(i32 31))
                             )
                         )
                   )
                   )
              ),
            (v8i32 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1)
            ))),
            (XVAVG_W  (v8i32 LASX256W:$a), (v8i32 LASX256W:$b))>;

def : LASXPat<(sra
              (v4i64 (add
                      (v4i64 (add LASX256D:$a, LASX256D:$b)),
                      (v4i64 (srl
                                (v4i64 (add LASX256D:$a, LASX256D:$b)),
                                (v4i64 (build_vector (i64 63),(i64 63),(i64 63),(i64 63)))
                            )
                      )
                      )
                  ),
              (v4i64 (build_vector (i64 1),(i64 1),(i64 1),(i64 1)))),
              (XVAVG_D  (v4i64 LASX256D:$a), (v4i64 LASX256D:$b))>;



def : LASXPat<(srl
               (v32i8 (add LASX256B:$a, LASX256B:$b)),
               (v32i8 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1))
                           )
               ),
             (XVAVG_BU  (v32i8 LASX256B:$a), (v32i8 LASX256B:$b))>;

def : LASXPat<(srl
               (v16i16 (add LASX256H:$a, LASX256H:$b)),
               (v16i16 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                     (i32 1),(i32 1),(i32 1),(i32 1),
                                     (i32 1),(i32 1),(i32 1),(i32 1),
                                     (i32 1),(i32 1),(i32 1),(i32 1))
                           )
                 ),
              (XVAVG_HU  (v16i16 LASX256H:$a), (v16i16 LASX256H:$b))>;

def : LASXPat<(srl
               (v8i32 (add LASX256W:$a, LASX256W:$b)),
               (v8i32 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1))
                           )
                ),
              (XVAVG_WU  (v8i32 LASX256W:$a), (v8i32 LASX256W:$b))>;

def : LASXPat<(srl
               (v4i64 (add LASX256D:$a, LASX256D:$b)),
               (v4i64 (build_vector (i64 1),(i64 1),(i64 1),(i64 1))
                           )
                ),
              (XVAVG_DU  (v4i64 LASX256D:$a), (v4i64 LASX256D:$b))>;



def : LASXPat<(sra
              (v32i8 (add
                      (v32i8 (add (v32i8 (
                      build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                   (i32 1),(i32 1),(i32 1),(i32 1),
                                   (i32 1),(i32 1),(i32 1),(i32 1),
                                   (i32 1),(i32 1),(i32 1),(i32 1),
                                   (i32 1),(i32 1),(i32 1),(i32 1),
                                   (i32 1),(i32 1),(i32 1),(i32 1),
                                   (i32 1),(i32 1),(i32 1),(i32 1),
                                   (i32 1),(i32 1),(i32 1),(i32 1)
                      )),
                      (v32i8 (add LASX256B:$a, LASX256B:$b))
                      )),
                      (v32i8 (srl
                             (v32i8 ( add (v32i8(
                               build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                            (i32 1),(i32 1),(i32 1),(i32 1),
                                            (i32 1),(i32 1),(i32 1),(i32 1),
                                            (i32 1),(i32 1),(i32 1),(i32 1),
                                            (i32 1),(i32 1),(i32 1),(i32 1),
                                            (i32 1),(i32 1),(i32 1),(i32 1),
                                            (i32 1),(i32 1),(i32 1),(i32 1),
                                            (i32 1),(i32 1),(i32 1),(i32 1)
                             )),
                             (v32i8 (add LASX256B:$a, LASX256B:$b))
                             )),
                             (v32i8 (build_vector (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7),
                                                  (i32 7),(i32 7),(i32 7),(i32 7))
                             )
                         )
                   )
                   )
              ),
            (v32i8 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1)
            ))),
            (XVAVGR_B  (v32i8 LASX256B:$a), (v32i8 LASX256B:$b))>;


def : LASXPat<(sra
              (v16i16 (add
                      (v16i16 (add (v16i16 (
                         build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                      (i32 1),(i32 1),(i32 1),(i32 1),
                                      (i32 1),(i32 1),(i32 1),(i32 1),
                                      (i32 1),(i32 1),(i32 1),(i32 1)
                      )),
                      (v16i16 (add LASX256H:$a, LASX256H:$b))
                      )),
                      (v16i16 (srl
                         (v16i16 (add (v16i16 (
                            build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                         (i32 1),(i32 1),(i32 1),(i32 1),
                                         (i32 1),(i32 1),(i32 1),(i32 1),
                                         (i32 1),(i32 1),(i32 1),(i32 1)
                         )),
                         (v16i16 (add LASX256H:$a, LASX256H:$b))
                         )),
                             (v16i16 (build_vector
                                  (i32 15),(i32 15),(i32 15),(i32 15),
                                  (i32 15),(i32 15),(i32 15),(i32 15),
                                  (i32 15),(i32 15),(i32 15),(i32 15),
                                  (i32 15),(i32 15),(i32 15),(i32 15))
                             )
                         )
                   )
                   )
              ),
            (v16i16 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                  (i32 1),(i32 1),(i32 1),(i32 1),
                                  (i32 1),(i32 1),(i32 1),(i32 1),
                                  (i32 1),(i32 1),(i32 1),(i32 1)
            ))),
            (XVAVGR_H  (v16i16 LASX256H:$a), (v16i16 LASX256H:$b))>;


def : LASXPat<(sra
              (v8i32 (add
                        (v8i32 (add (v8i32 (
                           build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                        (i32 1),(i32 1),(i32 1),(i32 1)
                        )),
                        (v8i32 (add LASX256W:$a, LASX256W:$b))
                        )),
                      (v8i32 (srl
                          (v8i32 (add (v8i32 (
                             build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                          (i32 1),(i32 1),(i32 1),(i32 1)
                          )),
                          (v8i32 (add LASX256W:$a, LASX256W:$b))
                          )),
                             (v8i32 (build_vector
                                     (i32 31),(i32 31),(i32 31),(i32 31),
                                     (i32 31),(i32 31),(i32 31),(i32 31)
                                     )
                             )
                         )
                   )
                   )
              ),
            (v8i32 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                 (i32 1),(i32 1),(i32 1),(i32 1)))),
            (XVAVGR_W  (v8i32 LASX256W:$a), (v8i32 LASX256W:$b))>;

def : LASXPat<(sra
              (v4i64 (add
                         (v4i64 (add (v4i64 (
                            build_vector (i64 1),(i64 1),(i64 1),(i64 1)
                         )),
                         (v4i64 (add LASX256D:$a, LASX256D:$b))
                         )),
                      (v4i64 (srl
                         (v4i64 (add (v4i64 (
                            build_vector (i64 1),(i64 1),(i64 1),(i64 1)
                         )),
                         (v4i64 (add LASX256D:$a, LASX256D:$b))
                         )),
                                (v4i64 (build_vector
                                    (i64 63),(i64 63),(i64 63),(i64 63)))
                                )
                          )
                          )
                  ),
              (v4i64 (build_vector (i64 1),(i64 1),(i64 1),(i64 1)))),
              (XVAVGR_D  (v4i64 LASX256D:$a), (v4i64 LASX256D:$b))>;



def : LASXPat<(srl
                (v32i8 (add (v32i8 (
                build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                             (i32 1),(i32 1),(i32 1),(i32 1),
                             (i32 1),(i32 1),(i32 1),(i32 1),
                             (i32 1),(i32 1),(i32 1),(i32 1),
                             (i32 1),(i32 1),(i32 1),(i32 1),
                             (i32 1),(i32 1),(i32 1),(i32 1),
                             (i32 1),(i32 1),(i32 1),(i32 1),
                             (i32 1),(i32 1),(i32 1),(i32 1)
                )),
                (v32i8 (add LASX256B:$a, LASX256B:$b))
                )),
               (v32i8 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1))
                           )
                ),
              (XVAVGR_BU  (v32i8 LASX256B:$a), (v32i8 LASX256B:$b))>;

def : LASXPat<(srl
               (v16i16 (add (v16i16 (
                  build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1)
               )),
               (v16i16 (add LASX256H:$a, LASX256H:$b))
               )),
               (v16i16 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                     (i32 1),(i32 1),(i32 1),(i32 1),
                                     (i32 1),(i32 1),(i32 1),(i32 1),
                                     (i32 1),(i32 1),(i32 1),(i32 1))
                           )
               ),
             (XVAVGR_HU  (v16i16 LASX256H:$a), (v16i16 LASX256H:$b))>;

def : LASXPat<(srl
               (v8i32 (add (v8i32 (
                  build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1)
               )),
               (v8i32 (add LASX256W:$a, LASX256W:$b))
               )),
               (v8i32 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1))
                           )
               ),
             (XVAVGR_WU  (v8i32 LASX256W:$a), (v8i32 LASX256W:$b))>;

def : LASXPat<(srl
               (v4i64 (add (v4i64 (
                  build_vector (i64 1),(i64 1),(i64 1),(i64 1)
               )),
               (v4i64 (add LASX256D:$a, LASX256D:$b))
               )),
               (v4i64 (build_vector (i64 1),(i64 1),(i64 1),(i64 1))
                           )
                ),
             (XVAVGR_DU  (v4i64 LASX256D:$a), (v4i64 LASX256D:$b))>;


def : LASXPat<(mulhs LASX256D:$a, LASX256D:$b),
              (XVMUH_D LASX256D:$a, LASX256D:$b)>;

def : LASXPat<(mulhs LASX256W:$a, LASX256W:$b),
              (XVMUH_W LASX256W:$a, LASX256W:$b)>;

def : LASXPat<(mulhs LASX256H:$a, LASX256H:$b),
              (XVMUH_H LASX256H:$a, LASX256H:$b)>;

def : LASXPat<(mulhs LASX256B:$a, LASX256B:$b),
              (XVMUH_B LASX256B:$a, LASX256B:$b)>;


def : LASXPat<(mulhu LASX256D:$a, LASX256D:$b),
              (XVMUH_DU LASX256D:$a, LASX256D:$b)>;

def : LASXPat<(mulhu LASX256W:$a, LASX256W:$b),
              (XVMUH_WU LASX256W:$a, LASX256W:$b)>;

def : LASXPat<(mulhu LASX256H:$a, LASX256H:$b),
              (XVMUH_HU LASX256H:$a, LASX256H:$b)>;

def : LASXPat<(mulhu LASX256B:$a, LASX256B:$b),
              (XVMUH_BU LASX256B:$a, LASX256B:$b)>;


def : LASXPat<(LoongArchINSVE  (v8i32 LASX256W:$a), (v8i32 LASX256W:$b), uimm3:$ui3),
              (XVINSVE0_W  LASX256W:$a, LASX256W:$b, uimm3:$ui3)>;

def : LASXPat<(LoongArchINSVE  (v4i64 LASX256D:$a), (v4i64 LASX256D:$b), uimm2:$ui2),
              (XVINSVE0_D  LASX256D:$a, LASX256D:$b, uimm2:$ui2)>;


def : LASXPat<(LoongArchXVPICKVE  (v8i32 (bitconvert (v32i8 (build_vector
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0)
                              )))), (v8i32 LASX256W:$b), uimm3:$ui3),
              (XVPICKVE_W  (v8i32 (IMPLICIT_DEF)), LASX256W:$b, uimm3:$ui3)>;

def : LASXPat<(LoongArchXVPICKVE  (v4i64 (bitconvert (v32i8 (build_vector
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0)
                              )))), (v4i64 LASX256D:$b), uimm2:$ui2),
             (XVPICKVE_D  (v4i64 (IMPLICIT_DEF)), LASX256D:$b, uimm2:$ui2)>;


def : LASXPat<(LoongArchXVPICKVE  (v8i32 (build_vector
                              (i32 0),(i32 0),(i32 0),(i32 0),
                              (i32 0),(i32 0),(i32 0),(i32 0)
                              )), (v8i32 LASX256W:$b), uimm3:$ui3),
              (XVPICKVE_W  (v8i32 (IMPLICIT_DEF)), LASX256W:$b, uimm3:$ui3)>;

def : LASXPat<(LoongArchXVPICKVE  (v4i64 (build_vector
                              (i64 0),(i64 0),(i64 0),(i64 0)
                              )), (v4i64 LASX256D:$b), uimm2:$ui2),
              (XVPICKVE_D  (v4i64 (IMPLICIT_DEF)), LASX256D:$b, uimm2:$ui2)>;


def : LASXPat<(LoongArchXVPICKVE  (v8i32 LASX256W:$a), (v8i32 LASX256W:$b), uimm3:$ui3),
              (XVPICKVE_W  LASX256W:$a, LASX256W:$b, uimm3:$ui3)>;

def : LASXPat<(LoongArchXVPICKVE  (v4i64 LASX256D:$a), (v4i64 LASX256D:$b), uimm2:$ui2),
              (XVPICKVE_D  LASX256D:$a, LASX256D:$b, uimm2:$ui2)>;


def : LASXPat<(LoongArchXVSHUF4I  (v4i64 LASX256D:$a), (v4i64 LASX256D:$b), uimm8_32:$ui8),
              (XVSHUF4I_D  LASX256D:$a, LASX256D:$b, uimm8_32:$ui8)>;

def : LASXPat<(LoongArchXVPERMI  (v4i64 LASX256D:$a), uimm8_32:$ui8),
              (XVPERMI_D  LASX256D:$a, uimm8_32:$ui8)>;




//===----------------------------------------------------------------------===//
// Intrinsics
//===----------------------------------------------------------------------===//

def : LASXPat<(int_loongarch_lasx_xvfcmp_cor_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFCMP_COR_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfcmp_cor_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFCMP_COR_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfcmp_cun_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFCMP_CUN_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfcmp_cun_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFCMP_CUN_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfcmp_cune_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFCMP_CUNE_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfcmp_cune_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFCMP_CUNE_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfcmp_cueq_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFCMP_CUEQ_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfcmp_cueq_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFCMP_CUEQ_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfcmp_ceq_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFCMP_CEQ_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfcmp_ceq_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFCMP_CEQ_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfcmp_cne_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFCMP_CNE_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfcmp_cne_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFCMP_CNE_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfcmp_clt_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFCMP_CLT_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfcmp_clt_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFCMP_CLT_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfcmp_cult_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFCMP_CULT_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfcmp_cult_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFCMP_CULT_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfcmp_cle_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFCMP_CLE_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfcmp_cle_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFCMP_CLE_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfcmp_cule_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFCMP_CULE_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfcmp_cule_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFCMP_CULE_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvseq_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSEQ_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvseq_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSEQ_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvseq_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSEQ_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvseq_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSEQ_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvsle_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSLE_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsle_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSLE_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsle_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSLE_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsle_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSLE_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvsle_bu (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSLE_BU LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsle_hu (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSLE_HU LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsle_wu (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSLE_WU LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsle_du (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSLE_DU LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvslt_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSLT_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvslt_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSLT_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvslt_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSLT_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvslt_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSLT_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvslt_bu (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSLT_BU LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvslt_hu (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSLT_HU LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvslt_wu (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSLT_WU LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvslt_du (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSLT_DU LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvadd_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVADD_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvadd_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVADD_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvadd_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVADD_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvadd_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVADD_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvsub_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSUB_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsub_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSUB_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsub_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSUB_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsub_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSUB_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvmax_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVMAX_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmax_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVMAX_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmax_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVMAX_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmax_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVMAX_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvmin_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVMIN_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmin_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVMIN_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmin_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVMIN_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmin_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVMIN_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvmin_bu (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVMIN_BU LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmin_hu (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVMIN_HU LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmin_wu (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVMIN_WU LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmin_du (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVMIN_DU LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvmul_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVMUL_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmul_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVMUL_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmul_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVMUL_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmul_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVMUL_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvdiv_bu (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVDIV_BU LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvdiv_hu (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVDIV_HU LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvdiv_wu (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVDIV_WU LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvdiv_du (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVDIV_DU LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvsll_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSLL_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsll_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSLL_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsll_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSLL_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsll_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSLL_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvsrl_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSRL_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsrl_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSRL_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsrl_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSRL_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsrl_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSRL_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvsra_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSRA_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsra_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSRA_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsra_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSRA_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsra_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSRA_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfadd_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFADD_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfadd_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFADD_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfsub_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFSUB_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfsub_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFSUB_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfmul_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFMUL_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfmul_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFMUL_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfdiv_s (v8f32 LASX256W:$xj), (v8f32 LASX256W:$xk)),
              (XVFDIV_S LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvfdiv_d (v4f64 LASX256D:$xj), (v4f64 LASX256D:$xk)),
              (XVFDIV_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfsqrt_s (v8f32 LASX256W:$xj)),
              (XVFSQRT_S LASX256W:$xj)>;
def : LASXPat<(int_loongarch_lasx_xvfsqrt_d (v4f64 LASX256D:$xj)),
              (XVFSQRT_D LASX256D:$xj)>;

def : LASXPat<(v8f32 (int_loongarch_lasx_xvffint_s_w (v8i32 LASX256W:$xj))),
              (XVFFINT_S_W (v8i32 LASX256W:$xj))>;
def : LASXPat<(v8f32 (int_loongarch_lasx_xvffint_s_wu (v8i32 LASX256W:$xj))),
              (XVFFINT_S_WU (v8i32 LASX256W:$xj))>;

def : LASXPat<(v4f64 (int_loongarch_lasx_xvffint_d_l (v4i64 LASX256D:$xj))),
              (XVFFINT_D_L (v4i64 LASX256D:$xj))>;
def : LASXPat<(v4f64 (int_loongarch_lasx_xvffint_d_lu (v4i64 LASX256D:$xj))),
              (XVFFINT_D_LU (v4i64 LASX256D:$xj))>;

def : LASXPat<(int_loongarch_lasx_xvreplgr2vr_b GPR32Opnd:$rj),
              (XVREPLGR2VR_B GPR32Opnd:$rj)>;
def : LASXPat<(int_loongarch_lasx_xvreplgr2vr_h GPR32Opnd:$rj),
              (XVREPLGR2VR_H GPR32Opnd:$rj)>;
def : LASXPat<(int_loongarch_lasx_xvreplgr2vr_w GPR32Opnd:$rj),
              (XVREPLGR2VR_W GPR32Opnd:$rj)>;
def : LASXPat<(int_loongarch_lasx_xvreplgr2vr_d GPR64Opnd:$rj),
              (XVREPLGR2VR_D GPR64Opnd:$rj)>;

def : LASXPat<(int_loongarch_lasx_xvpickve2gr_w (v8i32 LASX256W:$xj), (immZExt3:$ui3)),
              (XVPICKVE2GR_W LASX256W:$xj, uimm3:$ui3)>;
def : LASXPat<(int_loongarch_lasx_xvpickve2gr_d (v4i64 LASX256D:$xj), (immZExt2:$ui2)),
              (XVPICKVE2GR_D LASX256D:$xj, uimm2:$ui2)>;

def : LASXPat<(int_loongarch_lasx_xvpickve2gr_wu (v8i32 LASX256W:$xj), (immZExt3:$ui3)),
              (XVPICKVE2GR_WU LASX256W:$xj, uimm3:$ui3)>;
def : LASXPat<(int_loongarch_lasx_xvpickve2gr_du (v4i64 LASX256D:$xj), (immZExt2:$ui2)),
              (XVPICKVE2GR_DU LASX256D:$xj, uimm2:$ui2)>;

def : LASXPat<(int_loongarch_lasx_xvreplve0_d (v4i64 LASX256D:$xj)),
              (XVREPLVE0_D (v4i64 LASX256D:$xj))>;

def : LASXPat<(int_loongarch_lasx_xvinsgr2vr_w (v8i32 LASX256W:$xj), GPR32Opnd:$rj, (immZExt3:$ui3)),
              (XVINSGR2VR_W LASX256W:$xj, GPR32Opnd:$rj, uimm3:$ui3)>;
def : LASXPat<(int_loongarch_lasx_xvinsgr2vr_d (v4i64 LASX256D:$xj), GPR64Opnd:$rj, (immZExt2:$ui2)),
              (XVINSGR2VR_D LASX256D:$xj, GPR64Opnd:$rj, uimm2:$ui2)>;

def : LASXPat<(int_loongarch_lasx_xvpickve_w (v8i32 LASX256W:$xj), (immZExt3:$ui3)),
              (XVPICKVE_W (v8i32 (IMPLICIT_DEF)), LASX256W:$xj, uimm3:$ui3)>;
def : LASXPat<(int_loongarch_lasx_xvpickve_d (v4i64 LASX256D:$xj), (immZExt2:$ui2)),
              (XVPICKVE_D (v4i64 (IMPLICIT_DEF)), LASX256D:$xj, uimm2:$ui2)>;

def : LASXPat<(int_loongarch_lasx_xvpickve_w_f (v8f32 LASX256W:$xj), (immZExt3:$ui3)),
              (XVPICKVE_W (v8f32 (IMPLICIT_DEF)), LASX256W:$xj, uimm3:$ui3)>;
def : LASXPat<(int_loongarch_lasx_xvpickve_d_f (v4f64 LASX256D:$xj), (immZExt2:$ui2)),
              (XVPICKVE_D (v4f64 (IMPLICIT_DEF)), LASX256D:$xj, uimm2:$ui2)>;

def : LASXPat<(int_loongarch_lasx_xvdiv_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVDIV_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvdiv_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVDIV_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvdiv_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVDIV_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvdiv_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVDIV_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvmod_bu (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVMOD_BU LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmod_hu (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVMOD_HU LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmod_wu (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVMOD_WU LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmod_du (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVMOD_DU LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvmod_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVMOD_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmod_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVMOD_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmod_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVMOD_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmod_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVMOD_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvmax_bu (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVMAX_BU LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmax_hu (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVMAX_HU LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmax_wu (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVMAX_WU LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmax_du (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVMAX_DU LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvfrint_s (v8f32 LASX256W:$xj)),
              (XVFRINT_S LASX256W:$xj)>;
def : LASXPat<(int_loongarch_lasx_xvfrint_d (v4f64 LASX256D:$xj)),
              (XVFRINT_D LASX256D:$xj)>;

def : LASXPat<(int_loongarch_lasx_xvpackod_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVPACKOD_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpackod_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVPACKOD_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpackod_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVPACKOD_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpackod_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVPACKOD_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvpackev_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVPACKEV_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpackev_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVPACKEV_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpackev_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVPACKEV_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpackev_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVPACKEV_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvilvh_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVILVH_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvilvh_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVILVH_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvilvh_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVILVH_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvilvh_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVILVH_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvilvl_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVILVL_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvilvl_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVILVL_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvilvl_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVILVL_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvilvl_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVILVL_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvpickev_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVPICKEV_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpickev_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVPICKEV_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpickev_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVPICKEV_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpickev_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVPICKEV_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvpickod_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVPICKOD_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpickod_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVPICKOD_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpickod_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVPICKOD_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvpickod_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVPICKOD_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvsadd_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSADD_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsadd_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSADD_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsadd_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSADD_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsadd_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSADD_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvssub_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSSUB_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvssub_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSSUB_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvssub_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSSUB_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvssub_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSSUB_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvsadd_bu (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSADD_BU LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsadd_hu (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSADD_HU LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsadd_wu (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSADD_WU LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvsadd_du (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSADD_DU LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvssub_bu (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVSSUB_BU LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvssub_hu (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVSSUB_HU LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvssub_wu (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVSSUB_WU LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvssub_du (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVSSUB_DU LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvmadd_b (v32i8 LASX256B:$xd_in), (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVMADD_B LASX256B:$xd_in, LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmadd_h (v16i16 LASX256H:$xd_in), (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVMADD_H LASX256H:$xd_in, LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmadd_w (v8i32 LASX256W:$xd_in), (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVMADD_W LASX256W:$xd_in, LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmadd_d (v4i64 LASX256D:$xd_in), (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVMADD_D LASX256D:$xd_in, LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvmsub_b (v32i8 LASX256B:$xd_in), (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVMSUB_B LASX256B:$xd_in, LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmsub_h (v16i16 LASX256H:$xd_in), (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVMSUB_H LASX256H:$xd_in, LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmsub_w (v8i32 LASX256W:$xd_in), (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVMSUB_W LASX256W:$xd_in, LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvmsub_d (v4i64 LASX256D:$xd_in), (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVMSUB_D LASX256D:$xd_in, LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(v8i32 (int_loongarch_lasx_xvftintrz_wu_s (v8f32 LASX256W:$xj))),
              (XVFTINTRZ_WU_S (v8f32 LASX256W:$xj))>;
def : LASXPat<(v4i64 (int_loongarch_lasx_xvftintrz_lu_d (v4f64 LASX256D:$xj))),
              (XVFTINTRZ_LU_D (v4f64 LASX256D:$xj))>;

def : LASXPat<(v8i32 (int_loongarch_lasx_xvftintrz_w_s (v8f32 LASX256W:$xj))),
              (XVFTINTRZ_W_S (v8f32 LASX256W:$xj))>;
def : LASXPat<(v4i64 (int_loongarch_lasx_xvftintrz_l_d (v4f64 LASX256D:$xj))),
              (XVFTINTRZ_L_D (v4f64 LASX256D:$xj))>;

def : LASXPat<(int_loongarch_lasx_xvbitclr_b (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk)),
              (XVBITCLR_B LASX256B:$xj, LASX256B:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvbitclr_h (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk)),
              (XVBITCLR_H LASX256H:$xj, LASX256H:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvbitclr_w (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk)),
              (XVBITCLR_W LASX256W:$xj, LASX256W:$xk)>;
def : LASXPat<(int_loongarch_lasx_xvbitclr_d (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk)),
              (XVBITCLR_D LASX256D:$xj, LASX256D:$xk)>;

def : LASXPat<(int_loongarch_lasx_xvclz_b (v32i8 LASX256B:$xj)),
              (XVCLZ_B LASX256B:$xj)>;
def : LASXPat<(int_loongarch_lasx_xvclz_h (v16i16 LASX256H:$xj)),
              (XVCLZ_H LASX256H:$xj)>;
def : LASXPat<(int_loongarch_lasx_xvclz_w (v8i32 LASX256W:$xj)),
              (XVCLZ_W LASX256W:$xj)>;
def : LASXPat<(int_loongarch_lasx_xvclz_d (v4i64 LASX256D:$xj)),
              (XVCLZ_D LASX256D:$xj)>;

def : LASXPat<(int_loongarch_lasx_xvpcnt_b (v32i8 LASX256B:$xj)),
              (XVPCNT_B LASX256B:$xj)>;
def : LASXPat<(int_loongarch_lasx_xvpcnt_h (v16i16 LASX256H:$xj)),
              (XVPCNT_H LASX256H:$xj)>;
def : LASXPat<(int_loongarch_lasx_xvpcnt_w (v8i32 LASX256W:$xj)),
              (XVPCNT_W LASX256W:$xj)>;
def : LASXPat<(int_loongarch_lasx_xvpcnt_d (v4i64 LASX256D:$xj)),
              (XVPCNT_D LASX256D:$xj)>;


def : LASXPat<(v32i8 (load (add iPTR:$xj, iPTR:$xk))),
              (XVLDX PtrRC:$xj, PtrRC:$xk)>;

def : LASXPat<(store (v32i8 LASX256B:$xd), (add iPTR:$xj, iPTR:$xk)),
              (XVSTX LASX256B:$xd, PtrRC:$xj, PtrRC:$xk)>;


def : LASXPat<(v4i64 (sext_invec (v8i32 LASX256W:$xj))),
              (VEXT2XV_D_W LASX256W:$xj)>;
def : LASXPat<(v8i32 (sext_invec (v16i16 LASX256H:$xj))),
              (VEXT2XV_W_H LASX256H:$xj)>;
def : LASXPat<(v16i16 (sext_invec (v32i8 LASX256B:$xj))),
              (VEXT2XV_H_B LASX256B:$xj)>;


def : LASXPat<(v4i64 (zext_invec (v8i32 LASX256W:$xj))),
              (VEXT2XV_DU_WU LASX256W:$xj)>;
def : LASXPat<(v8i32 (zext_invec (v16i16 LASX256H:$xj))),
              (VEXT2XV_WU_HU LASX256H:$xj)>;
def : LASXPat<(v16i16 (zext_invec (v32i8 LASX256B:$xj))),
              (VEXT2XV_HU_BU LASX256B:$xj)>;


def : LASXPat<(v4i64 (sext_invec (v16i16 LASX256H:$xj))),
              (VEXT2XV_D_H LASX256H:$xj)>;
def : LASXPat<(v4i64 (sext_invec (v32i8 LASX256B:$xj))),
              (VEXT2XV_D_B LASX256B:$xj)>;
def : LASXPat<(v8i32 (sext_invec (v32i8 LASX256B:$xj))),
              (VEXT2XV_W_B LASX256B:$xj)>;


def : LASXPat<(v4i64 (zext_invec (v16i16 LASX256H:$xj))),
              (VEXT2XV_DU_HU LASX256H:$xj)>;
def : LASXPat<(v4i64 (zext_invec (v32i8 LASX256B:$xj))),
              (VEXT2XV_DU_BU LASX256B:$xj)>;
def : LASXPat<(v8i32 (zext_invec (v32i8 LASX256B:$xj))),
              (VEXT2XV_WU_BU LASX256B:$xj)>;


def : LASXPat<(v4i64 (sext_invec (v16i16 LASX256H:$xj))),
              (VEXT2XV_D_H LASX256H:$xj)>;
def : LASXPat<(v4i64 (sext_invec (v32i8 LASX256B:$xj))),
              (VEXT2XV_D_B LASX256B:$xj)>;
def : LASXPat<(v8i32 (sext_invec (v32i8 LASX256B:$xj))),
              (VEXT2XV_W_B LASX256B:$xj)>;

def : LASXPat<(v4i64 (zext_invec (v16i16 LASX256H:$xj))),
              (VEXT2XV_DU_HU LASX256H:$xj)>;
def : LASXPat<(v4i64 (zext_invec (v32i8 LASX256B:$xj))),
              (VEXT2XV_DU_BU LASX256B:$xj)>;
def : LASXPat<(v8i32 (zext_invec (v32i8 LASX256B:$xj))),
              (VEXT2XV_WU_BU LASX256B:$xj)>;


def : LASXPat<(v16i16 (sext (v16i8 LSX128B:$vj))),
              (VEXT2XV_H_B
                (INSERT_SUBREG (v32i8 (IMPLICIT_DEF)), LSX128B:$vj, sub_128))>;

def : LASXPat<(v8i32 (sext (v8i16 LSX128H:$vj))),
              (VEXT2XV_W_H
                (INSERT_SUBREG (v16i16 (IMPLICIT_DEF)), LSX128H:$vj, sub_128))>;

def : LASXPat<(v4i64 (sext (v4i32 LSX128W:$vj))),
              (VEXT2XV_D_W
                (INSERT_SUBREG (v8i32 (IMPLICIT_DEF)), LSX128W:$vj, sub_128))>;

def : LASXPat<(v16i16 (zext (v16i8 LSX128B:$vj))),
              (VEXT2XV_HU_BU
                (INSERT_SUBREG (v32i8 (IMPLICIT_DEF)), LSX128B:$vj, sub_128))>;

def : LASXPat<(v8i32 (zext (v8i16 LSX128H:$vj))),
              (VEXT2XV_WU_HU
                (INSERT_SUBREG (v16i16 (IMPLICIT_DEF)), LSX128H:$vj, sub_128))>;

def : LASXPat<(v4i64 (zext (v4i32 LSX128W:$vj))),
              (VEXT2XV_DU_WU
                (INSERT_SUBREG (v8i32 (IMPLICIT_DEF)), LSX128W:$vj, sub_128))>;


def : LASXPat<(xor
                (v16i16 LASX256H:$xj), (xvsplati16 imm_mask)
              ),
              (XNOR_V_H_PSEUDO  (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xj))>;

def : LASXPat<(xor
                (v8i32 LASX256W:$xj), (xvsplati32 imm_mask)
              ),
              (XNOR_V_W_PSEUDO  (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xj))>;

def : LASXPat<(xor
               (v4i64 LASX256D:$xj), (xvsplati64 imm_mask_64)
              ),
              (XNOR_V_D_PSEUDO  (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xj))>;


def : LASXPat<(and
                (v32i8 (xor (v32i8 LASX256B:$xj), (xvsplati8 imm_mask))),
                (v32i8 LASX256B:$xk)
              ),
              (XVANDN_V (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk))>;

def : LASXPat<(and
                (v16i16 (xor (v16i16 LASX256H:$xj), (xvsplati16 imm_mask))),
                (v16i16 LASX256H:$xk)
              ),
              (XVANDN_H_PSEUDO (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk))>;

def : LASXPat<(and
                  (v8i32 (xor (v8i32 LASX256W:$xj), (xvsplati32 imm_mask))),
                  (v8i32 LASX256W:$xk)
              ),
              (XVANDN_W_PSEUDO (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk))>;

def : LASXPat<(and
                  (v4i64 (xor (v4i64 LASX256D:$xj), (xvsplati64 imm_mask_64))),
                  (v4i64 LASX256D:$xk)
              ),
              (XVANDN_D_PSEUDO (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk))>;


def : LASXPat<(or
                (v32i8 LASX256B:$xj),
                (v32i8 (xor (v32i8 LASX256B:$xk), (xvsplati8 imm_mask)))
              ),
              (XVORN_V (v32i8 LASX256B:$xj), (v32i8 LASX256B:$xk))>;

def : LASXPat<(or
                (v16i16 LASX256H:$xj),
                (v16i16 (xor (v16i16 LASX256H:$xk), (xvsplati16 imm_mask)))
              ),
              (XVORN_H_PSEUDO (v16i16 LASX256H:$xj), (v16i16 LASX256H:$xk))>;

def : LASXPat<(or
                  (v8i32 LASX256W:$xj),
                  (v8i32 (xor (v8i32 LASX256W:$xk), (xvsplati32 imm_mask)))
              ),
              (XVORN_W_PSEUDO (v8i32 LASX256W:$xj), (v8i32 LASX256W:$xk))>;

def : LASXPat<(or
                  (v4i64 LASX256D:$xj),
                  (v4i64 (xor (v4i64 LASX256D:$xk), (xvsplati64 imm_mask_64)))
              ),
              (XVORN_D_PSEUDO (v4i64 LASX256D:$xj), (v4i64 LASX256D:$xk))>;


def : LASXPat<(add (v4i64 (abs LASX256D:$a)), (v4i64 (abs LASX256D:$b))),
              (XVADDA_D (v4i64 LASX256D:$a),(v4i64 LASX256D:$b))>;

def : LASXPat<(add (v8i32 (abs LASX256W:$a)), (v8i32 (abs LASX256W:$b))),
              (XVADDA_W (v8i32 LASX256W:$a),(v8i32 LASX256W:$b))>;

def : LASXPat<(add (v16i16 (abs LASX256H:$a)), (v16i16 (abs LASX256H:$b))),
              (XVADDA_H (v16i16 LASX256H:$a),(v16i16 LASX256H:$b))>;

def : LASXPat<(add (v32i8 (abs LASX256B:$a)), (v32i8 (abs LASX256B:$b))),
              (XVADDA_B (v32i8 LASX256B:$a),(v32i8 LASX256B:$b))>;


def : LASXPat<(and v32i8:$xj, (xor (shl xvsplat_imm_eq_1, v32i8:$xk),
                                  (xvsplati8 imm_mask))),
              (XVBITCLR_B v32i8:$xj, v32i8:$xk)>;

def : LASXPat<(and v16i16:$xj, (xor (shl xvsplat_imm_eq_1, v16i16:$xk),
                                  (xvsplati16 imm_mask))),
              (XVBITCLR_H v16i16:$xj, v16i16:$xk)>;

def : LASXPat<(and v8i32:$xj, (xor (shl xvsplat_imm_eq_1, v8i32:$xk),
                                  (xvsplati32 imm_mask))),
              (XVBITCLR_W v8i32:$xj, v8i32:$xk)>;

def : LASXPat<(and v4i64:$xj, (xor (shl xvsplat_imm_eq_1, v4i64:$xk),
                                   (xvsplati64 imm_mask_64))),
              (XVBITCLR_D v4i64:$xj, v4i64:$xk)>;
