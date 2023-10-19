//===-- LoongArchISelDAGToDAG.cpp - A Dag to Dag Inst Selector for LoongArch --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the LoongArch target.
//
//===----------------------------------------------------------------------===//

#include "LoongArchISelDAGToDAG.h"
#include "LoongArch.h"
#include "LoongArchMachineFunction.h"
#include "LoongArchRegisterInfo.h"
#include "MCTargetDesc/LoongArchAnalyzeImmediate.h"
#include "MCTargetDesc/LoongArchBaseInfo.h"
#include "MCTargetDesc/LoongArchMCTargetDesc.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGNodes.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/IntrinsicsLoongArch.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"
using namespace llvm;

#define DEBUG_TYPE "loongarch-isel"

//===----------------------------------------------------------------------===//
// Instruction Selector Implementation
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// LoongArchDAGToDAGISel - LoongArch specific code to select LoongArch machine
// instructions for SelectionDAG operations.
//===----------------------------------------------------------------------===//

void LoongArchDAGToDAGISel::PostprocessISelDAG() { doPeepholeLoadStoreADDI(); }

void LoongArchDAGToDAGISel::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequired<DominatorTreeWrapperPass>();
  SelectionDAGISel::getAnalysisUsage(AU);
}

bool LoongArchDAGToDAGISel::runOnMachineFunction(MachineFunction &MF) {
  Subtarget = &static_cast<const LoongArchSubtarget &>(MF.getSubtarget());
  bool Ret = SelectionDAGISel::runOnMachineFunction(MF);

  return Ret;
}

/// Match frameindex
bool LoongArchDAGToDAGISel::selectAddrFrameIndex(SDValue Addr, SDValue &Base,
                                              SDValue &Offset) const {
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
    EVT ValTy = Addr.getValueType();

    Base   = CurDAG->getTargetFrameIndex(FIN->getIndex(), ValTy);
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), ValTy);
    return true;
  }
  return false;
}

/// Match frameindex+offset and frameindex|offset
bool LoongArchDAGToDAGISel::selectAddrFrameIndexOffset(
    SDValue Addr, SDValue &Base, SDValue &Offset, unsigned OffsetBits,
    unsigned ShiftAmount = 0) const {
  if (CurDAG->isBaseWithConstantOffset(Addr)) {
    ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Addr.getOperand(1));
    if (isIntN(OffsetBits + ShiftAmount, CN->getSExtValue())) {
      EVT ValTy = Addr.getValueType();

      // If the first operand is a FI, get the TargetFI Node
      if (FrameIndexSDNode *FIN =
              dyn_cast<FrameIndexSDNode>(Addr.getOperand(0)))
        Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), ValTy);
      else {
        Base = Addr.getOperand(0);
        // If base is a FI, additional offset calculation is done in
        // eliminateFrameIndex, otherwise we need to check the alignment
        const Align Alignment(1ULL << ShiftAmount);
        if (!isAligned(Alignment, CN->getZExtValue()))
          return false;
      }

      Offset = CurDAG->getTargetConstant(CN->getZExtValue(), SDLoc(Addr),
                                         ValTy);
      return true;
    }
  }
  return false;
}

/// ComplexPattern used on LoongArchInstrInfo
/// Used on LoongArch Load/Store instructions
bool LoongArchDAGToDAGISel::selectAddrRegImm(SDValue Addr, SDValue &Base,
                                        SDValue &Offset) const {
  // if Address is FI, get the TargetFrameIndex.
  if (selectAddrFrameIndex(Addr, Base, Offset))
    return true;

  if (!TM.isPositionIndependent()) {
    if ((Addr.getOpcode() == ISD::TargetExternalSymbol ||
        Addr.getOpcode() == ISD::TargetGlobalAddress))
      return false;
  }

  // Addresses of the form FI+const or FI|const
  if (selectAddrFrameIndexOffset(Addr, Base, Offset, 12))
    return true;

  return false;
}

/// ComplexPattern used on LoongArchInstrInfo
/// Used on LoongArch Load/Store instructions
bool LoongArchDAGToDAGISel::selectAddrDefault(SDValue Addr, SDValue &Base,
                                         SDValue &Offset) const {
  Base = Addr;
  Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), Addr.getValueType());
  return true;
}

bool LoongArchDAGToDAGISel::selectIntAddr(SDValue Addr, SDValue &Base,
                                     SDValue &Offset) const {
  return selectAddrRegImm(Addr, Base, Offset) ||
    selectAddrDefault(Addr, Base, Offset);
}

