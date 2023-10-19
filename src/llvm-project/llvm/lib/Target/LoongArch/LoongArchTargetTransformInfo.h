//===-- LoongArchTargetTransformInfo.h - LoongArch specific TTI -------------*-
// C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// \file
// This file a TargetTransformInfo::Concept conforming object specific to the
// LoongArch target machine. It uses the target's detailed information to
// provide more precise answers to certain TTI queries, while letting the
// target independent and default TTI implementations handle the rest.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LoongArch_LoongArchTARGETTRANSFORMINFO_H
#define LLVM_LIB_TARGET_LoongArch_LoongArchTARGETTRANSFORMINFO_H

#include "LoongArch.h"
#include "LoongArchSubtarget.h"
#include "LoongArchTargetMachine.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/BasicTTIImpl.h"
#include "llvm/CodeGen/TargetLowering.h"

namespace llvm {

class LoongArchTTIImpl : public BasicTTIImplBase<LoongArchTTIImpl> {
  typedef BasicTTIImplBase<LoongArchTTIImpl> BaseT;
  typedef TargetTransformInfo TTI;
  friend BaseT;

  const LoongArchSubtarget *ST;
  const LoongArchTargetLowering *TLI;

  const LoongArchSubtarget *getST() const { return ST; }
  const LoongArchTargetLowering *getTLI() const { return TLI; }

public:
  explicit LoongArchTTIImpl(const LoongArchTargetMachine *TM, const Function &F)
      : BaseT(TM, F.getParent()->getDataLayout()), ST(TM->getSubtargetImpl(F)),
        TLI(ST->getTargetLowering()) {}

  bool areInlineCompatible(const Function *Caller,
                           const Function *Callee) const;

  /// \name Scalar TTI Implementations
  //  /// @{

  TTI::PopcntSupportKind getPopcntSupport(unsigned TyWidth);

  /// @}

  /// \name Vector TTI Implementations
  /// @{

  bool enableInterleavedAccessVectorization() { return true; }

  unsigned getNumberOfRegisters(bool Vector);

  unsigned getRegisterBitWidth(bool Vector) const;

  unsigned getMaxInterleaveFactor(unsigned VF);

  InstructionCost getVectorInstrCost(unsigned Opcode, Type *Val,
                                     unsigned Index);

  InstructionCost getCastInstrCost(unsigned Opcode, Type *Dst, Type *Src,
                                   TTI::CastContextHint CCH,
                                   TTI::TargetCostKind CostKind,
                                   const Instruction *I = nullptr);

  unsigned getLoadStoreVecRegBitWidth(unsigned AS) const;

  InstructionCost getArithmeticInstrCost(
      unsigned Opcode, Type *Ty, TTI::TargetCostKind CostKind,
      TTI::OperandValueKind Opd1Info = TTI::OK_AnyValue,
      TTI::OperandValueKind Opd2Info = TTI::OK_AnyValue,
      TTI::OperandValueProperties Opd1PropInfo = TTI::OP_None,
      TTI::OperandValueProperties Opd2PropInfo = TTI::OP_None,
      ArrayRef<const Value *> Args = ArrayRef<const Value *>(),
      const Instruction *CxtI = nullptr);

  /// @}
};

} // end namespace llvm

#endif
