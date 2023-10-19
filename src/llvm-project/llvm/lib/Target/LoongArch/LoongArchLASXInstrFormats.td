//===- LoongArchLASXInstrFormats.td - LoongArch LASX Instruction Formats ---*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

class LASXInst : InstLA<(outs), (ins), "", [], FrmOther>,
                EXT_LASX {
}

class LASXCBranch : LASXInst {
}

class LASXSpecial : LASXInst {
}

class LASXPseudo<dag outs, dag ins, list<dag> pattern>:
  LoongArchPseudo<outs, ins, pattern> {
  let Predicates = [HasLASX];
}

class LASX_3R<bits<17> op>: LASXInst {
  bits<5> xk;
  bits<5> xj;
  bits<5> xd;

  let Inst{31-15} = op;
  let Inst{14-10} = xk;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_4R<bits<12> op>: LASXInst {
  bits<5> xa;
  bits<5> xk;
  bits<5> xj;
  bits<5> xd;

  let Inst{31-20} = op;
  let Inst{19-15} = xa;
  let Inst{14-10} = xk;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_XVFCMP<bits<12> op>: LASXInst {
  bits<5> xd;
  bits<5> xj;
  bits<5> xk;
  bits<5> cond;

  let Inst{31-20} = op;
  let Inst{19-15} = cond;
  let Inst{14-10} = xk;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_I12_S<bits<10> op>: LASXInst {
  bits<5> xd;
  bits<17> addr;

  let Inst{31-22} = op;
  let Inst{21-10} = addr{11-0};
  let Inst{9-5} = addr{16-12};
  let Inst{4-0} = xd;
}

class LASX_SI12_S<bits<10> op>: LASXInst {
  bits<5> xd;
  bits<17> addr;

  let Inst{31-22} = op;
  let Inst{21-10} = addr{11-0};
  let Inst{9-5} = addr{16-12};
  let Inst{4-0} = xd;
}

class LASX_SI11_S<bits<11> op>: LASXInst {
  bits<5> xd;
  bits<16> addr;

  let Inst{31-21} = op;
  let Inst{20-10} = addr{10-0};
  let Inst{9-5} = addr{15-11};
  let Inst{4-0} = xd;
}

class LASX_SI10_S<bits<12> op>: LASXInst {
  bits<5> xd;
  bits<15> addr;

  let Inst{31-20} = op;
  let Inst{19-10} = addr{9-0};
  let Inst{9-5} = addr{14-10};
  let Inst{4-0} = xd;
}

class LASX_SI9_S<bits<13> op>: LASXInst {
  bits<5> xd;
  bits<14> addr;

  let Inst{31-19} = op;
  let Inst{18-10} = addr{8-0};
  let Inst{9-5} = addr{13-9};
  let Inst{4-0} = xd;
}

class LASX_SI8_idx5<bits<9> op>: LASXInst {
  bits<5> xd;
  bits<5> rj;
  bits<8> si8;
  bits<5> idx;

  let Inst{31-23} = op;
  let Inst{22-18} = idx;
  let Inst{17-10} = si8;
  let Inst{9-5} = rj;
  let Inst{4-0} = xd;
}

class LASX_SI8_idx2<bits<12> op>: LASXInst {
  bits<5> xd;
  bits<5> rj;
  bits<8> si8;
  bits<2> idx;

  let Inst{31-20} = op;
  let Inst{19-18} = idx;
  let Inst{17-10} = si8;
  let Inst{9-5} = rj;
  let Inst{4-0} = xd;
}

class LASX_SI8_idx3<bits<11> op>: LASXInst {
  bits<5> xd;
  bits<5> rj;
  bits<8> si8;
  bits<3> idx;

  let Inst{31-21} = op;
  let Inst{20-18} = idx;
  let Inst{17-10} = si8;
  let Inst{9-5} = rj;
  let Inst{4-0} = xd;
}

class LASX_SI8_idx4<bits<10> op>: LASXInst {
  bits<5> xd;
  bits<5> rj;
  bits<8> si8;
  bits<4> idx;

  let Inst{31-22} = op;
  let Inst{21-18} = idx;
  let Inst{17-10} = si8;
  let Inst{9-5} = rj;
  let Inst{4-0} = xd;
}

class LASX_3R_2GP<bits<17> op>: LASXInst {
  bits<5> rk;
  bits<5> rj;
  bits<5> xd;

  let Inst{31-15} = op;
  let Inst{14-10} = rk;
  let Inst{9-5} = rj;
  let Inst{4-0} = xd;
}

class LASX_3R_1GP<bits<17> op>: LASXInst {
  bits<5> rk;
  bits<5> xj;
  bits<5> xd;

  let Inst{31-15} = op;
  let Inst{14-10} = rk;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_I5<bits<17> op>: LASXInst {
  bits<5> xd;
  bits<5> xj;
  bits<5> si5;

  let Inst{31-15} = op;
  let Inst{14-10} = si5;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_I5_U<bits<17> op>: LASXInst {
  bits<5> xd;
  bits<5> xj;
  bits<5> ui5;

  let Inst{31-15} = op;
  let Inst{14-10} = ui5;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_I5_mode_U<bits<17> op>: LASXInst {
  bits<5> xd;
  bits<5> mode;
  bits<5> ui5;

  let Inst{31-15} = op;
  let Inst{14-10} = ui5;
  let Inst{9-5} = mode;
  let Inst{4-0} = xd;
}

class LASX_2R<bits<22> op>: LASXInst {
  bits<5> xj;
  bits<5> xd;

  let Inst{31-10} = op;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_SET<bits<22> op>: LASXInst {
  bits<5> xj;
  bits<3> cd;

  let Inst{31-10} = op;
  let Inst{9-5} = xj;
  let Inst{4-3} = 0b00;
  let Inst{2-0} = cd;
}

class LASX_2R_1GP<bits<22> op>: LASXInst {
  bits<5> rj;
  bits<5> xd;

  let Inst{31-10} = op;
  let Inst{9-5} = rj;
  let Inst{4-0} = xd;
}

class LASX_I3_U<bits<19> op>: LASXInst {
  bits<5> xd;
  bits<5> xj;
  bits<3> ui3;

  let Inst{31-13} = op;
  let Inst{12-10} = ui3;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_I4_U<bits<18> op>: LASXInst {
  bits<5> xd;
  bits<5> xj;
  bits<4> ui4;

  let Inst{31-14} = op;
  let Inst{13-10} = ui4;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_I6_U<bits<16> op>: LASXInst {
  bits<5> xd;
  bits<5> xj;
  bits<6> ui6;

  let Inst{31-16} = op;
  let Inst{15-10} = ui6;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_I2_R_U<bits<20> op>: LASXInst {
  bits<5> xd;
  bits<5> rj;
  bits<2> ui2;

  let Inst{31-12} = op;
  let Inst{11-10} = ui2;
  let Inst{9-5} = rj;
  let Inst{4-0} = xd;
}

class LASX_I3_R_U<bits<19> op>: LASXInst {
  bits<5> xd;
  bits<5> rj;
  bits<3> ui3;

  let Inst{31-13} = op;
  let Inst{12-10} = ui3;
  let Inst{9-5} = rj;
  let Inst{4-0} = xd;
}

class LASX_ELM_COPY_U3<bits<19> op>: LASXInst {
  bits<5> rd;
  bits<5> xj;
  bits<3> ui3;

  let Inst{31-13} = op;
  let Inst{12-10} = ui3;
  let Inst{9-5} = xj;
  let Inst{4-0} = rd;
}

class LASX_ELM_COPY_U2<bits<20> op>: LASXInst {
  bits<5> rd;
  bits<5> xj;
  bits<2> ui2;

  let Inst{31-12} = op;
  let Inst{11-10} = ui2;
  let Inst{9-5} = xj;
  let Inst{4-0} = rd;
}

class LASX_I1_U<bits<21> op>: LASXInst {
  bits<5> xd;
  bits<5> xj;
  bits<1> ui1;

  let Inst{31-11} = op;
  let Inst{10} = ui1;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_I2_U<bits<20> op>: LASXInst {
  bits<5> xd;
  bits<5> xj;
  bits<2> ui2;

  let Inst{31-12} = op;
  let Inst{11-10} = ui2;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_I7_U<bits<15> op>: LASXInst {
  bits<5> xd;
  bits<5> xj;
  bits<7> ui7;

  let Inst{31-17} = op;
  let Inst{16-10} = ui7;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}

class LASX_1R_I13<bits<14> op>: LASXInst {
  bits<13> i13;
  bits<5> xd;

  let Inst{31-18} = op;
  let Inst{17-5} = i13;
  let Inst{4-0} = xd;
}

class LASX_I8_U<bits<14> op>: LASXInst {
  bits<5> xd;
  bits<5> xj;
  bits<8> ui8;

  let Inst{31-18} = op;
  let Inst{17-10} = ui8;
  let Inst{9-5} = xj;
  let Inst{4-0} = xd;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class LASX_I1_R_U<bits<21> op>: LASXInst {
  bits<5> xd;
  bits<5> rj;
  bits<1> ui1;

  let Inst{31-11} = op;
  let Inst{10} = ui1;
  let Inst{9-5} = rj;
  let Inst{4-0} = xd;
}

class LASX_I4_R_U<bits<18> op>: LASXInst {
  bits<5> xd;
  bits<5> rj;
  bits<4> ui4;

  let Inst{31-14} = op;
  let Inst{13-10} = ui4;
  let Inst{9-5} = rj;
  let Inst{4-0} = xd;
}

class LASX_ELM_COPY_B<bits<18> op>: LASXInst {
  bits<5> rd;
  bits<5> xj;
  bits<4> ui4;

  let Inst{31-14} = op;
  let Inst{13-10} = ui4;
  let Inst{9-5} = xj;
  let Inst{4-0} = rd;
}

class LASX_ELM_COPY_D<bits<21> op>: LASXInst {
  bits<5> rd;
  bits<5> xj;
  bits<1> ui1;

  let Inst{31-11} = op;
  let Inst{10} = ui1;
  let Inst{9-5} = xj;
  let Inst{4-0} = rd;
}

class LASX_Addr_SI8_idx1<bits<13> op>: LASXInst {
  bits<5> xd;
  bits<13> addr;
  bits<1> idx;

  let Inst{31-19} = op;
  let Inst{18-11} = addr{7-0};
  let Inst{10} = idx;
  let Inst{9-5} = addr{12-8};
  let Inst{4-0} = xd;
}

class LASX_1R_I13_I10<bits<17> op>: LASXInst {
  bits<10> i10;
  bits<5> xd;

  let Inst{31-15} = op;
  let Inst{14-5} = i10;
  let Inst{4-0} = xd;
}