bool LoongArchDAGToDAGISel::selectAddrRegImm12(SDValue Addr, SDValue &Base,
                                            SDValue &Offset) const {
  if (selectAddrFrameIndex(Addr, Base, Offset))
    return true;

  if (selectAddrFrameIndexOffset(Addr, Base, Offset, 12))
    return true;

  return false;
}

bool LoongArchDAGToDAGISel::selectIntAddrSImm12(SDValue Addr, SDValue &Base,
                                           SDValue &Offset) const {
  if (selectAddrFrameIndex(Addr, Base, Offset))
    return true;

  if (selectAddrFrameIndexOffset(Addr, Base, Offset, 12))
    return true;

  return selectAddrDefault(Addr, Base, Offset);
}

bool LoongArchDAGToDAGISel::selectIntAddrSImm10Lsl1(SDValue Addr, SDValue &Base,
                                               SDValue &Offset) const {
  if (selectAddrFrameIndex(Addr, Base, Offset))
    return true;

  if (selectAddrFrameIndexOffset(Addr, Base, Offset, 10, 1))
    return true;

  return selectAddrDefault(Addr, Base, Offset);
}

bool LoongArchDAGToDAGISel::selectIntAddrSImm10(SDValue Addr, SDValue &Base,
                                               SDValue &Offset) const {
  if (selectAddrFrameIndex(Addr, Base, Offset))
    return true;

  if (selectAddrFrameIndexOffset(Addr, Base, Offset, 10))
    return true;

  return selectAddrDefault(Addr, Base, Offset);
}

bool LoongArchDAGToDAGISel::selectIntAddrSImm10Lsl2(SDValue Addr, SDValue &Base,
                                               SDValue &Offset) const {
  if (selectAddrFrameIndex(Addr, Base, Offset))
    return true;

  if (selectAddrFrameIndexOffset(Addr, Base, Offset, 10, 2))
    return true;

  return selectAddrDefault(Addr, Base, Offset);
}

bool LoongArchDAGToDAGISel::selectIntAddrSImm11Lsl1(SDValue Addr, SDValue &Base,
                                               SDValue &Offset) const {
  if (selectAddrFrameIndex(Addr, Base, Offset))
    return true;

  if (selectAddrFrameIndexOffset(Addr, Base, Offset, 11, 1))
    return true;

  return selectAddrDefault(Addr, Base, Offset);
}

bool LoongArchDAGToDAGISel::selectIntAddrSImm9Lsl3(SDValue Addr, SDValue &Base,
                                               SDValue &Offset) const {
  if (selectAddrFrameIndex(Addr, Base, Offset))
    return true;

  if (selectAddrFrameIndexOffset(Addr, Base, Offset, 9, 3))
    return true;

  return selectAddrDefault(Addr, Base, Offset);
}

bool LoongArchDAGToDAGISel::selectIntAddrSImm14Lsl2(SDValue Addr, SDValue &Base,
                                               SDValue &Offset) const {
  if (selectAddrFrameIndex(Addr, Base, Offset))
    return true;

  if (selectAddrFrameIndexOffset(Addr, Base, Offset, 14, 2))
    return true;

  return false;
}

bool LoongArchDAGToDAGISel::selectIntAddrSImm10Lsl3(SDValue Addr, SDValue &Base,
                                               SDValue &Offset) const {
  if (selectAddrFrameIndex(Addr, Base, Offset))
    return true;

  if (selectAddrFrameIndexOffset(Addr, Base, Offset, 10, 3))
    return true;

  return selectAddrDefault(Addr, Base, Offset);
}

// Select constant vector splats.
//
// Returns true and sets Imm if:
// * LSX is enabled
// * N is a ISD::BUILD_VECTOR representing a constant splat
bool LoongArchDAGToDAGISel::selectVSplat(SDNode *N, APInt &Imm,
                                         unsigned MinSizeInBits) const {
  if (!(Subtarget->hasLSX() || Subtarget->hasLASX()))
    return false;

  BuildVectorSDNode *Node = dyn_cast<BuildVectorSDNode>(N);

  if (!Node)
    return false;

  APInt SplatValue, SplatUndef;
  unsigned SplatBitSize;
  bool HasAnyUndefs;

  if (!Node->isConstantSplat(SplatValue, SplatUndef, SplatBitSize, HasAnyUndefs,
                             MinSizeInBits))
    return false;

  Imm = SplatValue;

  return true;
}

