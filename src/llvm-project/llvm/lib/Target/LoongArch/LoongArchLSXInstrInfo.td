//===- LoongArchLSXInstrInfo.td - LSX instructions -*- tablegen ------------*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes LoongArch LSX instructions.
//
//===----------------------------------------------------------------------===//

def SDT_LoongArchVecCond : SDTypeProfile<1, 1, [SDTCisInt<0>, SDTCisVec<1>]>;
def SDT_VSetCC : SDTypeProfile<1, 3, [SDTCisInt<0>,
                                      SDTCisInt<1>,
                                      SDTCisSameAs<1, 2>,
                                      SDTCisVT<3, OtherVT>]>;
def SDT_VFSetCC : SDTypeProfile<1, 3, [SDTCisInt<0>,
                                       SDTCisFP<1>,
                                       SDTCisSameAs<1, 2>,
                                       SDTCisVT<3, OtherVT>]>;
def SDT_VSHF : SDTypeProfile<1, 3, [SDTCisInt<0>, SDTCisVec<0>,
                                    SDTCisInt<1>, SDTCisVec<1>,
                                    SDTCisSameAs<0, 2>, SDTCisSameAs<2, 3>]>;
def SDT_SHF : SDTypeProfile<1, 2, [SDTCisInt<0>, SDTCisVec<0>,
                                   SDTCisVT<1, i32>, SDTCisSameAs<0, 2>]>;
def SDT_ILV : SDTypeProfile<1, 2, [SDTCisInt<0>, SDTCisVec<0>,
                                   SDTCisSameAs<0, 1>, SDTCisSameAs<1, 2>]>;
def SDTVABSD : SDTypeProfile<1, 3, [SDTCisVec<0>, SDTCisSameAs<0, 1>,
                                    SDTCisSameAs<0, 2>, SDTCisVT<3, i32>]>;

def SDT_VBROADCAST : SDTypeProfile<1, 1, [SDTCisVec<0>]>;
def LoongArchVBROADCAST : SDNode<"LoongArchISD::VBROADCAST", SDT_VBROADCAST>;

def LoongArchVAllNonZero : SDNode<"LoongArchISD::VALL_NONZERO", SDT_LoongArchVecCond>;
def LoongArchVAnyNonZero : SDNode<"LoongArchISD::VANY_NONZERO", SDT_LoongArchVecCond>;
def LoongArchVAllZero : SDNode<"LoongArchISD::VALL_ZERO", SDT_LoongArchVecCond>;
def LoongArchVAnyZero : SDNode<"LoongArchISD::VANY_ZERO", SDT_LoongArchVecCond>;
def LoongArchVNOR : SDNode<"LoongArchISD::VNOR", SDTIntBinOp,
                      [SDNPCommutative, SDNPAssociative]>;
def LoongArchVSHF : SDNode<"LoongArchISD::VSHF", SDT_VSHF>;
def LoongArchSHF : SDNode<"LoongArchISD::SHF", SDT_SHF>;
def LoongArchVPACKEV : SDNode<"LoongArchISD::VPACKEV", SDT_ILV>;
def LoongArchVPACKOD : SDNode<"LoongArchISD::VPACKOD", SDT_ILV>;
def LoongArchVILVH  : SDNode<"LoongArchISD::VILVH",  SDT_ILV>;
def LoongArchVILVL  : SDNode<"LoongArchISD::VILVL",  SDT_ILV>;
def LoongArchVPICKEV : SDNode<"LoongArchISD::VPICKEV", SDT_ILV>;
def LoongArchVPICKOD : SDNode<"LoongArchISD::VPICKOD", SDT_ILV>;
def LoongArchVABSD : SDNode<"LoongArchISD::VABSD", SDTVABSD>;
def LoongArchUVABSD : SDNode<"LoongArchISD::UVABSD", SDTVABSD>;

def vsetcc : SDNode<"ISD::SETCC", SDT_VSetCC>;
def vfsetcc : SDNode<"ISD::SETCC", SDT_VFSetCC>;

def LoongArchVExtractSExt : SDNode<"LoongArchISD::VEXTRACT_SEXT_ELT",
    SDTypeProfile<1, 3, [SDTCisPtrTy<2>]>, []>;
def LoongArchVExtractZExt : SDNode<"LoongArchISD::VEXTRACT_ZEXT_ELT",
    SDTypeProfile<1, 3, [SDTCisPtrTy<2>]>, []>;

def immZExt1Ptr : ImmLeaf<iPTR, [{return isUInt<1>(Imm);}]>;
def immZExt2Ptr : ImmLeaf<iPTR, [{return isUInt<2>(Imm);}]>;
def immZExt3Ptr : ImmLeaf<iPTR, [{return isUInt<3>(Imm);}]>;
def immZExt4Ptr : ImmLeaf<iPTR, [{return isUInt<4>(Imm);}]>;
def immZExt5Ptr : ImmLeaf<iPTR, [{return isUInt<5>(Imm);}]>;
def immZExt10 : ImmLeaf<i32, [{return isUInt<10>(Imm);}]>;
def immZExt8 : ImmLeaf<i32, [{return isUInt<8>(Imm);}]>;
def immZExt7 : PatLeaf<(imm), [{ return isUInt<7>(N->getZExtValue()); }]>;
def immZExt6 : ImmLeaf<i32, [{return Imm == (Imm & 0x3f);}]>;
def immZExt4 : ImmLeaf<i32, [{return isUInt<4>(Imm);}]>;
def immZExt3 : ImmLeaf<i32, [{return isUInt<3>(Imm);}]>;
def immZExt2 : ImmLeaf<i32, [{return isUInt<2>(Imm);}]>;
def immZExt1 : ImmLeaf<i32, [{return isUInt<1>(Imm);}]>;
def immSExt12_l : ImmLeaf<i32, [{return isInt<12>(Imm);}]>;
def immSExt11Ptr : ImmLeaf<iPTR, [{return isInt<11>(Imm);}]>;

def immSExt11_1 : ImmLeaf<i32, [{return isInt<11>(Imm<<1);}]>;
def immSExt10Ptr : ImmLeaf<iPTR, [{return isInt<10>(Imm);}]>;
def immSExt10_2 : ImmLeaf<i32, [{return isInt<10>(Imm<<2);}]>;
def immSExt9Ptr : ImmLeaf<iPTR, [{return isInt<9>(Imm);}]>;
def immSExt9_3 : ImmLeaf<i32, [{return isInt<9>(Imm<<3);}]>;
def immSExt8 : ImmLeaf<i32, [{return isInt<8>(Imm);}]>;
def immSExt5 : ImmLeaf<i32, [{return isInt<5>(Imm);}]>;
def immSExt8_1 : ImmLeaf<i32, [{return isInt<8>(Imm<<1);}]>;
def immSExt8_2 : ImmLeaf<i32, [{return isInt<8>(Imm<<2);}]>;
def immSExt8_3 : ImmLeaf<i32, [{return isInt<8>(Imm<<3);}]>;

def addrimm10 : ComplexPattern<iPTR, 2, "selectIntAddrSImm10", [frameindex]>;
def addrimm10lsl2 : ComplexPattern<iPTR, 2, "selectIntAddrSImm10Lsl2",
                                   [frameindex]>;
def addrimm9lsl3 : ComplexPattern<iPTR, 2, "selectIntAddrSImm9Lsl3",
                                   [frameindex]>;
def addrimm11lsl1 : ComplexPattern<iPTR, 2, "selectIntAddrSImm11Lsl1",
                                   [frameindex]>;


class SimmLslAsmOperandClass<int Bits, list<AsmOperandClass> Supers = [],
                                  int Shift = 0> : AsmOperandClass {
  let Name = "Simm" # Bits # "_Lsl" # Shift;
  let RenderMethod = "addImmOperands";
  let PredicateMethod = "isScaledSImm<" # Bits # ", " # Shift # ">"; 
  let SuperClasses = Supers;
  let DiagnosticType = "SImm" # Bits # "_Lsl" # Shift;
}

def Simm11Lsl1AsmOperand
    : SimmLslAsmOperandClass<11, [], 1>;

def immSExt11_1_O : Operand<i32> {
    let EncoderMethod = "getSImm11Lsl1Encoding";
    let DecoderMethod = "DecodeSImmWithOffsetAndScale<2>";
    let ParserMatchClass = Simm11Lsl1AsmOperand;
}

def Simm10Lsl2AsmOperand
    : SimmLslAsmOperandClass<10, [], 2>;

def immSExt10_2_O : Operand<i32> {
    let EncoderMethod = "getSImm10Lsl2Encoding";
    let DecoderMethod = "DecodeSImmWithOffsetAndScale<4>";
    let ParserMatchClass = Simm10Lsl2AsmOperand;
}

def Simm9Lsl3AsmOperand
    : SimmLslAsmOperandClass<9, [], 3>;

def immSExt9_3_O : Operand<i32> {
    let EncoderMethod = "getSImm9Lsl3Encoding";
    let DecoderMethod = "DecodeSImmWithOffsetAndScale<8>";
    let ParserMatchClass = Simm9Lsl3AsmOperand;
}

def Simm8Lsl3AsmOperand
    : SimmLslAsmOperandClass<8, [], 3>;

def immSExt8_3_O : Operand<i32> {
    let EncoderMethod = "getSImm8Lsl3Encoding";
    let DecoderMethod = "DecodeSImmWithOffsetAndScale<8>";
    let ParserMatchClass = Simm8Lsl3AsmOperand;
}

def Simm8Lsl2AsmOperand
    : SimmLslAsmOperandClass<8, [], 2>;

def immSExt8_2_O : Operand<i32> {
    let EncoderMethod = "getSImm8Lsl2Encoding";
    let DecoderMethod = "DecodeSImmWithOffsetAndScale<4>";
    let ParserMatchClass = Simm8Lsl2AsmOperand;
}

def Simm8Lsl1AsmOperand
    : SimmLslAsmOperandClass<8, [], 1>;

def immSExt8_1_O : Operand<i32> {
    let EncoderMethod = "getSImm8Lsl1Encoding";
    let DecoderMethod = "DecodeSImmWithOffsetAndScale<2>";
    let ParserMatchClass = Simm8Lsl1AsmOperand;
}


class ConstantSImmAsmOperandClass<int Bits, list<AsmOperandClass> Supers = [],
                                  int Offset = 0> : AsmOperandClass {
  let Name = "ConstantSImm" # Bits # "_" # Offset;
  let RenderMethod = "addConstantSImmOperands<" # Bits # ", " # Offset # ">";
  let PredicateMethod = "isConstantSImm<" # Bits # ", " # Offset # ">";
  let SuperClasses = Supers;
  let DiagnosticType = "SImm" # Bits # "_" # Offset;
}

class ConstantUImmRangeAsmOperandClass<int Bottom, int Top,
                                       list<AsmOperandClass> Supers = []>
    : AsmOperandClass {
  let Name = "ConstantUImmRange" # Bottom # "_" # Top;
  let RenderMethod = "addImmOperands";
  let PredicateMethod = "isConstantUImmRange<" # Bottom # ", " # Top # ">";
  let SuperClasses = Supers;
  let DiagnosticType = "UImmRange" # Bottom # "_" # Top;
}

def SImm16RelaxedAsmOperandClass
    : SImmAsmOperandClass<16, [UImm16RelaxedAsmOperandClass]> {
  let Name = "SImm16_Relaxed";
  let PredicateMethod = "isAnyImm<16>";
  let DiagnosticType = "SImm16_Relaxed";
}

def ConstantSImm11Lsl1AsmOperandClass : AsmOperandClass {
  let Name = "SImm11Lsl1";
  let RenderMethod = "addImmOperands";
  let PredicateMethod = "isScaledSImm<11, 1>";
  let SuperClasses = [SImm12Operand];
  let DiagnosticType = "SImm11_Lsl1";
}

def ConstantSImm9Lsl3AsmOperandClass : AsmOperandClass {
  let Name = "SImm9Lsl3";
  let RenderMethod = "addImmOperands";
  let PredicateMethod = "isScaledSImm<9, 3>";
  let SuperClasses = [SImm12Operand];
  let DiagnosticType = "SImm9_Lsl3";
}

def ConstantSImm10Lsl2AsmOperandClass : AsmOperandClass {
  let Name = "SImm10Lsl2";
  let RenderMethod = "addImmOperands";
  let PredicateMethod = "isScaledSImm<10, 2>";
  let SuperClasses = [SImm12Operand];
  let DiagnosticType = "SImm10_Lsl2";
}
def ConstantSImm11AsmOperandClass
    : ConstantSImmAsmOperandClass<11, [ConstantSImm10Lsl2AsmOperandClass]>;
def ConstantSImm10Lsl1AsmOperandClass : AsmOperandClass {
  let Name = "SImm10Lsl1";
  let RenderMethod = "addImmOperands";
  let PredicateMethod = "isScaledSImm<10, 1>";
  let SuperClasses = [ConstantSImm11AsmOperandClass];
  let DiagnosticType = "SImm10_Lsl1";
}
def ConstantUImm10AsmOperandClass
    : ConstantUImmAsmOperandClass<10, [ConstantSImm10Lsl1AsmOperandClass]>;
def ConstantSImm10AsmOperandClass
    : ConstantSImmAsmOperandClass<10, [ConstantUImm10AsmOperandClass]>;
def ConstantSImm9AsmOperandClass
    : ConstantSImmAsmOperandClass<9, [ConstantSImm10AsmOperandClass]>;
def ConstantSImm7Lsl2AsmOperandClass : AsmOperandClass {
  let Name = "SImm7Lsl2";
  let RenderMethod = "addImmOperands";
  let PredicateMethod = "isScaledSImm<7, 2>";
  let SuperClasses = [ConstantSImm9AsmOperandClass];
  let DiagnosticType = "SImm7_Lsl2";
}
def ConstantUImm8AsmOperandClass
    : ConstantUImmAsmOperandClass<8, [ConstantSImm7Lsl2AsmOperandClass]>;
def ConstantUImm7Sub1AsmOperandClass
    : ConstantUImmAsmOperandClass<7, [ConstantUImm8AsmOperandClass], -1> {
  // Specify the names since the -1 offset causes invalid identifiers otherwise.
  let Name = "UImm7_N1";
  let DiagnosticType = "UImm7_N1";
}
def ConstantUImm7AsmOperandClass
    : ConstantUImmAsmOperandClass<7, [ConstantUImm7Sub1AsmOperandClass]>;
def ConstantUImm6Lsl2AsmOperandClass : AsmOperandClass {
  let Name = "UImm6Lsl2";
  let RenderMethod = "addImmOperands";
  let PredicateMethod = "isScaledUImm<6, 2>";
  let SuperClasses = [ConstantUImm7AsmOperandClass];
  let DiagnosticType = "UImm6_Lsl2";
}
def ConstantUImm6AsmOperandClass
    : ConstantUImmAsmOperandClass<6, [ConstantUImm6Lsl2AsmOperandClass]>;
def ConstantSImm6AsmOperandClass
    : ConstantSImmAsmOperandClass<6, [ConstantUImm6AsmOperandClass]>;
def ConstantUImm5Lsl2AsmOperandClass : AsmOperandClass {
  let Name = "UImm5Lsl2";
  let RenderMethod = "addImmOperands";
  let PredicateMethod = "isScaledUImm<5, 2>";
  let SuperClasses = [ConstantSImm6AsmOperandClass];
  let DiagnosticType = "UImm5_Lsl2";
}
def ConstantUImm5_Range2_64AsmOperandClass
    : ConstantUImmRangeAsmOperandClass<2, 64, [ConstantUImm5Lsl2AsmOperandClass]>;
def ConstantUImm5Plus33AsmOperandClass
    : ConstantUImmAsmOperandClass<5, [ConstantUImm5_Range2_64AsmOperandClass],
                                  33>;
def ConstantUImm5ReportUImm6AsmOperandClass
    : ConstantUImmAsmOperandClass<5, [ConstantUImm5Plus33AsmOperandClass]> {
  let Name = "ConstantUImm5_0_Report_UImm6";
  let DiagnosticType = "UImm5_0_Report_UImm6";
}
def ConstantUImm5Plus32AsmOperandClass
    : ConstantUImmAsmOperandClass<
          5, [ConstantUImm5ReportUImm6AsmOperandClass], 32>;
def ConstantUImm5Plus32NormalizeAsmOperandClass
    : ConstantUImmAsmOperandClass<5, [ConstantUImm5Plus32AsmOperandClass], 32> {
  let Name = "ConstantUImm5_32_Norm";
  // We must also subtract 32 when we render the operand.
  let RenderMethod = "addConstantUImmOperands<5, 32, -32>";
}
def ConstantUImm5Plus1ReportUImm6AsmOperandClass
    : ConstantUImmAsmOperandClass<
          5, [ConstantUImm5Plus32NormalizeAsmOperandClass], 1>{
  let Name = "ConstantUImm5_Plus1_Report_UImm6";
}
def ConstantUImm5Plus1AsmOperandClass
    : ConstantUImmAsmOperandClass<
          5, [ConstantUImm5Plus1ReportUImm6AsmOperandClass], 1>;
def ConstantUImm5AsmOperandClass
    : ConstantUImmAsmOperandClass<5, [ConstantUImm5Plus1AsmOperandClass]>;
def ConstantSImm5AsmOperandClass
    : ConstantSImmAsmOperandClass<5, [ConstantUImm5AsmOperandClass]>;
def ConstantUImm4AsmOperandClass
    : ConstantUImmAsmOperandClass<4, [ConstantSImm5AsmOperandClass]>;
def ConstantSImm4AsmOperandClass
    : ConstantSImmAsmOperandClass<4, [ConstantUImm4AsmOperandClass]>;
def ConstantUImm3AsmOperandClass
    : ConstantUImmAsmOperandClass<3, [ConstantSImm4AsmOperandClass]>;
def ConstantUImm2AsmOperandClass
    : ConstantUImmAsmOperandClass<2, [ConstantUImm3AsmOperandClass]>;
def ConstantUImm1AsmOperandClass
    : ConstantUImmAsmOperandClass<1, [ConstantUImm2AsmOperandClass]>;
def ConstantImmzAsmOperandClass : AsmOperandClass {
  let Name = "ConstantImmz";
  let RenderMethod = "addConstantUImmOperands<1>";
  let PredicateMethod = "isConstantImmz";
  let SuperClasses = [ConstantUImm1AsmOperandClass];
  let DiagnosticType = "Immz";
}

foreach I = {1, 2, 3, 4, 5, 6, 8} in
  def vsplat_uimm # I : Operand<vAny> {
    let PrintMethod = "printUImm<" # I # ">";
    let ParserMatchClass =
        !cast<AsmOperandClass>("ConstantUImm" # I # "AsmOperandClass");
  }

foreach I = {5, 10} in
  def vsplat_simm # I : Operand<vAny> {
    let ParserMatchClass =
        !cast<AsmOperandClass>("ConstantSImm" # I # "AsmOperandClass");
  }

foreach I = {1, 4, 7, 8, 10, 20, 26} in
  def uimm # I : Operand<i32> {
    let PrintMethod = "printUImm<" # I # ">";
    let ParserMatchClass =
        !cast<AsmOperandClass>("ConstantUImm" # I # "AsmOperandClass");
  }

foreach I = {1, 2, 3, 4, 5, 6, 7, 8} in
  def uimm # I # _ptr : Operand<iPTR> {
    let PrintMethod = "printUImm<" # I # ">";
    let ParserMatchClass =
        !cast<AsmOperandClass>("ConstantUImm" # I # "AsmOperandClass");
  }


def addrimm12 : ComplexPattern<iPTR, 2, "selectIntAddrSImm12", [frameindex]>;


def LoongArchMemSimm12AsmOperand : AsmOperandClass {
  let Name = "MemOffsetSimm12";
  let SuperClasses = [LoongArchMemAsmOperand];
  let RenderMethod = "addMemOperands";
  let ParserMethod = "parseMemOperand";
  let PredicateMethod = "isMemWithSimmOffset<12>";
  let DiagnosticType = "MemSImm12";
}

def mem_simm12 : mem_generic {
  let MIOperandInfo = (ops ptr_rc, simm12);
  let EncoderMethod = "getMemEncoding";
  let ParserMatchClass = LoongArchMemSimm12AsmOperand;
}

foreach I = {4, 6, 9, 10, 11} in
  def simm # I : Operand<i32> {
    let DecoderMethod = "DecodeSImmWithOffsetAndScale<" # I # ">";
    let ParserMatchClass =
        !cast<AsmOperandClass>("ConstantSImm" # I # "AsmOperandClass");
  }

def LoongArchMemSimm9AsmOperand : AsmOperandClass {
  let Name = "MemOffsetSimm9";
  let SuperClasses = [LoongArchMemAsmOperand];
  let RenderMethod = "addMemOperands";
  let ParserMethod = "parseMemOperand";
  let PredicateMethod = "isMemWithSimmOffset<9>";
  let DiagnosticType = "MemSImm9";
}

def LoongArchMemSimm10AsmOperand : AsmOperandClass {
  let Name = "MemOffsetSimm10";
  let SuperClasses = [LoongArchMemAsmOperand];
  let RenderMethod = "addMemOperands";
  let ParserMethod = "parseMemOperand";
  let PredicateMethod = "isMemWithSimmOffset<10>";
  let DiagnosticType = "MemSImm10";
}

def LoongArchMemSimm11AsmOperand : AsmOperandClass {
  let Name = "MemOffsetSimm11";
  let SuperClasses = [LoongArchMemAsmOperand];
  let RenderMethod = "addMemOperands";
  let ParserMethod = "parseMemOperand";
  let PredicateMethod = "isMemWithSimmOffset<11>";
  let DiagnosticType = "MemSImm11";
}

def simm13  : PatLeaf<(imm), [{ return isInt<13>(N->getSExtValue()); }]>;

def simm10Op : Operand<i32> {
  let DecoderMethod = "DecodeSIMM10";
}

def simm13Op : Operand<i32> {
  let DecoderMethod = "DecodeSIMM13";
}

def LoongArchMemSimm10Lsl2AsmOperand : AsmOperandClass {
  let Name = "MemOffsetSimm10_2";
  let SuperClasses = [LoongArchMemAsmOperand];
  let RenderMethod = "addMemOperands";
  let ParserMethod = "parseMemOperand";
  let PredicateMethod = "isMemWithSimmOffset<10, 2>";
  let DiagnosticType = "MemSImm10Lsl2";
}


def simm10_lsl2 : Operand<i32> {
//    let DecoderMethod = "DecodeSImmWithOffsetAndScale<10, 2>";
  let ParserMatchClass =
      !cast<AsmOperandClass>("ConstantSImm10Lsl2AsmOperandClass");
}

def mem_simm10_lsl2 : mem_generic {
  let MIOperandInfo = (ops ptr_rc, !cast<Operand>("simm10_lsl2"));
  let EncoderMethod = "getMemEncoding10l2";
  let ParserMatchClass =
          !cast<AsmOperandClass>("LoongArchMemSimm10Lsl2AsmOperand");
}


def LoongArchMemSimm11Lsl1AsmOperand : AsmOperandClass {
  let Name = "MemOffsetSimm11_1";
  let SuperClasses = [LoongArchMemAsmOperand];
  let RenderMethod = "addMemOperands";
  let ParserMethod = "parseMemOperand";
  let PredicateMethod = "isMemWithSimmOffset<11, 1>";
  let DiagnosticType = "MemSImm11Lsl1";
}


def simm11_lsl1 : Operand<i32> {
  //  let DecoderMethod = "DecodeSImmWithOffsetAndScale<11, 1>";
  let ParserMatchClass =
      !cast<AsmOperandClass>("ConstantSImm11Lsl1AsmOperandClass");
}

def mem_simm11_lsl1 : mem_generic {
  let MIOperandInfo = (ops ptr_rc, !cast<Operand>("simm11_lsl1"));
  let EncoderMethod = "getMemEncoding11l1";
  let ParserMatchClass =
          !cast<AsmOperandClass>("LoongArchMemSimm11Lsl1AsmOperand");
}

def LoongArchMemSimm9Lsl3AsmOperand : AsmOperandClass {
  let Name = "MemOffsetSimm9_3";
  let SuperClasses = [LoongArchMemAsmOperand];
  let RenderMethod = "addMemOperands";
  let ParserMethod = "parseMemOperand";
  let PredicateMethod = "isMemWithSimmOffset<9, 3>";
  let DiagnosticType = "MemSImm9Lsl3";
}


def simm9_lsl3 : Operand<i32> {
  //  let DecoderMethod = "DecodeSImmWithOffsetAndScale<9, 3>";
  let ParserMatchClass =
      !cast<AsmOperandClass>("ConstantSImm9Lsl3AsmOperandClass");
}

def mem_simm9_lsl3 : mem_generic {
  let MIOperandInfo = (ops ptr_rc, !cast<Operand>("simm9_lsl3"));
  let EncoderMethod = "getMemEncoding9l3";
  let ParserMatchClass =
          !cast<AsmOperandClass>("LoongArchMemSimm9Lsl3AsmOperand");
}




// Operands

def immZExt2Lsa : ImmLeaf<i32, [{return isUInt<2>(Imm - 1);}]>;

// Pattern fragments
def vextract_sext_i8  : PatFrag<(ops node:$vec, node:$idx),
                                (LoongArchVExtractSExt node:$vec, node:$idx, i8)>;
def vextract_sext_i16 : PatFrag<(ops node:$vec, node:$idx),
                                (LoongArchVExtractSExt node:$vec, node:$idx, i16)>;
def vextract_sext_i32 : PatFrag<(ops node:$vec, node:$idx),
                                (LoongArchVExtractSExt node:$vec, node:$idx, i32)>;
def vextract_sext_i64 : PatFrag<(ops node:$vec, node:$idx),
                                (LoongArchVExtractSExt node:$vec, node:$idx, i64)>;

def vextract_zext_i8  : PatFrag<(ops node:$vec, node:$idx),
                                (LoongArchVExtractZExt node:$vec, node:$idx, i8)>;
def vextract_zext_i16 : PatFrag<(ops node:$vec, node:$idx),
                                (LoongArchVExtractZExt node:$vec, node:$idx, i16)>;
def vextract_zext_i32 : PatFrag<(ops node:$vec, node:$idx),
                                (LoongArchVExtractZExt node:$vec, node:$idx, i32)>;
def vextract_zext_i64 : PatFrag<(ops node:$vec, node:$idx),
                                (LoongArchVExtractZExt node:$vec, node:$idx, i64)>;

def vldrepl_v16i8  : PatFrag<(ops node:$v1),
                             (v16i8 (LoongArchVBROADCAST node:$v1))>;
def vldrepl_v8i16  : PatFrag<(ops node:$v1),
                             (v8i16 (LoongArchVBROADCAST node:$v1))>;
def vldrepl_v4i32  : PatFrag<(ops node:$v1),
                             (v4i32 (LoongArchVBROADCAST node:$v1))>;
def vldrepl_v2i64  : PatFrag<(ops node:$v1),
                             (v2i64 (LoongArchVBROADCAST node:$v1))>;

def vinsert_v16i8 : PatFrag<(ops node:$vec, node:$val, node:$idx),
    (v16i8 (vector_insert node:$vec, node:$val, node:$idx))>;
def vinsert_v8i16 : PatFrag<(ops node:$vec, node:$val, node:$idx),
    (v8i16 (vector_insert node:$vec, node:$val, node:$idx))>;
def vinsert_v4i32 : PatFrag<(ops node:$vec, node:$val, node:$idx),
    (v4i32 (vector_insert node:$vec, node:$val, node:$idx))>;
def vinsert_v2i64 : PatFrag<(ops node:$vec, node:$val, node:$idx),
    (v2i64 (vector_insert node:$vec, node:$val, node:$idx))>;

class vfsetcc_type<ValueType ResTy, ValueType OpTy, CondCode CC> :
  PatFrag<(ops node:$lhs, node:$rhs),
          (ResTy (vfsetcc (OpTy node:$lhs), (OpTy node:$rhs), CC))>;

// ISD::SETFALSE cannot occur
def vfseteq_v4f32 : vfsetcc_type<v4i32, v4f32, SETEQ>;
def vfseteq_v2f64 : vfsetcc_type<v2i64, v2f64, SETEQ>;
def vfsetge_v4f32 : vfsetcc_type<v4i32, v4f32, SETGE>;
def vfsetge_v2f64 : vfsetcc_type<v2i64, v2f64, SETGE>;
def vfsetgt_v4f32 : vfsetcc_type<v4i32, v4f32, SETGT>;
def vfsetgt_v2f64 : vfsetcc_type<v2i64, v2f64, SETGT>;
def vfsetle_v4f32 : vfsetcc_type<v4i32, v4f32, SETLE>;
def vfsetle_v2f64 : vfsetcc_type<v2i64, v2f64, SETLE>;
def vfsetlt_v4f32 : vfsetcc_type<v4i32, v4f32, SETLT>;
def vfsetlt_v2f64 : vfsetcc_type<v2i64, v2f64, SETLT>;
def vfsetne_v4f32 : vfsetcc_type<v4i32, v4f32, SETNE>;
def vfsetne_v2f64 : vfsetcc_type<v2i64, v2f64, SETNE>;
def vfsetoeq_v4f32 : vfsetcc_type<v4i32, v4f32, SETOEQ>;
def vfsetoeq_v2f64 : vfsetcc_type<v2i64, v2f64, SETOEQ>;
def vfsetoge_v4f32 : vfsetcc_type<v4i32, v4f32, SETOGE>;
def vfsetoge_v2f64 : vfsetcc_type<v2i64, v2f64, SETOGE>;
def vfsetogt_v4f32 : vfsetcc_type<v4i32, v4f32, SETOGT>;
def vfsetogt_v2f64 : vfsetcc_type<v2i64, v2f64, SETOGT>;
def vfsetole_v4f32 : vfsetcc_type<v4i32, v4f32, SETOLE>;
def vfsetole_v2f64 : vfsetcc_type<v2i64, v2f64, SETOLE>;
def vfsetolt_v4f32 : vfsetcc_type<v4i32, v4f32, SETOLT>;
def vfsetolt_v2f64 : vfsetcc_type<v2i64, v2f64, SETOLT>;
def vfsetone_v4f32 : vfsetcc_type<v4i32, v4f32, SETONE>;
def vfsetone_v2f64 : vfsetcc_type<v2i64, v2f64, SETONE>;
def vfsetord_v4f32 : vfsetcc_type<v4i32, v4f32, SETO>;
def vfsetord_v2f64 : vfsetcc_type<v2i64, v2f64, SETO>;
def vfsetun_v4f32  : vfsetcc_type<v4i32, v4f32, SETUO>;
def vfsetun_v2f64  : vfsetcc_type<v2i64, v2f64, SETUO>;
def vfsetueq_v4f32 : vfsetcc_type<v4i32, v4f32, SETUEQ>;
def vfsetueq_v2f64 : vfsetcc_type<v2i64, v2f64, SETUEQ>;
def vfsetuge_v4f32 : vfsetcc_type<v4i32, v4f32, SETUGE>;
def vfsetuge_v2f64 : vfsetcc_type<v2i64, v2f64, SETUGE>;
def vfsetugt_v4f32 : vfsetcc_type<v4i32, v4f32, SETUGT>;
def vfsetugt_v2f64 : vfsetcc_type<v2i64, v2f64, SETUGT>;
def vfsetule_v4f32 : vfsetcc_type<v4i32, v4f32, SETULE>;
def vfsetule_v2f64 : vfsetcc_type<v2i64, v2f64, SETULE>;
def vfsetult_v4f32 : vfsetcc_type<v4i32, v4f32, SETULT>;
def vfsetult_v2f64 : vfsetcc_type<v2i64, v2f64, SETULT>;
def vfsetune_v4f32 : vfsetcc_type<v4i32, v4f32, SETUNE>;
def vfsetune_v2f64 : vfsetcc_type<v2i64, v2f64, SETUNE>;



// ISD::SETTRUE cannot occur
// ISD::SETFALSE2 cannot occur
// ISD::SETTRUE2 cannot occur

class vsetcc_type<ValueType ResTy, CondCode CC> :
  PatFrag<(ops node:$lhs, node:$rhs),
          (ResTy (vsetcc node:$lhs, node:$rhs, CC))>;

def vseteq_v16i8  : vsetcc_type<v16i8, SETEQ>;
def vseteq_v8i16  : vsetcc_type<v8i16, SETEQ>;
def vseteq_v4i32  : vsetcc_type<v4i32, SETEQ>;
def vseteq_v2i64  : vsetcc_type<v2i64, SETEQ>;
def vsetle_v16i8  : vsetcc_type<v16i8, SETLE>;
def vsetle_v8i16  : vsetcc_type<v8i16, SETLE>;
def vsetle_v4i32  : vsetcc_type<v4i32, SETLE>;
def vsetle_v2i64  : vsetcc_type<v2i64, SETLE>;
def vsetlt_v16i8  : vsetcc_type<v16i8, SETLT>;
def vsetlt_v8i16  : vsetcc_type<v8i16, SETLT>;
def vsetlt_v4i32  : vsetcc_type<v4i32, SETLT>;
def vsetlt_v2i64  : vsetcc_type<v2i64, SETLT>;
def vsetule_v16i8 : vsetcc_type<v16i8, SETULE>;
def vsetule_v8i16 : vsetcc_type<v8i16, SETULE>;
def vsetule_v4i32 : vsetcc_type<v4i32, SETULE>;
def vsetule_v2i64 : vsetcc_type<v2i64, SETULE>;
def vsetult_v16i8 : vsetcc_type<v16i8, SETULT>;
def vsetult_v8i16 : vsetcc_type<v8i16, SETULT>;
def vsetult_v4i32 : vsetcc_type<v4i32, SETULT>;
def vsetult_v2i64 : vsetcc_type<v2i64, SETULT>;

def vsplati8  : PatFrag<(ops node:$e0),
                        (v16i8 (build_vector node:$e0, node:$e0,
                                             node:$e0, node:$e0,
                                             node:$e0, node:$e0,
                                             node:$e0, node:$e0,
                                             node:$e0, node:$e0,
                                             node:$e0, node:$e0,
                                             node:$e0, node:$e0,
                                             node:$e0, node:$e0))>;
def vsplati16 : PatFrag<(ops node:$e0),
                        (v8i16 (build_vector node:$e0, node:$e0,
                                             node:$e0, node:$e0,
                                             node:$e0, node:$e0,
                                             node:$e0, node:$e0))>;
def vsplati32 : PatFrag<(ops node:$e0),
                        (v4i32 (build_vector node:$e0, node:$e0,
                                             node:$e0, node:$e0))>;

def vsplati64_imm_eq_1 : PatLeaf<(bitconvert (v4i32 (build_vector))), [{
  APInt Imm;
  SDNode *BV = N->getOperand(0).getNode();
  EVT EltTy = N->getValueType(0).getVectorElementType();

  return selectVSplat(BV, Imm, EltTy.getSizeInBits()) &&
         Imm.getBitWidth() == EltTy.getSizeInBits() && Imm == 1;
}]>;

def vsplati64 : PatFrag<(ops node:$e0),
                        (v2i64 (build_vector node:$e0, node:$e0))>;

def vsplati64_splat_d : PatFrag<(ops node:$e0),
                                (v2i64 (bitconvert
                                         (v4i32 (and
                                           (v4i32 (build_vector node:$e0,
                                                                node:$e0,
                                                                node:$e0,
                                                                node:$e0)),
                                           vsplati64_imm_eq_1))))>;

def vsplatf32 : PatFrag<(ops node:$e0),
                        (v4f32 (build_vector node:$e0, node:$e0,
                                             node:$e0, node:$e0))>;
def vsplatf64 : PatFrag<(ops node:$e0),
                        (v2f64 (build_vector node:$e0, node:$e0))>;

def vsplati8_elt  : PatFrag<(ops node:$v, node:$i),
                            (LoongArchVSHF (vsplati8 node:$i), node:$v, node:$v)>;
def vsplati16_elt : PatFrag<(ops node:$v, node:$i),
                            (LoongArchVSHF (vsplati16 node:$i), node:$v, node:$v)>;
def vsplati32_elt : PatFrag<(ops node:$v, node:$i),
                            (LoongArchVSHF (vsplati32 node:$i), node:$v, node:$v)>;
def vsplati64_elt : PatFrag<(ops node:$v, node:$i),
                            (LoongArchVSHF (vsplati64_splat_d node:$i),node:$v, node:$v)>;

class SplatPatLeaf<Operand opclass, dag frag, code pred = [{}],
                   SDNodeXForm xform = NOOP_SDNodeXForm>
  : PatLeaf<frag, pred, xform> {
  Operand OpClass = opclass;
}

class SplatComplexPattern<Operand opclass, ValueType ty, int numops, string fn,
                          list<SDNode> roots = [],
                          list<SDNodeProperty> props = []> :
  ComplexPattern<ty, numops, fn, roots, props> {
  Operand OpClass = opclass;
}

def vsplati8_uimm3 : SplatComplexPattern<vsplat_uimm3, v16i8, 1,
                                         "selectVSplatUimm3",
                                         [build_vector, bitconvert]>;

