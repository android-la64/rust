//===-- LoongArchTargetTransformInfo.cpp - LoongArch specific TTI pass
//----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements a TargetTransformInfo analysis pass specific to the
/// LoongArch target machine. It uses the target's detailed information to
/// provide more precise answers to certain TTI queries, while letting the
/// target independent and default TTI implementations handle the rest.
///
//===----------------------------------------------------------------------===//

#include "LoongArchTargetTransformInfo.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/BasicTTIImpl.h"
#include "llvm/CodeGen/CostTable.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

#define DEBUG_TYPE "LoongArchtti"

//===----------------------------------------------------------------------===//
//
// LoongArch cost model.
//
//===----------------------------------------------------------------------===//

bool LoongArchTTIImpl::areInlineCompatible(const Function *Caller,
                                           const Function *Callee) const {
  const TargetMachine &TM = getTLI()->getTargetMachine();

  const FeatureBitset &CallerBits =
      TM.getSubtargetImpl(*Caller)->getFeatureBits();
  const FeatureBitset &CalleeBits =
      TM.getSubtargetImpl(*Callee)->getFeatureBits();

  // Inline a callee if its target-features are a subset of the callers
  // target-features.
  return (CallerBits & CalleeBits) == CalleeBits;
}

TargetTransformInfo::PopcntSupportKind
LoongArchTTIImpl::getPopcntSupport(unsigned TyWidth) {
  assert(isPowerOf2_32(TyWidth) && "Ty width must be power of 2");
  if (TyWidth == 32 || TyWidth == 64)
    return TTI::PSK_FastHardware;
  return TTI::PSK_Software;
}

unsigned LoongArchTTIImpl::getNumberOfRegisters(bool Vector) {
  if (Vector && !ST->hasLSX())
    return 0;

  return 32;
}

unsigned LoongArchTTIImpl::getRegisterBitWidth(bool Vector) const {
  if (Vector) {
    if (ST->hasLASX())
      return 256;

    if (ST->hasLSX())
      return 128;

    return 0;
  }
  return 64;
}

unsigned LoongArchTTIImpl::getMaxInterleaveFactor(unsigned VF) {
  if (VF == 1)
    return 1;
  return 2;
}