// Select constant vector splats.
//
// In addition to the requirements of selectVSplat(), this function returns
// true and sets Imm if:
// * The splat value is the same width as the elements of the vector
// * The splat value fits in an integer with the specified signed-ness and
//   width.
//
// This function looks through ISD::BITCAST nodes.
// TODO: This might not be appropriate for big-endian LSX since BITCAST is
//       sometimes a shuffle in big-endian mode.
//
// It's worth noting that this function is not used as part of the selection
// of [v/xv]ldi.[bhwd] since it does not permit using the wrong-typed
// [v/xv]ldi.[bhwd] instruction to achieve the desired bit pattern.
// [v/xv]ldi.[bhwd] is selected in LoongArchDAGToDAGISel::selectNode.
bool LoongArchDAGToDAGISel::selectVSplatCommon(SDValue N, SDValue &Imm,
                                               bool Signed,
                                               unsigned ImmBitSize) const {
  APInt ImmValue;
  EVT EltTy = N->getValueType(0).getVectorElementType();

  if (N->getOpcode() == ISD::BITCAST)
    N = N->getOperand(0);

  if (selectVSplat(N.getNode(), ImmValue, EltTy.getSizeInBits()) &&
      ImmValue.getBitWidth() == EltTy.getSizeInBits()) {

    if ((Signed && ImmValue.isSignedIntN(ImmBitSize)) ||
        (!Signed && ImmValue.isIntN(ImmBitSize))) {
      Imm = CurDAG->getTargetConstant(ImmValue, SDLoc(N), EltTy);
      return true;
    }
  }

  return false;
}

// Select constant vector splats.
bool LoongArchDAGToDAGISel::selectVSplatUimm1(SDValue N, SDValue &Imm) const {
  return selectVSplatCommon(N, Imm, false, 1);
}

bool LoongArchDAGToDAGISel::selectVSplatUimm2(SDValue N, SDValue &Imm) const {
  return selectVSplatCommon(N, Imm, false, 2);
}

bool LoongArchDAGToDAGISel::selectVSplatUimm3(SDValue N, SDValue &Imm) const {
  return selectVSplatCommon(N, Imm, false, 3);
}

bool LoongArchDAGToDAGISel::selectVSplatUimm4(SDValue N, SDValue &Imm) const {
  return selectVSplatCommon(N, Imm, false, 4);
}

bool LoongArchDAGToDAGISel::selectVSplatUimm5(SDValue N, SDValue &Imm) const {
  return selectVSplatCommon(N, Imm, false, 5);
}

bool LoongArchDAGToDAGISel::selectVSplatUimm6(SDValue N, SDValue &Imm) const {
  return selectVSplatCommon(N, Imm, false, 6);
}

bool LoongArchDAGToDAGISel::selectVSplatUimm8(SDValue N, SDValue &Imm) const {
  return selectVSplatCommon(N, Imm, false, 8);
}

bool LoongArchDAGToDAGISel::selectVSplatSimm5(SDValue N, SDValue &Imm) const {
  return selectVSplatCommon(N, Imm, true, 5);
}

// Select constant vector splats whose value is a power of 2.
//
// In addition to the requirements of selectVSplat(), this function returns
// true and sets Imm if:
// * The splat value is the same width as the elements of the vector
// * The splat value is a power of two.
//
// This function looks through ISD::BITCAST nodes.
// TODO: This might not be appropriate for big-endian LSX since BITCAST is
//       sometimes a shuffle in big-endian mode.
bool LoongArchDAGToDAGISel::selectVSplatUimmPow2(SDValue N,
                                                 SDValue &Imm) const {
  APInt ImmValue;
  EVT EltTy = N->getValueType(0).getVectorElementType();

  if (N->getOpcode() == ISD::BITCAST)
    N = N->getOperand(0);

  if (selectVSplat(N.getNode(), ImmValue, EltTy.getSizeInBits()) &&
      ImmValue.getBitWidth() == EltTy.getSizeInBits()) {
    int32_t Log2 = ImmValue.exactLogBase2();

    if (Log2 != -1) {
      Imm = CurDAG->getTargetConstant(Log2, SDLoc(N), EltTy);
      return true;
    }
  }

  return false;
}

bool LoongArchDAGToDAGISel::selectVSplatUimmInvPow2(SDValue N,
                                                    SDValue &Imm) const {
  APInt ImmValue;
  EVT EltTy = N->getValueType(0).getVectorElementType();

  if (N->getOpcode() == ISD::BITCAST)
    N = N->getOperand(0);

  if (selectVSplat(N.getNode(), ImmValue, EltTy.getSizeInBits()) &&
      ImmValue.getBitWidth() == EltTy.getSizeInBits()) {
    int32_t Log2 = (~ImmValue).exactLogBase2();

    if (Log2 != -1) {
      Imm = CurDAG->getTargetConstant(Log2, SDLoc(N), EltTy);
      return true;
    }
  }

  return false;
}