def vsplati8_uimm4 : SplatComplexPattern<vsplat_uimm4, v16i8, 1,
                                         "selectVSplatUimm4",
                                         [build_vector, bitconvert]>;

def vsplati8_uimm5 : SplatComplexPattern<vsplat_uimm5, v16i8, 1,
                                         "selectVSplatUimm5",
                                         [build_vector, bitconvert]>;

def vsplati8_uimm8 : SplatComplexPattern<vsplat_uimm8, v16i8, 1,
                                         "selectVSplatUimm8",
                                         [build_vector, bitconvert]>;

def vsplati8_simm5 : SplatComplexPattern<vsplat_simm5, v16i8, 1,
                                         "selectVSplatSimm5",
                                         [build_vector, bitconvert]>;

def vsplati16_uimm3 : SplatComplexPattern<vsplat_uimm3, v8i16, 1,
                                          "selectVSplatUimm3",
                                          [build_vector, bitconvert]>;

def vsplati16_uimm4 : SplatComplexPattern<vsplat_uimm4, v8i16, 1,
                                          "selectVSplatUimm4",
                                          [build_vector, bitconvert]>;

def vsplati16_uimm5 : SplatComplexPattern<vsplat_uimm5, v8i16, 1,
                                          "selectVSplatUimm5",
                                          [build_vector, bitconvert]>;

def vsplati16_simm5 : SplatComplexPattern<vsplat_simm5, v8i16, 1,
                                          "selectVSplatSimm5",
                                          [build_vector, bitconvert]>;

def vsplati32_uimm2 : SplatComplexPattern<vsplat_uimm2, v4i32, 1,
                                          "selectVSplatUimm2",
                                          [build_vector, bitconvert]>;

def vsplati32_uimm5 : SplatComplexPattern<vsplat_uimm5, v4i32, 1,
                                          "selectVSplatUimm5",
                                          [build_vector, bitconvert]>;

def vsplati32_simm5 : SplatComplexPattern<vsplat_simm5, v4i32, 1,
                                          "selectVSplatSimm5",
                                          [build_vector, bitconvert]>;

def vsplati64_uimm1 : SplatComplexPattern<vsplat_uimm1, v2i64, 1,
                                          "selectVSplatUimm1",
                                          [build_vector, bitconvert]>;

def vsplati64_uimm5 : SplatComplexPattern<vsplat_uimm5, v2i64, 1,
                                          "selectVSplatUimm5",
                                          [build_vector, bitconvert]>;

def vsplati64_uimm6 : SplatComplexPattern<vsplat_uimm6, v2i64, 1,
                                          "selectVSplatUimm6",
                                          [build_vector, bitconvert]>;

def vsplati64_simm5 : SplatComplexPattern<vsplat_simm5, v2i64, 1,
                                          "selectVSplatSimm5",
                                          [build_vector, bitconvert]>;


// Any build_vector that is a constant splat with a value that equals 1
// FIXME: These should be a ComplexPattern but we can't use them because the
//        ISel generator requires the uses to have a name, but providing a name
//        causes other errors ("used in pattern but not operand list")
def vsplat_imm_eq_1 : PatLeaf<(build_vector), [{
  APInt Imm;
  EVT EltTy = N->getValueType(0).getVectorElementType();

  return selectVSplat(N, Imm, EltTy.getSizeInBits()) &&
         Imm.getBitWidth() == EltTy.getSizeInBits() && Imm == 1;
}]>;

def vbitclr_b : PatFrag<(ops node:$vj, node:$vk),
                        (and node:$vj, (xor (shl vsplat_imm_eq_1, node:$vk),
                                          immAllOnesV))>;
def vbitclr_h : PatFrag<(ops node:$vj, node:$vk),
                        (and node:$vj, (xor (shl vsplat_imm_eq_1, node:$vk),
                                          immAllOnesV))>;
def vbitclr_w : PatFrag<(ops node:$vj, node:$vk),
                        (and node:$vj, (xor (shl vsplat_imm_eq_1, node:$vk),
                                          immAllOnesV))>;
def vbitclr_d : PatFrag<(ops node:$vj, node:$vk),
                        (and node:$vj, (xor (shl (v2i64 vsplati64_imm_eq_1),
                                               node:$vk),
                                          (bitconvert (v4i32 immAllOnesV))))>;

def vbneg_b : PatFrag<(ops node:$vj, node:$vk),
                      (xor node:$vj, (shl vsplat_imm_eq_1, node:$vk))>;
def vbneg_h : PatFrag<(ops node:$vj, node:$vk),
                      (xor node:$vj, (shl vsplat_imm_eq_1, node:$vk))>;
def vbneg_w : PatFrag<(ops node:$vj, node:$vk),
                      (xor node:$vj, (shl vsplat_imm_eq_1, node:$vk))>;
def vbneg_d : PatFrag<(ops node:$vj, node:$vk),
                      (xor node:$vj, (shl (v2i64 vsplati64_imm_eq_1),
                                          node:$vk))>;

def vbset_b : PatFrag<(ops node:$vj, node:$vk),
                      (or node:$vj, (shl vsplat_imm_eq_1, node:$vk))>;
def vbset_h : PatFrag<(ops node:$vj, node:$vk),
                      (or node:$vj, (shl vsplat_imm_eq_1, node:$vk))>;
def vbset_w : PatFrag<(ops node:$vj, node:$vk),
                      (or node:$vj, (shl vsplat_imm_eq_1, node:$vk))>;
def vbset_d : PatFrag<(ops node:$vj, node:$vk),
                      (or node:$vj, (shl (v2i64 vsplati64_imm_eq_1),
                                         node:$vk))>;

def muladd : PatFrag<(ops node:$vd, node:$vj, node:$vk),
                     (add node:$vd, (mul node:$vj, node:$vk))>;

def mulsub : PatFrag<(ops node:$vd, node:$vj, node:$vk),
                     (sub node:$vd, (mul node:$vj, node:$vk))>;

class IsCommutable {
  bit isCommutable = 1;
}



//class
class LSX_3R_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       RegisterOperand ROVD, RegisterOperand ROVJ = ROVD,
                       RegisterOperand ROVK = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ROVK:$vk);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $vk");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, ROVK:$vk))];
}

class LSX_3RN_DESC_BASE<string instr_asm, RegisterOperand ROVD,
                        RegisterOperand ROVJ = ROVD, RegisterOperand ROVK = ROVD> :
  LSX_3R_DESC_BASE<instr_asm, null_frag, ROVD, ROVJ, ROVK>;

class LSX_3R_4R_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                          RegisterOperand ROVD, RegisterOperand ROVJ = ROVD,
                          RegisterOperand ROVK = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, ROVK:$vk);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $vk");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj,
                                              ROVK:$vk))];
  string Constraints = "$vd = $vd_in";
}

class LSX_3R_VREPLVE_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                             RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, GPR32Opnd:$rk);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $rk");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, GPR32Opnd:$rk))];
}

class LSX_VEC_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                        RegisterOperand ROVD, RegisterOperand ROVJ = ROVD,
                        RegisterOperand ROVK = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ROVK:$vk);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $vk");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, ROVK:$vk))];
}

class LSX_VEC_PSEUDO_BASE<SDPatternOperator OpNode, RegisterOperand ROVD,
                          RegisterOperand ROVJ = ROVD,
                          RegisterOperand ROVK = ROVD> :
      LSXPseudo<(outs ROVD:$vd), (ins ROVJ:$vj, ROVK:$vk),
                [(set ROVD:$vd, (OpNode ROVJ:$vj, ROVK:$vk))]>;

class LSX_3RF_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                        RegisterOperand ROVD, RegisterOperand ROVJ = ROVD,
                        RegisterOperand ROVK = ROVD> :
  LSX_3R_DESC_BASE<instr_asm, OpNode, ROVD, ROVJ, ROVK>;

class LSX_3RFN_DESC_BASE<string instr_asm, RegisterOperand ROVD,
                        RegisterOperand ROVJ = ROVD, RegisterOperand ROVK = ROVD> :
  LSX_3R_DESC_BASE<instr_asm, null_frag, ROVD, ROVJ, ROVK>;

class LSX_3R_DESC_BASE1<string instr_asm, SDPatternOperator OpNode,
                       RegisterOperand ROVD, RegisterOperand ROVJ,
                       RegisterOperand ROVK> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ROVK:$vk);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $vk");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vk, ROVK:$vj))];
}

class LSX_3RF_DESC_BASE1<string instr_asm, SDPatternOperator OpNode,
                        RegisterOperand ROVD, RegisterOperand ROVJ,
                        RegisterOperand ROVK> :
  LSX_3R_DESC_BASE1<instr_asm, OpNode, ROVD, ROVJ, ROVK>;

class LSX_3R_VSHF_DESC_BASE<string instr_asm, RegisterOperand ROVD,
                            RegisterOperand ROVJ = ROVD,
                            RegisterOperand ROVK = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, ROVK:$vk);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $vk");
  list<dag> Pattern = [(set ROVD:$vd, (LoongArchVSHF ROVD:$vd_in, ROVJ:$vj,
                                       ROVK:$vk))];
  string Constraints = "$vd = $vd_in";
}

class LSX_3R_4R_VSHF_DESC_BASE<string instr_asm, RegisterOperand ROVD,
                               RegisterOperand ROVJ = ROVD,
                               RegisterOperand ROVK = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ROVK:$vk, ROVD:$va);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $vk, $va");
  list<dag> Pattern = [(set ROVD:$vd, (LoongArchVSHF ROVD:$va, ROVJ:$vj,
                                       ROVK:$vk))];
}

class LSX_I5_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       SplatComplexPattern SplatImm, RegisterOperand ROVD,
                       RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$si5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $si5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, SplatImm:$si5))];
}

class LSX_I5_U_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       SplatComplexPattern SplatImm, RegisterOperand ROVD,
                       RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, SplatImm:$ui5))];
}

class LSX_BIT_3_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                          RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui3");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, Imm:$ui3))];
}

class LSX_BIT_3N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ = ROVD> :
  LSX_BIT_3_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_BIT_4_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                          RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui4");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, Imm:$ui4))];
}

class LSX_BIT_4N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ = ROVD> :
  LSX_BIT_4_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_BIT_5_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                          RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, Imm:$ui5))];
}

class LSX_BIT_5N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ = ROVD> :
  LSX_BIT_5_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_BIT_6_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                          RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui6");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, Imm:$ui6))];
}

class LSX_BIT_6N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ = ROVD> :
  LSX_BIT_6_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_2R_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj))];
}

class LSX_2RN_DESC_BASE<string instr_asm, RegisterOperand ROVD,
                        RegisterOperand ROVJ = ROVD> :
  LSX_2R_DESC_BASE<instr_asm, null_frag, ROVD, ROVJ>;

class LSX_2RF_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                        RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj))];
}

class LSX_2RFN_DESC_BASE<string instr_asm, RegisterOperand ROVD,
                        RegisterOperand ROVJ = ROVD> :
  LSX_2R_DESC_BASE<instr_asm, null_frag, ROVD, ROVJ>;

class LSX_2RF_DESC_BASE_CVT<string instr_asm, SDPatternOperator OpNode,
                        RegisterOperand ROVD, RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj))];
}

class LSX_2RFN_DESC_BASE_CVT<string instr_asm, RegisterOperand ROVD,
                             RegisterOperand ROVJ = ROVD> :
  LSX_2RF_DESC_BASE_CVT<instr_asm, null_frag, ROVD, ROVJ>;

class LSX_2RF_DESC_BASE_tmp<string instr_asm,
                        RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj");
  list<dag> Pattern = [];
}

class LSX_2R_REPL_DESC_BASE<string instr_asm, ValueType VT,
                            SDPatternOperator OpNode, RegisterOperand ROVD,
                            RegisterOperand ROS = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROS:$rj);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj");
  list<dag> Pattern = [(set ROVD:$vd, (VT (OpNode ROS:$rj)))];
}

class LSX_INSERT_U4_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins  ROVD:$vd_in, ROVJ:$rj, ImmOp:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $ui4");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$rj, Imm:$ui4))];
  string Constraints = "$vd = $vd_in";
}

class LSX_INSERT_U4N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                               RegisterOperand ROVD,
                               RegisterOperand ROVJ = ROVD> :
  LSX_INSERT_U4_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_INSERT_U3_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                           RegisterOperand ROS> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROS:$rj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $ui3");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVD:$vd_in, ROS:$rj, Imm:$ui3))];
  string Constraints = "$vd = $vd_in";
}

class LSX_INSERT_U3N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                               RegisterOperand ROVD,
                               RegisterOperand ROVJ = ROVD> :
  LSX_INSERT_U3_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_INSERT_U2_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                           RegisterOperand ROS> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROS:$rj, ImmOp:$ui2);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $ui2");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVD:$vd_in, ROS:$rj, Imm:$ui2))];
  string Constraints = "$vd = $vd_in";
}

class LSX_INSERT_U2N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                               RegisterOperand ROVD,
                               RegisterOperand ROVJ = ROVD> :
  LSX_INSERT_U2_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_INSERT_U1_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                           RegisterOperand ROS> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROS:$rj, ImmOp:$ui1);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $ui1");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROS:$rj, Imm:$ui1))];
  string Constraints = "$vd = $vd_in";
}

class LSX_INSERT_U1N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                               RegisterOperand ROVD,
                               RegisterOperand ROVJ = ROVD> :
  LSX_INSERT_U1_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_PICK_U1_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                         ValueType VecTy, Operand ImmOp, ImmLeaf Imm,
                         RegisterOperand ROD, RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROD:$rd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui1);
  string AsmString = !strconcat(instr_asm, "\t$rd, $vj, $ui1");
  list<dag> Pattern = [(set ROD:$rd, (OpNode (VecTy ROVJ:$vj), Imm:$ui1))];
}

class LSX_PICK_U2_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                         ValueType VecTy, Operand ImmOp, ImmLeaf Imm,
                         RegisterOperand ROD, RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROD:$rd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui2);
  string AsmString = !strconcat(instr_asm, "\t$rd, $vj, $ui2");
  list<dag> Pattern = [(set ROD:$rd, (OpNode (VecTy ROVJ:$vj), Imm:$ui2))];
}

class LSX_PICK_U3_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                         ValueType VecTy, Operand ImmOp, ImmLeaf Imm,
                         RegisterOperand ROD, RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROD:$rd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$rd, $vj, $ui3");
  list<dag> Pattern = [(set ROD:$rd, (OpNode (VecTy ROVJ:$vj), Imm:$ui3))];
}

class LSX_PICK_U4_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                         ValueType VecTy, Operand ImmOp, ImmLeaf Imm,
                         RegisterOperand ROD, RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROD:$rd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$rd, $vj, $ui4");
  list<dag> Pattern = [(set ROD:$rd, (OpNode (VecTy ROVJ:$vj), Imm:$ui4))];
}

class LSX_ELM_U3_VREPLVE_DESC_BASE<string instr_asm, SplatComplexPattern SplatImm,
                                 RegisterOperand ROVD,
                                 RegisterOperand ROVJ = ROVD> {
 dag OutOperandList = (outs ROVD:$vd);
 dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$ui3);
 string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui3");
 list<dag> Pattern = [(set ROVD:$vd, (LoongArchVSHF SplatImm:$ui3, ROVJ:$vj,
                                      ROVJ:$vj))];
}

class LSX_ELM_U2_VREPLVE_DESC_BASE<string instr_asm, SplatComplexPattern SplatImm,
                                 RegisterOperand ROVD,
                                 RegisterOperand ROVJ = ROVD> {
 dag OutOperandList = (outs ROVD:$vd);
 dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$ui2);
 string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui2");
 list<dag> Pattern = [(set ROVD:$vd, (LoongArchVSHF SplatImm:$ui2, ROVJ:$vj,
                                      ROVJ:$vj))];
}

class LSX_ELM_U1_VREPLVE_DESC_BASE<string instr_asm, SplatComplexPattern SplatImm,
                                 RegisterOperand ROVD,
                                 RegisterOperand ROVJ = ROVD> {
 dag OutOperandList = (outs ROVD:$vd);
 dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$ui1);
 string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui1");
 list<dag> Pattern = [(set ROVD:$vd, (LoongArchVSHF SplatImm:$ui1, ROVJ:$vj,
                                      ROVJ:$vj))];
}

class LSX_ELM_U4_VREPLVE_DESC_BASE<string instr_asm, SplatComplexPattern SplatImm,
                                 RegisterOperand ROVD,
                                 RegisterOperand ROVJ = ROVD> {
 dag OutOperandList = (outs ROVD:$vd);
 dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$ui4);
 string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui4");
 list<dag> Pattern = [(set ROVD:$vd, (LoongArchVSHF SplatImm:$ui4, ROVJ:$vj,
                                      ROVJ:$vj))];
}

class LSX_ELM_U4_SLD_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                               RegisterOperand ROVD, RegisterOperand ROVJ,
                               Operand ImmOp, ImmLeaf Imm> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, ImmOp:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui4");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj,
                                       Imm:$ui4))];
  string Constraints = "$vd = $vd_in";
}

class LSX_ELM_U3_SLD_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                               RegisterOperand ROVD, RegisterOperand ROVJ,
                               Operand ImmOp, ImmLeaf Imm> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui3");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj,
                                       Imm:$ui3))];
  string Constraints = "$vd = $vd_in";
}

class LSX_ELM_U2_SLD_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                               RegisterOperand ROVD, RegisterOperand ROVJ,
                               Operand ImmOp, ImmLeaf Imm> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, ImmOp:$ui2);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui2");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj,
                                       Imm:$ui2))];
  string Constraints = "$vd = $vd_in";
}

class LSX_ELM_U1_SLD_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                               RegisterOperand ROVD, RegisterOperand ROVJ,
                               Operand ImmOp, ImmLeaf Imm> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, ImmOp:$ui1);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui1");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj,
                                       Imm:$ui1))];
  string Constraints = "$vd = $vd_in";
}

class LSX_BIT_U3_VREPLVE_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                                 SplatComplexPattern SplatImm,
                                 RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui3");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, SplatImm:$ui3))];
}

class LSX_BIT_U4_VREPLVE_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                                 SplatComplexPattern SplatImm,
                                 RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui4");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, SplatImm:$ui4))];
}

class LSX_BIT_U5_VREPLVE_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                                 SplatComplexPattern SplatImm,
                                 RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, SplatImm:$ui5))];
}

class LSX_BIT_U6_VREPLVE_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                                 SplatComplexPattern SplatImm,
                                 RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui6");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, SplatImm:$ui6))];
}

class LSX_BIT_U6_VREPLVE_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                                 RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm6:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui6");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, immZExt6:$ui6))];
}

class LSX_BIT_U3_VREPLVE_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                                 RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm3:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui3");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, immZExt3:$ui3))];
}

class LSX_BIT_U4_VREPLVE_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                                 RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm4:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui4");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, immZExt4:$ui4))];
}

class LSX_BIT_U5_VREPLVE_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                                 RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm5:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, immZExt5:$ui5))];
}

class LSX_I8_SHF_DESC_BASE<string instr_asm, RegisterOperand ROVD,
                           RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui8");
  list<dag> Pattern = [(set ROVD:$vd, (LoongArchSHF immZExt8:$ui8, ROVJ:$vj))];
}

class LSX_I8_SHUF_DESC_BASE_D<string instr_asm,
                           SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui8");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj, immZExt8:$ui8))];
  string Constraints = "$vd = $vd_in";
}

def LoongArchSelect : SDNode<"LoongArchISD::VSELECT" ,SDTSelect>;
def LoongArchVROR : SDNode<"LoongArchISD::VROR",
    SDTypeProfile<1, 2, [SDTCisVec<0>, SDTCisInt<0>,
                  SDTCisSameAs<0, 1>, SDTCisSameAs<0, 2>]>, []>;
def LoongArchVRORI : SDNode<"LoongArchISD::VRORI",
    SDTypeProfile<1, 2, [SDTCisVec<0>, SDTCisInt<0>,
                  SDTCisSameAs<0, 1>, SDTCisVT<2, i32>]>, []>;

class LSX2_RORI_U3_DESC_BASE <string instr_asm, Operand ImmOp, ImmLeaf Imm,
                              RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui3");
  list<dag> Pattern = [(set ROVD:$vd, (LoongArchVRORI ROVJ:$vj, Imm:$ui3))];
}

class LSX2_RORI_U4_DESC_BASE <string instr_asm, Operand ImmOp, ImmLeaf Imm,
                              RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui4");
  list<dag> Pattern = [(set ROVD:$vd, (LoongArchVRORI ROVJ:$vj, Imm:$ui4))];
}

class LSX2_RORI_U5_DESC_BASE <string instr_asm, Operand ImmOp, ImmLeaf Imm,
                              RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (LoongArchVRORI ROVJ:$vj, Imm:$ui5))];
}

class LSX2_RORI_U6_DESC_BASE <string instr_asm, Operand ImmOp, ImmLeaf Imm,
                              RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui6");
  list<dag> Pattern = [(set ROVD:$vd, (LoongArchVRORI ROVJ:$vj, Imm:$ui6))];
}

class LSX_BIND_U4_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                          RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, ImmOp:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui4");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj, Imm:$ui4))];
  string Constraints = "$vd = $vd_in";
}

class LSX_BIND_U4N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                               RegisterOperand ROVD,
                               RegisterOperand ROVJ = ROVD> :
  LSX_BIND_U4_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_BIND_U5_DESC_BASE <string instr_asm, SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                          RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, ImmOp:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj, Imm:$ui5))];
  string Constraints = "$vd = $vd_in";
}

class LSX_BIND_U5N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                               RegisterOperand ROVD,
                               RegisterOperand ROVJ = ROVD> :
  LSX_BIND_U5_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_BIND_U6_DESC_BASE <string instr_asm, SDPatternOperator OpNode,
                          Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                          RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, ImmOp:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui6");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj, Imm:$ui6))];
  string Constraints = "$vd = $vd_in";
}

class LSX_BIND_U6N_DESC_BASE<string instr_asm, Operand ImmOp, ImmLeaf Imm,
                               RegisterOperand ROVD,
                               RegisterOperand ROVJ = ROVD> :
  LSX_BIND_U6_DESC_BASE<instr_asm, null_frag, ImmOp, Imm, ROVD, ROVJ>;

class LSX_BIND_U7_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                            RegisterOperand ROVD,
                            RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, uimm7:$ui7);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui7");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj, immZExt7:$ui7))];
  string Constraints = "$vd = $vd_in";
}

class LSX_BIND_U7N_DESC_BASE<string instr_asm,
                               RegisterOperand ROVD,
                               RegisterOperand ROVJ = ROVD> :
  LSX_BIND_U7_DESC_BASE<instr_asm, null_frag, ROVD, ROVJ>;


class LD_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                   ValueType TyNode, RegisterOperand ROVD,
                   Operand MemOpnd, ComplexPattern Addr = addr> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins MemOpnd:$addr);
  string AsmString = !strconcat(instr_asm, "\t$vd, $addr");
  list<dag> Pattern = [(set ROVD:$vd, (TyNode (OpNode Addr:$addr)))];
  string DecoderMethod = "DecodeLSX128Mem";
}

class ST_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                   ValueType TyNode, RegisterOperand ROVD,
                   Operand MemOpnd, ComplexPattern Addr = addrimm12> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROVD:$vd, MemOpnd:$addr);
  string AsmString = !strconcat(instr_asm, "\t$vd, $addr");
  list<dag> Pattern = [(OpNode (TyNode ROVD:$vd), Addr:$addr)];
  string DecoderMethod = "DecodeLSX128Mem";
}

class LSX_VEC_ADDR_PSEUDO_BASE<SDPatternOperator OpNode,
                               ValueType TyNode,
                               RegisterOperand ROVD,
                               Operand MemOpnd,
                               ComplexPattern Addr = addrimm12> :
      LSXPseudo<(outs), (ins ROVD:$vd, MemOpnd:$addr),
                [(OpNode (TyNode ROVD:$vd), MemOpnd:$addr)]>;


class LSX_SET_DESC_BASE<string instr_asm, RegisterOperand ROVD> {
  dag OutOperandList = (outs FCFROpnd:$cd);
  dag InOperandList = (ins ROVD:$vj);
  string AsmString = !strconcat(instr_asm, "\t$cd, $vj");
  list<dag> Pattern = [];
}

class LSX_SET_DESC_BASE_tmp<string instr_asm, SDPatternOperator OpNode,
                            RegisterOperand ROVD> {
  dag OutOperandList = (outs FCFROpnd:$cd);
  dag InOperandList = (ins ROVD:$vj);
  string AsmString = !strconcat(instr_asm, "\t$cd, $vj");
  list<dag> Pattern = [];
}

class LSX_VMul_Reg4<string instr_asm,
                       RegisterOperand ROVD, RegisterOperand ROVJ = ROVD,
                       RegisterOperand ROVK = ROVD,
                       RegisterOperand ROVA = ROVD,
                       SDPatternOperator OpNode> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ROVK:$vk, ROVA:$va);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $vk, $va");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, ROVK:$vk, ROVA:$va))];
}

class LSX_4RF<string instr_asm,
                       SDPatternOperator OpNode,
                       RegisterOperand ROVJ, RegisterOperand ROVA = ROVJ,
                       RegisterOperand ROVK = ROVA, RegisterOperand ROVD = ROVK> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ROVK:$vk, ROVA:$va);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $vk, $va");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, ROVK:$vk, ROVA:$va))];
}


class LSX_VFCMP_Reg3<string instr_asm,
                       RegisterOperand ROVD, RegisterOperand ROVJ = ROVD,
                       RegisterOperand ROVK = ROVD,
                       SDPatternOperator OpNode> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ROVK:$vk);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $vk");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, ROVK:$vk))];
}

class LSX_I12_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins PtrRC:$rj, ImmOp:$si12);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $si12");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode iPTR:$rj, Imm:$si12))];
}

class LSX_I11_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins PtrRC:$rj, ImmOp:$si11);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $si11");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode iPTR:$rj, Imm:$si11))];
}

class LSX_I10_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins PtrRC:$rj, ImmOp:$si10);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $si10");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode iPTR:$rj, Imm:$si10))];
}

class LSX_I9_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins PtrRC:$rj, ImmOp:$si9);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $si9");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode iPTR:$rj, Imm:$si9))];
}


class LSX_I8_U1_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROVD> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins  ROVD:$vd, PtrRC:$rj, ImmOp:$si8, uimm1:$idx);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $si8, $idx");
  list<dag> Pattern = [(OpNode  ROVD:$vd, iPTR:$rj, Imm:$si8, immZExt1:$idx)];
  string DecoderMethod = "DecodeLSX128memstl";
}


class LSX_I8_U2_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROVD> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROVD:$vd, PtrRC:$rj, ImmOp:$si8, uimm2:$idx);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $si8, $idx");
  list<dag> Pattern = [(OpNode  ROVD:$vd, iPTR:$rj, Imm:$si8, immZExt2:$idx)];
  string DecoderMethod = "DecodeLSX128memstl";
}

class LSX_I8_U3_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROVD> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROVD:$vd, PtrRC:$rj, ImmOp:$si8, uimm3:$idx);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $si8, $idx");
  list<dag> Pattern = [(OpNode  ROVD:$vd, iPTR:$rj, Imm:$si8, immZExt3:$idx)];
  string DecoderMethod = "DecodeLSX128memstl";
}

class LSX_I8_U4_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm,
                       RegisterOperand ROVD> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROVD:$vd, PtrRC:$rj, ImmOp:$si8, uimm4:$idx);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $si8, $idx");
  list<dag> Pattern = [(OpNode ROVD:$vd, iPTR:$rj, Imm:$si8, immZExt4:$idx)];
  string DecoderMethod = "DecodeLSX128memstl";
}

class LSX_I5_U_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                       RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, Imm:$ui5))];
}

class LSX_I5_DESC_BASE_Intrinsic<string instr_asm, SDPatternOperator OpNode,
                       Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                       RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, ImmOp:$si5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $si5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, Imm:$si5))];
}

class LSX_LDX_LA<string instr_asm, SDPatternOperator OpNode,
                 RegisterOperand RORK,
                 RegisterOperand ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins PtrRC:$rj, RORK:$rk);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $rk");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode iPTR:$rj, RORK:$rk))];
}

class LSX_SDX_LA<string instr_asm, SDPatternOperator OpNode,
                 RegisterOperand RORK,
                 RegisterOperand ROVD> {
  dag OutOperandList = (outs);
  dag InOperandList = (ins ROVD:$vd, PtrRC:$rj, RORK:$rk);
  string AsmString = !strconcat(instr_asm, "\t$vd, $rj, $rk");
  list<dag> Pattern = [(OpNode ROVD:$vd, iPTR:$rj, RORK:$rk)];
}

class LSX_U5_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       RegisterOperand ROVD,
                       RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm5:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, immZExt5:$ui5))];
}

class LSX_U5_4R_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                          RegisterOperand ROVD,
                          RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, uimm5:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVD:$vd_in, ROVJ:$vj, immZExt5:$ui5))];
  string Constraints = "$vd = $vd_in";
}

class LSX_2R_U3_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm3:$ui3);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui3");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVJ:$vj, immZExt3:$ui3))];
}

class LSX_2R_U4_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm4:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui4");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVJ:$vj, immZExt4:$ui4))];
}

class LSX_2R_U5_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm5:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVJ:$vj, immZExt5:$ui5))];
}

class LSX_2R_U6_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm6:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui6");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVJ:$vj, immZExt6:$ui6))];
}

class LSX_2R_3R_U4_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, uimm4:$ui4);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui4");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVD:$vd_in, ROVJ:$vj, immZExt4:$ui4))];
  string Constraints = "$vd = $vd_in";
}

class LSX_2R_3R_U5_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, uimm5:$ui5);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui5");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVD:$vd_in, ROVJ:$vj, immZExt5:$ui5))];
  string Constraints = "$vd = $vd_in";
}

class LSX_2R_3R_U6_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, uimm6:$ui6);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui6");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVD:$vd_in, ROVJ:$vj, immZExt6:$ui6))];
  string Constraints = "$vd = $vd_in";
}

class LSX_2R_3R_U7_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, uimm7:$ui7);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui7");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVD:$vd_in, ROVJ:$vj, immZExt7:$ui7))];
  string Constraints = "$vd = $vd_in";
}

class LSX_2R_3R_U8_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui8");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVD:$vd_in, ROVJ:$vj, immZExt8:$ui8))];
  string Constraints = "$vd = $vd_in";
}

class LSX_2R_3R_SELECT<string instr_asm, SDPatternOperator OpNode,
                       RegisterOperand ROVD,
                       RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVD:$vd_in, ROVJ:$vj, vsplat_uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui8");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVD:$vd_in, vsplati8_uimm8:$ui8, ROVJ:$vj))];
  string Constraints = "$vd = $vd_in";
}

class LSX_2R_U8_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                           RegisterOperand ROVD,
                           RegisterOperand ROVJ> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, uimm8:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui8");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode  ROVJ:$vj, immZExt8:$ui8))];
}

class LSX_I13_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                       ValueType Ty, Operand immOp,
                       RegisterOperand ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins immOp:$i13);
  string AsmString = !strconcat(instr_asm, "\t$vd, $i13");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode (Ty simm13:$i13)))];
  string DecoderMethod = "DecodeLSX128Mem13";
}

class LSX_I13_DESC_BASE_10<string instr_asm, SDPatternOperator OpNode,
                           Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                           RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ImmOp:$i10);
  string AsmString = !strconcat(instr_asm, "\t$vd, $i10");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode Imm:$i10))];
  bit hasSideEffects = 0;
  string DecoderMethod = "DecodeLSX128Mem10";
}

class LSX_BIT_U8_VREPLVE_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                                 SplatComplexPattern SplatImm,
                                 RegisterOperand ROVD, RegisterOperand ROVJ = ROVD> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins ROVJ:$vj, SplatImm.OpClass:$ui8);
  string AsmString = !strconcat(instr_asm, "\t$vd, $vj, $ui8");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode ROVJ:$vj, SplatImm:$ui8))];
}


class LSXPat<dag pattern, dag result, list<Predicate> pred = [HasLSX]> :
  Pat<pattern, result>, Requires<pred>;

// Instruction encoding.


def VSADD_B : LSX_3R<0b01110000010001100>, IsCommutable,
              LSX_3RN_DESC_BASE<"vsadd.b", LSX128BOpnd>;

def VSADD_H : LSX_3R<0b01110000010001101>, IsCommutable,
              LSX_3RN_DESC_BASE<"vsadd.h", LSX128HOpnd>;

def VSADD_W : LSX_3R<0b01110000010001110>, IsCommutable,
              LSX_3RN_DESC_BASE<"vsadd.w", LSX128WOpnd>;

def VSADD_D : LSX_3R<0b01110000010001111>, IsCommutable,
              LSX_3RN_DESC_BASE<"vsadd.d", LSX128DOpnd>;


def VSSUB_B : LSX_3R<0b01110000010010000>,
              LSX_3RN_DESC_BASE<"vssub.b", LSX128BOpnd>;

def VSSUB_H : LSX_3R<0b01110000010010001>,
              LSX_3RN_DESC_BASE<"vssub.h", LSX128HOpnd>;

def VSSUB_W : LSX_3R<0b01110000010010010>,
              LSX_3RN_DESC_BASE<"vssub.w", LSX128WOpnd>;

def VSSUB_D : LSX_3R<0b01110000010010011>,
              LSX_3RN_DESC_BASE<"vssub.d", LSX128DOpnd>;


def VSADD_BU : LSX_3R<0b01110000010010100>, IsCommutable,
               LSX_3RN_DESC_BASE<"vsadd.bu", LSX128BOpnd>;

def VSADD_HU : LSX_3R<0b01110000010010101>, IsCommutable,
               LSX_3RN_DESC_BASE<"vsadd.hu", LSX128HOpnd>;

def VSADD_WU : LSX_3R<0b01110000010010110>, IsCommutable,
               LSX_3RN_DESC_BASE<"vsadd.wu", LSX128WOpnd>;

def VSADD_DU : LSX_3R<0b01110000010010111>, IsCommutable,
               LSX_3RN_DESC_BASE<"vsadd.du", LSX128DOpnd>;


def VSSUB_BU : LSX_3R<0b01110000010011000>,
               LSX_3RN_DESC_BASE<"vssub.bu", LSX128BOpnd>;

def VSSUB_HU : LSX_3R<0b01110000010011001>,
               LSX_3RN_DESC_BASE<"vssub.hu", LSX128HOpnd>;

def VSSUB_WU : LSX_3R<0b01110000010011010>,
               LSX_3RN_DESC_BASE<"vssub.wu", LSX128WOpnd>;

def VSSUB_DU : LSX_3R<0b01110000010011011>,
               LSX_3RN_DESC_BASE<"vssub.du", LSX128DOpnd>;


def VHADDW_H_B : LSX_3R<0b01110000010101000>,
                 LSX_3RN_DESC_BASE<"vhaddw.h.b", LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VHADDW_W_H : LSX_3R<0b01110000010101001>,
                 LSX_3RN_DESC_BASE<"vhaddw.w.h", LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VHADDW_D_W : LSX_3R<0b01110000010101010>,
                 LSX_3RN_DESC_BASE<"vhaddw.d.w", LSX128DOpnd, LSX128WOpnd, LSX128WOpnd>;


def VHSUBW_H_B : LSX_3R<0b01110000010101100>,
                 LSX_3RN_DESC_BASE<"vhsubw.h.b", LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VHSUBW_W_H : LSX_3R<0b01110000010101101>,
                 LSX_3RN_DESC_BASE<"vhsubw.w.h", LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VHSUBW_D_W : LSX_3R<0b01110000010101110>,
                 LSX_3RN_DESC_BASE<"vhsubw.d.w", LSX128DOpnd, LSX128WOpnd, LSX128WOpnd>;


def VHADDW_HU_BU : LSX_3R<0b01110000010110000>,
                   LSX_3RN_DESC_BASE<"vhaddw.hu.bu", LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VHADDW_WU_HU : LSX_3R<0b01110000010110001>,
                   LSX_3RN_DESC_BASE<"vhaddw.wu.hu", LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VHADDW_DU_WU : LSX_3R<0b01110000010110010>,
                   LSX_3RN_DESC_BASE<"vhaddw.du.wu", LSX128DOpnd, LSX128WOpnd, LSX128WOpnd>;


def VHSUBW_HU_BU : LSX_3R<0b01110000010110100>,
                   LSX_3RN_DESC_BASE<"vhsubw.hu.bu", LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VHSUBW_WU_HU : LSX_3R<0b01110000010110101>,
                   LSX_3RN_DESC_BASE<"vhsubw.wu.hu", LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VHSUBW_DU_WU : LSX_3R<0b01110000010110110>,
                   LSX_3RN_DESC_BASE<"vhsubw.du.wu", LSX128DOpnd, LSX128WOpnd, LSX128WOpnd>;


def VADDA_B : LSX_3R<0b01110000010111000>, IsCommutable,
              LSX_3RN_DESC_BASE<"vadda.b", LSX128BOpnd>;