InstructionCost LoongArchTTIImpl::getArithmeticInstrCost(
    unsigned Opcode, Type *Ty, TTI::TargetCostKind CostKind,
    TTI::OperandValueKind Op1Info, TTI::OperandValueKind Op2Info,
    TTI::OperandValueProperties Opd1PropInfo,
    TTI::OperandValueProperties Opd2PropInfo, ArrayRef<const Value *> Args,
    const Instruction *CxtI) {

  std::pair<InstructionCost, MVT> LT = TLI->getTypeLegalizationCost(DL, Ty);

  int ISD = TLI->InstructionOpcodeToISD(Opcode);
  assert(ISD && "Invalid opcode");

  static const CostTblEntry LASXCostTable[] = {

      {ISD::SHL, MVT::v32i8, 1},
      {ISD::SHL, MVT::v16i16, 1},
      {ISD::SHL, MVT::v8i32, 1},
      {ISD::SHL, MVT::v4i64, 1},

      {ISD::SRL, MVT::v32i8, 1},
      {ISD::SRL, MVT::v16i16, 1},
      {ISD::SRL, MVT::v8i32, 1},
      {ISD::SRL, MVT::v4i64, 1},

      {ISD::SRA, MVT::v32i8, 1},
      {ISD::SRA, MVT::v16i16, 1},
      {ISD::SRA, MVT::v8i32, 1},
      {ISD::SRA, MVT::v4i64, 1},

      {ISD::SUB, MVT::v32i8, 1},
      {ISD::SUB, MVT::v16i16, 1},
      {ISD::SUB, MVT::v8i32, 1},
      {ISD::SUB, MVT::v4i64, 1},

      {ISD::ADD, MVT::v32i8, 1},
      {ISD::ADD, MVT::v16i16, 1},
      {ISD::ADD, MVT::v8i32, 1},
      {ISD::ADD, MVT::v4i64, 1},

      {ISD::MUL, MVT::v32i8, 1},
      {ISD::MUL, MVT::v16i16, 1},
      {ISD::MUL, MVT::v8i32, 1},
      {ISD::MUL, MVT::v4i64, 1},

      {ISD::SDIV, MVT::v32i8, 29},
      {ISD::SDIV, MVT::v16i16, 19},
      {ISD::SDIV, MVT::v8i32, 14},
      {ISD::SDIV, MVT::v4i64, 13},

      {ISD::UDIV, MVT::v32i8, 29},
      {ISD::UDIV, MVT::v16i16, 19},
      {ISD::UDIV, MVT::v8i32, 14},
      {ISD::UDIV, MVT::v4i64, 13},

      {ISD::SREM, MVT::v32i8, 33},
      {ISD::SREM, MVT::v16i16, 21},
      {ISD::SREM, MVT::v8i32, 15},
      {ISD::SREM, MVT::v4i64, 13},

      {ISD::UREM, MVT::v32i8, 29},
      {ISD::UREM, MVT::v16i16, 19},
      {ISD::UREM, MVT::v8i32, 14},
      {ISD::UREM, MVT::v4i64, 13},

      {ISD::FADD, MVT::f64, 1},
      {ISD::FADD, MVT::f32, 1},
      {ISD::FADD, MVT::v4f64, 1},
      {ISD::FADD, MVT::v8f32, 1},

      {ISD::FSUB, MVT::f64, 1},
      {ISD::FSUB, MVT::f32, 1},
      {ISD::FSUB, MVT::v4f64, 1},
      {ISD::FSUB, MVT::v8f32, 1},

      {ISD::FMUL, MVT::f64, 1},
      {ISD::FMUL, MVT::f32, 1},
      {ISD::FMUL, MVT::v4f64, 1},
      {ISD::FMUL, MVT::v8f32, 1},

      {ISD::FDIV, MVT::f32, 12},
      {ISD::FDIV, MVT::f64, 10},
      {ISD::FDIV, MVT::v8f32, 12},
      {ISD::FDIV, MVT::v4f64, 10}

  };

  if (ST->hasLASX())
    if (const auto *Entry = CostTableLookup(LASXCostTable, ISD, LT.second))
      return LT.first * Entry->Cost;

  static const CostTblEntry LSXCostTable[] = {

      {ISD::SHL, MVT::v16i8, 1},
      {ISD::SHL, MVT::v8i16, 1},
      {ISD::SHL, MVT::v4i32, 1},
      {ISD::SHL, MVT::v2i64, 1},

      {ISD::SRL, MVT::v16i8, 1},
      {ISD::SRL, MVT::v8i16, 1},
      {ISD::SRL, MVT::v4i32, 1},
      {ISD::SRL, MVT::v2i64, 1},

      {ISD::SRA, MVT::v16i8, 1},
      {ISD::SRA, MVT::v8i16, 1},
      {ISD::SRA, MVT::v4i32, 1},
      {ISD::SRA, MVT::v2i64, 1},

      {ISD::SUB, MVT::v16i8, 1},
      {ISD::SUB, MVT::v8i16, 1},
      {ISD::SUB, MVT::v4i32, 1},
      {ISD::SUB, MVT::v2i64, 1},

      {ISD::ADD, MVT::v16i8, 1},
      {ISD::ADD, MVT::v8i16, 1},
      {ISD::ADD, MVT::v4i32, 1},
      {ISD::ADD, MVT::v2i64, 1},

      {ISD::MUL, MVT::v16i8, 1},
      {ISD::MUL, MVT::v8i16, 1},
      {ISD::MUL, MVT::v4i32, 1},
      {ISD::MUL, MVT::v2i64, 1},

      {ISD::SDIV, MVT::v16i8, 29},
      {ISD::SDIV, MVT::v8i16, 19},
      {ISD::SDIV, MVT::v4i32, 14},
      {ISD::SDIV, MVT::v2i64, 13},

      {ISD::UDIV, MVT::v16i8, 29},
      {ISD::UDIV, MVT::v8i16, 19},
      {ISD::UDIV, MVT::v4i32, 14},
      {ISD::UDIV, MVT::v2i64, 13},

      {ISD::SREM, MVT::v16i8, 33},
      {ISD::SREM, MVT::v8i16, 21},
      {ISD::SREM, MVT::v4i32, 15},
      {ISD::SREM, MVT::v2i64, 13},

      {ISD::UREM, MVT::v16i8, 29},
      {ISD::UREM, MVT::v8i16, 19},
      {ISD::UREM, MVT::v4i32, 14},
      {ISD::UREM, MVT::v2i64, 13},

      {ISD::FADD, MVT::f64, 1},
      {ISD::FADD, MVT::f32, 1},
      {ISD::FADD, MVT::v2f64, 1},
      {ISD::FADD, MVT::v4f32, 1},

      {ISD::FSUB, MVT::f64, 1},
      {ISD::FSUB, MVT::f32, 1},
      {ISD::FSUB, MVT::v2f64, 1},
      {ISD::FSUB, MVT::v4f32, 1},

      {ISD::FMUL, MVT::f64, 1},
      {ISD::FMUL, MVT::f32, 1},
      {ISD::FMUL, MVT::v2f64, 1},
      {ISD::FMUL, MVT::v4f32, 1},

      {ISD::FDIV, MVT::f32, 12},
      {ISD::FDIV, MVT::f64, 10},
      {ISD::FDIV, MVT::v4f32, 12},
      {ISD::FDIV, MVT::v2f64, 10}

  };

  if (ST->hasLSX())
    if (const auto *Entry = CostTableLookup(LSXCostTable, ISD, LT.second))
      return LT.first * Entry->Cost;

  // Fallback to the default implementation.
  return BaseT::getArithmeticInstrCost(Opcode, Ty, CostKind, Op1Info, Op2Info);
}