// Select constant vector splats whose value only has a consecutive sequence
// of left-most bits set (e.g. 0b11...1100...00).
//
// In addition to the requirements of selectVSplat(), this function returns
// true and sets Imm if:
// * The splat value is the same width as the elements of the vector
// * The splat value is a consecutive sequence of left-most bits.
//
// This function looks through ISD::BITCAST nodes.
// TODO: This might not be appropriate for big-endian LSX since BITCAST is
//       sometimes a shuffle in big-endian mode.
bool LoongArchDAGToDAGISel::selectVSplatMaskL(SDValue N, SDValue &Imm) const {
  APInt ImmValue;
  EVT EltTy = N->getValueType(0).getVectorElementType();

  if (N->getOpcode() == ISD::BITCAST)
    N = N->getOperand(0);

  if (selectVSplat(N.getNode(), ImmValue, EltTy.getSizeInBits()) &&
      ImmValue.getBitWidth() == EltTy.getSizeInBits()) {
    // Extract the run of set bits starting with bit zero from the bitwise
    // inverse of ImmValue, and test that the inverse of this is the same
    // as the original value.
    if (ImmValue == ~(~ImmValue & ~(~ImmValue + 1))) {

      Imm = CurDAG->getTargetConstant(ImmValue.countPopulation() - 1, SDLoc(N),
                                      EltTy);
      return true;
    }
  }

  return false;
}

// Select constant vector splats whose value only has a consecutive sequence
// of right-most bits set (e.g. 0b00...0011...11).
//
// In addition to the requirements of selectVSplat(), this function returns
// true and sets Imm if:
// * The splat value is the same width as the elements of the vector
// * The splat value is a consecutive sequence of right-most bits.
//
// This function looks through ISD::BITCAST nodes.
// TODO: This might not be appropriate for big-endian LSX since BITCAST is
//       sometimes a shuffle in big-endian mode.
bool LoongArchDAGToDAGISel::selectVSplatMaskR(SDValue N, SDValue &Imm) const {
  APInt ImmValue;
  EVT EltTy = N->getValueType(0).getVectorElementType();

  if (N->getOpcode() == ISD::BITCAST)
    N = N->getOperand(0);

  if (selectVSplat(N.getNode(), ImmValue, EltTy.getSizeInBits()) &&
      ImmValue.getBitWidth() == EltTy.getSizeInBits()) {
    // Extract the run of set bits starting with bit zero, and test that the
    // result is the same as the original value
    if (ImmValue == (ImmValue & ~(ImmValue + 1))) {
      Imm = CurDAG->getTargetConstant(ImmValue.countPopulation() - 1, SDLoc(N),
                                      EltTy);
      return true;
    }
  }

  return false;
}