def VADDA_H : LSX_3R<0b01110000010111001>, IsCommutable,
              LSX_3RN_DESC_BASE<"vadda.h", LSX128HOpnd>;

def VADDA_W : LSX_3R<0b01110000010111010>, IsCommutable,
              LSX_3RN_DESC_BASE<"vadda.w", LSX128WOpnd>;

def VADDA_D : LSX_3R<0b01110000010111011>, IsCommutable,
              LSX_3RN_DESC_BASE<"vadda.d", LSX128DOpnd>;


def VABSD_B : LSX_3R<0b01110000011000000>,
              LSX_3RN_DESC_BASE<"vabsd.b", LSX128BOpnd>;

def VABSD_H : LSX_3R<0b01110000011000001>,
              LSX_3RN_DESC_BASE<"vabsd.h", LSX128HOpnd>;

def VABSD_W : LSX_3R<0b01110000011000010>,
              LSX_3RN_DESC_BASE<"vabsd.w", LSX128WOpnd>;

def VABSD_D : LSX_3R<0b01110000011000011>,
              LSX_3RN_DESC_BASE<"vabsd.d", LSX128DOpnd>;


def VABSD_BU : LSX_3R<0b01110000011000100>,
               LSX_3RN_DESC_BASE<"vabsd.bu", LSX128BOpnd>;

def VABSD_HU : LSX_3R<0b01110000011000101>,
               LSX_3RN_DESC_BASE<"vabsd.hu", LSX128HOpnd>;

def VABSD_WU : LSX_3R<0b01110000011000110>,
               LSX_3RN_DESC_BASE<"vabsd.wu", LSX128WOpnd>;

def VABSD_DU : LSX_3R<0b01110000011000111>,
               LSX_3RN_DESC_BASE<"vabsd.du", LSX128DOpnd>;


def VAVG_B : LSX_3R<0b01110000011001000>, IsCommutable,
             LSX_3RN_DESC_BASE<"vavg.b", LSX128BOpnd>;

def VAVG_H : LSX_3R<0b01110000011001001>, IsCommutable,
             LSX_3RN_DESC_BASE<"vavg.h", LSX128HOpnd>;

def VAVG_W : LSX_3R<0b01110000011001010>, IsCommutable,
             LSX_3RN_DESC_BASE<"vavg.w", LSX128WOpnd>;

def VAVG_D : LSX_3R<0b01110000011001011>, IsCommutable,
             LSX_3RN_DESC_BASE<"vavg.d", LSX128DOpnd>;


def VAVG_BU : LSX_3R<0b01110000011001100>, IsCommutable,
              LSX_3RN_DESC_BASE<"vavg.bu", LSX128BOpnd>;

def VAVG_HU : LSX_3R<0b01110000011001101>, IsCommutable,
              LSX_3RN_DESC_BASE<"vavg.hu", LSX128HOpnd>;

def VAVG_WU : LSX_3R<0b01110000011001110>, IsCommutable,
              LSX_3RN_DESC_BASE<"vavg.wu", LSX128WOpnd>;

def VAVG_DU : LSX_3R<0b01110000011001111>, IsCommutable,
              LSX_3RN_DESC_BASE<"vavg.du", LSX128DOpnd>;


def VAVGR_B : LSX_3R<0b01110000011010000>, IsCommutable,
              LSX_3RN_DESC_BASE<"vavgr.b", LSX128BOpnd>;

def VAVGR_H : LSX_3R<0b01110000011010001>, IsCommutable,
              LSX_3RN_DESC_BASE<"vavgr.h", LSX128HOpnd>;

def VAVGR_W : LSX_3R<0b01110000011010010>, IsCommutable,
              LSX_3RN_DESC_BASE<"vavgr.w", LSX128WOpnd>;

def VAVGR_D : LSX_3R<0b01110000011010011>, IsCommutable,
              LSX_3RN_DESC_BASE<"vavgr.d", LSX128DOpnd>;


def VAVGR_BU : LSX_3R<0b01110000011010100>, IsCommutable,
               LSX_3RN_DESC_BASE<"vavgr.bu", LSX128BOpnd>;

def VAVGR_HU : LSX_3R<0b01110000011010101>, IsCommutable,
               LSX_3RN_DESC_BASE<"vavgr.hu", LSX128HOpnd>;

def VAVGR_WU : LSX_3R<0b01110000011010110>, IsCommutable,
               LSX_3RN_DESC_BASE<"vavgr.wu", LSX128WOpnd>;

def VAVGR_DU : LSX_3R<0b01110000011010111>, IsCommutable,
               LSX_3RN_DESC_BASE<"vavgr.du", LSX128DOpnd>;


def VMAX_B : LSX_3R<0b01110000011100000>,
             LSX_3R_DESC_BASE<"vmax.b", smax, LSX128BOpnd>;

def VMAX_H : LSX_3R<0b01110000011100001>,
             LSX_3R_DESC_BASE<"vmax.h", smax, LSX128HOpnd>;

def VMAX_W : LSX_3R<0b01110000011100010>,
             LSX_3R_DESC_BASE<"vmax.w", smax, LSX128WOpnd>;

def VMAX_D : LSX_3R<0b01110000011100011>,
             LSX_3R_DESC_BASE<"vmax.d", smax, LSX128DOpnd>;


def VMIN_B : LSX_3R<0b01110000011100100>,
             LSX_3R_DESC_BASE<"vmin.b", smin, LSX128BOpnd>;

def VMIN_H : LSX_3R<0b01110000011100101>,
             LSX_3R_DESC_BASE<"vmin.h", smin, LSX128HOpnd>;

def VMIN_W : LSX_3R<0b01110000011100110>,
             LSX_3R_DESC_BASE<"vmin.w", smin, LSX128WOpnd>;

def VMIN_D : LSX_3R<0b01110000011100111>,
             LSX_3R_DESC_BASE<"vmin.d", smin, LSX128DOpnd>;


def VMAX_BU : LSX_3R<0b01110000011101000>,
              LSX_3R_DESC_BASE<"vmax.bu", umax, LSX128BOpnd>;

def VMAX_HU : LSX_3R<0b01110000011101001>,
              LSX_3R_DESC_BASE<"vmax.hu", umax, LSX128HOpnd>;

def VMAX_WU : LSX_3R<0b01110000011101010>,
              LSX_3R_DESC_BASE<"vmax.wu", umax, LSX128WOpnd>;

def VMAX_DU : LSX_3R<0b01110000011101011>,
              LSX_3R_DESC_BASE<"vmax.du", umax, LSX128DOpnd>;


def VMIN_BU : LSX_3R<0b01110000011101100>,
              LSX_3R_DESC_BASE<"vmin.bu", umin, LSX128BOpnd>;

def VMIN_HU : LSX_3R<0b01110000011101101>,
              LSX_3R_DESC_BASE<"vmin.hu", umin, LSX128HOpnd>;

def VMIN_WU : LSX_3R<0b01110000011101110>,
              LSX_3R_DESC_BASE<"vmin.wu", umin, LSX128WOpnd>;

def VMIN_DU : LSX_3R<0b01110000011101111>,
              LSX_3R_DESC_BASE<"vmin.du", umin, LSX128DOpnd>;


def VMUL_B : LSX_3R<0b01110000100001000>,
             LSX_3R_DESC_BASE<"vmul.b", mul, LSX128BOpnd>;

def VMUL_H : LSX_3R<0b01110000100001001>,
             LSX_3R_DESC_BASE<"vmul.h", mul, LSX128HOpnd>;

def VMUL_W : LSX_3R<0b01110000100001010>,
             LSX_3R_DESC_BASE<"vmul.w", mul, LSX128WOpnd>;

def VMUL_D : LSX_3R<0b01110000100001011>,
             LSX_3R_DESC_BASE<"vmul.d", mul, LSX128DOpnd>;


def VMADD_B : LSX_3R<0b01110000101010000>,
              LSX_3R_4R_DESC_BASE<"vmadd.b", muladd, LSX128BOpnd>;

def VMADD_H : LSX_3R<0b01110000101010001>,
              LSX_3R_4R_DESC_BASE<"vmadd.h", muladd, LSX128HOpnd>;

def VMADD_W : LSX_3R<0b01110000101010010>,
              LSX_3R_4R_DESC_BASE<"vmadd.w", muladd, LSX128WOpnd>;

def VMADD_D : LSX_3R<0b01110000101010011>,
              LSX_3R_4R_DESC_BASE<"vmadd.d", muladd, LSX128DOpnd>;


def VMSUB_B : LSX_3R<0b01110000101010100>,
              LSX_3R_4R_DESC_BASE<"vmsub.b", mulsub, LSX128BOpnd>;

def VMSUB_H : LSX_3R<0b01110000101010101>,
              LSX_3R_4R_DESC_BASE<"vmsub.h", mulsub, LSX128HOpnd>;

def VMSUB_W : LSX_3R<0b01110000101010110>,
              LSX_3R_4R_DESC_BASE<"vmsub.w", mulsub, LSX128WOpnd>;

def VMSUB_D : LSX_3R<0b01110000101010111>,
              LSX_3R_4R_DESC_BASE<"vmsub.d", mulsub, LSX128DOpnd>;


def VDIV_B : LSX_3R<0b01110000111000000>,
             LSX_3R_DESC_BASE<"vdiv.b", sdiv, LSX128BOpnd>;

def VDIV_H : LSX_3R<0b01110000111000001>,
             LSX_3R_DESC_BASE<"vdiv.h", sdiv, LSX128HOpnd>;

def VDIV_W : LSX_3R<0b01110000111000010>,
             LSX_3R_DESC_BASE<"vdiv.w", sdiv, LSX128WOpnd>;

def VDIV_D : LSX_3R<0b01110000111000011>,
             LSX_3R_DESC_BASE<"vdiv.d", sdiv, LSX128DOpnd>;


def VMOD_B : LSX_3R<0b01110000111000100>,
             LSX_3R_DESC_BASE<"vmod.b", srem, LSX128BOpnd>;

def VMOD_H : LSX_3R<0b01110000111000101>,
             LSX_3R_DESC_BASE<"vmod.h", srem, LSX128HOpnd>;

def VMOD_W : LSX_3R<0b01110000111000110>,
             LSX_3R_DESC_BASE<"vmod.w", srem, LSX128WOpnd>;

def VMOD_D : LSX_3R<0b01110000111000111>,
             LSX_3R_DESC_BASE<"vmod.d", srem, LSX128DOpnd>;


def VDIV_BU : LSX_3R<0b01110000111001000>,
              LSX_3R_DESC_BASE<"vdiv.bu", udiv, LSX128BOpnd>;

def VDIV_HU : LSX_3R<0b01110000111001001>,
              LSX_3R_DESC_BASE<"vdiv.hu", udiv, LSX128HOpnd>;

def VDIV_WU : LSX_3R<0b01110000111001010>,
              LSX_3R_DESC_BASE<"vdiv.wu", udiv, LSX128WOpnd>;

def VDIV_DU : LSX_3R<0b01110000111001011>,
              LSX_3R_DESC_BASE<"vdiv.du", udiv, LSX128DOpnd>;


def VMOD_BU : LSX_3R<0b01110000111001100>,
              LSX_3R_DESC_BASE<"vmod.bu", urem, LSX128BOpnd>;

def VMOD_HU : LSX_3R<0b01110000111001101>,
              LSX_3R_DESC_BASE<"vmod.hu", urem, LSX128HOpnd>;

def VMOD_WU : LSX_3R<0b01110000111001110>,
              LSX_3R_DESC_BASE<"vmod.wu", urem, LSX128WOpnd>;

def VMOD_DU : LSX_3R<0b01110000111001111>,
              LSX_3R_DESC_BASE<"vmod.du", urem, LSX128DOpnd>;


def VSLL_B : LSX_3R<0b01110000111010000>,
             LSX_3R_DESC_BASE<"vsll.b", shl, LSX128BOpnd>;

def VSLL_H : LSX_3R<0b01110000111010001>,
             LSX_3R_DESC_BASE<"vsll.h", shl, LSX128HOpnd>;

def VSLL_W : LSX_3R<0b01110000111010010>,
             LSX_3R_DESC_BASE<"vsll.w", shl, LSX128WOpnd>;

def VSLL_D : LSX_3R<0b01110000111010011>,
             LSX_3R_DESC_BASE<"vsll.d", shl, LSX128DOpnd>;


def VSRL_B : LSX_3R<0b01110000111010100>,
             LSX_3R_DESC_BASE<"vsrl.b", srl, LSX128BOpnd>;

def VSRL_H : LSX_3R<0b01110000111010101>,
             LSX_3R_DESC_BASE<"vsrl.h", srl, LSX128HOpnd>;

def VSRL_W : LSX_3R<0b01110000111010110>,
             LSX_3R_DESC_BASE<"vsrl.w", srl, LSX128WOpnd>;

def VSRL_D : LSX_3R<0b01110000111010111>,
             LSX_3R_DESC_BASE<"vsrl.d", srl, LSX128DOpnd>;


def VSRA_B : LSX_3R<0b01110000111011000>,
             LSX_3R_DESC_BASE<"vsra.b", sra, LSX128BOpnd>;

def VSRA_H : LSX_3R<0b01110000111011001>,
             LSX_3R_DESC_BASE<"vsra.h", sra, LSX128HOpnd>;

def VSRA_W : LSX_3R<0b01110000111011010>,
             LSX_3R_DESC_BASE<"vsra.w", sra, LSX128WOpnd>;

def VSRA_D : LSX_3R<0b01110000111011011>,
             LSX_3R_DESC_BASE<"vsra.d", sra, LSX128DOpnd>;


def VSRLR_B : LSX_3R<0b01110000111100000>,
              LSX_3RN_DESC_BASE<"vsrlr.b", LSX128BOpnd>;

def VSRLR_H : LSX_3R<0b01110000111100001>,
              LSX_3RN_DESC_BASE<"vsrlr.h", LSX128HOpnd>;

def VSRLR_W : LSX_3R<0b01110000111100010>,
              LSX_3RN_DESC_BASE<"vsrlr.w", LSX128WOpnd>;

def VSRLR_D : LSX_3R<0b01110000111100011>,
              LSX_3RN_DESC_BASE<"vsrlr.d", LSX128DOpnd>;


def VSRAR_B : LSX_3R<0b01110000111100100>,
              LSX_3RN_DESC_BASE<"vsrar.b", LSX128BOpnd>;

def VSRAR_H : LSX_3R<0b01110000111100101>,
              LSX_3RN_DESC_BASE<"vsrar.h", LSX128HOpnd>;

def VSRAR_W : LSX_3R<0b01110000111100110>,
              LSX_3RN_DESC_BASE<"vsrar.w", LSX128WOpnd>;

def VSRAR_D : LSX_3R<0b01110000111100111>,
              LSX_3RN_DESC_BASE<"vsrar.d", LSX128DOpnd>;


def VBITCLR_B : LSX_3R<0b01110001000011000>,
                LSX_3R_DESC_BASE<"vbitclr.b", vbitclr_b, LSX128BOpnd>;

def VBITCLR_H : LSX_3R<0b01110001000011001>,
                LSX_3R_DESC_BASE<"vbitclr.h", vbitclr_h, LSX128HOpnd>;

def VBITCLR_W : LSX_3R<0b01110001000011010>,
                LSX_3R_DESC_BASE<"vbitclr.w", vbitclr_w, LSX128WOpnd>;

def VBITCLR_D : LSX_3R<0b01110001000011011>,
                LSX_3R_DESC_BASE<"vbitclr.d", vbitclr_d, LSX128DOpnd>;


def VBITSET_B : LSX_3R<0b01110001000011100>,
                LSX_3RN_DESC_BASE<"vbitset.b", LSX128BOpnd>;

def VBITSET_H : LSX_3R<0b01110001000011101>,
                LSX_3RN_DESC_BASE<"vbitset.h", LSX128HOpnd>;

def VBITSET_W : LSX_3R<0b01110001000011110>,
                LSX_3RN_DESC_BASE<"vbitset.w", LSX128WOpnd>;

def VBITSET_D : LSX_3R<0b01110001000011111>,
                LSX_3RN_DESC_BASE<"vbitset.d", LSX128DOpnd>;


def VBITREV_B : LSX_3R<0b01110001000100000>,
                LSX_3RN_DESC_BASE<"vbitrev.b", LSX128BOpnd>;

def VBITREV_H : LSX_3R<0b01110001000100001>,
                LSX_3RN_DESC_BASE<"vbitrev.h", LSX128HOpnd>;

def VBITREV_W : LSX_3R<0b01110001000100010>,
                LSX_3RN_DESC_BASE<"vbitrev.w", LSX128WOpnd>;

def VBITREV_D : LSX_3R<0b01110001000100011>,
                LSX_3RN_DESC_BASE<"vbitrev.d", LSX128DOpnd>;


def VPACKEV_B : LSX_3R<0b01110001000101100>,
                LSX_3R_DESC_BASE<"vpackev.b", LoongArchVPACKEV, LSX128BOpnd>;

def VPACKEV_H : LSX_3R<0b01110001000101101>,
                LSX_3R_DESC_BASE<"vpackev.h", LoongArchVPACKEV, LSX128HOpnd>;

def VPACKEV_W : LSX_3R<0b01110001000101110>,
                LSX_3R_DESC_BASE<"vpackev.w", LoongArchVPACKEV, LSX128WOpnd>;

def VPACKEV_D : LSX_3R<0b01110001000101111>,
                LSX_3R_DESC_BASE<"vpackev.d", LoongArchVPACKEV, LSX128DOpnd>;


def VPACKOD_B : LSX_3R<0b01110001000110000>,
                LSX_3R_DESC_BASE<"vpackod.b", LoongArchVPACKOD, LSX128BOpnd>;

def VPACKOD_H : LSX_3R<0b01110001000110001>,
                LSX_3R_DESC_BASE<"vpackod.h", LoongArchVPACKOD, LSX128HOpnd>;

def VPACKOD_W : LSX_3R<0b01110001000110010>,
                LSX_3R_DESC_BASE<"vpackod.w", LoongArchVPACKOD, LSX128WOpnd>;

def VPACKOD_D : LSX_3R<0b01110001000110011>,
                LSX_3R_DESC_BASE<"vpackod.d", LoongArchVPACKOD, LSX128DOpnd>;


def VILVL_B : LSX_3R<0b01110001000110100>,
              LSX_3R_DESC_BASE<"vilvl.b", LoongArchVILVL, LSX128BOpnd>;

def VILVL_H : LSX_3R<0b01110001000110101>,
              LSX_3R_DESC_BASE<"vilvl.h", LoongArchVILVL, LSX128HOpnd>;

def VILVL_W : LSX_3R<0b01110001000110110>,
              LSX_3R_DESC_BASE<"vilvl.w", LoongArchVILVL, LSX128WOpnd>;

def VILVL_D : LSX_3R<0b01110001000110111>,
              LSX_3R_DESC_BASE<"vilvl.d", LoongArchVILVL, LSX128DOpnd>;


def VILVH_B : LSX_3R<0b01110001000111000>,
              LSX_3R_DESC_BASE<"vilvh.b", LoongArchVILVH, LSX128BOpnd>;

def VILVH_H : LSX_3R<0b01110001000111001>,
              LSX_3R_DESC_BASE<"vilvh.h", LoongArchVILVH, LSX128HOpnd>;

def VILVH_W : LSX_3R<0b01110001000111010>,
              LSX_3R_DESC_BASE<"vilvh.w", LoongArchVILVH, LSX128WOpnd>;

def VILVH_D : LSX_3R<0b01110001000111011>,
              LSX_3R_DESC_BASE<"vilvh.d", LoongArchVILVH, LSX128DOpnd>;


def VPICKEV_B : LSX_3R<0b01110001000111100>,
                LSX_3R_DESC_BASE<"vpickev.b", LoongArchVPICKEV, LSX128BOpnd>;

def VPICKEV_H : LSX_3R<0b01110001000111101>,
                LSX_3R_DESC_BASE<"vpickev.h", LoongArchVPICKEV, LSX128HOpnd>;

def VPICKEV_W : LSX_3R<0b01110001000111110>,
                LSX_3R_DESC_BASE<"vpickev.w", LoongArchVPICKEV, LSX128WOpnd>;

def VPICKEV_D : LSX_3R<0b01110001000111111>,
                LSX_3R_DESC_BASE<"vpickev.d", LoongArchVPICKEV, LSX128DOpnd>;


def VPICKOD_B : LSX_3R<0b01110001001000000>,
                LSX_3R_DESC_BASE<"vpickod.b", LoongArchVPICKOD, LSX128BOpnd>;

def VPICKOD_H : LSX_3R<0b01110001001000001>,
                LSX_3R_DESC_BASE<"vpickod.h", LoongArchVPICKOD, LSX128HOpnd>;

def VPICKOD_W : LSX_3R<0b01110001001000010>,
                LSX_3R_DESC_BASE<"vpickod.w", LoongArchVPICKOD, LSX128WOpnd>;

def VPICKOD_D : LSX_3R<0b01110001001000011>,
                LSX_3R_DESC_BASE<"vpickod.d", LoongArchVPICKOD, LSX128DOpnd>;


def VREPLVE_B : LSX_3R_1GP<0b01110001001000100>,
                LSX_3R_VREPLVE_DESC_BASE<"vreplve.b", vsplati8_elt, LSX128BOpnd>;

def VREPLVE_H : LSX_3R_1GP<0b01110001001000101>,
                LSX_3R_VREPLVE_DESC_BASE<"vreplve.h", vsplati16_elt, LSX128HOpnd>;

def VREPLVE_W : LSX_3R_1GP<0b01110001001000110>,
                LSX_3R_VREPLVE_DESC_BASE<"vreplve.w", vsplati32_elt, LSX128WOpnd>;

def VREPLVE_D : LSX_3R_1GP<0b01110001001000111>,
                LSX_3R_VREPLVE_DESC_BASE<"vreplve.d", vsplati64_elt, LSX128DOpnd>;


def VAND_V : LSX_3R<0b01110001001001100>,
             LSX_VEC_DESC_BASE<"vand.v", and, LSX128BOpnd>;
class AND_V_H_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<and, LSX128HOpnd>;
class AND_V_W_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<and, LSX128WOpnd>;
class AND_V_D_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<and, LSX128DOpnd>;

def AND_V_H_PSEUDO : AND_V_H_PSEUDO_DESC,
                     PseudoInstExpansion<(VAND_V LSX128BOpnd:$vd,
                                                 LSX128BOpnd:$vj,
                                                 LSX128BOpnd:$vk)>;
def AND_V_W_PSEUDO : AND_V_W_PSEUDO_DESC,
                     PseudoInstExpansion<(VAND_V LSX128BOpnd:$vd,
                                                 LSX128BOpnd:$vj,
                                                 LSX128BOpnd:$vk)>;
def AND_V_D_PSEUDO : AND_V_D_PSEUDO_DESC,
                     PseudoInstExpansion<(VAND_V LSX128BOpnd:$vd,
                                                 LSX128BOpnd:$vj,
                                                 LSX128BOpnd:$vk)>;


def VOR_V : LSX_3R<0b01110001001001101>,
            LSX_VEC_DESC_BASE<"vor.v", or, LSX128BOpnd>;
class OR_V_H_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<or, LSX128HOpnd>;
class OR_V_W_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<or, LSX128WOpnd>;
class OR_V_D_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<or, LSX128DOpnd>;

def OR_V_H_PSEUDO : OR_V_H_PSEUDO_DESC,
                    PseudoInstExpansion<(VOR_V LSX128BOpnd:$vd,
                                               LSX128BOpnd:$vj,
                                               LSX128BOpnd:$vk)>;
def OR_V_W_PSEUDO : OR_V_W_PSEUDO_DESC,
                    PseudoInstExpansion<(VOR_V LSX128BOpnd:$vd,
                                               LSX128BOpnd:$vj,
                                               LSX128BOpnd:$vk)>;
def OR_V_D_PSEUDO : OR_V_D_PSEUDO_DESC,
                    PseudoInstExpansion<(VOR_V LSX128BOpnd:$vd,
                                               LSX128BOpnd:$vj,
                                               LSX128BOpnd:$vk)>;


def VXOR_V : LSX_3R<0b01110001001001110>,
             LSX_VEC_DESC_BASE<"vxor.v", xor, LSX128BOpnd>;
class XOR_V_H_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<xor, LSX128HOpnd>;
class XOR_V_W_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<xor, LSX128WOpnd>;
class XOR_V_D_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<xor, LSX128DOpnd>;

def XOR_V_H_PSEUDO : XOR_V_H_PSEUDO_DESC,
                     PseudoInstExpansion<(VXOR_V LSX128BOpnd:$vd,
                                                 LSX128BOpnd:$vj,
                                                 LSX128BOpnd:$vk)>;
def XOR_V_W_PSEUDO : XOR_V_W_PSEUDO_DESC,
                     PseudoInstExpansion<(VXOR_V LSX128BOpnd:$vd,
                                                 LSX128BOpnd:$vj,
                                                 LSX128BOpnd:$vk)>;
def XOR_V_D_PSEUDO : XOR_V_D_PSEUDO_DESC,
                     PseudoInstExpansion<(VXOR_V LSX128BOpnd:$vd,
                                                 LSX128BOpnd:$vj,
                                                 LSX128BOpnd:$vk)>;


def VNOR_V : LSX_3R<0b01110001001001111>,
             LSX_VEC_DESC_BASE<"vnor.v", LoongArchVNOR, LSX128BOpnd>;
class NOR_V_H_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<LoongArchVNOR, LSX128HOpnd>;
class NOR_V_W_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<LoongArchVNOR, LSX128WOpnd>;
class NOR_V_D_PSEUDO_DESC : LSX_VEC_PSEUDO_BASE<LoongArchVNOR, LSX128DOpnd>;

def NOR_V_H_PSEUDO : NOR_V_H_PSEUDO_DESC,
                     PseudoInstExpansion<(VNOR_V LSX128BOpnd:$vd,
                                                 LSX128BOpnd:$vj,
                                                 LSX128BOpnd:$vk)>;
def NOR_V_W_PSEUDO : NOR_V_W_PSEUDO_DESC,
                     PseudoInstExpansion<(VNOR_V LSX128BOpnd:$vd,
                                                 LSX128BOpnd:$vj,
                                                 LSX128BOpnd:$vk)>;
def NOR_V_D_PSEUDO : NOR_V_D_PSEUDO_DESC,
                     PseudoInstExpansion<(VNOR_V LSX128BOpnd:$vd,
                                                 LSX128BOpnd:$vj,
                                                 LSX128BOpnd:$vk)>;


def VFADD_S : LSX_3R<0b01110001001100001>, IsCommutable,
              LSX_3RF_DESC_BASE<"vfadd.s", fadd, LSX128WOpnd>;

def VFADD_D : LSX_3R<0b01110001001100010>, IsCommutable,
              LSX_3RF_DESC_BASE<"vfadd.d", fadd, LSX128DOpnd>;


def VFSUB_S : LSX_3R<0b01110001001100101>,
              LSX_3RF_DESC_BASE<"vfsub.s", fsub, LSX128WOpnd>;

def VFSUB_D : LSX_3R<0b01110001001100110>,
              LSX_3RF_DESC_BASE<"vfsub.d", fsub, LSX128DOpnd>;


def VFMUL_S : LSX_3R<0b01110001001110001>,
              LSX_3RF_DESC_BASE<"vfmul.s", fmul, LSX128WOpnd>;

def VFMUL_D : LSX_3R<0b01110001001110010>,
              LSX_3RF_DESC_BASE<"vfmul.d", fmul, LSX128DOpnd>;


def VFDIV_S : LSX_3R<0b01110001001110101>,
              LSX_3RF_DESC_BASE<"vfdiv.s", fdiv, LSX128WOpnd>;

def VFDIV_D : LSX_3R<0b01110001001110110>,
              LSX_3RF_DESC_BASE<"vfdiv.d", fdiv, LSX128DOpnd>;


def VFMAX_S : LSX_3R<0b01110001001111001>,
              LSX_3RFN_DESC_BASE<"vfmax.s", LSX128WOpnd>;

def VFMAX_D : LSX_3R<0b01110001001111010>,
              LSX_3RFN_DESC_BASE<"vfmax.d", LSX128DOpnd>;


def VFMIN_S : LSX_3R<0b01110001001111101>,
              LSX_3RFN_DESC_BASE<"vfmin.s", LSX128WOpnd>;

def VFMIN_D : LSX_3R<0b01110001001111110>,
              LSX_3RFN_DESC_BASE<"vfmin.d", LSX128DOpnd>;


def VFMAXA_S : LSX_3R<0b01110001010000001>,
               LSX_3RFN_DESC_BASE<"vfmaxa.s", LSX128WOpnd>;

def VFMAXA_D : LSX_3R<0b01110001010000010>,
               LSX_3RFN_DESC_BASE<"vfmaxa.d", LSX128DOpnd>;


def VFMINA_S : LSX_3R<0b01110001010000101>,
               LSX_3RFN_DESC_BASE<"vfmina.s", LSX128WOpnd>;

def VFMINA_D : LSX_3R<0b01110001010000110>,
               LSX_3RFN_DESC_BASE<"vfmina.d", LSX128DOpnd>;


def VSHUF_H : LSX_3R<0b01110001011110101>,
              LSX_3R_VSHF_DESC_BASE<"vshuf.h", LSX128HOpnd>;

def VSHUF_W : LSX_3R<0b01110001011110110>,
              LSX_3R_VSHF_DESC_BASE<"vshuf.w", LSX128WOpnd>;

def VSHUF_D : LSX_3R<0b01110001011110111>,
              LSX_3R_VSHF_DESC_BASE<"vshuf.d", LSX128DOpnd>;


def VSEQI_B : LSX_I5<0b01110010100000000>,
              LSX_I5_DESC_BASE_Intrinsic<"vseqi.b", int_loongarch_lsx_vseqi_b, simm5_32, immSExt5, LSX128BOpnd>;

def VSEQI_H : LSX_I5<0b01110010100000001>,
              LSX_I5_DESC_BASE_Intrinsic<"vseqi.h", int_loongarch_lsx_vseqi_h, simm5_32, immSExt5, LSX128HOpnd>;

def VSEQI_W : LSX_I5<0b01110010100000010>,
              LSX_I5_DESC_BASE_Intrinsic<"vseqi.w", int_loongarch_lsx_vseqi_w, simm5_32, immSExt5, LSX128WOpnd>;

def VSEQI_D : LSX_I5<0b01110010100000011>,
              LSX_I5_DESC_BASE_Intrinsic<"vseqi.d", int_loongarch_lsx_vseqi_d, simm5_32, immSExt5, LSX128DOpnd>;


def VSLEI_B : LSX_I5<0b01110010100000100>,
              LSX_I5_DESC_BASE_Intrinsic<"vslei.b", int_loongarch_lsx_vslei_b, simm5_32, immSExt5, LSX128BOpnd>;

def VSLEI_H : LSX_I5<0b01110010100000101>,
              LSX_I5_DESC_BASE_Intrinsic<"vslei.h", int_loongarch_lsx_vslei_h, simm5_32, immSExt5, LSX128HOpnd>;

def VSLEI_W : LSX_I5<0b01110010100000110>,
              LSX_I5_DESC_BASE_Intrinsic<"vslei.w", int_loongarch_lsx_vslei_w, simm5_32, immSExt5, LSX128WOpnd>;

def VSLEI_D : LSX_I5<0b01110010100000111>,
              LSX_I5_DESC_BASE_Intrinsic<"vslei.d", int_loongarch_lsx_vslei_d, simm5_32, immSExt5, LSX128DOpnd>;


def VSLEI_BU : LSX_I5_U<0b01110010100001000>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vslei.bu", int_loongarch_lsx_vslei_bu, uimm5, immZExt5, LSX128BOpnd>;

def VSLEI_HU : LSX_I5_U<0b01110010100001001>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vslei.hu", int_loongarch_lsx_vslei_hu, uimm5, immZExt5, LSX128HOpnd>;

def VSLEI_WU : LSX_I5_U<0b01110010100001010>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vslei.wu", int_loongarch_lsx_vslei_wu, uimm5, immZExt5, LSX128WOpnd>;

def VSLEI_DU : LSX_I5_U<0b01110010100001011>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vslei.du", int_loongarch_lsx_vslei_du, uimm5, immZExt5, LSX128DOpnd>;


def VSLTI_B : LSX_I5<0b01110010100001100>,
              LSX_I5_DESC_BASE_Intrinsic<"vslti.b", int_loongarch_lsx_vslti_b, simm5_32, immSExt5, LSX128BOpnd>;

def VSLTI_H : LSX_I5<0b01110010100001101>,
              LSX_I5_DESC_BASE_Intrinsic<"vslti.h", int_loongarch_lsx_vslti_h, simm5_32, immSExt5, LSX128HOpnd>;

def VSLTI_W : LSX_I5<0b01110010100001110>,
              LSX_I5_DESC_BASE_Intrinsic<"vslti.w", int_loongarch_lsx_vslti_w, simm5_32, immSExt5, LSX128WOpnd>;

def VSLTI_D : LSX_I5<0b01110010100001111>,
              LSX_I5_DESC_BASE_Intrinsic<"vslti.d", int_loongarch_lsx_vslti_d, simm5_32, immSExt5, LSX128DOpnd>;


def VSLTI_BU : LSX_I5_U<0b01110010100010000>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vslti.bu", int_loongarch_lsx_vslti_bu, uimm5, immZExt5, LSX128BOpnd>;

def VSLTI_HU : LSX_I5_U<0b01110010100010001>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vslti.hu", int_loongarch_lsx_vslti_hu, uimm5, immZExt5, LSX128HOpnd>;

def VSLTI_WU : LSX_I5_U<0b01110010100010010>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vslti.wu", int_loongarch_lsx_vslti_wu, uimm5, immZExt5, LSX128WOpnd>;

def VSLTI_DU : LSX_I5_U<0b01110010100010011>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vslti.du", int_loongarch_lsx_vslti_du, uimm5, immZExt5, LSX128DOpnd>;


def VADDI_BU : LSX_I5_U<0b01110010100010100>,
               LSX_I5_U_DESC_BASE<"vaddi.bu", add, vsplati8_uimm5, LSX128BOpnd>;

def VADDI_HU : LSX_I5_U<0b01110010100010101>,
               LSX_I5_U_DESC_BASE<"vaddi.hu", add, vsplati16_uimm5, LSX128HOpnd>;

def VADDI_WU : LSX_I5_U<0b01110010100010110>,
               LSX_I5_U_DESC_BASE<"vaddi.wu", add, vsplati32_uimm5, LSX128WOpnd>;

def VADDI_DU : LSX_I5_U<0b01110010100010111>,
               LSX_I5_U_DESC_BASE<"vaddi.du", add, vsplati64_uimm5, LSX128DOpnd>;


def VSUBI_BU : LSX_I5_U<0b01110010100011000>,
               LSX_I5_U_DESC_BASE<"vsubi.bu", sub, vsplati8_uimm5, LSX128BOpnd>;

def VSUBI_HU : LSX_I5_U<0b01110010100011001>,
               LSX_I5_U_DESC_BASE<"vsubi.hu", sub, vsplati16_uimm5, LSX128HOpnd>;

def VSUBI_WU : LSX_I5_U<0b01110010100011010>,
               LSX_I5_U_DESC_BASE<"vsubi.wu", sub, vsplati32_uimm5, LSX128WOpnd>;

def VSUBI_DU : LSX_I5_U<0b01110010100011011>,
               LSX_I5_U_DESC_BASE<"vsubi.du", sub, vsplati64_uimm5, LSX128DOpnd>;


def VMAXI_B : LSX_I5<0b01110010100100000>,
              LSX_I5_DESC_BASE_Intrinsic<"vmaxi.b", int_loongarch_lsx_vmaxi_b, simm5_32, immSExt5, LSX128BOpnd>;

def VMAXI_H : LSX_I5<0b01110010100100001>,
              LSX_I5_DESC_BASE_Intrinsic<"vmaxi.h", int_loongarch_lsx_vmaxi_h, simm5_32, immSExt5, LSX128HOpnd>;

def VMAXI_W : LSX_I5<0b01110010100100010>,
              LSX_I5_DESC_BASE_Intrinsic<"vmaxi.w", int_loongarch_lsx_vmaxi_w, simm5_32, immSExt5, LSX128WOpnd>;

def VMAXI_D : LSX_I5<0b01110010100100011>,
              LSX_I5_DESC_BASE_Intrinsic<"vmaxi.d", int_loongarch_lsx_vmaxi_d, simm5_32, immSExt5, LSX128DOpnd>;


def VMINI_B : LSX_I5<0b01110010100100100>,
              LSX_I5_DESC_BASE_Intrinsic<"vmini.b", int_loongarch_lsx_vmini_b, simm5_32, immSExt5, LSX128BOpnd>;

def VMINI_H : LSX_I5<0b01110010100100101>,
              LSX_I5_DESC_BASE_Intrinsic<"vmini.h", int_loongarch_lsx_vmini_h, simm5_32, immSExt5, LSX128HOpnd>;

def VMINI_W : LSX_I5<0b01110010100100110>,
              LSX_I5_DESC_BASE_Intrinsic<"vmini.w", int_loongarch_lsx_vmini_w, simm5_32, immSExt5, LSX128WOpnd>;