InstructionCost LoongArchTTIImpl::getVectorInstrCost(unsigned Opcode, Type *Val,
                                                     unsigned Index) {
  assert(Val->isVectorTy() && "This must be a vector type");

  Type *ScalarType = Val->getScalarType();

  if (Index != -1U) {
    // Legalize the type.
    std::pair<InstructionCost, MVT> LT = TLI->getTypeLegalizationCost(DL, Val);

    // This type is legalized to a scalar type.
    if (!LT.second.isVector())
      return 0;

    // The type may be split. Normalize the index to the new type.
    unsigned Width = LT.second.getVectorNumElements();
    Index = Index % Width;

    // The element at index zero is already inside the vector.
    if (Index == 0) // if (ScalarType->isFloatingPointTy() && Index == 0)
      return 0;
  }

  // Add to the base cost if we know that the extracted element of a vector is
  // destined to be moved to and used in the integer register file.
  int RegisterFileMoveCost = 0;
  if (Opcode == Instruction::ExtractElement && ScalarType->isPointerTy())
    RegisterFileMoveCost = 1;

  int N = TLI->InstructionOpcodeToISD(Opcode);
  if (N == ISD::INSERT_VECTOR_ELT || N == ISD::EXTRACT_VECTOR_ELT)
    return 3 + BaseT::getVectorInstrCost(Opcode, Val, Index) +
           RegisterFileMoveCost;

  return BaseT::getVectorInstrCost(Opcode, Val, Index) + RegisterFileMoveCost;
}

unsigned LoongArchTTIImpl::getLoadStoreVecRegBitWidth(unsigned) const {
  return getRegisterBitWidth(true);
}

InstructionCost LoongArchTTIImpl::getCastInstrCost(unsigned Opcode, Type *Dst,
                                                   Type *Src,
                                                   TTI::CastContextHint CCH,
                                                   TTI::TargetCostKind CostKind,
                                                   const Instruction *I) {
  int ISD = TLI->InstructionOpcodeToISD(Opcode);
  assert(ISD && "Invalid opcode");

  static const TypeConversionCostTblEntry LASXConversionTbl[] = {

      // TODO:The cost requires more granular testing
      {ISD::SIGN_EXTEND, MVT::v16i16, MVT::v16i8, 3},
      {ISD::ZERO_EXTEND, MVT::v16i16, MVT::v16i8, 3},
      {ISD::SIGN_EXTEND, MVT::v8i32, MVT::v8i16, 3},
      {ISD::ZERO_EXTEND, MVT::v8i32, MVT::v8i16, 3},
      {ISD::SIGN_EXTEND, MVT::v4i64, MVT::v4i32, 3},
      {ISD::ZERO_EXTEND, MVT::v4i64, MVT::v4i32, 3},

  };

  EVT SrcTy = TLI->getValueType(DL, Src);
  EVT DstTy = TLI->getValueType(DL, Dst);

  if (!SrcTy.isSimple() || !DstTy.isSimple())
    return BaseT::getCastInstrCost(Opcode, Dst, Src, CCH, CostKind, I);

  if (ST->hasLASX()) {
    if (const auto *Entry = ConvertCostTableLookup(
            LASXConversionTbl, ISD, DstTy.getSimpleVT(), SrcTy.getSimpleVT()))
      return Entry->Cost;
  }

  return BaseT::getCastInstrCost(Opcode, Dst, Src, CCH, CostKind, I);
}