bool LoongArchDAGToDAGISel::trySelect(SDNode *Node) {
  unsigned Opcode = Node->getOpcode();
  SDLoc DL(Node);

  ///
  // Instruction Selection not handled by the auto-generated
  // tablegen selection should be handled here.
  ///
  switch(Opcode) {
  default: break;
  case ISD::ConstantFP: {
    ConstantFPSDNode *CN = dyn_cast<ConstantFPSDNode>(Node);
    if (Node->getValueType(0) == MVT::f64 && CN->isExactlyValue(+0.0)) {
      if (Subtarget->is64Bit()) {
        SDValue Zero = CurDAG->getCopyFromReg(CurDAG->getEntryNode(), DL,
                                              LoongArch::ZERO_64, MVT::i64);
        ReplaceNode(Node,
                    CurDAG->getMachineNode(LoongArch::MOVGR2FR_D, DL, MVT::f64, Zero));
      }
      return true;
    }
    break;
  }

  case ISD::Constant: {
    const ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Node);
    MVT VT = CN->getSimpleValueType(0);
    int64_t Imm = CN->getSExtValue();
    LoongArchAnalyzeImmediate::InstSeq Seq =
        LoongArchAnalyzeImmediate::generateInstSeq(Imm, VT == MVT::i64);
    SDLoc DL(CN);
    SDNode *Result = nullptr;
    SDValue SrcReg = CurDAG->getRegister(
        VT == MVT::i64 ? LoongArch::ZERO_64 : LoongArch::ZERO, VT);

    // The instructions in the sequence are handled here.
    for (LoongArchAnalyzeImmediate::Inst &Inst : Seq) {
      SDValue SDImm = CurDAG->getTargetConstant(Inst.Imm, DL, VT);
      if (Inst.Opc == LoongArch::LU12I_W || Inst.Opc == LoongArch::LU12I_W32)
        Result = CurDAG->getMachineNode(Inst.Opc, DL, VT, SDImm);
      else
        Result = CurDAG->getMachineNode(Inst.Opc, DL, VT, SrcReg, SDImm);
      SrcReg = SDValue(Result, 0);
    }
    ReplaceNode(Node, Result);
    return true;
  }

  case ISD::BUILD_VECTOR: {
    // Select appropriate vldi.[bhwd] instructions for constant splats of
    // 128-bit when LSX is enabled. Select appropriate xvldi.[bhwd] instructions
    // for constant splats of 256-bit when LASX is enabled. Fixup any register
    // class mismatches that occur as a result.
    //
    // This allows the compiler to use a wider range of immediates than would
    // otherwise be allowed. If, for example, v4i32 could only use [v/xv]ldi.h
    // then it would not be possible to load { 0x01010101, 0x01010101,
    // 0x01010101, 0x01010101 } without using a constant pool. This would be
    // sub-optimal when // '[v/xv]ldi.b vd, 1' is capable of producing that
    // bit-pattern in the same set/ of registers. Similarly, [v/xv]ldi.h isn't
    // capable of producing { 0x00000000, 0x00000001, 0x00000000, 0x00000001 }
    // but '[v/xv]ldi.d vd, 1' can.

    const LoongArchABIInfo &ABI =
        static_cast<const LoongArchTargetMachine &>(TM).getABI();

    BuildVectorSDNode *BVN = cast<BuildVectorSDNode>(Node);
    APInt SplatValue, SplatUndef;
    unsigned SplatBitSize;
    bool HasAnyUndefs;
    unsigned LdiOp;
    EVT ResVecTy = BVN->getValueType(0);
    EVT ViaVecTy;

    if ((!Subtarget->hasLSX() || !BVN->getValueType(0).is128BitVector()) &&
        (!Subtarget->hasLASX() || !BVN->getValueType(0).is256BitVector()))
      return false;

    if (!BVN->isConstantSplat(SplatValue, SplatUndef, SplatBitSize,
                              HasAnyUndefs, 8))
      return false;

    bool IsLASX256 = BVN->getValueType(0).is256BitVector();

    switch (SplatBitSize) {
    default:
      return false;
    case 8:
      LdiOp = IsLASX256 ? LoongArch::XVLDI_B : LoongArch::VLDI_B;
      ViaVecTy = IsLASX256 ? MVT::v32i8 : MVT::v16i8;
      break;
    case 16:
      LdiOp = IsLASX256 ? LoongArch::XVLDI_H : LoongArch::VLDI_H;
      ViaVecTy = IsLASX256 ? MVT::v16i16 : MVT::v8i16;
      break;
    case 32:
      LdiOp = IsLASX256 ? LoongArch::XVLDI_W : LoongArch::VLDI_W;
      ViaVecTy = IsLASX256 ? MVT::v8i32 : MVT::v4i32;
      break;
    case 64:
      LdiOp = IsLASX256 ? LoongArch::XVLDI_D : LoongArch::VLDI_D;
      ViaVecTy = IsLASX256 ? MVT::v4i64 : MVT::v2i64;
      break;
    }

    SDNode *Res;

    // If we have a signed 13 bit integer, we can splat it directly.
    //
    // If we have something bigger we can synthesize the value into a GPR and
    // splat from there.
    if (SplatValue.isSignedIntN(10)) {
      SDValue Imm = CurDAG->getTargetConstant(SplatValue, DL,
                                              ViaVecTy.getVectorElementType());

      Res = CurDAG->getMachineNode(LdiOp, DL, ViaVecTy, Imm);
    } else if (SplatValue.isSignedIntN(12)) {
      bool Is32BitSplat = SplatBitSize < 64 ? true : false;
      const unsigned ADDIOp =
          Is32BitSplat ? LoongArch::ADDI_W : LoongArch::ADDI_D;
      const MVT SplatMVT = Is32BitSplat ? MVT::i32 : MVT::i64;
      SDValue ZeroVal = CurDAG->getRegister(
          Is32BitSplat ? LoongArch::ZERO : LoongArch::ZERO_64, SplatMVT);

      const unsigned FILLOp =
          (SplatBitSize == 16)
              ? (IsLASX256 ? LoongArch::XVREPLGR2VR_H : LoongArch::VREPLGR2VR_H)
              : (SplatBitSize == 32
                     ? (IsLASX256 ? LoongArch::XVREPLGR2VR_W
                                  : LoongArch::VREPLGR2VR_W)
                     : (SplatBitSize == 64
                            ? (IsLASX256 ? LoongArch::XVREPLGR2VR_D
                                         : LoongArch::VREPLGR2VR_D)
                            : 0));

      assert(FILLOp != 0 && "Unknown FILL Op for splat synthesis!");

      short Lo = SplatValue.getLoBits(12).getSExtValue();
      SDValue LoVal = CurDAG->getTargetConstant(Lo, DL, SplatMVT);

      Res = CurDAG->getMachineNode(ADDIOp, DL, SplatMVT, ZeroVal, LoVal);
      Res = CurDAG->getMachineNode(FILLOp, DL, ViaVecTy, SDValue(Res, 0));
    } else if (SplatValue.isSignedIntN(16) && SplatBitSize == 16) {
      const unsigned Lo = SplatValue.getLoBits(12).getZExtValue();
      const unsigned Hi = SplatValue.lshr(12).getLoBits(4).getZExtValue();
      SDValue ZeroVal = CurDAG->getRegister(LoongArch::ZERO, MVT::i32);

      SDValue LoVal = CurDAG->getTargetConstant(Lo, DL, MVT::i32);
      SDValue HiVal = CurDAG->getTargetConstant(Hi, DL, MVT::i32);
      if (Hi)
        Res = CurDAG->getMachineNode(LoongArch::LU12I_W32, DL, MVT::i32, HiVal);

      if (Lo)
        Res = CurDAG->getMachineNode(LoongArch::ORI32, DL, MVT::i32,
                                     Hi ? SDValue(Res, 0) : ZeroVal, LoVal);

      assert((Hi || Lo) && "Zero case reached 32 bit case splat synthesis!");
      const unsigned FILLOp =
          IsLASX256 ? LoongArch::XVREPLGR2VR_H : LoongArch::VREPLGR2VR_H;
      EVT FILLTy = IsLASX256 ? MVT::v16i16 : MVT::v8i16;
      Res = CurDAG->getMachineNode(FILLOp, DL, FILLTy, SDValue(Res, 0));
    } else if (SplatValue.isSignedIntN(32) && SplatBitSize == 32) {
      // Only handle the cases where the splat size agrees with the size
      // of the SplatValue here.
      const unsigned Lo = SplatValue.getLoBits(12).getZExtValue();
      const unsigned Hi = SplatValue.lshr(12).getLoBits(20).getZExtValue();
      SDValue ZeroVal = CurDAG->getRegister(LoongArch::ZERO, MVT::i32);

      SDValue LoVal = CurDAG->getTargetConstant(Lo, DL, MVT::i32);
      SDValue HiVal = CurDAG->getTargetConstant(Hi, DL, MVT::i32);
      if (Hi)
        Res = CurDAG->getMachineNode(LoongArch::LU12I_W32, DL, MVT::i32, HiVal);

      if (Lo)
        Res = CurDAG->getMachineNode(LoongArch::ORI32, DL, MVT::i32,
                                     Hi ? SDValue(Res, 0) : ZeroVal, LoVal);

      assert((Hi || Lo) && "Zero case reached 32 bit case splat synthesis!");
      const unsigned FILLOp =
          IsLASX256 ? LoongArch::XVREPLGR2VR_W : LoongArch::VREPLGR2VR_W;
      EVT FILLTy = IsLASX256 ? MVT::v8i32 : MVT::v4i32;
      Res = CurDAG->getMachineNode(FILLOp, DL, FILLTy, SDValue(Res, 0));

    } else if ((SplatValue.isSignedIntN(32) && SplatBitSize == 64 &&
                ABI.IsLP64()) ||
               (SplatValue.isSignedIntN(64))) {

      int64_t Imm = SplatValue.getSExtValue();
      LoongArchAnalyzeImmediate::InstSeq Seq =
          LoongArchAnalyzeImmediate::generateInstSeq(Imm, true);
      SDValue SrcReg = CurDAG->getRegister(LoongArch::ZERO_64, MVT::i64);

      for (LoongArchAnalyzeImmediate::Inst &Inst : Seq) {
        SDValue SDImm = CurDAG->getTargetConstant(Inst.Imm, DL, MVT::i64);
        if (Inst.Opc == LoongArch::LU12I_W || Inst.Opc == LoongArch::LU12I_W32)
          Res = CurDAG->getMachineNode(Inst.Opc, DL, MVT::i64, SDImm);
        else
          Res = CurDAG->getMachineNode(Inst.Opc, DL, MVT::i64, SrcReg, SDImm);
        SrcReg = SDValue(Res, 0);
      }

      const unsigned FILLOp =
          IsLASX256 ? LoongArch::XVREPLGR2VR_D : LoongArch::VREPLGR2VR_D;
      EVT FILLTy = IsLASX256 ? MVT::v4i64 : MVT::v2i64;
      Res = CurDAG->getMachineNode(FILLOp, DL, FILLTy, SDValue(Res, 0));

    } else
      return false;

    if (ResVecTy != ViaVecTy) {
      // If LdiOp is writing to a different register class to ResVecTy, then
      // fix it up here. This COPY_TO_REGCLASS should never cause a move.v
      // since the source and destination register sets contain the same
      // registers.
      const TargetLowering *TLI = getTargetLowering();
      MVT ResVecTySimple = ResVecTy.getSimpleVT();
      const TargetRegisterClass *RC = TLI->getRegClassFor(ResVecTySimple);
      Res = CurDAG->getMachineNode(
          LoongArch::COPY_TO_REGCLASS, DL, ResVecTy, SDValue(Res, 0),
          CurDAG->getTargetConstant(RC->getID(), DL, MVT::i32));
    }

    ReplaceNode(Node, Res);
    return true;
  }
  }

  return false;
}