def VMINI_D : LSX_I5<0b01110010100100111>,
              LSX_I5_DESC_BASE_Intrinsic<"vmini.d", int_loongarch_lsx_vmini_d, simm5_32, immSExt5, LSX128DOpnd>;


def VMAXI_BU : LSX_I5_U<0b01110010100101000>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vmaxi.bu", int_loongarch_lsx_vmaxi_bu, uimm5, immZExt5, LSX128BOpnd>;

def VMAXI_HU : LSX_I5_U<0b01110010100101001>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vmaxi.hu", int_loongarch_lsx_vmaxi_hu, uimm5, immZExt5, LSX128HOpnd>;

def VMAXI_WU : LSX_I5_U<0b01110010100101010>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vmaxi.wu", int_loongarch_lsx_vmaxi_wu, uimm5, immZExt5, LSX128WOpnd>;

def VMAXI_DU : LSX_I5_U<0b01110010100101011>,
               LSX_I5_U_DESC_BASE_Intrinsic<"vmaxi.du", int_loongarch_lsx_vmaxi_du, uimm5, immZExt5, LSX128DOpnd>;


def VMINI_BU : LSX_I5_U<0b01110010100101100>,
               LSX_I5_U_DESC_BASE<"vmini.bu", umin, vsplati8_uimm5, LSX128BOpnd>;

def VMINI_HU : LSX_I5_U<0b01110010100101101>,
               LSX_I5_U_DESC_BASE<"vmini.hu", umin, vsplati16_uimm5, LSX128HOpnd>;

def VMINI_WU : LSX_I5_U<0b01110010100101110>,
               LSX_I5_U_DESC_BASE<"vmini.wu", umin, vsplati32_uimm5, LSX128WOpnd>;

def VMINI_DU : LSX_I5_U<0b01110010100101111>,
               LSX_I5_U_DESC_BASE<"vmini.du", umin, vsplati64_uimm5, LSX128DOpnd>;


def VCLO_B : LSX_2R<0b0111001010011100000000>,
             LSX_2RN_DESC_BASE<"vclo.b", LSX128BOpnd>;

def VCLO_H : LSX_2R<0b0111001010011100000001>,
             LSX_2RN_DESC_BASE<"vclo.h", LSX128HOpnd>;

def VCLO_W : LSX_2R<0b0111001010011100000010>,
             LSX_2RN_DESC_BASE<"vclo.w", LSX128WOpnd>;

def VCLO_D : LSX_2R<0b0111001010011100000011>,
             LSX_2RN_DESC_BASE<"vclo.d", LSX128DOpnd>;


def VCLZ_B : LSX_2R<0b0111001010011100000100>,
             LSX_2R_DESC_BASE<"vclz.b", ctlz, LSX128BOpnd>;

def VCLZ_H : LSX_2R<0b0111001010011100000101>,
             LSX_2R_DESC_BASE<"vclz.h", ctlz, LSX128HOpnd>;

def VCLZ_W : LSX_2R<0b0111001010011100000110>,
             LSX_2R_DESC_BASE<"vclz.w", ctlz, LSX128WOpnd>;

def VCLZ_D : LSX_2R<0b0111001010011100000111>,
             LSX_2R_DESC_BASE<"vclz.d", ctlz, LSX128DOpnd>;


def VPCNT_B : LSX_2R<0b0111001010011100001000>,
              LSX_2R_DESC_BASE<"vpcnt.b", ctpop, LSX128BOpnd>;

def VPCNT_H : LSX_2R<0b0111001010011100001001>,
              LSX_2R_DESC_BASE<"vpcnt.h", ctpop, LSX128HOpnd>;

def VPCNT_W : LSX_2R<0b0111001010011100001010>,
              LSX_2R_DESC_BASE<"vpcnt.w", ctpop, LSX128WOpnd>;

def VPCNT_D : LSX_2R<0b0111001010011100001011>,
              LSX_2R_DESC_BASE<"vpcnt.d", ctpop, LSX128DOpnd>;


def VFLOGB_S : LSX_2R<0b0111001010011100110001>,
               LSX_2RFN_DESC_BASE<"vflogb.s", LSX128WOpnd>;

def VFLOGB_D : LSX_2R<0b0111001010011100110010>,
               LSX_2RFN_DESC_BASE<"vflogb.d", LSX128DOpnd>;


def VFCLASS_S : LSX_2R<0b0111001010011100110101>,
                LSX_2RFN_DESC_BASE<"vfclass.s", LSX128WOpnd>;

def VFCLASS_D : LSX_2R<0b0111001010011100110110>,
                LSX_2RFN_DESC_BASE<"vfclass.d", LSX128DOpnd>;


def VFSQRT_S : LSX_2R<0b0111001010011100111001>,
               LSX_2RF_DESC_BASE<"vfsqrt.s", fsqrt, LSX128WOpnd>;

def VFSQRT_D : LSX_2R<0b0111001010011100111010>,
               LSX_2RF_DESC_BASE<"vfsqrt.d", fsqrt, LSX128DOpnd>;


def VFRECIP_S : LSX_2R<0b0111001010011100111101>,
                LSX_2RFN_DESC_BASE<"vfrecip.s", LSX128WOpnd>;

def VFRECIP_D : LSX_2R<0b0111001010011100111110>,
                LSX_2RFN_DESC_BASE<"vfrecip.d", LSX128DOpnd>;


def VFRSQRT_S : LSX_2R<0b0111001010011101000001>,
                LSX_2RFN_DESC_BASE<"vfrsqrt.s", LSX128WOpnd>;

def VFRSQRT_D : LSX_2R<0b0111001010011101000010>,
                LSX_2RFN_DESC_BASE<"vfrsqrt.d", LSX128DOpnd>;


def VFRINT_S : LSX_2R<0b0111001010011101001101>,
               LSX_2RF_DESC_BASE<"vfrint.s", frint, LSX128WOpnd>;

def VFRINT_D : LSX_2R<0b0111001010011101001110>,
               LSX_2RF_DESC_BASE<"vfrint.d", frint, LSX128DOpnd>;


def VFCVTL_S_H : LSX_2R<0b0111001010011101111010>,
                 LSX_2RFN_DESC_BASE_CVT<"vfcvtl.s.h", LSX128WOpnd, LSX128HOpnd>;

def VFCVTH_S_H : LSX_2R<0b0111001010011101111011>,
                 LSX_2RFN_DESC_BASE_CVT<"vfcvth.s.h", LSX128WOpnd, LSX128HOpnd>;


def VFCVTL_D_S : LSX_2R<0b0111001010011101111100>,
                 LSX_2RFN_DESC_BASE_CVT<"vfcvtl.d.s", LSX128DOpnd, LSX128WOpnd>;

def VFCVTH_D_S : LSX_2R<0b0111001010011101111101>,
                 LSX_2RFN_DESC_BASE_CVT<"vfcvth.d.s", LSX128DOpnd, LSX128WOpnd>;


def VFFINT_S_W : LSX_2R<0b0111001010011110000000>,
                 LSX_2RF_DESC_BASE<"vffint.s.w", sint_to_fp, LSX128WOpnd>;

def VFFINT_S_WU : LSX_2R<0b0111001010011110000001>,
                  LSX_2RF_DESC_BASE<"vffint.s.wu", uint_to_fp, LSX128WOpnd>;


def VFFINT_D_L : LSX_2R<0b0111001010011110000010>,
                 LSX_2RF_DESC_BASE<"vffint.d.l", sint_to_fp, LSX128DOpnd>;

def VFFINT_D_LU : LSX_2R<0b0111001010011110000011>,
                  LSX_2RF_DESC_BASE<"vffint.d.lu", uint_to_fp, LSX128DOpnd>;


def VFTINT_W_S : LSX_2R<0b0111001010011110001100>,
                 LSX_2RFN_DESC_BASE<"vftint.w.s", LSX128WOpnd>;

def VFTINT_L_D : LSX_2R<0b0111001010011110001101>,
                 LSX_2RFN_DESC_BASE<"vftint.l.d", LSX128DOpnd>;


def VFTINT_WU_S : LSX_2R<0b0111001010011110010110>,
                  LSX_2RFN_DESC_BASE<"vftint.wu.s", LSX128WOpnd>;

def VFTINT_LU_D : LSX_2R<0b0111001010011110010111>,
                  LSX_2RFN_DESC_BASE<"vftint.lu.d", LSX128DOpnd>;


def VFTINTRZ_WU_S : LSX_2R<0b0111001010011110011100>,
                    LSX_2RF_DESC_BASE<"vftintrz.wu.s", fp_to_uint, LSX128WOpnd>;

def VFTINTRZ_LU_D : LSX_2R<0b0111001010011110011101>,
                    LSX_2RF_DESC_BASE<"vftintrz.lu.d", fp_to_uint, LSX128DOpnd>;


def VREPLGR2VR_B : LSX_2R_1GP<0b0111001010011111000000>,
                   LSX_2R_REPL_DESC_BASE<"vreplgr2vr.b", v16i8, vsplati8, LSX128BOpnd, GPR32Opnd>;

def VREPLGR2VR_H : LSX_2R_1GP<0b0111001010011111000001>,
                   LSX_2R_REPL_DESC_BASE<"vreplgr2vr.h", v8i16, vsplati16, LSX128HOpnd, GPR32Opnd>;

def VREPLGR2VR_W : LSX_2R_1GP<0b0111001010011111000010>,
                   LSX_2R_REPL_DESC_BASE<"vreplgr2vr.w", v4i32, vsplati32, LSX128WOpnd, GPR32Opnd>;

def VREPLGR2VR_D : LSX_2R_1GP<0b0111001010011111000011>,
                   LSX_2R_REPL_DESC_BASE<"vreplgr2vr.d", v2i64, vsplati64, LSX128DOpnd, GPR64Opnd>;


class LSX_2R_FILL_PSEUDO_BASE<ValueType VT, SDPatternOperator OpNode,
                              RegisterClass RCVD, RegisterClass RCVS = RCVD> :
      LSXPseudo<(outs RCVD:$vd), (ins RCVS:$fs),
                [(set RCVD:$vd, (OpNode RCVS:$fs))]> {
  let usesCustomInserter = 1;
}

class FILL_FW_PSEUDO_DESC : LSX_2R_FILL_PSEUDO_BASE<v4f32, vsplatf32, LSX128W,
                                                    FGR32>;
class FILL_FD_PSEUDO_DESC : LSX_2R_FILL_PSEUDO_BASE<v2f64, vsplatf64, LSX128D,
                                                    FGR64>;

def FILL_FW_PSEUDO : FILL_FW_PSEUDO_DESC;
def FILL_FD_PSEUDO : FILL_FD_PSEUDO_DESC;


def VSRLRI_B : LSX_I3_U<0b0111001010100100001>,
               LSX_BIT_3N_DESC_BASE<"vsrlri.b", uimm3, immZExt3, LSX128BOpnd>;

def VSRLRI_H : LSX_I4_U<0b011100101010010001>,
               LSX_BIT_4N_DESC_BASE<"vsrlri.h", uimm4, immZExt4, LSX128HOpnd>;

def VSRLRI_W : LSX_I5_U<0b01110010101001001>,
               LSX_BIT_5N_DESC_BASE<"vsrlri.w", uimm5, immZExt5, LSX128WOpnd>;

def VSRLRI_D : LSX_I6_U<0b0111001010100101>,
               LSX_BIT_6N_DESC_BASE<"vsrlri.d", uimm6, immZExt6, LSX128DOpnd>;


def VSRARI_B : LSX_I3_U<0b0111001010101000001>,
               LSX_BIT_3N_DESC_BASE<"vsrari.b", uimm3, immZExt3, LSX128BOpnd>;

def VSRARI_H : LSX_I4_U<0b011100101010100001>,
               LSX_BIT_4N_DESC_BASE<"vsrari.h", uimm4, immZExt4, LSX128HOpnd>;

def VSRARI_W : LSX_I5_U<0b01110010101010001>,
               LSX_BIT_5N_DESC_BASE<"vsrari.w", uimm5, immZExt5, LSX128WOpnd>;

def VSRARI_D : LSX_I6_U<0b0111001010101001>,
               LSX_BIT_6N_DESC_BASE<"vsrari.d", uimm6, immZExt6, LSX128DOpnd>;


def VINSGR2VR_B : LSX_I4_R_U<0b011100101110101110>,
                  LSX_INSERT_U4_DESC_BASE<"vinsgr2vr.b", vinsert_v16i8, uimm4, immZExt4Ptr, LSX128BOpnd, GPR32Opnd>;

def VINSGR2VR_H : LSX_I3_R_U<0b0111001011101011110>,
                  LSX_INSERT_U3_DESC_BASE<"vinsgr2vr.h", vinsert_v8i16, uimm3, immZExt3Ptr, LSX128HOpnd, GPR32Opnd>;

def VINSGR2VR_W : LSX_I2_R_U<0b01110010111010111110>,
                  LSX_INSERT_U2_DESC_BASE<"vinsgr2vr.w", vinsert_v4i32, uimm2, immZExt2Ptr, LSX128WOpnd, GPR32Opnd>;

def VINSGR2VR_D : LSX_I1_R_U<0b011100101110101111110>,
                  LSX_INSERT_U1_DESC_BASE<"vinsgr2vr.d", vinsert_v2i64, uimm1, immZExt1Ptr, LSX128DOpnd, GPR64Opnd>;


def VPICKVE2GR_B : LSX_ELM_COPY_B<0b011100101110111110>,
                   LSX_PICK_U4_DESC_BASE<"vpickve2gr.b", vextract_sext_i8, v16i8, uimm4_ptr, immZExt4Ptr, GPR32Opnd, LSX128BOpnd>;

def VPICKVE2GR_H : LSX_ELM_COPY_H<0b0111001011101111110>,
                   LSX_PICK_U3_DESC_BASE<"vpickve2gr.h", vextract_sext_i16, v8i16, uimm3_ptr, immZExt3Ptr, GPR32Opnd, LSX128HOpnd>;

def VPICKVE2GR_W : LSX_ELM_COPY_W<0b01110010111011111110>,
                   LSX_PICK_U2_DESC_BASE<"vpickve2gr.w", vextract_sext_i32, v4i32, uimm2_ptr, immZExt2Ptr, GPR32Opnd, LSX128WOpnd>;

def VPICKVE2GR_D : LSX_ELM_COPY_D<0b011100101110111111110>,
                   LSX_PICK_U1_DESC_BASE<"vpickve2gr.d", vextract_sext_i64, v2i64, uimm1_ptr, immZExt1Ptr, GPR64Opnd, LSX128DOpnd>;


def VPICKVE2GR_BU : LSX_ELM_COPY_B<0b011100101111001110>,
                    LSX_PICK_U4_DESC_BASE<"vpickve2gr.bu", vextract_zext_i8, v16i8, uimm4_ptr, immZExt4Ptr, GPR32Opnd, LSX128BOpnd>;

def VPICKVE2GR_HU : LSX_ELM_COPY_H<0b0111001011110011110>,
                    LSX_PICK_U3_DESC_BASE<"vpickve2gr.hu", vextract_zext_i16, v8i16, uimm3_ptr, immZExt3Ptr, GPR32Opnd, LSX128HOpnd>;

def VPICKVE2GR_WU : LSX_ELM_COPY_W<0b01110010111100111110>,
                    LSX_PICK_U2_DESC_BASE<"vpickve2gr.wu", vextract_zext_i32, v4i32, uimm2_ptr, immZExt2Ptr, GPR32Opnd, LSX128WOpnd>;

def VPICKVE2GR_DU : LSX_ELM_COPY_D<0b011100101111001111110>,
                    LSX_PICK_U1_DESC_BASE<"vpickve2gr.du", int_loongarch_lsx_vpickve2gr_du, v2i64, uimm1, immZExt1, GPR64Opnd, LSX128DOpnd>;


def : LSXPat<(vextract_zext_i64 (v2i64 LSX128D:$vj), immZExt1Ptr:$idx),
             (VPICKVE2GR_D LSX128D:$vj, immZExt1:$idx)>;
def : LSXPat<(vextract_zext_i64 (v2f64 LSX128D:$vj), immZExt1Ptr:$idx),
             (VPICKVE2GR_D LSX128D:$vj, immZExt1:$idx)>;


def VREPLVEI_B : LSX_I4_U<0b011100101111011110>,
                 LSX_ELM_U4_VREPLVE_DESC_BASE<"vreplvei.b", vsplati8_uimm4, LSX128BOpnd>;

def VREPLVEI_H : LSX_I3_U<0b0111001011110111110>,
                 LSX_ELM_U3_VREPLVE_DESC_BASE<"vreplvei.h", vsplati16_uimm3, LSX128HOpnd>;

def VREPLVEI_W : LSX_I2_U<0b01110010111101111110>,
                 LSX_ELM_U2_VREPLVE_DESC_BASE<"vreplvei.w", vsplati32_uimm2, LSX128WOpnd>;

def VREPLVEI_D : LSX_I1_U<0b011100101111011111110>,
                 LSX_ELM_U1_VREPLVE_DESC_BASE<"vreplvei.d", vsplati64_uimm1, LSX128DOpnd>;


def VSAT_B : LSX_I3_U<0b0111001100100100001>,
             LSX_BIT_3N_DESC_BASE<"vsat.b", uimm3, immZExt3, LSX128BOpnd>;

def VSAT_H : LSX_I4_U<0b011100110010010001>,
             LSX_BIT_4N_DESC_BASE<"vsat.h", uimm4, immZExt4, LSX128HOpnd>;

def VSAT_W : LSX_I5_U<0b01110011001001001>,
             LSX_BIT_5N_DESC_BASE<"vsat.w", uimm5, immZExt5, LSX128WOpnd>;

def VSAT_D : LSX_I6_U<0b0111001100100101>,
             LSX_BIT_6N_DESC_BASE<"vsat.d", uimm6, immZExt6, LSX128DOpnd>;


def VSAT_BU : LSX_I3_U<0b0111001100101000001>,
              LSX_BIT_3N_DESC_BASE<"vsat.bu", uimm3, immZExt3, LSX128BOpnd>;

def VSAT_HU : LSX_I4_U<0b011100110010100001>,
              LSX_BIT_4N_DESC_BASE<"vsat.hu", uimm4, immZExt4, LSX128HOpnd>;

def VSAT_WU : LSX_I5_U<0b01110011001010001>,
              LSX_BIT_5N_DESC_BASE<"vsat.wu", uimm5, immZExt5, LSX128WOpnd>;

def VSAT_DU : LSX_I6_U<0b0111001100101001>,
              LSX_BIT_6N_DESC_BASE<"vsat.du", uimm6, immZExt6, LSX128DOpnd>;


def VSLLI_B : LSX_I3_U<0b0111001100101100001>,
              LSX_BIT_U3_VREPLVE_DESC_BASE<"vslli.b", shl, vsplati8_uimm3, LSX128BOpnd>;

def VSLLI_H : LSX_I4_U<0b011100110010110001>,
              LSX_BIT_U4_VREPLVE_DESC_BASE<"vslli.h", shl, vsplati16_uimm4, LSX128HOpnd>;

def VSLLI_W : LSX_I5_U<0b01110011001011001>,
              LSX_BIT_U5_VREPLVE_DESC_BASE<"vslli.w", shl, vsplati32_uimm5, LSX128WOpnd>;

def VSLLI_D : LSX_I6_U<0b0111001100101101>,
              LSX_BIT_U6_VREPLVE_DESC_BASE<"vslli.d", shl, vsplati64_uimm6, LSX128DOpnd>;


def VSRLI_B : LSX_I3_U<0b0111001100110000001>,
              LSX_BIT_U3_VREPLVE_DESC_BASE<"vsrli.b", srl, vsplati8_uimm3, LSX128BOpnd>;

def VSRLI_H : LSX_I4_U<0b011100110011000001>,
              LSX_BIT_U4_VREPLVE_DESC_BASE<"vsrli.h", srl, vsplati16_uimm4, LSX128HOpnd>;

def VSRLI_W : LSX_I5_U<0b01110011001100001>,
              LSX_BIT_U5_VREPLVE_DESC_BASE<"vsrli.w", srl, vsplati32_uimm5, LSX128WOpnd>;

def VSRLI_D : LSX_I6_U<0b0111001100110001>,
              LSX_BIT_U6_VREPLVE_DESC_BASE<"vsrli.d", srl, vsplati64_uimm6, LSX128DOpnd>;


def VSRAI_B : LSX_I3_U<0b0111001100110100001>,
              LSX_BIT_U3_VREPLVE_DESC_BASE_Intrinsic<"vsrai.b", int_loongarch_lsx_vsrai_b, LSX128BOpnd>;

def VSRAI_H : LSX_I4_U<0b011100110011010001>,
              LSX_BIT_U4_VREPLVE_DESC_BASE_Intrinsic<"vsrai.h", int_loongarch_lsx_vsrai_h, LSX128HOpnd>;

def VSRAI_W : LSX_I5_U<0b01110011001101001>,
              LSX_BIT_U5_VREPLVE_DESC_BASE_Intrinsic<"vsrai.w", int_loongarch_lsx_vsrai_w, LSX128WOpnd>;

def VSRAI_D : LSX_I6_U<0b0111001100110101>,
              LSX_BIT_U6_VREPLVE_DESC_BASE_Intrinsic<"vsrai.d", int_loongarch_lsx_vsrai_d, LSX128DOpnd>;


def VSHUF4I_B : LSX_I8_U<0b01110011100100>,
                LSX_I8_SHF_DESC_BASE<"vshuf4i.b", LSX128BOpnd>;

def VSHUF4I_H : LSX_I8_U<0b01110011100101>,
                LSX_I8_SHF_DESC_BASE<"vshuf4i.h", LSX128HOpnd>;

def VSHUF4I_W : LSX_I8_U<0b01110011100110>,
                LSX_I8_SHF_DESC_BASE<"vshuf4i.w", LSX128WOpnd>;

def VSHUF4I_D : LSX_I8_U<0b01110011100111>,
                LSX_I8_SHUF_DESC_BASE_D<"vshuf4i.d", int_loongarch_lsx_vshuf4i_d, LSX128DOpnd>;


def VROTR_B : LSX_3R<0b01110000111011100>,
              LSX_3R_DESC_BASE<"vrotr.b", LoongArchVROR, LSX128BOpnd>;

def VROTR_H : LSX_3R<0b01110000111011101>,
              LSX_3R_DESC_BASE<"vrotr.h", LoongArchVROR, LSX128HOpnd>;

def VROTR_W : LSX_3R<0b01110000111011110>,
              LSX_3R_DESC_BASE<"vrotr.w", LoongArchVROR, LSX128WOpnd>;

def VROTR_D : LSX_3R<0b01110000111011111>,
              LSX_3R_DESC_BASE<"vrotr.d", LoongArchVROR, LSX128DOpnd>;


def VMSKLTZ_B : LSX_2R<0b0111001010011100010000>,
                LSX_2RN_DESC_BASE<"vmskltz.b", LSX128BOpnd>;

def VMSKLTZ_H : LSX_2R<0b0111001010011100010001>,
                LSX_2RN_DESC_BASE<"vmskltz.h", LSX128HOpnd>;

def VMSKLTZ_W : LSX_2R<0b0111001010011100010010>,
                LSX_2RN_DESC_BASE<"vmskltz.w", LSX128WOpnd>;

def VMSKLTZ_D : LSX_2R<0b0111001010011100010011>,
                LSX_2RN_DESC_BASE<"vmskltz.d", LSX128DOpnd>;


def VROTRI_B : LSX_I3_U<0b0111001010100000001>,
               LSX2_RORI_U3_DESC_BASE<"vrotri.b", uimm3, immZExt3, LSX128BOpnd>;

def VROTRI_H : LSX_I4_U<0b011100101010000001>,
               LSX2_RORI_U4_DESC_BASE<"vrotri.h", uimm4, immZExt4, LSX128HOpnd>;

def VROTRI_W : LSX_I5_U<0b01110010101000001>,
               LSX2_RORI_U5_DESC_BASE<"vrotri.w", uimm5, immZExt5, LSX128WOpnd>;

def VROTRI_D : LSX_I6_U<0b0111001010100001>,
               LSX2_RORI_U6_DESC_BASE<"vrotri.d", uimm6, immZExt6, LSX128DOpnd>;


def VSRLNI_B_H : LSX_I4_U<0b011100110100000001>,
                 LSX_BIND_U4N_DESC_BASE<"vsrlni.b.h", uimm4, immZExt4, LSX128BOpnd>;

def VSRLNI_H_W : LSX_I5_U<0b01110011010000001>,
                 LSX_BIND_U5N_DESC_BASE<"vsrlni.h.w", uimm5, immZExt5, LSX128HOpnd>;

def VSRLNI_W_D : LSX_I6_U<0b0111001101000001>,
                 LSX_BIND_U6N_DESC_BASE<"vsrlni.w.d", uimm6, immZExt6, LSX128WOpnd>;

def VSRLNI_D_Q : LSX_I7_U<0b011100110100001>,
                 LSX_BIND_U7N_DESC_BASE<"vsrlni.d.q", LSX128DOpnd>;


def VSRLRNI_B_H : LSX_I4_U<0b011100110100010001>,
                  LSX_BIND_U4_DESC_BASE<"vsrlrni.b.h", int_loongarch_lsx_vsrlrni_b_h, uimm4, immZExt4, LSX128BOpnd>;

def VSRLRNI_H_W : LSX_I5_U<0b01110011010001001>,
                  LSX_BIND_U5_DESC_BASE<"vsrlrni.h.w", int_loongarch_lsx_vsrlrni_h_w, uimm5, immZExt5, LSX128HOpnd>;

def VSRLRNI_W_D : LSX_I6_U<0b0111001101000101>,
                  LSX_BIND_U6_DESC_BASE<"vsrlrni.w.d", int_loongarch_lsx_vsrlrni_w_d, uimm6, immZExt6, LSX128WOpnd>;

def VSRLRNI_D_Q : LSX_I7_U<0b011100110100011>,
                  LSX_BIND_U7_DESC_BASE<"vsrlrni.d.q", int_loongarch_lsx_vsrlrni_d_q,  LSX128DOpnd>;


def VSSRLNI_B_H : LSX_I4_U<0b011100110100100001>,
                  LSX_BIND_U4N_DESC_BASE<"vssrlni.b.h", uimm4, immZExt4, LSX128BOpnd>;

def VSSRLNI_H_W : LSX_I5_U<0b01110011010010001>,
                  LSX_BIND_U5N_DESC_BASE<"vssrlni.h.w", uimm5, immZExt5, LSX128HOpnd>;

def VSSRLNI_W_D : LSX_I6_U<0b0111001101001001>,
                  LSX_BIND_U6N_DESC_BASE<"vssrlni.w.d", uimm6, immZExt6, LSX128WOpnd>;

def VSSRLNI_D_Q : LSX_I7_U<0b011100110100101>,
                  LSX_BIND_U7N_DESC_BASE<"vssrlni.d.q", LSX128DOpnd>;


def VSSRLNI_BU_H : LSX_I4_U<0b011100110100110001>,
                   LSX_BIND_U4N_DESC_BASE<"vssrlni.bu.h", uimm4, immZExt4, LSX128BOpnd> ;

def VSSRLNI_HU_W : LSX_I5_U<0b01110011010011001>,
                   LSX_BIND_U5N_DESC_BASE<"vssrlni.hu.w", uimm5, immZExt5, LSX128HOpnd>;

def VSSRLNI_WU_D : LSX_I6_U<0b0111001101001101>,
                   LSX_BIND_U6N_DESC_BASE<"vssrlni.wu.d", uimm6, immZExt6, LSX128WOpnd>;

def VSSRLNI_DU_Q : LSX_I7_U<0b011100110100111>,
                   LSX_BIND_U7N_DESC_BASE<"vssrlni.du.q", LSX128DOpnd>;


def VSSRLRNI_BU_H : LSX_I4_U<0b011100110101010001>,
                    LSX_BIND_U4N_DESC_BASE<"vssrlrni.bu.h", uimm4, immZExt4, LSX128BOpnd>;

def VSSRLRNI_HU_W : LSX_I5_U<0b01110011010101001>,
                    LSX_BIND_U5N_DESC_BASE<"vssrlrni.hu.w", uimm5, immZExt5, LSX128HOpnd>;

def VSSRLRNI_WU_D : LSX_I6_U<0b0111001101010101>,
                    LSX_BIND_U6N_DESC_BASE<"vssrlrni.wu.d", uimm6, immZExt6, LSX128WOpnd>;

def VSSRLRNI_DU_Q : LSX_I7_U<0b011100110101011>,
                    LSX_BIND_U7N_DESC_BASE<"vssrlrni.du.q", LSX128DOpnd>;


def VSRARNI_B_H : LSX_I4_U<0b011100110101110001>,
                  LSX_BIND_U4N_DESC_BASE<"vsrarni.b.h", uimm4, immZExt4, LSX128BOpnd>;

def VSRARNI_H_W : LSX_I5_U<0b01110011010111001>,
                  LSX_BIND_U5N_DESC_BASE<"vsrarni.h.w", uimm5, immZExt5, LSX128HOpnd>;

def VSRARNI_W_D : LSX_I6_U<0b0111001101011101>,
                  LSX_BIND_U6N_DESC_BASE<"vsrarni.w.d", uimm6, immZExt6, LSX128WOpnd>;

def VSRARNI_D_Q : LSX_I7_U<0b011100110101111>,
                  LSX_BIND_U7N_DESC_BASE<"vsrarni.d.q", LSX128DOpnd>;


def VSSRANI_B_H : LSX_I4_U<0b011100110110000001>,
                  LSX_BIND_U4N_DESC_BASE<"vssrani.b.h", uimm4, immZExt4, LSX128BOpnd>;

def VSSRANI_H_W : LSX_I5_U<0b01110011011000001>,
                  LSX_BIND_U5N_DESC_BASE<"vssrani.h.w", uimm5, immZExt5, LSX128HOpnd>;

def VSSRANI_W_D : LSX_I6_U<0b0111001101100001>,
                  LSX_BIND_U6N_DESC_BASE<"vssrani.w.d", uimm6, immZExt6, LSX128WOpnd>;

def VSSRANI_D_Q : LSX_I7_U<0b011100110110001>,
                  LSX_BIND_U7N_DESC_BASE<"vssrani.d.q", LSX128DOpnd>;


def VSSRANI_BU_H : LSX_I4_U<0b011100110110010001>,
                   LSX_BIND_U4N_DESC_BASE<"vssrani.bu.h", uimm4, immZExt4, LSX128BOpnd>;

def VSSRANI_HU_W : LSX_I5_U<0b01110011011001001>,
                   LSX_BIND_U5N_DESC_BASE<"vssrani.hu.w", uimm5, immZExt5, LSX128HOpnd>;

def VSSRANI_WU_D : LSX_I6_U<0b0111001101100101>,
                   LSX_BIND_U6N_DESC_BASE<"vssrani.wu.d", uimm6, immZExt6, LSX128WOpnd>;

def VSSRANI_DU_Q : LSX_I7_U<0b011100110110011>,
                   LSX_BIND_U7N_DESC_BASE<"vssrani.du.q", LSX128DOpnd>;


def VSSRARNI_B_H : LSX_I4_U<0b011100110110100001>,
                   LSX_BIND_U4N_DESC_BASE<"vssrarni.b.h", uimm4, immZExt4, LSX128BOpnd>;

def VSSRARNI_H_W : LSX_I5_U<0b01110011011010001>,
                   LSX_BIND_U5N_DESC_BASE<"vssrarni.h.w", uimm5, immZExt5, LSX128HOpnd>;

def VSSRARNI_W_D : LSX_I6_U<0b0111001101101001>,
                   LSX_BIND_U6N_DESC_BASE<"vssrarni.w.d", uimm6, immZExt6, LSX128WOpnd>;

def VSSRARNI_D_Q : LSX_I7_U<0b011100110110101>,
                   LSX_BIND_U7N_DESC_BASE<"vssrarni.d.q", LSX128DOpnd>;


def VSSRARNI_BU_H : LSX_I4_U<0b011100110110110001>,
                    LSX_BIND_U4N_DESC_BASE<"vssrarni.bu.h", uimm4, immZExt4, LSX128BOpnd>;

def VSSRARNI_HU_W : LSX_I5_U<0b01110011011011001>,
                    LSX_BIND_U5N_DESC_BASE<"vssrarni.hu.w", uimm5, immZExt5, LSX128HOpnd>;

def VSSRARNI_WU_D : LSX_I6_U<0b0111001101101101>,
                    LSX_BIND_U6N_DESC_BASE<"vssrarni.wu.d", uimm6, immZExt6, LSX128WOpnd>;

def VSSRARNI_DU_Q : LSX_I7_U<0b011100110110111>,
                    LSX_BIND_U7N_DESC_BASE<"vssrarni.du.q", LSX128DOpnd>;



def VLD : LSX_I12_S<0b0010110000>,
          LD_DESC_BASE<"vld", load, v16i8, LSX128BOpnd, mem>;

def VST : LSX_I12_S<0b0010110001>,
          ST_DESC_BASE<"vst", store, v16i8, LSX128BOpnd, mem_simm12>;


def VSETEQZ_V : LSX_SET<0b0111001010011100100110>,
                LSX_SET_DESC_BASE<"vseteqz.v", LSX128BOpnd>;

def VSETNEZ_V : LSX_SET<0b0111001010011100100111>,
                LSX_SET_DESC_BASE<"vsetnez.v", LSX128BOpnd>;


def VSETANYEQZ_B : LSX_SET<0b0111001010011100101000>,
                   LSX_SET_DESC_BASE<"vsetanyeqz.b", LSX128BOpnd>;

def VSETANYEQZ_H : LSX_SET<0b0111001010011100101001>,
                   LSX_SET_DESC_BASE<"vsetanyeqz.h", LSX128HOpnd>;

def VSETANYEQZ_W : LSX_SET<0b0111001010011100101010>,
                   LSX_SET_DESC_BASE<"vsetanyeqz.w", LSX128WOpnd>;

def VSETANYEQZ_D : LSX_SET<0b0111001010011100101011>,
                   LSX_SET_DESC_BASE<"vsetanyeqz.d", LSX128DOpnd>;


def VSETALLNEZ_B : LSX_SET<0b0111001010011100101100>,
                   LSX_SET_DESC_BASE<"vsetallnez.b", LSX128BOpnd>;

def VSETALLNEZ_H : LSX_SET<0b0111001010011100101101>,
                   LSX_SET_DESC_BASE<"vsetallnez.h", LSX128HOpnd>;

def VSETALLNEZ_W : LSX_SET<0b0111001010011100101110>,
                   LSX_SET_DESC_BASE<"vsetallnez.w", LSX128WOpnd>;

def VSETALLNEZ_D : LSX_SET<0b0111001010011100101111>,
                   LSX_SET_DESC_BASE<"vsetallnez.d", LSX128DOpnd>;

class LSX_CBRANCH_PSEUDO_DESC_BASE<SDPatternOperator OpNode, ValueType TyNode,
                                   RegisterClass RCVS> :
  LoongArchPseudo<(outs GPR32Opnd:$rd),
             (ins RCVS:$vj),
             [(set GPR32Opnd:$rd, (OpNode (TyNode RCVS:$vj)))]> {
  bit usesCustomInserter = 1;
}

def SNZ_B_PSEUDO : LSX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lsx_bnz_b, v16i8,
                                                LSX128B>;
def SNZ_H_PSEUDO : LSX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lsx_bnz_h, v8i16,
                                                LSX128H>;
def SNZ_W_PSEUDO : LSX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lsx_bnz_w, v4i32,
                                                LSX128W>;
def SNZ_D_PSEUDO : LSX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lsx_bnz_d, v2i64,
                                                LSX128D>;
def SNZ_V_PSEUDO : LSX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lsx_bnz_v, v16i8,
                                                LSX128B>;

def SZ_B_PSEUDO : LSX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lsx_bz_b, v16i8,
                                               LSX128B>;
def SZ_H_PSEUDO : LSX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lsx_bz_h, v8i16,
                                               LSX128H>;
def SZ_W_PSEUDO : LSX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lsx_bz_w, v4i32,
                                               LSX128W>;
def SZ_D_PSEUDO : LSX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lsx_bz_d, v2i64,
                                               LSX128D>;
def SZ_V_PSEUDO : LSX_CBRANCH_PSEUDO_DESC_BASE<int_loongarch_lsx_bz_v, v16i8,
                                               LSX128B>;


def VFMADD_S  : LSX_VR4MUL<0b000010010001>,
                LSX_4RF<"vfmadd.s", int_loongarch_lsx_vfmadd_s, LSX128WOpnd>;

def VFMADD_D  : LSX_VR4MUL<0b000010010010>,
                LSX_4RF<"vfmadd.d", int_loongarch_lsx_vfmadd_d, LSX128DOpnd>;

def VFMSUB_S  : LSX_VR4MUL<0b000010010101>,
                LSX_4RF<"vfmsub.s", int_loongarch_lsx_vfmsub_s, LSX128WOpnd>;

def VFMSUB_D  : LSX_VR4MUL<0b000010010110>,
                LSX_4RF<"vfmsub.d", int_loongarch_lsx_vfmsub_d, LSX128DOpnd>;

