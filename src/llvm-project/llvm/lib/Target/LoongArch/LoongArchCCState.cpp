//===---- LoongArchCCState.cpp - CCState with LoongArch specific extensions ---------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "LoongArchCCState.h"
#include "LoongArchSubtarget.h"
#include "llvm/IR/Module.h"

using namespace llvm;

/// This function returns true if CallSym is a long double emulation routine.
static bool isF128SoftLibCall(const char *CallSym) {
  const char *const LibCalls[] = {
      "__addtf3",      "__divtf3",     "__eqtf2",       "__extenddftf2",
      "__extendsftf2", "__fixtfdi",    "__fixtfsi",     "__fixtfti",
      "__fixunstfdi",  "__fixunstfsi", "__fixunstfti",  "__floatditf",
      "__floatsitf",   "__floattitf",  "__floatunditf", "__floatunsitf",
      "__floatuntitf", "__getf2",      "__gttf2",       "__letf2",
      "__lttf2",       "__multf3",     "__netf2",       "__powitf2",
      "__subtf3",      "__trunctfdf2", "__trunctfsf2",  "__unordtf2",
      "ceill",         "copysignl",    "cosl",          "exp2l",
      "expl",          "floorl",       "fmal",          "fmaxl",
      "fmodl",         "log10l",       "log2l",         "logl",
      "nearbyintl",    "powl",         "rintl",         "roundl",
      "sinl",          "sqrtl",        "truncl"};

  // Check that LibCalls is sorted alphabetically.
  auto Comp = [](const char *S1, const char *S2) { return strcmp(S1, S2) < 0; };
  assert(std::is_sorted(std::begin(LibCalls), std::end(LibCalls), Comp));
  return std::binary_search(std::begin(LibCalls), std::end(LibCalls),
                            CallSym, Comp);
}

/// This function returns true if Ty is fp128, {f128} or i128 which was
/// originally a fp128.
static bool originalTypeIsF128(const Type *Ty, const char *Func) {
  if (Ty->isFP128Ty())
    return true;

  if (Ty->isStructTy() && Ty->getStructNumElements() == 1 &&
      Ty->getStructElementType(0)->isFP128Ty())
    return true;

  // If the Ty is i128 and the function being called is a long double emulation
  // routine, then the original type is f128.
  return (Func && Ty->isIntegerTy(128) && isF128SoftLibCall(Func));
}

/// Return true if the original type was vXfXX.
static bool originalEVTTypeIsVectorFloat(EVT Ty) {
  if (Ty.isVector() && Ty.getVectorElementType().isFloatingPoint())
    return true;

  return false;
}

/// Return true if the original type was vXfXX / vXfXX.
static bool originalTypeIsVectorFloat(const Type * Ty) {
  if (Ty->isVectorTy() && Ty->isFPOrFPVectorTy())
    return true;

  return false;
}

LoongArchCCState::SpecialCallingConvType
LoongArchCCState::getSpecialCallingConvForCallee(const SDNode *Callee,
                                            const LoongArchSubtarget &Subtarget) {
  LoongArchCCState::SpecialCallingConvType SpecialCallingConv = NoSpecialCallingConv;
  return SpecialCallingConv;
}

void LoongArchCCState::PreAnalyzeCallResultForF128(
    const SmallVectorImpl<ISD::InputArg> &Ins,
    const Type *RetTy, const char *Call) {
  for (unsigned i = 0; i < Ins.size(); ++i) {
    OriginalArgWasF128.push_back(
        originalTypeIsF128(RetTy, Call));
    OriginalArgWasFloat.push_back(RetTy->isFloatingPointTy());
  }
}

/// Identify lowered values that originated from f128 or float arguments and
/// record this for use by RetCC_LoongArchLP64LPX32.
void LoongArchCCState::PreAnalyzeReturnForF128(
    const SmallVectorImpl<ISD::OutputArg> &Outs) {
  const MachineFunction &MF = getMachineFunction();
  for (unsigned i = 0; i < Outs.size(); ++i) {
    OriginalArgWasF128.push_back(
        originalTypeIsF128(MF.getFunction().getReturnType(), nullptr));
    OriginalArgWasFloat.push_back(
        MF.getFunction().getReturnType()->isFloatingPointTy());
  }
}

/// Identify lower values that originated from vXfXX and record
/// this.
void LoongArchCCState::PreAnalyzeCallResultForVectorFloat(
    const SmallVectorImpl<ISD::InputArg> &Ins, const Type *RetTy) {
  for (unsigned i = 0; i < Ins.size(); ++i) {
    OriginalRetWasFloatVector.push_back(originalTypeIsVectorFloat(RetTy));
  }
}

/// Identify lowered values that originated from vXfXX arguments and record
/// this.
void LoongArchCCState::PreAnalyzeReturnForVectorFloat(
    const SmallVectorImpl<ISD::OutputArg> &Outs) {
  for (unsigned i = 0; i < Outs.size(); ++i) {
    ISD::OutputArg Out = Outs[i];
    OriginalRetWasFloatVector.push_back(
        originalEVTTypeIsVectorFloat(Out.ArgVT));
  }
}

/// Identify lowered values that originated from f128, float and sret to vXfXX
/// arguments and record this.
void LoongArchCCState::PreAnalyzeCallOperands(
    const SmallVectorImpl<ISD::OutputArg> &Outs,
    std::vector<TargetLowering::ArgListEntry> &FuncArgs,
    const char *Func) {
  for (unsigned i = 0; i < Outs.size(); ++i) {
    TargetLowering::ArgListEntry FuncArg = FuncArgs[Outs[i].OrigArgIndex];

    OriginalArgWasF128.push_back(originalTypeIsF128(FuncArg.Ty, Func));
    OriginalArgWasFloat.push_back(FuncArg.Ty->isFloatingPointTy());
    OriginalArgWasFloatVector.push_back(FuncArg.Ty->isVectorTy());
    CallOperandIsFixed.push_back(Outs[i].IsFixed);
  }
}

/// Identify lowered values that originated from f128, float and vXfXX arguments
/// and record this.
void LoongArchCCState::PreAnalyzeFormalArgumentsForF128(
    const SmallVectorImpl<ISD::InputArg> &Ins) {
  const MachineFunction &MF = getMachineFunction();
  for (unsigned i = 0; i < Ins.size(); ++i) {
    Function::const_arg_iterator FuncArg = MF.getFunction().arg_begin();

    // SRet arguments cannot originate from f128 or {f128} returns so we just
    // push false. We have to handle this specially since SRet arguments
    // aren't mapped to an original argument.
    if (Ins[i].Flags.isSRet()) {
      OriginalArgWasF128.push_back(false);
      OriginalArgWasFloat.push_back(false);
      OriginalArgWasFloatVector.push_back(false);
      continue;
    }

    assert(Ins[i].getOrigArgIndex() < MF.getFunction().arg_size());
    std::advance(FuncArg, Ins[i].getOrigArgIndex());

    OriginalArgWasF128.push_back(
        originalTypeIsF128(FuncArg->getType(), nullptr));
    OriginalArgWasFloat.push_back(FuncArg->getType()->isFloatingPointTy());

    // The LoongArch vector ABI exhibits a corner case of sorts or quirk; if the
    // first argument is actually an SRet pointer to a vector, then the next
    // argument slot is $a2.
    OriginalArgWasFloatVector.push_back(FuncArg->getType()->isVectorTy());
  }
}