/// Select instructions not customized! Used for
/// expanded, promoted and normal instructions
void LoongArchDAGToDAGISel::Select(SDNode *Node) {
  // If we have a custom node, we already have selected!
  if (Node->isMachineOpcode()) {
    LLVM_DEBUG(errs() << "== "; Node->dump(CurDAG); errs() << "\n");
    Node->setNodeId(-1);
    return;
  }

  // See if subclasses can handle this node.
  if (trySelect(Node))
    return;

  // Select the default instruction
  SelectCode(Node);
}

bool LoongArchDAGToDAGISel::
SelectInlineAsmMemoryOperand(const SDValue &Op, unsigned ConstraintID,
                             std::vector<SDValue> &OutOps) {
  SDValue Base, Offset;

  switch(ConstraintID) {
  default:
    llvm_unreachable("Unexpected asm memory constraint");
  // All memory constraints can at least accept raw pointers.
  case InlineAsm::Constraint_i:
    OutOps.push_back(Op);
    OutOps.push_back(CurDAG->getTargetConstant(0, SDLoc(Op), MVT::i32));
    return false;
  case InlineAsm::Constraint_m:
    if (selectAddrRegImm12(Op, Base, Offset)) {
      OutOps.push_back(Base);
      OutOps.push_back(Offset);
      return false;
    }
    OutOps.push_back(Op);
    OutOps.push_back(CurDAG->getTargetConstant(0, SDLoc(Op), MVT::i32));
    return false;
  case InlineAsm::Constraint_R:
    if (selectAddrRegImm12(Op, Base, Offset)) {
      OutOps.push_back(Base);
      OutOps.push_back(Offset);
      return false;
    }
    OutOps.push_back(Op);
    OutOps.push_back(CurDAG->getTargetConstant(0, SDLoc(Op), MVT::i32));
    return false;
  case InlineAsm::Constraint_ZC:
    if (selectIntAddrSImm14Lsl2(Op, Base, Offset)) {
      OutOps.push_back(Base);
      OutOps.push_back(Offset);
      return false;
    }
    OutOps.push_back(Op);
    OutOps.push_back(CurDAG->getTargetConstant(0, SDLoc(Op), MVT::i32));
    return false;
  case InlineAsm::Constraint_ZB:
    OutOps.push_back(Op);
    OutOps.push_back(CurDAG->getTargetConstant(0, SDLoc(Op), MVT::i32));
    return false;
  }
  return true;
}