def VFNMADD_S : LSX_VR4MUL<0b000010011001>,
                LSX_4RF<"vfnmadd.s", int_loongarch_lsx_vfnmadd_s, LSX128WOpnd>;

def VFNMADD_D : LSX_VR4MUL<0b000010011010>,
                LSX_4RF<"vfnmadd.d", int_loongarch_lsx_vfnmadd_d, LSX128DOpnd>;

def VFNMSUB_S : LSX_VR4MUL<0b000010011101>,
                LSX_4RF<"vfnmsub.s", int_loongarch_lsx_vfnmsub_s, LSX128WOpnd>;

def VFNMSUB_D : LSX_VR4MUL<0b000010011110>,
                LSX_4RF<"vfnmsub.d", int_loongarch_lsx_vfnmsub_d, LSX128DOpnd>;


// vfmadd: vj * vk + va
def : LSXPat<(fma v2f64:$vj, v2f64:$vk, v2f64:$va),
             (VFMADD_D $vj, $vk, $va)>;

def : LSXPat<(fma v4f32:$vj, v4f32:$vk, v4f32:$va),
             (VFMADD_S $vj, $vk, $va)>;


// vfmsub: vj * vk - va
def : LSXPat<(fma v2f64:$vj, v2f64:$vk, (fneg v2f64:$va)),
             (VFMSUB_D v2f64:$vj, v2f64:$vk, v2f64:$va)>;

def : LSXPat<(fma v4f32:$vj, v4f32:$vk, (fneg v4f32:$va)),
             (VFMSUB_S v4f32:$vj, v4f32:$vk, v4f32:$va)>;


// vfnmadd: -(vj * vk + va)
def : LSXPat<(fma (fneg v2f64:$vj), v2f64:$vk, (fneg v2f64:$va)),
             (VFNMADD_D v2f64:$vj, v2f64:$vk, v2f64:$va)>;

def : LSXPat<(fma (fneg v4f32:$vj), v4f32:$vk, (fneg v4f32:$va)),
             (VFNMADD_S v4f32:$vj, v4f32:$vk, v4f32:$va)>;

// vfnmsub: -(vj * vk - va)
def : LSXPat<(fma (fneg v2f64:$vj), v2f64:$vk, v2f64:$va),
             (VFNMSUB_D v2f64:$vj, v2f64:$vk, v2f64:$va)>;

def : LSXPat<(fma (fneg v4f32:$vj), v4f32:$vk, v4f32:$va),
             (VFNMSUB_S v4f32:$vj, v4f32:$vk, v4f32:$va)>;


def VFCMP_CAF_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.caf.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_caf_s>{
                    bits<5> cond=0x0;
                  }

def VFCMP_CAF_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.caf.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_caf_d>{
                    bits<5> cond=0x0;
                  }


def VFCMP_COR_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.cor.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, vfsetord_v4f32>{
                  bits<5> cond=0x14;
                }

def VFCMP_COR_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.cor.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, vfsetord_v2f64>{
                    bits<5> cond=0x14;
                  }


def VFCMP_CUN_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.cun.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, vfsetun_v4f32>{
                    bits<5> cond=0x8;
                  }

def VFCMP_CUN_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.cun.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, vfsetun_v2f64>{
                    bits<5> cond=0x8;
                  }


def VFCMP_CUNE_S : LSX_VFCMP<0b000011000101>,
                   LSX_VFCMP_Reg3<"vfcmp.cune.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, vfsetune_v4f32>{
                    bits<5> cond=0x18;
                  }

def VFCMP_CUNE_D : LSX_VFCMP<0b000011000110>,
                   LSX_VFCMP_Reg3<"vfcmp.cune.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, vfsetune_v2f64>{
                    bits<5> cond=0x18;
                  }


def VFCMP_CUEQ_S : LSX_VFCMP<0b000011000101>,
                   LSX_VFCMP_Reg3<"vfcmp.cueq.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, vfsetueq_v4f32>{
                    bits<5> cond=0xc;
                  }

def VFCMP_CUEQ_D : LSX_VFCMP<0b000011000110>,
                   LSX_VFCMP_Reg3<"vfcmp.cueq.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, vfsetueq_v2f64>{
                    bits<5> cond=0xc;
                  }

def VFCMP_CEQ_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.ceq.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, vfsetoeq_v4f32>{
                  bits<5> cond=0x4;
                }

def VFCMP_CEQ_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.ceq.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, vfsetoeq_v2f64>{
                    bits<5> cond=0x4;
                  }


def VFCMP_CNE_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.cne.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, vfsetone_v4f32>{
                    bits<5> cond=0x10;
                  }

def VFCMP_CNE_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.cne.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, vfsetone_v2f64>{
                    bits<5> cond=0x10;
                  }


def VFCMP_CLT_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.clt.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, vfsetolt_v4f32>{
                    bits<5> cond=0x2;
                  }

def VFCMP_CLT_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.clt.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, vfsetolt_v2f64>{
                    bits<5> cond=0x2;
                  }


def VFCMP_CULT_S : LSX_VFCMP<0b000011000101>,
                   LSX_VFCMP_Reg3<"vfcmp.cult.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, vfsetult_v4f32>{
                    bits<5> cond=0xa;
                  }

def VFCMP_CULT_D : LSX_VFCMP<0b000011000110>,
                   LSX_VFCMP_Reg3<"vfcmp.cult.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, vfsetult_v2f64>{
                    bits<5> cond=0xa;
                  }


def VFCMP_CLE_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.cle.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, vfsetole_v4f32>{
                    bits<5> cond=0x6;
                  }

def VFCMP_CLE_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.cle.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, vfsetole_v2f64>{
                    bits<5> cond=0x6;
                  }


def VFCMP_CULE_S : LSX_VFCMP<0b000011000101>,
                   LSX_VFCMP_Reg3<"vfcmp.cule.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, vfsetule_v4f32>{
                    bits<5> cond=0xe;
                  }

def VFCMP_CULE_D : LSX_VFCMP<0b000011000110>,
                   LSX_VFCMP_Reg3<"vfcmp.cule.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, vfsetule_v2f64>{
                    bits<5> cond=0xe;
                  }


def VFCMP_SAF_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.saf.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_saf_s>{
                    bits<5> cond=0x1;
                  }

def VFCMP_SAF_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.saf.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_saf_d>{
                    bits<5> cond=0x1;
                  }

def VFCMP_SOR_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.sor.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_sor_s>{
                    bits<5> cond=0x15;
                  }

def VFCMP_SOR_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.sor.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_sor_d>{
                    bits<5> cond=0x15;
                  }

def VFCMP_SUN_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.sun.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_sun_s>{
                    bits<5> cond=0x9;
                  }

def VFCMP_SUN_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.sun.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_sun_d>{
                    bits<5> cond=0x9;
                  }

def VFCMP_SUNE_S : LSX_VFCMP<0b000011000101>,
                   LSX_VFCMP_Reg3<"vfcmp.sune.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_sune_s>{
                    bits<5> cond=0x19;
                  }

def VFCMP_SUNE_D : LSX_VFCMP<0b000011000110>,
                   LSX_VFCMP_Reg3<"vfcmp.sune.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_sune_d>{
                    bits<5> cond=0x19;
                  }

def VFCMP_SUEQ_S : LSX_VFCMP<0b000011000101>,
                   LSX_VFCMP_Reg3<"vfcmp.sueq.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_sueq_s>{
                    bits<5> cond=0xd;
                  }

def VFCMP_SUEQ_D : LSX_VFCMP<0b000011000110>,
                   LSX_VFCMP_Reg3<"vfcmp.sueq.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_sueq_d>{
                    bits<5> cond=0xd;
                  }

def VFCMP_SEQ_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.seq.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_seq_s>{
                    bits<5> cond=0x5;
                  }

def VFCMP_SEQ_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.seq.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_seq_d>{
                    bits<5> cond=0x5;
                  }

def VFCMP_SNE_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.sne.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_sne_s>{
                    bits<5> cond=0x11;
                  }

def VFCMP_SNE_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.sne.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_sne_d>{
                    bits<5> cond=0x11;
                  }

def VFCMP_SLT_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.slt.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_slt_s>{
                    bits<5> cond=0x3;
                  }

def VFCMP_SLT_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.slt.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_slt_d>{
                    bits<5> cond=0x3;
                  }

def VFCMP_SULT_S : LSX_VFCMP<0b000011000101>,
                   LSX_VFCMP_Reg3<"vfcmp.sult.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_sult_s>{
                    bits<5> cond=0xb;
                  }

def VFCMP_SULT_D : LSX_VFCMP<0b000011000110>,
                   LSX_VFCMP_Reg3<"vfcmp.sult.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_sult_d>{
                    bits<5> cond=0xb;
                  }

def VFCMP_SLE_S : LSX_VFCMP<0b000011000101>,
                  LSX_VFCMP_Reg3<"vfcmp.sle.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_sle_s>{
                    bits<5> cond=0x7;
                  }

def VFCMP_SLE_D : LSX_VFCMP<0b000011000110>,
                  LSX_VFCMP_Reg3<"vfcmp.sle.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_sle_d>{
                    bits<5> cond=0x7;
                  }

def VFCMP_SULE_S : LSX_VFCMP<0b000011000101>,
                   LSX_VFCMP_Reg3<"vfcmp.sule.s", LSX128WOpnd, LSX128WOpnd, LSX128WOpnd, int_loongarch_lsx_vfcmp_sule_s>{
                    bits<5> cond=0xf;
                  }

def VFCMP_SULE_D : LSX_VFCMP<0b000011000110>,
                   LSX_VFCMP_Reg3<"vfcmp.sule.d", LSX128DOpnd, LSX128DOpnd, LSX128DOpnd, int_loongarch_lsx_vfcmp_sule_d>{
                    bits<5> cond=0xf;
                  }

def VBITSEL_V  : LSX_VR4MUL<0b000011010001>,
                 LSX_VMul_Reg4<"vbitsel.v", LSX128BOpnd, LSX128BOpnd, LSX128BOpnd, LSX128BOpnd, int_loongarch_lsx_vbitsel_v>;

def VSHUF_B  : LSX_VR4MUL<0b000011010101>,
               LSX_3R_4R_VSHF_DESC_BASE<"vshuf.b", LSX128BOpnd>;


class LSX_BSEL_PSEUDO_BASE<RegisterOperand RO, ValueType Ty> :
  LSXPseudo<(outs RO:$vd), (ins RO:$vd_in, RO:$vs, RO:$vt),
            [(set RO:$vd, (Ty (vselect RO:$vd_in, RO:$vt, RO:$vs)))]>,
  PseudoInstExpansion<(VBITSEL_V LSX128BOpnd:$vd, LSX128BOpnd:$vs,
                                 LSX128BOpnd:$vt, LSX128BOpnd:$vd_in)> {
  let Constraints = "$vd_in = $vd";
}

def BSEL_B_PSEUDO : LSX_BSEL_PSEUDO_BASE<LSX128BOpnd, v16i8>;
def BSEL_H_PSEUDO : LSX_BSEL_PSEUDO_BASE<LSX128HOpnd, v8i16>;
def BSEL_W_PSEUDO : LSX_BSEL_PSEUDO_BASE<LSX128WOpnd, v4i32>;
def BSEL_D_PSEUDO : LSX_BSEL_PSEUDO_BASE<LSX128DOpnd, v2i64>;
def BSEL_FW_PSEUDO : LSX_BSEL_PSEUDO_BASE<LSX128WOpnd, v4f32>;
def BSEL_FD_PSEUDO : LSX_BSEL_PSEUDO_BASE<LSX128DOpnd, v2f64>;


class LSX_LD_DESC_BASE<string instr_asm, SDPatternOperator OpNode,
                         ValueType TyNode, RegisterOperand ROVD,
                                 Operand MemOpnd = mem,
                                 ComplexPattern Addr = addr> {
  dag OutOperandList = (outs ROVD:$vd);
  dag InOperandList = (ins MemOpnd:$addr);
  string AsmString = !strconcat(instr_asm, "\t$vd, $addr");
  list<dag> Pattern = [(set ROVD:$vd, (OpNode (TyNode (load Addr:$addr))))];
  string DecoderMethod = "DecodeLSX128memlsl";
}

def VLDREPL_B : LSX_SI12_S<0b0011000010>,
                LSX_LD_DESC_BASE<"vldrepl.b", vldrepl_v16i8,  v16i8, LSX128BOpnd>;

def VLDREPL_H : LSX_SI11_S<0b00110000010>,
                LSX_LD_DESC_BASE<"vldrepl.h", vldrepl_v8i16, v8i16, LSX128HOpnd, mem_simm11_lsl1, addrimm11lsl1>;

def VLDREPL_W : LSX_SI10_S<0b001100000010>,
                LSX_LD_DESC_BASE<"vldrepl.w", vldrepl_v4i32, v4i32, LSX128WOpnd, mem_simm10_lsl2, addrimm10lsl2>;

def VLDREPL_D : LSX_SI9_S<0b0011000000010>,
                LSX_LD_DESC_BASE<"vldrepl.d", vldrepl_v2i64,  v2i64, LSX128DOpnd,  mem_simm9_lsl3, addrimm9lsl3>;


def VSTELM_B : LSX_SI8_idx4<0b0011000110>,
               LSX_I8_U4_DESC_BASE<"vstelm.b", int_loongarch_lsx_vstelm_b, simm8_32, immSExt8, LSX128BOpnd>;

def VSTELM_H : LSX_SI8_idx3<0b00110001010>,
               LSX_I8_U3_DESC_BASE<"vstelm.h", int_loongarch_lsx_vstelm_h, immSExt8_1_O, immSExt8, LSX128HOpnd>;

def VSTELM_W : LSX_SI8_idx2<0b001100010010>,
               LSX_I8_U2_DESC_BASE<"vstelm.w", int_loongarch_lsx_vstelm_w, immSExt8_2_O, immSExt8, LSX128WOpnd>;

def VSTELM_D : LSX_SI8_idx1<0b0011000100010>,
               LSX_I8_U1_DESC_BASE<"vstelm.d", int_loongarch_lsx_vstelm_d, immSExt8_3_O, immSExt8, LSX128DOpnd>;


let mayLoad = 1, canFoldAsLoad = 1 in {
 def VLDX : LSX_3R_2GP<0b00111000010000000>,
            LSX_LDX_LA<"vldx", int_loongarch_lsx_vldx, GPR64Opnd, LSX128BOpnd>;
}

let mayStore = 1 in{
 def VSTX : LSX_3R_2GP<0b00111000010001000>,
            LSX_SDX_LA<"vstx", int_loongarch_lsx_vstx, GPR64Opnd, LSX128BOpnd>;
}


def VADDWEV_H_B : LSX_3R<0b01110000000111100>,
                  LSX_3R_DESC_BASE<"vaddwev.h.b", int_loongarch_lsx_vaddwev_h_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VADDWEV_W_H : LSX_3R<0b01110000000111101>,
                  LSX_3R_DESC_BASE<"vaddwev.w.h", int_loongarch_lsx_vaddwev_w_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VADDWEV_D_W : LSX_3R<0b01110000000111110>,
                  LSX_3R_DESC_BASE<"vaddwev.d.w", int_loongarch_lsx_vaddwev_d_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VADDWEV_Q_D : LSX_3R<0b01110000000111111>,
                  LSX_3R_DESC_BASE<"vaddwev.q.d", int_loongarch_lsx_vaddwev_q_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSUBWEV_H_B : LSX_3R<0b01110000001000000>,
                  LSX_3R_DESC_BASE<"vsubwev.h.b", int_loongarch_lsx_vsubwev_h_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VSUBWEV_W_H : LSX_3R<0b01110000001000001>,
                  LSX_3R_DESC_BASE<"vsubwev.w.h", int_loongarch_lsx_vsubwev_w_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSUBWEV_D_W : LSX_3R<0b01110000001000010>,
                  LSX_3R_DESC_BASE<"vsubwev.d.w", int_loongarch_lsx_vsubwev_d_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VSUBWEV_Q_D : LSX_3R<0b01110000001000011>,
                  LSX_3R_DESC_BASE<"vsubwev.q.d", int_loongarch_lsx_vsubwev_q_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VADDWOD_H_B : LSX_3R<0b01110000001000100>,
                  LSX_3R_DESC_BASE<"vaddwod.h.b", int_loongarch_lsx_vaddwod_h_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VADDWOD_W_H : LSX_3R<0b01110000001000101>,
                  LSX_3R_DESC_BASE<"vaddwod.w.h", int_loongarch_lsx_vaddwod_w_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VADDWOD_D_W : LSX_3R<0b01110000001000110>,
                  LSX_3R_DESC_BASE<"vaddwod.d.w", int_loongarch_lsx_vaddwod_d_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VADDWOD_Q_D : LSX_3R<0b01110000001000111>,
                  LSX_3R_DESC_BASE<"vaddwod.q.d", int_loongarch_lsx_vaddwod_q_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSUBWOD_H_B : LSX_3R<0b01110000001001000>,
                  LSX_3R_DESC_BASE<"vsubwod.h.b", int_loongarch_lsx_vsubwod_h_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VSUBWOD_W_H : LSX_3R<0b01110000001001001>,
                  LSX_3R_DESC_BASE<"vsubwod.w.h", int_loongarch_lsx_vsubwod_w_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSUBWOD_D_W : LSX_3R<0b01110000001001010>,
                  LSX_3R_DESC_BASE<"vsubwod.d.w", int_loongarch_lsx_vsubwod_d_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VSUBWOD_Q_D : LSX_3R<0b01110000001001011>,
                  LSX_3R_DESC_BASE<"vsubwod.q.d", int_loongarch_lsx_vsubwod_q_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VADDWEV_H_BU : LSX_3R<0b01110000001011100>,
                   LSX_3R_DESC_BASE<"vaddwev.h.bu", int_loongarch_lsx_vaddwev_h_bu, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VADDWEV_W_HU : LSX_3R<0b01110000001011101>,
                   LSX_3R_DESC_BASE<"vaddwev.w.hu", int_loongarch_lsx_vaddwev_w_hu, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VADDWEV_D_WU : LSX_3R<0b01110000001011110>,
                   LSX_3R_DESC_BASE<"vaddwev.d.wu", int_loongarch_lsx_vaddwev_d_wu, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VADDWEV_Q_DU : LSX_3R<0b01110000001011111>,
                   LSX_3R_DESC_BASE<"vaddwev.q.du", int_loongarch_lsx_vaddwev_q_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSUBWEV_H_BU : LSX_3R<0b01110000001100000>,
                   LSX_3R_DESC_BASE<"vsubwev.h.bu", int_loongarch_lsx_vsubwev_h_bu, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VSUBWEV_W_HU : LSX_3R<0b01110000001100001>,
                   LSX_3R_DESC_BASE<"vsubwev.w.hu", int_loongarch_lsx_vsubwev_w_hu, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSUBWEV_D_WU : LSX_3R<0b01110000001100010>,
                   LSX_3R_DESC_BASE<"vsubwev.d.wu", int_loongarch_lsx_vsubwev_d_wu, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VSUBWEV_Q_DU : LSX_3R<0b01110000001100011>,
                   LSX_3R_DESC_BASE<"vsubwev.q.du", int_loongarch_lsx_vsubwev_q_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VADDWOD_H_BU : LSX_3R<0b01110000001100100>,
                   LSX_3R_DESC_BASE<"vaddwod.h.bu", int_loongarch_lsx_vaddwod_h_bu, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VADDWOD_W_HU : LSX_3R<0b01110000001100101>,
                   LSX_3R_DESC_BASE<"vaddwod.w.hu", int_loongarch_lsx_vaddwod_w_hu, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VADDWOD_D_WU : LSX_3R<0b01110000001100110>,
                   LSX_3R_DESC_BASE<"vaddwod.d.wu", int_loongarch_lsx_vaddwod_d_wu, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VADDWOD_Q_DU : LSX_3R<0b01110000001100111>,
                   LSX_3R_DESC_BASE<"vaddwod.q.du", int_loongarch_lsx_vaddwod_q_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSUBWOD_H_BU : LSX_3R<0b01110000001101000>,
                   LSX_3R_DESC_BASE<"vsubwod.h.bu", int_loongarch_lsx_vsubwod_h_bu, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VSUBWOD_W_HU : LSX_3R<0b01110000001101001>,
                   LSX_3R_DESC_BASE<"vsubwod.w.hu", int_loongarch_lsx_vsubwod_w_hu, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSUBWOD_D_WU : LSX_3R<0b01110000001101010>,
                   LSX_3R_DESC_BASE<"vsubwod.d.wu", int_loongarch_lsx_vsubwod_d_wu, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VSUBWOD_Q_DU : LSX_3R<0b01110000001101011>,
                   LSX_3R_DESC_BASE<"vsubwod.q.du", int_loongarch_lsx_vsubwod_q_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VADDWEV_H_BU_B : LSX_3R<0b01110000001111100>,
                     LSX_3R_DESC_BASE<"vaddwev.h.bu.b", int_loongarch_lsx_vaddwev_h_bu_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VADDWEV_W_HU_H : LSX_3R<0b01110000001111101>,
                     LSX_3R_DESC_BASE<"vaddwev.w.hu.h", int_loongarch_lsx_vaddwev_w_hu_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VADDWEV_D_WU_W : LSX_3R<0b01110000001111110>,
                     LSX_3R_DESC_BASE<"vaddwev.d.wu.w", int_loongarch_lsx_vaddwev_d_wu_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VADDWEV_Q_DU_D : LSX_3R<0b01110000001111111>,
                     LSX_3R_DESC_BASE<"vaddwev.q.du.d", int_loongarch_lsx_vaddwev_q_du_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VADDWOD_H_BU_B : LSX_3R<0b01110000010000000>,
                     LSX_3R_DESC_BASE<"vaddwod.h.bu.b", int_loongarch_lsx_vaddwod_h_bu_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VADDWOD_W_HU_H : LSX_3R<0b01110000010000001>,
                     LSX_3R_DESC_BASE<"vaddwod.w.hu.h", int_loongarch_lsx_vaddwod_w_hu_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VADDWOD_D_WU_W : LSX_3R<0b01110000010000010>,
                     LSX_3R_DESC_BASE<"vaddwod.d.wu.w", int_loongarch_lsx_vaddwod_d_wu_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VADDWOD_Q_DU_D : LSX_3R<0b01110000010000011>,
                     LSX_3R_DESC_BASE<"vaddwod.q.du.d", int_loongarch_lsx_vaddwod_q_du_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VHADDW_Q_D : LSX_3R<0b01110000010101011>,
                 LSX_3R_DESC_BASE<"vhaddw.q.d", int_loongarch_lsx_vhaddw_q_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;

def VHSUBW_Q_D : LSX_3R<0b01110000010101111>,
                 LSX_3R_DESC_BASE<"vhsubw.q.d", int_loongarch_lsx_vhsubw_q_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VHADDW_QU_DU : LSX_3R<0b01110000010110011>,
                   LSX_3R_DESC_BASE<"vhaddw.qu.du", int_loongarch_lsx_vhaddw_qu_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;

def VHSUBW_QU_DU : LSX_3R<0b01110000010110111>,
                   LSX_3R_DESC_BASE<"vhsubw.qu.du", int_loongarch_lsx_vhsubw_qu_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMUH_B : LSX_3R<0b01110000100001100>,
             LSX_3R_DESC_BASE<"vmuh.b", int_loongarch_lsx_vmuh_b, LSX128BOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMUH_H : LSX_3R<0b01110000100001101>,
             LSX_3R_DESC_BASE<"vmuh.h", int_loongarch_lsx_vmuh_h, LSX128HOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMUH_W : LSX_3R<0b01110000100001110>,
             LSX_3R_DESC_BASE<"vmuh.w", int_loongarch_lsx_vmuh_w, LSX128WOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VMUH_D : LSX_3R<0b01110000100001111>,
             LSX_3R_DESC_BASE<"vmuh.d", int_loongarch_lsx_vmuh_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMUH_BU : LSX_3R<0b01110000100010000>,
              LSX_3R_DESC_BASE<"vmuh.bu", int_loongarch_lsx_vmuh_bu, LSX128BOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMUH_HU : LSX_3R<0b01110000100010001>,
              LSX_3R_DESC_BASE<"vmuh.hu", int_loongarch_lsx_vmuh_hu, LSX128HOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMUH_WU : LSX_3R<0b01110000100010010>,
              LSX_3R_DESC_BASE<"vmuh.wu", int_loongarch_lsx_vmuh_wu, LSX128WOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VMUH_DU : LSX_3R<0b01110000100010011>,
              LSX_3R_DESC_BASE<"vmuh.du", int_loongarch_lsx_vmuh_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMULWEV_H_B : LSX_3R<0b01110000100100000>,
                  LSX_3R_DESC_BASE<"vmulwev.h.b", int_loongarch_lsx_vmulwev_h_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMULWEV_W_H : LSX_3R<0b01110000100100001>,
                  LSX_3R_DESC_BASE<"vmulwev.w.h", int_loongarch_lsx_vmulwev_w_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMULWEV_D_W : LSX_3R<0b01110000100100010>,
                  LSX_3R_DESC_BASE<"vmulwev.d.w", int_loongarch_lsx_vmulwev_d_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VMULWEV_Q_D : LSX_3R<0b01110000100100011>,
                  LSX_3R_DESC_BASE<"vmulwev.q.d", int_loongarch_lsx_vmulwev_q_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMULWOD_H_B : LSX_3R<0b01110000100100100>,
                  LSX_3R_DESC_BASE<"vmulwod.h.b", int_loongarch_lsx_vmulwod_h_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMULWOD_W_H : LSX_3R<0b01110000100100101>,
                  LSX_3R_DESC_BASE<"vmulwod.w.h", int_loongarch_lsx_vmulwod_w_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMULWOD_D_W : LSX_3R<0b01110000100100110>,
                  LSX_3R_DESC_BASE<"vmulwod.d.w", int_loongarch_lsx_vmulwod_d_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VMULWOD_Q_D : LSX_3R<0b01110000100100111>,
                  LSX_3R_DESC_BASE<"vmulwod.q.d", int_loongarch_lsx_vmulwod_q_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMULWEV_H_BU : LSX_3R<0b01110000100110000>,
                   LSX_3R_DESC_BASE<"vmulwev.h.bu", int_loongarch_lsx_vmulwev_h_bu, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMULWEV_W_HU : LSX_3R<0b01110000100110001>,
                   LSX_3R_DESC_BASE<"vmulwev.w.hu", int_loongarch_lsx_vmulwev_w_hu, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMULWEV_D_WU : LSX_3R<0b01110000100110010>,
                   LSX_3R_DESC_BASE<"vmulwev.d.wu", int_loongarch_lsx_vmulwev_d_wu, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VMULWEV_Q_DU : LSX_3R<0b01110000100110011>,
                   LSX_3R_DESC_BASE<"vmulwev.q.du", int_loongarch_lsx_vmulwev_q_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMULWOD_H_BU : LSX_3R<0b01110000100110100>,
                   LSX_3R_DESC_BASE<"vmulwod.h.bu", int_loongarch_lsx_vmulwod_h_bu, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMULWOD_W_HU : LSX_3R<0b01110000100110101>,
                   LSX_3R_DESC_BASE<"vmulwod.w.hu", int_loongarch_lsx_vmulwod_w_hu, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMULWOD_D_WU : LSX_3R<0b01110000100110110>,
                   LSX_3R_DESC_BASE<"vmulwod.d.wu", int_loongarch_lsx_vmulwod_d_wu, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VMULWOD_Q_DU : LSX_3R<0b01110000100110111>,
                   LSX_3R_DESC_BASE<"vmulwod.q.du", int_loongarch_lsx_vmulwod_q_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMULWEV_H_BU_B : LSX_3R<0b01110000101000000>,
                     LSX_3R_DESC_BASE<"vmulwev.h.bu.b", int_loongarch_lsx_vmulwev_h_bu_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMULWEV_W_HU_H : LSX_3R<0b01110000101000001>,
                     LSX_3R_DESC_BASE<"vmulwev.w.hu.h", int_loongarch_lsx_vmulwev_w_hu_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMULWEV_D_WU_W : LSX_3R<0b01110000101000010>,
                     LSX_3R_DESC_BASE<"vmulwev.d.wu.w", int_loongarch_lsx_vmulwev_d_wu_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VMULWEV_Q_DU_D : LSX_3R<0b01110000101000011>,
                     LSX_3R_DESC_BASE<"vmulwev.q.du.d", int_loongarch_lsx_vmulwev_q_du_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMULWOD_H_BU_B : LSX_3R<0b01110000101000100>,
                     LSX_3R_DESC_BASE<"vmulwod.h.bu.b", int_loongarch_lsx_vmulwod_h_bu_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMULWOD_W_HU_H : LSX_3R<0b01110000101000101>,
                     LSX_3R_DESC_BASE<"vmulwod.w.hu.h", int_loongarch_lsx_vmulwod_w_hu_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMULWOD_D_WU_W : LSX_3R<0b01110000101000110>,
                     LSX_3R_DESC_BASE<"vmulwod.d.wu.w", int_loongarch_lsx_vmulwod_d_wu_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VMULWOD_Q_DU_D : LSX_3R<0b01110000101000111>,
                     LSX_3R_DESC_BASE<"vmulwod.q.du.d", int_loongarch_lsx_vmulwod_q_du_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMADDWEV_H_B : LSX_3R<0b01110000101011000>,
                   LSX_3R_4R_DESC_BASE<"vmaddwev.h.b", int_loongarch_lsx_vmaddwev_h_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMADDWEV_W_H : LSX_3R<0b01110000101011001>,
                   LSX_3R_4R_DESC_BASE<"vmaddwev.w.h", int_loongarch_lsx_vmaddwev_w_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMADDWEV_D_W : LSX_3R<0b01110000101011010>,
                   LSX_3R_4R_DESC_BASE<"vmaddwev.d.w", int_loongarch_lsx_vmaddwev_d_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd>;

def VMADDWEV_Q_D : LSX_3R<0b01110000101011011>,
                   LSX_3R_4R_DESC_BASE<"vmaddwev.q.d", int_loongarch_lsx_vmaddwev_q_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMADDWOD_H_B : LSX_3R<0b01110000101011100>,
                   LSX_3R_4R_DESC_BASE<"vmaddwod.h.b", int_loongarch_lsx_vmaddwod_h_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMADDWOD_W_H : LSX_3R<0b01110000101011101>,
                   LSX_3R_4R_DESC_BASE<"vmaddwod.w.h", int_loongarch_lsx_vmaddwod_w_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMADDWOD_D_W : LSX_3R<0b01110000101011110>,
                   LSX_3R_4R_DESC_BASE<"vmaddwod.d.w", int_loongarch_lsx_vmaddwod_d_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd>;

def VMADDWOD_Q_D : LSX_3R<0b01110000101011111>,
                   LSX_3R_4R_DESC_BASE<"vmaddwod.q.d", int_loongarch_lsx_vmaddwod_q_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMADDWEV_H_BU : LSX_3R<0b01110000101101000>,
                    LSX_3R_4R_DESC_BASE<"vmaddwev.h.bu", int_loongarch_lsx_vmaddwev_h_bu, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMADDWEV_W_HU : LSX_3R<0b01110000101101001>,
                    LSX_3R_4R_DESC_BASE<"vmaddwev.w.hu", int_loongarch_lsx_vmaddwev_w_hu, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMADDWEV_D_WU : LSX_3R<0b01110000101101010>,
                    LSX_3R_4R_DESC_BASE<"vmaddwev.d.wu", int_loongarch_lsx_vmaddwev_d_wu, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd>;

def VMADDWEV_Q_DU : LSX_3R<0b01110000101101011>,
                    LSX_3R_4R_DESC_BASE<"vmaddwev.q.du", int_loongarch_lsx_vmaddwev_q_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMADDWOD_H_BU : LSX_3R<0b01110000101101100>,
                    LSX_3R_4R_DESC_BASE<"vmaddwod.h.bu", int_loongarch_lsx_vmaddwod_h_bu, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMADDWOD_W_HU : LSX_3R<0b01110000101101101>,
                    LSX_3R_4R_DESC_BASE<"vmaddwod.w.hu", int_loongarch_lsx_vmaddwod_w_hu, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMADDWOD_D_WU : LSX_3R<0b01110000101101110>,
                    LSX_3R_4R_DESC_BASE<"vmaddwod.d.wu", int_loongarch_lsx_vmaddwod_d_wu, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd>;

def VMADDWOD_Q_DU : LSX_3R<0b01110000101101111>,
                    LSX_3R_4R_DESC_BASE<"vmaddwod.q.du", int_loongarch_lsx_vmaddwod_q_du, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMADDWEV_H_BU_B : LSX_3R<0b01110000101111000>,
                      LSX_3R_4R_DESC_BASE<"vmaddwev.h.bu.b", int_loongarch_lsx_vmaddwev_h_bu_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMADDWEV_W_HU_H : LSX_3R<0b01110000101111001>,
                      LSX_3R_4R_DESC_BASE<"vmaddwev.w.hu.h", int_loongarch_lsx_vmaddwev_w_hu_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMADDWEV_D_WU_W : LSX_3R<0b01110000101111010>,
                      LSX_3R_4R_DESC_BASE<"vmaddwev.d.wu.w", int_loongarch_lsx_vmaddwev_d_wu_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VMADDWEV_Q_DU_D : LSX_3R<0b01110000101111011>,
                      LSX_3R_4R_DESC_BASE<"vmaddwev.q.du.d", int_loongarch_lsx_vmaddwev_q_du_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VMADDWOD_H_BU_B : LSX_3R<0b01110000101111100>,
                      LSX_3R_4R_DESC_BASE<"vmaddwod.h.bu.b", int_loongarch_lsx_vmaddwod_h_bu_b, LSX128HOpnd, LSX128BOpnd, LSX128BOpnd>;

def VMADDWOD_W_HU_H : LSX_3R<0b01110000101111101>,
                      LSX_3R_4R_DESC_BASE<"vmaddwod.w.hu.h", int_loongarch_lsx_vmaddwod_w_hu_h, LSX128WOpnd, LSX128HOpnd, LSX128HOpnd>;

def VMADDWOD_D_WU_W : LSX_3R<0b01110000101111110>,
                      LSX_3R_4R_DESC_BASE<"vmaddwod.d.wu.w", int_loongarch_lsx_vmaddwod_d_wu_w, LSX128DOpnd, LSX128WOpnd, LSX128WOpnd> ;

