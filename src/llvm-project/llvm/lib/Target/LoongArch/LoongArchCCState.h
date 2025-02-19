//===---- LoongArchCCState.h - CCState with LoongArch specific extensions -----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LoongArchCCSTATE_H
#define LoongArchCCSTATE_H

#include "LoongArchISelLowering.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/CallingConvLower.h"

namespace llvm {
class SDNode;
class LoongArchSubtarget;

class LoongArchCCState : public CCState {
public:
  enum SpecialCallingConvType { NoSpecialCallingConv };

  /// Determine the SpecialCallingConvType for the given callee
  static SpecialCallingConvType
  getSpecialCallingConvForCallee(const SDNode *Callee,
                                 const LoongArchSubtarget &Subtarget);

private:
  /// Identify lowered values that originated from f128 arguments and record
  /// this for use by RetCC_LoongArchLP64LPX32.
  void PreAnalyzeCallResultForF128(const SmallVectorImpl<ISD::InputArg> &Ins,
                                   const Type *RetTy, const char * Func);

  /// Identify lowered values that originated from f128 arguments and record
  /// this for use by RetCC_LoongArchLP64LPX32.
  void PreAnalyzeReturnForF128(const SmallVectorImpl<ISD::OutputArg> &Outs);

  /// Identify lowered values that originated from f128 arguments and record
  /// this.
  void
  PreAnalyzeCallOperands(const SmallVectorImpl<ISD::OutputArg> &Outs,
                         std::vector<TargetLowering::ArgListEntry> &FuncArgs,
                         const char *Func);

  /// Identify lowered values that originated from f128 arguments and record
  /// this for use by RetCC_LoongArchLP64LPX32.
  void
  PreAnalyzeFormalArgumentsForF128(const SmallVectorImpl<ISD::InputArg> &Ins);

  void
  PreAnalyzeCallResultForVectorFloat(const SmallVectorImpl<ISD::InputArg> &Ins,
                                     const Type *RetTy);

  void PreAnalyzeFormalArgumentsForVectorFloat(
      const SmallVectorImpl<ISD::InputArg> &Ins);

  void
  PreAnalyzeReturnForVectorFloat(const SmallVectorImpl<ISD::OutputArg> &Outs);

  /// Records whether the value has been lowered from an f128.
  SmallVector<bool, 4> OriginalArgWasF128;

  /// Records whether the value has been lowered from float.
  SmallVector<bool, 4> OriginalArgWasFloat;

  /// Records whether the value has been lowered from a floating point vector.
  SmallVector<bool, 4> OriginalArgWasFloatVector;

  /// Records whether the return value has been lowered from a floating point
  /// vector.
  SmallVector<bool, 4> OriginalRetWasFloatVector;

  /// Records whether the value was a fixed argument.
  /// See ISD::OutputArg::IsFixed,
  SmallVector<bool, 4> CallOperandIsFixed;

  // FIXME: This should probably be a fully fledged calling convention.
  SpecialCallingConvType SpecialCallingConv;

public:
  LoongArchCCState(CallingConv::ID CC, bool isVarArg, MachineFunction &MF,
              SmallVectorImpl<CCValAssign> &locs, LLVMContext &C,
              SpecialCallingConvType SpecialCC = NoSpecialCallingConv)
      : CCState(CC, isVarArg, MF, locs, C), SpecialCallingConv(SpecialCC) {}

  void
  AnalyzeCallOperands(const SmallVectorImpl<ISD::OutputArg> &Outs,
                      CCAssignFn Fn,
                      std::vector<TargetLowering::ArgListEntry> &FuncArgs,
                      const char *Func) {
    PreAnalyzeCallOperands(Outs, FuncArgs, Func);
    CCState::AnalyzeCallOperands(Outs, Fn);
    OriginalArgWasF128.clear();
    OriginalArgWasFloat.clear();
    OriginalArgWasFloatVector.clear();
    CallOperandIsFixed.clear();
  }

  // The AnalyzeCallOperands in the base class is not usable since we must
  // provide a means of accessing ArgListEntry::IsFixed. Delete them from this
  // class. This doesn't stop them being used via the base class though.
  void AnalyzeCallOperands(const SmallVectorImpl<ISD::OutputArg> &Outs,
                           CCAssignFn Fn) = delete;
  void AnalyzeCallOperands(const SmallVectorImpl<MVT> &Outs,
                           SmallVectorImpl<ISD::ArgFlagsTy> &Flags,
                           CCAssignFn Fn) = delete;

  void AnalyzeFormalArguments(const SmallVectorImpl<ISD::InputArg> &Ins,
                              CCAssignFn Fn) {
    PreAnalyzeFormalArgumentsForF128(Ins);
    CCState::AnalyzeFormalArguments(Ins, Fn);
    OriginalArgWasFloat.clear();
    OriginalArgWasF128.clear();
    OriginalArgWasFloatVector.clear();
  }

  void AnalyzeCallResult(const SmallVectorImpl<ISD::InputArg> &Ins,
                         CCAssignFn Fn, const Type *RetTy,
                         const char *Func) {
    PreAnalyzeCallResultForF128(Ins, RetTy, Func);
    PreAnalyzeCallResultForVectorFloat(Ins, RetTy);
    CCState::AnalyzeCallResult(Ins, Fn);
    OriginalArgWasFloat.clear();
    OriginalArgWasF128.clear();
    OriginalArgWasFloatVector.clear();
  }

  void AnalyzeReturn(const SmallVectorImpl<ISD::OutputArg> &Outs,
                     CCAssignFn Fn) {
    PreAnalyzeReturnForF128(Outs);
    PreAnalyzeReturnForVectorFloat(Outs);
    CCState::AnalyzeReturn(Outs, Fn);
    OriginalArgWasFloat.clear();
    OriginalArgWasF128.clear();
    OriginalArgWasFloatVector.clear();
  }

  bool CheckReturn(const SmallVectorImpl<ISD::OutputArg> &ArgsFlags,
                   CCAssignFn Fn) {
    PreAnalyzeReturnForF128(ArgsFlags);
    PreAnalyzeReturnForVectorFloat(ArgsFlags);
    bool Return = CCState::CheckReturn(ArgsFlags, Fn);
    OriginalArgWasFloat.clear();
    OriginalArgWasF128.clear();
    OriginalArgWasFloatVector.clear();
    return Return;
  }

  bool WasOriginalArgF128(unsigned ValNo) { return OriginalArgWasF128[ValNo]; }
  bool WasOriginalArgFloat(unsigned ValNo) {
      return OriginalArgWasFloat[ValNo];
  }
  bool WasOriginalArgVectorFloat(unsigned ValNo) const {
    return OriginalArgWasFloatVector[ValNo];
  }
  bool WasOriginalRetVectorFloat(unsigned ValNo) const {
    return OriginalRetWasFloatVector[ValNo];
  }
  bool IsCallOperandFixed(unsigned ValNo) { return CallOperandIsFixed[ValNo]; }
  SpecialCallingConvType getSpecialCallingConv() { return SpecialCallingConv; }
};
}

#endif