// This optimisation is ported from RISCV.
// Merge an ADDI into the offset of a load/store instruction where possible.
// (load (addi base, off1), off2) -> (load base, off1+off2)
// (store val, (addi base, off1), off2) -> (store val, base, off1+off2)
// This is possible when off1+off2 fits a 12-bit immediate.
void LoongArchDAGToDAGISel::doPeepholeLoadStoreADDI() {
  SelectionDAG::allnodes_iterator Position(CurDAG->getRoot().getNode());
  ++Position;

  while (Position != CurDAG->allnodes_begin()) {
    SDNode *N = &*--Position;
    // Skip dead nodes and any non-machine opcodes.
    if (N->use_empty() || !N->isMachineOpcode())
      continue;

    int OffsetOpIdx;
    int BaseOpIdx;

    // TODO: handle more instructions.
    switch (N->getMachineOpcode()) {
    default:
      continue;
    case LoongArch::LD_B:
    case LoongArch::LD_B32:
    case LoongArch::LD_BU:
    case LoongArch::LD_BU32:
    case LoongArch::LD_H:
    case LoongArch::LD_H32:
    case LoongArch::LD_HU:
    case LoongArch::LD_HU32:
    case LoongArch::LD_W:
    case LoongArch::LD_W32:
    case LoongArch::LD_WU:
    case LoongArch::LD_D:
      BaseOpIdx = 0;
      OffsetOpIdx = 1;
      break;
    case LoongArch::ST_B:
    case LoongArch::ST_B32:
    case LoongArch::ST_H:
    case LoongArch::ST_H32:
    case LoongArch::ST_W:
    case LoongArch::ST_W32:
    case LoongArch::ST_D:
      BaseOpIdx = 1;
      OffsetOpIdx = 2;
      break;
    }

    if (!isa<ConstantSDNode>(N->getOperand(OffsetOpIdx)))
      continue;

    SDValue Base = N->getOperand(BaseOpIdx);

    // If the base is an ADDI, we can merge it in to the load/store.
    // TODO: handle more instructions, i.e. ADDI_W.
    if (!Base.isMachineOpcode() || Base.getMachineOpcode() != LoongArch::ADDI_D)
      continue;

    SDValue ImmOperand = Base.getOperand(1);
    uint64_t Offset2 = N->getConstantOperandVal(OffsetOpIdx);

    if (auto *Const = dyn_cast<ConstantSDNode>(ImmOperand)) {
      int64_t Offset1 = Const->getSExtValue();
      int64_t CombinedOffset = Offset1 + Offset2;
      if (!isInt<12>(CombinedOffset))
        continue;
      ImmOperand = CurDAG->getTargetConstant(CombinedOffset, SDLoc(ImmOperand),
                                             ImmOperand.getValueType());
      // TODO: handle below cases.
#if 0
    } else if (auto *GA = dyn_cast<GlobalAddressSDNode>(ImmOperand)) {
      // If the off1 in (addi base, off1) is a global variable's address (its
      // low part, really), then we can rely on the alignment of that variable
      // to provide a margin of safety before off1 can overflow the 12 bits.
      // Check if off2 falls within that margin; if so off1+off2 can't overflow.
      const DataLayout &DL = CurDAG->getDataLayout();
      Align Alignment = GA->getGlobal()->getPointerAlignment(DL);
      if (Offset2 != 0 && Alignment <= Offset2)
        continue;
      int64_t Offset1 = GA->getOffset();
      int64_t CombinedOffset = Offset1 + Offset2;
      ImmOperand = CurDAG->getTargetGlobalAddress(
          GA->getGlobal(), SDLoc(ImmOperand), ImmOperand.getValueType(),
          CombinedOffset, GA->getTargetFlags());
    } else if (auto *CP = dyn_cast<ConstantPoolSDNode>(ImmOperand)) {
      // Ditto.
      Align Alignment = CP->getAlign();
      if (Offset2 != 0 && Alignment <= Offset2)
        continue;
      int64_t Offset1 = CP->getOffset();
      int64_t CombinedOffset = Offset1 + Offset2;
      ImmOperand = CurDAG->getTargetConstantPool(
          CP->getConstVal(), ImmOperand.getValueType(), CP->getAlign(),
          CombinedOffset, CP->getTargetFlags());
#endif
    } else {
      continue;
    }

    LLVM_DEBUG(dbgs() << "Folding add-immediate into mem-op:\nBase:    ");
    LLVM_DEBUG(Base->dump(CurDAG));
    LLVM_DEBUG(dbgs() << "\nN: ");
    LLVM_DEBUG(N->dump(CurDAG));
    LLVM_DEBUG(dbgs() << "\n");

    // Modify the offset operand of the load/store.
    if (BaseOpIdx == 0) // Load
      CurDAG->UpdateNodeOperands(N, Base.getOperand(0), ImmOperand,
                                 N->getOperand(2));
    else // Store
      CurDAG->UpdateNodeOperands(N, N->getOperand(0), Base.getOperand(0),
                                 ImmOperand, N->getOperand(3));

    // The add-immediate may now be dead, in which case remove it.
    if (Base.getNode()->use_empty())
      CurDAG->RemoveDeadNode(Base.getNode());
  }
}

FunctionPass *llvm::createLoongArchISelDag(LoongArchTargetMachine &TM,
                                           CodeGenOpt::Level OptLevel) {
  return new LoongArchDAGToDAGISel(TM, OptLevel);
}