def VMADDWOD_Q_DU_D : LSX_3R<0b01110000101111111>,
                      LSX_3R_4R_DESC_BASE<"vmaddwod.q.du.d", int_loongarch_lsx_vmaddwod_q_du_d, LSX128DOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSRLN_B_H : LSX_3R<0b01110000111101001>,
                LSX_3R_DESC_BASE<"vsrln.b.h", int_loongarch_lsx_vsrln_b_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSRLN_H_W : LSX_3R<0b01110000111101010>,
                LSX_3R_DESC_BASE<"vsrln.h.w", int_loongarch_lsx_vsrln_h_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSRLN_W_D : LSX_3R<0b01110000111101011>,
                LSX_3R_DESC_BASE<"vsrln.w.d", int_loongarch_lsx_vsrln_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSRAN_B_H : LSX_3R<0b01110000111101101>,
                LSX_3R_DESC_BASE<"vsran.b.h", int_loongarch_lsx_vsran_b_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSRAN_H_W : LSX_3R<0b01110000111101110>,
                LSX_3R_DESC_BASE<"vsran.h.w", int_loongarch_lsx_vsran_h_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSRAN_W_D : LSX_3R<0b01110000111101111>,
                LSX_3R_DESC_BASE<"vsran.w.d", int_loongarch_lsx_vsran_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSRLRN_B_H : LSX_3R<0b01110000111110001>,
                 LSX_3R_DESC_BASE<"vsrlrn.b.h", int_loongarch_lsx_vsrlrn_b_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSRLRN_H_W : LSX_3R<0b01110000111110010>,
                 LSX_3R_DESC_BASE<"vsrlrn.h.w", int_loongarch_lsx_vsrlrn_h_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSRLRN_W_D : LSX_3R<0b01110000111110011>,
                 LSX_3R_DESC_BASE<"vsrlrn.w.d", int_loongarch_lsx_vsrlrn_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSRARN_B_H : LSX_3R<0b01110000111110101>,
                 LSX_3R_DESC_BASE<"vsrarn.b.h", int_loongarch_lsx_vsrarn_b_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSRARN_H_W : LSX_3R<0b01110000111110110>,
                 LSX_3R_DESC_BASE<"vsrarn.h.w", int_loongarch_lsx_vsrarn_h_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSRARN_W_D : LSX_3R<0b01110000111110111>,
                 LSX_3R_DESC_BASE<"vsrarn.w.d", int_loongarch_lsx_vsrarn_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSSRLN_B_H : LSX_3R<0b01110000111111001>,
                 LSX_3R_DESC_BASE<"vssrln.b.h", int_loongarch_lsx_vssrln_b_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSSRLN_H_W : LSX_3R<0b01110000111111010>,
                 LSX_3R_DESC_BASE<"vssrln.h.w", int_loongarch_lsx_vssrln_h_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSSRLN_W_D : LSX_3R<0b01110000111111011>,
                 LSX_3R_DESC_BASE<"vssrln.w.d", int_loongarch_lsx_vssrln_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSSRAN_B_H : LSX_3R<0b01110000111111101>,
                 LSX_3R_DESC_BASE<"vssran.b.h", int_loongarch_lsx_vssran_b_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSSRAN_H_W : LSX_3R<0b01110000111111110>,
                 LSX_3R_DESC_BASE<"vssran.h.w", int_loongarch_lsx_vssran_h_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSSRAN_W_D : LSX_3R<0b01110000111111111>,
                 LSX_3R_DESC_BASE<"vssran.w.d", int_loongarch_lsx_vssran_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSSRLRN_B_H : LSX_3R<0b01110001000000001>,
                  LSX_3R_DESC_BASE<"vssrlrn.b.h", int_loongarch_lsx_vssrlrn_b_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSSRLRN_H_W : LSX_3R<0b01110001000000010>,
                  LSX_3R_DESC_BASE<"vssrlrn.h.w", int_loongarch_lsx_vssrlrn_h_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSSRLRN_W_D : LSX_3R<0b01110001000000011>,
                  LSX_3R_DESC_BASE<"vssrlrn.w.d", int_loongarch_lsx_vssrlrn_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSSRARN_B_H : LSX_3R<0b01110001000000101>,
                  LSX_3R_DESC_BASE<"vssrarn.b.h", int_loongarch_lsx_vssrarn_b_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSSRARN_H_W : LSX_3R<0b01110001000000110>,
                  LSX_3R_DESC_BASE<"vssrarn.h.w", int_loongarch_lsx_vssrarn_h_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSSRARN_W_D : LSX_3R<0b01110001000000111>,
                  LSX_3R_DESC_BASE<"vssrarn.w.d", int_loongarch_lsx_vssrarn_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSSRLN_BU_H : LSX_3R<0b01110001000001001>,
                  LSX_3R_DESC_BASE<"vssrln.bu.h", int_loongarch_lsx_vssrln_bu_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSSRLN_HU_W : LSX_3R<0b01110001000001010>,
                  LSX_3R_DESC_BASE<"vssrln.hu.w", int_loongarch_lsx_vssrln_hu_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSSRLN_WU_D : LSX_3R<0b01110001000001011>,
                  LSX_3R_DESC_BASE<"vssrln.wu.d", int_loongarch_lsx_vssrln_wu_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSSRAN_BU_H : LSX_3R<0b01110001000001101>,
                  LSX_3R_DESC_BASE<"vssran.bu.h", int_loongarch_lsx_vssran_bu_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSSRAN_HU_W : LSX_3R<0b01110001000001110>,
                  LSX_3R_DESC_BASE<"vssran.hu.w", int_loongarch_lsx_vssran_hu_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSSRAN_WU_D : LSX_3R<0b01110001000001111>,
                  LSX_3R_DESC_BASE<"vssran.wu.d", int_loongarch_lsx_vssran_wu_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSSRLRN_BU_H : LSX_3R<0b01110001000010001>,
                   LSX_3R_DESC_BASE<"vssrlrn.bu.h", int_loongarch_lsx_vssrlrn_bu_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSSRLRN_HU_W : LSX_3R<0b01110001000010010>,
                   LSX_3R_DESC_BASE<"vssrlrn.hu.w", int_loongarch_lsx_vssrlrn_hu_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSSRLRN_WU_D : LSX_3R<0b01110001000010011>,
                   LSX_3R_DESC_BASE<"vssrlrn.wu.d", int_loongarch_lsx_vssrlrn_wu_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VSSRARN_BU_H : LSX_3R<0b01110001000010101>,
                   LSX_3R_DESC_BASE<"vssrarn.bu.h", int_loongarch_lsx_vssrarn_bu_h, LSX128BOpnd, LSX128HOpnd, LSX128HOpnd>;

def VSSRARN_HU_W : LSX_3R<0b01110001000010110>,
                   LSX_3R_DESC_BASE<"vssrarn.hu.w", int_loongarch_lsx_vssrarn_hu_w, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VSSRARN_WU_D : LSX_3R<0b01110001000010111>,
                   LSX_3R_DESC_BASE<"vssrarn.wu.d", int_loongarch_lsx_vssrarn_wu_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VANDN_V : LSX_3R<0b01110001001010000>,
              LSX_3R_DESC_BASE<"vandn.v", int_loongarch_lsx_vandn_v, LSX128BOpnd>;


class LSX_VANDN_PSEUDO_BASE<RegisterOperand RO> :
                            LSXPseudo<(outs RO:$vd), (ins RO:$vj, RO:$vk),
                            []>,
                            PseudoInstExpansion<(VANDN_V LSX128BOpnd:$vd,
                                                         LSX128BOpnd:$vj,
                                                         LSX128BOpnd:$vk)>;

def VANDN_H_PSEUDO : LSX_VANDN_PSEUDO_BASE<LSX128HOpnd>;
def VANDN_W_PSEUDO : LSX_VANDN_PSEUDO_BASE<LSX128WOpnd>;
def VANDN_D_PSEUDO : LSX_VANDN_PSEUDO_BASE<LSX128DOpnd>;



def VORN_V : LSX_3R<0b01110001001010001>,
             LSX_3R_DESC_BASE<"vorn.v", int_loongarch_lsx_vorn_v, LSX128BOpnd>;


class LSX_VORN_PSEUDO_BASE<RegisterOperand RO> :
                           LSXPseudo<(outs RO:$vd), (ins RO:$vj, RO:$vk),
                           []>,
                           PseudoInstExpansion<(VORN_V LSX128BOpnd:$vd,
                                                       LSX128BOpnd:$vj,
                                                       LSX128BOpnd:$vk)>;

def VORN_H_PSEUDO : LSX_VORN_PSEUDO_BASE<LSX128HOpnd>;
def VORN_W_PSEUDO : LSX_VORN_PSEUDO_BASE<LSX128WOpnd>;
def VORN_D_PSEUDO : LSX_VORN_PSEUDO_BASE<LSX128DOpnd>;


def VFRSTP_B : LSX_3R<0b01110001001010110>,
               LSX_3R_4R_DESC_BASE<"vfrstp.b", int_loongarch_lsx_vfrstp_b, LSX128BOpnd>;

def VFRSTP_H : LSX_3R<0b01110001001010111>,
               LSX_3R_4R_DESC_BASE<"vfrstp.h", int_loongarch_lsx_vfrstp_h, LSX128HOpnd>;


def VADD_Q : LSX_3R<0b01110001001011010>, IsCommutable,
             LSX_3R_DESC_BASE<"vadd.q", int_loongarch_lsx_vadd_q, LSX128DOpnd>;

def VSUB_Q : LSX_3R<0b01110001001011011>,
             LSX_3R_DESC_BASE<"vsub.q", int_loongarch_lsx_vsub_q, LSX128DOpnd>;


def VSIGNCOV_B : LSX_3R<0b01110001001011100>,
                 LSX_3R_DESC_BASE<"vsigncov.b", int_loongarch_lsx_vsigncov_b, LSX128BOpnd>;

def VSIGNCOV_H : LSX_3R<0b01110001001011101>,
                 LSX_3R_DESC_BASE<"vsigncov.h", int_loongarch_lsx_vsigncov_h, LSX128HOpnd>;

def VSIGNCOV_W : LSX_3R<0b01110001001011110>,
                 LSX_3R_DESC_BASE<"vsigncov.w", int_loongarch_lsx_vsigncov_w, LSX128WOpnd>;

def VSIGNCOV_D : LSX_3R<0b01110001001011111>,
                 LSX_3R_DESC_BASE<"vsigncov.d", int_loongarch_lsx_vsigncov_d, LSX128DOpnd>;


def VFCVT_H_S : LSX_3R<0b01110001010001100>,
                LSX_3RF_DESC_BASE<"vfcvt.h.s", int_loongarch_lsx_vfcvt_h_s, LSX128HOpnd, LSX128WOpnd, LSX128WOpnd>;

def VFCVT_S_D : LSX_3R<0b01110001010001101>,
                LSX_3RF_DESC_BASE1<"vfcvt.s.d", int_loongarch_lsx_vfcvt_s_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VFFINT_S_L : LSX_3R<0b01110001010010000>,
                 LSX_3RF_DESC_BASE<"vffint.s.l", int_loongarch_lsx_vffint_s_l, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;

def VFTINT_W_D : LSX_3R<0b01110001010010011>,
                 LSX_3RF_DESC_BASE<"vftint.w.d", int_loongarch_lsx_vftint_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VFTINTRZ_W_D : LSX_3R<0b01110001010010110>,
                   LSX_3RF_DESC_BASE<"vftintrz.w.d", int_loongarch_lsx_vftintrz_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;

def VFTINTRP_W_D : LSX_3R<0b01110001010010101>,
                   LSX_3RF_DESC_BASE<"vftintrp.w.d", int_loongarch_lsx_vftintrp_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;

def VFTINTRM_W_D : LSX_3R<0b01110001010010100>,
                   LSX_3RF_DESC_BASE<"vftintrm.w.d", int_loongarch_lsx_vftintrm_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;

def VFTINTRNE_W_D : LSX_3R<0b01110001010010111>,
                    LSX_3RF_DESC_BASE<"vftintrne.w.d", int_loongarch_lsx_vftintrne_w_d, LSX128WOpnd, LSX128DOpnd, LSX128DOpnd>;


def VBSRL_V : LSX_I5_U<0b01110010100011101>,
              LSX_U5_DESC_BASE<"vbsrl.v", int_loongarch_lsx_vbsrl_v, LSX128BOpnd>;

def VBSLL_V : LSX_I5_U<0b01110010100011100>,
              LSX_U5_DESC_BASE<"vbsll.v", int_loongarch_lsx_vbsll_v, LSX128BOpnd>;


def VFRSTPI_B : LSX_I5_U<0b01110010100110100>,
                LSX_U5_4R_DESC_BASE<"vfrstpi.b", int_loongarch_lsx_vfrstpi_b, LSX128BOpnd>;

def VFRSTPI_H : LSX_I5_U<0b01110010100110101>,
                LSX_U5_4R_DESC_BASE<"vfrstpi.h", int_loongarch_lsx_vfrstpi_h, LSX128HOpnd>;


def VNEG_B : LSX_2R<0b0111001010011100001100>,
             LSX_2R_DESC_BASE<"vneg.b", int_loongarch_lsx_vneg_b, LSX128BOpnd>;

def VNEG_H : LSX_2R<0b0111001010011100001101>,
             LSX_2R_DESC_BASE<"vneg.h", int_loongarch_lsx_vneg_h, LSX128HOpnd>;

def VNEG_W : LSX_2R<0b0111001010011100001110>,
             LSX_2R_DESC_BASE<"vneg.w", int_loongarch_lsx_vneg_w, LSX128WOpnd>;

def VNEG_D : LSX_2R<0b0111001010011100001111>,
             LSX_2R_DESC_BASE<"vneg.d", int_loongarch_lsx_vneg_d, LSX128DOpnd>;


def VMSKGEZ_B : LSX_2R<0b0111001010011100010100>,
                LSX_2R_DESC_BASE<"vmskgez.b", int_loongarch_lsx_vmskgez_b, LSX128BOpnd>;

def VMSKNZ_B : LSX_2R<0b0111001010011100011000>,
               LSX_2R_DESC_BASE<"vmsknz.b", int_loongarch_lsx_vmsknz_b, LSX128BOpnd>;


def VFRINTRM_S : LSX_2R<0b0111001010011101010001>,
                 LSX_2RF_DESC_BASE<"vfrintrm.s", int_loongarch_lsx_vfrintrm_s, LSX128WOpnd>;

def VFRINTRM_D : LSX_2R<0b0111001010011101010010>,
                 LSX_2RF_DESC_BASE<"vfrintrm.d", int_loongarch_lsx_vfrintrm_d, LSX128DOpnd>;


def VFRINTRP_S : LSX_2R<0b0111001010011101010101>,
                 LSX_2RF_DESC_BASE<"vfrintrp.s", int_loongarch_lsx_vfrintrp_s, LSX128WOpnd>;

def VFRINTRP_D : LSX_2R<0b0111001010011101010110>,
                 LSX_2RF_DESC_BASE<"vfrintrp.d", int_loongarch_lsx_vfrintrp_d, LSX128DOpnd>;


def VFRINTRZ_S : LSX_2R<0b0111001010011101011001>,
                 LSX_2RF_DESC_BASE<"vfrintrz.s", int_loongarch_lsx_vfrintrz_s, LSX128WOpnd>;

def VFRINTRZ_D : LSX_2R<0b0111001010011101011010>,
                 LSX_2RF_DESC_BASE<"vfrintrz.d", int_loongarch_lsx_vfrintrz_d, LSX128DOpnd>;


def VFRINTRNE_S : LSX_2R<0b0111001010011101011101>,
                  LSX_2RF_DESC_BASE<"vfrintrne.s", int_loongarch_lsx_vfrintrne_s, LSX128WOpnd>;

def VFRINTRNE_D : LSX_2R<0b0111001010011101011110>,
                  LSX_2RF_DESC_BASE<"vfrintrne.d", int_loongarch_lsx_vfrintrne_d, LSX128DOpnd>;


def VFFINTL_D_W : LSX_2R<0b0111001010011110000100>,
                  LSX_2RF_DESC_BASE<"vffintl.d.w", int_loongarch_lsx_vffintl_d_w, LSX128DOpnd, LSX128WOpnd>;

def VFFINTH_D_W : LSX_2R<0b0111001010011110000101>,
                  LSX_2RF_DESC_BASE<"vffinth.d.w", int_loongarch_lsx_vffinth_d_w, LSX128DOpnd, LSX128WOpnd>;


def VFTINTRM_W_S : LSX_2R<0b0111001010011110001110>,
                   LSX_2RF_DESC_BASE<"vftintrm.w.s", int_loongarch_lsx_vftintrm_w_s, LSX128WOpnd>;

def VFTINTRM_L_D : LSX_2R<0b0111001010011110001111>,
                   LSX_2RF_DESC_BASE<"vftintrm.l.d", int_loongarch_lsx_vftintrm_l_d, LSX128DOpnd>;


def VFTINTRP_W_S : LSX_2R<0b0111001010011110010000>,
                   LSX_2RF_DESC_BASE<"vftintrp.w.s", int_loongarch_lsx_vftintrp_w_s, LSX128WOpnd>;

def VFTINTRP_L_D : LSX_2R<0b0111001010011110010001>,
                   LSX_2RF_DESC_BASE<"vftintrp.l.d", int_loongarch_lsx_vftintrp_l_d, LSX128DOpnd>;


def VFTINTRZ_W_S : LSX_2R<0b0111001010011110010010>,
                   LSX_2RF_DESC_BASE<"vftintrz.w.s", fp_to_sint, LSX128WOpnd>;

def VFTINTRZ_L_D : LSX_2R<0b0111001010011110010011>,
                   LSX_2RF_DESC_BASE<"vftintrz.l.d", fp_to_sint, LSX128DOpnd>;


def VFTINTRNE_W_S : LSX_2R<0b0111001010011110010100>,
                    LSX_2RF_DESC_BASE<"vftintrne.w.s", int_loongarch_lsx_vftintrne_w_s, LSX128WOpnd>;

def VFTINTRNE_L_D : LSX_2R<0b0111001010011110010101>,
                    LSX_2RF_DESC_BASE<"vftintrne.l.d", int_loongarch_lsx_vftintrne_l_d, LSX128DOpnd>;


def VFTINTL_L_S : LSX_2R<0b0111001010011110100000>,
                  LSX_2RF_DESC_BASE<"vftintl.l.s", int_loongarch_lsx_vftintl_l_s, LSX128DOpnd, LSX128WOpnd>;

def VFTINTH_L_S : LSX_2R<0b0111001010011110100001>,
                  LSX_2RF_DESC_BASE<"vftinth.l.s", int_loongarch_lsx_vftinth_l_s, LSX128DOpnd, LSX128WOpnd>;


def VFTINTRML_L_S : LSX_2R<0b0111001010011110100010>,
                    LSX_2RF_DESC_BASE<"vftintrml.l.s", int_loongarch_lsx_vftintrml_l_s, LSX128DOpnd, LSX128WOpnd>;

def VFTINTRMH_L_S : LSX_2R<0b0111001010011110100011>,
                    LSX_2RF_DESC_BASE<"vftintrmh.l.s", int_loongarch_lsx_vftintrmh_l_s, LSX128DOpnd, LSX128WOpnd>;


def VFTINTRPL_L_S : LSX_2R<0b0111001010011110100100>,
                    LSX_2RF_DESC_BASE<"vftintrpl.l.s", int_loongarch_lsx_vftintrpl_l_s, LSX128DOpnd, LSX128WOpnd>;

def VFTINTRPH_L_S : LSX_2R<0b0111001010011110100101>,
                    LSX_2RF_DESC_BASE<"vftintrph.l.s", int_loongarch_lsx_vftintrph_l_s, LSX128DOpnd, LSX128WOpnd>;


def VFTINTRZL_L_S : LSX_2R<0b0111001010011110100110>,
                    LSX_2RF_DESC_BASE<"vftintrzl.l.s", int_loongarch_lsx_vftintrzl_l_s, LSX128DOpnd, LSX128WOpnd>;

def VFTINTRZH_L_S : LSX_2R<0b0111001010011110100111>,
                    LSX_2RF_DESC_BASE<"vftintrzh.l.s", int_loongarch_lsx_vftintrzh_l_s, LSX128DOpnd, LSX128WOpnd>;


def VFTINTRNEL_L_S : LSX_2R<0b0111001010011110101000>,
                     LSX_2RF_DESC_BASE<"vftintrnel.l.s", int_loongarch_lsx_vftintrnel_l_s, LSX128DOpnd, LSX128WOpnd>;

def VFTINTRNEH_L_S : LSX_2R<0b0111001010011110101001>,
                     LSX_2RF_DESC_BASE<"vftintrneh.l.s", int_loongarch_lsx_vftintrneh_l_s, LSX128DOpnd, LSX128WOpnd>;


def VEXTH_H_B : LSX_2R<0b0111001010011110111000>,
                LSX_2R_DESC_BASE<"vexth.h.b", int_loongarch_lsx_vexth_h_b, LSX128HOpnd, LSX128BOpnd>;

def VEXTH_W_H : LSX_2R<0b0111001010011110111001>,
                LSX_2R_DESC_BASE<"vexth.w.h", int_loongarch_lsx_vexth_w_h, LSX128WOpnd, LSX128HOpnd>;

def VEXTH_D_W : LSX_2R<0b0111001010011110111010>,
                LSX_2R_DESC_BASE<"vexth.d.w", int_loongarch_lsx_vexth_d_w, LSX128DOpnd, LSX128WOpnd> ;

def VEXTH_Q_D : LSX_2R<0b0111001010011110111011>,
                LSX_2R_DESC_BASE<"vexth.q.d", int_loongarch_lsx_vexth_q_d, LSX128DOpnd, LSX128DOpnd>;


def VEXTH_HU_BU : LSX_2R<0b0111001010011110111100>,
                  LSX_2R_DESC_BASE<"vexth.hu.bu", int_loongarch_lsx_vexth_hu_bu, LSX128HOpnd, LSX128BOpnd>;

def VEXTH_WU_HU : LSX_2R<0b0111001010011110111101>,
                  LSX_2R_DESC_BASE<"vexth.wu.hu", int_loongarch_lsx_vexth_wu_hu, LSX128WOpnd, LSX128HOpnd>;

def VEXTH_DU_WU : LSX_2R<0b0111001010011110111110>,
                  LSX_2R_DESC_BASE<"vexth.du.wu", int_loongarch_lsx_vexth_du_wu, LSX128DOpnd, LSX128WOpnd> ;

def VEXTH_QU_DU : LSX_2R<0b0111001010011110111111>,
                  LSX_2R_DESC_BASE<"vexth.qu.du", int_loongarch_lsx_vexth_qu_du, LSX128DOpnd, LSX128DOpnd>;


def VSLLWIL_H_B : LSX_I3_U<0b0111001100001000001>,
                  LSX_2R_U3_DESC_BASE<"vsllwil.h.b", int_loongarch_lsx_vsllwil_h_b, LSX128HOpnd, LSX128BOpnd>;

def VSLLWIL_W_H : LSX_I4_U<0b011100110000100001>,
                  LSX_2R_U4_DESC_BASE<"vsllwil.w.h", int_loongarch_lsx_vsllwil_w_h, LSX128WOpnd, LSX128HOpnd>;

def VSLLWIL_D_W : LSX_I5_U<0b01110011000010001>,
                  LSX_2R_U5_DESC_BASE<"vsllwil.d.w", int_loongarch_lsx_vsllwil_d_w, LSX128DOpnd, LSX128WOpnd> ;


def VEXTL_Q_D : LSX_2R<0b0111001100001001000000>,
                LSX_2R_DESC_BASE<"vextl.q.d", int_loongarch_lsx_vextl_q_d, LSX128DOpnd, LSX128DOpnd>;


def VSLLWIL_HU_BU : LSX_I3_U<0b0111001100001100001>,
                    LSX_2R_U3_DESC_BASE<"vsllwil.hu.bu", int_loongarch_lsx_vsllwil_hu_bu, LSX128HOpnd, LSX128BOpnd>;

def VSLLWIL_WU_HU : LSX_I4_U<0b011100110000110001>,
                    LSX_2R_U4_DESC_BASE<"vsllwil.wu.hu", int_loongarch_lsx_vsllwil_wu_hu, LSX128WOpnd, LSX128HOpnd>;

def VSLLWIL_DU_WU : LSX_I5_U<0b01110011000011001>,
                    LSX_2R_U5_DESC_BASE<"vsllwil.du.wu", int_loongarch_lsx_vsllwil_du_wu, LSX128DOpnd, LSX128WOpnd> ;


def VEXTL_QU_DU : LSX_2R<0b0111001100001101000000>,
                  LSX_2R_DESC_BASE<"vextl.qu.du", int_loongarch_lsx_vextl_qu_du, LSX128DOpnd, LSX128DOpnd>;


def VBITCLRI_B : LSX_I3_U<0b0111001100010000001>,
                 LSX_2R_U3_DESC_BASE<"vbitclri.b", int_loongarch_lsx_vbitclri_b, LSX128BOpnd, LSX128BOpnd>;

def VBITCLRI_H : LSX_I4_U<0b011100110001000001>,
                 LSX_2R_U4_DESC_BASE<"vbitclri.h", int_loongarch_lsx_vbitclri_h, LSX128HOpnd, LSX128HOpnd>;

def VBITCLRI_W : LSX_I5_U<0b01110011000100001>,
                 LSX_2R_U5_DESC_BASE<"vbitclri.w", int_loongarch_lsx_vbitclri_w, LSX128WOpnd, LSX128WOpnd>;

def VBITCLRI_D : LSX_I6_U<0b0111001100010001>,
                 LSX_2R_U6_DESC_BASE<"vbitclri.d", int_loongarch_lsx_vbitclri_d, LSX128DOpnd, LSX128DOpnd>;


def VBITSETI_B : LSX_I3_U<0b0111001100010100001>,
                 LSX_2R_U3_DESC_BASE<"vbitseti.b", int_loongarch_lsx_vbitseti_b, LSX128BOpnd, LSX128BOpnd>;

def VBITSETI_H : LSX_I4_U<0b011100110001010001>,
                 LSX_2R_U4_DESC_BASE<"vbitseti.h", int_loongarch_lsx_vbitseti_h, LSX128HOpnd, LSX128HOpnd>;

def VBITSETI_W : LSX_I5_U<0b01110011000101001>,
                 LSX_2R_U5_DESC_BASE<"vbitseti.w", int_loongarch_lsx_vbitseti_w, LSX128WOpnd, LSX128WOpnd>;

def VBITSETI_D : LSX_I6_U<0b0111001100010101>,
                 LSX_2R_U6_DESC_BASE<"vbitseti.d", int_loongarch_lsx_vbitseti_d, LSX128DOpnd, LSX128DOpnd>;


def VBITREVI_B : LSX_I3_U<0b0111001100011000001>,
                 LSX_2R_U3_DESC_BASE<"vbitrevi.b", int_loongarch_lsx_vbitrevi_b, LSX128BOpnd, LSX128BOpnd>;

def VBITREVI_H : LSX_I4_U<0b011100110001100001>,
                 LSX_2R_U4_DESC_BASE<"vbitrevi.h", int_loongarch_lsx_vbitrevi_h, LSX128HOpnd, LSX128HOpnd>;

def VBITREVI_W : LSX_I5_U<0b01110011000110001>,
                 LSX_2R_U5_DESC_BASE<"vbitrevi.w", int_loongarch_lsx_vbitrevi_w, LSX128WOpnd, LSX128WOpnd>;

def VBITREVI_D : LSX_I6_U<0b0111001100011001>,
                 LSX_2R_U6_DESC_BASE<"vbitrevi.d", int_loongarch_lsx_vbitrevi_d, LSX128DOpnd, LSX128DOpnd>;


def VSSRLRNI_B_H : LSX_I4_U<0b011100110101000001>,
                   LSX_2R_3R_U4_DESC_BASE<"vssrlrni.b.h", int_loongarch_lsx_vssrlrni_b_h, LSX128BOpnd, LSX128BOpnd>;

def VSSRLRNI_H_W : LSX_I5_U<0b01110011010100001>,
                   LSX_2R_3R_U5_DESC_BASE<"vssrlrni.h.w", int_loongarch_lsx_vssrlrni_h_w, LSX128HOpnd, LSX128HOpnd>;

def VSSRLRNI_W_D : LSX_I6_U<0b0111001101010001>,
                   LSX_2R_3R_U6_DESC_BASE<"vssrlrni.w.d", int_loongarch_lsx_vssrlrni_w_d, LSX128WOpnd, LSX128WOpnd>;

def VSSRLRNI_D_Q : LSX_I7_U<0b011100110101001>,
                   LSX_2R_3R_U7_DESC_BASE<"vssrlrni.d.q", int_loongarch_lsx_vssrlrni_d_q, LSX128DOpnd, LSX128DOpnd>;


def VSRANI_B_H : LSX_I4_U<0b011100110101100001>,
                 LSX_2R_3R_U4_DESC_BASE<"vsrani.b.h", int_loongarch_lsx_vsrani_b_h, LSX128BOpnd, LSX128BOpnd>;

def VSRANI_H_W : LSX_I5_U<0b01110011010110001>,
                 LSX_2R_3R_U5_DESC_BASE<"vsrani.h.w", int_loongarch_lsx_vsrani_h_w, LSX128HOpnd, LSX128HOpnd>;

def VSRANI_W_D : LSX_I6_U<0b0111001101011001>,
                 LSX_2R_3R_U6_DESC_BASE<"vsrani.w.d", int_loongarch_lsx_vsrani_w_d, LSX128WOpnd, LSX128WOpnd>;

def VSRANI_D_Q : LSX_I7_U<0b011100110101101>,
                 LSX_2R_3R_U7_DESC_BASE<"vsrani.d.q", int_loongarch_lsx_vsrani_d_q, LSX128DOpnd, LSX128DOpnd>;


def VEXTRINS_B : LSX_I8_U<0b01110011100011>,
                 LSX_2R_3R_U8_DESC_BASE<"vextrins.b", int_loongarch_lsx_vextrins_b, LSX128BOpnd, LSX128BOpnd>;

def VEXTRINS_H : LSX_I8_U<0b01110011100010>,
                 LSX_2R_3R_U8_DESC_BASE<"vextrins.h", int_loongarch_lsx_vextrins_h, LSX128HOpnd, LSX128HOpnd>;

def VEXTRINS_W : LSX_I8_U<0b01110011100001>,
                 LSX_2R_3R_U8_DESC_BASE<"vextrins.w", int_loongarch_lsx_vextrins_w, LSX128WOpnd, LSX128WOpnd>;

def VEXTRINS_D : LSX_I8_U<0b01110011100000>,
                 LSX_2R_3R_U8_DESC_BASE<"vextrins.d", int_loongarch_lsx_vextrins_d, LSX128DOpnd, LSX128DOpnd>;


def VBITSELI_B : LSX_I8_U<0b01110011110001>,
                 LSX_2R_3R_U8_DESC_BASE<"vbitseli.b", int_loongarch_lsx_vbitseli_b, LSX128BOpnd, LSX128BOpnd>;


def VANDI_B : LSX_I8_U<0b01110011110100>,
              LSX_2R_U8_DESC_BASE<"vandi.b", int_loongarch_lsx_vandi_b, LSX128BOpnd, LSX128BOpnd>;


def VORI_B : LSX_I8_U<0b01110011110101>,
             LSX_2R_U8_DESC_BASE<"vori.b", int_loongarch_lsx_vori_b, LSX128BOpnd, LSX128BOpnd>;


def VXORI_B : LSX_I8_U<0b01110011110110>,
              LSX_2R_U8_DESC_BASE<"vxori.b", int_loongarch_lsx_vxori_b, LSX128BOpnd, LSX128BOpnd>;


def VNORI_B : LSX_I8_U<0b01110011110111>,
              LSX_2R_U8_DESC_BASE<"vnori.b", int_loongarch_lsx_vnori_b, LSX128BOpnd, LSX128BOpnd>;


def VLDI : LSX_1R_I13<0b01110011111000>,
           LSX_I13_DESC_BASE<"vldi", int_loongarch_lsx_vldi, i32, simm13Op, LSX128DOpnd>;

def VLDI_B : LSX_1R_I13_I10<0b01110011111000000>,
             LSX_I13_DESC_BASE_10<"vldi", int_loongarch_lsx_vrepli_b, simm10, immZExt10, LSX128BOpnd>;

def VLDI_H : LSX_1R_I13_I10<0b01110011111000001>,
             LSX_I13_DESC_BASE_10<"vldi", int_loongarch_lsx_vrepli_h, simm10, immZExt10, LSX128HOpnd>;

def VLDI_W : LSX_1R_I13_I10<0b01110011111000010>,
             LSX_I13_DESC_BASE_10<"vldi", int_loongarch_lsx_vrepli_w, simm10, immZExt10, LSX128WOpnd>;

def VLDI_D : LSX_1R_I13_I10<0b01110011111000011>,
             LSX_I13_DESC_BASE_10<"vldi", int_loongarch_lsx_vrepli_d, simm10, immZExt10, LSX128DOpnd>;

def VPERMI_W : LSX_I8_U<0b01110011111001>,
               LSX_2R_3R_U8_DESC_BASE<"vpermi.w", int_loongarch_lsx_vpermi_w, LSX128WOpnd, LSX128WOpnd>;


def VSEQ_B : LSX_3R<0b01110000000000000>, IsCommutable,
             LSX_3R_DESC_BASE<"vseq.b", vseteq_v16i8, LSX128BOpnd>;

def VSEQ_H : LSX_3R<0b01110000000000001>, IsCommutable,
             LSX_3R_DESC_BASE<"vseq.h", vseteq_v8i16, LSX128HOpnd>;

def VSEQ_W : LSX_3R<0b01110000000000010>, IsCommutable,
             LSX_3R_DESC_BASE<"vseq.w", vseteq_v4i32, LSX128WOpnd> ;

def VSEQ_D : LSX_3R<0b01110000000000011>, IsCommutable,
             LSX_3R_DESC_BASE<"vseq.d", vseteq_v2i64, LSX128DOpnd>;


def VSLE_B : LSX_3R<0b01110000000000100>,
             LSX_3R_DESC_BASE<"vsle.b", vsetle_v16i8, LSX128BOpnd>;

def VSLE_H : LSX_3R<0b01110000000000101>,
             LSX_3R_DESC_BASE<"vsle.h", vsetle_v8i16, LSX128HOpnd>;

def VSLE_W : LSX_3R<0b01110000000000110>,
             LSX_3R_DESC_BASE<"vsle.w", vsetle_v4i32, LSX128WOpnd>;

def VSLE_D : LSX_3R<0b01110000000000111>,
             LSX_3R_DESC_BASE<"vsle.d", vsetle_v2i64, LSX128DOpnd>;


def VSLE_BU : LSX_3R<0b01110000000001000>,
              LSX_3R_DESC_BASE<"vsle.bu", vsetule_v16i8, LSX128BOpnd>;

def VSLE_HU : LSX_3R<0b01110000000001001>,
              LSX_3R_DESC_BASE<"vsle.hu", vsetule_v8i16, LSX128HOpnd>;

def VSLE_WU : LSX_3R<0b01110000000001010>,
              LSX_3R_DESC_BASE<"vsle.wu", vsetule_v4i32, LSX128WOpnd>;

def VSLE_DU : LSX_3R<0b01110000000001011>,
              LSX_3R_DESC_BASE<"vsle.du", vsetule_v2i64, LSX128DOpnd>;


def VSLT_B : LSX_3R<0b01110000000001100>,
             LSX_3R_DESC_BASE<"vslt.b", vsetlt_v16i8, LSX128BOpnd>;

def VSLT_H : LSX_3R<0b01110000000001101>,
             LSX_3R_DESC_BASE<"vslt.h", vsetlt_v8i16, LSX128HOpnd>;

def VSLT_W : LSX_3R<0b01110000000001110>,
             LSX_3R_DESC_BASE<"vslt.w", vsetlt_v4i32, LSX128WOpnd>;

def VSLT_D : LSX_3R<0b01110000000001111>,
             LSX_3R_DESC_BASE<"vslt.d", vsetlt_v2i64, LSX128DOpnd>;


def VSLT_BU : LSX_3R<0b01110000000010000>,
              LSX_3R_DESC_BASE<"vslt.bu", vsetult_v16i8, LSX128BOpnd>;

def VSLT_HU : LSX_3R<0b01110000000010001>,
              LSX_3R_DESC_BASE<"vslt.hu", vsetult_v8i16, LSX128HOpnd>;

def VSLT_WU : LSX_3R<0b01110000000010010>,
              LSX_3R_DESC_BASE<"vslt.wu", vsetult_v4i32, LSX128WOpnd>;

def VSLT_DU : LSX_3R<0b01110000000010011>,
              LSX_3R_DESC_BASE<"vslt.du", vsetult_v2i64, LSX128DOpnd>;


def VADD_B : LSX_3R<0b01110000000010100>, IsCommutable,
             LSX_3R_DESC_BASE<"vadd.b", add, LSX128BOpnd>;

def VADD_H : LSX_3R<0b01110000000010101>, IsCommutable,
             LSX_3R_DESC_BASE<"vadd.h", add, LSX128HOpnd>;

def VADD_W : LSX_3R<0b01110000000010110>, IsCommutable,
             LSX_3R_DESC_BASE<"vadd.w", add, LSX128WOpnd>;

def VADD_D : LSX_3R<0b01110000000010111>, IsCommutable,
             LSX_3R_DESC_BASE<"vadd.d", add, LSX128DOpnd>;


def VSUB_B : LSX_3R<0b01110000000011000>,
             LSX_3R_DESC_BASE<"vsub.b", sub, LSX128BOpnd>;

def VSUB_H : LSX_3R<0b01110000000011001>,
             LSX_3R_DESC_BASE<"vsub.h", sub, LSX128HOpnd>;

def VSUB_W : LSX_3R<0b01110000000011010>,
             LSX_3R_DESC_BASE<"vsub.w", sub, LSX128WOpnd>;

def VSUB_D : LSX_3R<0b01110000000011011>,
             LSX_3R_DESC_BASE<"vsub.d", sub, LSX128DOpnd>;



//Pat
class LSXBitconvertPat<ValueType DstVT, ValueType SrcVT,
                       RegisterClass DstRC, list<Predicate> preds = [HasLSX]> :
   LSXPat<(DstVT (bitconvert SrcVT:$src)),
          (COPY_TO_REGCLASS SrcVT:$src, DstRC), preds>;

def : LSXBitconvertPat<v4i32, v4f32, LSX128W>;
def : LSXBitconvertPat<v2i64, v2f64, LSX128D>;
def : LSXBitconvertPat<v4f32, v4i32, LSX128W>;
def : LSXBitconvertPat<v2f64, v2i64, LSX128D>;

def : LSXBitconvertPat<v16i8, v8i16, LSX128B>;
def : LSXBitconvertPat<v16i8, v4i32, LSX128B>;
def : LSXBitconvertPat<v16i8, v2i64, LSX128B>;
def : LSXBitconvertPat<v16i8, v4f32, LSX128B>;
def : LSXBitconvertPat<v16i8, v2f64, LSX128B>;

def : LSXBitconvertPat<v8i16, v16i8, LSX128H>;
def : LSXBitconvertPat<v8i16, v4i32, LSX128H>;
def : LSXBitconvertPat<v8i16, v2i64, LSX128H>;
def : LSXBitconvertPat<v8i16, v4f32, LSX128H>;
def : LSXBitconvertPat<v8i16, v2f64, LSX128H>;

def : LSXBitconvertPat<v4i32, v16i8, LSX128W>;
def : LSXBitconvertPat<v4i32, v8i16, LSX128W>;
def : LSXBitconvertPat<v4i32, v2i64, LSX128W>;
def : LSXBitconvertPat<v4i32, v2f64, LSX128W>;

def : LSXBitconvertPat<v2i64, v16i8, LSX128D>;
def : LSXBitconvertPat<v2i64, v8i16, LSX128D>;
def : LSXBitconvertPat<v2i64, v4i32, LSX128D>;
def : LSXBitconvertPat<v2i64, v4f32, LSX128D>;

def : LSXBitconvertPat<v4f32, v16i8, LSX128W>;
def : LSXBitconvertPat<v4f32, v8i16, LSX128W>;
def : LSXBitconvertPat<v4f32, v2i64, LSX128W>;
def : LSXBitconvertPat<v4f32, v2f64, LSX128W>;

def : LSXBitconvertPat<v2f64, v16i8, LSX128D>;
def : LSXBitconvertPat<v2f64, v8i16, LSX128D>;
def : LSXBitconvertPat<v2f64, v4i32, LSX128D>;
def : LSXBitconvertPat<v2f64, v4f32, LSX128D>;




def : LSXPat<(i32 (vextract_sext_i8 v16i8:$vj, i32:$idx)),
             (SRAI_W (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG (VREPLVE_B v16i8:$vj,
                                                                  i32:$idx),
                                                         sub_lo)),
                                    GPR32), (i32 24))>;
def : LSXPat<(i32 (vextract_sext_i16 v8i16:$vj, i32:$idx)),
             (SRAI_W (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG (VREPLVE_H v8i16:$vj,
                                                                  i32:$idx),
                                                         sub_lo)),
                                    GPR32), (i32 16))>;
def : LSXPat<(i32 (vextract_sext_i32 v4i32:$vj, i32:$idx)),
             (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG (VREPLVE_W v4i32:$vj,
                                                             i32:$idx),
                                                    sub_lo)),
                               GPR32)>;
def : LSXPat<(i64 (vextract_sext_i64 v2i64:$vj, i32:$idx)),
             (COPY_TO_REGCLASS (i64 (EXTRACT_SUBREG (VREPLVE_D v2i64:$vj,
                                                             i32:$idx),
                                                    sub_64)),
                               GPR64)>;

def : LSXPat<(i32 (vextract_zext_i8 v16i8:$vj, i32:$idx)),
             (SRLI_W (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG (VREPLVE_B v16i8:$vj,
                                                                  i32:$idx),
                                                         sub_lo)),
                                    GPR32), (i32 24))>;
def : LSXPat<(i32 (vextract_zext_i16 v8i16:$vj, i32:$idx)),
             (SRLI_W (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG (VREPLVE_H v8i16:$vj,
                                                                  i32:$idx),
                                                         sub_lo)),
                                    GPR32), (i32 16))>;
def : LSXPat<(i32 (vextract_zext_i32 v4i32:$vj, i32:$idx)),
             (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG (VREPLVE_W v4i32:$vj,
                                                             i32:$idx),
                                                    sub_lo)),
                               GPR32)>;

def : LSXPat<(i64 (vextract_zext_i64 v2i64:$vj, i32:$idx)),
             (COPY_TO_REGCLASS (i64 (EXTRACT_SUBREG (VREPLVE_D v2i64:$vj,
                                                             i32:$idx),
                                                    sub_64)),
                               GPR64)>;

def : LSXPat<(f32 (vector_extract v4f32:$vj, i32:$idx)),
             (f32 (EXTRACT_SUBREG (VREPLVE_W v4f32:$vj,
                                           i32:$idx),
                                  sub_lo))>;
def : LSXPat<(f64 (vector_extract v2f64:$vj, i32:$idx)),
             (f64 (EXTRACT_SUBREG (VREPLVE_D v2f64:$vj,
                                           i32:$idx),
                                  sub_64))>;

def : LSXPat<
  (i32 (vextract_sext_i8 v16i8:$vj, i64:$idx)),
  (SRAI_W (COPY_TO_REGCLASS
         (i32 (EXTRACT_SUBREG
                (VREPLVE_B v16i8:$vj,
                  (COPY_TO_REGCLASS
                    (i32 (EXTRACT_SUBREG i64:$idx, sub_32)), GPR32)),
                sub_lo)),
         GPR32),
       (i32 24))>;
def : LSXPat<
  (i32 (vextract_sext_i16 v8i16:$vj, i64:$idx)),
  (SRAI_W (COPY_TO_REGCLASS
         (i32 (EXTRACT_SUBREG
                (VREPLVE_H v8i16:$vj,
                  (COPY_TO_REGCLASS
                    (i32 (EXTRACT_SUBREG i64:$idx, sub_32)), GPR32)),
                sub_lo)),
         GPR32),
       (i32 16))>;

def : LSXPat<
  (i32 (vextract_sext_i32 v4i32:$vj, i64:$idx)),
  (COPY_TO_REGCLASS
    (i32 (EXTRACT_SUBREG
           (VREPLVE_W v4i32:$vj,
             (COPY_TO_REGCLASS
               (i32 (EXTRACT_SUBREG i64:$idx, sub_32)), GPR32)),
           sub_lo)),
    GPR32)>;

def : LSXPat<
  (i64 (vextract_sext_i64 v2i64:$vj, i64:$idx)),
  (COPY_TO_REGCLASS
    (i64 (EXTRACT_SUBREG
           (VREPLVE_D v2i64:$vj,
             (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG i64:$idx, sub_32)), GPR32)),
           sub_64)),
    GPR64)>;

def : LSXPat<
  (i32 (vextract_zext_i8 v16i8:$vj, i64:$idx)),
  (SRLI_W (COPY_TO_REGCLASS
         (i32 (EXTRACT_SUBREG
                 (VREPLVE_B v16i8:$vj,
                   (COPY_TO_REGCLASS
                     (i32 (EXTRACT_SUBREG i64:$idx, sub_32)), GPR32)),
                 sub_lo)),
         GPR32),
       (i32 24))>;
def : LSXPat<
  (i32 (vextract_zext_i16 v8i16:$vj, i64:$idx)),
  (SRLI_W (COPY_TO_REGCLASS
         (i32 (EXTRACT_SUBREG
                (VREPLVE_H v8i16:$vj,
                  (COPY_TO_REGCLASS
                    (i32 (EXTRACT_SUBREG i64:$idx, sub_32)), GPR32)),
                sub_lo)),
         GPR32),
       (i32 16))>;
def : LSXPat<
  (i32 (vextract_zext_i32 v4i32:$vj, i64:$idx)),
  (COPY_TO_REGCLASS
    (i32 (EXTRACT_SUBREG
           (VREPLVE_W v4i32:$vj,
             (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG i64:$idx, sub_32)), GPR32)),
           sub_lo)),
    GPR32)>;
def : LSXPat<
  (i64 (vextract_zext_i64 v2i64:$vj, i64:$idx)),
  (COPY_TO_REGCLASS
    (i64 (EXTRACT_SUBREG
           (VREPLVE_D v2i64:$vj,
             (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG i64:$idx, sub_32)), GPR32)),
           sub_64)),
    GPR64)>;

  def : LSXPat<
  (f32 (vector_extract v4f32:$vj, i64:$idx)),
  (f32 (EXTRACT_SUBREG
         (VREPLVE_W v4f32:$vj,
           (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG i64:$idx, sub_32)), GPR32)),
         sub_lo))>;
def : LSXPat<
  (f64 (vector_extract v2f64:$vj, i64:$idx)),
  (f64 (EXTRACT_SUBREG
         (VREPLVE_D v2f64:$vj,
           (COPY_TO_REGCLASS (i32 (EXTRACT_SUBREG i64:$idx, sub_32)), GPR32)),
         sub_64))>;


def : LSXPat<(vfseteq_v4f32 LSX128WOpnd:$a, LSX128WOpnd:$b),
             (VFCMP_CEQ_S LSX128WOpnd:$a, LSX128WOpnd:$b)>;

def : LSXPat<(vfseteq_v2f64 LSX128DOpnd:$a, LSX128DOpnd:$b),
             (VFCMP_CEQ_D LSX128DOpnd:$a, LSX128DOpnd:$b)>;

def : LSXPat<(vfsetle_v4f32 LSX128WOpnd:$a, LSX128WOpnd:$b),
             (VFCMP_CLE_S LSX128WOpnd:$a, LSX128WOpnd:$b)>;

def : LSXPat<(vfsetle_v2f64 LSX128DOpnd:$a, LSX128DOpnd:$b),
             (VFCMP_CLE_D LSX128DOpnd:$a, LSX128DOpnd:$b)>;

def : LSXPat<(vfsetlt_v4f32 LSX128WOpnd:$a, LSX128WOpnd:$b),
             (VFCMP_CLT_S LSX128WOpnd:$a, LSX128WOpnd:$b)>;

def : LSXPat<(vfsetlt_v2f64 LSX128DOpnd:$a, LSX128DOpnd:$b),
             (VFCMP_CLT_D LSX128DOpnd:$a, LSX128DOpnd:$b)>;

def : LSXPat<(vfsetne_v4f32 LSX128WOpnd:$a, LSX128WOpnd:$b),
             (VFCMP_CNE_S LSX128WOpnd:$a, LSX128WOpnd:$b)>;

def : LSXPat<(vfsetne_v2f64 LSX128DOpnd:$a, LSX128DOpnd:$b),
             (VFCMP_CNE_D LSX128DOpnd:$a, LSX128DOpnd:$b)>;


class LSX_INSERT_PSEUDO_BASE<SDPatternOperator OpNode, ValueType Ty,
                             Operand ImmOp, ImmLeaf Imm, RegisterOperand ROVD,
                             RegisterOperand ROFS> :
      LSXPseudo<(outs ROVD:$vd), (ins ROVD:$vd_in, ImmOp:$n, ROFS:$fs),
                [(set ROVD:$vd, (OpNode (Ty ROVD:$vd_in), ROFS:$fs, Imm:$n))]> {
  bit usesCustomInserter = 1;
  string Constraints = "$vd = $vd_in";
}


class INSERT_FW_PSEUDO_DESC : LSX_INSERT_PSEUDO_BASE<vector_insert, v4f32,
                                                     uimm2, immZExt2Ptr,
                                                     LSX128WOpnd, FGR32Opnd>;
class INSERT_FD_PSEUDO_DESC : LSX_INSERT_PSEUDO_BASE<vector_insert, v2f64,
                                                     uimm1, immZExt1Ptr,
                                                     LSX128DOpnd, FGR64Opnd>;

def INSERT_FW_PSEUDO : INSERT_FW_PSEUDO_DESC;
def INSERT_FD_PSEUDO : INSERT_FD_PSEUDO_DESC;


class LSX_INSERT_VIDX_PSEUDO_BASE<SDPatternOperator OpNode, ValueType Ty,
                                  RegisterOperand ROVD, RegisterOperand ROFS,
                                  RegisterOperand ROIdx> :
      LSXPseudo<(outs ROVD:$vd), (ins ROVD:$vd_in, ROIdx:$n, ROFS:$fs),
                [(set ROVD:$vd, (OpNode (Ty ROVD:$vd_in), ROFS:$fs,
                                        ROIdx:$n))]> {
  bit usesCustomInserter = 1;
  string Constraints = "$vd = $vd_in";
}

class INSERT_H_VIDX64_PSEUDO_DESC :
      LSX_INSERT_VIDX_PSEUDO_BASE<vector_insert, v8i16, LSX128HOpnd, GPR32Opnd, GPR64Opnd>;
def INSERT_H_VIDX64_PSEUDO : INSERT_H_VIDX64_PSEUDO_DESC;

class INSERTPostRA<RegisterClass RC, RegisterClass RD, RegisterClass RE> :
  LoongArchPseudo<(outs RC:$xd), (ins RC:$xd_in, RD:$n, RE:$fs), []> {
  let mayLoad = 1;
  let mayStore = 1;
}

def INSERT_H_VIDX64_PSEUDO_POSTRA  : INSERTPostRA<LSX128H, GPR64, GPR32>;

class LSX_COPY_PSEUDO_BASE<SDPatternOperator OpNode, ValueType VecTy,
                           Operand ImmOp, ImmLeaf Imm, RegisterClass RCD,
                           RegisterClass RCVS> :
      LSXPseudo<(outs RCD:$vd), (ins RCVS:$vj, ImmOp:$n),
                [(set RCD:$vd, (OpNode (VecTy RCVS:$vj), Imm:$n))]> {
  bit usesCustomInserter = 1;
}


class COPY_FW_PSEUDO_DESC : LSX_COPY_PSEUDO_BASE<vector_extract, v4f32,
                                                 uimm2_ptr, immZExt2Ptr, FGR32,
                                                 LSX128W>;
class COPY_FD_PSEUDO_DESC : LSX_COPY_PSEUDO_BASE<vector_extract, v2f64,
                                                 uimm1_ptr, immZExt1Ptr, FGR64,
                                                 LSX128D>;
def COPY_FW_PSEUDO : COPY_FW_PSEUDO_DESC;
def COPY_FD_PSEUDO : COPY_FD_PSEUDO_DESC;


let isCodeGenOnly = 1 in {

def VST_H : LSX_I12_S<0b0010110001>,
            ST_DESC_BASE<"vst", store, v8i16, LSX128HOpnd, mem_simm12>;
def VST_W : LSX_I12_S<0b0010110001>,
            ST_DESC_BASE<"vst", store, v4i32, LSX128WOpnd, mem_simm12>;
def VST_D : LSX_I12_S<0b0010110001>,
            ST_DESC_BASE<"vst", store, v2i64, LSX128DOpnd, mem_simm12>;


def VLD_H : LSX_I12_S<0b0010110000>,
            LD_DESC_BASE<"vld", load, v8i16, LSX128HOpnd, mem_simm12>;
def VLD_W : LSX_I12_S<0b0010110000>,
            LD_DESC_BASE<"vld", load, v4i32, LSX128WOpnd, mem_simm12>;
def VLD_D : LSX_I12_S<0b0010110000>,
            LD_DESC_BASE<"vld", load, v2i64, LSX128DOpnd, mem_simm12>;



def VANDI_B_N : LSX_I8_U<0b01110011110100>,
                LSX_BIT_U8_VREPLVE_DESC_BASE<"vandi.b", and, vsplati8_uimm8, LSX128BOpnd>;


def VXORI_B_N : LSX_I8_U<0b01110011110110>,
                LSX_BIT_U8_VREPLVE_DESC_BASE<"vxori.b", xor, vsplati8_uimm8, LSX128BOpnd>;


def VSRAI_B_N : LSX_I3_U<0b0111001100110100001>,
                LSX_BIT_U3_VREPLVE_DESC_BASE<"vsrai.b", sra, vsplati8_uimm3, LSX128BOpnd>;

def VSRAI_H_N : LSX_I4_U<0b011100110011010001>,
                LSX_BIT_U4_VREPLVE_DESC_BASE<"vsrai.h", sra, vsplati16_uimm4, LSX128HOpnd>;

def VSRAI_W_N : LSX_I5_U<0b01110011001101001>,
                LSX_BIT_U5_VREPLVE_DESC_BASE<"vsrai.w", sra, vsplati32_uimm5, LSX128WOpnd>;

def VSRAI_D_N : LSX_I6_U<0b0111001100110101>,
                LSX_BIT_U6_VREPLVE_DESC_BASE<"vsrai.d", sra, vsplati64_uimm6, LSX128DOpnd>;


def VMAXI_BU_N : LSX_I5_U<0b01110010100101000>,
                 LSX_I5_U_DESC_BASE<"vmaxi.bu", umax, vsplati8_uimm5, LSX128BOpnd>;

def VMAXI_HU_N : LSX_I5_U<0b01110010100101001>,
                 LSX_I5_U_DESC_BASE<"vmaxi.hu", umax, vsplati16_uimm5, LSX128HOpnd>;

def VMAXI_WU_N : LSX_I5_U<0b01110010100101010>,
                 LSX_I5_U_DESC_BASE<"vmaxi.wu", umax, vsplati32_uimm5, LSX128WOpnd>;

def VMAXI_DU_N : LSX_I5_U<0b01110010100101011>,
                 LSX_I5_U_DESC_BASE<"vmaxi.du", umax, vsplati64_uimm5, LSX128DOpnd>;


def VMINI_B_N : LSX_I5<0b01110010100100100>,
                LSX_I5_DESC_BASE<"vmini.b", smin, vsplati8_simm5, LSX128BOpnd>;

def VMINI_H_N : LSX_I5<0b01110010100100101>,
                LSX_I5_DESC_BASE<"vmini.h", smin, vsplati16_simm5, LSX128HOpnd>;

def VMINI_W_N : LSX_I5<0b01110010100100110>,
                LSX_I5_DESC_BASE<"vmini.w", smin, vsplati32_simm5, LSX128WOpnd>;

def VMINI_D_N : LSX_I5<0b01110010100100111>,
                LSX_I5_DESC_BASE<"vmini.d", smin, vsplati64_simm5, LSX128DOpnd>;


def VMAXI_B_N : LSX_I5<0b01110010100100000>,
                LSX_I5_DESC_BASE<"vmaxi.b", smax, vsplati8_simm5, LSX128BOpnd>;

def VMAXI_H_N : LSX_I5<0b01110010100100001>,
                LSX_I5_DESC_BASE<"vmaxi.h", smax, vsplati16_simm5, LSX128HOpnd>;

def VMAXI_W_N : LSX_I5<0b01110010100100010>,
                LSX_I5_DESC_BASE<"vmaxi.w", smax, vsplati32_simm5, LSX128WOpnd>;

def VMAXI_D_N : LSX_I5<0b01110010100100011>,
                LSX_I5_DESC_BASE<"vmaxi.d", smax, vsplati64_simm5, LSX128DOpnd>;


def VSEQI_B_N : LSX_I5<0b01110010100000000>,
                LSX_I5_DESC_BASE<"vseqi.b", vseteq_v16i8, vsplati8_simm5, LSX128BOpnd>;

def VSEQI_H_N : LSX_I5<0b01110010100000001>,
                LSX_I5_DESC_BASE<"vseqi.h", vseteq_v8i16, vsplati16_simm5, LSX128HOpnd>;

def VSEQI_W_N : LSX_I5<0b01110010100000010>,
                LSX_I5_DESC_BASE<"vseqi.w", vseteq_v4i32, vsplati32_simm5, LSX128WOpnd>;

def VSEQI_D_N : LSX_I5<0b01110010100000011>,
                LSX_I5_DESC_BASE<"vseqi.d", vseteq_v2i64, vsplati64_simm5, LSX128DOpnd>;


def VSLEI_B_N : LSX_I5<0b01110010100000100>,
                LSX_I5_DESC_BASE<"vslei.b", vsetle_v16i8, vsplati8_simm5, LSX128BOpnd>;

def VSLEI_H_N : LSX_I5<0b01110010100000101>,
                LSX_I5_DESC_BASE<"vslei.h", vsetle_v8i16, vsplati16_simm5, LSX128HOpnd>;

def VSLEI_W_N : LSX_I5<0b01110010100000110>,
                LSX_I5_DESC_BASE<"vslei.w", vsetle_v4i32, vsplati32_simm5, LSX128WOpnd>;

def VSLEI_D_N : LSX_I5<0b01110010100000111>,
                LSX_I5_DESC_BASE<"vslei.d", vsetle_v2i64, vsplati64_simm5, LSX128DOpnd>;

def VSLEI_BU_N : LSX_I5_U<0b01110010100001000>,
                 LSX_I5_U_DESC_BASE<"vslei.bu", vsetule_v16i8, vsplati8_uimm5, LSX128BOpnd>;

def VSLEI_HU_N : LSX_I5_U<0b01110010100001001>,
                 LSX_I5_U_DESC_BASE<"vslei.hu", vsetule_v8i16, vsplati16_uimm5, LSX128HOpnd>;

def VSLEI_WU_N : LSX_I5_U<0b01110010100001010>,
                 LSX_I5_U_DESC_BASE<"vslei.wu", vsetule_v4i32, vsplati32_uimm5, LSX128WOpnd>;

def VSLEI_DU_N : LSX_I5_U<0b01110010100001011>,
                 LSX_I5_U_DESC_BASE<"vslei.du", vsetule_v2i64, vsplati64_uimm5, LSX128DOpnd>;


def VSLTI_B_N : LSX_I5<0b01110010100001100>,
                LSX_I5_DESC_BASE<"vslti.b", vsetlt_v16i8, vsplati8_simm5, LSX128BOpnd>;

def VSLTI_H_N : LSX_I5<0b01110010100001101>,
                LSX_I5_DESC_BASE<"vslti.h", vsetlt_v8i16, vsplati16_simm5, LSX128HOpnd>;

def VSLTI_W_N : LSX_I5<0b01110010100001110>,
                LSX_I5_DESC_BASE<"vslti.w", vsetlt_v4i32, vsplati32_simm5, LSX128WOpnd>;

def VSLTI_D_N : LSX_I5<0b01110010100001111>,
                LSX_I5_DESC_BASE<"vslti.d", vsetlt_v2i64, vsplati64_simm5, LSX128DOpnd>;


def VSLTI_BU_N : LSX_I5_U<0b01110010100010000>,
                 LSX_I5_U_DESC_BASE<"vslti.bu", vsetult_v16i8, vsplati8_uimm5, LSX128BOpnd>;

def VSLTI_HU_N : LSX_I5_U<0b01110010100010001>,
                 LSX_I5_U_DESC_BASE<"vslti.hu", vsetult_v8i16, vsplati16_uimm5, LSX128HOpnd>;

def VSLTI_WU_N : LSX_I5_U<0b01110010100010010>,
                 LSX_I5_U_DESC_BASE<"vslti.wu", vsetult_v4i32, vsplati32_uimm5, LSX128WOpnd>;

def VSLTI_DU_N : LSX_I5_U<0b01110010100010011>,
                 LSX_I5_U_DESC_BASE<"vslti.du", vsetult_v2i64, vsplati64_uimm5, LSX128DOpnd>;


def VBITSELI_B_N : LSX_I8_U<0b01110011110001>,
                   LSX_2R_3R_SELECT<"vbitseli.b", vselect, LSX128BOpnd, LSX128BOpnd>;

}


def : LSXPat<(v4f32 (load addrimm12:$addr)), (VLD_W addrimm12:$addr)>;
def : LSXPat<(v2f64 (load addrimm12:$addr)), (VLD_D addrimm12:$addr)>;

def VST_FW : LSXPat<(store (v4f32 LSX128W:$vj), addrimm12:$addr),
                    (VST_W LSX128W:$vj, addrimm12:$addr)>;
def VST_FD : LSXPat<(store (v2f64 LSX128D:$vj), addrimm12:$addr),
                    (VST_D LSX128D:$vj, addrimm12:$addr)>;

def VNEG_FW : LSXPat<(fneg (v4f32 LSX128W:$vj)),
                     (VBITREVI_W LSX128W:$vj, 31)>;
def VNEG_FD : LSXPat<(fneg (v2f64 LSX128D:$vj)),
                     (VBITREVI_D LSX128D:$vj, 63)>;


def : LSXPat<(v2i64 (LoongArchVABSD v2i64:$vj, v2i64:$vk, (i32 0))),
             (v2i64 (VABSD_D $vj, $vk))>;

def : LSXPat<(v4i32 (LoongArchVABSD v4i32:$vj, v4i32:$vk, (i32 0))),
             (v4i32 (VABSD_W $vj, $vk))>;

def : LSXPat<(v8i16 (LoongArchVABSD v8i16:$vj, v8i16:$vk, (i32 0))),
             (v8i16 (VABSD_H $vj, $vk))>;

def : LSXPat<(v16i8 (LoongArchVABSD v16i8:$vj, v16i8:$vk, (i32 0))),
             (v16i8 (VABSD_B $vj, $vk))>;

def : LSXPat<(v2i64 (LoongArchUVABSD v2i64:$vj, v2i64:$vk, (i32 0))),
             (v2i64 (VABSD_DU $vj, $vk))>;

def : LSXPat<(v4i32 (LoongArchUVABSD v4i32:$vj, v4i32:$vk, (i32 0))),
             (v4i32 (VABSD_WU $vj, $vk))>;

def : LSXPat<(v8i16 (LoongArchUVABSD v8i16:$vj, v8i16:$vk, (i32 0))),
             (v8i16 (VABSD_HU $vj, $vk))>;

def : LSXPat<(v16i8 (LoongArchUVABSD v16i8:$vj, v16i8:$vk, (i32 0))),
             (v16i8 (VABSD_BU $vj, $vk))>;


def : LSXPat<(or v16i8:$vj, (shl vsplat_imm_eq_1, v16i8:$vk)),
             (VBITSET_B v16i8:$vj, v16i8:$vk)>;
def : LSXPat<(or v8i16:$vj, (shl vsplat_imm_eq_1, v8i16:$vk)),
             (VBITSET_H v8i16:$vj, v8i16:$vk)>;
def : LSXPat<(or v4i32:$vj, (shl vsplat_imm_eq_1, v4i32:$vk)),
             (VBITSET_W v4i32:$vj, v4i32:$vk)>;
def : LSXPat<(or v2i64:$vj, (shl vsplat_imm_eq_1, v2i64:$vk)),
             (VBITSET_D v2i64:$vj, v2i64:$vk)>;

def : LSXPat<(xor v16i8:$vj, (shl vsplat_imm_eq_1, v16i8:$vk)),
             (VBITREV_B v16i8:$vj, v16i8:$vk)>;
def : LSXPat<(xor v8i16:$vj, (shl vsplat_imm_eq_1, v8i16:$vk)),
             (VBITREV_H v8i16:$vj, v8i16:$vk)>;
def : LSXPat<(xor v4i32:$vj, (shl vsplat_imm_eq_1, v4i32:$vk)),
             (VBITREV_W v4i32:$vj, v4i32:$vk)>;
def : LSXPat<(xor v2i64:$vj, (shl (v2i64 vsplati64_imm_eq_1), v2i64:$vk)),
             (VBITREV_D v2i64:$vj, v2i64:$vk)>;

def : LSXPat<(and v16i8:$vj, (xor (shl vsplat_imm_eq_1, v16i8:$vk), immAllOnesV)),
             (VBITCLR_B v16i8:$vj, v16i8:$vk)>;
def : LSXPat<(and v8i16:$vj, (xor (shl vsplat_imm_eq_1, v8i16:$vk), immAllOnesV)),
             (VBITCLR_H v8i16:$vj, v8i16:$vk)>;
def : LSXPat<(and v4i32:$vj, (xor (shl vsplat_imm_eq_1, v4i32:$vk), immAllOnesV)),
             (VBITCLR_W v4i32:$vj, v4i32:$vk)>;
def : LSXPat<(and v2i64:$vj, (xor (shl (v2i64 vsplati64_imm_eq_1), v2i64:$vk), (bitconvert (v4i32 immAllOnesV)))),
             (VBITCLR_D v2i64:$vj, v2i64:$vk)>;
def vsplati64_imm_eq_63 : PatLeaf<(bitconvert (v4i32 (build_vector))), [{
  APInt Imm;
  SDNode *BV = N->getOperand(0).getNode();
  EVT EltTy = N->getValueType(0).getVectorElementType();

  return selectVSplat(BV, Imm, EltTy.getSizeInBits()) &&
         Imm.getBitWidth() == EltTy.getSizeInBits() && Imm == 63;
}]>;

def immi32Cst7  : ImmLeaf<i32, [{return isUInt<32>(Imm) && Imm == 7;}]>;
def immi32Cst15 : ImmLeaf<i32, [{return isUInt<32>(Imm) && Imm == 15;}]>;
def immi32Cst31 : ImmLeaf<i32, [{return isUInt<32>(Imm) && Imm == 31;}]>;

def vsplati8imm7 :   PatFrag<(ops node:$vt),
                             (and node:$vt, (vsplati8 immi32Cst7))>;
def vsplati16imm15 : PatFrag<(ops node:$vt),
                             (and node:$vt, (vsplati16 immi32Cst15))>;
def vsplati32imm31 : PatFrag<(ops node:$vt),
                             (and node:$vt, (vsplati32 immi32Cst31))>;
def vsplati64imm63 : PatFrag<(ops node:$vt),
                             (and node:$vt, vsplati64_imm_eq_63)>;

class LSXShiftPat<SDNode Node, ValueType VT, LSXInst Insn, dag Vec> :
  LSXPat<(VT (Node VT:$vs, (VT (and VT:$vt, Vec)))),
         (VT (Insn VT:$vs, VT:$vt))>;

class LSXBitPat<SDNode Node, ValueType VT, LSXInst Insn, PatFrag Frag> :
  LSXPat<(VT (Node VT:$vs, (shl vsplat_imm_eq_1, (Frag VT:$vt)))),
         (VT (Insn VT:$vs, VT:$vt))>;

multiclass LSXShiftPats<SDNode Node, string Insn> {
  def : LSXShiftPat<Node, v16i8, !cast<LSXInst>(Insn#_B),
                    (vsplati8 immi32Cst7)>;
  def : LSXShiftPat<Node, v8i16, !cast<LSXInst>(Insn#_H),
                    (vsplati16 immi32Cst15)>;
  def : LSXShiftPat<Node, v4i32, !cast<LSXInst>(Insn#_W),
                    (vsplati32 immi32Cst31)>;
  def : LSXPat<(v2i64 (Node v2i64:$vs, (v2i64 (and v2i64:$vt,
                                                   vsplati64_imm_eq_63)))),
               (v2i64 (!cast<LSXInst>(Insn#_D) v2i64:$vs, v2i64:$vt))>;
}

multiclass LSXBitPats<SDNode Node, string Insn> {
  def : LSXBitPat<Node, v16i8, !cast<LSXInst>(Insn#_B), vsplati8imm7>;
  def : LSXBitPat<Node, v8i16, !cast<LSXInst>(Insn#_H), vsplati16imm15>;
  def : LSXBitPat<Node, v4i32, !cast<LSXInst>(Insn#_W), vsplati32imm31>;
  def : LSXPat<(Node v2i64:$vs, (shl (v2i64 vsplati64_imm_eq_1),
                                     (vsplati64imm63 v2i64:$vt))),
               (v2i64 (!cast<LSXInst>(Insn#_D) v2i64:$vs, v2i64:$vt))>;
}

defm : LSXShiftPats<shl, "VSLL">;
defm : LSXShiftPats<srl, "VSRL">;
defm : LSXShiftPats<sra, "VSRA">;
defm : LSXBitPats<xor, "VBITREV">;
defm : LSXBitPats<or, "VBITSET">;

def : LSXPat<(and v16i8:$vs, (xor (shl vsplat_imm_eq_1,
                                       (vsplati8imm7 v16i8:$vt)),
                                       immAllOnesV)),
             (v16i8 (VBITCLR_B v16i8:$vs, v16i8:$vt))>;
def : LSXPat<(and v8i16:$vs, (xor (shl vsplat_imm_eq_1,
                                       (vsplati16imm15 v8i16:$vt)),
                                       immAllOnesV)),
             (v8i16 (VBITCLR_H v8i16:$vs, v8i16:$vt))>;
def : LSXPat<(and v4i32:$vs, (xor (shl vsplat_imm_eq_1,
                                       (vsplati32imm31 v4i32:$vt)),
                                       immAllOnesV)),
             (v4i32 (VBITCLR_W v4i32:$vs, v4i32:$vt))>;
def : LSXPat<(and v2i64:$vs, (xor (shl (v2i64 vsplati64_imm_eq_1),
                                       (vsplati64imm63 v2i64:$vt)),
                                       (bitconvert (v4i32 immAllOnesV)))),
             (v2i64 (VBITCLR_D v2i64:$vs, v2i64:$vt))>;


def : LSXPat<(fdiv (v4f32 (build_vector (f32 fpimm1), (f32 fpimm1), (f32 fpimm1), (f32 fpimm1))), v4f32:$v),
             (VFRECIP_S v4f32:$v)>;

def : LSXPat<(fdiv (v2f64 (build_vector (f64 fpimm1), (f64 fpimm1))), v2f64:$v),
             (VFRECIP_D v2f64:$v)>;

def : LSXPat<(fdiv (v4f32 fpimm1), v4f32:$v),
             (VFRECIP_S v4f32:$v)>;

def : LSXPat<(fdiv (v2f64 fpimm1), v2f64:$v),
             (VFRECIP_D v2f64:$v)>;


def : LSXPat<(fdiv (v4f32 (build_vector (f32 fpimm1), (f32 fpimm1), (f32 fpimm1), (f32 fpimm1))), (fsqrt v4f32:$v)),
             (VFRSQRT_S v4f32:$v)>;

def : LSXPat<(fdiv (v2f64 (build_vector (f64 fpimm1), (f64 fpimm1))), (fsqrt v2f64:$v)),
             (VFRSQRT_D v2f64:$v)>;

def : LSXPat<(fdiv (v4f32 fpimm1), (fsqrt v4f32:$v)),
             (VFRSQRT_S v4f32:$v)>;

def : LSXPat<(fdiv (v2f64 fpimm1), (fsqrt v2f64:$v)),
             (VFRSQRT_D v2f64:$v)>;


def : LSXPat<(abs v2i64:$v),
             (VMAX_D v2i64:$v, (VNEG_D v2i64:$v))>;

def : LSXPat<(abs v4i32:$v),
             (VMAX_W v4i32:$v, (VNEG_W v4i32:$v))>;

def : LSXPat<(abs v8i16:$v),
             (VMAX_H v8i16:$v, (VNEG_H v8i16:$v))>;

def : LSXPat<(abs v16i8:$v),
             (VMAX_B v16i8:$v, (VNEG_B v16i8:$v))>;


def : LSXPat<(sub (v16i8 immAllZerosV), v16i8:$v),
             (VNEG_B v16i8:$v)>;

def : LSXPat<(sub (v8i16 immAllZerosV), v8i16:$v),
             (VNEG_H v8i16:$v)>;

def : LSXPat<(sub (v4i32 immAllZerosV), v4i32:$v),
             (VNEG_W v4i32:$v)>;

def : LSXPat<(sub (v2i64 immAllZerosV), v2i64:$v),
             (VNEG_D v2i64:$v)>;


def : LSXPat<(sra
            (v16i8 (add
                    (v16i8 (add LSX128B:$a, LSX128B:$b)),
                    (v16i8 (srl
                           (v16i8 (add LSX128B:$a, LSX128B:$b)),
                           (v16i8 (build_vector (i32 7),(i32 7),(i32 7),(i32 7),
                                                (i32 7),(i32 7),(i32 7),(i32 7),
                                                (i32 7),(i32 7),(i32 7),(i32 7),
                                                (i32 7),(i32 7),(i32 7),(i32 7))
                           )
                       )
                 )
                 )
            ),
          (v16i8 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1)
          ))),
          (VAVG_B  (v16i8 LSX128B:$a), (v16i8 LSX128B:$b))>;

def : LSXPat<(sra
            (v8i16 (add
                    (v8i16 (add LSX128H:$a, LSX128H:$b)),
                    (v8i16 (srl
                           (v8i16 (add LSX128H:$a, LSX128H:$b)),
                           (v8i16 (build_vector (i32 15),(i32 15),(i32 15),(i32 15),
                                                (i32 15),(i32 15),(i32 15),(i32 15))
                           )
                       )
                 )
                 )
            ),
          (v8i16 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1)
          ))),
          (VAVG_H  (v8i16 LSX128H:$a), (v8i16 LSX128H:$b))>;

def : LSXPat<(sra
            (v4i32 (add
                    (v4i32 (add LSX128W:$a, LSX128W:$b)),
                    (v4i32 (srl
                           (v4i32 (add LSX128W:$a, LSX128W:$b)),
                           (v4i32 (build_vector (i32 31),(i32 31),(i32 31),(i32 31))
                           )
                       )
                 )
                 )
            ),
          (v4i32 (build_vector (i32 1),(i32 1),(i32 1),(i32 1)))),
          (VAVG_W  (v4i32 LSX128W:$a), (v4i32 LSX128W:$b))>;

def : LSXPat<(sra
              (v2i64 (add
                      (v2i64 (add LSX128D:$a, LSX128D:$b)),
                      (v2i64 (srl
                                (v2i64 (add LSX128D:$a, LSX128D:$b)),
                                (v2i64 (build_vector (i64 63),(i64 63)))
                            )
                      )
                      )
              ),
          (v2i64 (build_vector (i64 1),(i64 1)))),
          (VAVG_D  (v2i64 LSX128D:$a), (v2i64 LSX128D:$b))>;



def : LSXPat<(srl
               (v16i8 (add LSX128B:$a, LSX128B:$b)),
               (v16i8 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1))
                           )
            ),
          (VAVG_BU  (v16i8 LSX128B:$a), (v16i8 LSX128B:$b))>;

def : LSXPat<(srl
               (v8i16 (add LSX128H:$a, LSX128H:$b)),
               (v8i16 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1))
                           )
            ),
          (VAVG_HU  (v8i16 LSX128H:$a), (v8i16 LSX128H:$b))>;

def : LSXPat<(srl
               (v4i32 (add LSX128W:$a, LSX128W:$b)),
               (v4i32 (build_vector (i32 1),(i32 1),(i32 1),(i32 1))
                           )
            ),
          (VAVG_WU  (v4i32 LSX128W:$a), (v4i32 LSX128W:$b))>;

def : LSXPat<(srl
               (v2i64 (add LSX128D:$a, LSX128D:$b)),
               (v2i64 (build_vector (i64 1),(i64 1))
                           )
            ),
          (VAVG_DU  (v2i64 LSX128D:$a), (v2i64 LSX128D:$b))>;




def : LSXPat<(sra
            (v16i8 (add
                    (v16i8 (add (v16i8 (
                    build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1)
                    )),
                    (v16i8 (add LSX128B:$a, LSX128B:$b))
                    )),
                    (v16i8 (srl
                           (v16i8 ( add (v16i8(
                             build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                        (i32 1),(i32 1),(i32 1),(i32 1),
                                        (i32 1),(i32 1),(i32 1),(i32 1),
                                        (i32 1),(i32 1),(i32 1),(i32 1)
                           )),
                           (v16i8 (add LSX128B:$a, LSX128B:$b))
                           )),
                           (v16i8 (build_vector (i32 7),(i32 7),(i32 7),(i32 7),
                                                (i32 7),(i32 7),(i32 7),(i32 7),
                                                (i32 7),(i32 7),(i32 7),(i32 7),
                                                (i32 7),(i32 7),(i32 7),(i32 7))
                           )
                       )
                 )
                 )
            ),
          (v16i8 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1)
          ))),
          (VAVGR_B  (v16i8 LSX128B:$a), (v16i8 LSX128B:$b))>;

def : LSXPat<(sra
            (v8i16 (add
                    (v8i16 (add (v8i16 (
                       build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1)
                    )),
                    (v8i16 (add LSX128H:$a, LSX128H:$b))
                    )),
                    (v8i16 (srl
                       (v8i16 (add (v8i16 (
                          build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                       (i32 1),(i32 1),(i32 1),(i32 1)
                       )),
                       (v8i16 (add LSX128H:$a, LSX128H:$b))
                       )),
                           (v8i16 (build_vector (i32 15),(i32 15),(i32 15),(i32 15),
                                                (i32 15),(i32 15),(i32 15),(i32 15))
                           )
                       )
                 )
                 )
            ),
          (v8i16 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1)
          ))),
          (VAVGR_H  (v8i16 LSX128H:$a), (v8i16 LSX128H:$b))>;

def : LSXPat<(sra
            (v4i32 (add
                      (v4i32 (add (v4i32 (
                         build_vector (i32 1),(i32 1),(i32 1),(i32 1)
                      )),
                      (v4i32 (add LSX128W:$a, LSX128W:$b))
                      )),
                    (v4i32 (srl
                        (v4i32 (add (v4i32 (
                           build_vector (i32 1),(i32 1),(i32 1),(i32 1)
                        )),
                        (v4i32 (add LSX128W:$a, LSX128W:$b))
                        )),
                           (v4i32 (build_vector (i32 31),(i32 31),(i32 31),(i32 31))
                           )
                       )
                 )
                 )
            ),
          (v4i32 (build_vector (i32 1),(i32 1),(i32 1),(i32 1)))),
          (VAVGR_W  (v4i32 LSX128W:$a), (v4i32 LSX128W:$b))>;

def : LSXPat<(sra
              (v2i64 (add
                         (v2i64 (add (v2i64 (
                            build_vector (i64 1),(i64 1)
                         )),
                         (v2i64 (add LSX128D:$a, LSX128D:$b))
                         )),
                      (v2i64 (srl
                         (v2i64 (add (v2i64 (
                            build_vector (i64 1),(i64 1)
                         )),
                         (v2i64 (add LSX128D:$a, LSX128D:$b))
                         )),
                                (v2i64 (build_vector (i64 63),(i64 63)))
                            )
                      )
                      )
              ),
          (v2i64 (build_vector (i64 1),(i64 1)))),
          (VAVGR_D  (v2i64 LSX128D:$a), (v2i64 LSX128D:$b))>;




def : LSXPat<(srl
               (v16i8 (add (v16i8 (
               build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                          (i32 1),(i32 1),(i32 1),(i32 1),
                          (i32 1),(i32 1),(i32 1),(i32 1),
                          (i32 1),(i32 1),(i32 1),(i32 1)
               )),
               (v16i8 (add LSX128B:$a, LSX128B:$b))
               )),
               (v16i8 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1))
                           )
            ),
          (VAVGR_BU  (v16i8 LSX128B:$a), (v16i8 LSX128B:$b))>;

def : LSXPat<(srl
               (v8i16 (add (v8i16 (
                  build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                               (i32 1),(i32 1),(i32 1),(i32 1)
               )),
               (v8i16 (add LSX128H:$a, LSX128H:$b))
               )),
               (v8i16 (build_vector (i32 1),(i32 1),(i32 1),(i32 1),
                                    (i32 1),(i32 1),(i32 1),(i32 1))
                           )
            ),
          (VAVGR_HU  (v8i16 LSX128H:$a), (v8i16 LSX128H:$b))>;

def : LSXPat<(srl
               (v4i32 (add (v4i32 (
                  build_vector (i32 1),(i32 1),(i32 1),(i32 1)
               )),
               (v4i32 (add LSX128W:$a, LSX128W:$b))
               )),
               (v4i32 (build_vector (i32 1),(i32 1),(i32 1),(i32 1))
                           )
            ),
          (VAVGR_WU  (v4i32 LSX128W:$a), (v4i32 LSX128W:$b))>;

def : LSXPat<(srl
               (v2i64 (add (v2i64 (
                  build_vector (i64 1),(i64 1)
               )),
               (v2i64 (add LSX128D:$a, LSX128D:$b))
               )),
               (v2i64 (build_vector (i64 1),(i64 1))
                           )
            ),
          (VAVGR_DU  (v2i64 LSX128D:$a), (v2i64 LSX128D:$b))>;


def : LSXPat<(mulhs LSX128D:$a, LSX128D:$b),
             (VMUH_D LSX128D:$a, LSX128D:$b)>;

def : LSXPat<(mulhs LSX128W:$a, LSX128W:$b),
             (VMUH_W LSX128W:$a, LSX128W:$b)>;

def : LSXPat<(mulhs LSX128H:$a, LSX128H:$b),
             (VMUH_H LSX128H:$a, LSX128H:$b)>;

def : LSXPat<(mulhs LSX128B:$a, LSX128B:$b),
             (VMUH_B LSX128B:$a, LSX128B:$b)>;


def : LSXPat<(mulhu LSX128D:$a, LSX128D:$b),
             (VMUH_DU LSX128D:$a, LSX128D:$b)>;

def : LSXPat<(mulhu LSX128W:$a, LSX128W:$b),
            (VMUH_WU LSX128W:$a, LSX128W:$b)>;

def : LSXPat<(mulhu LSX128H:$a, LSX128H:$b),
             (VMUH_HU LSX128H:$a, LSX128H:$b)>;

def : LSXPat<(mulhu LSX128B:$a, LSX128B:$b),
             (VMUH_BU LSX128B:$a, LSX128B:$b)>;



//===----------------------------------------------------------------------===//
// Intrinsics
//===----------------------------------------------------------------------===//

def : LSXPat<(int_loongarch_lsx_vseq_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSEQ_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vseq_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSEQ_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vseq_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSEQ_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vseq_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSEQ_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vsle_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSLE_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsle_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSLE_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsle_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSLE_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsle_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSLE_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vsle_bu (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSLE_BU LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsle_hu (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSLE_HU LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsle_wu (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSLE_WU LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsle_du (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSLE_DU LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vslt_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSLT_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vslt_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSLT_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vslt_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSLT_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vslt_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSLT_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vslt_bu (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSLT_BU LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vslt_hu (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSLT_HU LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vslt_wu (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSLT_WU LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vslt_du (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSLT_DU LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vadd_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VADD_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vadd_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VADD_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vadd_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VADD_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vadd_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VADD_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vsub_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSUB_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsub_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSUB_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsub_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSUB_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsub_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSUB_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vsadd_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSADD_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsadd_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSADD_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsadd_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSADD_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsadd_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSADD_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vssub_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSSUB_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vssub_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSSUB_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vssub_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSSUB_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vssub_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSSUB_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vsadd_bu (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSADD_BU LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsadd_hu (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSADD_HU LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsadd_wu (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSADD_WU LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsadd_du (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSADD_DU LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vssub_bu (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSSUB_BU LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vssub_hu (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSSUB_HU LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vssub_wu (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSSUB_WU LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vssub_du (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSSUB_DU LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vhaddw_h_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VHADDW_H_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vhaddw_w_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VHADDW_W_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vhaddw_d_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VHADDW_D_W LSX128W:$vj, LSX128W:$vk)>;

def : LSXPat<(int_loongarch_lsx_vhsubw_h_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VHSUBW_H_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vhsubw_w_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VHSUBW_W_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vhsubw_d_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VHSUBW_D_W LSX128W:$vj, LSX128W:$vk)>;

def : LSXPat<(int_loongarch_lsx_vhaddw_hu_bu (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VHADDW_HU_BU LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vhaddw_wu_hu (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VHADDW_WU_HU LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vhaddw_du_wu (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VHADDW_DU_WU LSX128W:$vj, LSX128W:$vk)>;

def : LSXPat<(int_loongarch_lsx_vhsubw_hu_bu (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VHSUBW_HU_BU LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vhsubw_wu_hu (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VHSUBW_WU_HU LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vhsubw_du_wu (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VHSUBW_DU_WU LSX128W:$vj, LSX128W:$vk)>;

def : LSXPat<(int_loongarch_lsx_vadda_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VADDA_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vadda_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VADDA_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vadda_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VADDA_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vadda_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VADDA_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vabsd_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VABSD_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vabsd_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VABSD_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vabsd_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VABSD_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vabsd_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VABSD_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vabsd_bu (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VABSD_BU LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vabsd_hu (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VABSD_HU LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vabsd_wu (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VABSD_WU LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vabsd_du (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VABSD_DU LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vavg_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VAVG_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavg_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VAVG_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavg_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VAVG_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavg_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VAVG_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vavg_bu (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VAVG_BU LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavg_hu (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VAVG_HU LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavg_wu (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VAVG_WU LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavg_du (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VAVG_DU LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vavgr_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VAVGR_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavgr_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VAVGR_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavgr_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VAVGR_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavgr_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VAVGR_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vavgr_bu (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VAVGR_BU LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavgr_hu (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VAVGR_HU LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavgr_wu (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VAVGR_WU LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vavgr_du (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VAVGR_DU LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vsrlr_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSRLR_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsrlr_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSRLR_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsrlr_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSRLR_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsrlr_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSRLR_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vsrar_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VSRAR_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsrar_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VSRAR_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsrar_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VSRAR_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vsrar_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VSRAR_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vbitset_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VBITSET_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vbitset_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VBITSET_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vbitset_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VBITSET_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vbitset_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VBITSET_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vbitrev_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk)),
             (VBITREV_B LSX128B:$vj, LSX128B:$vk)>;
def : LSXPat<(int_loongarch_lsx_vbitrev_h (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk)),
             (VBITREV_H LSX128H:$vj, LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vbitrev_w (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk)),
             (VBITREV_W LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vbitrev_d (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk)),
             (VBITREV_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfadd_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFADD_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfadd_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFADD_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfsub_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFSUB_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfsub_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFSUB_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfmax_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFMAX_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfmax_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFMAX_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfmin_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFMIN_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfmin_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFMIN_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfmaxa_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFMAXA_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfmaxa_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFMAXA_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfmina_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFMINA_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfmina_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFMINA_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vclo_b (v16i8 LSX128B:$vj)),
             (VCLO_B LSX128B:$vj)>;
def : LSXPat<(int_loongarch_lsx_vclo_h (v8i16 LSX128H:$vj)),
             (VCLO_H LSX128H:$vj)>;
def : LSXPat<(int_loongarch_lsx_vclo_w (v4i32 LSX128W:$vj)),
             (VCLO_W LSX128W:$vj)>;
def : LSXPat<(int_loongarch_lsx_vclo_d (v2i64 LSX128D:$vj)),
             (VCLO_D LSX128D:$vj)>;

def : LSXPat<(int_loongarch_lsx_vflogb_s (v4f32 LSX128W:$vj)),
             (VFLOGB_S LSX128W:$vj)>;
def : LSXPat<(int_loongarch_lsx_vflogb_d (v2f64 LSX128D:$vj)),
             (VFLOGB_D LSX128D:$vj)>;

def : LSXPat<(int_loongarch_lsx_vfclass_s (v4f32 LSX128W:$vj)),
             (VFCLASS_S LSX128W:$vj)>;
def : LSXPat<(int_loongarch_lsx_vfclass_d (v2f64 LSX128D:$vj)),
             (VFCLASS_D LSX128D:$vj)>;

def : LSXPat<(int_loongarch_lsx_vfrecip_s (v4f32 LSX128W:$vj)),
             (VFRECIP_S LSX128W:$vj)>;
def : LSXPat<(int_loongarch_lsx_vfrecip_d (v2f64 LSX128D:$vj)),
             (VFRECIP_D LSX128D:$vj)>;

def : LSXPat<(int_loongarch_lsx_vfrsqrt_s (v4f32 LSX128W:$vj)),
             (VFRSQRT_S LSX128W:$vj)>;
def : LSXPat<(int_loongarch_lsx_vfrsqrt_d (v2f64 LSX128D:$vj)),
             (VFRSQRT_D LSX128D:$vj)>;

def : LSXPat<(int_loongarch_lsx_vfcvtl_s_h  (v8i16 LSX128H:$vk)),
             (VFCVTL_S_H  LSX128H:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcvth_s_h  (v8i16 LSX128H:$vk)),
             (VFCVTH_S_H  LSX128H:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfcvtl_d_s (v4f32 LSX128W:$vj)),
             (VFCVTL_D_S LSX128W:$vj)>;
def : LSXPat<(int_loongarch_lsx_vfcvth_d_s (v4f32 LSX128W:$vj)),
             (VFCVTH_D_S LSX128W:$vj)>;

def : LSXPat<(int_loongarch_lsx_vftint_w_s (v4f32 LSX128W:$vj)),
             (VFTINT_W_S LSX128W:$vj)>;
def : LSXPat<(int_loongarch_lsx_vftint_l_d (v2f64 LSX128D:$vj)),
             (VFTINT_L_D LSX128D:$vj)>;

def : LSXPat<(int_loongarch_lsx_vftint_wu_s (v4f32 LSX128W:$vj)),
             (VFTINT_WU_S LSX128W:$vj)>;
def : LSXPat<(int_loongarch_lsx_vftint_lu_d (v2f64 LSX128D:$vj)),
             (VFTINT_LU_D LSX128D:$vj)>;

def : LSXPat<(int_loongarch_lsx_vreplgr2vr_b GPR32Opnd:$rj),
             (VREPLGR2VR_B GPR32Opnd:$rj)>;
def : LSXPat<(int_loongarch_lsx_vreplgr2vr_h GPR32Opnd:$rj),
             (VREPLGR2VR_H GPR32Opnd:$rj)>;
def : LSXPat<(int_loongarch_lsx_vreplgr2vr_w GPR32Opnd:$rj),
             (VREPLGR2VR_W GPR32Opnd:$rj)>;
def : LSXPat<(int_loongarch_lsx_vreplgr2vr_d GPR64Opnd:$rj),
             (VREPLGR2VR_D GPR64Opnd:$rj)>;

def : LSXPat<(int_loongarch_lsx_vsrlri_b (v16i8 LSX128B:$vj), (immZExt3:$ui3)),
             (VSRLRI_B LSX128B:$vj, uimm3:$ui3)>;
def : LSXPat<(int_loongarch_lsx_vsrlri_h (v8i16 LSX128H:$vj), (immZExt4:$ui4)),
             (VSRLRI_H LSX128H:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vsrlri_w (v4i32 LSX128W:$vj), (immZExt5:$ui5)),
             (VSRLRI_W LSX128W:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vsrlri_d (v2i64 LSX128D:$vj), (immZExt6:$ui6)),
             (VSRLRI_D LSX128D:$vj, uimm6:$ui6)>;

def : LSXPat<(int_loongarch_lsx_vsrari_b (v16i8 LSX128B:$vj), (immZExt3:$ui3)),
             (VSRARI_B LSX128B:$vj, uimm3:$ui3)>;
def : LSXPat<(int_loongarch_lsx_vsrari_h (v8i16 LSX128H:$vj), (immZExt4:$ui4)),
             (VSRARI_H LSX128H:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vsrari_w (v4i32 LSX128W:$vj), (immZExt5:$ui5)),
             (VSRARI_W LSX128W:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vsrari_d (v2i64 LSX128D:$vj), (immZExt6:$ui6)),
             (VSRARI_D LSX128D:$vj, uimm6:$ui6)>;

def : LSXPat<(int_loongarch_lsx_vinsgr2vr_b (v16i8 LSX128B:$vj), GPR32Opnd:$rj, (immZExt4:$ui4)),
             (VINSGR2VR_B LSX128B:$vj, GPR32Opnd:$rj, (uimm4i:$ui4))>;
def : LSXPat<(int_loongarch_lsx_vinsgr2vr_h (v8i16 LSX128H:$vj), GPR32Opnd:$rj, (immZExt3:$ui3)),
             (VINSGR2VR_H LSX128H:$vj, GPR32Opnd:$rj, uimm3:$ui3)>;
def : LSXPat<(int_loongarch_lsx_vinsgr2vr_w (v4i32 LSX128W:$vj), GPR32Opnd:$rj, (immZExt2:$ui2)),
             (VINSGR2VR_W LSX128W:$vj, GPR32Opnd:$rj, uimm2:$ui2)>;
def : LSXPat<(int_loongarch_lsx_vinsgr2vr_d (v2i64 LSX128D:$vj), GPR64Opnd:$rj, (immZExt1:$ui1)),
             (VINSGR2VR_D LSX128D:$vj, GPR64Opnd:$rj, uimm1i:$ui1)>;

def : LSXPat<(int_loongarch_lsx_vpickve2gr_b (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VPICKVE2GR_B LSX128B:$vj, (uimm4i:$ui4))>;
def : LSXPat<(int_loongarch_lsx_vpickve2gr_h (v8i16 LSX128H:$vj), (immZExt3:$ui3)),
             (VPICKVE2GR_H LSX128H:$vj, uimm3:$ui3)>;
def : LSXPat<(int_loongarch_lsx_vpickve2gr_w (v4i32 LSX128W:$vj), (immZExt2:$ui2)),
             (VPICKVE2GR_W LSX128W:$vj, uimm2:$ui2)>;
def : LSXPat<(int_loongarch_lsx_vpickve2gr_d (v2i64 LSX128D:$vj), (immZExt1:$ui1)),
             (VPICKVE2GR_D LSX128D:$vj, uimm1i:$ui1)>;

def : LSXPat<(int_loongarch_lsx_vpickve2gr_bu (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VPICKVE2GR_BU LSX128B:$vj, (uimm4i:$ui4))>;
def : LSXPat<(int_loongarch_lsx_vpickve2gr_hu (v8i16 LSX128H:$vj), (immZExt3:$ui3)),
             (VPICKVE2GR_HU LSX128H:$vj, uimm3:$ui3)>;
def : LSXPat<(int_loongarch_lsx_vpickve2gr_wu (v4i32 LSX128W:$vj), (immZExt2:$ui2)),
             (VPICKVE2GR_WU LSX128W:$vj, uimm2:$ui2)>;

def : LSXPat<(int_loongarch_lsx_vsat_b (v16i8 LSX128B:$vj), (immZExt3:$ui3)),
             (VSAT_B LSX128B:$vj, uimm3:$ui3)>;
def : LSXPat<(int_loongarch_lsx_vsat_h (v8i16 LSX128H:$vj), (immZExt4:$ui4)),
             (VSAT_H LSX128H:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vsat_w (v4i32 LSX128W:$vj), (immZExt5:$ui5)),
             (VSAT_W LSX128W:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vsat_d (v2i64 LSX128D:$vj), (immZExt6:$ui6)),
             (VSAT_D LSX128D:$vj, uimm6:$ui6)>;

def : LSXPat<(int_loongarch_lsx_vsat_bu (v16i8 LSX128B:$vj), (immZExt3:$ui3)),
             (VSAT_BU LSX128B:$vj, uimm3:$ui3)>;
def : LSXPat<(int_loongarch_lsx_vsat_hu (v8i16 LSX128H:$vj), (immZExt4:$ui4)),
             (VSAT_HU LSX128H:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vsat_wu (v4i32 LSX128W:$vj), (immZExt5:$ui5)),
             (VSAT_WU LSX128W:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vsat_du (v2i64 LSX128D:$vj), (immZExt6:$ui6)),
             (VSAT_DU LSX128D:$vj, uimm6:$ui6)>;

def : LSXPat<(int_loongarch_lsx_vmskltz_b (v16i8 LSX128B:$vj)),
             (VMSKLTZ_B LSX128B:$vj)>;
def : LSXPat<(int_loongarch_lsx_vmskltz_h (v8i16 LSX128H:$vj)),
             (VMSKLTZ_H LSX128H:$vj)>;
def : LSXPat<(int_loongarch_lsx_vmskltz_w (v4i32 LSX128W:$vj)),
             (VMSKLTZ_W LSX128W:$vj)>;
def : LSXPat<(int_loongarch_lsx_vmskltz_d (v2i64 LSX128D:$vj)),
             (VMSKLTZ_D LSX128D:$vj)>;

def : LSXPat<(int_loongarch_lsx_vsrlni_b_h (v16i8 LSX128B:$vd_in), (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VSRLNI_B_H LSX128B:$vd_in, LSX128B:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vsrlni_h_w (v8i16 LSX128H:$vd_in), (v8i16 LSX128H:$vj), (immZExt5:$ui5)),
             (VSRLNI_H_W LSX128H:$vd_in, LSX128H:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vsrlni_w_d (v4i32 LSX128W:$vd_in), (v4i32 LSX128W:$vj), (immZExt6:$ui6)),
             (VSRLNI_W_D LSX128W:$vd_in, LSX128W:$vj, uimm6:$ui6)>;
def : LSXPat<(int_loongarch_lsx_vsrlni_d_q (v2i64 LSX128D:$vd_in), (v2i64 LSX128D:$vj), (immZExt7:$ui7)),
             (VSRLNI_D_Q LSX128D:$vd_in, LSX128D:$vj, uimm7i:$ui7)>;

def : LSXPat<(int_loongarch_lsx_vssrlni_b_h (v16i8 LSX128B:$vd_in), (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VSSRLNI_B_H LSX128B:$vd_in, LSX128B:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vssrlni_h_w (v8i16 LSX128H:$vd_in), (v8i16 LSX128H:$vj), (immZExt5:$ui5)),
             (VSSRLNI_H_W LSX128H:$vd_in, LSX128H:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vssrlni_w_d (v4i32 LSX128W:$vd_in), (v4i32 LSX128W:$vj), (immZExt6:$ui6)),
             (VSSRLNI_W_D LSX128W:$vd_in, LSX128W:$vj, uimm6:$ui6)>;
def : LSXPat<(int_loongarch_lsx_vssrlni_d_q (v2i64 LSX128D:$vd_in), (v2i64 LSX128D:$vj), (immZExt7:$ui7)),
             (VSSRLNI_D_Q LSX128D:$vd_in, LSX128D:$vj, uimm7i:$ui7)>;

def : LSXPat<(int_loongarch_lsx_vssrlni_bu_h (v16i8 LSX128B:$vd_in), (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VSSRLNI_BU_H LSX128B:$vd_in, LSX128B:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vssrlni_hu_w (v8i16 LSX128H:$vd_in), (v8i16 LSX128H:$vj), (immZExt5:$ui5)),
             (VSSRLNI_HU_W LSX128H:$vd_in, LSX128H:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vssrlni_wu_d (v4i32 LSX128W:$vd_in), (v4i32 LSX128W:$vj), (immZExt6:$ui6)),
             (VSSRLNI_WU_D LSX128W:$vd_in, LSX128W:$vj, uimm6:$ui6)>;
def : LSXPat<(int_loongarch_lsx_vssrlni_du_q (v2i64 LSX128D:$vd_in), (v2i64 LSX128D:$vj), (immZExt7:$ui7)),
             (VSSRLNI_DU_Q LSX128D:$vd_in, LSX128D:$vj, uimm7i:$ui7)>;

def : LSXPat<(int_loongarch_lsx_vssrlrni_bu_h (v16i8 LSX128B:$vd_in), (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VSSRLRNI_BU_H LSX128B:$vd_in, LSX128B:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vssrlrni_hu_w (v8i16 LSX128H:$vd_in), (v8i16 LSX128H:$vj), (immZExt5:$ui5)),
             (VSSRLRNI_HU_W LSX128H:$vd_in, LSX128H:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vssrlrni_wu_d (v4i32 LSX128W:$vd_in), (v4i32 LSX128W:$vj), (immZExt6:$ui6)),
             (VSSRLRNI_WU_D LSX128W:$vd_in, LSX128W:$vj, uimm6:$ui6)>;
def : LSXPat<(int_loongarch_lsx_vssrlrni_du_q (v2i64 LSX128D:$vd_in), (v2i64 LSX128D:$vj), (immZExt7:$ui7)),
             (VSSRLRNI_DU_Q LSX128D:$vd_in, LSX128D:$vj, uimm7i:$ui7)>;

def : LSXPat<(int_loongarch_lsx_vsrarni_b_h (v16i8 LSX128B:$vd_in), (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VSRARNI_B_H LSX128B:$vd_in, LSX128B:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vsrarni_h_w (v8i16 LSX128H:$vd_in), (v8i16 LSX128H:$vj), (immZExt5:$ui5)),
             (VSRARNI_H_W LSX128H:$vd_in, LSX128H:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vsrarni_w_d (v4i32 LSX128W:$vd_in), (v4i32 LSX128W:$vj), (immZExt6:$ui6)),
             (VSRARNI_W_D LSX128W:$vd_in, LSX128W:$vj, uimm6:$ui6)>;
def : LSXPat<(int_loongarch_lsx_vsrarni_d_q (v2i64 LSX128D:$vd_in), (v2i64 LSX128D:$vj), (immZExt7:$ui7)),
             (VSRARNI_D_Q LSX128D:$vd_in, LSX128D:$vj, uimm7i:$ui7)>;

def : LSXPat<(int_loongarch_lsx_vssrani_b_h (v16i8 LSX128B:$vd_in), (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VSSRANI_B_H LSX128B:$vd_in, LSX128B:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vssrani_h_w (v8i16 LSX128H:$vd_in), (v8i16 LSX128H:$vj), (immZExt5:$ui5)),
             (VSSRANI_H_W LSX128H:$vd_in, LSX128H:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vssrani_w_d (v4i32 LSX128W:$vd_in), (v4i32 LSX128W:$vj), (immZExt6:$ui6)),
             (VSSRANI_W_D LSX128W:$vd_in, LSX128W:$vj, uimm6:$ui6)>;
def : LSXPat<(int_loongarch_lsx_vssrani_d_q (v2i64 LSX128D:$vd_in), (v2i64 LSX128D:$vj), (immZExt7:$ui7)),
             (VSSRANI_D_Q LSX128D:$vd_in, LSX128D:$vj, uimm7i:$ui7)>;

def : LSXPat<(int_loongarch_lsx_vssrani_bu_h (v16i8 LSX128B:$vd_in), (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VSSRANI_BU_H LSX128B:$vd_in, LSX128B:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vssrani_hu_w (v8i16 LSX128H:$vd_in), (v8i16 LSX128H:$vj), (immZExt5:$ui5)),
             (VSSRANI_HU_W LSX128H:$vd_in, LSX128H:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vssrani_wu_d (v4i32 LSX128W:$vd_in), (v4i32 LSX128W:$vj), (immZExt6:$ui6)),
             (VSSRANI_WU_D LSX128W:$vd_in, LSX128W:$vj, uimm6:$ui6)>;
def : LSXPat<(int_loongarch_lsx_vssrani_du_q (v2i64 LSX128D:$vd_in), (v2i64 LSX128D:$vj), (immZExt7:$ui7)),
             (VSSRANI_DU_Q LSX128D:$vd_in, LSX128D:$vj, uimm7i:$ui7)>;

def : LSXPat<(int_loongarch_lsx_vssrarni_b_h (v16i8 LSX128B:$vd_in), (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VSSRARNI_B_H LSX128B:$vd_in, LSX128B:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vssrarni_h_w (v8i16 LSX128H:$vd_in), (v8i16 LSX128H:$vj), (immZExt5:$ui5)),
             (VSSRARNI_H_W LSX128H:$vd_in, LSX128H:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vssrarni_w_d (v4i32 LSX128W:$vd_in), (v4i32 LSX128W:$vj), (immZExt6:$ui6)),
             (VSSRARNI_W_D LSX128W:$vd_in, LSX128W:$vj, uimm6:$ui6)>;
def : LSXPat<(int_loongarch_lsx_vssrarni_d_q (v2i64 LSX128D:$vd_in), (v2i64 LSX128D:$vj), (immZExt7:$ui7)),
             (VSSRARNI_D_Q LSX128D:$vd_in, LSX128D:$vj, uimm7i:$ui7)>;

def : LSXPat<(int_loongarch_lsx_vssrarni_bu_h (v16i8 LSX128B:$vd_in), (v16i8 LSX128B:$vj), (immZExt4:$ui4)),
             (VSSRARNI_BU_H LSX128B:$vd_in, LSX128B:$vj, uimm4i:$ui4)>;
def : LSXPat<(int_loongarch_lsx_vssrarni_hu_w (v8i16 LSX128H:$vd_in), (v8i16 LSX128H:$vj), (immZExt5:$ui5)),
             (VSSRARNI_HU_W LSX128H:$vd_in, LSX128H:$vj, uimm5:$ui5)>;
def : LSXPat<(int_loongarch_lsx_vssrarni_wu_d (v4i32 LSX128W:$vd_in), (v4i32 LSX128W:$vj), (immZExt6:$ui6)),
             (VSSRARNI_WU_D LSX128W:$vd_in, LSX128W:$vj, uimm6:$ui6)>;
def : LSXPat<(int_loongarch_lsx_vssrarni_du_q (v2i64 LSX128D:$vd_in), (v2i64 LSX128D:$vj), (immZExt7:$ui7)),
             (VSSRARNI_DU_Q LSX128D:$vd_in, LSX128D:$vj, uimm7i:$ui7)>;

def : LSXPat<(load (add iPTR:$vj, GPR64Opnd:$vk)),
             (VLDX PtrRC:$vj, GPR64Opnd:$vk)>;

def : LSXPat<(store (v16i8 LSX128B:$vd), (add iPTR:$vj, GPR64Opnd:$vk)),
             (VSTX LSX128B:$vd, PtrRC:$vj, GPR64Opnd:$vk)>;

def : LSXPat<(int_loongarch_lsx_vshuf_b (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk), (v16i8 LSX128B:$va)),
             (VSHUF_B LSX128B:$vj, LSX128B:$vk, LSX128B:$va)>;

def : LSXPat<(int_loongarch_lsx_vfcmp_ceq_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFCMP_CEQ_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcmp_ceq_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFCMP_CEQ_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfcmp_cor_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFCMP_COR_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcmp_cor_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFCMP_COR_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfcmp_cun_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFCMP_CUN_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcmp_cun_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFCMP_CUN_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfcmp_cune_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFCMP_CUNE_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcmp_cune_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFCMP_CUNE_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfcmp_cueq_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFCMP_CUEQ_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcmp_cueq_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFCMP_CUEQ_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfcmp_cne_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFCMP_CNE_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcmp_cne_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFCMP_CNE_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfcmp_clt_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFCMP_CLT_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcmp_clt_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFCMP_CLT_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfcmp_cult_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFCMP_CULT_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcmp_cult_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFCMP_CULT_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfcmp_cle_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFCMP_CLE_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcmp_cle_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFCMP_CLE_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vfcmp_cule_s (v4f32 LSX128W:$vj), (v4f32 LSX128W:$vk)),
             (VFCMP_CULE_S LSX128W:$vj, LSX128W:$vk)>;
def : LSXPat<(int_loongarch_lsx_vfcmp_cule_d (v2f64 LSX128D:$vj), (v2f64 LSX128D:$vk)),
             (VFCMP_CULE_D LSX128D:$vj, LSX128D:$vk)>;

def : LSXPat<(int_loongarch_lsx_vftintrz_w_s (v4f32 LSX128W:$vj)),
             (VFTINTRZ_W_S LSX128W:$vj)>;
def : LSXPat<(int_loongarch_lsx_vftintrz_l_d (v2f64 LSX128D:$vj)),
             (VFTINTRZ_L_D LSX128D:$vj)>;


def imm_mask  : ImmLeaf<i32, [{return isInt<32>(Imm) && Imm == -1;}]>;
def imm_mask_64  : ImmLeaf<i64, [{return isInt<64>(Imm) && Imm == -1;}]>;


def : LSXPat<(xor (v8i16 LSX128H:$vj), (vsplati16 imm_mask)),
             (NOR_V_H_PSEUDO  (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vj))>;

def : LSXPat<(xor (v4i32 LSX128W:$vj), (vsplati32 imm_mask)),
             (NOR_V_W_PSEUDO  (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vj))>;

def : LSXPat<(xor (v2i64 LSX128D:$vj), (vsplati64 imm_mask_64)),
             (NOR_V_D_PSEUDO  (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vj))>;


def : LSXPat<(and
                (v16i8 (xor (v16i8 LSX128B:$vj),(vsplati8 imm_mask))),
                (v16i8 LSX128B:$vk)
             ),
             (VANDN_V (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk))>;

def : LSXPat<(and
                (v8i16 (xor (v8i16 LSX128H:$vj), (vsplati16 imm_mask))),
                (v8i16 LSX128H:$vk)
             ),
             (VANDN_H_PSEUDO (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk))>;

def : LSXPat<(and
                (v4i32 (xor (v4i32 LSX128W:$vj), (vsplati32 imm_mask))),
                (v4i32 LSX128W:$vk)
             ),
             (VANDN_W_PSEUDO (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk))>;

def : LSXPat<(and
                (v2i64 (xor (v2i64 LSX128D:$vj), (vsplati64 imm_mask_64))),
                (v2i64 LSX128D:$vk)
             ),
             (VANDN_D_PSEUDO (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk))>;


def : LSXPat<(or
                (v16i8 LSX128B:$vj),
                (v16i8 (xor (v16i8 LSX128B:$vk), (vsplati8 imm_mask)))
             ),
             (VORN_V (v16i8 LSX128B:$vj), (v16i8 LSX128B:$vk))>;

def : LSXPat<(or
                (v8i16 LSX128H:$vj),
                (v8i16 (xor (v8i16 LSX128H:$vk), (vsplati16 imm_mask)))
             ),
             (VORN_H_PSEUDO (v8i16 LSX128H:$vj), (v8i16 LSX128H:$vk))>;

def : LSXPat<(or
                (v4i32 LSX128W:$vj),
                (v4i32 (xor (v4i32 LSX128W:$vk), (vsplati32 imm_mask)))
             ),
             (VORN_W_PSEUDO (v4i32 LSX128W:$vj), (v4i32 LSX128W:$vk))>;

def : LSXPat<(or
                (v2i64 LSX128D:$vj),
                (v2i64 (xor (v2i64 LSX128D:$vk), (vsplati64 imm_mask_64)))
             ),
             (VORN_D_PSEUDO (v2i64 LSX128D:$vj), (v2i64 LSX128D:$vk))>;


def : LSXPat<(add (v2i64 (abs LSX128D:$a)), (v2i64 (abs LSX128D:$b))),
             (VADDA_D (v2i64 LSX128D:$a),(v2i64 LSX128D:$b))>;

def : LSXPat<(add (v4i32 (abs LSX128W:$a)), (v4i32 (abs LSX128W:$b))),
             (VADDA_W (v4i32 LSX128W:$a),(v4i32 LSX128W:$b))>;

def : LSXPat<(add (v8i16 (abs LSX128H:$a)), (v8i16 (abs LSX128H:$b))),
             (VADDA_H (v8i16 LSX128H:$a),(v8i16 LSX128H:$b))>;

def : LSXPat<(add (v16i8 (abs LSX128B:$a)), (v16i8 (abs LSX128B:$b))),
             (VADDA_B (v16i8 LSX128B:$a),(v16i8 LSX128B:$b))>;


def : LSXPat<(and v16i8:$vj, (xor (shl vsplat_imm_eq_1, v16i8:$vk),
                                  (vsplati8 imm_mask))),
             (VBITCLR_B v16i8:$vj, v16i8:$vk)>;

def : LSXPat<(and v8i16:$vj, (xor (shl vsplat_imm_eq_1, v8i16:$vk),
                                  (vsplati16 imm_mask))),
             (VBITCLR_H v8i16:$vj, v8i16:$vk)>;

def : LSXPat<(and v4i32:$vj, (xor (shl vsplat_imm_eq_1, v4i32:$vk),
                                  (vsplati32 imm_mask))),
             (VBITCLR_W v4i32:$vj, v4i32:$vk)>;

def : LSXPat<(and v2i64:$vj, (xor (shl vsplat_imm_eq_1, v2i64:$vk),
                                  (vsplati64 imm_mask_64))),
             (VBITCLR_D v2i64:$vj, v2i64:$vk)>;
