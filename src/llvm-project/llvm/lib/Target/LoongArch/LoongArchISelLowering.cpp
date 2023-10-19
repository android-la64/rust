//===- LoongArchISelLowering.cpp - LoongArch DAG Lowering Implementation ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the interfaces that LoongArch uses to lower LLVM code into a
// selection DAG.
//
//===----------------------------------------------------------------------===//

#include "LoongArchISelLowering.h"
#include "MCTargetDesc/LoongArchBaseInfo.h"
#include "MCTargetDesc/LoongArchInstPrinter.h"
#include "MCTargetDesc/LoongArchMCTargetDesc.h"
#include "LoongArchCCState.h"
#include "LoongArchInstrInfo.h"
#include "LoongArchMachineFunction.h"
#include "LoongArchRegisterInfo.h"
#include "LoongArchSubtarget.h"
#include "LoongArchTargetMachine.h"
#include "LoongArchTargetObjectFile.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/ADT/Triple.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/FunctionLoweringInfo.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RuntimeLibcalls.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/SelectionDAGNodes.h"
#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/IntrinsicsLoongArch.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MachineValueType.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include <algorithm>
#include <cassert>
#include <cctype>
#include <cstdint>
#include <deque>
#include <iterator>
#include <utility>
#include <vector>

using namespace llvm;

#define DEBUG_TYPE "loongarch-lower"

STATISTIC(NumTailCalls, "Number of tail calls");

static cl::opt<bool>
NoZeroDivCheck("mnocheck-zero-division", cl::Hidden,
               cl::desc("LoongArch: Don't trap on integer division by zero."),
               cl::init(false));

static const MCPhysReg LoongArch64DPRegs[8] = {
  LoongArch::F0_64, LoongArch::F1_64, LoongArch::F2_64, LoongArch::F3_64,
  LoongArch::F4_64, LoongArch::F5_64, LoongArch::F6_64, LoongArch::F7_64
};

// If I is a shifted mask, set the size (SMSize) and the first bit of the
// mask (SMLsb), and return true.
// For example, if I is 0x003ff800, (SMLsb, SMSize) = (11, 11).
static bool isShiftedMask(uint64_t I, uint64_t &SMLsb, uint64_t &SMSize) {
  if (!isShiftedMask_64(I))
    return false;

  SMSize = countPopulation(I);
  SMLsb = countTrailingZeros(I);
  return true;
}

SDValue LoongArchTargetLowering::getTargetNode(GlobalAddressSDNode *N, EVT Ty,
                                          SelectionDAG &DAG,
                                          unsigned Flag) const {
  return DAG.getTargetGlobalAddress(N->getGlobal(), SDLoc(N), Ty, 0, Flag);
}

SDValue LoongArchTargetLowering::getTargetNode(ExternalSymbolSDNode *N, EVT Ty,
                                          SelectionDAG &DAG,
                                          unsigned Flag) const {
  return DAG.getTargetExternalSymbol(N->getSymbol(), Ty, Flag);
}

SDValue LoongArchTargetLowering::getTargetNode(BlockAddressSDNode *N, EVT Ty,
                                          SelectionDAG &DAG,
                                          unsigned Flag) const {
  return DAG.getTargetBlockAddress(N->getBlockAddress(), Ty, N->getOffset(), Flag);
}

SDValue LoongArchTargetLowering::getTargetNode(JumpTableSDNode *N, EVT Ty,
                                          SelectionDAG &DAG,
                                          unsigned Flag) const {
  return DAG.getTargetJumpTable(N->getIndex(), Ty, Flag);
}

SDValue LoongArchTargetLowering::getTargetNode(ConstantPoolSDNode *N, EVT Ty,
                                          SelectionDAG &DAG,
                                          unsigned Flag) const {
  return DAG.getTargetConstantPool(N->getConstVal(), Ty, N->getAlign(),
                                   N->getOffset(), Flag);
}

const char *LoongArchTargetLowering::getTargetNodeName(unsigned Opcode) const {
  switch ((LoongArchISD::NodeType)Opcode) {
  case LoongArchISD::FIRST_NUMBER:      break;
  case LoongArchISD::JmpLink:           return "LoongArchISD::JmpLink";
  case LoongArchISD::TailCall:          return "LoongArchISD::TailCall";
  case LoongArchISD::GlobalAddress:     return "LoongArchISD::GlobalAddress";
  case LoongArchISD::Ret:               return "LoongArchISD::Ret";
  case LoongArchISD::ERet:              return "LoongArchISD::ERet";
  case LoongArchISD::EH_RETURN:         return "LoongArchISD::EH_RETURN";
  case LoongArchISD::FPBrcond:          return "LoongArchISD::FPBrcond";
  case LoongArchISD::FPCmp:             return "LoongArchISD::FPCmp";
  case LoongArchISD::CMovFP_T:          return "LoongArchISD::CMovFP_T";
  case LoongArchISD::CMovFP_F:          return "LoongArchISD::CMovFP_F";
  case LoongArchISD::TruncIntFP:        return "LoongArchISD::TruncIntFP";
  case LoongArchISD::DBAR:              return "LoongArchISD::DBAR";
  case LoongArchISD::BSTRPICK:          return "LoongArchISD::BSTRPICK";
  case LoongArchISD::BSTRINS:           return "LoongArchISD::BSTRINS";
  case LoongArchISD::VALL_ZERO:
    return "LoongArchISD::VALL_ZERO";
  case LoongArchISD::VANY_ZERO:
    return "LoongArchISD::VANY_ZERO";
  case LoongArchISD::VALL_NONZERO:
    return "LoongArchISD::VALL_NONZERO";
  case LoongArchISD::VANY_NONZERO:
    return "LoongArchISD::VANY_NONZERO";
  case LoongArchISD::VEXTRACT_SEXT_ELT:
    return "LoongArchISD::VEXTRACT_SEXT_ELT";
  case LoongArchISD::VEXTRACT_ZEXT_ELT:
    return "LoongArchISD::VEXTRACT_ZEXT_ELT";
  case LoongArchISD::VNOR:
    return "LoongArchISD::VNOR";
  case LoongArchISD::VSHF:
    return "LoongArchISD::VSHF";
  case LoongArchISD::SHF:
    return "LoongArchISD::SHF";
  case LoongArchISD::VPACKEV:
    return "LoongArchISD::VPACKEV";
  case LoongArchISD::VPACKOD:
    return "LoongArchISD::VPACKOD";
  case LoongArchISD::VILVH:
    return "LoongArchISD::VILVH";
  case LoongArchISD::VILVL:
    return "LoongArchISD::VILVL";
  case LoongArchISD::VPICKEV:
    return "LoongArchISD::VPICKEV";
  case LoongArchISD::VPICKOD:
    return "LoongArchISD::VPICKOD";
  case LoongArchISD::INSVE:
    return "LoongArchISD::INSVE";
  case LoongArchISD::VROR:
    return "LoongArchISD::VROR";
  case LoongArchISD::VRORI:
    return "LoongArchISD::VRORI";
  case LoongArchISD::XVBROADCAST:
    return "LoongArchISD::XVBROADCAST";
  case LoongArchISD::VBROADCAST:
    return "LoongArchISD::VBROADCAST";
  case LoongArchISD::VABSD:
    return "LoongArchISD::VABSD";
  case LoongArchISD::UVABSD:
    return "LoongArchISD::UVABSD";
  case LoongArchISD::XVPICKVE:
    return "LoongArchISD::XVPICKVE";
  case LoongArchISD::XVPERMI:
    return "LoongArchISD::XVPERMI";
  case LoongArchISD::XVSHUF4I:
    return "LoongArchISD::XVSHUF4I";
  case LoongArchISD::REVBD:
    return "LoongArchISD::REVBD";
  case LoongArchISD::FSEL:
    return "LoongArchISD::FSEL";
  }
  return nullptr;
}

LoongArchTargetLowering::LoongArchTargetLowering(const LoongArchTargetMachine &TM,
                                       const LoongArchSubtarget &STI)
    : TargetLowering(TM), Subtarget(STI), ABI(TM.getABI()) {
  // Set up the register classes
  addRegisterClass(MVT::i32, &LoongArch::GPR32RegClass);

  if (Subtarget.is64Bit())
    addRegisterClass(MVT::i64, &LoongArch::GPR64RegClass);

  // LoongArch does not have i1 type, so use i32 for
  // setcc operations results (slt, sgt, ...).
  setBooleanContents(ZeroOrOneBooleanContent);
  setBooleanVectorContents(ZeroOrNegativeOneBooleanContent);

  // Load extented operations for i1 types must be promoted
  for (MVT VT : MVT::integer_valuetypes()) {
    setLoadExtAction(ISD::EXTLOAD,  VT, MVT::i1,  Promote);
    setLoadExtAction(ISD::ZEXTLOAD, VT, MVT::i1,  Promote);
    setLoadExtAction(ISD::SEXTLOAD, VT, MVT::i1,  Promote);
  }

  // LoongArch doesn't have extending float->double load/store.  Set LoadExtAction
  // for f32, f16
  for (MVT VT : MVT::fp_valuetypes()) {
    setLoadExtAction(ISD::EXTLOAD, VT, MVT::f32, Expand);
    setLoadExtAction(ISD::EXTLOAD, VT, MVT::f16, Expand);
  }

  // Set LoadExtAction for f16 vectors to Expand
  for (MVT VT : MVT::fp_fixedlen_vector_valuetypes()) {
    MVT F16VT = MVT::getVectorVT(MVT::f16, VT.getVectorNumElements());
    if (F16VT.isValid())
      setLoadExtAction(ISD::EXTLOAD, VT, F16VT, Expand);
  }

  setTruncStoreAction(MVT::f32, MVT::f16, Expand);
  setTruncStoreAction(MVT::f64, MVT::f16, Expand);

  setTruncStoreAction(MVT::f64, MVT::f32, Expand);

  // Used by legalize types to correctly generate the setcc result.
  // Without this, every float setcc comes with a AND/OR with the result,
  // we don't want this, since the fpcmp result goes to a flag register,
  // which is used implicitly by brcond and select operations.
  AddPromotedToType(ISD::SETCC, MVT::i1, MVT::i32);

  // LoongArch Custom Operations
  setOperationAction(ISD::BR_JT,              MVT::Other, Expand);
  setOperationAction(ISD::GlobalAddress,      MVT::i32,   Custom);
  setOperationAction(ISD::BlockAddress,       MVT::i32,   Custom);
  setOperationAction(ISD::GlobalTLSAddress,   MVT::i32,   Custom);
  setOperationAction(ISD::JumpTable,          MVT::i32,   Custom);
  setOperationAction(ISD::ConstantPool,       MVT::i32,   Custom);
  setOperationAction(ISD::SELECT,             MVT::f32,   Custom);
  setOperationAction(ISD::SELECT,             MVT::f64,   Custom);
  setOperationAction(ISD::SELECT,             MVT::i32,   Custom);
  setOperationAction(ISD::SETCC,              MVT::f32,   Custom);
  setOperationAction(ISD::SETCC,              MVT::f64,   Custom);
  setOperationAction(ISD::BRCOND,             MVT::Other, Custom);
  setOperationAction(ISD::FP_TO_SINT,         MVT::i32,   Custom);

  if (Subtarget.is64Bit()) {
    setOperationAction(ISD::GlobalAddress,      MVT::i64,   Custom);
    setOperationAction(ISD::BlockAddress,       MVT::i64,   Custom);
    setOperationAction(ISD::GlobalTLSAddress,   MVT::i64,   Custom);
    setOperationAction(ISD::JumpTable,          MVT::i64,   Custom);
    setOperationAction(ISD::ConstantPool,       MVT::i64,   Custom);
    setOperationAction(ISD::SELECT,             MVT::i64,   Custom);
    setOperationAction(ISD::LOAD,               MVT::i64,   Legal);
    setOperationAction(ISD::STORE, MVT::i64, Legal);
    setOperationAction(ISD::FP_TO_SINT,         MVT::i64,   Custom);
    setOperationAction(ISD::SHL_PARTS,          MVT::i64,   Custom);
    setOperationAction(ISD::SRA_PARTS,          MVT::i64,   Custom);
    setOperationAction(ISD::SRL_PARTS,          MVT::i64,   Custom);
  }

  if (!Subtarget.is64Bit()) {
    setOperationAction(ISD::SHL_PARTS,          MVT::i32,   Custom);
    setOperationAction(ISD::SRA_PARTS,          MVT::i32,   Custom);
    setOperationAction(ISD::SRL_PARTS,          MVT::i32,   Custom);
  }

  setOperationAction(ISD::EH_DWARF_CFA,         MVT::i32,   Custom);
  if (Subtarget.is64Bit())
    setOperationAction(ISD::EH_DWARF_CFA,       MVT::i64,   Custom);

  setOperationAction(ISD::SDIV, MVT::i32, Expand);
  setOperationAction(ISD::SREM, MVT::i32, Expand);
  setOperationAction(ISD::UDIV, MVT::i32, Expand);
  setOperationAction(ISD::UREM, MVT::i32, Expand);
  setOperationAction(ISD::SDIV, MVT::i64, Expand);
  setOperationAction(ISD::SREM, MVT::i64, Expand);
  setOperationAction(ISD::UDIV, MVT::i64, Expand);
  setOperationAction(ISD::UREM, MVT::i64, Expand);

  // Operations not directly supported by LoongArch.
  setOperationAction(ISD::BR_CC,             MVT::f32,   Expand);
  setOperationAction(ISD::BR_CC,             MVT::f64,   Expand);
  setOperationAction(ISD::BR_CC,             MVT::i32,   Expand);
  setOperationAction(ISD::BR_CC,             MVT::i64,   Expand);
  setOperationAction(ISD::SELECT_CC,         MVT::i32,   Expand);
  setOperationAction(ISD::SELECT_CC,         MVT::i64,   Expand);
  setOperationAction(ISD::SELECT_CC,         MVT::f32,   Expand);
  setOperationAction(ISD::SELECT_CC,         MVT::f64,   Expand);
  setOperationAction(ISD::UINT_TO_FP,        MVT::i32,   Expand);
  setOperationAction(ISD::UINT_TO_FP,        MVT::i64,   Expand);
  setOperationAction(ISD::FP_TO_UINT,        MVT::i32,   Expand);
  setOperationAction(ISD::FP_TO_UINT,        MVT::i64,   Expand);
  setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i1,    Expand);
  setOperationAction(ISD::CTPOP,           MVT::i32,   Expand);
  setOperationAction(ISD::CTPOP,           MVT::i64,   Expand);
  setOperationAction(ISD::ROTL,              MVT::i32,   Expand);
  setOperationAction(ISD::ROTL,              MVT::i64,   Expand);
  setOperationAction(ISD::DYNAMIC_STACKALLOC, MVT::i32,  Expand);
  setOperationAction(ISD::DYNAMIC_STACKALLOC, MVT::i64,  Expand);

  setOperationAction(ISD::FSIN,              MVT::f32,   Expand);
  setOperationAction(ISD::FSIN,              MVT::f64,   Expand);
  setOperationAction(ISD::FCOS,              MVT::f32,   Expand);
  setOperationAction(ISD::FCOS,              MVT::f64,   Expand);
  setOperationAction(ISD::FSINCOS,           MVT::f32,   Expand);
  setOperationAction(ISD::FSINCOS,           MVT::f64,   Expand);
  setOperationAction(ISD::FPOW,              MVT::f32,   Expand);
  setOperationAction(ISD::FPOW,              MVT::f64,   Expand);
  setOperationAction(ISD::FLOG,              MVT::f32,   Expand);
  setOperationAction(ISD::FRINT,             MVT::f32,   Legal);
  setOperationAction(ISD::FRINT,             MVT::f64,   Legal);

  setOperationAction(ISD::FLOG10,            MVT::f32,   Expand);
  setOperationAction(ISD::FEXP,              MVT::f32,   Expand);
  setOperationAction(ISD::FMA,               MVT::f32,   Legal);
  setOperationAction(ISD::FMA,               MVT::f64,   Legal);
  setOperationAction(ISD::FREM,              MVT::f32,   Expand);
  setOperationAction(ISD::FREM,              MVT::f64,   Expand);

  setOperationAction(ISD::FMINNUM_IEEE,      MVT::f32,   Legal);
  setOperationAction(ISD::FMINNUM_IEEE,      MVT::f64,   Legal);
  setOperationAction(ISD::FMAXNUM_IEEE,      MVT::f32,   Legal);
  setOperationAction(ISD::FMAXNUM_IEEE,      MVT::f64,   Legal);

  // Lower f16 conversion operations into library calls
  setOperationAction(ISD::FP16_TO_FP,        MVT::f32,   Expand);
  setOperationAction(ISD::FP_TO_FP16,        MVT::f32,   Expand);
  setOperationAction(ISD::FP16_TO_FP,        MVT::f64,   Expand);
  setOperationAction(ISD::FP_TO_FP16,        MVT::f64,   Expand);

  setOperationAction(ISD::EH_RETURN, MVT::Other, Custom);

  setOperationAction(ISD::VASTART,           MVT::Other, Custom);
  setOperationAction(ISD::VAARG,             MVT::Other, Custom);
  setOperationAction(ISD::VACOPY,            MVT::Other, Expand);
  setOperationAction(ISD::VAEND,             MVT::Other, Expand);

  // Use the default for now
  setOperationAction(ISD::STACKSAVE,         MVT::Other, Expand);
  setOperationAction(ISD::STACKRESTORE,      MVT::Other, Expand);

  if (!Subtarget.is64Bit()) {
    setOperationAction(ISD::ATOMIC_LOAD,     MVT::i64,   Expand);
    setOperationAction(ISD::ATOMIC_STORE,    MVT::i64,   Expand);
  }

  if (Subtarget.is64Bit()) {
    setLoadExtAction(ISD::EXTLOAD, MVT::i64, MVT::i32, Custom);
    setTruncStoreAction(MVT::i64, MVT::i32, Custom);
  }

  setOperationAction(ISD::TRAP, MVT::Other, Legal);
  setOperationAction(ISD::BITREVERSE, MVT::i32, Legal);
  setOperationAction(ISD::BITREVERSE, MVT::i64, Legal);

  setTargetDAGCombine(ISD::SELECT);
  setTargetDAGCombine(ISD::AND);
  setTargetDAGCombine(ISD::OR);
  setTargetDAGCombine(ISD::AssertZext);
  setTargetDAGCombine(ISD::SHL);
  setTargetDAGCombine(ISD::SIGN_EXTEND);
  setTargetDAGCombine(ISD::ZERO_EXTEND);
  setTargetDAGCombine(ISD::ADD);
  setTargetDAGCombine(ISD::SUB);
  setTargetDAGCombine(ISD::MUL);
  setTargetDAGCombine(ISD::SRL);
  setTargetDAGCombine(ISD::SRA);

  if (ABI.IsLP32()) {
    // These libcalls are not available in 32-bit.
    setLibcallName(RTLIB::SHL_I128, nullptr);
    setLibcallName(RTLIB::SRL_I128, nullptr);
    setLibcallName(RTLIB::SRA_I128, nullptr);
  }

  if (Subtarget.hasLSX() || Subtarget.hasLASX()) {
    // Expand all truncating stores and extending loads.
    for (MVT VT0 : MVT::vector_valuetypes()) {
      for (MVT VT1 : MVT::vector_valuetypes()) {
        setTruncStoreAction(VT0, VT1, Expand);
        setLoadExtAction(ISD::SEXTLOAD, VT0, VT1, Expand);
        setLoadExtAction(ISD::ZEXTLOAD, VT0, VT1, Expand);
        setLoadExtAction(ISD::EXTLOAD, VT0, VT1, Expand);
      }
    }
  }

  if (Subtarget.hasLSX()) {
    addLSXIntType(MVT::v16i8, &LoongArch::LSX128BRegClass);
    addLSXIntType(MVT::v8i16, &LoongArch::LSX128HRegClass);
    addLSXIntType(MVT::v4i32, &LoongArch::LSX128WRegClass);
    addLSXIntType(MVT::v2i64, &LoongArch::LSX128DRegClass);
    addLSXFloatType(MVT::v4f32, &LoongArch::LSX128WRegClass);
    addLSXFloatType(MVT::v2f64, &LoongArch::LSX128DRegClass);

    // f16 is a storage-only type, always promote it to f32.
    setOperationAction(ISD::SETCC, MVT::f16, Promote);
    setOperationAction(ISD::BR_CC, MVT::f16, Promote);
    setOperationAction(ISD::SELECT_CC, MVT::f16, Promote);
    setOperationAction(ISD::SELECT, MVT::f16, Promote);
    setOperationAction(ISD::FADD, MVT::f16, Promote);
    setOperationAction(ISD::FSUB, MVT::f16, Promote);
    setOperationAction(ISD::FMUL, MVT::f16, Promote);
    setOperationAction(ISD::FDIV, MVT::f16, Promote);
    setOperationAction(ISD::FREM, MVT::f16, Promote);
    setOperationAction(ISD::FMA, MVT::f16, Promote);
    setOperationAction(ISD::FNEG, MVT::f16, Promote);
    setOperationAction(ISD::FABS, MVT::f16, Promote);
    setOperationAction(ISD::FCEIL, MVT::f16, Promote);
    setOperationAction(ISD::FCOPYSIGN, MVT::f16, Promote);
    setOperationAction(ISD::FCOS, MVT::f16, Promote);
    setOperationAction(ISD::FP_EXTEND, MVT::f16, Promote);
    setOperationAction(ISD::FFLOOR, MVT::f16, Promote);
    setOperationAction(ISD::FNEARBYINT, MVT::f16, Promote);
    setOperationAction(ISD::FPOW, MVT::f16, Promote);
    setOperationAction(ISD::FPOWI, MVT::f16, Promote);
    setOperationAction(ISD::FRINT, MVT::f16, Promote);
    setOperationAction(ISD::FSIN, MVT::f16, Promote);
    setOperationAction(ISD::FSINCOS, MVT::f16, Promote);
    setOperationAction(ISD::FSQRT, MVT::f16, Promote);
    setOperationAction(ISD::FEXP, MVT::f16, Promote);
    setOperationAction(ISD::FEXP2, MVT::f16, Promote);
    setOperationAction(ISD::FLOG, MVT::f16, Promote);
    setOperationAction(ISD::FLOG2, MVT::f16, Promote);
    setOperationAction(ISD::FLOG10, MVT::f16, Promote);
    setOperationAction(ISD::FROUND, MVT::f16, Promote);
    setOperationAction(ISD::FTRUNC, MVT::f16, Promote);
    setOperationAction(ISD::FMINNUM, MVT::f16, Promote);
    setOperationAction(ISD::FMAXNUM, MVT::f16, Promote);
    setOperationAction(ISD::FMINIMUM, MVT::f16, Promote);
    setOperationAction(ISD::FMAXIMUM, MVT::f16, Promote);

    setTargetDAGCombine(ISD::AND);
    setTargetDAGCombine(ISD::OR);
    setTargetDAGCombine(ISD::SRA);
    setTargetDAGCombine(ISD::VSELECT);
    setTargetDAGCombine(ISD::XOR);
  }

  if (Subtarget.hasLASX()) {
    addLASXIntType(MVT::v32i8, &LoongArch::LASX256BRegClass);
    addLASXIntType(MVT::v16i16, &LoongArch::LASX256HRegClass);
    addLASXIntType(MVT::v8i32, &LoongArch::LASX256WRegClass);
    addLASXIntType(MVT::v4i64, &LoongArch::LASX256DRegClass);
    addLASXFloatType(MVT::v8f32, &LoongArch::LASX256WRegClass);
    addLASXFloatType(MVT::v4f64, &LoongArch::LASX256DRegClass);

    // f16 is a storage-only type, always promote it to f32.
    setOperationAction(ISD::SETCC, MVT::f16, Promote);
    setOperationAction(ISD::BR_CC, MVT::f16, Promote);
    setOperationAction(ISD::SELECT_CC, MVT::f16, Promote);
    setOperationAction(ISD::SELECT, MVT::f16, Promote);
    setOperationAction(ISD::FADD, MVT::f16, Promote);
    setOperationAction(ISD::FSUB, MVT::f16, Promote);
    setOperationAction(ISD::FMUL, MVT::f16, Promote);
    setOperationAction(ISD::FDIV, MVT::f16, Promote);
    setOperationAction(ISD::FREM, MVT::f16, Promote);
    setOperationAction(ISD::FMA, MVT::f16, Promote);
    setOperationAction(ISD::FNEG, MVT::f16, Promote);
    setOperationAction(ISD::FABS, MVT::f16, Promote);
    setOperationAction(ISD::FCEIL, MVT::f16, Promote);
    setOperationAction(ISD::FCOPYSIGN, MVT::f16, Promote);
    setOperationAction(ISD::FCOS, MVT::f16, Promote);
    setOperationAction(ISD::FP_EXTEND, MVT::f16, Promote);
    setOperationAction(ISD::FFLOOR, MVT::f16, Promote);
    setOperationAction(ISD::FNEARBYINT, MVT::f16, Promote);
    setOperationAction(ISD::FPOW, MVT::f16, Promote);
    setOperationAction(ISD::FPOWI, MVT::f16, Promote);
    setOperationAction(ISD::FRINT, MVT::f16, Promote);
    setOperationAction(ISD::FSIN, MVT::f16, Promote);
    setOperationAction(ISD::FSINCOS, MVT::f16, Promote);
    setOperationAction(ISD::FSQRT, MVT::f16, Promote);
    setOperationAction(ISD::FEXP, MVT::f16, Promote);
    setOperationAction(ISD::FEXP2, MVT::f16, Promote);
    setOperationAction(ISD::FLOG, MVT::f16, Promote);
    setOperationAction(ISD::FLOG2, MVT::f16, Promote);
    setOperationAction(ISD::FLOG10, MVT::f16, Promote);
    setOperationAction(ISD::FROUND, MVT::f16, Promote);
    setOperationAction(ISD::FTRUNC, MVT::f16, Promote);
    setOperationAction(ISD::FMINNUM, MVT::f16, Promote);
    setOperationAction(ISD::FMAXNUM, MVT::f16, Promote);
    setOperationAction(ISD::FMINIMUM, MVT::f16, Promote);
    setOperationAction(ISD::FMAXIMUM, MVT::f16, Promote);

    setTargetDAGCombine(ISD::AND);
    setTargetDAGCombine(ISD::OR);
    setTargetDAGCombine(ISD::SRA);
    setTargetDAGCombine(ISD::VSELECT);
    setTargetDAGCombine(ISD::XOR);
  }

  if (!Subtarget.useSoftFloat()) {
    addRegisterClass(MVT::f32, &LoongArch::FGR32RegClass);

    // When dealing with single precision only, use libcalls
    if (!Subtarget.isSingleFloat()) {
      if (Subtarget.isFP64bit())
        addRegisterClass(MVT::f64, &LoongArch::FGR64RegClass);
    }
  }

  setOperationAction(ISD::SMUL_LOHI,          MVT::i32, Custom);
  setOperationAction(ISD::UMUL_LOHI,          MVT::i32, Custom);

  if (Subtarget.is64Bit())
    setOperationAction(ISD::MUL,              MVT::i64, Custom);

  if (Subtarget.is64Bit()) {
    setOperationAction(ISD::SMUL_LOHI,        MVT::i64, Custom);
    setOperationAction(ISD::UMUL_LOHI,        MVT::i64, Custom);
    setOperationAction(ISD::SDIVREM,          MVT::i64, Custom);
    setOperationAction(ISD::UDIVREM,          MVT::i64, Custom);
  }

  setOperationAction(ISD::INTRINSIC_WO_CHAIN, MVT::i64, Custom);
  setOperationAction(ISD::INTRINSIC_W_CHAIN,  MVT::i64, Custom);

  setOperationAction(ISD::SDIVREM, MVT::i32, Custom);
  setOperationAction(ISD::UDIVREM, MVT::i32, Custom);
  setOperationAction(ISD::ATOMIC_FENCE,       MVT::Other, Custom);
  setOperationAction(ISD::LOAD,               MVT::i32, Legal);
  setOperationAction(ISD::STORE, MVT::i32, Legal);

  setTargetDAGCombine(ISD::MUL);

  setOperationAction(ISD::INTRINSIC_WO_CHAIN, MVT::Other, Custom);
  setOperationAction(ISD::INTRINSIC_W_CHAIN, MVT::Other, Custom);
  setOperationAction(ISD::INTRINSIC_VOID, MVT::Other, Custom);

  // Replace the accumulator-based multiplies with a
  // three register instruction.
  setOperationAction(ISD::SMUL_LOHI, MVT::i32, Expand);
  setOperationAction(ISD::UMUL_LOHI, MVT::i32, Expand);
  setOperationAction(ISD::MUL, MVT::i32, Legal);
  setOperationAction(ISD::MULHS, MVT::i32, Legal);
  setOperationAction(ISD::MULHU, MVT::i32, Legal);

  // Replace the accumulator-based division/remainder with separate
  // three register division and remainder instructions.
  setOperationAction(ISD::SDIVREM, MVT::i32, Expand);
  setOperationAction(ISD::UDIVREM, MVT::i32, Expand);
  setOperationAction(ISD::SDIV, MVT::i32, Legal);
  setOperationAction(ISD::UDIV, MVT::i32, Legal);
  setOperationAction(ISD::SREM, MVT::i32, Legal);
  setOperationAction(ISD::UREM, MVT::i32, Legal);

  // Replace the accumulator-based multiplies with a
  // three register instruction.
  setOperationAction(ISD::SMUL_LOHI, MVT::i64, Expand);
  setOperationAction(ISD::UMUL_LOHI, MVT::i64, Expand);
  setOperationAction(ISD::MUL, MVT::i64, Legal);
  setOperationAction(ISD::MULHS, MVT::i64, Legal);
  setOperationAction(ISD::MULHU, MVT::i64, Legal);

  // Replace the accumulator-based division/remainder with separate
  // three register division and remainder instructions.
  setOperationAction(ISD::SDIVREM, MVT::i64, Expand);
  setOperationAction(ISD::UDIVREM, MVT::i64, Expand);
  setOperationAction(ISD::SDIV, MVT::i64, Legal);
  setOperationAction(ISD::UDIV, MVT::i64, Legal);
  setOperationAction(ISD::SREM, MVT::i64, Legal);
  setOperationAction(ISD::UREM, MVT::i64, Legal);

  MaxGluedStoresPerMemcpy = 4;

  setMinFunctionAlignment(Align(4));

  // The arguments on the stack are defined in terms of 4-byte slots on LP32
  // and 8-byte slots on LPX32/LP64.
  setMinStackArgumentAlignment((ABI.IsLPX32() || ABI.IsLP64()) ? Align(8)
                                                               : Align(4));

  setStackPointerRegisterToSaveRestore(ABI.IsLP64() ? LoongArch::SP_64 : LoongArch::SP);

  if (Subtarget.hasLASX()) {
    // = 16*32/2; the smallest memcpy;
    MaxStoresPerMemcpy = 16;
  } else if (Subtarget.hasLSX()) {
    MaxStoresPerMemcpy = 65535;
  } else {
    MaxStoresPerMemcpy = 16;
  }

  computeRegisterProperties(Subtarget.getRegisterInfo());
}

// Enable LSX support for the given integer type and Register class.
void LoongArchTargetLowering::addLSXIntType(MVT::SimpleValueType Ty,
                                            const TargetRegisterClass *RC) {
  addRegisterClass(Ty, RC);

  // Expand all builtin opcodes.
  for (unsigned Opc = 0; Opc < ISD::BUILTIN_OP_END; ++Opc)
    setOperationAction(Opc, Ty, Expand);

  setOperationAction(ISD::BITCAST, Ty, Legal);
  setOperationAction(ISD::LOAD, Ty, Legal);
  setOperationAction(ISD::STORE, Ty, Legal);
  setOperationAction(ISD::EXTRACT_VECTOR_ELT, Ty, Custom);
  setOperationAction(ISD::INSERT_VECTOR_ELT, Ty, Legal);
  setOperationAction(ISD::BUILD_VECTOR, Ty, Custom);
  setOperationAction(ISD::ABS, Ty, Legal);
  setOperationAction(ISD::UNDEF, Ty, Legal);
  setOperationAction(ISD::EXTRACT_SUBVECTOR, Ty, Legal);
  setOperationAction(ISD::CONCAT_VECTORS, Ty, Legal);

  if (Ty == MVT::v4i32 || Ty == MVT::v2i64) {
    setOperationAction(ISD::FP_TO_SINT, Ty, Custom);
    setOperationAction(ISD::FP_TO_UINT, Ty, Custom);
  }

  setOperationAction(ISD::ADD, Ty, Legal);
  setOperationAction(ISD::AND, Ty, Legal);
  setOperationAction(ISD::CTLZ, Ty, Legal);
  setOperationAction(ISD::CTPOP, Ty, Legal);
  setOperationAction(ISD::MUL, Ty, Legal);
  setOperationAction(ISD::OR, Ty, Legal);
  setOperationAction(ISD::SDIV, Ty, Legal);
  setOperationAction(ISD::SREM, Ty, Legal);
  setOperationAction(ISD::SHL, Ty, Legal);
  setOperationAction(ISD::SRA, Ty, Legal);
  setOperationAction(ISD::SRL, Ty, Legal);
  setOperationAction(ISD::SUB, Ty, Legal);
  setOperationAction(ISD::SMAX, Ty, Legal);
  setOperationAction(ISD::SMIN, Ty, Legal);
  setOperationAction(ISD::UDIV, Ty, Legal);
  setOperationAction(ISD::UREM, Ty, Legal);
  setOperationAction(ISD::UMAX, Ty, Legal);
  setOperationAction(ISD::UMIN, Ty, Legal);
  setOperationAction(ISD::VECTOR_SHUFFLE, Ty, Custom);
  setOperationAction(ISD::VSELECT, Ty, Legal);
  setOperationAction(ISD::XOR, Ty, Legal);
  setOperationAction(ISD::MULHS, Ty, Legal);
  setOperationAction(ISD::MULHU, Ty, Legal);

  if (Ty == MVT::v4i32 || Ty == MVT::v2i64) {
    setOperationAction(ISD::SINT_TO_FP, Ty, Custom);
    setOperationAction(ISD::UINT_TO_FP, Ty, Custom);
  }

  setOperationAction(ISD::SETCC, Ty, Legal);
  setCondCodeAction(ISD::SETNE, Ty, Expand);
  setCondCodeAction(ISD::SETGE, Ty, Expand);
  setCondCodeAction(ISD::SETGT, Ty, Expand);
  setCondCodeAction(ISD::SETUGE, Ty, Expand);
  setCondCodeAction(ISD::SETUGT, Ty, Expand);
}

// Enable LASX support for the given integer type and Register class.
void LoongArchTargetLowering::addLASXIntType(MVT::SimpleValueType Ty,
                                             const TargetRegisterClass *RC) {
  addRegisterClass(Ty, RC);

  // Expand all builtin opcodes.
  for (unsigned Opc = 0; Opc < ISD::BUILTIN_OP_END; ++Opc)
    setOperationAction(Opc, Ty, Expand);

  // FIXME
  setOperationAction(ISD::BITCAST, Ty, Legal);
  setOperationAction(ISD::LOAD, Ty, Legal);
  setOperationAction(ISD::STORE, Ty, Legal);
  setOperationAction(ISD::EXTRACT_VECTOR_ELT, Ty, Custom);
  setOperationAction(ISD::INSERT_VECTOR_ELT, Ty, Custom);
  setOperationAction(ISD::BUILD_VECTOR, Ty, Custom);
  setOperationAction(ISD::CONCAT_VECTORS, Ty, Legal);
  setOperationAction(ISD::UNDEF, Ty, Legal);
  setOperationAction(ISD::UADDSAT, Ty, Legal);
  setOperationAction(ISD::SADDSAT, Ty, Legal);
  setOperationAction(ISD::USUBSAT, Ty, Legal);
  setOperationAction(ISD::SSUBSAT, Ty, Legal);
  setOperationAction(ISD::ABS, Ty, Legal);

  setOperationAction(ISD::ADD, Ty, Legal);
  setOperationAction(ISD::AND, Ty, Legal);
  setOperationAction(ISD::CTLZ, Ty, Legal);
  setOperationAction(ISD::CTPOP, Ty, Legal);
  setOperationAction(ISD::MUL, Ty, Legal);
  setOperationAction(ISD::OR, Ty, Legal);
  setOperationAction(ISD::SDIV, Ty, Legal);
  setOperationAction(ISD::SREM, Ty, Legal);
  setOperationAction(ISD::SHL, Ty, Legal);
  setOperationAction(ISD::SRA, Ty, Legal);
  setOperationAction(ISD::SRL, Ty, Legal);
  setOperationAction(ISD::SUB, Ty, Legal);
  setOperationAction(ISD::SMAX, Ty, Legal);
  setOperationAction(ISD::SMIN, Ty, Legal);
  setOperationAction(ISD::UDIV, Ty, Legal);
  setOperationAction(ISD::UREM, Ty, Legal);
  setOperationAction(ISD::UMAX, Ty, Legal);
  setOperationAction(ISD::UMIN, Ty, Legal);
  setOperationAction(ISD::VECTOR_SHUFFLE, Ty, Custom);
  setOperationAction(ISD::VSELECT, Ty, Legal);
  setOperationAction(ISD::XOR, Ty, Legal);
  setOperationAction(ISD::INSERT_SUBVECTOR, Ty, Legal);
  setOperationAction(ISD::MULHS, Ty, Legal);
  setOperationAction(ISD::MULHU, Ty, Legal);

  setOperationAction(ISD::SIGN_EXTEND_VECTOR_INREG, Ty, Legal);
  setOperationAction(ISD::ZERO_EXTEND_VECTOR_INREG, Ty, Legal);

  setOperationAction(ISD::SIGN_EXTEND, Ty, Legal);
  setOperationAction(ISD::ZERO_EXTEND, Ty, Legal);

  if (Ty == MVT::v8i32 || Ty == MVT::v4i64) {
    setOperationAction(ISD::SINT_TO_FP, Ty, Custom);
    setOperationAction(ISD::UINT_TO_FP, Ty, Custom);
  }

  setTargetDAGCombine(ISD::CONCAT_VECTORS);

  setOperationAction(ISD::SETCC, Ty, Legal);
  setCondCodeAction(ISD::SETNE, Ty, Expand);
  setCondCodeAction(ISD::SETGE, Ty, Expand);
  setCondCodeAction(ISD::SETGT, Ty, Expand);
  setCondCodeAction(ISD::SETUGE, Ty, Expand);
  setCondCodeAction(ISD::SETUGT, Ty, Expand);
}

// Enable LSX support for the given floating-point type and Register class.
void LoongArchTargetLowering::addLSXFloatType(MVT::SimpleValueType Ty,
                                              const TargetRegisterClass *RC) {
  addRegisterClass(Ty, RC);

  // Expand all builtin opcodes.
  for (unsigned Opc = 0; Opc < ISD::BUILTIN_OP_END; ++Opc)
    setOperationAction(Opc, Ty, Expand);

  setOperationAction(ISD::LOAD, Ty, Legal);
  setOperationAction(ISD::STORE, Ty, Legal);
  setOperationAction(ISD::BITCAST, Ty, Legal);
  setOperationAction(ISD::EXTRACT_VECTOR_ELT, Ty, Legal);
  setOperationAction(ISD::INSERT_VECTOR_ELT, Ty, Legal);
  setOperationAction(ISD::UNDEF, Ty, Legal);
  setOperationAction(ISD::BUILD_VECTOR, Ty, Custom);
  setOperationAction(ISD::CONCAT_VECTORS, Ty, Legal);

  if (Ty == MVT::v4f32 || Ty == MVT::v2f64) {
    setOperationAction(ISD::FP_TO_SINT, Ty, Custom);
    setOperationAction(ISD::FP_TO_UINT, Ty, Custom);
  }

  setOperationAction(ISD::FADD, Ty, Legal);
  setOperationAction(ISD::FDIV, Ty, Legal);
  setOperationAction(ISD::FMA, Ty, Legal);
  setOperationAction(ISD::FMUL, Ty, Legal);
  setOperationAction(ISD::FSQRT, Ty, Legal);
  setOperationAction(ISD::FSUB, Ty, Legal);
  setOperationAction(ISD::VSELECT, Ty, Legal);
  setOperationAction(ISD::FNEG, Ty, Legal);
  setOperationAction(ISD::FRINT, Ty, Legal);

  setOperationAction(ISD::SETCC, Ty, Legal);
  setCondCodeAction(ISD::SETOGE, Ty, Expand);
  setCondCodeAction(ISD::SETOGT, Ty, Expand);
  setCondCodeAction(ISD::SETUGE, Ty, Expand);
  setCondCodeAction(ISD::SETUGT, Ty, Expand);
  setCondCodeAction(ISD::SETGE, Ty, Expand);
  setCondCodeAction(ISD::SETGT, Ty, Expand);
}

// Enable LASX support for the given floating-point type and Register class.
void LoongArchTargetLowering::addLASXFloatType(MVT::SimpleValueType Ty,
                                               const TargetRegisterClass *RC) {
  addRegisterClass(Ty, RC);

  // Expand all builtin opcodes.
  for (unsigned Opc = 0; Opc < ISD::BUILTIN_OP_END; ++Opc)
    setOperationAction(Opc, Ty, Expand);

  setOperationAction(ISD::LOAD, Ty, Legal);
  setOperationAction(ISD::STORE, Ty, Legal);
  setOperationAction(ISD::BITCAST, Ty, Legal);
  setOperationAction(ISD::EXTRACT_VECTOR_ELT, Ty, Legal);
  setOperationAction(ISD::INSERT_VECTOR_ELT, Ty, Legal);
  setOperationAction(ISD::BUILD_VECTOR, Ty, Custom);
  setOperationAction(ISD::UNDEF, Ty, Legal);
  setOperationAction(ISD::CONCAT_VECTORS, Ty, Legal);

  setOperationAction(ISD::FADD, Ty, Legal);
  setOperationAction(ISD::FDIV, Ty, Legal);
  setOperationAction(ISD::FMA, Ty, Legal);
  setOperationAction(ISD::FMUL, Ty, Legal);
  setOperationAction(ISD::FSQRT, Ty, Legal);
  setOperationAction(ISD::FSUB, Ty, Legal);
  setOperationAction(ISD::VSELECT, Ty, Legal);
  setOperationAction(ISD::FNEG, Ty, Legal);
  setOperationAction(ISD::FRINT, Ty, Legal);

  if (Ty == MVT::v8f32 || Ty == MVT::v4f64) {
    setOperationAction(ISD::FP_TO_SINT, Ty, Custom);
    setOperationAction(ISD::FP_TO_UINT, Ty, Custom);
  }

  setOperationAction(ISD::SETCC, Ty, Legal);
  setCondCodeAction(ISD::SETOGE, Ty, Expand);
  setCondCodeAction(ISD::SETOGT, Ty, Expand);
  setCondCodeAction(ISD::SETUGE, Ty, Expand);
  setCondCodeAction(ISD::SETUGT, Ty, Expand);
  setCondCodeAction(ISD::SETGE, Ty, Expand);
  setCondCodeAction(ISD::SETGT, Ty, Expand);
}

bool LoongArchTargetLowering::allowsMisalignedMemoryAccesses(
    EVT VT, unsigned AddrSpace, Align Alignment, MachineMemOperand::Flags Flags,
    bool *Fast) const {
  if (!Subtarget.allowUnalignedAccess())
    return false;
  if (Fast)
    *Fast = true;
  return true;
}

EVT LoongArchTargetLowering::getSetCCResultType(const DataLayout &, LLVMContext &,
                                           EVT VT) const {
  if (!VT.isVector())
    return MVT::i32;
  return VT.changeVectorElementTypeToInteger();
}

static LoongArch::CondCode condCodeToFCC(ISD::CondCode CC) {
  switch (CC) {
  default: llvm_unreachable("Unknown fp condition code!");
  case ISD::SETEQ:
  case ISD::SETOEQ: return LoongArch::FCOND_OEQ;
  case ISD::SETUNE: return LoongArch::FCOND_UNE;
  case ISD::SETLT:
  case ISD::SETOLT: return LoongArch::FCOND_OLT;
  case ISD::SETGT:
  case ISD::SETOGT: return LoongArch::FCOND_OGT;
  case ISD::SETLE:
  case ISD::SETOLE: return LoongArch::FCOND_OLE;
  case ISD::SETGE:
  case ISD::SETOGE: return LoongArch::FCOND_OGE;
  case ISD::SETULT: return LoongArch::FCOND_ULT;
  case ISD::SETULE: return LoongArch::FCOND_ULE;
  case ISD::SETUGT: return LoongArch::FCOND_UGT;
  case ISD::SETUGE: return LoongArch::FCOND_UGE;
  case ISD::SETUO:  return LoongArch::FCOND_UN;
  case ISD::SETO:   return LoongArch::FCOND_OR;
  case ISD::SETNE:
  case ISD::SETONE: return LoongArch::FCOND_ONE;
  case ISD::SETUEQ: return LoongArch::FCOND_UEQ;
  }
}

/// This function returns true if the floating point conditional branches and
/// conditional moves which use condition code CC should be inverted.
static bool invertFPCondCodeUser(LoongArch::CondCode CC) {
  if (CC >= LoongArch::FCOND_F && CC <= LoongArch::FCOND_SUNE)
    return false;

  assert((CC >= LoongArch::FCOND_T && CC <= LoongArch::FCOND_GT) &&
         "Illegal Condition Code");

  return true;
}

// Creates and returns an FPCmp node from a setcc node.
// Returns Op if setcc is not a floating point comparison.
static SDValue createFPCmp(SelectionDAG &DAG, const SDValue &Op) {
  // must be a SETCC node
  if (Op.getOpcode() != ISD::SETCC)
    return Op;

  SDValue LHS = Op.getOperand(0);

  if (!LHS.getValueType().isFloatingPoint())
    return Op;

  SDValue RHS = Op.getOperand(1);
  SDLoc DL(Op);

  // Assume the 3rd operand is a CondCodeSDNode. Add code to check the type of
  // node if necessary.
  ISD::CondCode CC = cast<CondCodeSDNode>(Op.getOperand(2))->get();

  return DAG.getNode(LoongArchISD::FPCmp, DL, MVT::Glue, LHS, RHS,
                     DAG.getConstant(condCodeToFCC(CC), DL, MVT::i32));
}

// Creates and returns a CMovFPT/F node.
static SDValue createCMovFP(SelectionDAG &DAG, SDValue Cond, SDValue True,
                            SDValue False, const SDLoc &DL) {
  ConstantSDNode *CC = cast<ConstantSDNode>(Cond.getOperand(2));
  bool invert = invertFPCondCodeUser((LoongArch::CondCode)CC->getSExtValue());
  SDValue FCC0 = DAG.getRegister(LoongArch::FCC0, MVT::i32);

  return DAG.getNode((invert ? LoongArchISD::CMovFP_F : LoongArchISD::CMovFP_T), DL,
                 True.getValueType(), True, FCC0, False, Cond);

}

static SDValue performSELECTCombine(SDNode *N, SelectionDAG &DAG,
                                    TargetLowering::DAGCombinerInfo &DCI,
                                    const LoongArchSubtarget &Subtarget) {
  if (DCI.isBeforeLegalizeOps())
    return SDValue();

  SDValue SetCC = N->getOperand(0);

  if ((SetCC.getOpcode() != ISD::SETCC) ||
      !SetCC.getOperand(0).getValueType().isInteger())
    return SDValue();

  SDValue False = N->getOperand(2);
  EVT FalseTy = False.getValueType();

  if (!FalseTy.isInteger())
    return SDValue();

  ConstantSDNode *FalseC = dyn_cast<ConstantSDNode>(False);

  // If the RHS (False) is 0, we swap the order of the operands
  // of ISD::SELECT (obviously also inverting the condition) so that we can
  // take advantage of conditional moves using the $0 register.
  // Example:
  //   return (a != 0) ? x : 0;
  //     load $reg, x
  //     movz $reg, $0, a
  if (!FalseC)
    return SDValue();

  const SDLoc DL(N);

  if (!FalseC->getZExtValue()) {
    ISD::CondCode CC = cast<CondCodeSDNode>(SetCC.getOperand(2))->get();
    SDValue True = N->getOperand(1);

    SetCC = DAG.getSetCC(DL, SetCC.getValueType(), SetCC.getOperand(0),
                         SetCC.getOperand(1),
                         ISD::getSetCCInverse(CC, SetCC.getValueType()));

    return DAG.getNode(ISD::SELECT, DL, FalseTy, SetCC, False, True);
  }

  // If both operands are integer constants there's a possibility that we
  // can do some interesting optimizations.
  SDValue True = N->getOperand(1);
  ConstantSDNode *TrueC = dyn_cast<ConstantSDNode>(True);

  if (!TrueC || !True.getValueType().isInteger())
    return SDValue();

  // We'll also ignore MVT::i64 operands as this optimizations proves
  // to be ineffective because of the required sign extensions as the result
  // of a SETCC operator is always MVT::i32 for non-vector types.
  if (True.getValueType() == MVT::i64)
    return SDValue();

  int64_t Diff = TrueC->getSExtValue() - FalseC->getSExtValue();

  // 1)  (a < x) ? y : y-1
  //  slti $reg1, a, x
  //  addiu $reg2, $reg1, y-1
  if (Diff == 1)
    return DAG.getNode(ISD::ADD, DL, SetCC.getValueType(), SetCC, False);

  // 2)  (a < x) ? y-1 : y
  //  slti $reg1, a, x
  //  xor $reg1, $reg1, 1
  //  addiu $reg2, $reg1, y-1
  if (Diff == -1) {
    ISD::CondCode CC = cast<CondCodeSDNode>(SetCC.getOperand(2))->get();
    SetCC = DAG.getSetCC(DL, SetCC.getValueType(), SetCC.getOperand(0),
                         SetCC.getOperand(1),
                         ISD::getSetCCInverse(CC, SetCC.getValueType()));
    return DAG.getNode(ISD::ADD, DL, SetCC.getValueType(), SetCC, True);
  }

  // Could not optimize.
  return SDValue();
}

static SDValue performANDCombine(SDNode *N, SelectionDAG &DAG,
                                 TargetLowering::DAGCombinerInfo &DCI,
                                 const LoongArchSubtarget &Subtarget) {

  if (Subtarget.hasLSX()) {

    // Fold zero extensions into LoongArchISD::VEXTRACT_[SZ]EXT_ELT
    //
    // Performs the following transformations:
    // - Changes LoongArchISD::VEXTRACT_[SZ]EXT_ELT to zero extension if its
    //   sign/zero-extension is completely overwritten by the new one performed
    //   by the ISD::AND.
    // - Removes redundant zero extensions performed by an ISD::AND.
    SDValue Op0 = N->getOperand(0);
    SDValue Op1 = N->getOperand(1);
    unsigned Op0Opcode = Op0->getOpcode();

    // (and (LoongArchVExtract[SZ]Ext $a, $b, $c), imm:$d)
    // where $d + 1 == 2^n and n == 32
    // or    $d + 1 == 2^n and n <= 32 and ZExt
    // -> (LoongArchVExtractZExt $a, $b, $c)
    if (Op0Opcode == LoongArchISD::VEXTRACT_SEXT_ELT ||
        Op0Opcode == LoongArchISD::VEXTRACT_ZEXT_ELT) {
      ConstantSDNode *Mask = dyn_cast<ConstantSDNode>(Op1);

      if (Mask) {

        int32_t Log2IfPositive = (Mask->getAPIntValue() + 1).exactLogBase2();

        if (Log2IfPositive > 0) {
          SDValue Op0Op2 = Op0->getOperand(2);
          EVT ExtendTy = cast<VTSDNode>(Op0Op2)->getVT();
          unsigned ExtendTySize = ExtendTy.getSizeInBits();
          unsigned Log2 = Log2IfPositive;

          if ((Op0Opcode == LoongArchISD::VEXTRACT_ZEXT_ELT &&
               Log2 >= ExtendTySize) ||
              Log2 == ExtendTySize) {
            SDValue Ops[] = {Op0->getOperand(0), Op0->getOperand(1), Op0Op2};
            return DAG.getNode(LoongArchISD::VEXTRACT_ZEXT_ELT, SDLoc(Op0),
                               Op0->getVTList(),
                               makeArrayRef(Ops, Op0->getNumOperands()));
          }
        }
      }
    }
  }

  if (DCI.isBeforeLegalizeOps())
    return SDValue();

  SDValue FirstOperand = N->getOperand(0);
  unsigned FirstOperandOpc = FirstOperand.getOpcode();
  SDValue Mask = N->getOperand(1);
  EVT ValTy = N->getValueType(0);
  SDLoc DL(N);

  uint64_t Lsb = 0, SMLsb, SMSize;
  ConstantSDNode *CN;
  SDValue NewOperand;
  unsigned Opc;

  // Op's second operand must be a shifted mask.
  if (!(CN = dyn_cast<ConstantSDNode>(Mask)) ||
      !isShiftedMask(CN->getZExtValue(), SMLsb, SMSize))
    return SDValue();

  if (FirstOperandOpc == ISD::SRA || FirstOperandOpc == ISD::SRL) {
    // Pattern match BSTRPICK.
    //  $dst = and ((sra or srl) $src , lsb), (2**size - 1)
    //  => bstrpick $dst, $src, lsb+size-1, lsb

    // The second operand of the shift must be an immediate.
    if (!(CN = dyn_cast<ConstantSDNode>(FirstOperand.getOperand(1))))
      return SDValue();

    Lsb = CN->getZExtValue();

    // Return if the shifted mask does not start at bit 0 or the sum of its size
    // and Lsb exceeds the word's size.
    if (SMLsb != 0 || Lsb + SMSize > ValTy.getSizeInBits())
      return SDValue();

    Opc = LoongArchISD::BSTRPICK;
    NewOperand = FirstOperand.getOperand(0);
  } else {
    // Pattern match BSTRPICK.
    //  $dst = and $src, (2**size - 1) , if size > 12
    //  => bstrpick $dst, $src, lsb+size-1, lsb , lsb = 0

    // If the mask is <= 0xfff, andi can be used instead.
    if (CN->getZExtValue() <= 0xfff)
      return SDValue();
    // Return if the mask doesn't start at position 0.
    if (SMLsb)
      return SDValue();

    Opc = LoongArchISD::BSTRPICK;
    NewOperand = FirstOperand;
  }
  return DAG.getNode(Opc, DL, ValTy, NewOperand,
                     DAG.getConstant((Lsb + SMSize - 1), DL, MVT::i32),
                     DAG.getConstant(Lsb, DL, MVT::i32));
}

// Determine if the specified node is a constant vector splat.
//
// Returns true and sets Imm if:
// * N is a ISD::BUILD_VECTOR representing a constant splat
static bool isVSplat(SDValue N, APInt &Imm) {
  BuildVectorSDNode *Node = dyn_cast<BuildVectorSDNode>(N.getNode());

  if (!Node)
    return false;

  APInt SplatValue, SplatUndef;
  unsigned SplatBitSize;
  bool HasAnyUndefs;

  if (!Node->isConstantSplat(SplatValue, SplatUndef, SplatBitSize, HasAnyUndefs,
                             8))
    return false;

  Imm = SplatValue;

  return true;
}

// Test whether the given node is an all-ones build_vector.
static bool isVectorAllOnes(SDValue N) {
  // Look through bitcasts. Endianness doesn't matter because we are looking
  // for an all-ones value.
  if (N->getOpcode() == ISD::BITCAST)
    N = N->getOperand(0);

  BuildVectorSDNode *BVN = dyn_cast<BuildVectorSDNode>(N);

  if (!BVN)
    return false;

  APInt SplatValue, SplatUndef;
  unsigned SplatBitSize;
  bool HasAnyUndefs;

  // Endianness doesn't matter in this context because we are looking for
  // an all-ones value.
  if (BVN->isConstantSplat(SplatValue, SplatUndef, SplatBitSize, HasAnyUndefs))
    return SplatValue.isAllOnesValue();

  return false;
}

// Test whether N is the bitwise inverse of OfNode.
static bool isBitwiseInverse(SDValue N, SDValue OfNode) {
  if (N->getOpcode() != ISD::XOR)
    return false;

  if (isVectorAllOnes(N->getOperand(0)))
    return N->getOperand(1) == OfNode;

  if (isVectorAllOnes(N->getOperand(1)))
    return N->getOperand(0) == OfNode;

  return false;
}

static SDValue performSet(SDNode *N, SelectionDAG &DAG,
                          TargetLowering::DAGCombinerInfo &DCI,
                          const LoongArchSubtarget &Subtarget) {

  SDValue Op0 = N->getOperand(0);
  SDValue Op1 = N->getOperand(1);
  SDValue N1, N2;
  if (Op0->getOpcode() == ISD::BUILD_VECTOR &&
      (Op1->getValueType(0).is128BitVector() ||
       Op1->getValueType(0).is256BitVector())) {
    N1 = Op0;
    N2 = Op1;
  } else if (Op1->getOpcode() == ISD::BUILD_VECTOR &&
             (Op0->getValueType(0).is128BitVector() ||
              Op0->getValueType(0).is256BitVector())) {
    N1 = Op1;
    N2 = Op0;
  } else
    return SDValue();

  APInt Mask1, Mask2;
  if (!isVSplat(N1, Mask1))
    return SDValue();

  if (!N1->getValueType(0).isSimple())
    return SDValue();

  ConstantSDNode *C1;
  uint64_t Imm;
  unsigned ImmL;
  if (!(C1 = dyn_cast<ConstantSDNode>(N1.getOperand(0))) ||
      !isPowerOf2_64(C1->getZExtValue()))
    return SDValue();

  Imm = C1->getZExtValue();
  ImmL = Log2_64(Imm);
  MVT VT = N1->getSimpleValueType(0).SimpleTy;

  SDNode *Res;

  if (Subtarget.hasLASX() && N->getValueType(0).is256BitVector()) {
    if (VT == MVT::v32i8 && ImmL < 8)
      Res = DAG.getMachineNode(LoongArch::XVBITSETI_B, SDLoc(N), VT, N2,
                               DAG.getTargetConstant(ImmL, SDLoc(N), MVT::i32));
    else if (VT == MVT::v16i16 && ImmL < 16)
      Res = DAG.getMachineNode(LoongArch::XVBITSETI_H, SDLoc(N), VT, N2,
                               DAG.getTargetConstant(ImmL, SDLoc(N), MVT::i32));
    else if (VT == MVT::v8i32 && ImmL < 32)
      Res = DAG.getMachineNode(LoongArch::XVBITSETI_W, SDLoc(N), VT, N2,
                               DAG.getTargetConstant(ImmL, SDLoc(N), MVT::i32));
    else if (VT == MVT::v4i64 && ImmL < 64)
      Res = DAG.getMachineNode(LoongArch::XVBITSETI_D, SDLoc(N), VT, N2,
                               DAG.getTargetConstant(ImmL, SDLoc(N), MVT::i32));
    else
      return SDValue();
  } else if (N->getValueType(0).is128BitVector()) {
    if (VT == MVT::v16i8 && ImmL < 8)
      Res = DAG.getMachineNode(LoongArch::VBITSETI_B, SDLoc(N), VT, N2,
                               DAG.getTargetConstant(ImmL, SDLoc(N), MVT::i32));
    else if (VT == MVT::v8i16 && ImmL < 16)
      Res = DAG.getMachineNode(LoongArch::VBITSETI_H, SDLoc(N), VT, N2,
                               DAG.getTargetConstant(ImmL, SDLoc(N), MVT::i32));
    else if (VT == MVT::v4i32 && ImmL < 32)
      Res = DAG.getMachineNode(LoongArch::VBITSETI_W, SDLoc(N), VT, N2,
                               DAG.getTargetConstant(ImmL, SDLoc(N), MVT::i32));
    else if (VT == MVT::v2i64 && ImmL < 64)
      Res = DAG.getMachineNode(LoongArch::VBITSETI_D, SDLoc(N), VT, N2,
                               DAG.getTargetConstant(ImmL, SDLoc(N), MVT::i32));
    else
      return SDValue();

  } else
    return SDValue();

  return SDValue(Res, 0);
}

static SDValue performORCombine(SDNode *N, SelectionDAG &DAG,
                                TargetLowering::DAGCombinerInfo &DCI,
                                const LoongArchSubtarget &Subtarget) {

  SDValue Res;
  if (Subtarget.hasLSX() && (N->getValueType(0).is128BitVector() ||
                             N->getValueType(0).is256BitVector())) {
    SDValue Op0 = N->getOperand(0);
    SDValue Op1 = N->getOperand(1);

    if (Op0->getOpcode() == ISD::AND && Op1->getOpcode() == ISD::AND) {
      SDValue Op0Op0 = Op0->getOperand(0);
      SDValue Op0Op1 = Op0->getOperand(1);
      SDValue Op1Op0 = Op1->getOperand(0);
      SDValue Op1Op1 = Op1->getOperand(1);

      SDValue IfSet, IfClr, Cond;
      bool IsConstantMask = false;
      APInt Mask, InvMask;

      // If Op0Op0 is an appropriate mask, try to find it's inverse in either
      // Op1Op0, or Op1Op1. Keep track of the Cond, IfSet, and IfClr nodes,
      // while looking. IfClr will be set if we find a valid match.
      if (isVSplat(Op0Op0, Mask)) {
        Cond = Op0Op0;
        IfSet = Op0Op1;

        if (isVSplat(Op1Op0, InvMask) &&
            Mask.getBitWidth() == InvMask.getBitWidth() && Mask == ~InvMask)
          IfClr = Op1Op1;
        else if (isVSplat(Op1Op1, InvMask) &&
                 Mask.getBitWidth() == InvMask.getBitWidth() &&
                 Mask == ~InvMask)
          IfClr = Op1Op0;

        IsConstantMask = true;
      }

      // If IfClr is not yet set, and Op0Op1 is an appropriate mask, try the
      // same thing again using this mask. IfClr will be set if we find a valid
      // match.
      if (!IfClr.getNode() && isVSplat(Op0Op1, Mask)) {
        Cond = Op0Op1;
        IfSet = Op0Op0;

        if (isVSplat(Op1Op0, InvMask) &&
            Mask.getBitWidth() == InvMask.getBitWidth() && Mask == ~InvMask)
          IfClr = Op1Op1;
        else if (isVSplat(Op1Op1, InvMask) &&
                 Mask.getBitWidth() == InvMask.getBitWidth() &&
                 Mask == ~InvMask)
          IfClr = Op1Op0;

        IsConstantMask = true;
      }

      // If IfClr is not yet set, try looking for a non-constant match.
      // IfClr will be set if we find a valid match amongst the eight
      // possibilities.
      if (!IfClr.getNode()) {
        if (isBitwiseInverse(Op0Op0, Op1Op0)) {
          Cond = Op1Op0;
          IfSet = Op1Op1;
          IfClr = Op0Op1;
        } else if (isBitwiseInverse(Op0Op1, Op1Op0)) {
          Cond = Op1Op0;
          IfSet = Op1Op1;
          IfClr = Op0Op0;
        } else if (isBitwiseInverse(Op0Op0, Op1Op1)) {
          Cond = Op1Op1;
          IfSet = Op1Op0;
          IfClr = Op0Op1;
        } else if (isBitwiseInverse(Op0Op1, Op1Op1)) {
          Cond = Op1Op1;
          IfSet = Op1Op0;
          IfClr = Op0Op0;
        } else if (isBitwiseInverse(Op1Op0, Op0Op0)) {
          Cond = Op0Op0;
          IfSet = Op0Op1;
          IfClr = Op1Op1;
        } else if (isBitwiseInverse(Op1Op1, Op0Op0)) {
          Cond = Op0Op0;
          IfSet = Op0Op1;
          IfClr = Op1Op0;
        } else if (isBitwiseInverse(Op1Op0, Op0Op1)) {
          Cond = Op0Op1;
          IfSet = Op0Op0;
          IfClr = Op1Op1;
        } else if (isBitwiseInverse(Op1Op1, Op0Op1)) {
          Cond = Op0Op1;
          IfSet = Op0Op0;
          IfClr = Op1Op0;
        }
      }

      // At this point, IfClr will be set if we have a valid match.
      if (IfClr.getNode()) {
        assert(Cond.getNode() && IfSet.getNode());

        // Fold degenerate cases.
        if (IsConstantMask) {
          if (Mask.isAllOnesValue())
            return IfSet;
          else if (Mask == 0)
            return IfClr;
        }

        // Transform the DAG into an equivalent VSELECT.
        return DAG.getNode(ISD::VSELECT, SDLoc(N), N->getValueType(0), Cond,
                           IfSet, IfClr);
      }
    }

    if (Res = performSet(N, DAG, DCI, Subtarget))
      return Res;
  }

  // Pattern match BSTRINS.
  //  $dst = or (and $src1 , mask0), (and (shl $src, lsb), mask1),
  //  where mask1 = (2**size - 1) << lsb, mask0 = ~mask1
  //  => bstrins $dst, $src, lsb+size-1, lsb, $src1
  if (DCI.isBeforeLegalizeOps())
    return SDValue();

  SDValue And0 = N->getOperand(0), And1 = N->getOperand(1);
  uint64_t SMLsb0, SMSize0, SMLsb1, SMSize1;
  ConstantSDNode *CN, *CN1;

  // See if Op's first operand matches (and $src1 , mask0).
  if (And0.getOpcode() != ISD::AND)
    return SDValue();

  if (!(CN = dyn_cast<ConstantSDNode>(And0.getOperand(1))) ||
      !isShiftedMask(~CN->getSExtValue(), SMLsb0, SMSize0))
    return SDValue();

  // See if Op's second operand matches (and (shl $src, lsb), mask1).
  if (And1.getOpcode() == ISD::AND &&
      And1.getOperand(0).getOpcode() == ISD::SHL) {

    if (!(CN = dyn_cast<ConstantSDNode>(And1.getOperand(1))) ||
        !isShiftedMask(CN->getZExtValue(), SMLsb1, SMSize1))
      return SDValue();

    // The shift masks must have the same least significant bit and size.
    if (SMLsb0 != SMLsb1 || SMSize0 != SMSize1)
      return SDValue();

    SDValue Shl = And1.getOperand(0);

    if (!(CN = dyn_cast<ConstantSDNode>(Shl.getOperand(1))))
      return SDValue();

    unsigned Shamt = CN->getZExtValue();

    // Return if the shift amount and the first bit position of mask are not the
    // same.
    EVT ValTy = N->getValueType(0);
    if ((Shamt != SMLsb0) || (SMLsb0 + SMSize0 > ValTy.getSizeInBits()))
      return SDValue();

    SDLoc DL(N);
    return DAG.getNode(LoongArchISD::BSTRINS, DL, ValTy, Shl.getOperand(0),
                       DAG.getConstant((SMLsb0 + SMSize0 - 1), DL, MVT::i32),
                       DAG.getConstant(SMLsb0, DL, MVT::i32),
                       And0.getOperand(0));
  } else {
    // Pattern match BSTRINS.
    //  $dst = or (and $src, mask0), mask1
    //  where mask0 = ((1 << SMSize0) -1) << SMLsb0
    //  => bstrins $dst, $src, SMLsb0+SMSize0-1, SMLsb0
    if (~CN->getSExtValue() == ((((int64_t)1 << SMSize0) - 1) << SMLsb0) &&
        (SMSize0 + SMLsb0 <= 64)) {
      // Check if AND instruction has constant as argument
      bool isConstCase = And1.getOpcode() != ISD::AND;
      if (And1.getOpcode() == ISD::AND) {
        if (!(CN1 = dyn_cast<ConstantSDNode>(And1->getOperand(1))))
          return SDValue();
      } else {
        if (!(CN1 = dyn_cast<ConstantSDNode>(N->getOperand(1))))
          return SDValue();
      }
      // Don't generate BSTRINS if constant OR operand doesn't fit into bits
      // cleared by constant AND operand.
      if (CN->getSExtValue() & CN1->getSExtValue())
        return SDValue();

      SDLoc DL(N);
      EVT ValTy = N->getOperand(0)->getValueType(0);
      SDValue Const1;
      SDValue SrlX;
      if (!isConstCase) {
        Const1 = DAG.getConstant(SMLsb0, DL, MVT::i32);
        SrlX = DAG.getNode(ISD::SRL, DL, And1->getValueType(0), And1, Const1);
      }
      return DAG.getNode(
          LoongArchISD::BSTRINS, DL, N->getValueType(0),
          isConstCase
              ? DAG.getConstant(CN1->getSExtValue() >> SMLsb0, DL, ValTy)
              : SrlX,
          DAG.getConstant(ValTy.getSizeInBits() / 8 < 8 ? (SMLsb0 + (SMSize0 & 31) - 1)
                                                        : (SMLsb0 + SMSize0 - 1),
                          DL, MVT::i32),
          DAG.getConstant(SMLsb0, DL, MVT::i32),
          And0->getOperand(0));

    }
    return SDValue();
  }
}

static bool
shouldTransformMulToShiftsAddsSubs(APInt C, EVT VT,
                                   SelectionDAG &DAG,
                                   const LoongArchSubtarget &Subtarget) {
  // Estimate the number of operations the below transform will turn a
  // constant multiply into. The number is approximately equal to the minimal
  // number of powers of two that constant can be broken down to by adding
  // or subtracting them.
  //
  // If we have taken more than 10[1] / 8[2] steps to attempt the
  // optimization for a native sized value, it is more than likely that this
  // optimization will make things worse.
  //
  // [1] LA64 requires 4 instructions at most to materialize any constant,
  //     multiplication requires at least 4 cycles, but another cycle (or two)
  //     to retrieve the result from corresponding registers.
  //
  // [2] LA32 requires 2 instructions at most to materialize any constant,
  //     multiplication requires at least 4 cycles, but another cycle (or two)
  //     to retrieve the result from corresponding registers.
  //
  // TODO:
  // - MaxSteps needs to consider the `VT` of the constant for the current
  //   target.
  // - Consider to perform this optimization after type legalization.
  //   That allows to remove a workaround for types not supported natively.
  // - Take in account `-Os, -Oz` flags because this optimization
  //   increases code size.
  unsigned MaxSteps = Subtarget.isABI_LP32() ? 8 : 10;

  SmallVector<APInt, 16> WorkStack(1, C);
  unsigned Steps = 0;
  unsigned BitWidth = C.getBitWidth();

  while (!WorkStack.empty()) {
    APInt Val = WorkStack.pop_back_val();

    if (Val == 0 || Val == 1)
      continue;

    if (Steps >= MaxSteps)
      return false;

    if (Val.isPowerOf2()) {
      ++Steps;
      continue;
    }

    APInt Floor = APInt(BitWidth, 1) << Val.logBase2();
    APInt Ceil = Val.isNegative() ? APInt(BitWidth, 0)
                                  : APInt(BitWidth, 1) << C.ceilLogBase2();

    if ((Val - Floor).ule(Ceil - Val)) {
      WorkStack.push_back(Floor);
      WorkStack.push_back(Val - Floor);
    } else {
      WorkStack.push_back(Ceil);
      WorkStack.push_back(Ceil - Val);
    }

    ++Steps;
  }

  // If the value being multiplied is not supported natively, we have to pay
  // an additional legalization cost, conservatively assume an increase in the
  // cost of 3 instructions per step. This values for this heuristic were
  // determined experimentally.
  unsigned RegisterSize = DAG.getTargetLoweringInfo()
                              .getRegisterType(*DAG.getContext(), VT)
                              .getSizeInBits();
  Steps *= (VT.getSizeInBits() != RegisterSize) * 3;
  if (Steps > 27)
    return false;

  return true;
}

static SDValue genConstMult(SDValue X, APInt C, const SDLoc &DL, EVT VT,
                            EVT ShiftTy, SelectionDAG &DAG) {
  // Return 0.
  if (C == 0)
    return DAG.getConstant(0, DL, VT);

  // Return x.
  if (C == 1)
    return X;

  // If c is power of 2, return (shl x, log2(c)).
  if (C.isPowerOf2())
    return DAG.getNode(ISD::SHL, DL, VT, X,
                       DAG.getConstant(C.logBase2(), DL, ShiftTy));

  unsigned BitWidth = C.getBitWidth();
  APInt Floor = APInt(BitWidth, 1) << C.logBase2();
  APInt Ceil = C.isNegative() ? APInt(BitWidth, 0) :
                                APInt(BitWidth, 1) << C.ceilLogBase2();

  // If |c - floor_c| <= |c - ceil_c|,
  // where floor_c = pow(2, floor(log2(c))) and ceil_c = pow(2, ceil(log2(c))),
  // return (add constMult(x, floor_c), constMult(x, c - floor_c)).
  if ((C - Floor).ule(Ceil - C)) {
    SDValue Op0 = genConstMult(X, Floor, DL, VT, ShiftTy, DAG);
    SDValue Op1 = genConstMult(X, C - Floor, DL, VT, ShiftTy, DAG);
    return DAG.getNode(ISD::ADD, DL, VT, Op0, Op1);
  }

  // If |c - floor_c| > |c - ceil_c|,
  // return (sub constMult(x, ceil_c), constMult(x, ceil_c - c)).
  SDValue Op0 = genConstMult(X, Ceil, DL, VT, ShiftTy, DAG);
  SDValue Op1 = genConstMult(X, Ceil - C, DL, VT, ShiftTy, DAG);
  return DAG.getNode(ISD::SUB, DL, VT, Op0, Op1);
}

static SDValue performLogicCombine(SDNode *N, SelectionDAG &DAG,
                                   const LoongArchSubtarget &Subtarget) {

  SDLoc DL(N);
  SDValue N0 = N->getOperand(0);
  SDValue N1 = N->getOperand(1);

  if (!(N0->getOpcode() == ISD::TRUNCATE && N1->getOpcode() == ISD::TRUNCATE))
    return SDValue();

  if (!(N->getValueType(0).isSimple() && N0->getValueType(0).isSimple() &&
        N1->getValueType(0).isSimple() &&
        N0->getOperand(0)->getValueType(0).isSimple() &&
        N1->getOperand(0)->getValueType(0).isSimple()))
    return SDValue();

  if (!(N->getValueType(0).isSimple() && N0->getValueType(0).isSimple() &&
        N1->getValueType(0).isSimple() &&
        N0->getOperand(0)->getValueType(0).isSimple() &&
        N1->getOperand(0)->getValueType(0).isSimple()))
    return SDValue();

  if (!(N->getSimpleValueType(0).SimpleTy == MVT::i32 &&
        N0->getSimpleValueType(0).SimpleTy == MVT::i32 &&
        N1->getSimpleValueType(0).SimpleTy == MVT::i32))
    return SDValue();

  if (!(N0->getOperand(0)->getSimpleValueType(0).SimpleTy == MVT::i64 &&
        N1->getOperand(0)->getSimpleValueType(0).SimpleTy == MVT::i64))
    return SDValue();

  SDValue SubReg = DAG.getTargetConstant(LoongArch::sub_32, DL, MVT::i32);
  SDValue Val0 = SDValue(DAG.getMachineNode(TargetOpcode::EXTRACT_SUBREG, DL,
                                            N0->getValueType(0),
                                            N0->getOperand(0), SubReg),
                         0);
  SDValue Val1 = SDValue(DAG.getMachineNode(TargetOpcode::EXTRACT_SUBREG, DL,
                                            N1->getValueType(0),
                                            N1->getOperand(0), SubReg),
                         0);

  return DAG.getNode(N->getOpcode(), DL, N0->getValueType(0), Val0, Val1);
}

static SDValue performMULCombine(SDNode *N, SelectionDAG &DAG,
                                 const TargetLowering::DAGCombinerInfo &DCI,
                                 const LoongArchTargetLowering *TL,
                                 const LoongArchSubtarget &Subtarget) {
  EVT VT = N->getValueType(0);

  SDValue Res;
  if ((Res = performLogicCombine(N, DAG, Subtarget)))
    return Res;

  if (ConstantSDNode *C = dyn_cast<ConstantSDNode>(N->getOperand(1)))
    if (!VT.isVector() && shouldTransformMulToShiftsAddsSubs(
                              C->getAPIntValue(), VT, DAG, Subtarget))
      return genConstMult(N->getOperand(0), C->getAPIntValue(), SDLoc(N), VT,
                          TL->getScalarShiftAmountTy(DAG.getDataLayout(), VT),
                          DAG);

  return SDValue(N, 0);
}

// Fold sign-extensions into LoongArchISD::VEXTRACT_[SZ]EXT_ELT for LSX.
//
// Performs the following transformations:
// - Changes LoongArchISD::VEXTRACT_[SZ]EXT_ELT to sign extension if its
//   sign/zero-extension is completely overwritten by the new one performed by
//   the ISD::SRA and ISD::SHL nodes.
// - Removes redundant sign extensions performed by an ISD::SRA and ISD::SHL
//   sequence.
static SDValue performSRACombine(SDNode *N, SelectionDAG &DAG,
                                 TargetLowering::DAGCombinerInfo &DCI,
                                 const LoongArchSubtarget &Subtarget) {

  SDValue Res;
  if ((Res = performLogicCombine(N, DAG, Subtarget)))
    return Res;

  if (Subtarget.hasLSX() || Subtarget.hasLASX()) {
    SDValue Op0 = N->getOperand(0);
    SDValue Op1 = N->getOperand(1);

    // (sra (shl (LoongArchVExtract[SZ]Ext $a, $b, $c), imm:$d), imm:$d)
    // where $d + sizeof($c) == 32
    // or    $d + sizeof($c) <= 32 and SExt
    // -> (LoongArchVExtractSExt $a, $b, $c)
    if (Op0->getOpcode() == ISD::SHL && Op1 == Op0->getOperand(1)) {
      SDValue Op0Op0 = Op0->getOperand(0);
      ConstantSDNode *ShAmount = dyn_cast<ConstantSDNode>(Op1);

      if (!ShAmount)
        return SDValue();

      if (Op0Op0->getOpcode() != LoongArchISD::VEXTRACT_SEXT_ELT &&
          Op0Op0->getOpcode() != LoongArchISD::VEXTRACT_ZEXT_ELT)
        return SDValue();

      EVT ExtendTy = cast<VTSDNode>(Op0Op0->getOperand(2))->getVT();
      unsigned TotalBits = ShAmount->getZExtValue() + ExtendTy.getSizeInBits();

      if (TotalBits == 32 ||
          (Op0Op0->getOpcode() == LoongArchISD::VEXTRACT_SEXT_ELT &&
           TotalBits <= 32)) {
        SDValue Ops[] = {Op0Op0->getOperand(0), Op0Op0->getOperand(1),
                         Op0Op0->getOperand(2)};
        return DAG.getNode(LoongArchISD::VEXTRACT_SEXT_ELT, SDLoc(Op0Op0),
                           Op0Op0->getVTList(),
                           makeArrayRef(Ops, Op0Op0->getNumOperands()));
      }
    }
  }

  return SDValue();
}

// combine vsub/vslt/vbitsel.v to vabsd
static SDValue performVSELECTCombine(SDNode *N, SelectionDAG &DAG) {
  assert((N->getOpcode() == ISD::VSELECT) && "Need ISD::VSELECT");

  SDLoc dl(N);
  SDValue Cond = N->getOperand(0);
  SDValue TrueOpnd = N->getOperand(1);
  SDValue FalseOpnd = N->getOperand(2);

  if (Cond.getOpcode() != ISD::SETCC || TrueOpnd.getOpcode() != ISD::SUB ||
      FalseOpnd.getOpcode() != ISD::SUB)
    return SDValue();

  if (!(Cond.hasOneUse() || TrueOpnd.hasOneUse() || FalseOpnd.hasOneUse()))
    return SDValue();

  ISD::CondCode CC = cast<CondCodeSDNode>(Cond.getOperand(2))->get();

  switch (CC) {
  default:
    return SDValue();
  case ISD::SETUGT:
  case ISD::SETUGE:
  case ISD::SETGT:
  case ISD::SETGE:
    break;
  case ISD::SETULT:
  case ISD::SETULE:
  case ISD::SETLT:
  case ISD::SETLE:
    std::swap(TrueOpnd, FalseOpnd);
    break;
  }

  SDValue Op1 = Cond.getOperand(0);
  SDValue Op2 = Cond.getOperand(1);

  if (TrueOpnd.getOperand(0) == Op1 && TrueOpnd.getOperand(1) == Op2 &&
      FalseOpnd.getOperand(0) == Op2 && FalseOpnd.getOperand(1) == Op1) {
    if (ISD::isSignedIntSetCC(CC)) {
      return DAG.getNode(LoongArchISD::VABSD, dl,
                         N->getOperand(1).getValueType(), Op1, Op2,
                         DAG.getTargetConstant(0, dl, MVT::i32));
    } else {
      return DAG.getNode(LoongArchISD::UVABSD, dl,
                         N->getOperand(1).getValueType(), Op1, Op2,
                         DAG.getTargetConstant(0, dl, MVT::i32));
    }
  }
  return SDValue();
}

static SDValue performXORCombine(SDNode *N, SelectionDAG &DAG,
                                 const LoongArchSubtarget &Subtarget) {

  EVT Ty = N->getValueType(0);

  if ((Subtarget.hasLSX() && Ty.is128BitVector() && Ty.isInteger()) ||
      (Subtarget.hasLASX() && Ty.is256BitVector() && Ty.isInteger())) {
    // Try the following combines:
    //   (xor (or $a, $b), (build_vector allones))
    //   (xor (or $a, $b), (bitcast (build_vector allones)))
    SDValue Op0 = N->getOperand(0);
    SDValue Op1 = N->getOperand(1);
    SDValue NotOp;

    if (ISD::isBuildVectorAllOnes(Op0.getNode()))
      NotOp = Op1;
    else if (ISD::isBuildVectorAllOnes(Op1.getNode()))
      NotOp = Op0;
    else
      return SDValue();

    if (NotOp->getOpcode() == ISD::OR)
      return DAG.getNode(LoongArchISD::VNOR, SDLoc(N), Ty, NotOp->getOperand(0),
                         NotOp->getOperand(1));
  }

  return SDValue();
}

// When using a 256-bit vector is less expensive than using a 128-bit vector,
// use this function to convert a 128-bit vector to a 256-bit vector.
static SDValue
performCONCAT_VECTORSCombine(SDNode *N, SelectionDAG &DAG,
                             TargetLowering::DAGCombinerInfo &DCI,
                             const LoongArchSubtarget &Subtarget) {

  assert((N->getOpcode() == ISD::CONCAT_VECTORS) && "Need ISD::CONCAT_VECTORS");
  if (DCI.isAfterLegalizeDAG())
    return SDValue();

  SDLoc DL(N);
  SDValue Top0 = N->getOperand(0);
  SDValue Top1 = N->getOperand(1);

  // Check for cheaper optimizations.
  if (!((Top0->getOpcode() == ISD::SIGN_EXTEND) &&
        (Top1->getOpcode() == ISD::SIGN_EXTEND)))
    return SDValue();
  if (!((Top0->getOperand(0)->getOpcode() == ISD::ADD) &&
        (Top1->getOperand(0)->getOpcode() == ISD::ADD)))
    return SDValue();

  SDValue Op_a0 = Top0->getOperand(0);
  SDValue Op_a1 = Top1->getOperand(0);
  for (int i = 0; i < 2; i++) {
    if (!((Op_a0->getOperand(i)->getOpcode() == ISD::BUILD_VECTOR) &&
          (Op_a1->getOperand(i)->getOpcode() == ISD::BUILD_VECTOR)))
      return SDValue();
  }

  SDValue Ops_b[] = {Op_a0->getOperand(0), Op_a0->getOperand(1),
                     Op_a1->getOperand(0), Op_a1->getOperand(1)};
  for (int i = 0; i < 4; i++) {
    if (Ops_b[i]->getNumOperands() != 2)
      return SDValue();
  }

  // Currently only a single case is handled, and more optimization scenarios
  // will be added in the future.
  SDValue Ops_e[] = {Ops_b[0]->getOperand(0), Ops_b[0]->getOperand(1),
                     Ops_b[2]->getOperand(0), Ops_b[2]->getOperand(1),
                     Ops_b[1]->getOperand(0), Ops_b[1]->getOperand(1),
                     Ops_b[3]->getOperand(0), Ops_b[3]->getOperand(1)};
  for (int i = 0; i < 8; i++) {
    if (dyn_cast<ConstantSDNode>(Ops_e[i]))
      return SDValue();
    if (i < 4) {
      if (cast<ConstantSDNode>(Ops_e[i]->getOperand(1))->getSExtValue() !=
          (2 * i))
        return SDValue();
    } else {
      if (cast<ConstantSDNode>(Ops_e[i]->getOperand(1))->getSExtValue() !=
          (2 * i - 7))
        return SDValue();
    }
  }

  for (int i = 0; i < 5; i = i + 4) {
    if (!((Ops_e[i]->getOperand(0) == Ops_e[i + 1]->getOperand(0)) &&
          (Ops_e[i + 1]->getOperand(0) == Ops_e[i + 2]->getOperand(0)) &&
          (Ops_e[i + 2]->getOperand(0) == Ops_e[i + 3]->getOperand(0))))
      return SDValue();
  }
  return SDValue(DAG.getMachineNode(LoongArch::XVHADDW_D_W, DL, MVT::v4i64,
                                    Ops_e[6]->getOperand(0),
                                    Ops_e[0]->getOperand(0)),
                 0);
}

static SDValue performParity(SDNode *N, SelectionDAG &DAG,
                             TargetLowering::DAGCombinerInfo &DCI,
                             const LoongArchSubtarget &Subtarget) {

  SDLoc DL(N);
  SDValue T = N->getOperand(0);
  if (!(N->getValueType(0).isSimple() && T->getValueType(0).isSimple()))
    return SDValue();

  if (DCI.isAfterLegalizeDAG())
    return SDValue();

  SDValue Ops[4];
  bool pos_e = false;
  bool pos_o = false;

  for (int i = 0; i < 4; i++) {
    Ops[i] = T->getOperand(i);
    if (!Ops[i]->getValueType(0).isSimple())
      return SDValue();
    if (Ops[i]->getOpcode() != ISD::EXTRACT_VECTOR_ELT)
      return SDValue();

    if (!dyn_cast<ConstantSDNode>(Ops[i]->getOperand(1)))
      return SDValue();

    if (cast<ConstantSDNode>(Ops[i]->getOperand(1))->getSExtValue() ==
        (2 * i)) {
      pos_e = true;
    } else if (cast<ConstantSDNode>(Ops[i]->getOperand(1))->getSExtValue() ==
               (2 * i + 1)) {
      pos_o = true;
    } else
      return SDValue();
  }

  if (!(N->getSimpleValueType(0).SimpleTy == MVT::v4i64 &&
        T->getSimpleValueType(0).SimpleTy == MVT::v4i32))
    return SDValue();

  for (int j = 0; j < 3; j++) {
    if (Ops[j]->getOperand(0) != Ops[j + 1]->getOperand(0))
      return SDValue();
  }
  if (pos_e) {
    if (N->getOpcode() == ISD::SIGN_EXTEND) {
      if (Ops[0]->getOperand(0)->getOpcode() == ISD::ADD)
        return SDValue(DAG.getMachineNode(LoongArch::XVADDWEV_D_W, DL,
                                          MVT::v4i64,
                                          Ops[0]->getOperand(0)->getOperand(1),
                                          Ops[0]->getOperand(0)->getOperand(0)),
                       0);
      else if (Ops[0]->getOperand(0)->getOpcode() == ISD::SUB)
        return SDValue(DAG.getMachineNode(LoongArch::XVSUBWEV_D_W, DL,
                                          MVT::v4i64,
                                          Ops[0]->getOperand(0)->getOperand(0),
                                          Ops[0]->getOperand(0)->getOperand(1)),
                       0);
    } else if (N->getOpcode() == ISD::ZERO_EXTEND) {
      if (Ops[0]->getOperand(0)->getOpcode() == ISD::ADD)
        return SDValue(DAG.getMachineNode(LoongArch::XVADDWEV_D_WU, DL,
                                          MVT::v4i64,
                                          Ops[0]->getOperand(0)->getOperand(1),
                                          Ops[0]->getOperand(0)->getOperand(0)),
                       0);
      else if (Ops[0]->getOperand(0)->getOpcode() == ISD::SUB)
        return SDValue(DAG.getMachineNode(LoongArch::XVSUBWEV_D_WU, DL,
                                          MVT::v4i64,
                                          Ops[0]->getOperand(0)->getOperand(0),
                                          Ops[0]->getOperand(0)->getOperand(1)),
                       0);
    }
  } else if (pos_o) {
    if (N->getOpcode() == ISD::SIGN_EXTEND) {
      if (Ops[0]->getOperand(0)->getOpcode() == ISD::ADD)
        return SDValue(DAG.getMachineNode(LoongArch::XVADDWOD_D_W, DL,
                                          MVT::v4i64,
                                          Ops[0]->getOperand(0)->getOperand(1),
                                          Ops[0]->getOperand(0)->getOperand(0)),
                       0);
      else if (Ops[0]->getOperand(0)->getOpcode() == ISD::SUB)
        return SDValue(DAG.getMachineNode(LoongArch::XVSUBWOD_D_W, DL,
                                          MVT::v4i64,
                                          Ops[0]->getOperand(0)->getOperand(0),
                                          Ops[0]->getOperand(0)->getOperand(1)),
                       0);
    } else if (N->getOpcode() == ISD::ZERO_EXTEND) {
      if (Ops[0]->getOperand(0)->getOpcode() == ISD::ADD)
        return SDValue(DAG.getMachineNode(LoongArch::XVADDWOD_D_WU, DL,
                                          MVT::v4i64,
                                          Ops[0]->getOperand(0)->getOperand(1),
                                          Ops[0]->getOperand(0)->getOperand(0)),
                       0);
      else if (Ops[0]->getOperand(0)->getOpcode() == ISD::SUB)
        return SDValue(DAG.getMachineNode(LoongArch::XVSUBWOD_D_WU, DL,
                                          MVT::v4i64,
                                          Ops[0]->getOperand(0)->getOperand(0),
                                          Ops[0]->getOperand(0)->getOperand(1)),
                       0);
    }
  } else
    return SDValue();

  return SDValue();
}

// Optimize zero extension and sign extension of data
static SDValue performExtend(SDNode *N, SelectionDAG &DAG,
                             TargetLowering::DAGCombinerInfo &DCI,
                             const LoongArchSubtarget &Subtarget) {

  if (!Subtarget.hasLASX())
    return SDValue();

  SDLoc DL(N);
  SDValue T = N->getOperand(0);

  if (T->getOpcode() == ISD::BUILD_VECTOR)
    return performParity(N, DAG, DCI, Subtarget);

  if (T->getOpcode() != ISD::ADD && T->getOpcode() != ISD::SUB)
    return SDValue();

  SDValue T0 = T->getOperand(0);
  SDValue T1 = T->getOperand(1);

  if (!(T0->getOpcode() == ISD::BUILD_VECTOR &&
        T1->getOpcode() == ISD::BUILD_VECTOR))
    return SDValue();

  if (DCI.isAfterLegalizeDAG())
    return SDValue();

  if (!(T->getValueType(0).isSimple() && T0->getValueType(0).isSimple() &&
        T1->getValueType(0).isSimple() && N->getValueType(0).isSimple()))
    return SDValue();

  if (!(N->getSimpleValueType(0).SimpleTy == MVT::v4i64 &&
        T->getSimpleValueType(0).SimpleTy == MVT::v4i32 &&
        T0->getSimpleValueType(0).SimpleTy == MVT::v4i32 &&
        T1->getSimpleValueType(0).SimpleTy == MVT::v4i32))
    return SDValue();

  SDValue Opse0[4];
  SDValue Opse1[4];

  for (int i = 0; i < 4; i++) {
    if (T->getOpcode() == ISD::ADD) {
      Opse0[i] = T1->getOperand(i);
      Opse1[i] = T0->getOperand(i);
    } else if (T->getOpcode() == ISD::SUB) {
      Opse0[i] = T0->getOperand(i);
      Opse1[i] = T1->getOperand(i);
    }

    if (Opse0[i]->getOpcode() != ISD::EXTRACT_VECTOR_ELT ||
        Opse1[i]->getOpcode() != ISD::EXTRACT_VECTOR_ELT)
      return SDValue();

    if (!(dyn_cast<ConstantSDNode>(Opse0[i]->getOperand(1)) &&
          dyn_cast<ConstantSDNode>(Opse1[i]->getOperand(1))))
      return SDValue();

    if (cast<ConstantSDNode>(Opse0[i]->getOperand(1))->getSExtValue() !=
            (2 * i + 1) ||
        cast<ConstantSDNode>(Opse1[i]->getOperand(1))->getSExtValue() !=
            (2 * i))
      return SDValue();

    if (i > 0 && (Opse0[i]->getOperand(0) != Opse0[i - 1]->getOperand(0) ||
                  Opse1[i]->getOperand(0) != Opse1[i - 1]->getOperand(0)))
      return SDValue();
  }

  if (N->getOpcode() == ISD::SIGN_EXTEND) {
    if (T->getOpcode() == ISD::ADD)
      return SDValue(DAG.getMachineNode(LoongArch::XVHADDW_D_W, DL, MVT::v4i64,
                                        Opse0[0]->getOperand(0),
                                        Opse1[0]->getOperand(0)),
                     0);
    else if (T->getOpcode() == ISD::SUB)
      return SDValue(DAG.getMachineNode(LoongArch::XVHSUBW_D_W, DL, MVT::v4i64,
                                        Opse0[0]->getOperand(0),
                                        Opse1[0]->getOperand(0)),
                     0);
  } else if (N->getOpcode() == ISD::ZERO_EXTEND) {
    if (T->getOpcode() == ISD::ADD)
      return SDValue(DAG.getMachineNode(LoongArch::XVHADDW_DU_WU, DL,
                                        MVT::v4i64, Opse0[0]->getOperand(0),
                                        Opse1[0]->getOperand(0)),
                     0);
    else if (T->getOpcode() == ISD::SUB)
      return SDValue(DAG.getMachineNode(LoongArch::XVHSUBW_DU_WU, DL,
                                        MVT::v4i64, Opse0[0]->getOperand(0),
                                        Opse1[0]->getOperand(0)),
                     0);
  }

  return SDValue();
}

static SDValue performSIGN_EXTENDCombine(SDNode *N, SelectionDAG &DAG,
                                         TargetLowering::DAGCombinerInfo &DCI,
                                         const LoongArchSubtarget &Subtarget) {

  assert((N->getOpcode() == ISD::SIGN_EXTEND) && "Need ISD::SIGN_EXTEND");

  SDLoc DL(N);
  SDValue Top = N->getOperand(0);

  SDValue Res;
  if (Res = performExtend(N, DAG, DCI, Subtarget))
    return Res;

  if (!(Top->getOpcode() == ISD::CopyFromReg))
    return SDValue();

  if ((Top->getOperand(0)->getOpcode() == ISD::EntryToken) &&
      (N->getValueType(0) == MVT::i64)) {

    SDValue SubReg = DAG.getTargetConstant(LoongArch::sub_32, DL, MVT::i32);
    SDNode *Res = DAG.getMachineNode(TargetOpcode::IMPLICIT_DEF, DL, MVT::i64);

    Res = DAG.getMachineNode(TargetOpcode::INSERT_SUBREG, DL, MVT::i64,
                             SDValue(Res, 0), Top, SubReg);

    return SDValue(Res, 0);
  }

  return SDValue();
}

static SDValue performZERO_EXTENDCombine(SDNode *N, SelectionDAG &DAG,
                                         TargetLowering::DAGCombinerInfo &DCI,
                                         const LoongArchSubtarget &Subtarget) {

  assert((N->getOpcode() == ISD::ZERO_EXTEND) && "Need ISD::ZERO_EXTEND");

  SDLoc DL(N);

  SDValue Res;
  if (Res = performExtend(N, DAG, DCI, Subtarget))
    return Res;

  return SDValue();
}

SDValue  LoongArchTargetLowering::
PerformDAGCombine(SDNode *N, DAGCombinerInfo &DCI) const {
  SelectionDAG &DAG = DCI.DAG;
  SDValue Val;

  switch (N->getOpcode()) {
  default: break;
  case ISD::AND:
    return performANDCombine(N, DAG, DCI, Subtarget);
  case ISD::OR:
    return performORCombine(N, DAG, DCI, Subtarget);
  case ISD::XOR:
    return performXORCombine(N, DAG, Subtarget);
  case ISD::MUL:
    return performMULCombine(N, DAG, DCI, this, Subtarget);
  case ISD::SRA:
    return performSRACombine(N, DAG, DCI, Subtarget);
  case ISD::SELECT:
    return performSELECTCombine(N, DAG, DCI, Subtarget);
  case ISD::VSELECT:
    return performVSELECTCombine(N, DAG);
  case ISD::CONCAT_VECTORS:
    return performCONCAT_VECTORSCombine(N, DAG, DCI, Subtarget);
  case ISD::SIGN_EXTEND:
    return performSIGN_EXTENDCombine(N, DAG, DCI, Subtarget);
  case ISD::ZERO_EXTEND:
    return performZERO_EXTENDCombine(N, DAG, DCI, Subtarget);
  case ISD::ADD:
  case ISD::SUB:
  case ISD::SHL:
  case ISD::SRL:
    return performLogicCombine(N, DAG, Subtarget);
  }
  return SDValue();
}

static SDValue lowerLSXSplatZExt(SDValue Op, unsigned OpNr, SelectionDAG &DAG) {
  EVT ResVecTy = Op->getValueType(0);
  EVT ViaVecTy = ResVecTy;
  SDLoc DL(Op);

  // When ResVecTy == MVT::v2i64, LaneA is the upper 32 bits of the lane and
  // LaneB is the lower 32-bits. Otherwise LaneA and LaneB are alternating
  // lanes.
  SDValue LaneA = Op->getOperand(OpNr);
  SDValue LaneB;

  if (ResVecTy == MVT::v2i64) {
    // In case of the index being passed as an immediate value, set the upper
    // lane to 0 so that the splati.d instruction can be matched.
    if (isa<ConstantSDNode>(LaneA))
      LaneB = DAG.getConstant(0, DL, MVT::i32);
    // Having the index passed in a register, set the upper lane to the same
    // value as the lower - this results in the BUILD_VECTOR node not being
    // expanded through stack. This way we are able to pattern match the set of
    // nodes created here to splat.d.
    else
      LaneB = LaneA;
    ViaVecTy = MVT::v4i32;
  } else
    LaneB = LaneA;

  SDValue Ops[16] = {LaneA, LaneB, LaneA, LaneB, LaneA, LaneB, LaneA, LaneB,
                     LaneA, LaneB, LaneA, LaneB, LaneA, LaneB, LaneA, LaneB};

  SDValue Result = DAG.getBuildVector(
      ViaVecTy, DL, makeArrayRef(Ops, ViaVecTy.getVectorNumElements()));

  if (ViaVecTy != ResVecTy) {
    SDValue One = DAG.getConstant(1, DL, ViaVecTy);
    Result = DAG.getNode(ISD::BITCAST, DL, ResVecTy,
                         DAG.getNode(ISD::AND, DL, ViaVecTy, Result, One));
  }

  return Result;
}

static SDValue lowerLSXSplatImm(SDValue Op, unsigned ImmOp, SelectionDAG &DAG,
                                bool IsSigned = false) {
  return DAG.getConstant(
      APInt(Op->getValueType(0).getScalarType().getSizeInBits(),
            Op->getConstantOperandVal(ImmOp), IsSigned),
      SDLoc(Op), Op->getValueType(0));
}

static SDValue getBuildVectorSplat(EVT VecTy, SDValue SplatValue,
                                   SelectionDAG &DAG) {
  EVT ViaVecTy = VecTy;
  SDValue SplatValueA = SplatValue;
  SDValue SplatValueB = SplatValue;
  SDLoc DL(SplatValue);

  if (VecTy == MVT::v2i64) {
    // v2i64 BUILD_VECTOR must be performed via v4i32 so split into i32's.
    ViaVecTy = MVT::v4i32;

    SplatValueA = DAG.getNode(ISD::TRUNCATE, DL, MVT::i32, SplatValue);
    SplatValueB = DAG.getNode(ISD::SRL, DL, MVT::i64, SplatValue,
                              DAG.getConstant(32, DL, MVT::i32));
    SplatValueB = DAG.getNode(ISD::TRUNCATE, DL, MVT::i32, SplatValueB);
  }

  SDValue Ops[32] = {SplatValueA, SplatValueB, SplatValueA, SplatValueB,
                     SplatValueA, SplatValueB, SplatValueA, SplatValueB,
                     SplatValueA, SplatValueB, SplatValueA, SplatValueB,
                     SplatValueA, SplatValueB, SplatValueA, SplatValueB,
                     SplatValueA, SplatValueB, SplatValueA, SplatValueB,
                     SplatValueA, SplatValueB, SplatValueA, SplatValueB,
                     SplatValueA, SplatValueB, SplatValueA, SplatValueB,
                     SplatValueA, SplatValueB, SplatValueA, SplatValueB};

  SDValue Result = DAG.getBuildVector(
      ViaVecTy, DL, makeArrayRef(Ops, ViaVecTy.getVectorNumElements()));

  if (VecTy != ViaVecTy)
    Result = DAG.getNode(ISD::BITCAST, DL, VecTy, Result);

  return Result;
}

static SDValue truncateVecElts(SDValue Op, SelectionDAG &DAG) {
  SDLoc DL(Op);
  EVT ResTy = Op->getValueType(0);
  SDValue Vec = Op->getOperand(2);
  MVT ResEltTy =
      (ResTy == MVT::v2i64 || ResTy == MVT::v4i64) ? MVT::i64 : MVT::i32;
  SDValue ConstValue =
      DAG.getConstant(Vec.getScalarValueSizeInBits() - 1, DL, ResEltTy);
  SDValue SplatVec = getBuildVectorSplat(ResTy, ConstValue, DAG);

  return DAG.getNode(ISD::AND, DL, ResTy, Vec, SplatVec);
}

static SDValue lowerLSXBitClear(SDValue Op, SelectionDAG &DAG) {
  EVT ResTy = Op->getValueType(0);
  SDLoc DL(Op);
  SDValue One = DAG.getConstant(1, DL, ResTy);
  SDValue Bit = DAG.getNode(ISD::SHL, DL, ResTy, One, truncateVecElts(Op, DAG));

  return DAG.getNode(ISD::AND, DL, ResTy, Op->getOperand(1),
                     DAG.getNOT(DL, Bit, ResTy));
}

static SDValue lowerLSXLoadIntr(SDValue Op, SelectionDAG &DAG, unsigned Intr,
                                const LoongArchSubtarget &Subtarget) {
  SDLoc DL(Op);
  SDValue ChainIn = Op->getOperand(0);
  SDValue Address = Op->getOperand(2);
  SDValue Offset = Op->getOperand(3);
  EVT ResTy = Op->getValueType(0);
  EVT PtrTy = Address->getValueType(0);

  // For LP64 addresses have the underlying type MVT::i64. This intrinsic
  // however takes an i32 signed constant offset. The actual type of the
  // intrinsic is a scaled signed i12.
  if (Subtarget.isABI_LP64())
    Offset = DAG.getNode(ISD::SIGN_EXTEND, DL, PtrTy, Offset);

  Address = DAG.getNode(ISD::ADD, DL, PtrTy, Address, Offset);
  return DAG.getLoad(ResTy, DL, ChainIn, Address, MachinePointerInfo(),
                     /* Alignment = */ 16);
}

static SDValue lowerLASXLoadIntr(SDValue Op, SelectionDAG &DAG, unsigned Intr,
                                 const LoongArchSubtarget &Subtarget) {
  SDLoc DL(Op);
  SDValue ChainIn = Op->getOperand(0);
  SDValue Address = Op->getOperand(2);
  SDValue Offset = Op->getOperand(3);
  EVT ResTy = Op->getValueType(0);
  EVT PtrTy = Address->getValueType(0);

  // For LP64 addresses have the underlying type MVT::i64. This intrinsic
  // however takes an i32 signed constant offset. The actual type of the
  // intrinsic is a scaled signed i12.
  if (Subtarget.isABI_LP64())
    Offset = DAG.getNode(ISD::SIGN_EXTEND, DL, PtrTy, Offset);

  Address = DAG.getNode(ISD::ADD, DL, PtrTy, Address, Offset);
  return DAG.getLoad(ResTy, DL, ChainIn, Address, MachinePointerInfo(),
                     /* Alignment = */ 32);
}

static SDValue lowerLASXVLDRIntr(SDValue Op, SelectionDAG &DAG, unsigned Intr,
                                 const LoongArchSubtarget &Subtarget) {
  SDLoc DL(Op);
  SDValue ChainIn = Op->getOperand(0);
  SDValue Address = Op->getOperand(2);
  SDValue Offset = Op->getOperand(3);
  EVT ResTy = Op->getValueType(0);
  EVT PtrTy = Address->getValueType(0);

  // For LP64 addresses have the underlying type MVT::i64. This intrinsic
  // however takes an i32 signed constant offset. The actual type of the
  // intrinsic is a scaled signed i12.
  if (Subtarget.isABI_LP64())
    Offset = DAG.getNode(ISD::SIGN_EXTEND, DL, PtrTy, Offset);

  Address = DAG.getNode(ISD::ADD, DL, PtrTy, Address, Offset);
  SDValue Load = DAG.getLoad(ResTy, DL, ChainIn, Address, MachinePointerInfo(),
                             /* Alignment = */ 32);
  return DAG.getNode(LoongArchISD::XVBROADCAST, DL,
                     DAG.getVTList(ResTy, MVT::Other), Load);
}

static SDValue lowerLSXVLDRIntr(SDValue Op, SelectionDAG &DAG, unsigned Intr,
                                const LoongArchSubtarget &Subtarget) {
  SDLoc DL(Op);
  SDValue ChainIn = Op->getOperand(0);
  SDValue Address = Op->getOperand(2);
  SDValue Offset = Op->getOperand(3);
  EVT ResTy = Op->getValueType(0);
  EVT PtrTy = Address->getValueType(0);

  // For LP64 addresses have the underlying type MVT::i64. This intrinsic
  // however takes an i32 signed constant offset. The actual type of the
  // intrinsic is a scaled signed i12.
  if (Subtarget.isABI_LP64())
    Offset = DAG.getNode(ISD::SIGN_EXTEND, DL, PtrTy, Offset);

  Address = DAG.getNode(ISD::ADD, DL, PtrTy, Address, Offset);
  SDValue Load = DAG.getLoad(ResTy, DL, ChainIn, Address, MachinePointerInfo(),
                             /* Alignment = */ 16);
  return DAG.getNode(LoongArchISD::VBROADCAST, DL,
                     DAG.getVTList(ResTy, MVT::Other), Load);
}

static SDValue lowerLSXStoreIntr(SDValue Op, SelectionDAG &DAG, unsigned Intr,
                                 const LoongArchSubtarget &Subtarget) {
  SDLoc DL(Op);
  SDValue ChainIn = Op->getOperand(0);
  SDValue Value = Op->getOperand(2);
  SDValue Address = Op->getOperand(3);
  SDValue Offset = Op->getOperand(4);
  EVT PtrTy = Address->getValueType(0);

  // For LP64 addresses have the underlying type MVT::i64. This intrinsic
  // however takes an i32 signed constant offset. The actual type of the
  // intrinsic is a scaled signed i12.
  if (Subtarget.isABI_LP64())
    Offset = DAG.getNode(ISD::SIGN_EXTEND, DL, PtrTy, Offset);

  Address = DAG.getNode(ISD::ADD, DL, PtrTy, Address, Offset);

  return DAG.getStore(ChainIn, DL, Value, Address, MachinePointerInfo(),
                      /* Alignment = */ 16);
}

static SDValue lowerLASXStoreIntr(SDValue Op, SelectionDAG &DAG, unsigned Intr,
                                  const LoongArchSubtarget &Subtarget) {
  SDLoc DL(Op);
  SDValue ChainIn = Op->getOperand(0);
  SDValue Value = Op->getOperand(2);
  SDValue Address = Op->getOperand(3);
  SDValue Offset = Op->getOperand(4);
  EVT PtrTy = Address->getValueType(0);

  // For LP64 addresses have the underlying type MVT::i64. This intrinsic
  // however takes an i32 signed constant offset. The actual type of the
  // intrinsic is a scaled signed i12.
  if (Subtarget.isABI_LP64())
    Offset = DAG.getNode(ISD::SIGN_EXTEND, DL, PtrTy, Offset);

  Address = DAG.getNode(ISD::ADD, DL, PtrTy, Address, Offset);

  return DAG.getStore(ChainIn, DL, Value, Address, MachinePointerInfo(),
                      /* Alignment = */ 32);
}

static SDValue LowerSUINT_TO_FP(unsigned ExtOpcode, SDValue Op, SelectionDAG &DAG) {

  EVT ResTy = Op->getValueType(0);
  SDValue Op0 = Op->getOperand(0);
  EVT ViaTy = Op0->getValueType(0);
  SDLoc DL(Op);

  if (!ResTy.isVector()) {
    if(ResTy.getScalarSizeInBits() == ViaTy.getScalarSizeInBits())
        return DAG.getNode(ISD::BITCAST, DL, ResTy, Op0);
    else if(ResTy.getScalarSizeInBits() > ViaTy.getScalarSizeInBits()) {
        Op0 = DAG.getNode(ISD::BITCAST, DL, MVT::f32, Op0);
        return DAG.getNode(ISD::FP_EXTEND, DL, MVT::f64, Op0);
    } else {
        Op0 = DAG.getNode(ISD::BITCAST, DL, MVT::f64, Op0);
        return DAG.getNode(ISD::TRUNCATE, DL, MVT::f32, Op0);
    }

  }

  if (ResTy.getScalarSizeInBits() == ViaTy.getScalarSizeInBits()) {
    // v4i32 => v4f32     v8i32 => v8f32
    // v2i64 => v2f64     v4i64 => v4f64
    // do nothing
  } else if (ResTy.getScalarSizeInBits() > ViaTy.getScalarSizeInBits()) {
    // v4i32 => v4i64 => v4f64
    Op0 = DAG.getNode(ISD::CONCAT_VECTORS, DL, MVT::v8i32, {Op0, Op0});
    Op0 = DAG.getNode(ExtOpcode, DL, MVT::v4i64, Op0);
  } else {
    // v4i64 => v4f32
    SDValue Ops[4];
    for (unsigned i = 0; i < 4; i++) {
      SDValue I64 = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, MVT::i64, Op0,
                                DAG.getConstant(i, DL, MVT::i32));
      Ops[i] = DAG.getNode(ISD::TRUNCATE, DL, MVT::i32, I64);
    }
    Op0 = DAG.getBuildVector(MVT::v4i32, DL, makeArrayRef(Ops, 4));
  }

   return Op0;
}

static SDValue LowerFP_TO_SUINT(unsigned FPToSUI, unsigned ExtOpcode,
                                SDValue Op, SelectionDAG &DAG) {

  EVT ResTy = Op->getValueType(0);
  SDValue Op0 = Op->getOperand(0);
  EVT ViaTy = Op0->getValueType(0);
  SDLoc DL(Op);

  if (ResTy.getScalarSizeInBits() == ViaTy.getScalarSizeInBits()) {
    // v4f32 => v4i32     v8f32 => v8i32
    // v2f64 => v2i64     v4f64 => v4i64
    // do nothing
    Op0 = DAG.getNode(FPToSUI, DL, ResTy, Op0);
  } else if (ResTy.getScalarSizeInBits() > ViaTy.getScalarSizeInBits()) {
    // v4f32 => v4i32 => v4i64
    Op0 = DAG.getNode(FPToSUI, DL, MVT::v4i32, Op0);
    Op0 = DAG.getNode(ISD::CONCAT_VECTORS, DL, MVT::v8i32, {Op0, Op0});
    Op0 = DAG.getNode(ExtOpcode, DL, MVT::v4i64, Op0);
  } else {
    SDValue Ops[4];
    Ops[0] = DAG.getNode(FPToSUI, DL, MVT::i32,
                         DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, MVT::f64, Op0,
                                     DAG.getConstant(0, DL, MVT::i64)));
    Ops[1] = DAG.getNode(FPToSUI, DL, MVT::i32,
                         DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, MVT::f64, Op0,
                                     DAG.getConstant(1, DL, MVT::i64)));
    Ops[2] = DAG.getNode(FPToSUI, DL, MVT::i32,
                         DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, MVT::f64, Op0,
                                     DAG.getConstant(2, DL, MVT::i64)));
    Ops[3] = DAG.getNode(FPToSUI, DL, MVT::i32,
                         DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, MVT::f64, Op0,
                                     DAG.getConstant(3, DL, MVT::i64)));

    Op0 = DAG.getBuildVector(MVT::v4i32, DL, makeArrayRef(Ops, 4));
  }

  return Op0;
}

// Lower VECTOR_SHUFFLE into SHF (if possible).
//
// SHF splits the vector into blocks of four elements, then shuffles these
// elements according to a <4 x i2> constant (encoded as an integer immediate).
//
// It is therefore possible to lower into SHF when the mask takes the form:
//   <a, b, c, d, a+4, b+4, c+4, d+4, a+8, b+8, c+8, d+8, ...>
// When undef's appear they are treated as if they were whatever value is
// necessary in order to fit the above forms.
//
// For example:
//   %2 = shufflevector <8 x i16> %0, <8 x i16> undef,
//                      <8 x i32> <i32 3, i32 2, i32 1, i32 0,
//                                 i32 7, i32 6, i32 5, i32 4>
// is lowered to:
//   (VSHUF4I_H $v0, $v1, 27)
// where the 27 comes from:
//   3 + (2 << 2) + (1 << 4) + (0 << 6)
static SDValue lowerVECTOR_SHUFFLE_SHF(SDValue Op, EVT ResTy,
                                       SmallVector<int, 16> Indices,
                                       SelectionDAG &DAG) {
  int SHFIndices[4] = {-1, -1, -1, -1};

  if (Indices.size() < 4)
    return SDValue();

  for (unsigned i = 0; i < 4; ++i) {
    for (unsigned j = i; j < Indices.size(); j += 4) {
      int Idx = Indices[j];

      // Convert from vector index to 4-element subvector index
      // If an index refers to an element outside of the subvector then give up
      if (Idx != -1) {
        Idx -= 4 * (j / 4);
        if (Idx < 0 || Idx >= 4)
          return SDValue();
      }

      // If the mask has an undef, replace it with the current index.
      // Note that it might still be undef if the current index is also undef
      if (SHFIndices[i] == -1)
        SHFIndices[i] = Idx;

      // Check that non-undef values are the same as in the mask. If they
      // aren't then give up
      if (!(Idx == -1 || Idx == SHFIndices[i]))
        return SDValue();
    }
  }

  // Calculate the immediate. Replace any remaining undefs with zero
  APInt Imm(32, 0);
  for (int i = 3; i >= 0; --i) {
    int Idx = SHFIndices[i];

    if (Idx == -1)
      Idx = 0;

    Imm <<= 2;
    Imm |= Idx & 0x3;
  }

  SDLoc DL(Op);
  return DAG.getNode(LoongArchISD::SHF, DL, ResTy,
                     DAG.getConstant(Imm, DL, MVT::i32), Op->getOperand(0));
}

/// Determine whether a range fits a regular pattern of values.
/// This function accounts for the possibility of jumping over the End iterator.
template <typename ValType>
static bool
fitsRegularPattern(typename SmallVectorImpl<ValType>::const_iterator Begin,
                   unsigned CheckStride,
                   typename SmallVectorImpl<ValType>::const_iterator End,
                   ValType ExpectedIndex, unsigned ExpectedIndexStride) {
  auto &I = Begin;

  while (I != End) {
    if (*I != -1 && *I != ExpectedIndex)
      return false;
    ExpectedIndex += ExpectedIndexStride;

    // Incrementing past End is undefined behaviour so we must increment one
    // step at a time and check for End at each step.
    for (unsigned n = 0; n < CheckStride && I != End; ++n, ++I)
      ; // Empty loop body.
  }
  return true;
}

// Determine whether VECTOR_SHUFFLE is a VREPLVEI.
//
// It is a VREPLVEI when the mask is:
//   <x, x, x, ...>
// where x is any valid index.
//
// When undef's appear in the mask they are treated as if they were whatever
// value is necessary in order to fit the above form.
static bool isVECTOR_SHUFFLE_VREPLVEI(SDValue Op, EVT ResTy,
                                      SmallVector<int, 16> Indices,
                                      SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  int SplatIndex = -1;
  for (const auto &V : Indices) {
    if (V != -1) {
      SplatIndex = V;
      break;
    }
  }

  return fitsRegularPattern<int>(Indices.begin(), 1, Indices.end(), SplatIndex,
                                 0);
}

// Lower VECTOR_SHUFFLE into VPACKEV (if possible).
//
// VPACKEV interleaves the even elements from each vector.
//
// It is possible to lower into VPACKEV when the mask consists of two of the
// following forms interleaved:
//   <0, 2, 4, ...>
//   <n, n+2, n+4, ...>
// where n is the number of elements in the vector.
// For example:
//   <0, 0, 2, 2, 4, 4, ...>
//   <0, n, 2, n+2, 4, n+4, ...>
//
// When undef's appear in the mask they are treated as if they were whatever
// value is necessary in order to fit the above forms.
static SDValue lowerVECTOR_SHUFFLE_VPACKEV(SDValue Op, EVT ResTy,
                                           SmallVector<int, 16> Indices,
                                           SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  SDValue Vj;
  SDValue Vk;
  const auto &Begin = Indices.begin();
  const auto &End = Indices.end();

  // Check even elements are taken from the even elements of one half or the
  // other and pick an operand accordingly.
  if (fitsRegularPattern<int>(Begin, 2, End, 0, 2))
    Vj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 2, End, Indices.size(), 2))
    Vj = Op->getOperand(1);
  else
    return SDValue();

  // Check odd elements are taken from the even elements of one half or the
  // other and pick an operand accordingly.
  if (fitsRegularPattern<int>(Begin + 1, 2, End, 0, 2))
    Vk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin + 1, 2, End, Indices.size(), 2))
    Vk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VPACKEV, SDLoc(Op), ResTy, Vk, Vj);
}

// Lower VECTOR_SHUFFLE into VPACKOD (if possible).
//
// VPACKOD interleaves the odd elements from each vector.
//
// It is possible to lower into VPACKOD when the mask consists of two of the
// following forms interleaved:
//   <1, 3, 5, ...>
//   <n+1, n+3, n+5, ...>
// where n is the number of elements in the vector.
// For example:
//   <1, 1, 3, 3, 5, 5, ...>
//   <1, n+1, 3, n+3, 5, n+5, ...>
//
// When undef's appear in the mask they are treated as if they were whatever
// value is necessary in order to fit the above forms.
static SDValue lowerVECTOR_SHUFFLE_VPACKOD(SDValue Op, EVT ResTy,
                                           SmallVector<int, 16> Indices,
                                           SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  SDValue Vj;
  SDValue Vk;
  const auto &Begin = Indices.begin();
  const auto &End = Indices.end();

  // Check even elements are taken from the odd elements of one half or the
  // other and pick an operand accordingly.
  if (fitsRegularPattern<int>(Begin, 2, End, 1, 2))
    Vj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 2, End, Indices.size() + 1, 2))
    Vj = Op->getOperand(1);
  else
    return SDValue();

  // Check odd elements are taken from the odd elements of one half or the
  // other and pick an operand accordingly.
  if (fitsRegularPattern<int>(Begin + 1, 2, End, 1, 2))
    Vk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin + 1, 2, End, Indices.size() + 1, 2))
    Vk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VPACKOD, SDLoc(Op), ResTy, Vk, Vj);
}

// Lower VECTOR_SHUFFLE into VILVL (if possible).
//
// VILVL interleaves consecutive elements from the right (lowest-indexed) half
// of each vector.
//
// It is possible to lower into VILVL when the mask consists of two of the
// following forms interleaved:
//   <0, 1, 2, ...>
//   <n, n+1, n+2, ...>
// where n is the number of elements in the vector.
// For example:
//   <0, 0, 1, 1, 2, 2, ...>
//   <0, n, 1, n+1, 2, n+2, ...>
//
// When undef's appear in the mask they are treated as if they were whatever
// value is necessary in order to fit the above forms.
static SDValue lowerVECTOR_SHUFFLE_VILVL(SDValue Op, EVT ResTy,
                                         SmallVector<int, 16> Indices,
                                         SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  SDValue Vj;
  SDValue Vk;
  const auto &Begin = Indices.begin();
  const auto &End = Indices.end();

  // Check even elements are taken from the right (lowest-indexed) elements of
  // one half or the other and pick an operand accordingly.
  if (fitsRegularPattern<int>(Begin, 2, End, 0, 1))
    Vj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 2, End, Indices.size(), 1))
    Vj = Op->getOperand(1);
  else
    return SDValue();

  // Check odd elements are taken from the right (lowest-indexed) elements of
  // one half or the other and pick an operand accordingly.
  if (fitsRegularPattern<int>(Begin + 1, 2, End, 0, 1))
    Vk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin + 1, 2, End, Indices.size(), 1))
    Vk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VILVL, SDLoc(Op), ResTy, Vk, Vj);
}

// Lower VECTOR_SHUFFLE into VILVH (if possible).
//
// VILVH interleaves consecutive elements from the left (highest-indexed) half
// of each vector.
//
// It is possible to lower into VILVH when the mask consists of two of the
// following forms interleaved:
//   <x, x+1, x+2, ...>
//   <n+x, n+x+1, n+x+2, ...>
// where n is the number of elements in the vector and x is half n.
// For example:
//   <x, x, x+1, x+1, x+2, x+2, ...>
//   <x, n+x, x+1, n+x+1, x+2, n+x+2, ...>
//
// When undef's appear in the mask they are treated as if they were whatever
// value is necessary in order to fit the above forms.
static SDValue lowerVECTOR_SHUFFLE_VILVH(SDValue Op, EVT ResTy,
                                         SmallVector<int, 16> Indices,
                                         SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  unsigned HalfSize = Indices.size() / 2;
  SDValue Vj;
  SDValue Vk;
  const auto &Begin = Indices.begin();
  const auto &End = Indices.end();

  // Check even elements are taken from the left (highest-indexed) elements of
  // one half or the other and pick an operand accordingly.
  if (fitsRegularPattern<int>(Begin, 2, End, HalfSize, 1))
    Vj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 2, End, Indices.size() + HalfSize, 1))
    Vj = Op->getOperand(1);
  else
    return SDValue();

  // Check odd elements are taken from the left (highest-indexed) elements of
  // one half or the other and pick an operand accordingly.
  if (fitsRegularPattern<int>(Begin + 1, 2, End, HalfSize, 1))
    Vk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin + 1, 2, End, Indices.size() + HalfSize,
                                   1))
    Vk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VILVH, SDLoc(Op), ResTy, Vk, Vj);
}

// Lower VECTOR_SHUFFLE into VPICKEV (if possible).
//
// VPICKEV copies the even elements of each vector into the result vector.
//
// It is possible to lower into VPICKEV when the mask consists of two of the
// following forms concatenated:
//   <0, 2, 4, ...>
//   <n, n+2, n+4, ...>
// where n is the number of elements in the vector.
// For example:
//   <0, 2, 4, ..., 0, 2, 4, ...>
//   <0, 2, 4, ..., n, n+2, n+4, ...>
//
// When undef's appear in the mask they are treated as if they were whatever
// value is necessary in order to fit the above forms.
static SDValue lowerVECTOR_SHUFFLE_VPICKEV(SDValue Op, EVT ResTy,
                                           SmallVector<int, 16> Indices,
                                           SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  SDValue Vj;
  SDValue Vk;
  const auto &Begin = Indices.begin();
  const auto &Mid = Indices.begin() + Indices.size() / 2;
  const auto &End = Indices.end();

  if (fitsRegularPattern<int>(Begin, 1, Mid, 0, 2))
    Vj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 1, Mid, Indices.size(), 2))
    Vj = Op->getOperand(1);
  else
    return SDValue();

  if (fitsRegularPattern<int>(Mid, 1, End, 0, 2))
    Vk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Mid, 1, End, Indices.size(), 2))
    Vk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VPICKEV, SDLoc(Op), ResTy, Vk, Vj);
}

// Lower VECTOR_SHUFFLE into VPICKOD (if possible).
//
// VPICKOD copies the odd elements of each vector into the result vector.
//
// It is possible to lower into VPICKOD when the mask consists of two of the
// following forms concatenated:
//   <1, 3, 5, ...>
//   <n+1, n+3, n+5, ...>
// where n is the number of elements in the vector.
// For example:
//   <1, 3, 5, ..., 1, 3, 5, ...>
//   <1, 3, 5, ..., n+1, n+3, n+5, ...>
//
// When undef's appear in the mask they are treated as if they were whatever
// value is necessary in order to fit the above forms.
static SDValue lowerVECTOR_SHUFFLE_VPICKOD(SDValue Op, EVT ResTy,
                                           SmallVector<int, 16> Indices,
                                           SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  SDValue Vj;
  SDValue Vk;
  const auto &Begin = Indices.begin();
  const auto &Mid = Indices.begin() + Indices.size() / 2;
  const auto &End = Indices.end();

  if (fitsRegularPattern<int>(Begin, 1, Mid, 1, 2))
    Vj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 1, Mid, Indices.size() + 1, 2))
    Vj = Op->getOperand(1);
  else
    return SDValue();

  if (fitsRegularPattern<int>(Mid, 1, End, 1, 2))
    Vk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Mid, 1, End, Indices.size() + 1, 2))
    Vk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VPICKOD, SDLoc(Op), ResTy, Vk, Vj);
}

// Lower VECTOR_SHUFFLE into VSHF.
//
// This mostly consists of converting the shuffle indices in Indices into a
// BUILD_VECTOR and adding it as an operand to the resulting VSHF. There is
// also code to eliminate unused operands of the VECTOR_SHUFFLE. For example,
// if the type is v8i16 and all the indices are less than 8 then the second
// operand is unused and can be replaced with anything. We choose to replace it
// with the used operand since this reduces the number of instructions overall.
static SDValue lowerVECTOR_SHUFFLE_VSHF(SDValue Op, EVT ResTy,
                                        SmallVector<int, 16> Indices,
                                        SelectionDAG &DAG) {
  SmallVector<SDValue, 16> Ops;
  SDValue Op0;
  SDValue Op1;
  EVT MaskVecTy = ResTy.changeVectorElementTypeToInteger();
  EVT MaskEltTy = MaskVecTy.getVectorElementType();
  bool Using1stVec = false;
  bool Using2ndVec = false;
  SDLoc DL(Op);
  int ResTyNumElts = ResTy.getVectorNumElements();

  for (int i = 0; i < ResTyNumElts; ++i) {
    // Idx == -1 means UNDEF
    int Idx = Indices[i];

    if (0 <= Idx && Idx < ResTyNumElts)
      Using1stVec = true;
    if (ResTyNumElts <= Idx && Idx < ResTyNumElts * 2)
      Using2ndVec = true;
  }

  for (SmallVector<int, 16>::iterator I = Indices.begin(); I != Indices.end();
       ++I)
    Ops.push_back(DAG.getTargetConstant(*I, DL, MaskEltTy));

  SDValue MaskVec = DAG.getBuildVector(MaskVecTy, DL, Ops);

  if (Using1stVec && Using2ndVec) {
    Op0 = Op->getOperand(0);
    Op1 = Op->getOperand(1);
  } else if (Using1stVec)
    Op0 = Op1 = Op->getOperand(0);
  else if (Using2ndVec)
    Op0 = Op1 = Op->getOperand(1);
  else
    llvm_unreachable("shuffle vector mask references neither vector operand?");

  // VECTOR_SHUFFLE concatenates the vectors in an vectorwise fashion.
  // <0b00, 0b01> + <0b10, 0b11> -> <0b00, 0b01, 0b10, 0b11>
  // VSHF concatenates the vectors in a bitwise fashion:
  // <0b00, 0b01> + <0b10, 0b11> ->
  // 0b0100       + 0b1110       -> 0b01001110
  //                                <0b10, 0b11, 0b00, 0b01>
  // We must therefore swap the operands to get the correct result.
  return DAG.getNode(LoongArchISD::VSHF, DL, ResTy, MaskVec, Op1, Op0);
}

static SDValue lowerVECTOR_SHUFFLE_XVILVL(SDValue Op, EVT ResTy,
                                          SmallVector<int, 32> Indices,
                                          SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  SDValue Xj;
  SDValue Xk;
  const auto &Begin = Indices.begin();
  const auto &End = Indices.end();
  unsigned HalfSize = Indices.size() / 2;

  if (fitsRegularPattern<int>(Begin, 2, End - HalfSize, 0, 1) &&
      fitsRegularPattern<int>(Begin + HalfSize, 2, End, HalfSize, 1))
    Xj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 2, End - HalfSize, Indices.size(),
                                   1) &&
           fitsRegularPattern<int>(Begin + HalfSize, 2, End,
                                   Indices.size() + HalfSize, 1))
    Xj = Op->getOperand(1);
  else
    return SDValue();

  if (fitsRegularPattern<int>(Begin + 1, 2, End - HalfSize, 0, 1) &&
      fitsRegularPattern<int>(Begin + 1 + HalfSize, 2, End, HalfSize, 1))
    Xk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin + 1, 2, End - HalfSize, Indices.size(),
                                   1) &&
           fitsRegularPattern<int>(Begin + 1 + HalfSize, 2, End,
                                   Indices.size() + HalfSize, 1))
    Xk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VILVL, SDLoc(Op), ResTy, Xk, Xj);
}

static SDValue lowerVECTOR_SHUFFLE_XVILVH(SDValue Op, EVT ResTy,
                                          SmallVector<int, 32> Indices,
                                          SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  unsigned HalfSize = Indices.size() / 2;
  unsigned LeftSize = HalfSize / 2;
  SDValue Xj;
  SDValue Xk;
  const auto &Begin = Indices.begin();
  const auto &End = Indices.end();

  if (fitsRegularPattern<int>(Begin, 2, End - HalfSize, HalfSize - LeftSize,
                              1) &&
      fitsRegularPattern<int>(Begin + HalfSize, 2, End, HalfSize + LeftSize, 1))
    Xj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 2, End - HalfSize,
                                   Indices.size() + HalfSize - LeftSize, 1) &&
           fitsRegularPattern<int>(Begin + HalfSize, 2, End,
                                   Indices.size() + HalfSize + LeftSize, 1))
    Xj = Op->getOperand(1);
  else
    return SDValue();

  if (fitsRegularPattern<int>(Begin + 1, 2, End - HalfSize, HalfSize - LeftSize,
                              1) &&
      fitsRegularPattern<int>(Begin + 1 + HalfSize, 2, End, HalfSize + LeftSize,
                              1))
    Xk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin + 1, 2, End - HalfSize,
                                   Indices.size() + HalfSize - LeftSize, 1) &&
           fitsRegularPattern<int>(Begin + 1 + HalfSize, 2, End,
                                   Indices.size() + HalfSize + LeftSize, 1))
    Xk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VILVH, SDLoc(Op), ResTy, Xk, Xj);
}

static SDValue lowerVECTOR_SHUFFLE_XVPACKEV(SDValue Op, EVT ResTy,
                                            SmallVector<int, 32> Indices,
                                            SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  SDValue Xj;
  SDValue Xk;
  const auto &Begin = Indices.begin();
  const auto &End = Indices.end();
  unsigned HalfSize = Indices.size() / 2;

  if (fitsRegularPattern<int>(Begin, 2, End, 0, 2) &&
      fitsRegularPattern<int>(Begin + HalfSize, 2, End, HalfSize, 2))
    Xj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 2, End, Indices.size(), 2) &&
           fitsRegularPattern<int>(Begin + HalfSize, 2, End,
                                   Indices.size() + HalfSize, 2))
    Xj = Op->getOperand(1);
  else
    return SDValue();

  if (fitsRegularPattern<int>(Begin + 1, 2, End, 0, 2) &&
      fitsRegularPattern<int>(Begin + 1 + HalfSize, 2, End, HalfSize, 2))
    Xk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin + 1, 2, End, Indices.size(), 2) &&
           fitsRegularPattern<int>(Begin + 1 + HalfSize, 2, End,
                                   Indices.size() + HalfSize, 2))
    Xk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VPACKEV, SDLoc(Op), ResTy, Xk, Xj);
}

static SDValue lowerVECTOR_SHUFFLE_XVPACKOD(SDValue Op, EVT ResTy,
                                            SmallVector<int, 32> Indices,
                                            SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  SDValue Xj;
  SDValue Xk;
  const auto &Begin = Indices.begin();
  const auto &End = Indices.end();
  unsigned HalfSize = Indices.size() / 2;

  if (fitsRegularPattern<int>(Begin, 2, End, 1, 2) &&
      fitsRegularPattern<int>(Begin + HalfSize, 2, End, HalfSize + 1, 2))
    Xj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 2, End, Indices.size() + 1, 2) &&
           fitsRegularPattern<int>(Begin + HalfSize, 2, End,
                                   Indices.size() + HalfSize + 1, 2))
    Xj = Op->getOperand(1);
  else
    return SDValue();

  if (fitsRegularPattern<int>(Begin + 1, 2, End, 1, 2) &&
      fitsRegularPattern<int>(Begin + 1 + HalfSize, 2, End, HalfSize + 1, 2))
    Xk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin + 1, 2, End, Indices.size() + 1, 2) &&
           fitsRegularPattern<int>(Begin + 1 + HalfSize, 2, End,
                                   Indices.size() + HalfSize + 1, 2))
    Xk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VPACKOD, SDLoc(Op), ResTy, Xk, Xj);
}

static bool isVECTOR_SHUFFLE_XVREPLVEI(SDValue Op, EVT ResTy,
                                       SmallVector<int, 32> Indices,
                                       SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);
  unsigned HalfSize = Indices.size() / 2;

  for (unsigned i = 0; i < HalfSize; i++) {
    if (Indices[i] == -1 || Indices[HalfSize + i] == -1)
      return false;
    if (Indices[0] != Indices[i] || Indices[HalfSize] != Indices[HalfSize + i])
      return false;
  }
  return true;
}

static SDValue lowerVECTOR_SHUFFLE_XVPICKEV(SDValue Op, EVT ResTy,
                                            SmallVector<int, 32> Indices,
                                            SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  SDValue Xj;
  SDValue Xk;
  const auto &Begin = Indices.begin();
  const auto &LeftMid = Indices.begin() + Indices.size() / 4;
  const auto &End = Indices.end();
  const auto &RightMid = Indices.end() - Indices.size() / 4;
  const auto &Mid = Indices.begin() + Indices.size() / 2;
  unsigned HalfSize = Indices.size() / 2;

  if (fitsRegularPattern<int>(Begin, 1, LeftMid, 0, 2) &&
      fitsRegularPattern<int>(Mid, 1, RightMid, HalfSize, 2))
    Xj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 1, LeftMid, Indices.size(), 2) &&
           fitsRegularPattern<int>(Mid, 1, RightMid, Indices.size() + HalfSize,
                                   2))
    Xj = Op->getOperand(1);
  else
    return SDValue();

  if (fitsRegularPattern<int>(LeftMid, 1, Mid, 0, 2) &&
      fitsRegularPattern<int>(RightMid, 1, End, HalfSize, 2))
    Xk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(LeftMid, 1, Mid, Indices.size(), 2) &&
           fitsRegularPattern<int>(RightMid, 1, End, Indices.size() + HalfSize,
                                   2))
    Xk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VPICKEV, SDLoc(Op), ResTy, Xk, Xj);
}

static SDValue lowerVECTOR_SHUFFLE_XVPICKOD(SDValue Op, EVT ResTy,
                                            SmallVector<int, 32> Indices,
                                            SelectionDAG &DAG) {
  assert((Indices.size() % 2) == 0);

  SDValue Xj;
  SDValue Xk;
  const auto &Begin = Indices.begin();
  const auto &LeftMid = Indices.begin() + Indices.size() / 4;
  const auto &Mid = Indices.begin() + Indices.size() / 2;
  const auto &RightMid = Indices.end() - Indices.size() / 4;
  const auto &End = Indices.end();
  unsigned HalfSize = Indices.size() / 2;

  if (fitsRegularPattern<int>(Begin, 1, LeftMid, 1, 2) &&
      fitsRegularPattern<int>(Mid, 1, RightMid, HalfSize + 1, 2))
    Xj = Op->getOperand(0);
  else if (fitsRegularPattern<int>(Begin, 1, LeftMid, Indices.size() + 1, 2) &&
           fitsRegularPattern<int>(Mid, 1, RightMid,
                                   Indices.size() + HalfSize + 1, 2))
    Xj = Op->getOperand(1);
  else
    return SDValue();

  if (fitsRegularPattern<int>(LeftMid, 1, Mid, 1, 2) &&
      fitsRegularPattern<int>(RightMid, 1, End, HalfSize + 1, 2))
    Xk = Op->getOperand(0);
  else if (fitsRegularPattern<int>(LeftMid, 1, Mid, Indices.size() + 1, 2) &&
           fitsRegularPattern<int>(RightMid, 1, End,
                                   Indices.size() + HalfSize + 1, 2))
    Xk = Op->getOperand(1);
  else
    return SDValue();

  return DAG.getNode(LoongArchISD::VPICKOD, SDLoc(Op), ResTy, Xk, Xj);
}

static SDValue lowerVECTOR_SHUFFLE_XSHF(SDValue Op, EVT ResTy,
                                        SmallVector<int, 32> Indices,
                                        SelectionDAG &DAG) {
  int SHFIndices[4] = {-1, -1, -1, -1};

  // If the size of the mask is 4, it should not be converted to SHF node,
  // because SHF only corresponds to type b/h/w instruction but no type d.
  if (Indices.size() <= 4)
    return SDValue();

  int HalfSize = Indices.size() / 2;
  for (int i = 0; i < 4; ++i) {
    for (int j = i; j < HalfSize; j += 4) {
      int Idx = Indices[j];
      // check mxshf
      if (Idx + HalfSize != Indices[j + HalfSize])
        return SDValue();

      // Convert from vector index to 4-element subvector index
      // If an index refers to an element outside of the subvector then give up
      if (Idx != -1) {
        Idx -= 4 * (j / 4);
        if (Idx < 0 || Idx >= 4)
          return SDValue();
      }

      // If the mask has an undef, replace it with the current index.
      // Note that it might still be undef if the current index is also undef
      if (SHFIndices[i] == -1)
        SHFIndices[i] = Idx;

      // Check that non-undef values are the same as in the mask. If they
      // aren't then give up
      if (!(Idx == -1 || Idx == SHFIndices[i]))
        return SDValue();
    }
  }

  // Calculate the immediate. Replace any remaining undefs with zero
  APInt Imm(32, 0);
  for (int i = 3; i >= 0; --i) {
    int Idx = SHFIndices[i];

    if (Idx == -1)
      Idx = 0;

    Imm <<= 2;
    Imm |= Idx & 0x3;
  }
  SDLoc DL(Op);
  return DAG.getNode(LoongArchISD::SHF, DL, ResTy,
                     DAG.getConstant(Imm, DL, MVT::i32), Op->getOperand(0));
}

static bool isConstantOrUndef(const SDValue Op) {
  if (Op->isUndef())
    return true;
  if (isa<ConstantSDNode>(Op))
    return true;
  if (isa<ConstantFPSDNode>(Op))
    return true;
  return false;
}

static bool isConstantOrUndefBUILD_VECTOR(const BuildVectorSDNode *Op) {
  for (unsigned i = 0; i < Op->getNumOperands(); ++i)
    if (isConstantOrUndef(Op->getOperand(i)))
      return true;
  return false;
}

static bool isLASXBySplatBitSize(unsigned SplatBitSize, EVT &ViaVecTy) {
  switch (SplatBitSize) {
  default:
    return false;
  case 8:
    ViaVecTy = MVT::v32i8;
    break;
  case 16:
    ViaVecTy = MVT::v16i16;
    break;
  case 32:
    ViaVecTy = MVT::v8i32;
    break;
  case 64:
    ViaVecTy = MVT::v4i64;
    break;
  case 128:
    // There's no fill.q to fall back on for 64-bit values
    return false;
  }

  return true;
}

static bool isLSXBySplatBitSize(unsigned SplatBitSize, EVT &ViaVecTy) {
  switch (SplatBitSize) {
  default:
    return false;
  case 8:
    ViaVecTy = MVT::v16i8;
    break;
  case 16:
    ViaVecTy = MVT::v8i16;
    break;
  case 32:
    ViaVecTy = MVT::v4i32;
    break;
  case 64:
    // There's no fill.d to fall back on for 64-bit values
    return false;
  }

  return true;
}

bool LoongArchTargetLowering::isCheapToSpeculateCttz() const { return true; }

bool LoongArchTargetLowering::isCheapToSpeculateCtlz() const { return true; }

void LoongArchTargetLowering::LowerOperationWrapper(
    SDNode *N, SmallVectorImpl<SDValue> &Results, SelectionDAG &DAG) const {
  SDValue Res = LowerOperation(SDValue(N, 0), DAG);

  if (!Res.getNode())
    return;

  assert((N->getNumValues() <= Res->getNumValues()) &&
         "Lowering returned the wrong number of results!");

  for (unsigned I = 0, E = Res->getNumValues(); I != E; ++I)
    Results.push_back(Res.getValue(I));
}

void LoongArchTargetLowering::ReplaceNodeResults(
    SDNode *N, SmallVectorImpl<SDValue> &Results, SelectionDAG &DAG) const {
  SDLoc DL(N);
  switch (N->getOpcode()) {
  default:
    return LowerOperationWrapper(N, Results, DAG);
  case LoongArchISD::VABSD:
  case LoongArchISD::UVABSD: {
    EVT VT = N->getValueType(0);
    assert(VT.isVector() && "Unexpected VT");
    if (getTypeAction(*DAG.getContext(), VT) == TypePromoteInteger) {
      EVT PromoteVT;
      if (VT.getVectorNumElements() == 2)
        PromoteVT = MVT::v2i64;
      else if (VT.getVectorNumElements() == 4)
        PromoteVT = MVT::v4i32;
      else if (VT.getVectorNumElements() == 8)
        PromoteVT = MVT::v8i16;
      else
        return;

      SDValue N0 =
          DAG.getNode(ISD::ANY_EXTEND, DL, PromoteVT, N->getOperand(0));
      SDValue N1 =
          DAG.getNode(ISD::ANY_EXTEND, DL, PromoteVT, N->getOperand(1));

      SDValue Vabsd =
          DAG.getNode(N->getOpcode(), DL, PromoteVT, N0, N1, N->getOperand(2));

      Results.push_back(DAG.getNode(ISD::TRUNCATE, DL, VT, Vabsd));
    }
    return;
  }
  }
}

SDValue LoongArchTargetLowering::LowerOperation(SDValue Op,
                                                SelectionDAG &DAG) const {
  switch (Op.getOpcode()) {
  case ISD::STORE:
    return lowerSTORE(Op, DAG);
  case ISD::INTRINSIC_WO_CHAIN:
    return lowerINTRINSIC_WO_CHAIN(Op, DAG);
  case ISD::INTRINSIC_W_CHAIN:
    return lowerINTRINSIC_W_CHAIN(Op, DAG);
  case ISD::INTRINSIC_VOID:
    return lowerINTRINSIC_VOID(Op, DAG);
  case ISD::EXTRACT_VECTOR_ELT:
    return lowerEXTRACT_VECTOR_ELT(Op, DAG);
  case ISD::INSERT_VECTOR_ELT:
    return lowerINSERT_VECTOR_ELT(Op, DAG);
  case ISD::BUILD_VECTOR:
    return lowerBUILD_VECTOR(Op, DAG);
  case ISD::VECTOR_SHUFFLE:
    return lowerVECTOR_SHUFFLE(Op, DAG);
  case ISD::UINT_TO_FP:
    return lowerUINT_TO_FP(Op, DAG);
  case ISD::SINT_TO_FP:
    return lowerSINT_TO_FP(Op, DAG);
  case ISD::FP_TO_UINT:
    return lowerFP_TO_UINT(Op, DAG);
  case ISD::FP_TO_SINT:
    return lowerFP_TO_SINT(Op, DAG);
  case ISD::BRCOND:
    return lowerBRCOND(Op, DAG);
  case ISD::ConstantPool:
    return lowerConstantPool(Op, DAG);
  case ISD::GlobalAddress:
    return lowerGlobalAddress(Op, DAG);
  case ISD::BlockAddress:
    return lowerBlockAddress(Op, DAG);
  case ISD::GlobalTLSAddress:
    return lowerGlobalTLSAddress(Op, DAG);
  case ISD::JumpTable:
    return lowerJumpTable(Op, DAG);
  case ISD::SELECT:
    return lowerSELECT(Op, DAG);
  case ISD::SETCC:
    return lowerSETCC(Op, DAG);
  case ISD::VASTART:
    return lowerVASTART(Op, DAG);
  case ISD::VAARG:
    return lowerVAARG(Op, DAG);
  case ISD::FRAMEADDR:
    return lowerFRAMEADDR(Op, DAG);
  case ISD::RETURNADDR:
    return lowerRETURNADDR(Op, DAG);
  case ISD::EH_RETURN:
    return lowerEH_RETURN(Op, DAG);
  case ISD::ATOMIC_FENCE:
    return lowerATOMIC_FENCE(Op, DAG);
  case ISD::SHL_PARTS:
    return lowerShiftLeftParts(Op, DAG);
  case ISD::SRA_PARTS:
    return lowerShiftRightParts(Op, DAG, true);
  case ISD::SRL_PARTS:
    return lowerShiftRightParts(Op, DAG, false);
  case ISD::EH_DWARF_CFA:
    return lowerEH_DWARF_CFA(Op, DAG);
  }
  return SDValue();
}

//===----------------------------------------------------------------------===//
//  Lower helper functions
//===----------------------------------------------------------------------===//

template <class NodeTy>
SDValue LoongArchTargetLowering::getAddr(NodeTy *N, SelectionDAG &DAG,
                                         bool IsLocal) const {
  SDLoc DL(N);
  EVT Ty = getPointerTy(DAG.getDataLayout());

  if (isPositionIndependent()) {
    SDValue Addr = getTargetNode(N, Ty, DAG, 0U);
    if (IsLocal)
      // Use PC-relative addressing to access the symbol.
      return SDValue(DAG.getMachineNode(LoongArch::LoadAddrLocal, DL, Ty, Addr),
                     0);

    // Use PC-relative addressing to access the GOT for this symbol, then load
    // the address from the GOT.
    return SDValue(DAG.getMachineNode(LoongArch::LoadAddrGlobal, DL, Ty, Addr),
                   0);
  }

  SDValue Addr = getTargetNode(N, Ty, DAG, 0U);
  return SDValue(DAG.getMachineNode(LoongArch::LoadAddrLocal, DL, Ty, Addr), 0);
}

// addLiveIn - This helper function adds the specified physical register to the
// MachineFunction as a live in value.  It also creates a corresponding
// virtual register for it.
static unsigned addLiveIn(MachineFunction &MF, unsigned PReg,
                          const TargetRegisterClass *RC) {
  unsigned VReg = MF.getRegInfo().createVirtualRegister(RC);
  MF.getRegInfo().addLiveIn(PReg, VReg);
  return VReg;
}

static MachineBasicBlock *insertDivByZeroTrap(MachineInstr &MI,
                                              MachineBasicBlock &MBB,
                                              const TargetInstrInfo &TII,
                                              bool Is64Bit) {
  if (NoZeroDivCheck)
    return &MBB;

  // Insert pseudo instruction(PseudoTEQ), will expand:
  //   beq $divisor_reg, $zero, 8
  //   break 7
  MachineBasicBlock::iterator I(MI);
  MachineInstrBuilder MIB;
  MachineOperand &Divisor = MI.getOperand(2);
  unsigned TeqOp = LoongArch::PseudoTEQ;

  MIB = BuildMI(MBB, std::next(I), MI.getDebugLoc(), TII.get(TeqOp))
            .addReg(Divisor.getReg(), getKillRegState(Divisor.isKill()));

  // Use the 32-bit sub-register if this is a 64-bit division.
  //if (Is64Bit)
  //  MIB->getOperand(0).setSubReg(LoongArch::sub_32);

  // Clear Divisor's kill flag.
  Divisor.setIsKill(false);

  // We would normally delete the original instruction here but in this case
  // we only needed to inject an additional instruction rather than replace it.

  return &MBB;
}

MachineBasicBlock *
LoongArchTargetLowering::EmitInstrWithCustomInserter(MachineInstr &MI,
                                                MachineBasicBlock *BB) const {
  switch (MI.getOpcode()) {
  default:
    llvm_unreachable("Unexpected instr type to insert");
  case LoongArch::FILL_FW_PSEUDO:
    return emitFILL_FW(MI, BB);
  case LoongArch::FILL_FD_PSEUDO:
    return emitFILL_FD(MI, BB);
  case LoongArch::SNZ_B_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::VSETALLNEZ_B);
  case LoongArch::SNZ_H_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::VSETALLNEZ_H);
  case LoongArch::SNZ_W_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::VSETALLNEZ_W);
  case LoongArch::SNZ_D_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::VSETALLNEZ_D);
  case LoongArch::SNZ_V_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::VSETNEZ_V);
  case LoongArch::SZ_B_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::VSETANYEQZ_B);
  case LoongArch::SZ_H_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::VSETANYEQZ_H);
  case LoongArch::SZ_W_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::VSETANYEQZ_W);
  case LoongArch::SZ_D_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::VSETANYEQZ_D);
  case LoongArch::SZ_V_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::VSETEQZ_V);
  case LoongArch::XSNZ_B_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::XVSETALLNEZ_B);
  case LoongArch::XSNZ_H_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::XVSETALLNEZ_H);
  case LoongArch::XSNZ_W_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::XVSETALLNEZ_W);
  case LoongArch::XSNZ_D_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::XVSETALLNEZ_D);
  case LoongArch::XSNZ_V_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::XVSETNEZ_V);
  case LoongArch::XSZ_B_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::XVSETANYEQZ_B);
  case LoongArch::XSZ_H_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::XVSETANYEQZ_H);
  case LoongArch::XSZ_W_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::XVSETANYEQZ_W);
  case LoongArch::XSZ_D_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::XVSETANYEQZ_D);
  case LoongArch::XSZ_V_PSEUDO:
    return emitLSXCBranchPseudo(MI, BB, LoongArch::XVSETEQZ_V);
  case LoongArch::INSERT_FW_PSEUDO:
    return emitINSERT_FW(MI, BB);
  case LoongArch::INSERT_FD_PSEUDO:
    return emitINSERT_FD(MI, BB);
  case LoongArch::XINSERT_H_PSEUDO:
    return emitXINSERT_BH(MI, BB, 2);
  case LoongArch::XCOPY_FW_PSEUDO:
    return emitXCOPY_FW(MI, BB);
  case LoongArch::XCOPY_FD_PSEUDO:
    return emitXCOPY_FD(MI, BB);
  case LoongArch::XINSERT_FW_PSEUDO:
    return emitXINSERT_FW(MI, BB);
  case LoongArch::COPY_FW_PSEUDO:
    return emitCOPY_FW(MI, BB);
  case LoongArch::XFILL_FW_PSEUDO:
    return emitXFILL_FW(MI, BB);
  case LoongArch::XFILL_FD_PSEUDO:
    return emitXFILL_FD(MI, BB);
  case LoongArch::COPY_FD_PSEUDO:
    return emitCOPY_FD(MI, BB);
  case LoongArch::XINSERT_FD_PSEUDO:
    return emitXINSERT_FD(MI, BB);
  case LoongArch::XINSERT_B_PSEUDO:
    return emitXINSERT_BH(MI, BB, 1);
  case LoongArch::CONCAT_VECTORS_B_PSEUDO:
    return emitCONCAT_VECTORS(MI, BB, 1);
  case LoongArch::CONCAT_VECTORS_H_PSEUDO:
    return emitCONCAT_VECTORS(MI, BB, 2);
  case LoongArch::CONCAT_VECTORS_W_PSEUDO:
  case LoongArch::CONCAT_VECTORS_FW_PSEUDO:
    return emitCONCAT_VECTORS(MI, BB, 4);
  case LoongArch::CONCAT_VECTORS_D_PSEUDO:
  case LoongArch::CONCAT_VECTORS_FD_PSEUDO:
    return emitCONCAT_VECTORS(MI, BB, 8);
  case LoongArch::XCOPY_FW_GPR_PSEUDO:
    return emitXCOPY_FW_GPR(MI, BB);

  case LoongArch::ATOMIC_LOAD_ADD_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_LOAD_ADD_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_LOAD_ADD_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_LOAD_ADD_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::ATOMIC_LOAD_AND_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_LOAD_AND_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_LOAD_AND_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_LOAD_AND_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::ATOMIC_LOAD_OR_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_LOAD_OR_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_LOAD_OR_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_LOAD_OR_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::ATOMIC_LOAD_XOR_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_LOAD_XOR_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_LOAD_XOR_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_LOAD_XOR_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::ATOMIC_LOAD_NAND_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_LOAD_NAND_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_LOAD_NAND_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_LOAD_NAND_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::ATOMIC_LOAD_SUB_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_LOAD_SUB_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_LOAD_SUB_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_LOAD_SUB_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::ATOMIC_SWAP_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_SWAP_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_SWAP_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_SWAP_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::XINSERT_B_VIDX_PSEUDO:
  case LoongArch::XINSERT_B_VIDX64_PSEUDO:
    return emitXINSERT_B(MI, BB);
  case LoongArch::INSERT_H_VIDX64_PSEUDO:
    return emitINSERT_H_VIDX(MI, BB);
  case LoongArch::XINSERT_FW_VIDX_PSEUDO:
    return emitXINSERT_DF_VIDX(MI, BB, false);
  case LoongArch::XINSERT_FW_VIDX64_PSEUDO:
    return emitXINSERT_DF_VIDX(MI, BB, true);

  case LoongArch::ATOMIC_LOAD_MAX_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_LOAD_MAX_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_LOAD_MAX_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_LOAD_MAX_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::ATOMIC_LOAD_MIN_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_LOAD_MIN_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_LOAD_MIN_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_LOAD_MIN_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::ATOMIC_LOAD_UMAX_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_LOAD_UMAX_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_LOAD_UMAX_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_LOAD_UMAX_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::ATOMIC_LOAD_UMIN_I8:
    return emitAtomicBinaryPartword(MI, BB, 1);
  case LoongArch::ATOMIC_LOAD_UMIN_I16:
    return emitAtomicBinaryPartword(MI, BB, 2);
  case LoongArch::ATOMIC_LOAD_UMIN_I32:
    return emitAtomicBinary(MI, BB);
  case LoongArch::ATOMIC_LOAD_UMIN_I64:
    return emitAtomicBinary(MI, BB);

  case LoongArch::ATOMIC_CMP_SWAP_I8:
    return emitAtomicCmpSwapPartword(MI, BB, 1);
  case LoongArch::ATOMIC_CMP_SWAP_I16:
    return emitAtomicCmpSwapPartword(MI, BB, 2);
  case LoongArch::ATOMIC_CMP_SWAP_I32:
    return emitAtomicCmpSwap(MI, BB);
  case LoongArch::ATOMIC_CMP_SWAP_I64:
    return emitAtomicCmpSwap(MI, BB);

  case LoongArch::PseudoSELECT_I:
  case LoongArch::PseudoSELECT_I64:
  case LoongArch::PseudoSELECT_S:
  case LoongArch::PseudoSELECT_D64:
    return emitPseudoSELECT(MI, BB, false, LoongArch::BNE32);

  case LoongArch::PseudoSELECTFP_T_I:
  case LoongArch::PseudoSELECTFP_T_I64:
    return emitPseudoSELECT(MI, BB, true, LoongArch::BCNEZ);

  case LoongArch::PseudoSELECTFP_F_I:
  case LoongArch::PseudoSELECTFP_F_I64:
    return emitPseudoSELECT(MI, BB, true, LoongArch::BCEQZ);
  case LoongArch::DIV_W:
  case LoongArch::DIV_WU:
  case LoongArch::MOD_W:
  case LoongArch::MOD_WU:
    return insertDivByZeroTrap(MI, *BB, *Subtarget.getInstrInfo(), false);
  case LoongArch::DIV_D:
  case LoongArch::DIV_DU:
  case LoongArch::MOD_D:
  case LoongArch::MOD_DU:
    return insertDivByZeroTrap(MI, *BB, *Subtarget.getInstrInfo(), true);
  }
}

MachineBasicBlock *LoongArchTargetLowering::emitXINSERT_DF_VIDX(
    MachineInstr &MI, MachineBasicBlock *BB, bool IsGPR64) const {

  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &RegInfo = MF->getRegInfo();
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();

  unsigned insertOp;
  insertOp = IsGPR64 ? LoongArch::XINSERT_FW_VIDX64_PSEUDO_POSTRA
                     : LoongArch::XINSERT_FW_VIDX_PSEUDO_POSTRA;

  unsigned DstReg = MI.getOperand(0).getReg();
  unsigned SrcVecReg = MI.getOperand(1).getReg();
  unsigned LaneReg = MI.getOperand(2).getReg();
  unsigned SrcValReg = MI.getOperand(3).getReg();
  unsigned Dest = RegInfo.createVirtualRegister(RegInfo.getRegClass(DstReg));

  MachineBasicBlock::iterator II(MI);

  unsigned VecCopy =
      RegInfo.createVirtualRegister(RegInfo.getRegClass(SrcVecReg));
  unsigned LaneCopy =
      RegInfo.createVirtualRegister(RegInfo.getRegClass(LaneReg));
  unsigned ValCopy =
      RegInfo.createVirtualRegister(RegInfo.getRegClass(SrcValReg));

  const TargetRegisterClass *RC =
      IsGPR64 ? &LoongArch::GPR64RegClass : &LoongArch::GPR32RegClass;
  unsigned RI = RegInfo.createVirtualRegister(RC);

  unsigned Rj = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);
  unsigned Xj = RegInfo.createVirtualRegister(&LoongArch::LASX256WRegClass);
  BuildMI(*BB, II, DL, TII->get(LoongArch::SUBREG_TO_REG), Xj)
      .addImm(0)
      .addReg(SrcValReg)
      .addImm(LoongArch::sub_lo);
  BuildMI(*BB, II, DL, TII->get(LoongArch::XVPICKVE2GR_W), Rj)
      .addReg(Xj)
      .addImm(0);

  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), VecCopy).addReg(SrcVecReg);
  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), LaneCopy).addReg(LaneReg);
  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), ValCopy).addReg(SrcValReg);

  BuildMI(*BB, II, DL, TII->get(insertOp))
      .addReg(DstReg, RegState::Define | RegState::EarlyClobber)
      .addReg(VecCopy)
      .addReg(LaneCopy)
      .addReg(ValCopy)
      .addReg(Dest, RegState::Define | RegState::EarlyClobber |
                        RegState::Implicit | RegState::Dead)
      .addReg(RI, RegState::Define | RegState::EarlyClobber |
                      RegState::Implicit | RegState::Dead)
      .addReg(Rj, RegState::Define | RegState::EarlyClobber |
                      RegState::Implicit | RegState::Dead);

  MI.eraseFromParent();

  return BB;
}

MachineBasicBlock *
LoongArchTargetLowering::emitINSERT_H_VIDX(MachineInstr &MI,
                                           MachineBasicBlock *BB) const {

  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &RegInfo = MF->getRegInfo();
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();

  unsigned insertOp;
  unsigned isGP64 = 0;
  switch (MI.getOpcode()) {
  case LoongArch::INSERT_H_VIDX64_PSEUDO:
    isGP64 = 1;
    insertOp = LoongArch::INSERT_H_VIDX64_PSEUDO_POSTRA;
    break;
  default:
    llvm_unreachable("Unknown pseudo vector for replacement!");
  }

  unsigned DstReg = MI.getOperand(0).getReg();
  unsigned SrcVecReg = MI.getOperand(1).getReg();
  unsigned LaneReg = MI.getOperand(2).getReg();
  unsigned SrcValReg = MI.getOperand(3).getReg();
  unsigned Dest = RegInfo.createVirtualRegister(RegInfo.getRegClass(DstReg));

  MachineBasicBlock::iterator II(MI);

  unsigned VecCopy =
      RegInfo.createVirtualRegister(RegInfo.getRegClass(SrcVecReg));
  unsigned LaneCopy =
      RegInfo.createVirtualRegister(RegInfo.getRegClass(LaneReg));
  unsigned ValCopy =
      RegInfo.createVirtualRegister(RegInfo.getRegClass(SrcValReg));

  const TargetRegisterClass *RC =
      isGP64 ? &LoongArch::GPR64RegClass : &LoongArch::GPR32RegClass;
  unsigned RI = RegInfo.createVirtualRegister(RC);

  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), VecCopy).addReg(SrcVecReg);
  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), LaneCopy).addReg(LaneReg);
  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), ValCopy).addReg(SrcValReg);

  BuildMI(*BB, II, DL, TII->get(insertOp))
      .addReg(DstReg, RegState::Define | RegState::EarlyClobber)
      .addReg(VecCopy)
      .addReg(LaneCopy)
      .addReg(ValCopy)
      .addReg(Dest, RegState::Define | RegState::EarlyClobber |
                        RegState::Implicit | RegState::Dead)
      .addReg(RI, RegState::Define | RegState::EarlyClobber |
                      RegState::Implicit | RegState::Dead);

  MI.eraseFromParent();

  return BB;
}

MachineBasicBlock *
LoongArchTargetLowering::emitXINSERT_B(MachineInstr &MI,
                                       MachineBasicBlock *BB) const {

  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &RegInfo = MF->getRegInfo();
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();

  unsigned insertOp;
  unsigned isGP64 = 0;
  switch (MI.getOpcode()) {
  case LoongArch::XINSERT_B_VIDX64_PSEUDO:
    isGP64 = 1;
    insertOp = LoongArch::XINSERT_B_VIDX64_PSEUDO_POSTRA;
    break;
  case LoongArch::XINSERT_B_VIDX_PSEUDO:
    insertOp = LoongArch::XINSERT_B_VIDX_PSEUDO_POSTRA;
    break;
  default:
    llvm_unreachable("Unknown pseudo vector for replacement!");
  }

  unsigned DstReg = MI.getOperand(0).getReg();
  unsigned SrcVecReg = MI.getOperand(1).getReg();
  unsigned LaneReg = MI.getOperand(2).getReg();
  unsigned SrcValReg = MI.getOperand(3).getReg();
  unsigned Dest = RegInfo.createVirtualRegister(RegInfo.getRegClass(DstReg));

  MachineBasicBlock::iterator II(MI);

  unsigned VecCopy =
      RegInfo.createVirtualRegister(RegInfo.getRegClass(SrcVecReg));
  unsigned LaneCopy =
      RegInfo.createVirtualRegister(RegInfo.getRegClass(LaneReg));
  unsigned ValCopy =
      RegInfo.createVirtualRegister(RegInfo.getRegClass(SrcValReg));
  const TargetRegisterClass *RC =
      isGP64 ? &LoongArch::GPR64RegClass : &LoongArch::GPR32RegClass;
  unsigned Rimm = RegInfo.createVirtualRegister(RC);
  unsigned R4r = RegInfo.createVirtualRegister(RC);
  unsigned Rib = RegInfo.createVirtualRegister(RC);
  unsigned Ris = RegInfo.createVirtualRegister(RC);
  unsigned R7b1 = RegInfo.createVirtualRegister(RC);
  unsigned R7b2 = RegInfo.createVirtualRegister(RC);
  unsigned R7b3 = RegInfo.createVirtualRegister(RC);
  unsigned RI = RegInfo.createVirtualRegister(RC);

  unsigned R7r80_3 = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);
  unsigned R7r80l_3 = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);
  unsigned R7r81_3 = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);
  unsigned R7r81l_3 = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);
  unsigned R7r82_3 = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);
  unsigned R7r82l_3 = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);
  unsigned R70 = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);
  unsigned tmp_Dst73 =
      RegInfo.createVirtualRegister(&LoongArch::LASX256BRegClass);

  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), VecCopy).addReg(SrcVecReg);
  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), LaneCopy).addReg(LaneReg);
  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), ValCopy).addReg(SrcValReg);

  BuildMI(*BB, II, DL, TII->get(insertOp))
      .addReg(DstReg, RegState::Define | RegState::EarlyClobber)
      .addReg(VecCopy)
      .addReg(LaneCopy)
      .addReg(ValCopy)
      .addReg(Dest, RegState::Define | RegState::EarlyClobber |
                        RegState::Implicit | RegState::Dead)
      .addReg(R4r, RegState::Define | RegState::EarlyClobber |
                       RegState::Implicit | RegState::Dead)
      .addReg(Rib, RegState::Define | RegState::EarlyClobber |
                       RegState::Implicit | RegState::Dead)
      .addReg(Ris, RegState::Define | RegState::EarlyClobber |
                       RegState::Implicit | RegState::Dead)
      .addReg(R7b1, RegState::Define | RegState::EarlyClobber |
                        RegState::Implicit | RegState::Dead)
      .addReg(R7b2, RegState::Define | RegState::EarlyClobber |
                        RegState::Implicit | RegState::Dead)
      .addReg(R7b3, RegState::Define | RegState::EarlyClobber |
                        RegState::Implicit | RegState::Dead)
      .addReg(R7r80_3, RegState::Define | RegState::EarlyClobber |
                           RegState::Implicit | RegState::Dead)
      .addReg(R7r80l_3, RegState::Define | RegState::EarlyClobber |
                            RegState::Implicit | RegState::Dead)
      .addReg(R7r81_3, RegState::Define | RegState::EarlyClobber |
                           RegState::Implicit | RegState::Dead)
      .addReg(R7r81l_3, RegState::Define | RegState::EarlyClobber |
                            RegState::Implicit | RegState::Dead)
      .addReg(R7r82_3, RegState::Define | RegState::EarlyClobber |
                           RegState::Implicit | RegState::Dead)
      .addReg(R7r82l_3, RegState::Define | RegState::EarlyClobber |
                            RegState::Implicit | RegState::Dead)
      .addReg(RI, RegState::Define | RegState::EarlyClobber |
                      RegState::Implicit | RegState::Dead)
      .addReg(tmp_Dst73, RegState::Define | RegState::EarlyClobber |
                             RegState::Implicit | RegState::Dead)
      .addReg(Rimm, RegState::Define | RegState::EarlyClobber |
                        RegState::Implicit | RegState::Dead)
      .addReg(R70, RegState::Define | RegState::EarlyClobber |
                       RegState::Implicit | RegState::Dead);

  MI.eraseFromParent();

  return BB;
}

const TargetRegisterClass *
LoongArchTargetLowering::getRepRegClassFor(MVT VT) const {
  return TargetLowering::getRepRegClassFor(VT);
}

// This function also handles LoongArch::ATOMIC_SWAP_I32 (when BinOpcode == 0), and
// LoongArch::ATOMIC_LOAD_NAND_I32 (when Nand == true)
MachineBasicBlock *
LoongArchTargetLowering::emitAtomicBinary(MachineInstr &MI,
                                     MachineBasicBlock *BB) const {

  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &RegInfo = MF->getRegInfo();
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();

  unsigned AtomicOp;
  switch (MI.getOpcode()) {
  case LoongArch::ATOMIC_LOAD_ADD_I32:
    AtomicOp = LoongArch::ATOMIC_LOAD_ADD_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_SUB_I32:
    AtomicOp = LoongArch::ATOMIC_LOAD_SUB_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_AND_I32:
    AtomicOp = LoongArch::ATOMIC_LOAD_AND_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_OR_I32:
    AtomicOp = LoongArch::ATOMIC_LOAD_OR_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_XOR_I32:
    AtomicOp = LoongArch::ATOMIC_LOAD_XOR_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_NAND_I32:
    AtomicOp = LoongArch::ATOMIC_LOAD_NAND_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_SWAP_I32:
    AtomicOp = LoongArch::ATOMIC_SWAP_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_MAX_I32:
    AtomicOp = LoongArch::ATOMIC_LOAD_MAX_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_MIN_I32:
    AtomicOp = LoongArch::ATOMIC_LOAD_MIN_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_UMAX_I32:
    AtomicOp = LoongArch::ATOMIC_LOAD_UMAX_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_UMIN_I32:
    AtomicOp = LoongArch::ATOMIC_LOAD_UMIN_I32_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_ADD_I64:
    AtomicOp = LoongArch::ATOMIC_LOAD_ADD_I64_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_SUB_I64:
    AtomicOp = LoongArch::ATOMIC_LOAD_SUB_I64_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_AND_I64:
    AtomicOp = LoongArch::ATOMIC_LOAD_AND_I64_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_OR_I64:
    AtomicOp = LoongArch::ATOMIC_LOAD_OR_I64_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_XOR_I64:
    AtomicOp = LoongArch::ATOMIC_LOAD_XOR_I64_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_NAND_I64:
    AtomicOp = LoongArch::ATOMIC_LOAD_NAND_I64_POSTRA;
    break;
  case LoongArch::ATOMIC_SWAP_I64:
    AtomicOp = LoongArch::ATOMIC_SWAP_I64_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_MAX_I64:
    AtomicOp = LoongArch::ATOMIC_LOAD_MAX_I64_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_MIN_I64:
    AtomicOp = LoongArch::ATOMIC_LOAD_MIN_I64_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_UMAX_I64:
    AtomicOp = LoongArch::ATOMIC_LOAD_UMAX_I64_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_UMIN_I64:
    AtomicOp = LoongArch::ATOMIC_LOAD_UMIN_I64_POSTRA;
    break;
  default:
    llvm_unreachable("Unknown pseudo atomic for replacement!");
  }

  unsigned OldVal = MI.getOperand(0).getReg();
  unsigned Ptr = MI.getOperand(1).getReg();
  unsigned Incr = MI.getOperand(2).getReg();
  unsigned Scratch = RegInfo.createVirtualRegister(RegInfo.getRegClass(OldVal));

  MachineBasicBlock::iterator II(MI);

  // The scratch registers here with the EarlyClobber | Define | Implicit
  // flags is used to persuade the register allocator and the machine
  // verifier to accept the usage of this register. This has to be a real
  // register which has an UNDEF value but is dead after the instruction which
  // is unique among the registers chosen for the instruction.

  // The EarlyClobber flag has the semantic properties that the operand it is
  // attached to is clobbered before the rest of the inputs are read. Hence it
  // must be unique among the operands to the instruction.
  // The Define flag is needed to coerce the machine verifier that an Undef
  // value isn't a problem.
  // The Dead flag is needed as the value in scratch isn't used by any other
  // instruction. Kill isn't used as Dead is more precise.
  // The implicit flag is here due to the interaction between the other flags
  // and the machine verifier.

  // For correctness purpose, a new pseudo is introduced here. We need this
  // new pseudo, so that FastRegisterAllocator does not see an ll/sc sequence
  // that is spread over >1 basic blocks. A register allocator which
  // introduces (or any codegen infact) a store, can violate the expectations
  // of the hardware.
  //
  // An atomic read-modify-write sequence starts with a linked load
  // instruction and ends with a store conditional instruction. The atomic
  // read-modify-write sequence fails if any of the following conditions
  // occur between the execution of ll and sc:
  //   * A coherent store is completed by another process or coherent I/O
  //     module into the block of synchronizable physical memory containing
  //     the word. The size and alignment of the block is
  //     implementation-dependent.
  //   * A coherent store is executed between an LL and SC sequence on the
  //     same processor to the block of synchornizable physical memory
  //     containing the word.
  //

  unsigned PtrCopy = RegInfo.createVirtualRegister(RegInfo.getRegClass(Ptr));
  unsigned IncrCopy = RegInfo.createVirtualRegister(RegInfo.getRegClass(Incr));

  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), IncrCopy).addReg(Incr);
  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), PtrCopy).addReg(Ptr);

  BuildMI(*BB, II, DL, TII->get(AtomicOp))
      .addReg(OldVal, RegState::Define | RegState::EarlyClobber)
      .addReg(PtrCopy)
      .addReg(IncrCopy)
      .addReg(Scratch, RegState::Define | RegState::EarlyClobber |
                           RegState::Implicit | RegState::Dead);

  if(MI.getOpcode() == LoongArch::ATOMIC_LOAD_NAND_I32
     || MI.getOpcode() == LoongArch::ATOMIC_LOAD_NAND_I64){
    BuildMI(*BB, II, DL, TII->get(LoongArch::DBAR)).addImm(DBAR_HINT);
  }

  MI.eraseFromParent();

  return BB;
}

MachineBasicBlock *LoongArchTargetLowering::emitSignExtendToI32InReg(
    MachineInstr &MI, MachineBasicBlock *BB, unsigned Size, unsigned DstReg,
    unsigned SrcReg) const {
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  const DebugLoc &DL = MI.getDebugLoc();
  if (Size == 1) {
    BuildMI(BB, DL, TII->get(LoongArch::EXT_W_B32), DstReg).addReg(SrcReg);
    return BB;
  }

  if (Size == 2) {
    BuildMI(BB, DL, TII->get(LoongArch::EXT_W_H32), DstReg).addReg(SrcReg);
    return BB;
  }

  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &RegInfo = MF->getRegInfo();
  const TargetRegisterClass *RC = getRegClassFor(MVT::i32);
  unsigned ScrReg = RegInfo.createVirtualRegister(RC);

  assert(Size < 32);
  int64_t ShiftImm = 32 - (Size * 8);

  BuildMI(BB, DL, TII->get(LoongArch::SLLI_W), ScrReg).addReg(SrcReg).addImm(ShiftImm);
  BuildMI(BB, DL, TII->get(LoongArch::SRAI_W), DstReg).addReg(ScrReg).addImm(ShiftImm);

  return BB;
}

MachineBasicBlock *LoongArchTargetLowering::emitAtomicBinaryPartword(
    MachineInstr &MI, MachineBasicBlock *BB, unsigned Size) const {
  assert((Size == 1 || Size == 2) &&
         "Unsupported size for EmitAtomicBinaryPartial.");

  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &RegInfo = MF->getRegInfo();
  const TargetRegisterClass *RC = getRegClassFor(MVT::i32);
  const bool ArePtrs64bit = ABI.ArePtrs64bit();
  const TargetRegisterClass *RCp =
    getRegClassFor(ArePtrs64bit ? MVT::i64 : MVT::i32);
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();

  unsigned Dest = MI.getOperand(0).getReg();
  unsigned Ptr = MI.getOperand(1).getReg();
  unsigned Incr = MI.getOperand(2).getReg();

  unsigned AlignedAddr = RegInfo.createVirtualRegister(RCp);
  unsigned ShiftAmt = RegInfo.createVirtualRegister(RC);
  unsigned Mask = RegInfo.createVirtualRegister(RC);
  unsigned Mask2 = RegInfo.createVirtualRegister(RC);
  unsigned Incr2 = RegInfo.createVirtualRegister(RC);
  unsigned MaskLSB2 = RegInfo.createVirtualRegister(RCp);
  unsigned PtrLSB2 = RegInfo.createVirtualRegister(RC);
  unsigned MaskUpper = RegInfo.createVirtualRegister(RC);
  unsigned MaskUppest = RegInfo.createVirtualRegister(RC);
  unsigned Scratch = RegInfo.createVirtualRegister(RC);
  unsigned Scratch2 = RegInfo.createVirtualRegister(RC);
  unsigned Scratch3 = RegInfo.createVirtualRegister(RC);
  unsigned Scratch4 = RegInfo.createVirtualRegister(RC);
  unsigned Scratch5 = RegInfo.createVirtualRegister(RC);

  unsigned AtomicOp = 0;
  switch (MI.getOpcode()) {
  case LoongArch::ATOMIC_LOAD_NAND_I8:
    AtomicOp = LoongArch::ATOMIC_LOAD_NAND_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_NAND_I16:
    AtomicOp = LoongArch::ATOMIC_LOAD_NAND_I16_POSTRA;
    break;
  case LoongArch::ATOMIC_SWAP_I8:
    AtomicOp = LoongArch::ATOMIC_SWAP_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_SWAP_I16:
    AtomicOp = LoongArch::ATOMIC_SWAP_I16_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_MAX_I8:
    AtomicOp = LoongArch::ATOMIC_LOAD_MAX_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_MAX_I16:
    AtomicOp = LoongArch::ATOMIC_LOAD_MAX_I16_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_MIN_I8:
    AtomicOp = LoongArch::ATOMIC_LOAD_MIN_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_MIN_I16:
    AtomicOp = LoongArch::ATOMIC_LOAD_MIN_I16_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_UMAX_I8:
    AtomicOp = LoongArch::ATOMIC_LOAD_UMAX_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_UMAX_I16:
    AtomicOp = LoongArch::ATOMIC_LOAD_UMAX_I16_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_UMIN_I8:
    AtomicOp = LoongArch::ATOMIC_LOAD_UMIN_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_UMIN_I16:
    AtomicOp = LoongArch::ATOMIC_LOAD_UMIN_I16_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_ADD_I8:
    AtomicOp = LoongArch::ATOMIC_LOAD_ADD_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_ADD_I16:
    AtomicOp = LoongArch::ATOMIC_LOAD_ADD_I16_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_SUB_I8:
    AtomicOp = LoongArch::ATOMIC_LOAD_SUB_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_SUB_I16:
    AtomicOp = LoongArch::ATOMIC_LOAD_SUB_I16_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_AND_I8:
    AtomicOp = LoongArch::ATOMIC_LOAD_AND_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_AND_I16:
    AtomicOp = LoongArch::ATOMIC_LOAD_AND_I16_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_OR_I8:
    AtomicOp = LoongArch::ATOMIC_LOAD_OR_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_OR_I16:
    AtomicOp = LoongArch::ATOMIC_LOAD_OR_I16_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_XOR_I8:
    AtomicOp = LoongArch::ATOMIC_LOAD_XOR_I8_POSTRA;
    break;
  case LoongArch::ATOMIC_LOAD_XOR_I16:
    AtomicOp = LoongArch::ATOMIC_LOAD_XOR_I16_POSTRA;
    break;
  default:
    llvm_unreachable("Unknown subword atomic pseudo for expansion!");
  }

  // insert new blocks after the current block
  const BasicBlock *LLVM_BB = BB->getBasicBlock();
  MachineBasicBlock *exitMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineFunction::iterator It = ++BB->getIterator();
  MF->insert(It, exitMBB);

  // Transfer the remainder of BB and its successor edges to exitMBB.
  exitMBB->splice(exitMBB->begin(), BB,
                  std::next(MachineBasicBlock::iterator(MI)), BB->end());
  exitMBB->transferSuccessorsAndUpdatePHIs(BB);

  BB->addSuccessor(exitMBB, BranchProbability::getOne());

  //  thisMBB:
  //    addiu   masklsb2,$0,-4                # 0xfffffffc
  //    and     alignedaddr,ptr,masklsb2
  //    andi    ptrlsb2,ptr,3
  //    sll     shiftamt,ptrlsb2,3
  //    ori     maskupper,$0,255               # 0xff
  //    sll     mask,maskupper,shiftamt
  //    nor     mask2,$0,mask
  //    sll     incr2,incr,shiftamt

  int64_t MaskImm = (Size == 1) ? 255 : 4095;
  BuildMI(BB, DL, TII->get(ABI.GetPtrAddiOp()), MaskLSB2)
    .addReg(ABI.GetNullPtr()).addImm(-4);
  BuildMI(BB, DL, TII->get(ABI.GetPtrAndOp()), AlignedAddr)
    .addReg(Ptr).addReg(MaskLSB2);
  BuildMI(BB, DL, TII->get(LoongArch::ANDI32), PtrLSB2)
      .addReg(Ptr, 0, ArePtrs64bit ? LoongArch::sub_32 : 0).addImm(3);
  BuildMI(BB, DL, TII->get(LoongArch::SLLI_W), ShiftAmt).addReg(PtrLSB2).addImm(3);

  if(MaskImm==4095){
  BuildMI(BB, DL, TII->get(LoongArch::LU12I_W32), MaskUppest).addImm(0xf);
  BuildMI(BB, DL, TII->get(LoongArch::ORI32), MaskUpper)
    .addReg(MaskUppest).addImm(MaskImm);
  }
  else{
  BuildMI(BB, DL, TII->get(LoongArch::ORI32), MaskUpper)
    .addReg(LoongArch::ZERO).addImm(MaskImm);
  }

  BuildMI(BB, DL, TII->get(LoongArch::SLL_W), Mask)
    .addReg(MaskUpper).addReg(ShiftAmt);
  BuildMI(BB, DL, TII->get(LoongArch::NOR32), Mask2).addReg(LoongArch::ZERO).addReg(Mask);
  BuildMI(BB, DL, TII->get(LoongArch::SLL_W), Incr2).addReg(Incr).addReg(ShiftAmt);


  // The purposes of the flags on the scratch registers is explained in
  // emitAtomicBinary. In summary, we need a scratch register which is going to
  // be undef, that is unique among registers chosen for the instruction.

  BuildMI(BB, DL, TII->get(LoongArch::DBAR)).addImm(0);
  BuildMI(BB, DL, TII->get(AtomicOp))
      .addReg(Dest, RegState::Define | RegState::EarlyClobber)
      .addReg(AlignedAddr)
      .addReg(Incr2)
      .addReg(Mask)
      .addReg(Mask2)
      .addReg(ShiftAmt)
      .addReg(Scratch, RegState::EarlyClobber | RegState::Define |
                           RegState::Dead | RegState::Implicit)
      .addReg(Scratch2, RegState::EarlyClobber | RegState::Define |
                            RegState::Dead | RegState::Implicit)
      .addReg(Scratch3, RegState::EarlyClobber | RegState::Define |
                            RegState::Dead | RegState::Implicit)
      .addReg(Scratch4, RegState::EarlyClobber | RegState::Define |
                            RegState::Dead | RegState::Implicit)
      .addReg(Scratch5, RegState::EarlyClobber | RegState::Define |
                            RegState::Dead | RegState::Implicit);


  MI.eraseFromParent(); // The instruction is gone now.

  return exitMBB;
}

// Lower atomic compare and swap to a pseudo instruction, taking care to
// define a scratch register for the pseudo instruction's expansion. The
// instruction is expanded after the register allocator as to prevent
// the insertion of stores between the linked load and the store conditional.

MachineBasicBlock *
LoongArchTargetLowering::emitAtomicCmpSwap(MachineInstr &MI,
                                      MachineBasicBlock *BB) const {
  assert((MI.getOpcode() == LoongArch::ATOMIC_CMP_SWAP_I32 ||
          MI.getOpcode() == LoongArch::ATOMIC_CMP_SWAP_I64) &&
         "Unsupported atomic psseudo for EmitAtomicCmpSwap.");

  const unsigned Size = MI.getOpcode() == LoongArch::ATOMIC_CMP_SWAP_I32 ? 4 : 8;

  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &MRI = MF->getRegInfo();
  const TargetRegisterClass *RC = getRegClassFor(MVT::getIntegerVT(Size * 8));
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();

  unsigned AtomicOp = MI.getOpcode() == LoongArch::ATOMIC_CMP_SWAP_I32
                          ? LoongArch::ATOMIC_CMP_SWAP_I32_POSTRA
                          : LoongArch::ATOMIC_CMP_SWAP_I64_POSTRA;
  unsigned Dest = MI.getOperand(0).getReg();
  unsigned Ptr = MI.getOperand(1).getReg();
  unsigned OldVal = MI.getOperand(2).getReg();
  unsigned NewVal = MI.getOperand(3).getReg();

  unsigned Scratch = MRI.createVirtualRegister(RC);
  MachineBasicBlock::iterator II(MI);

  // We need to create copies of the various registers and kill them at the
  // atomic pseudo. If the copies are not made, when the atomic is expanded
  // after fast register allocation, the spills will end up outside of the
  // blocks that their values are defined in, causing livein errors.

  unsigned PtrCopy = MRI.createVirtualRegister(MRI.getRegClass(Ptr));
  unsigned OldValCopy = MRI.createVirtualRegister(MRI.getRegClass(OldVal));
  unsigned NewValCopy = MRI.createVirtualRegister(MRI.getRegClass(NewVal));

  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), PtrCopy).addReg(Ptr);
  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), OldValCopy).addReg(OldVal);
  BuildMI(*BB, II, DL, TII->get(LoongArch::COPY), NewValCopy).addReg(NewVal);

  // The purposes of the flags on the scratch registers is explained in
  // emitAtomicBinary. In summary, we need a scratch register which is going to
  // be undef, that is unique among registers chosen for the instruction.

  BuildMI(*BB, II, DL, TII->get(LoongArch::DBAR)).addImm(0);
  BuildMI(*BB, II, DL, TII->get(AtomicOp))
      .addReg(Dest, RegState::Define | RegState::EarlyClobber)
      .addReg(PtrCopy, RegState::Kill)
      .addReg(OldValCopy, RegState::Kill)
      .addReg(NewValCopy, RegState::Kill)
      .addReg(Scratch, RegState::EarlyClobber | RegState::Define |
                           RegState::Dead | RegState::Implicit);

  BuildMI(*BB, II, DL, TII->get(LoongArch::DBAR)).addImm(DBAR_HINT);

  MI.eraseFromParent(); // The instruction is gone now.

  return BB;
}

MachineBasicBlock *LoongArchTargetLowering::emitAtomicCmpSwapPartword(
    MachineInstr &MI, MachineBasicBlock *BB, unsigned Size) const {
  assert((Size == 1 || Size == 2) &&
      "Unsupported size for EmitAtomicCmpSwapPartial.");

  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &RegInfo = MF->getRegInfo();
  const TargetRegisterClass *RC = getRegClassFor(MVT::i32);
  const bool ArePtrs64bit = ABI.ArePtrs64bit();
  const TargetRegisterClass *RCp =
    getRegClassFor(ArePtrs64bit ? MVT::i64 : MVT::i32);
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();

  unsigned Dest = MI.getOperand(0).getReg();
  unsigned Ptr = MI.getOperand(1).getReg();
  unsigned CmpVal = MI.getOperand(2).getReg();
  unsigned NewVal = MI.getOperand(3).getReg();

  unsigned AlignedAddr = RegInfo.createVirtualRegister(RCp);
  unsigned ShiftAmt = RegInfo.createVirtualRegister(RC);
  unsigned Mask = RegInfo.createVirtualRegister(RC);
  unsigned Mask2 = RegInfo.createVirtualRegister(RC);
  unsigned ShiftedCmpVal = RegInfo.createVirtualRegister(RC);
  unsigned ShiftedNewVal = RegInfo.createVirtualRegister(RC);
  unsigned MaskLSB2 = RegInfo.createVirtualRegister(RCp);
  unsigned PtrLSB2 = RegInfo.createVirtualRegister(RC);
  unsigned MaskUpper = RegInfo.createVirtualRegister(RC);
  unsigned MaskUppest = RegInfo.createVirtualRegister(RC);
  unsigned Mask3 = RegInfo.createVirtualRegister(RC);
  unsigned MaskedCmpVal = RegInfo.createVirtualRegister(RC);
  unsigned MaskedNewVal = RegInfo.createVirtualRegister(RC);
  unsigned AtomicOp = MI.getOpcode() == LoongArch::ATOMIC_CMP_SWAP_I8
                          ? LoongArch::ATOMIC_CMP_SWAP_I8_POSTRA
                          : LoongArch::ATOMIC_CMP_SWAP_I16_POSTRA;

  // The scratch registers here with the EarlyClobber | Define | Dead | Implicit
  // flags are used to coerce the register allocator and the machine verifier to
  // accept the usage of these registers.
  // The EarlyClobber flag has the semantic properties that the operand it is
  // attached to is clobbered before the rest of the inputs are read. Hence it
  // must be unique among the operands to the instruction.
  // The Define flag is needed to coerce the machine verifier that an Undef
  // value isn't a problem.
  // The Dead flag is needed as the value in scratch isn't used by any other
  // instruction. Kill isn't used as Dead is more precise.
  unsigned Scratch = RegInfo.createVirtualRegister(RC);
  unsigned Scratch2 = RegInfo.createVirtualRegister(RC);

  // insert new blocks after the current block
  const BasicBlock *LLVM_BB = BB->getBasicBlock();
  MachineBasicBlock *exitMBB = MF->CreateMachineBasicBlock(LLVM_BB);
  MachineFunction::iterator It = ++BB->getIterator();
  MF->insert(It, exitMBB);

  // Transfer the remainder of BB and its successor edges to exitMBB.
  exitMBB->splice(exitMBB->begin(), BB,
                  std::next(MachineBasicBlock::iterator(MI)), BB->end());
  exitMBB->transferSuccessorsAndUpdatePHIs(BB);

  BB->addSuccessor(exitMBB, BranchProbability::getOne());

  //  thisMBB:
  //    addiu   masklsb2,$0,-4                # 0xfffffffc
  //    and     alignedaddr,ptr,masklsb2
  //    andi    ptrlsb2,ptr,3
  //    xori    ptrlsb2,ptrlsb2,3              # Only for BE
  //    sll     shiftamt,ptrlsb2,3
  //    ori     maskupper,$0,255               # 0xff
  //    sll     mask,maskupper,shiftamt
  //    nor     mask2,$0,mask
  //    andi    maskedcmpval,cmpval,255
  //    sll     shiftedcmpval,maskedcmpval,shiftamt
  //    andi    maskednewval,newval,255
  //    sll     shiftednewval,maskednewval,shiftamt


  int64_t MaskImm = (Size == 1) ? 255 : 4095;
  BuildMI(BB, DL, TII->get(ArePtrs64bit ? LoongArch::ADDI_D : LoongArch::ADDI_W), MaskLSB2)
    .addReg(ABI.GetNullPtr()).addImm(-4);
  BuildMI(BB, DL, TII->get(ArePtrs64bit ? LoongArch::AND : LoongArch::AND32), AlignedAddr)
    .addReg(Ptr).addReg(MaskLSB2);
  BuildMI(BB, DL, TII->get(LoongArch::ANDI32), PtrLSB2)
      .addReg(Ptr, 0, ArePtrs64bit ? LoongArch::sub_32 : 0).addImm(3);
  BuildMI(BB, DL, TII->get(LoongArch::SLLI_W), ShiftAmt).addReg(PtrLSB2).addImm(3);

  if(MaskImm==4095){
  BuildMI(BB, DL, TII->get(LoongArch::LU12I_W32), MaskUppest).addImm(0xf);
  BuildMI(BB, DL, TII->get(LoongArch::ORI32), MaskUpper)
    .addReg(MaskUppest).addImm(MaskImm);
  }
  else{
  BuildMI(BB, DL, TII->get(LoongArch::ORI32), MaskUpper)
    .addReg(LoongArch::ZERO).addImm(MaskImm);
  }

  BuildMI(BB, DL, TII->get(LoongArch::SLL_W), Mask)
    .addReg(MaskUpper).addReg(ShiftAmt);
  BuildMI(BB, DL, TII->get(LoongArch::NOR32), Mask2).addReg(LoongArch::ZERO).addReg(Mask);
  if(MaskImm==4095){
    BuildMI(BB, DL, TII->get(LoongArch::ORI32), Mask3)
    .addReg(MaskUppest).addImm(MaskImm);
    BuildMI(BB, DL, TII->get(LoongArch::AND32), MaskedCmpVal)
      .addReg(CmpVal).addReg(Mask3);
    BuildMI(BB, DL, TII->get(LoongArch::SLL_W), ShiftedCmpVal)
      .addReg(MaskedCmpVal).addReg(ShiftAmt);
    BuildMI(BB, DL, TII->get(LoongArch::AND32), MaskedNewVal)
      .addReg(NewVal).addReg(Mask3);
  }
  else{
    BuildMI(BB, DL, TII->get(LoongArch::ANDI32), MaskedCmpVal)
      .addReg(CmpVal).addImm(MaskImm);
    BuildMI(BB, DL, TII->get(LoongArch::SLL_W), ShiftedCmpVal)
      .addReg(MaskedCmpVal).addReg(ShiftAmt);
    BuildMI(BB, DL, TII->get(LoongArch::ANDI32), MaskedNewVal)
      .addReg(NewVal).addImm(MaskImm);
  }
  BuildMI(BB, DL, TII->get(LoongArch::SLL_W), ShiftedNewVal)
    .addReg(MaskedNewVal).addReg(ShiftAmt);

  // The purposes of the flags on the scratch registers are explained in
  // emitAtomicBinary. In summary, we need a scratch register which is going to
  // be undef, that is unique among the register chosen for the instruction.

  BuildMI(BB, DL, TII->get(LoongArch::DBAR)).addImm(0);
  BuildMI(BB, DL, TII->get(AtomicOp))
      .addReg(Dest, RegState::Define | RegState::EarlyClobber)
      .addReg(AlignedAddr)
      .addReg(Mask)
      .addReg(ShiftedCmpVal)
      .addReg(Mask2)
      .addReg(ShiftedNewVal)
      .addReg(ShiftAmt)
      .addReg(Scratch, RegState::EarlyClobber | RegState::Define |
                           RegState::Dead | RegState::Implicit)
      .addReg(Scratch2, RegState::EarlyClobber | RegState::Define |
                            RegState::Dead | RegState::Implicit);


  MI.eraseFromParent(); // The instruction is gone now.

  return exitMBB;
}

SDValue LoongArchTargetLowering::lowerBRCOND(SDValue Op, SelectionDAG &DAG) const {
  // The first operand is the chain, the second is the condition, the third is
  // the block to branch to if the condition is true.
  SDValue Chain = Op.getOperand(0);
  SDValue Dest = Op.getOperand(2);
  SDLoc DL(Op);

  SDValue CondRes = createFPCmp(DAG, Op.getOperand(1));

  // Return if flag is not set by a floating point comparison.
  if (CondRes.getOpcode() != LoongArchISD::FPCmp)
    return Op;

  SDValue CCNode  = CondRes.getOperand(2);
  LoongArch::CondCode CC =
    (LoongArch::CondCode)cast<ConstantSDNode>(CCNode)->getZExtValue();
  unsigned Opc = invertFPCondCodeUser(CC) ? LoongArch::BRANCH_F : LoongArch::BRANCH_T;
  SDValue BrCode = DAG.getConstant(Opc, DL, MVT::i32);
  SDValue FCC0 = DAG.getRegister(LoongArch::FCC0, MVT::i32);
  return DAG.getNode(LoongArchISD::FPBrcond, DL, Op.getValueType(), Chain, BrCode,
                     FCC0, Dest, CondRes);
}

SDValue LoongArchTargetLowering::lowerSELECT(SDValue Op,
                                             SelectionDAG &DAG) const {
  SDValue Cond = createFPCmp(DAG, Op.getOperand(0));

  // Return if flag is not set by a floating point comparison.
  if (Cond.getOpcode() != LoongArchISD::FPCmp)
    return Op;

  SDValue N1 = Op.getOperand(1);
  SDValue N2 = Op.getOperand(2);
  SDLoc DL(Op);

  ConstantSDNode *CC = cast<ConstantSDNode>(Cond.getOperand(2));
  bool invert = invertFPCondCodeUser((LoongArch::CondCode)CC->getSExtValue());
  SDValue FCC = DAG.getRegister(LoongArch::FCC0, MVT::i32);

  if (Op->getSimpleValueType(0).SimpleTy == MVT::f64 ||
      Op->getSimpleValueType(0).SimpleTy == MVT::f32) {
    if (invert)
      return DAG.getNode(LoongArchISD::FSEL, DL, N1.getValueType(), N1, FCC, N2,
                         Cond);
    else
      return DAG.getNode(LoongArchISD::FSEL, DL, N1.getValueType(), N2, FCC, N1,
                         Cond);

  } else
    return Op;
}

SDValue LoongArchTargetLowering::lowerSETCC(SDValue Op, SelectionDAG &DAG) const {
  SDValue Cond = createFPCmp(DAG, Op);

  assert(Cond.getOpcode() == LoongArchISD::FPCmp &&
         "Floating point operand expected.");

  SDLoc DL(Op);
  SDValue True  = DAG.getConstant(1, DL, MVT::i32);
  SDValue False = DAG.getConstant(0, DL, MVT::i32);

  return createCMovFP(DAG, Cond, True, False, DL);
}

SDValue LoongArchTargetLowering::lowerGlobalAddress(SDValue Op,
                                               SelectionDAG &DAG) const {
  GlobalAddressSDNode *N = cast<GlobalAddressSDNode>(Op);

  const GlobalValue *GV = N->getGlobal();
  bool IsLocal = getTargetMachine().shouldAssumeDSOLocal(*GV->getParent(), GV);
  SDValue Addr = getAddr(N, DAG, IsLocal);

  return Addr;
}

SDValue LoongArchTargetLowering::lowerBlockAddress(SDValue Op,
                                              SelectionDAG &DAG) const {
  BlockAddressSDNode *N = cast<BlockAddressSDNode>(Op);

  return getAddr(N, DAG);
}

SDValue LoongArchTargetLowering::
lowerGlobalTLSAddress(SDValue Op, SelectionDAG &DAG) const
{
  GlobalAddressSDNode *GA = cast<GlobalAddressSDNode>(Op);
  if (DAG.getTarget().useEmulatedTLS())
    return LowerToTLSEmulatedModel(GA, DAG);

  SDLoc DL(GA);
  const GlobalValue *GV = GA->getGlobal();
  EVT PtrVT = getPointerTy(DAG.getDataLayout());

  TLSModel::Model model = getTargetMachine().getTLSModel(GV);

  if (model == TLSModel::GeneralDynamic || model == TLSModel::LocalDynamic) {
    // General Dynamic TLS Model && Local Dynamic TLS Model
    unsigned PtrSize = PtrVT.getSizeInBits();
    IntegerType *PtrTy = Type::getIntNTy(*DAG.getContext(), PtrSize);
    //  SDValue Addr = DAG.getTargetGlobalAddress(GV, DL, PtrTy, 0, 0);
    SDValue Addr = DAG.getTargetGlobalAddress(GV, DL, PtrVT, 0, 0U);
    SDValue Load = SDValue(DAG.getMachineNode(LoongArch::LoadAddrTLS_GD ,
                           DL, PtrVT, Addr), 0);
    SDValue TlsGetAddr = DAG.getExternalSymbol("__tls_get_addr", PtrVT);

    ArgListTy Args;
    ArgListEntry Entry;
    Entry.Node = Load;
    Entry.Ty = PtrTy;
    Args.push_back(Entry);

    TargetLowering::CallLoweringInfo CLI(DAG);
    CLI.setDebugLoc(DL)
       .setChain(DAG.getEntryNode())
       .setLibCallee(CallingConv::C, PtrTy, TlsGetAddr, std::move(Args));
    std::pair<SDValue, SDValue> CallResult = LowerCallTo(CLI);

    SDValue Ret = CallResult.first;

    return Ret;
  }

  SDValue Addr = DAG.getTargetGlobalAddress(GV, DL, PtrVT, 0, 0U);
  SDValue Offset;
  if (model == TLSModel::InitialExec) {
    // Initial Exec TLS Model
    Offset = SDValue(DAG.getMachineNode(LoongArch::LoadAddrTLS_IE, DL,
                     PtrVT, Addr), 0);
  } else {
    // Local Exec TLS Model
    assert(model == TLSModel::LocalExec);
    Offset = SDValue(DAG.getMachineNode(LoongArch::LoadAddrTLS_LE, DL,
                     PtrVT, Addr), 0);
  }

  SDValue ThreadPointer = DAG.getRegister((PtrVT == MVT::i32)
                                          ? LoongArch::TP
                                          : LoongArch::TP_64, PtrVT);
  return DAG.getNode(ISD::ADD, DL, PtrVT, ThreadPointer, Offset);
}

SDValue LoongArchTargetLowering::
lowerJumpTable(SDValue Op, SelectionDAG &DAG) const
{
  JumpTableSDNode *N = cast<JumpTableSDNode>(Op);

  return getAddr(N, DAG);
}

SDValue LoongArchTargetLowering::
lowerConstantPool(SDValue Op, SelectionDAG &DAG) const
{
  ConstantPoolSDNode *N = cast<ConstantPoolSDNode>(Op);

  return getAddr(N, DAG);
}

SDValue LoongArchTargetLowering::lowerVASTART(SDValue Op, SelectionDAG &DAG) const {
  MachineFunction &MF = DAG.getMachineFunction();
  LoongArchFunctionInfo *FuncInfo = MF.getInfo<LoongArchFunctionInfo>();

  SDLoc DL(Op);
  SDValue FI = DAG.getFrameIndex(FuncInfo->getVarArgsFrameIndex(),
                                 getPointerTy(MF.getDataLayout()));

  // vastart just stores the address of the VarArgsFrameIndex slot into the
  // memory location argument.
  const Value *SV = cast<SrcValueSDNode>(Op.getOperand(2))->getValue();
  return DAG.getStore(Op.getOperand(0), DL, FI, Op.getOperand(1),
                      MachinePointerInfo(SV));
}

SDValue LoongArchTargetLowering::lowerVAARG(SDValue Op, SelectionDAG &DAG) const {
  SDNode *Node = Op.getNode();
  EVT VT = Node->getValueType(0);
  SDValue Chain = Node->getOperand(0);
  SDValue VAListPtr = Node->getOperand(1);
  const Align Align =
      llvm::MaybeAlign(Node->getConstantOperandVal(3)).valueOrOne();
  const Value *SV = cast<SrcValueSDNode>(Node->getOperand(2))->getValue();
  SDLoc DL(Node);
  unsigned ArgSlotSizeInBytes = (ABI.IsLPX32() || ABI.IsLP64()) ? 8 : 4;

  SDValue VAListLoad = DAG.getLoad(getPointerTy(DAG.getDataLayout()), DL, Chain,
                                   VAListPtr, MachinePointerInfo(SV));
  SDValue VAList = VAListLoad;

  // Re-align the pointer if necessary.
  // It should only ever be necessary for 64-bit types on LP32 since the minimum
  // argument alignment is the same as the maximum type alignment for LPX32/LP64.
  //
  // FIXME: We currently align too often. The code generator doesn't notice
  //        when the pointer is still aligned from the last va_arg (or pair of
  //        va_args for the i64 on LP32 case).
  if (Align > getMinStackArgumentAlignment()) {
    VAList = DAG.getNode(
        ISD::ADD, DL, VAList.getValueType(), VAList,
        DAG.getConstant(Align.value() - 1, DL, VAList.getValueType()));

    VAList = DAG.getNode(
        ISD::AND, DL, VAList.getValueType(), VAList,
        DAG.getConstant(-(int64_t)Align.value(), DL, VAList.getValueType()));
  }

  // Increment the pointer, VAList, to the next vaarg.
  auto &TD = DAG.getDataLayout();
  unsigned ArgSizeInBytes =
      TD.getTypeAllocSize(VT.getTypeForEVT(*DAG.getContext()));
  SDValue Tmp3 =
      DAG.getNode(ISD::ADD, DL, VAList.getValueType(), VAList,
                  DAG.getConstant(alignTo(ArgSizeInBytes, ArgSlotSizeInBytes),
                                  DL, VAList.getValueType()));
  // Store the incremented VAList to the legalized pointer
  Chain = DAG.getStore(VAListLoad.getValue(1), DL, Tmp3, VAListPtr,
                       MachinePointerInfo(SV));

  // Load the actual argument out of the pointer VAList
  return DAG.getLoad(VT, DL, Chain, VAList, MachinePointerInfo());
}

SDValue LoongArchTargetLowering::
lowerFRAMEADDR(SDValue Op, SelectionDAG &DAG) const {
  // check the depth
  assert((cast<ConstantSDNode>(Op.getOperand(0))->getZExtValue() == 0) &&
         "Frame address can only be determined for current frame.");

  MachineFrameInfo &MFI = DAG.getMachineFunction().getFrameInfo();
  MFI.setFrameAddressIsTaken(true);
  EVT VT = Op.getValueType();
  SDLoc DL(Op);
  SDValue FrameAddr = DAG.getCopyFromReg(
      DAG.getEntryNode(), DL, ABI.IsLP64() ? LoongArch::FP_64 : LoongArch::FP, VT);
  return FrameAddr;
}

SDValue LoongArchTargetLowering::lowerRETURNADDR(SDValue Op,
                                            SelectionDAG &DAG) const {
  if (verifyReturnAddressArgumentIsConstant(Op, DAG))
    return SDValue();

  // check the depth
  assert((cast<ConstantSDNode>(Op.getOperand(0))->getZExtValue() == 0) &&
         "Return address can be determined only for current frame.");

  MachineFunction &MF = DAG.getMachineFunction();
  MachineFrameInfo &MFI = MF.getFrameInfo();
  MVT VT = Op.getSimpleValueType();
  unsigned RA = ABI.IsLP64() ? LoongArch::RA_64 : LoongArch::RA;
  MFI.setReturnAddressIsTaken(true);

  // Return RA, which contains the return address. Mark it an implicit live-in.
  unsigned Reg = MF.addLiveIn(RA, getRegClassFor(VT));
  return DAG.getCopyFromReg(DAG.getEntryNode(), SDLoc(Op), Reg, VT);
}

// An EH_RETURN is the result of lowering llvm.eh.return which in turn is
// generated from __builtin_eh_return (offset, handler)
// The effect of this is to adjust the stack pointer by "offset"
// and then branch to "handler".
SDValue LoongArchTargetLowering::lowerEH_RETURN(SDValue Op, SelectionDAG &DAG)
                                                                     const {
  MachineFunction &MF = DAG.getMachineFunction();
  LoongArchFunctionInfo *LoongArchFI = MF.getInfo<LoongArchFunctionInfo>();

  LoongArchFI->setCallsEhReturn();
  SDValue Chain     = Op.getOperand(0);
  SDValue Offset    = Op.getOperand(1);
  SDValue Handler   = Op.getOperand(2);
  SDLoc DL(Op);
  EVT Ty = ABI.IsLP64() ? MVT::i64 : MVT::i32;

  // Store stack offset in A1, store jump target in A0. Glue CopyToReg and
  // EH_RETURN nodes, so that instructions are emitted back-to-back.
  unsigned OffsetReg = ABI.IsLP64() ? LoongArch::A1_64 : LoongArch::A1;
  unsigned AddrReg = ABI.IsLP64() ? LoongArch::A0_64 : LoongArch::A0;
  Chain = DAG.getCopyToReg(Chain, DL, OffsetReg, Offset, SDValue());
  Chain = DAG.getCopyToReg(Chain, DL, AddrReg, Handler, Chain.getValue(1));
  return DAG.getNode(LoongArchISD::EH_RETURN, DL, MVT::Other, Chain,
                     DAG.getRegister(OffsetReg, Ty),
                     DAG.getRegister(AddrReg, getPointerTy(MF.getDataLayout())),
                     Chain.getValue(1));
}

SDValue LoongArchTargetLowering::lowerATOMIC_FENCE(SDValue Op,
                                              SelectionDAG &DAG) const {
  // FIXME: Need pseudo-fence for 'singlethread' fences
  // FIXME: Set SType for weaker fences where supported/appropriate.
  unsigned SType = 0;
  SDLoc DL(Op);
  return DAG.getNode(LoongArchISD::DBAR, DL, MVT::Other, Op.getOperand(0),
                     DAG.getConstant(SType, DL, MVT::i32));
}

SDValue LoongArchTargetLowering::lowerShiftLeftParts(SDValue Op,
                                                SelectionDAG &DAG) const {
  SDLoc DL(Op);
  MVT VT = Subtarget.is64Bit() ? MVT::i64 : MVT::i32;

  SDValue Lo = Op.getOperand(0), Hi = Op.getOperand(1);
  SDValue Shamt = Op.getOperand(2);
  // if shamt < (VT.bits):
  //  lo = (shl lo, shamt)
  //  hi = (or (shl hi, shamt) (srl (srl lo, 1), ~shamt))
  // else:
  //  lo = 0
  //  hi = (shl lo, shamt[4:0])
  SDValue Not = DAG.getNode(ISD::XOR, DL, MVT::i32, Shamt,
                            DAG.getConstant(-1, DL, MVT::i32));
  SDValue ShiftRight1Lo = DAG.getNode(ISD::SRL, DL, VT, Lo,
                                      DAG.getConstant(1, DL, VT));
  SDValue ShiftRightLo = DAG.getNode(ISD::SRL, DL, VT, ShiftRight1Lo, Not);
  SDValue ShiftLeftHi = DAG.getNode(ISD::SHL, DL, VT, Hi, Shamt);
  SDValue Or = DAG.getNode(ISD::OR, DL, VT, ShiftLeftHi, ShiftRightLo);
  SDValue ShiftLeftLo = DAG.getNode(ISD::SHL, DL, VT, Lo, Shamt);
  SDValue Cond = DAG.getNode(ISD::AND, DL, MVT::i32, Shamt,
                             DAG.getConstant(VT.getSizeInBits(), DL, MVT::i32));
  Lo = DAG.getNode(ISD::SELECT, DL, VT, Cond,
                   DAG.getConstant(0, DL, VT), ShiftLeftLo);
  Hi = DAG.getNode(ISD::SELECT, DL, VT, Cond, ShiftLeftLo, Or);

  SDValue Ops[2] = {Lo, Hi};
  return DAG.getMergeValues(Ops, DL);
}

SDValue LoongArchTargetLowering::lowerShiftRightParts(SDValue Op, SelectionDAG &DAG,
                                                 bool IsSRA) const {
  SDLoc DL(Op);
  SDValue Lo = Op.getOperand(0), Hi = Op.getOperand(1);
  SDValue Shamt = Op.getOperand(2);
  MVT VT = Subtarget.is64Bit() ? MVT::i64 : MVT::i32;

  // if shamt < (VT.bits):
  //  lo = (or (shl (shl hi, 1), ~shamt) (srl lo, shamt))
  //  if isSRA:
  //    hi = (sra hi, shamt)
  //  else:
  //    hi = (srl hi, shamt)
  // else:
  //  if isSRA:
  //   lo = (sra hi, shamt[4:0])
  //   hi = (sra hi, 31)
  //  else:
  //   lo = (srl hi, shamt[4:0])
  //   hi = 0
  SDValue Not = DAG.getNode(ISD::XOR, DL, MVT::i32, Shamt,
                            DAG.getConstant(-1, DL, MVT::i32));
  SDValue ShiftLeft1Hi = DAG.getNode(ISD::SHL, DL, VT, Hi,
                                     DAG.getConstant(1, DL, VT));
  SDValue ShiftLeftHi = DAG.getNode(ISD::SHL, DL, VT, ShiftLeft1Hi, Not);
  SDValue ShiftRightLo = DAG.getNode(ISD::SRL, DL, VT, Lo, Shamt);
  SDValue Or = DAG.getNode(ISD::OR, DL, VT, ShiftLeftHi, ShiftRightLo);
  SDValue ShiftRightHi = DAG.getNode(IsSRA ? ISD::SRA : ISD::SRL,
                                     DL, VT, Hi, Shamt);
  SDValue Cond = DAG.getNode(ISD::AND, DL, MVT::i32, Shamt,
                             DAG.getConstant(VT.getSizeInBits(), DL, MVT::i32));
  SDValue Ext = DAG.getNode(ISD::SRA, DL, VT, Hi,
                            DAG.getConstant(VT.getSizeInBits() - 1, DL, VT));
  Lo = DAG.getNode(ISD::SELECT, DL, VT, Cond, ShiftRightHi, Or);
  Hi = DAG.getNode(ISD::SELECT, DL, VT, Cond,
                   IsSRA ? Ext : DAG.getConstant(0, DL, VT), ShiftRightHi);

  SDValue Ops[2] = {Lo, Hi};
  return DAG.getMergeValues(Ops, DL);
}

// Lower (store (fp_to_sint $fp) $ptr) to (store (TruncIntFP $fp), $ptr).
static SDValue lowerFP_TO_SINT_STORE(StoreSDNode *SD, SelectionDAG &DAG,
                                     bool SingleFloat) {
  SDValue Val = SD->getValue();

  if (Val.getOpcode() != ISD::FP_TO_SINT ||
      (Val.getValueSizeInBits() > 32 && SingleFloat))
    return SDValue();

  EVT FPTy = EVT::getFloatingPointVT(Val.getValueSizeInBits());
  SDValue Tr = DAG.getNode(LoongArchISD::TruncIntFP, SDLoc(Val), FPTy,
                           Val.getOperand(0));
  return DAG.getStore(SD->getChain(), SDLoc(SD), Tr, SD->getBasePtr(),
                      SD->getPointerInfo(), SD->getAlignment(),
                      SD->getMemOperand()->getFlags());
}

SDValue LoongArchTargetLowering::lowerSTORE(SDValue Op, SelectionDAG &DAG) const {
  StoreSDNode *SD = cast<StoreSDNode>(Op);
  return lowerFP_TO_SINT_STORE(SD, DAG, Subtarget.isSingleFloat());
}

SDValue LoongArchTargetLowering::lowerINTRINSIC_WO_CHAIN(SDValue Op,
                                                      SelectionDAG &DAG) const {
  SDLoc DL(Op);
  unsigned Intrinsic = cast<ConstantSDNode>(Op->getOperand(0))->getZExtValue();
  switch (Intrinsic) {
  default:
    return SDValue();
  case Intrinsic::loongarch_lsx_vaddi_bu:
  case Intrinsic::loongarch_lsx_vaddi_hu:
  case Intrinsic::loongarch_lsx_vaddi_wu:
  case Intrinsic::loongarch_lsx_vaddi_du:
    return DAG.getNode(ISD::ADD, DL, Op->getValueType(0), Op->getOperand(1),
                       lowerLSXSplatImm(Op, 2, DAG));
  case Intrinsic::loongarch_lsx_vand_v:
  case Intrinsic::loongarch_lasx_xvand_v:
    return DAG.getNode(ISD::AND, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vbitclr_b:
  case Intrinsic::loongarch_lsx_vbitclr_h:
  case Intrinsic::loongarch_lsx_vbitclr_w:
  case Intrinsic::loongarch_lsx_vbitclr_d:
    return lowerLSXBitClear(Op, DAG);
  case Intrinsic::loongarch_lsx_vdiv_b:
  case Intrinsic::loongarch_lsx_vdiv_h:
  case Intrinsic::loongarch_lsx_vdiv_w:
  case Intrinsic::loongarch_lsx_vdiv_d:
    return DAG.getNode(ISD::SDIV, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vdiv_bu:
  case Intrinsic::loongarch_lsx_vdiv_hu:
  case Intrinsic::loongarch_lsx_vdiv_wu:
  case Intrinsic::loongarch_lsx_vdiv_du:
    return DAG.getNode(ISD::UDIV, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vfdiv_s:
  case Intrinsic::loongarch_lsx_vfdiv_d:
    return DAG.getNode(ISD::FDIV, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vffint_s_wu:
  case Intrinsic::loongarch_lsx_vffint_d_lu:
    return DAG.getNode(ISD::UINT_TO_FP, DL, Op->getValueType(0),
                       Op->getOperand(1));
  case Intrinsic::loongarch_lsx_vffint_s_w:
  case Intrinsic::loongarch_lsx_vffint_d_l:
    return DAG.getNode(ISD::SINT_TO_FP, DL, Op->getValueType(0),
                       Op->getOperand(1));
  case Intrinsic::loongarch_lsx_vfmul_s:
  case Intrinsic::loongarch_lsx_vfmul_d:
    return DAG.getNode(ISD::FMUL, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vfrint_s:
  case Intrinsic::loongarch_lsx_vfrint_d:
    return DAG.getNode(ISD::FRINT, DL, Op->getValueType(0), Op->getOperand(1));
  case Intrinsic::loongarch_lsx_vfsqrt_s:
  case Intrinsic::loongarch_lsx_vfsqrt_d:
    return DAG.getNode(ISD::FSQRT, DL, Op->getValueType(0), Op->getOperand(1));
  case Intrinsic::loongarch_lsx_vftintrz_wu_s:
  case Intrinsic::loongarch_lsx_vftintrz_lu_d:
    return DAG.getNode(ISD::FP_TO_UINT, DL, Op->getValueType(0),
                       Op->getOperand(1));
  case Intrinsic::loongarch_lsx_vpackev_b:
  case Intrinsic::loongarch_lsx_vpackev_h:
  case Intrinsic::loongarch_lsx_vpackev_w:
  case Intrinsic::loongarch_lsx_vpackev_d:
    return DAG.getNode(LoongArchISD::VPACKEV, DL, Op->getValueType(0),
                       Op->getOperand(1), Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vilvh_b:
  case Intrinsic::loongarch_lsx_vilvh_h:
  case Intrinsic::loongarch_lsx_vilvh_w:
  case Intrinsic::loongarch_lsx_vilvh_d:
    return DAG.getNode(LoongArchISD::VILVH, DL, Op->getValueType(0),
                       Op->getOperand(1), Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vpackod_b:
  case Intrinsic::loongarch_lsx_vpackod_h:
  case Intrinsic::loongarch_lsx_vpackod_w:
  case Intrinsic::loongarch_lsx_vpackod_d:
    return DAG.getNode(LoongArchISD::VPACKOD, DL, Op->getValueType(0),
                       Op->getOperand(1), Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vilvl_b:
  case Intrinsic::loongarch_lsx_vilvl_h:
  case Intrinsic::loongarch_lsx_vilvl_w:
  case Intrinsic::loongarch_lsx_vilvl_d:
    return DAG.getNode(LoongArchISD::VILVL, DL, Op->getValueType(0),
                       Op->getOperand(1), Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vmadd_b:
  case Intrinsic::loongarch_lsx_vmadd_h:
  case Intrinsic::loongarch_lsx_vmadd_w:
  case Intrinsic::loongarch_lsx_vmadd_d: {
    EVT ResTy = Op->getValueType(0);
    return DAG.getNode(ISD::ADD, SDLoc(Op), ResTy, Op->getOperand(1),
                       DAG.getNode(ISD::MUL, SDLoc(Op), ResTy,
                                   Op->getOperand(2), Op->getOperand(3)));
  }
  case Intrinsic::loongarch_lsx_vmax_b:
  case Intrinsic::loongarch_lsx_vmax_h:
  case Intrinsic::loongarch_lsx_vmax_w:
  case Intrinsic::loongarch_lsx_vmax_d:
    return DAG.getNode(ISD::SMAX, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vmax_bu:
  case Intrinsic::loongarch_lsx_vmax_hu:
  case Intrinsic::loongarch_lsx_vmax_wu:
  case Intrinsic::loongarch_lsx_vmax_du:
    return DAG.getNode(ISD::UMAX, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vmin_b:
  case Intrinsic::loongarch_lsx_vmin_h:
  case Intrinsic::loongarch_lsx_vmin_w:
  case Intrinsic::loongarch_lsx_vmin_d:
    return DAG.getNode(ISD::SMIN, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vmin_bu:
  case Intrinsic::loongarch_lsx_vmin_hu:
  case Intrinsic::loongarch_lsx_vmin_wu:
  case Intrinsic::loongarch_lsx_vmin_du:
    return DAG.getNode(ISD::UMIN, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vmini_bu:
  case Intrinsic::loongarch_lsx_vmini_hu:
  case Intrinsic::loongarch_lsx_vmini_wu:
  case Intrinsic::loongarch_lsx_vmini_du:
    return DAG.getNode(ISD::UMIN, DL, Op->getValueType(0), Op->getOperand(1),
                       lowerLSXSplatImm(Op, 2, DAG));
  case Intrinsic::loongarch_lsx_vmod_b:
  case Intrinsic::loongarch_lsx_vmod_h:
  case Intrinsic::loongarch_lsx_vmod_w:
  case Intrinsic::loongarch_lsx_vmod_d:
    return DAG.getNode(ISD::SREM, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vmod_bu:
  case Intrinsic::loongarch_lsx_vmod_hu:
  case Intrinsic::loongarch_lsx_vmod_wu:
  case Intrinsic::loongarch_lsx_vmod_du:
    return DAG.getNode(ISD::UREM, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vmul_b:
  case Intrinsic::loongarch_lsx_vmul_h:
  case Intrinsic::loongarch_lsx_vmul_w:
  case Intrinsic::loongarch_lsx_vmul_d:
    return DAG.getNode(ISD::MUL, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vmsub_b:
  case Intrinsic::loongarch_lsx_vmsub_h:
  case Intrinsic::loongarch_lsx_vmsub_w:
  case Intrinsic::loongarch_lsx_vmsub_d: {
    EVT ResTy = Op->getValueType(0);
    return DAG.getNode(ISD::SUB, SDLoc(Op), ResTy, Op->getOperand(1),
                       DAG.getNode(ISD::MUL, SDLoc(Op), ResTy,
                                   Op->getOperand(2), Op->getOperand(3)));
  }
  case Intrinsic::loongarch_lsx_vclz_b:
  case Intrinsic::loongarch_lsx_vclz_h:
  case Intrinsic::loongarch_lsx_vclz_w:
  case Intrinsic::loongarch_lsx_vclz_d:
    return DAG.getNode(ISD::CTLZ, DL, Op->getValueType(0), Op->getOperand(1));
  case Intrinsic::loongarch_lsx_vnor_v:
  case Intrinsic::loongarch_lasx_xvnor_v: {
    SDValue Res = DAG.getNode(ISD::OR, DL, Op->getValueType(0),
                              Op->getOperand(1), Op->getOperand(2));
    return DAG.getNOT(DL, Res, Res->getValueType(0));
  }
  case Intrinsic::loongarch_lsx_vor_v:
  case Intrinsic::loongarch_lasx_xvor_v:
    return DAG.getNode(ISD::OR, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vpickev_b:
  case Intrinsic::loongarch_lsx_vpickev_h:
  case Intrinsic::loongarch_lsx_vpickev_w:
  case Intrinsic::loongarch_lsx_vpickev_d:
    return DAG.getNode(LoongArchISD::VPICKEV, DL, Op->getValueType(0),
                       Op->getOperand(1), Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vpickod_b:
  case Intrinsic::loongarch_lsx_vpickod_h:
  case Intrinsic::loongarch_lsx_vpickod_w:
  case Intrinsic::loongarch_lsx_vpickod_d:
    return DAG.getNode(LoongArchISD::VPICKOD, DL, Op->getValueType(0),
                       Op->getOperand(1), Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vpcnt_b:
  case Intrinsic::loongarch_lsx_vpcnt_h:
  case Intrinsic::loongarch_lsx_vpcnt_w:
  case Intrinsic::loongarch_lsx_vpcnt_d:
    return DAG.getNode(ISD::CTPOP, DL, Op->getValueType(0), Op->getOperand(1));
  case Intrinsic::loongarch_lsx_vsat_b:
  case Intrinsic::loongarch_lsx_vsat_h:
  case Intrinsic::loongarch_lsx_vsat_w:
  case Intrinsic::loongarch_lsx_vsat_d:
  case Intrinsic::loongarch_lsx_vsat_bu:
  case Intrinsic::loongarch_lsx_vsat_hu:
  case Intrinsic::loongarch_lsx_vsat_wu:
  case Intrinsic::loongarch_lsx_vsat_du: {
    // Report an error for out of range values.
    int64_t Max;
    switch (Intrinsic) {
    case Intrinsic::loongarch_lsx_vsat_b:
    case Intrinsic::loongarch_lsx_vsat_bu:
      Max = 7;
      break;
    case Intrinsic::loongarch_lsx_vsat_h:
    case Intrinsic::loongarch_lsx_vsat_hu:
      Max = 15;
      break;
    case Intrinsic::loongarch_lsx_vsat_w:
    case Intrinsic::loongarch_lsx_vsat_wu:
      Max = 31;
      break;
    case Intrinsic::loongarch_lsx_vsat_d:
    case Intrinsic::loongarch_lsx_vsat_du:
      Max = 63;
      break;
    default:
      llvm_unreachable("Unmatched intrinsic");
    }
    int64_t Value = cast<ConstantSDNode>(Op->getOperand(2))->getSExtValue();
    if (Value < 0 || Value > Max)
      report_fatal_error("Immediate out of range");
    return SDValue();
  }
  case Intrinsic::loongarch_lsx_vshuf4i_b:
  case Intrinsic::loongarch_lsx_vshuf4i_h:
  case Intrinsic::loongarch_lsx_vshuf4i_w:
    //  case Intrinsic::loongarch_lsx_vshuf4i_d:
    {
      int64_t Value = cast<ConstantSDNode>(Op->getOperand(2))->getSExtValue();
      if (Value < 0 || Value > 255)
        report_fatal_error("Immediate out of range");
      return DAG.getNode(LoongArchISD::SHF, DL, Op->getValueType(0),
                         Op->getOperand(2), Op->getOperand(1));
    }
  case Intrinsic::loongarch_lsx_vsll_b:
  case Intrinsic::loongarch_lsx_vsll_h:
  case Intrinsic::loongarch_lsx_vsll_w:
  case Intrinsic::loongarch_lsx_vsll_d:
    return DAG.getNode(ISD::SHL, DL, Op->getValueType(0), Op->getOperand(1),
                       truncateVecElts(Op, DAG));
  case Intrinsic::loongarch_lsx_vslli_b:
  case Intrinsic::loongarch_lsx_vslli_h:
  case Intrinsic::loongarch_lsx_vslli_w:
  case Intrinsic::loongarch_lsx_vslli_d:
    return DAG.getNode(ISD::SHL, DL, Op->getValueType(0), Op->getOperand(1),
                       lowerLSXSplatImm(Op, 2, DAG));
  case Intrinsic::loongarch_lsx_vreplve_b:
  case Intrinsic::loongarch_lsx_vreplve_h:
  case Intrinsic::loongarch_lsx_vreplve_w:
  case Intrinsic::loongarch_lsx_vreplve_d:
    // We can't lower via VECTOR_SHUFFLE because it requires constant shuffle
    // masks, nor can we lower via BUILD_VECTOR & EXTRACT_VECTOR_ELT because
    // EXTRACT_VECTOR_ELT can't extract i64's on LoongArch32.
    // Instead we lower to LoongArchISD::VSHF and match from there.
    return DAG.getNode(LoongArchISD::VSHF, DL, Op->getValueType(0),
                       lowerLSXSplatZExt(Op, 2, DAG), Op->getOperand(1),
                       Op->getOperand(1));
  case Intrinsic::loongarch_lsx_vreplvei_b:
  case Intrinsic::loongarch_lsx_vreplvei_h:
  case Intrinsic::loongarch_lsx_vreplvei_w:
  case Intrinsic::loongarch_lsx_vreplvei_d:
    return DAG.getNode(LoongArchISD::VSHF, DL, Op->getValueType(0),
                       lowerLSXSplatImm(Op, 2, DAG), Op->getOperand(1),
                       Op->getOperand(1));
  case Intrinsic::loongarch_lsx_vsra_b:
  case Intrinsic::loongarch_lsx_vsra_h:
  case Intrinsic::loongarch_lsx_vsra_w:
  case Intrinsic::loongarch_lsx_vsra_d:
    return DAG.getNode(ISD::SRA, DL, Op->getValueType(0), Op->getOperand(1),
                       truncateVecElts(Op, DAG));
  case Intrinsic::loongarch_lsx_vsrari_b:
  case Intrinsic::loongarch_lsx_vsrari_h:
  case Intrinsic::loongarch_lsx_vsrari_w:
  case Intrinsic::loongarch_lsx_vsrari_d: {
    // Report an error for out of range values.
    int64_t Max;
    switch (Intrinsic) {
    case Intrinsic::loongarch_lsx_vsrari_b:
      Max = 7;
      break;
    case Intrinsic::loongarch_lsx_vsrari_h:
      Max = 15;
      break;
    case Intrinsic::loongarch_lsx_vsrari_w:
      Max = 31;
      break;
    case Intrinsic::loongarch_lsx_vsrari_d:
      Max = 63;
      break;
    default:
      llvm_unreachable("Unmatched intrinsic");
    }
    int64_t Value = cast<ConstantSDNode>(Op->getOperand(2))->getSExtValue();
    if (Value < 0 || Value > Max)
      report_fatal_error("Immediate out of range");
    return SDValue();
  }
  case Intrinsic::loongarch_lsx_vsrl_b:
  case Intrinsic::loongarch_lsx_vsrl_h:
  case Intrinsic::loongarch_lsx_vsrl_w:
  case Intrinsic::loongarch_lsx_vsrl_d:
    return DAG.getNode(ISD::SRL, DL, Op->getValueType(0), Op->getOperand(1),
                       truncateVecElts(Op, DAG));
  case Intrinsic::loongarch_lsx_vsrli_b:
  case Intrinsic::loongarch_lsx_vsrli_h:
  case Intrinsic::loongarch_lsx_vsrli_w:
  case Intrinsic::loongarch_lsx_vsrli_d:
    return DAG.getNode(ISD::SRL, DL, Op->getValueType(0), Op->getOperand(1),
                       lowerLSXSplatImm(Op, 2, DAG));
  case Intrinsic::loongarch_lsx_vsrlri_b:
  case Intrinsic::loongarch_lsx_vsrlri_h:
  case Intrinsic::loongarch_lsx_vsrlri_w:
  case Intrinsic::loongarch_lsx_vsrlri_d: {
    // Report an error for out of range values.
    int64_t Max;
    switch (Intrinsic) {
    case Intrinsic::loongarch_lsx_vsrlri_b:
      Max = 7;
      break;
    case Intrinsic::loongarch_lsx_vsrlri_h:
      Max = 15;
      break;
    case Intrinsic::loongarch_lsx_vsrlri_w:
      Max = 31;
      break;
    case Intrinsic::loongarch_lsx_vsrlri_d:
      Max = 63;
      break;
    default:
      llvm_unreachable("Unmatched intrinsic");
    }
    int64_t Value = cast<ConstantSDNode>(Op->getOperand(2))->getSExtValue();
    if (Value < 0 || Value > Max)
      report_fatal_error("Immediate out of range");
    return SDValue();
  }
  case Intrinsic::loongarch_lsx_vsubi_bu:
  case Intrinsic::loongarch_lsx_vsubi_hu:
  case Intrinsic::loongarch_lsx_vsubi_wu:
  case Intrinsic::loongarch_lsx_vsubi_du:
    return DAG.getNode(ISD::SUB, DL, Op->getValueType(0), Op->getOperand(1),
                       lowerLSXSplatImm(Op, 2, DAG));
  case Intrinsic::loongarch_lsx_vshuf_h:
  case Intrinsic::loongarch_lsx_vshuf_w:
  case Intrinsic::loongarch_lsx_vshuf_d:
  case Intrinsic::loongarch_lasx_xvshuf_h:
  case Intrinsic::loongarch_lasx_xvshuf_w:
  case Intrinsic::loongarch_lasx_xvshuf_d:
    return DAG.getNode(LoongArchISD::VSHF, DL, Op->getValueType(0),
                       Op->getOperand(1), Op->getOperand(2), Op->getOperand(3));
  case Intrinsic::loongarch_lsx_vxor_v:
  case Intrinsic::loongarch_lasx_xvxor_v:
    return DAG.getNode(ISD::XOR, DL, Op->getValueType(0), Op->getOperand(1),
                       Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vrotr_b:
  case Intrinsic::loongarch_lsx_vrotr_h:
  case Intrinsic::loongarch_lsx_vrotr_w:
  case Intrinsic::loongarch_lsx_vrotr_d:
    return DAG.getNode(LoongArchISD::VROR, DL, Op->getValueType(0),
                       Op->getOperand(1), Op->getOperand(2));
  case Intrinsic::loongarch_lsx_vrotri_b:
  case Intrinsic::loongarch_lsx_vrotri_h:
  case Intrinsic::loongarch_lsx_vrotri_w:
  case Intrinsic::loongarch_lsx_vrotri_d:
    return DAG.getNode(LoongArchISD::VRORI, DL, Op->getValueType(0),
                       Op->getOperand(1), Op->getOperand(2));
  case Intrinsic::thread_pointer: {
    EVT PtrVT = getPointerTy(DAG.getDataLayout());
    if (PtrVT ==  MVT::i64)
      return DAG.getRegister(LoongArch::TP_64, MVT::i64);
    return DAG.getRegister(LoongArch::TP, MVT::i32);
  }
  }
}

SDValue
LoongArchTargetLowering::lowerINTRINSIC_W_CHAIN(SDValue Op,
                                                SelectionDAG &DAG) const {
  unsigned Intr = cast<ConstantSDNode>(Op->getOperand(1))->getZExtValue();
  switch (Intr) {
  default:
    return SDValue();
  case Intrinsic::loongarch_lsx_vld:
    return lowerLSXLoadIntr(Op, DAG, Intr, Subtarget);
  case Intrinsic::loongarch_lasx_xvld:
    return lowerLASXLoadIntr(Op, DAG, Intr, Subtarget);
  case Intrinsic::loongarch_lasx_xvldrepl_b:
  case Intrinsic::loongarch_lasx_xvldrepl_h:
  case Intrinsic::loongarch_lasx_xvldrepl_w:
  case Intrinsic::loongarch_lasx_xvldrepl_d:
    return lowerLASXVLDRIntr(Op, DAG, Intr, Subtarget);
  case Intrinsic::loongarch_lsx_vldrepl_b:
  case Intrinsic::loongarch_lsx_vldrepl_h:
  case Intrinsic::loongarch_lsx_vldrepl_w:
  case Intrinsic::loongarch_lsx_vldrepl_d:
    return lowerLSXVLDRIntr(Op, DAG, Intr, Subtarget);
  }
}

SDValue LoongArchTargetLowering::lowerINTRINSIC_VOID(SDValue Op,
                                                     SelectionDAG &DAG) const {
  unsigned Intr = cast<ConstantSDNode>(Op->getOperand(1))->getZExtValue();
  switch (Intr) {
  default:
    return SDValue();
  case Intrinsic::loongarch_lsx_vst:
    return lowerLSXStoreIntr(Op, DAG, Intr, Subtarget);
  case Intrinsic::loongarch_lasx_xvst:
    return lowerLASXStoreIntr(Op, DAG, Intr, Subtarget);
  }
}

// Lower ISD::EXTRACT_VECTOR_ELT into LoongArchISD::VEXTRACT_SEXT_ELT.
//
// The non-value bits resulting from ISD::EXTRACT_VECTOR_ELT are undefined. We
// choose to sign-extend but we could have equally chosen zero-extend. The
// DAGCombiner will fold any sign/zero extension of the ISD::EXTRACT_VECTOR_ELT
// result into this node later (possibly changing it to a zero-extend in the
// process).
SDValue
LoongArchTargetLowering::lowerEXTRACT_VECTOR_ELT(SDValue Op,
                                                 SelectionDAG &DAG) const {
  SDLoc DL(Op);
  EVT ResTy = Op->getValueType(0);
  SDValue Op0 = Op->getOperand(0);
  EVT VecTy = Op0->getValueType(0);

  if (!VecTy.is128BitVector() && !VecTy.is256BitVector())
    return SDValue();

  if (ResTy.isInteger()) {
    SDValue Op1 = Op->getOperand(1);
    EVT EltTy = VecTy.getVectorElementType();
    if (VecTy.is128BitVector())
      return DAG.getNode(LoongArchISD::VEXTRACT_SEXT_ELT, DL, ResTy, Op0, Op1,
                         DAG.getValueType(EltTy));

    ConstantSDNode *cn = dyn_cast<ConstantSDNode>(Op1);
    if (!cn)
      return SDValue();

    if (EltTy == MVT::i32 || EltTy == MVT::i64)
      return DAG.getNode(LoongArchISD::VEXTRACT_SEXT_ELT, DL, ResTy, Op0, Op1,
                         DAG.getValueType(EltTy));
  }

  return SDValue();
}

SDValue
LoongArchTargetLowering::lowerINSERT_VECTOR_ELT(SDValue Op,
                                                SelectionDAG &DAG) const {

  MVT VT = Op.getSimpleValueType();
  MVT EltVT = VT.getVectorElementType();

  SDLoc DL(Op);
  SDValue Op0 = Op.getOperand(0);
  SDValue Op1 = Op.getOperand(1);
  SDValue Op2 = Op.getOperand(2);

  if (!EltVT.isInteger())
    return Op;

  if (!isa<ConstantSDNode>(Op2)) {
    if (EltVT == MVT::i8 || EltVT == MVT::i16) {
      return Op; // ==> pseudo
      // use stack
      return SDValue();
    } else {
      return Op;
    }
  }

  if (VT.is128BitVector())
    return DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, VT, Op0, Op1, Op2);

  if (VT.is256BitVector()) {

    if (EltVT == MVT::i32 || EltVT == MVT::i64)
      return DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, VT, Op0, Op1, Op2);

    return Op;
  }

  return SDValue();
}

// Lowers ISD::BUILD_VECTOR into appropriate SelectionDAG nodes for the
// backend.
//
// Lowers according to the following rules:
// - Constant splats are legal as-is as long as the SplatBitSize is a power of
//   2 less than or equal to 64 and the value fits into a signed 10-bit
//   immediate
// - Constant splats are lowered to bitconverted BUILD_VECTORs if SplatBitSize
//   is a power of 2 less than or equal to 64 and the value does not fit into a
//   signed 10-bit immediate
// - Non-constant splats are legal as-is.
// - Non-constant non-splats are lowered to sequences of INSERT_VECTOR_ELT.
// - All others are illegal and must be expanded.
SDValue LoongArchTargetLowering::lowerBUILD_VECTOR(SDValue Op,
                                                   SelectionDAG &DAG) const {
  BuildVectorSDNode *Node = cast<BuildVectorSDNode>(Op);
  EVT ResTy = Op->getValueType(0);
  SDLoc DL(Op);
  APInt SplatValue, SplatUndef;
  unsigned SplatBitSize;
  bool HasAnyUndefs;

  if ((!Subtarget.hasLSX() || !ResTy.is128BitVector()) &&
      (!Subtarget.hasLASX() || !ResTy.is256BitVector()))
    return SDValue();

  if (Node->isConstantSplat(SplatValue, SplatUndef, SplatBitSize, HasAnyUndefs,
                            8) &&
      SplatBitSize <= 64) {
    // We can only cope with 8, 16, 32, or 64-bit elements
    if ((ResTy.is128BitVector() && SplatBitSize != 8 && SplatBitSize != 16 &&
         SplatBitSize != 32 && SplatBitSize != 64) ||
        (ResTy.is256BitVector() && SplatBitSize != 8 && SplatBitSize != 16 &&
         SplatBitSize != 32 && SplatBitSize != 64))
      return SDValue();

    // If the value isn't an integer type we will have to bitcast
    // from an integer type first. Also, if there are any undefs, we must
    // lower them to defined values first.
    if (ResTy.isInteger() && !HasAnyUndefs)
      return Op;

    EVT ViaVecTy;

    if ((ResTy.is128BitVector() &&
         !isLSXBySplatBitSize(SplatBitSize, ViaVecTy)) ||
        (ResTy.is256BitVector() &&
         !isLASXBySplatBitSize(SplatBitSize, ViaVecTy)))
      return SDValue();

    // SelectionDAG::getConstant will promote SplatValue appropriately.
    SDValue Result = DAG.getConstant(SplatValue, DL, ViaVecTy);

    // Bitcast to the type we originally wanted
    if (ViaVecTy != ResTy)
      Result = DAG.getNode(ISD::BITCAST, SDLoc(Node), ResTy, Result);

    return Result;
  } else if (DAG.isSplatValue(Op, /* AllowUndefs */ false))
    return Op;
  else if (!isConstantOrUndefBUILD_VECTOR(Node)) {
    // Use INSERT_VECTOR_ELT operations rather than expand to stores.
    // The resulting code is the same length as the expansion, but it doesn't
    // use memory operations
    EVT ResTy = Node->getValueType(0);

    assert(ResTy.isVector());

    unsigned NumElts = ResTy.getVectorNumElements();
    SDValue Vector = DAG.getUNDEF(ResTy);
    for (unsigned i = 0; i < NumElts; ++i) {
      Vector =
          DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, ResTy, Vector,
                      Node->getOperand(i), DAG.getConstant(i, DL, MVT::i32));
    }
    return Vector;
  }

  return SDValue();
}

SDValue LoongArchTargetLowering::lowerUINT_TO_FP(SDValue Op,
                                                 SelectionDAG &DAG) const {
  SDLoc DL(Op);
  EVT ResTy = Op->getValueType(0);
  Op = LowerSUINT_TO_FP(ISD::ZERO_EXTEND_VECTOR_INREG, Op, DAG);
  if (!ResTy.isVector())
    return Op;
  return DAG.getNode(ISD::UINT_TO_FP, DL, ResTy, Op);
}

SDValue LoongArchTargetLowering::lowerSINT_TO_FP(SDValue Op,
                                                 SelectionDAG &DAG) const {
  SDLoc DL(Op);
  EVT ResTy = Op->getValueType(0);
  Op = LowerSUINT_TO_FP(ISD::SIGN_EXTEND_VECTOR_INREG, Op, DAG);
  if (!ResTy.isVector())
    return Op;
  return DAG.getNode(ISD::SINT_TO_FP, DL, ResTy, Op);
}

SDValue LoongArchTargetLowering::lowerFP_TO_UINT(SDValue Op,
                                                 SelectionDAG &DAG) const {
  if (!Op->getValueType(0).isVector())
    return SDValue();
  return LowerFP_TO_SUINT(ISD::FP_TO_UINT, ISD::ZERO_EXTEND_VECTOR_INREG, Op,
                          DAG);
}

SDValue LoongArchTargetLowering::lowerFP_TO_SINT(SDValue Op,
                                                 SelectionDAG &DAG) const {
  if (Op->getValueType(0).isVector())
    return LowerFP_TO_SUINT(ISD::FP_TO_SINT, ISD::SIGN_EXTEND_VECTOR_INREG, Op,
                            DAG);

  if (Op.getValueSizeInBits() > 32 && Subtarget.isSingleFloat())
    return SDValue();

  EVT FPTy = EVT::getFloatingPointVT(Op.getValueSizeInBits());
  SDValue Trunc =
      DAG.getNode(LoongArchISD::TruncIntFP, SDLoc(Op), FPTy, Op.getOperand(0));
  return DAG.getNode(ISD::BITCAST, SDLoc(Op), Op.getValueType(), Trunc);
}

static bool checkUndef(ArrayRef<int> Mask, int Lo, int Hi) {

  for (int i = Lo, end = Hi; i != end; i++, Hi++)
    if (!((Mask[i] == -1) || (Mask[i] == Hi)))
      return false;
  return true;
}

static bool CheckRev(ArrayRef<int> Mask) {

  int Num = Mask.size() - 1;
  for (long unsigned int i = 0; i < Mask.size(); i++, Num--)
    if (Mask[i] != Num)
      return false;
  return true;
}

static bool checkHalf(ArrayRef<int> Mask, int Lo, int Hi, int base) {

  for (int i = Lo; i < Hi; i++)
    if (Mask[i] != (base + i))
      return false;
  return true;
}

static SDValue lowerHalfHalf(const SDLoc &DL, MVT VT, SDValue Op1, SDValue Op2,
                             ArrayRef<int> Mask, SelectionDAG &DAG) {

  int Num = VT.getVectorNumElements();
  int HalfNum = Num / 2;

  if (Op1->isUndef() || Op2->isUndef() || Mask.size() > (long unsigned int)Num)
    return SDValue();

  if (checkHalf(Mask, HalfNum, Num, Num) && checkHalf(Mask, 0, HalfNum, 0)) {
    return SDValue(DAG.getMachineNode(LoongArch::XVPERMI_Q, DL, VT, Op2, Op1,
                                      DAG.getTargetConstant(48, DL, MVT::i32)),
                   0);
  }

  return SDValue();
}

static bool checkHalfUndef(ArrayRef<int> Mask, int Lo, int Hi) {

  for (int i = Lo; i < Hi; i++)
    if (Mask[i] != -1)
      return false;
  return true;
}

// Lowering vectors with half undef data,
// use EXTRACT_SUBVECTOR and INSERT_SUBVECTOR instead of VECTOR_SHUFFLE
static SDValue lowerHalfUndef(const SDLoc &DL, MVT VT, SDValue Op1, SDValue Op2,
                              ArrayRef<int> Mask, SelectionDAG &DAG) {

  int Num = VT.getVectorNumElements();
  int HalfNum = Num / 2;
  MVT HalfVT = MVT::getVectorVT(VT.getVectorElementType(), HalfNum);
  MVT VT1 = Op1.getSimpleValueType();
  SDValue Op;

  bool check1 = Op1->isUndef() && (!Op2->isUndef());
  bool check2 = Op2->isUndef() && (!Op1->isUndef());

  if ((check1 || check2) && (VT1 == VT)) {
    if (check1) {
      Op = DAG.getNode(ISD::BITCAST, DL, MVT::v4i64, Op2);
    } else if (check2) {
      Op = DAG.getNode(ISD::BITCAST, DL, MVT::v4i64, Op1);
    }

    if (VT == MVT::v32i8 && CheckRev(Mask)) {
      SDValue Vector;
      SDValue Rev[4];
      SDValue Ext[4];
      for (int i = 0; i < 4; i++) {
        Ext[i] = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, MVT::i64, Op,
                             DAG.getConstant(i, DL, MVT::i32));
        Rev[i] = DAG.getNode(LoongArchISD::REVBD, DL, MVT::i64, Ext[i]);
      }

      Vector =
          DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, MVT::v4i64, DAG.getUNDEF(VT),
                      Rev[3], DAG.getConstant(3, DL, MVT::i32));
      Vector = DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, MVT::v4i64, Vector,
                           Rev[2], DAG.getConstant(2, DL, MVT::i32));
      Vector = DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, MVT::v4i64, Vector,
                           Rev[1], DAG.getConstant(1, DL, MVT::i32));
      Vector = DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, MVT::v4i64, Vector,
                           Rev[0], DAG.getConstant(0, DL, MVT::i32));

      Vector = DAG.getNode(ISD::BITCAST, DL, MVT::v32i8, Vector);

      return Vector;
    }
  }

  if (checkHalfUndef(Mask, HalfNum, Num) && checkUndef(Mask, 0, HalfNum)) {
    SDValue High = DAG.getNode(ISD::EXTRACT_SUBVECTOR, DL, HalfVT, Op1,
                               DAG.getConstant(HalfNum, DL, MVT::i64));
    return DAG.getNode(ISD::INSERT_SUBVECTOR, DL, VT, DAG.getUNDEF(VT), High,
                       DAG.getConstant(0, DL, MVT::i64));
  }

  if (checkHalfUndef(Mask, HalfNum, Num) && (VT == MVT::v8i32) &&
      (Mask[0] == 0) && (Mask[1] == 1) && (Mask[2] == (Num + 2)) &&
      (Mask[3] == (Num + 3))) {

    SDValue Val1 =
        SDValue(DAG.getMachineNode(LoongArch::XVPERMI_Q, DL, VT, Op2, Op1,
                                   DAG.getTargetConstant(32, DL, MVT::i32)),
                0);

    SDValue Val2 =
        SDValue(DAG.getMachineNode(LoongArch::XVPERMI_D, DL, VT, Val1,
                                   DAG.getTargetConstant(12, DL, MVT::i32)),
                0);

    SDValue Val3 = SDValue(
        DAG.getMachineNode(LoongArch::XVPERMI_Q, DL, VT, Val2, DAG.getUNDEF(VT),
                           DAG.getTargetConstant(2, DL, MVT::i32)),
        0);
    return Val3;
  }

  if (checkHalfUndef(Mask, 0, HalfNum) && checkUndef(Mask, HalfNum, Num)) {
    SDValue Low = DAG.getNode(ISD::EXTRACT_SUBVECTOR, DL, HalfVT, Op1,
                              DAG.getConstant(0, DL, MVT::i32));
    return DAG.getNode(ISD::INSERT_SUBVECTOR, DL, VT, DAG.getUNDEF(VT), Low,
                       DAG.getConstant(HalfNum, DL, MVT::i32));
  }

  if (checkHalfUndef(Mask, 0, HalfNum) && (VT == MVT::v8i32) &&
      (Mask[HalfNum] == HalfNum) && (Mask[HalfNum + 1] == (HalfNum + 1)) &&
      (Mask[HalfNum + 2] == (2 * Num - 2)) &&
      (Mask[HalfNum + 3] == (2 * Num - 1))) {

    SDValue Val1 =
        SDValue(DAG.getMachineNode(LoongArch::XVPERMI_Q, DL, VT, Op2, Op1,
                                   DAG.getTargetConstant(49, DL, MVT::i32)),
                0);

    SDValue Val2 =
        SDValue(DAG.getMachineNode(LoongArch::XVPERMI_D, DL, VT, Val1,
                                   DAG.getTargetConstant(12, DL, MVT::i32)),
                0);

    SDValue Val3 = SDValue(
        DAG.getMachineNode(LoongArch::XVPERMI_Q, DL, VT, Val2, DAG.getUNDEF(VT),
                           DAG.getTargetConstant(32, DL, MVT::i32)),
        0);
    return Val3;
  }

  if ((VT == MVT::v8i32) || (VT == MVT::v4i64)) {
    int def = 0;
    int j = 0;
    int ext[3];
    int ins[3];
    bool useOp1[3] = {true, true, true};
    bool checkdef = true;

    for (int i = 0; i < Num; i++) {
      if (def > 2) {
        checkdef = false;
        break;
      }
      if (Mask[i] != -1) {
        def++;
        ins[j] = i;
        if (Mask[i] >= Num) {
          ext[j] = Mask[i] - Num;
          useOp1[j] = false;
        } else {
          ext[j] = Mask[i];
        }
        j++;
      }
    }

    if (checkdef) {
      SDValue Vector = DAG.getUNDEF(VT);
      EVT EltTy = VT.getVectorElementType();
      SDValue Ext[2];

      if (check1 || check2) {
        for (int i = 0; i < def; i++) {
          if (check1) {
            Ext[i] = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, EltTy, Op2,
                                 DAG.getConstant(ext[i], DL, MVT::i32));
            Vector = DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, VT, Vector, Ext[i],
                                 DAG.getConstant(ins[i], DL, MVT::i32));
          } else if (check2) {
            Ext[i] = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, EltTy, Op1,
                                 DAG.getConstant(ext[i], DL, MVT::i32));
            Vector = DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, VT, Vector, Ext[i],
                                 DAG.getConstant(ins[i], DL, MVT::i32));
          }
        }
        return Vector;
      } else {
        for (int i = 0; i < def; i++) {
          if (!useOp1[i]) {
            Ext[i] = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, EltTy, Op2,
                                 DAG.getConstant(ext[i], DL, MVT::i32));
            Vector = DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, VT, Vector, Ext[i],
                                 DAG.getConstant(ins[i], DL, MVT::i32));
          } else {
            Ext[i] = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, EltTy, Op1,
                                 DAG.getConstant(ext[i], DL, MVT::i32));
            Vector = DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, VT, Vector, Ext[i],
                                 DAG.getConstant(ins[i], DL, MVT::i32));
          }
        }
        return Vector;
      }
    }
  }

  return SDValue();
}

static SDValue lowerHalfUndef_LSX(const SDLoc &DL, EVT ResTy, MVT VT,
                                  SDValue Op1, SDValue Op2, ArrayRef<int> Mask,
                                  SelectionDAG &DAG) {

  MVT VT1 = Op1.getSimpleValueType();

  bool check1 = Op1->isUndef() && (!Op2->isUndef());
  bool check2 = Op2->isUndef() && (!Op1->isUndef());

  if ((check1 || check2) && (VT1 == VT)) {
    SDValue Op;

    if (VT == MVT::v16i8 && CheckRev(Mask)) {

      if (check1) {
        Op = DAG.getNode(ISD::BITCAST, DL, MVT::v2i64, Op2);
      } else if (check2) {
        Op = DAG.getNode(ISD::BITCAST, DL, MVT::v2i64, Op1);
      }

      SDValue Vector;
      SDValue Rev[2];
      SDValue Ext[2];
      for (int i = 0; i < 2; i++) {
        Ext[i] = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, DL, MVT::i64, Op,
                             DAG.getConstant(i, DL, MVT::i32));
        Rev[i] = DAG.getNode(LoongArchISD::REVBD, DL, MVT::i64, Ext[i]);
      }

      Vector =
          DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, MVT::v2i64, DAG.getUNDEF(VT),
                      Rev[1], DAG.getConstant(1, DL, MVT::i32));
      Vector = DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, MVT::v2i64, Vector,
                           Rev[0], DAG.getConstant(0, DL, MVT::i32));

      Vector = DAG.getNode(ISD::BITCAST, DL, MVT::v16i8, Vector);

      return Vector;
    }
  }

  return SDValue();
}

// Use SDNode of LoongArchINSVE instead of
// a series of EXTRACT_VECTOR_ELT and INSERT_VECTOR_ELT
static SDValue lowerVECTOR_SHUFFLE_INSVE(const SDLoc &DL, MVT VT, EVT ResTy,
                                         SDValue Op1, SDValue Op2,
                                         ArrayRef<int> Mask,
                                         SelectionDAG &DAG) {

  int Num = VT.getVectorNumElements();
  if (ResTy == MVT::v16i16 || ResTy == MVT::v32i8)
    return SDValue();

  int CheckOne = 0;
  int CheckOther = 0;
  int Idx;

  for (int i = 0; i < Num; i++) {
    if ((Mask[i] == i) || (Mask[i] == -1)) {
      CheckOther++;
    } else if (Mask[i] == Num) {
      CheckOne++;
      Idx = i;
    } else
      return SDValue();
  }

  if ((CheckOne != 1) || (CheckOther != (Num - 1)))
    return SDValue();
  else {
    return DAG.getNode(LoongArchISD::INSVE, DL, ResTy, Op1, Op2,
                       DAG.getConstant(Idx, DL, MVT::i32));
  }

  return SDValue();
}

static SDValue lowerVECTOR_SHUFFLE_XVPICKVE(const SDLoc &DL, MVT VT, EVT ResTy,
                                            SDValue Op1, SDValue Op2,
                                            ArrayRef<int> Mask,
                                            SelectionDAG &DAG) {

  int Num = VT.getVectorNumElements();
  if (ResTy == MVT::v16i16 || ResTy == MVT::v32i8 ||
      (!ISD::isBuildVectorAllZeros(Op1.getNode())))
    return SDValue();

  bool CheckV = true;

  if ((Mask[0] < Num) || (Mask[0] > (2 * Num - 1)))
    CheckV = false;

  for (int i = 1; i < Num; i++) {
    if (Mask[i] != 0) {
      CheckV = false;
      break;
    }
  }

  if (!CheckV)
    return SDValue();
  else {
    return DAG.getNode(LoongArchISD::XVPICKVE, DL, ResTy, Op1, Op2,
                       DAG.getConstant(Mask[0] - Num, DL, MVT::i32));
  }

  return SDValue();
}

static SDValue lowerVECTOR_SHUFFLE_XVSHUF(const SDLoc &DL, MVT VT, EVT ResTy,
                                          SDValue Op1, SDValue Op2,
                                          ArrayRef<int> Mask,
                                          SelectionDAG &DAG) {

  if (VT == MVT::v4i64) {
    int Num = VT.getVectorNumElements();

    bool CheckV = true;
    for (int i = 0; i < Num; i++) {
      if (Mask[i] != (i * 2)) {
        CheckV = false;
        break;
      }
    }

    if (!CheckV)
      return SDValue();
    else {
      SDValue Res = DAG.getNode(LoongArchISD::XVSHUF4I, DL, ResTy, Op1, Op2,
                                DAG.getConstant(8, DL, MVT::i32));
      return DAG.getNode(LoongArchISD::XVPERMI, DL, ResTy, Res,
                         DAG.getConstant(0xD8, DL, MVT::i32));
    }
  } else
    return SDValue();
}

// Lower VECTOR_SHUFFLE into one of a number of instructions depending on the
// indices in the shuffle.
SDValue LoongArchTargetLowering::lowerVECTOR_SHUFFLE(SDValue Op,
                                                     SelectionDAG &DAG) const {
  ShuffleVectorSDNode *Node = cast<ShuffleVectorSDNode>(Op);
  EVT ResTy = Op->getValueType(0);
  ArrayRef<int> Mask = Node->getMask();
  SDValue Op1 = Op.getOperand(0);
  SDValue Op2 = Op.getOperand(1);
  MVT VT = Op.getSimpleValueType();
  SDLoc DL(Op);

  if (ResTy.is128BitVector()) {

    int ResTyNumElts = ResTy.getVectorNumElements();
    SmallVector<int, 16> Indices;

    for (int i = 0; i < ResTyNumElts; ++i)
      Indices.push_back(Node->getMaskElt(i));

    SDValue Result;
    if (isVECTOR_SHUFFLE_VREPLVEI(Op, ResTy, Indices, DAG))
      return lowerVECTOR_SHUFFLE_VSHF(Op, ResTy, Indices, DAG);
    if ((Result = lowerVECTOR_SHUFFLE_VPACKEV(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_VPACKOD(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_VILVH(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_VILVL(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_VPICKEV(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_VPICKOD(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_SHF(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerHalfUndef_LSX(DL, ResTy, VT, Op1, Op2, Mask, DAG)))
      return Result;
    return lowerVECTOR_SHUFFLE_VSHF(Op, ResTy, Indices, DAG);

  } else if (ResTy.is256BitVector()) {
    int ResTyNumElts = ResTy.getVectorNumElements();
    SmallVector<int, 32> Indices;

    for (int i = 0; i < ResTyNumElts; ++i)
      Indices.push_back(Node->getMaskElt(i));

    SDValue Result;
    if ((Result = lowerHalfHalf(DL, VT, Op1, Op2, Mask, DAG)))
      return Result;
    if ((Result = lowerHalfUndef(DL, VT, Op1, Op2, Mask, DAG)))
      return Result;
    if (isVECTOR_SHUFFLE_XVREPLVEI(Op, ResTy, Indices, DAG))
      return SDValue();
    if ((Result = lowerVECTOR_SHUFFLE_XVPACKEV(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_XVPACKOD(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_XVILVH(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_XVILVL(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_XVPICKEV(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_XVPICKOD(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result = lowerVECTOR_SHUFFLE_XSHF(Op, ResTy, Indices, DAG)))
      return Result;
    if ((Result =
             lowerVECTOR_SHUFFLE_INSVE(DL, VT, ResTy, Op1, Op2, Mask, DAG)))
      return Result;
    if ((Result =
             lowerVECTOR_SHUFFLE_XVPICKVE(DL, VT, ResTy, Op1, Op2, Mask, DAG)))
      return Result;
    if ((Result =
             lowerVECTOR_SHUFFLE_XVSHUF(DL, VT, ResTy, Op1, Op2, Mask, DAG)))
      return Result;
  }

  return SDValue();
}

SDValue LoongArchTargetLowering::lowerEH_DWARF_CFA(SDValue Op,
                                              SelectionDAG &DAG) const {

  // Return a fixed StackObject with offset 0 which points to the old stack
  // pointer.
  MachineFrameInfo &MFI = DAG.getMachineFunction().getFrameInfo();
  EVT ValTy = Op->getValueType(0);
  int FI = MFI.CreateFixedObject(Op.getValueSizeInBits() / 8, 0, false);
  return DAG.getFrameIndex(FI, ValTy);
}

// Check whether the tail call optimization conditions are met
bool LoongArchTargetLowering::isEligibleForTailCallOptimization(
    const CCState &CCInfo, CallLoweringInfo &CLI, MachineFunction &MF,
    unsigned NextStackOffset, const LoongArchFunctionInfo &FI) const {

  auto CalleeCC = CLI.CallConv;
  auto IsVarArg = CLI.IsVarArg;
  auto &Outs = CLI.Outs;
  auto &Caller = MF.getFunction();
  auto CallerCC = Caller.getCallingConv();

  if (Caller.getFnAttribute("disable-tail-calls").getValueAsString() == "true")
    return false;

  if (Caller.hasFnAttribute("interrupt"))
    return false;

  if (IsVarArg)
    return false;

  if (getTargetMachine().getCodeModel() == CodeModel::Large)
    return false;

  if (getTargetMachine().getRelocationModel() == Reloc::Static)
    return false;

  // Do not tail call optimize if the stack is used to pass parameters.
  if (CCInfo.getNextStackOffset() != 0)
    return false;

  // Do not tail call optimize functions with byval parameters.
  for (auto &Arg : Outs)
    if (Arg.Flags.isByVal())
      return false;

  // Do not tail call optimize if either caller or callee uses structret
  // semantics.
  auto IsCallerStructRet = Caller.hasStructRetAttr();
  auto IsCalleeStructRet = Outs.empty() ? false : Outs[0].Flags.isSRet();
  if (IsCallerStructRet || IsCalleeStructRet)
    return false;

  // The callee has to preserve all registers the caller needs to preserve.
  const LoongArchRegisterInfo *TRI = Subtarget.getRegisterInfo();
  const uint32_t *CallerPreserved = TRI->getCallPreservedMask(MF, CallerCC);
  if (CalleeCC != CallerCC) {
    const uint32_t *CalleePreserved = TRI->getCallPreservedMask(MF, CalleeCC);
    if (!TRI->regmaskSubsetEqual(CallerPreserved, CalleePreserved))
      return false;
  }

  // Return false if either the callee or caller has a byval argument.
  if (CCInfo.getInRegsParamsCount() > 0 || FI.hasByvalArg())
    return false;

  // Return true if the callee's argument area is no larger than the
  // caller's.
  return NextStackOffset <= FI.getIncomingArgSize();
}

//===----------------------------------------------------------------------===//
//                      Calling Convention Implementation
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// TODO: Implement a generic logic using tblgen that can support this.
// LoongArch LP32 ABI rules:
// ---
// i32 - Passed in A0, A1, A2, A3 and stack
// f32 - Only passed in f32 registers if no int reg has been used yet to hold
//       an argument. Otherwise, passed in A1, A2, A3 and stack.
// f64 - Only passed in two aliased f32 registers if no int reg has been used
//       yet to hold an argument. Otherwise, use A2, A3 and stack. If A1 is
//       not used, it must be shadowed. If only A3 is available, shadow it and
//       go to stack.
// vXiX - Received as scalarized i32s, passed in A0 - A3 and the stack.
// vXf32 - Passed in either a pair of registers {A0, A1}, {A2, A3} or {A0 - A3}
//         with the remainder spilled to the stack.
// vXf64 - Passed in either {A0, A1, A2, A3} or {A2, A3} and in both cases
//         spilling the remainder to the stack.
//
//  For vararg functions, all arguments are passed in A0, A1, A2, A3 and stack.
//===----------------------------------------------------------------------===//

static bool CC_LoongArchLP32(unsigned ValNo, MVT ValVT, MVT LocVT,
                       CCValAssign::LocInfo LocInfo, ISD::ArgFlagsTy ArgFlags,
                       CCState &State, ArrayRef<MCPhysReg> F64Regs) {
  static const MCPhysReg IntRegs[] = { LoongArch::A0, LoongArch::A1, LoongArch::A2, LoongArch::A3 };

  const LoongArchCCState * LoongArchState = static_cast<LoongArchCCState *>(&State);

  static const MCPhysReg F32Regs[] = { LoongArch::F12, LoongArch::F14 };

  static const MCPhysReg FloatVectorIntRegs[] = { LoongArch::A0, LoongArch::A2 };

  // Do not process byval args here.
  if (ArgFlags.isByVal())
    return true;


  // Promote i8 and i16
  if (LocVT == MVT::i8 || LocVT == MVT::i16) {
    LocVT = MVT::i32;
    if (ArgFlags.isSExt())
      LocInfo = CCValAssign::SExt;
    else if (ArgFlags.isZExt())
      LocInfo = CCValAssign::ZExt;
    else
      LocInfo = CCValAssign::AExt;
  }

  unsigned Reg;

  // f32 and f64 are allocated in A0, A1, A2, A3 when either of the following
  // is true: function is vararg, argument is 3rd or higher, there is previous
  // argument which is not f32 or f64.
  bool AllocateFloatsInIntReg = State.isVarArg() || ValNo > 1 ||
                                State.getFirstUnallocated(F32Regs) != ValNo;
  Align OrigAlign = ArgFlags.getNonZeroOrigAlign();
  bool isI64 = (ValVT == MVT::i32 && OrigAlign == Align(8));
  bool isVectorFloat = LoongArchState->WasOriginalArgVectorFloat(ValNo);

  // The LoongArch vector ABI for floats passes them in a pair of registers
  if (ValVT == MVT::i32 && isVectorFloat) {
    // This is the start of an vector that was scalarized into an unknown number
    // of components. It doesn't matter how many there are. Allocate one of the
    // notional 8 byte aligned registers which map onto the argument stack, and
    // shadow the register lost to alignment requirements.
    if (ArgFlags.isSplit()) {
      Reg = State.AllocateReg(FloatVectorIntRegs);
      if (Reg == LoongArch::A2)
        State.AllocateReg(LoongArch::A1);
      else if (Reg == 0)
        State.AllocateReg(LoongArch::A3);
    } else {
      // If we're an intermediate component of the split, we can just attempt to
      // allocate a register directly.
      Reg = State.AllocateReg(IntRegs);
    }
  } else if (ValVT == MVT::i32 || (ValVT == MVT::f32 && AllocateFloatsInIntReg)) {
    Reg = State.AllocateReg(IntRegs);
    // If this is the first part of an i64 arg,
    // the allocated register must be either A0 or A2.
    if (isI64 && (Reg == LoongArch::A1 || Reg == LoongArch::A3))
      Reg = State.AllocateReg(IntRegs);
    LocVT = MVT::i32;
  } else if (ValVT == MVT::f64 && AllocateFloatsInIntReg) {
    // Allocate int register and shadow next int register. If first
    // available register is LoongArch::A1 or LoongArch::A3, shadow it too.
    Reg = State.AllocateReg(IntRegs);
    if (Reg == LoongArch::A1 || Reg == LoongArch::A3)
      Reg = State.AllocateReg(IntRegs);
    State.AllocateReg(IntRegs);
    LocVT = MVT::i32;
  } else if (ValVT.isFloatingPoint() && !AllocateFloatsInIntReg) {
    // we are guaranteed to find an available float register
    if (ValVT == MVT::f32) {
      Reg = State.AllocateReg(F32Regs);
      // Shadow int register
      State.AllocateReg(IntRegs);
    } else {
      Reg = State.AllocateReg(F64Regs);
      // Shadow int registers
      unsigned Reg2 = State.AllocateReg(IntRegs);
      if (Reg2 == LoongArch::A1 || Reg2 == LoongArch::A3)
        State.AllocateReg(IntRegs);
      State.AllocateReg(IntRegs);
    }
  } else
    llvm_unreachable("Cannot handle this ValVT.");

  if (!Reg) {
    unsigned Offset = State.AllocateStack(ValVT.getStoreSize(), OrigAlign);
    State.addLoc(CCValAssign::getMem(ValNo, ValVT, Offset, LocVT, LocInfo));
  } else
    State.addLoc(CCValAssign::getReg(ValNo, ValVT, Reg, LocVT, LocInfo));

  return false;
}

static bool CC_LoongArchLP32_FP32(unsigned ValNo, MVT ValVT,
                            MVT LocVT, CCValAssign::LocInfo LocInfo,
                            ISD::ArgFlagsTy ArgFlags, CCState &State) {
  static const MCPhysReg F64Regs[] = {LoongArch::F0_64, LoongArch::F1_64, LoongArch::F2_64, \
                                      LoongArch::F3_64, LoongArch::F4_64, LoongArch::F5_64, \
                                      LoongArch::F6_64, LoongArch::F7_64 };

  return CC_LoongArchLP32(ValNo, ValVT, LocVT, LocInfo, ArgFlags, State, F64Regs);
}

static bool CC_LoongArchLP32_FP64(unsigned ValNo, MVT ValVT,
                            MVT LocVT, CCValAssign::LocInfo LocInfo,
                            ISD::ArgFlagsTy ArgFlags, CCState &State) {
  static const MCPhysReg F64Regs[] = {LoongArch::F0_64, LoongArch::F1_64, LoongArch::F2_64, \
                                      LoongArch::F3_64, LoongArch::F4_64, LoongArch::F5_64, \
                                      LoongArch::F6_64, LoongArch::F7_64 };

  return CC_LoongArchLP32(ValNo, ValVT, LocVT, LocInfo, ArgFlags, State, F64Regs);
}

static bool CC_LoongArch_F128(unsigned ValNo, MVT ValVT,
                            MVT LocVT, CCValAssign::LocInfo LocInfo,
                            ISD::ArgFlagsTy ArgFlags, CCState &State) LLVM_ATTRIBUTE_UNUSED;

static bool CC_LoongArch_F128(unsigned ValNo, MVT ValVT,
                            MVT LocVT, CCValAssign::LocInfo LocInfo,
                            ISD::ArgFlagsTy ArgFlags, CCState &State) {

  static const MCPhysReg ArgRegs[8] = {
      LoongArch::A0_64, LoongArch::A1_64, LoongArch::A2_64, LoongArch::A3_64,
      LoongArch::A4_64, LoongArch::A5_64, LoongArch::A6_64, LoongArch::A7_64};

  unsigned Idx = State.getFirstUnallocated(ArgRegs);
  // Skip 'odd' register if necessary.
  if (!ArgFlags.isSplitEnd() && Idx != array_lengthof(ArgRegs) && Idx % 2 == 1)
    State.AllocateReg(ArgRegs);
  return true;
}

static bool CC_LoongArchLP32(unsigned ValNo, MVT ValVT, MVT LocVT,
                       CCValAssign::LocInfo LocInfo, ISD::ArgFlagsTy ArgFlags,
                       CCState &State) LLVM_ATTRIBUTE_UNUSED;

#include "LoongArchGenCallingConv.inc"

 CCAssignFn *LoongArchTargetLowering::CCAssignFnForCall() const{
   return CC_LoongArch;
 }

 CCAssignFn *LoongArchTargetLowering::CCAssignFnForReturn() const{
   return RetCC_LoongArch;
 }

//===----------------------------------------------------------------------===//
//                  Call Calling Convention Implementation
//===----------------------------------------------------------------------===//
SDValue LoongArchTargetLowering::passArgOnStack(SDValue StackPtr, unsigned Offset,
                                           SDValue Chain, SDValue Arg,
                                           const SDLoc &DL, bool IsTailCall,
                                           SelectionDAG &DAG) const {
  if (!IsTailCall) {
    SDValue PtrOff =
        DAG.getNode(ISD::ADD, DL, getPointerTy(DAG.getDataLayout()), StackPtr,
                    DAG.getIntPtrConstant(Offset, DL));
    return DAG.getStore(Chain, DL, Arg, PtrOff, MachinePointerInfo());
  }

  MachineFrameInfo &MFI = DAG.getMachineFunction().getFrameInfo();
  int FI = MFI.CreateFixedObject(Arg.getValueSizeInBits() / 8, Offset, false);
  SDValue FIN = DAG.getFrameIndex(FI, getPointerTy(DAG.getDataLayout()));
  return DAG.getStore(Chain, DL, Arg, FIN, MachinePointerInfo(),
                      /* Alignment = */ 0, MachineMemOperand::MOVolatile);
}

void LoongArchTargetLowering::getOpndList(
    SmallVectorImpl<SDValue> &Ops,
    std::deque<std::pair<unsigned, SDValue>> &RegsToPass, bool IsPICCall,
    bool GlobalOrExternal, bool IsCallReloc, CallLoweringInfo &CLI,
    SDValue Callee, SDValue Chain, bool IsTailCall) const {
  // Build a sequence of copy-to-reg nodes chained together with token
  // chain and flag operands which copy the outgoing args into registers.
  // The InFlag in necessary since all emitted instructions must be
  // stuck together.
  SDValue InFlag;

  Ops.push_back(Callee);

  for (unsigned i = 0, e = RegsToPass.size(); i != e; ++i) {
    Chain = CLI.DAG.getCopyToReg(Chain, CLI.DL, RegsToPass[i].first,
                                 RegsToPass[i].second, InFlag);
    InFlag = Chain.getValue(1);
  }

  // Add argument registers to the end of the list so that they are
  // known live into the call.
  for (unsigned i = 0, e = RegsToPass.size(); i != e; ++i)
    Ops.push_back(CLI.DAG.getRegister(RegsToPass[i].first,
                                      RegsToPass[i].second.getValueType()));

  if (!IsTailCall) {
    // Add a register mask operand representing the call-preserved registers.
    const TargetRegisterInfo *TRI = Subtarget.getRegisterInfo();
    const uint32_t *Mask =
        TRI->getCallPreservedMask(CLI.DAG.getMachineFunction(), CLI.CallConv);
    assert(Mask && "Missing call preserved mask for calling convention");
    Ops.push_back(CLI.DAG.getRegisterMask(Mask));
  }

  if (InFlag.getNode())
    Ops.push_back(InFlag);
}

void LoongArchTargetLowering::AdjustInstrPostInstrSelection(MachineInstr &MI,
                                                       SDNode *Node) const {
  switch (MI.getOpcode()) {
    default:
      return;
  }
}

/// LowerCall - functions arguments are copied from virtual regs to
/// (physical regs)/(stack frame), CALLSEQ_START and CALLSEQ_END are emitted.
SDValue
LoongArchTargetLowering::LowerCall(TargetLowering::CallLoweringInfo &CLI,
                              SmallVectorImpl<SDValue> &InVals) const {
  SelectionDAG &DAG                     = CLI.DAG;
  SDLoc DL                              = CLI.DL;
  SmallVectorImpl<ISD::OutputArg> &Outs = CLI.Outs;
  SmallVectorImpl<SDValue> &OutVals     = CLI.OutVals;
  SmallVectorImpl<ISD::InputArg> &Ins   = CLI.Ins;
  SDValue Chain                         = CLI.Chain;
  SDValue Callee                        = CLI.Callee;
  bool &IsTailCall                      = CLI.IsTailCall;
  CallingConv::ID CallConv              = CLI.CallConv;
  bool IsVarArg                         = CLI.IsVarArg;

  MachineFunction &MF = DAG.getMachineFunction();
  MachineFrameInfo &MFI = MF.getFrameInfo();
  const TargetFrameLowering *TFL = Subtarget.getFrameLowering();
  bool IsPIC = isPositionIndependent();

  // Analyze operands of the call, assigning locations to each operand.
  SmallVector<CCValAssign, 16> ArgLocs;
  LoongArchCCState CCInfo(
      CallConv, IsVarArg, DAG.getMachineFunction(), ArgLocs, *DAG.getContext(),
      LoongArchCCState::getSpecialCallingConvForCallee(Callee.getNode(), Subtarget));

  const ExternalSymbolSDNode *ES =
      dyn_cast_or_null<const ExternalSymbolSDNode>(Callee.getNode());

  // There is one case where CALLSEQ_START..CALLSEQ_END can be nested, which
  // is during the lowering of a call with a byval argument which produces
  // a call to memcpy. For the LP32 case, this causes the caller to allocate
  // stack space for the reserved argument area for the callee, then recursively
  // again for the memcpy call. In the NEWABI case, this doesn't occur as those
  // ABIs mandate that the callee allocates the reserved argument area. We do
  // still produce nested CALLSEQ_START..CALLSEQ_END with zero space though.
  //
  // If the callee has a byval argument and memcpy is used, we are mandated
  // to already have produced a reserved argument area for the callee for LP32.
  // Therefore, the reserved argument area can be reused for both calls.
  //
  // Other cases of calling memcpy cannot have a chain with a CALLSEQ_START
  // present, as we have yet to hook that node onto the chain.
  //
  // Hence, the CALLSEQ_START and CALLSEQ_END nodes can be eliminated in this
  // case. GCC does a similar trick, in that wherever possible, it calculates
  // the maximum out going argument area (including the reserved area), and
  // preallocates the stack space on entrance to the caller.
  //
  // FIXME: We should do the same for efficiency and space.

  bool MemcpyInByVal = ES &&
                       StringRef(ES->getSymbol()) == StringRef("memcpy") &&
                       Chain.getOpcode() == ISD::CALLSEQ_START;

  CCInfo.AnalyzeCallOperands(Outs, CC_LoongArch, CLI.getArgs(),
                             ES ? ES->getSymbol() : nullptr);

  // Get a count of how many bytes are to be pushed on the stack.
  unsigned NextStackOffset = CCInfo.getNextStackOffset();

  // Check if it's really possible to do a tail call. Restrict it to functions
  // that are part of this compilation unit.
  if (IsTailCall) {
    IsTailCall = isEligibleForTailCallOptimization(
        CCInfo, CLI, MF, NextStackOffset, *MF.getInfo<LoongArchFunctionInfo>());
    if (GlobalAddressSDNode *G = dyn_cast<GlobalAddressSDNode>(Callee)) {
      if (G->getGlobal()->hasExternalWeakLinkage())
        IsTailCall = false;
    }
  }
  if (!IsTailCall && CLI.CB && CLI.CB->isMustTailCall())
    report_fatal_error("failed to perform tail call elimination on a call "
                       "site marked musttail");

  if (IsTailCall)
    ++NumTailCalls;

  // Chain is the output chain of the last Load/Store or CopyToReg node.
  // ByValChain is the output chain of the last Memcpy node created for copying
  // byval arguments to the stack.
  unsigned StackAlignment = TFL->getStackAlignment();
  NextStackOffset = alignTo(NextStackOffset, StackAlignment);
  SDValue NextStackOffsetVal = DAG.getIntPtrConstant(NextStackOffset, DL, true);

  if (!(IsTailCall || MemcpyInByVal))
    Chain = DAG.getCALLSEQ_START(Chain, NextStackOffset, 0, DL);

  SDValue StackPtr =
      DAG.getCopyFromReg(Chain, DL, ABI.IsLP64() ? LoongArch::SP_64 : LoongArch::SP,
                         getPointerTy(DAG.getDataLayout()));

  std::deque<std::pair<unsigned, SDValue>> RegsToPass;
  SmallVector<SDValue, 8> MemOpChains;

  CCInfo.rewindByValRegsInfo();

  // Walk the register/memloc assignments, inserting copies/loads.
  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    SDValue Arg = OutVals[i];
    CCValAssign &VA = ArgLocs[i];
    MVT ValVT = VA.getValVT(), LocVT = VA.getLocVT();
    ISD::ArgFlagsTy Flags = Outs[i].Flags;
    bool UseUpperBits = false;

    // ByVal Arg.
    if (Flags.isByVal()) {
      unsigned FirstByValReg, LastByValReg;
      unsigned ByValIdx = CCInfo.getInRegsParamsProcessed();
      CCInfo.getInRegsParamInfo(ByValIdx, FirstByValReg, LastByValReg);

      assert(Flags.getByValSize() &&
             "ByVal args of size 0 should have been ignored by front-end.");
      assert(ByValIdx < CCInfo.getInRegsParamsCount());
      assert(!IsTailCall &&
             "Do not tail-call optimize if there is a byval argument.");
      passByValArg(Chain, DL, RegsToPass, MemOpChains, StackPtr, MFI, DAG, Arg,
                   FirstByValReg, LastByValReg, Flags,
                   VA);
      CCInfo.nextInRegsParam();
      continue;
    }

    // Promote the value if needed.
    switch (VA.getLocInfo()) {
    default:
      llvm_unreachable("Unknown loc info!");
    case CCValAssign::Full:
      if (VA.isRegLoc()) {
        if ((ValVT == MVT::f32 && LocVT == MVT::i32) ||
            (ValVT == MVT::f64 && LocVT == MVT::i64) ||
            (ValVT == MVT::i64 && LocVT == MVT::f64))
          Arg = DAG.getNode(ISD::BITCAST, DL, LocVT, Arg);
      }
      break;
    case CCValAssign::BCvt:
      Arg = DAG.getNode(ISD::BITCAST, DL, LocVT, Arg);
      break;
    case CCValAssign::SExtUpper:
      UseUpperBits = true;
      LLVM_FALLTHROUGH;
    case CCValAssign::SExt:
      Arg = DAG.getNode(ISD::SIGN_EXTEND, DL, LocVT, Arg);
      break;
    case CCValAssign::ZExtUpper:
      UseUpperBits = true;
      LLVM_FALLTHROUGH;
    case CCValAssign::ZExt:
      Arg = DAG.getNode(ISD::ZERO_EXTEND, DL, LocVT, Arg);
      break;
    case CCValAssign::AExtUpper:
      UseUpperBits = true;
      LLVM_FALLTHROUGH;
    case CCValAssign::AExt:
      Arg = DAG.getNode(ISD::ANY_EXTEND, DL, LocVT, Arg);
      break;
    }

    if (UseUpperBits) {
      unsigned ValSizeInBits = Outs[i].ArgVT.getSizeInBits();
      unsigned LocSizeInBits = VA.getLocVT().getSizeInBits();
      Arg = DAG.getNode(
          ISD::SHL, DL, VA.getLocVT(), Arg,
          DAG.getConstant(LocSizeInBits - ValSizeInBits, DL, VA.getLocVT()));
    }

    // Arguments that can be passed on register must be kept at
    // RegsToPass vector
    if (VA.isRegLoc()) {
      RegsToPass.push_back(std::make_pair(VA.getLocReg(), Arg));
      continue;
    }

    // Register can't get to this point...
    assert(VA.isMemLoc());

    // emit ISD::STORE whichs stores the
    // parameter value to a stack Location
    MemOpChains.push_back(passArgOnStack(StackPtr, VA.getLocMemOffset(),
                                         Chain, Arg, DL, IsTailCall, DAG));
  }

  // Transform all store nodes into one single node because all store
  // nodes are independent of each other.
  if (!MemOpChains.empty())
    Chain = DAG.getNode(ISD::TokenFactor, DL, MVT::Other, MemOpChains);

  // If the callee is a GlobalAddress/ExternalSymbol node (quite common, every
  // direct call is) turn it into a TargetGlobalAddress/TargetExternalSymbol
  // node so that legalize doesn't hack it.

  bool GlobalOrExternal = false, IsCallReloc = false;

  if (GlobalAddressSDNode *G = dyn_cast<GlobalAddressSDNode>(Callee)) {
    Callee = DAG.getTargetGlobalAddress(G->getGlobal(), DL,
                                        getPointerTy(DAG.getDataLayout()), 0,
                                        LoongArchII::MO_NO_FLAG);
    GlobalOrExternal = true;
  }
  else if (ExternalSymbolSDNode *S = dyn_cast<ExternalSymbolSDNode>(Callee)) {
    const char *Sym = S->getSymbol();
    Callee = DAG.getTargetExternalSymbol(
        Sym, getPointerTy(DAG.getDataLayout()), LoongArchII::MO_NO_FLAG);

    GlobalOrExternal = true;
  }

  SmallVector<SDValue, 8> Ops(1, Chain);
  SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);

  getOpndList(Ops, RegsToPass, IsPIC, GlobalOrExternal, IsCallReloc, CLI,
              Callee, Chain, IsTailCall);

  if (IsTailCall) {
    MF.getFrameInfo().setHasTailCall();
    return DAG.getNode(LoongArchISD::TailCall, DL, MVT::Other, Ops);
  }

  Chain = DAG.getNode(LoongArchISD::JmpLink, DL, NodeTys, Ops);
  DAG.addNoMergeSiteInfo(Chain.getNode(), CLI.NoMerge);
  SDValue InFlag = Chain.getValue(1);

  // Create the CALLSEQ_END node in the case of where it is not a call to
  // memcpy.
  if (!(MemcpyInByVal)) {
    Chain = DAG.getCALLSEQ_END(Chain, NextStackOffsetVal,
                               DAG.getIntPtrConstant(0, DL, true), InFlag, DL);
    InFlag = Chain.getValue(1);
  }

  // Handle result values, copying them out of physregs into vregs that we
  // return.
  return LowerCallResult(Chain, InFlag, CallConv, IsVarArg, Ins, DL, DAG,
                         InVals, CLI);
}

/// LowerCallResult - Lower the result values of a call into the
/// appropriate copies out of appropriate physical registers.
SDValue LoongArchTargetLowering::LowerCallResult(
    SDValue Chain, SDValue InFlag, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, const SDLoc &DL,
    SelectionDAG &DAG, SmallVectorImpl<SDValue> &InVals,
    TargetLowering::CallLoweringInfo &CLI) const {
  // Assign locations to each value returned by this call.
  SmallVector<CCValAssign, 16> RVLocs;
  LoongArchCCState CCInfo(CallConv, IsVarArg, DAG.getMachineFunction(), RVLocs,
                     *DAG.getContext());

  const ExternalSymbolSDNode *ES =
      dyn_cast_or_null<const ExternalSymbolSDNode>(CLI.Callee.getNode());
  CCInfo.AnalyzeCallResult(Ins, RetCC_LoongArch, CLI.RetTy,
                           ES ? ES->getSymbol() : nullptr);

  // Copy all of the result registers out of their specified physreg.
  for (unsigned i = 0; i != RVLocs.size(); ++i) {
    CCValAssign &VA = RVLocs[i];
    assert(VA.isRegLoc() && "Can only return in registers!");

    SDValue Val = DAG.getCopyFromReg(Chain, DL, RVLocs[i].getLocReg(),
                                     RVLocs[i].getLocVT(), InFlag);
    Chain = Val.getValue(1);
    InFlag = Val.getValue(2);

    if (VA.isUpperBitsInLoc()) {
      unsigned ValSizeInBits = Ins[i].ArgVT.getSizeInBits();
      unsigned LocSizeInBits = VA.getLocVT().getSizeInBits();
      unsigned Shift =
          VA.getLocInfo() == CCValAssign::ZExtUpper ? ISD::SRL : ISD::SRA;
      Val = DAG.getNode(
          Shift, DL, VA.getLocVT(), Val,
          DAG.getConstant(LocSizeInBits - ValSizeInBits, DL, VA.getLocVT()));
    }

    switch (VA.getLocInfo()) {
    default:
      llvm_unreachable("Unknown loc info!");
    case CCValAssign::Full:
      break;
    case CCValAssign::BCvt:
      Val = DAG.getNode(ISD::BITCAST, DL, VA.getValVT(), Val);
      break;
    case CCValAssign::AExt:
    case CCValAssign::AExtUpper:
      Val = DAG.getNode(ISD::TRUNCATE, DL, VA.getValVT(), Val);
      break;
    case CCValAssign::ZExt:
    case CCValAssign::ZExtUpper:
      Val = DAG.getNode(ISD::AssertZext, DL, VA.getLocVT(), Val,
                        DAG.getValueType(VA.getValVT()));
      Val = DAG.getNode(ISD::TRUNCATE, DL, VA.getValVT(), Val);
      break;
    case CCValAssign::SExt:
    case CCValAssign::SExtUpper:
      Val = DAG.getNode(ISD::AssertSext, DL, VA.getLocVT(), Val,
                        DAG.getValueType(VA.getValVT()));
      Val = DAG.getNode(ISD::TRUNCATE, DL, VA.getValVT(), Val);
      break;
    }

    InVals.push_back(Val);
  }

  return Chain;
}

static SDValue UnpackFromArgumentSlot(SDValue Val, const CCValAssign &VA,
                                      EVT ArgVT, const SDLoc &DL,
                                      SelectionDAG &DAG) {
  MVT LocVT = VA.getLocVT();
  EVT ValVT = VA.getValVT();

  // Shift into the upper bits if necessary.
  switch (VA.getLocInfo()) {
  default:
    break;
  case CCValAssign::AExtUpper:
  case CCValAssign::SExtUpper:
  case CCValAssign::ZExtUpper: {
    unsigned ValSizeInBits = ArgVT.getSizeInBits();
    unsigned LocSizeInBits = VA.getLocVT().getSizeInBits();
    unsigned Opcode =
        VA.getLocInfo() == CCValAssign::ZExtUpper ? ISD::SRL : ISD::SRA;
    Val = DAG.getNode(
        Opcode, DL, VA.getLocVT(), Val,
        DAG.getConstant(LocSizeInBits - ValSizeInBits, DL, VA.getLocVT()));
    break;
  }
  }

  // If this is an value smaller than the argument slot size (32-bit for LP32,
  // 64-bit for LPX32/LP64), it has been promoted in some way to the argument slot
  // size. Extract the value and insert any appropriate assertions regarding
  // sign/zero extension.
  switch (VA.getLocInfo()) {
  default:
    llvm_unreachable("Unknown loc info!");
  case CCValAssign::Full:
    break;
  case CCValAssign::AExtUpper:
  case CCValAssign::AExt:
    Val = DAG.getNode(ISD::TRUNCATE, DL, ValVT, Val);
    break;
  case CCValAssign::SExtUpper:
  case CCValAssign::SExt: {
    if ((ArgVT == MVT::i1) || (ArgVT == MVT::i8) || (ArgVT == MVT::i16)) {
      SDValue SubReg = DAG.getTargetConstant(LoongArch::sub_32, DL, MVT::i32);
      Val = SDValue(DAG.getMachineNode(TargetOpcode::EXTRACT_SUBREG, DL, ValVT,
                                       Val, SubReg),
                    0);
    } else {
      Val =
          DAG.getNode(ISD::AssertSext, DL, LocVT, Val, DAG.getValueType(ValVT));
      Val = DAG.getNode(ISD::TRUNCATE, DL, ValVT, Val);
    }
    break;
  }
  case CCValAssign::ZExtUpper:
  case CCValAssign::ZExt:
    Val = DAG.getNode(ISD::AssertZext, DL, LocVT, Val, DAG.getValueType(ValVT));
    Val = DAG.getNode(ISD::TRUNCATE, DL, ValVT, Val);
    break;
  case CCValAssign::BCvt:
    Val = DAG.getNode(ISD::BITCAST, DL, ValVT, Val);
    break;
  }

  return Val;
}

//===----------------------------------------------------------------------===//
//             Formal Arguments Calling Convention Implementation
//===----------------------------------------------------------------------===//
/// LowerFormalArguments - transform physical registers into virtual registers
/// and generate load operations for arguments places on the stack.
SDValue LoongArchTargetLowering::LowerFormalArguments(
    SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, const SDLoc &DL,
    SelectionDAG &DAG, SmallVectorImpl<SDValue> &InVals) const {
  MachineFunction &MF = DAG.getMachineFunction();
  MachineFrameInfo &MFI = MF.getFrameInfo();
  LoongArchFunctionInfo *LoongArchFI = MF.getInfo<LoongArchFunctionInfo>();

  LoongArchFI->setVarArgsFrameIndex(0);

  // Used with vargs to acumulate store chains.
  std::vector<SDValue> OutChains;

  // Assign locations to all of the incoming arguments.
  SmallVector<CCValAssign, 16> ArgLocs;
  LoongArchCCState CCInfo(CallConv, IsVarArg, DAG.getMachineFunction(), ArgLocs,
                          *DAG.getContext());
  const Function &Func = DAG.getMachineFunction().getFunction();
  Function::const_arg_iterator FuncArg = Func.arg_begin();

  CCInfo.AnalyzeFormalArguments(Ins, CC_LoongArch_FixedArg);
  LoongArchFI->setFormalArgInfo(CCInfo.getNextStackOffset(),
                           CCInfo.getInRegsParamsCount() > 0);

  unsigned CurArgIdx = 0;
  CCInfo.rewindByValRegsInfo();

  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    CCValAssign &VA = ArgLocs[i];
    if (Ins[i].isOrigArg()) {
      std::advance(FuncArg, Ins[i].getOrigArgIndex() - CurArgIdx);
      CurArgIdx = Ins[i].getOrigArgIndex();
    }
    EVT ValVT = VA.getValVT();
    ISD::ArgFlagsTy Flags = Ins[i].Flags;
    bool IsRegLoc = VA.isRegLoc();

    if (Flags.isByVal()) {
      assert(Ins[i].isOrigArg() && "Byval arguments cannot be implicit");
      unsigned FirstByValReg, LastByValReg;
      unsigned ByValIdx = CCInfo.getInRegsParamsProcessed();
      CCInfo.getInRegsParamInfo(ByValIdx, FirstByValReg, LastByValReg);

      assert(Flags.getByValSize() &&
             "ByVal args of size 0 should have been ignored by front-end.");
      assert(ByValIdx < CCInfo.getInRegsParamsCount());
      copyByValRegs(Chain, DL, OutChains, DAG, Flags, InVals, &*FuncArg,
                    FirstByValReg, LastByValReg, VA, CCInfo);
      CCInfo.nextInRegsParam();
      continue;
    }

    // Arguments stored on registers
    if (IsRegLoc) {
      MVT RegVT = VA.getLocVT();
      unsigned ArgReg = VA.getLocReg();
      const TargetRegisterClass *RC = getRegClassFor(RegVT);

      // Transform the arguments stored on
      // physical registers into virtual ones
      unsigned Reg = addLiveIn(DAG.getMachineFunction(), ArgReg, RC);
      SDValue ArgValue = DAG.getCopyFromReg(Chain, DL, Reg, RegVT);

      ArgValue = UnpackFromArgumentSlot(ArgValue, VA, Ins[i].ArgVT, DL, DAG);

      // Handle floating point arguments passed in integer registers and
      // long double arguments passed in floating point registers.
      if ((RegVT == MVT::i32 && ValVT == MVT::f32) ||
          (RegVT == MVT::i64 && ValVT == MVT::f64) ||
          (RegVT == MVT::f64 && ValVT == MVT::i64))
        ArgValue = DAG.getNode(ISD::BITCAST, DL, ValVT, ArgValue);
      else if (ABI.IsLP32() && RegVT == MVT::i32 &&
               ValVT == MVT::f64) {
        // TODO: lp32
      }

      InVals.push_back(ArgValue);
    } else { // VA.isRegLoc()
      MVT LocVT = VA.getLocVT();

      if (ABI.IsLP32()) {
        // We ought to be able to use LocVT directly but LP32 sets it to i32
        // when allocating floating point values to integer registers.
        // This shouldn't influence how we load the value into registers unless
        // we are targeting softfloat.
        if (VA.getValVT().isFloatingPoint() && !Subtarget.useSoftFloat())
          LocVT = VA.getValVT();
      }

      // sanity check
      assert(VA.isMemLoc());

      // The stack pointer offset is relative to the caller stack frame.
      int FI = MFI.CreateFixedObject(LocVT.getSizeInBits() / 8,
                                     VA.getLocMemOffset(), true);

      // Create load nodes to retrieve arguments from the stack
      SDValue FIN = DAG.getFrameIndex(FI, getPointerTy(DAG.getDataLayout()));
      SDValue ArgValue = DAG.getLoad(
          LocVT, DL, Chain, FIN,
          MachinePointerInfo::getFixedStack(DAG.getMachineFunction(), FI));
      OutChains.push_back(ArgValue.getValue(1));

      ArgValue = UnpackFromArgumentSlot(ArgValue, VA, Ins[i].ArgVT, DL, DAG);

      InVals.push_back(ArgValue);
    }
  }

  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    // The loongarch ABIs for returning structs by value requires that we copy
    // the sret argument into $v0 for the return. Save the argument into
    // a virtual register so that we can access it from the return points.
    if (Ins[i].Flags.isSRet()) {
      unsigned Reg = LoongArchFI->getSRetReturnReg();
      if (!Reg) {
        Reg = MF.getRegInfo().createVirtualRegister(
            getRegClassFor(ABI.IsLP64() ? MVT::i64 : MVT::i32));
        LoongArchFI->setSRetReturnReg(Reg);
      }
      SDValue Copy = DAG.getCopyToReg(DAG.getEntryNode(), DL, Reg, InVals[i]);
      Chain = DAG.getNode(ISD::TokenFactor, DL, MVT::Other, Copy, Chain);
      break;
    }
  }

  if (IsVarArg)
    writeVarArgRegs(OutChains, Chain, DL, DAG, CCInfo);

  // All stores are grouped in one node to allow the matching between
  // the size of Ins and InVals. This only happens when on varg functions
  if (!OutChains.empty()) {
    OutChains.push_back(Chain);
    Chain = DAG.getNode(ISD::TokenFactor, DL, MVT::Other, OutChains);
  }

  return Chain;
}

//===----------------------------------------------------------------------===//
//               Return Value Calling Convention Implementation
//===----------------------------------------------------------------------===//

bool
LoongArchTargetLowering::CanLowerReturn(CallingConv::ID CallConv,
                                   MachineFunction &MF, bool IsVarArg,
                                   const SmallVectorImpl<ISD::OutputArg> &Outs,
                                   LLVMContext &Context) const {
  SmallVector<CCValAssign, 16> RVLocs;
  LoongArchCCState CCInfo(CallConv, IsVarArg, MF, RVLocs, Context);
  return CCInfo.CheckReturn(Outs, RetCC_LoongArch);
}

bool
LoongArchTargetLowering::shouldSignExtendTypeInLibCall(EVT Type, bool IsSigned) const {
  if ((ABI.IsLPX32() || ABI.IsLP64()) && Type == MVT::i32)
      return true;

  return IsSigned;
}

SDValue
LoongArchTargetLowering::LowerReturn(SDValue Chain, CallingConv::ID CallConv,
                                bool IsVarArg,
                                const SmallVectorImpl<ISD::OutputArg> &Outs,
                                const SmallVectorImpl<SDValue> &OutVals,
                                const SDLoc &DL, SelectionDAG &DAG) const {
  // CCValAssign - represent the assignment of
  // the return value to a location
  SmallVector<CCValAssign, 16> RVLocs;
  MachineFunction &MF = DAG.getMachineFunction();

  // CCState - Info about the registers and stack slot.
  LoongArchCCState CCInfo(CallConv, IsVarArg, MF, RVLocs, *DAG.getContext());

  // Analyze return values.
  CCInfo.AnalyzeReturn(Outs, RetCC_LoongArch);

  SDValue Flag;
  SmallVector<SDValue, 4> RetOps(1, Chain);

  // Copy the result values into the output registers.
  for (unsigned i = 0; i != RVLocs.size(); ++i) {
    SDValue Val = OutVals[i];
    CCValAssign &VA = RVLocs[i];
    assert(VA.isRegLoc() && "Can only return in registers!");
    bool UseUpperBits = false;

    switch (VA.getLocInfo()) {
    default:
      llvm_unreachable("Unknown loc info!");
    case CCValAssign::Full:
      break;
    case CCValAssign::BCvt:
      Val = DAG.getNode(ISD::BITCAST, DL, VA.getLocVT(), Val);
      break;
    case CCValAssign::AExtUpper:
      UseUpperBits = true;
      LLVM_FALLTHROUGH;
    case CCValAssign::AExt:
      Val = DAG.getNode(ISD::ANY_EXTEND, DL, VA.getLocVT(), Val);
      break;
    case CCValAssign::ZExtUpper:
      UseUpperBits = true;
      LLVM_FALLTHROUGH;
    case CCValAssign::ZExt:
      Val = DAG.getNode(ISD::ZERO_EXTEND, DL, VA.getLocVT(), Val);
      break;
    case CCValAssign::SExtUpper:
      UseUpperBits = true;
      LLVM_FALLTHROUGH;
    case CCValAssign::SExt:
      Val = DAG.getNode(ISD::SIGN_EXTEND, DL, VA.getLocVT(), Val);
      break;
    }

    if (UseUpperBits) {
      unsigned ValSizeInBits = Outs[i].ArgVT.getSizeInBits();
      unsigned LocSizeInBits = VA.getLocVT().getSizeInBits();
      Val = DAG.getNode(
          ISD::SHL, DL, VA.getLocVT(), Val,
          DAG.getConstant(LocSizeInBits - ValSizeInBits, DL, VA.getLocVT()));
    }

    Chain = DAG.getCopyToReg(Chain, DL, VA.getLocReg(), Val, Flag);

    // Guarantee that all emitted copies are stuck together with flags.
    Flag = Chain.getValue(1);
    RetOps.push_back(DAG.getRegister(VA.getLocReg(), VA.getLocVT()));
  }

  // The loongarch ABIs for returning structs by value requires that we copy
  // the sret argument into $v0 for the return. We saved the argument into
  // a virtual register in the entry block, so now we copy the value out
  // and into $v0.
  if (MF.getFunction().hasStructRetAttr()) {
    LoongArchFunctionInfo *LoongArchFI = MF.getInfo<LoongArchFunctionInfo>();
    unsigned Reg = LoongArchFI->getSRetReturnReg();

    if (!Reg)
      llvm_unreachable("sret virtual register not created in the entry block");
    SDValue Val =
        DAG.getCopyFromReg(Chain, DL, Reg, getPointerTy(DAG.getDataLayout()));
    unsigned A0 = ABI.IsLP64() ? LoongArch::A0_64 : LoongArch::A0;

    Chain = DAG.getCopyToReg(Chain, DL, A0, Val, Flag);
    Flag = Chain.getValue(1);
    RetOps.push_back(DAG.getRegister(A0, getPointerTy(DAG.getDataLayout())));
  }

  RetOps[0] = Chain;  // Update chain.

  // Add the flag if we have it.
  if (Flag.getNode())
    RetOps.push_back(Flag);

  // Standard return on LoongArch is a "jr $ra"
  return DAG.getNode(LoongArchISD::Ret, DL, MVT::Other, RetOps);
}

//===----------------------------------------------------------------------===//
//                           LoongArch Inline Assembly Support
//===----------------------------------------------------------------------===//

/// getConstraintType - Given a constraint letter, return the type of
/// constraint it is for this target.
LoongArchTargetLowering::ConstraintType
LoongArchTargetLowering::getConstraintType(StringRef Constraint) const {
  // LoongArch specific constraints
  // GCC config/loongarch/constraints.md
  //
  // 'f': Floating Point register
  // 'G': Floating-point 0
  // 'l': Signed 16-bit constant
  // 'R': Memory address that can be used in a non-macro load or store
  // "ZC" Memory address with 16-bit and 4 bytes aligned offset
  // "ZB" Memory address with 0 offset

  if (Constraint.size() == 1) {
    switch (Constraint[0]) {
      default : break;
      case 'f':
        return C_RegisterClass;
      case 'l':
      case 'G':
        return C_Other;
      case 'R':
        return C_Memory;
    }
  }

  if (Constraint == "ZC" || Constraint == "ZB")
    return C_Memory;

  return TargetLowering::getConstraintType(Constraint);
}

/// Examine constraint type and operand type and determine a weight value.
/// This object must already have been set up with the operand type
/// and the current alternative constraint selected.
TargetLowering::ConstraintWeight
LoongArchTargetLowering::getSingleConstraintMatchWeight(
    AsmOperandInfo &info, const char *constraint) const {
  ConstraintWeight weight = CW_Invalid;
  Value *CallOperandVal = info.CallOperandVal;
    // If we don't have a value, we can't do a match,
    // but allow it at the lowest weight.
  if (!CallOperandVal)
    return CW_Default;
  Type *type = CallOperandVal->getType();
  // Look at the constraint type.
  switch (*constraint) {
  default:
    weight = TargetLowering::getSingleConstraintMatchWeight(info, constraint);
    break;
  case 'f': // FPU
    if (Subtarget.hasLSX() && type->isVectorTy() &&
        type->getPrimitiveSizeInBits() == 128)
      weight = CW_Register;
    else if (Subtarget.hasLASX() && type->isVectorTy() &&
             type->getPrimitiveSizeInBits() == 256)
      weight = CW_Register;
    else if (type->isFloatTy())
      weight = CW_Register;
    break;
  case 'l': // signed 16 bit immediate
  case 'I': // signed 12 bit immediate
  case 'J': // integer zero
  case 'G': // floating-point zero
  case 'K': // unsigned 12 bit immediate
    if (isa<ConstantInt>(CallOperandVal))
      weight = CW_Constant;
    break;
  case 'm':
  case 'R':
    weight = CW_Memory;
    break;
  }
  return weight;
}

/// This is a helper function to parse a physical register string and split it
/// into non-numeric and numeric parts (Prefix and Reg). The first boolean flag
/// that is returned indicates whether parsing was successful. The second flag
/// is true if the numeric part exists.
static std::pair<bool, bool> parsePhysicalReg(StringRef C, StringRef &Prefix,
                                              unsigned long long &Reg) {
  if (C.empty() || C.front() != '{' || C.back() != '}')
    return std::make_pair(false, false);

  // Search for the first numeric character.
  StringRef::const_iterator I, B = C.begin() + 1, E = C.end() - 1;
  I = std::find_if(B, E, isdigit);

  Prefix = StringRef(B, I - B);

  // The second flag is set to false if no numeric characters were found.
  if (I == E)
    return std::make_pair(true, false);

  // Parse the numeric characters.
  return std::make_pair(!getAsUnsignedInteger(StringRef(I, E - I), 10, Reg),
                        true);
}

EVT LoongArchTargetLowering::getTypeForExtReturn(LLVMContext &Context, EVT VT,
                                            ISD::NodeType) const {
  bool Cond = !Subtarget.isABI_LP32() && VT.getSizeInBits() == 32;
  EVT MinVT = getRegisterType(Context, Cond ? MVT::i64 : MVT::i32);
  return VT.bitsLT(MinVT) ? MinVT : VT;
}

static const TargetRegisterClass *getRegisterClassForVT(MVT VT, bool Is64Bit) {
  // Newer llvm versions (>= 12) do not require simple VTs for constraints and
  // they use MVT::Other for constraints with complex VTs. For more details,
  // please see https://reviews.llvm.org/D91710.
  if (VT == MVT::Other || VT.getSizeInBits() <= 32)
    return &LoongArch::GPR32RegClass;
  if (VT.getSizeInBits() <= 64)
    return Is64Bit ? &LoongArch::GPR64RegClass : &LoongArch::GPR32RegClass;
  return nullptr;
}

std::pair<unsigned, const TargetRegisterClass *> LoongArchTargetLowering::
parseRegForInlineAsmConstraint(StringRef C, MVT VT) const {
  const TargetRegisterInfo *TRI =
      Subtarget.getRegisterInfo();
  const TargetRegisterClass *RC;
  StringRef Prefix;
  unsigned long long Reg;

  std::pair<bool, bool> R = parsePhysicalReg(C, Prefix, Reg);

  if (!R.first)
    return std::make_pair(0U, nullptr);

  if (!R.second)
    return std::make_pair(0U, nullptr);

  if (Prefix == "$f") { // Parse $f0-$f31.
    // If the size of FP registers is 64-bit or Reg is an even number, select
    // the 64-bit register class. Otherwise, select the 32-bit register class.
    if (VT == MVT::Other)
      VT = (Subtarget.isFP64bit() || !(Reg % 2)) ? MVT::f64 : MVT::f32;

    RC = getRegClassFor(VT);
  }
  else if (Prefix == "$vr") { // Parse $vr0-$vr31.
    RC = getRegClassFor((VT == MVT::Other) ? MVT::v16i8 : VT);
  }
  else if (Prefix == "$xr") { // Parse $xr0-$xr31.
    RC = getRegClassFor((VT == MVT::Other) ? MVT::v16i8 : VT);
  }
  else if (Prefix == "$fcc") // Parse $fcc0-$fcc7.
    RC = TRI->getRegClass(LoongArch::FCFRRegClassID);
  else { // Parse $r0-$r31.
    assert(Prefix == "$r");
    if ((RC = getRegisterClassForVT(VT, Subtarget.is64Bit())) == nullptr) {
      // This will generate an error message.
      return std::make_pair(0U, nullptr);
    }
  }

  assert(Reg < RC->getNumRegs());

  if (RC == &LoongArch::GPR64RegClass || RC == &LoongArch::GPR32RegClass) {
    // Sync with the GPR32/GPR64 RegisterClass in LoongArchRegisterInfo.td
    // that just like LoongArchAsmParser.cpp
    switch (Reg) {
      case 0: return std::make_pair(*(RC->begin() + 0), RC); // r0
      case 1: return std::make_pair(*(RC->begin() + 27), RC); // r1
      case 2: return std::make_pair(*(RC->begin() + 28), RC); // r2
      case 3: return std::make_pair(*(RC->begin() + 29), RC); // r3
      case 4: return std::make_pair(*(RC->begin() + 1), RC); // r4
      case 5: return std::make_pair(*(RC->begin() + 2), RC); // r5
      case 6: return std::make_pair(*(RC->begin() + 3), RC); // r6
      case 7: return std::make_pair(*(RC->begin() + 4), RC); // r7
      case 8: return std::make_pair(*(RC->begin() + 5), RC); // r8
      case 9: return std::make_pair(*(RC->begin() + 6), RC); // r9
      case 10: return std::make_pair(*(RC->begin() + 7), RC); // r10
      case 11: return std::make_pair(*(RC->begin() + 8), RC); // r11
      case 12: return std::make_pair(*(RC->begin() + 9), RC); // r12
      case 13: return std::make_pair(*(RC->begin() + 10), RC); // r13
      case 14: return std::make_pair(*(RC->begin() + 11), RC); // r14
      case 15: return std::make_pair(*(RC->begin() + 12), RC); // r15
      case 16: return std::make_pair(*(RC->begin() + 13), RC); // r16
      case 17: return std::make_pair(*(RC->begin() + 14), RC); // r17
      case 18: return std::make_pair(*(RC->begin() + 15), RC); // r18
      case 19: return std::make_pair(*(RC->begin() + 16), RC); // r19
      case 20: return std::make_pair(*(RC->begin() + 17), RC); // r20
      case 21: return std::make_pair(*(RC->begin() + 30), RC); // r21
      case 22: return std::make_pair(*(RC->begin() + 31), RC); // r22
      case 23: return std::make_pair(*(RC->begin() + 18), RC); // r23
      case 24: return std::make_pair(*(RC->begin() + 19), RC); // r24
      case 25: return std::make_pair(*(RC->begin() + 20), RC); // r25
      case 26: return std::make_pair(*(RC->begin() + 21), RC); // r26
      case 27: return std::make_pair(*(RC->begin() + 22), RC); // r27
      case 28: return std::make_pair(*(RC->begin() + 23), RC); // r28
      case 29: return std::make_pair(*(RC->begin() + 24), RC); // r29
      case 30: return std::make_pair(*(RC->begin() + 25), RC); // r30
      case 31: return std::make_pair(*(RC->begin() + 26), RC); // r31
    }
  }
  return std::make_pair(*(RC->begin() + Reg), RC);
}

/// Given a register class constraint, like 'r', if this corresponds directly
/// to an LLVM register class, return a register of 0 and the register class
/// pointer.
std::pair<unsigned, const TargetRegisterClass *>
LoongArchTargetLowering::getRegForInlineAsmConstraint(const TargetRegisterInfo *TRI,
                                                 StringRef Constraint,
                                                 MVT VT) const {
    if (Constraint.size() == 1) {
    switch (Constraint[0]) {
    case 'r':
      return std::make_pair(0U, getRegisterClassForVT(VT, Subtarget.is64Bit()));
    case 'f': // FPU or LSX register
      if (VT == MVT::v16i8)
        return std::make_pair(0U, &LoongArch::LSX128BRegClass);
      else if (VT == MVT::v8i16)
        return std::make_pair(0U, &LoongArch::LSX128HRegClass);
      else if (VT == MVT::v4i32 || VT == MVT::v4f32)
        return std::make_pair(0U, &LoongArch::LSX128WRegClass);
      else if (VT == MVT::v2i64 || VT == MVT::v2f64)
        return std::make_pair(0U, &LoongArch::LSX128DRegClass);
      else if (VT == MVT::v32i8)
        return std::make_pair(0U, &LoongArch::LASX256BRegClass);
      else if (VT == MVT::v16i16)
        return std::make_pair(0U, &LoongArch::LASX256HRegClass);
      else if (VT == MVT::v8i32 || VT == MVT::v8f32)
        return std::make_pair(0U, &LoongArch::LASX256WRegClass);
      else if (VT == MVT::v4i64 || VT == MVT::v4f64)
        return std::make_pair(0U, &LoongArch::LASX256DRegClass);
      else if (VT == MVT::f32)
        return std::make_pair(0U, &LoongArch::FGR32RegClass);
      else if (VT == MVT::f64)
        return std::make_pair(0U, &LoongArch::FGR64RegClass);
      break;
    }
  }

  std::pair<unsigned, const TargetRegisterClass *> R;
  R = parseRegForInlineAsmConstraint(Constraint, VT);

  if (R.second)
    return R;

  return TargetLowering::getRegForInlineAsmConstraint(TRI, Constraint, VT);
}

/// LowerAsmOperandForConstraint - Lower the specified operand into the Ops
/// vector.  If it is invalid, don't add anything to Ops.
void LoongArchTargetLowering::LowerAsmOperandForConstraint(SDValue Op,
                                                     std::string &Constraint,
                                                     std::vector<SDValue>&Ops,
                                                     SelectionDAG &DAG) const {
  SDLoc DL(Op);
  SDValue Result;

  // Only support length 1 constraints for now.
  if (Constraint.length() > 1) return;

  char ConstraintLetter = Constraint[0];
  switch (ConstraintLetter) {
  default: break; // This will fall through to the generic implementation
  case 'l': // Signed 16 bit constant
    // If this fails, the parent routine will give an error
    if (ConstantSDNode *C = dyn_cast<ConstantSDNode>(Op)) {
      EVT Type = Op.getValueType();
      int64_t Val = C->getSExtValue();
      if (isInt<16>(Val)) {
        Result = DAG.getTargetConstant(Val, DL, Type);
        break;
      }
    }
    return;
  case 'I': // Signed 12 bit constant
    // If this fails, the parent routine will give an error
    if (ConstantSDNode *C = dyn_cast<ConstantSDNode>(Op)) {
      EVT Type = Op.getValueType();
      int64_t Val = C->getSExtValue();
      if (isInt<12>(Val)) {
        Result = DAG.getTargetConstant(Val, DL, Type);
        break;
      }
    }
    return;
  case 'J': // integer zero
    if (ConstantSDNode *C = dyn_cast<ConstantSDNode>(Op)) {
      EVT Type = Op.getValueType();
      int64_t Val = C->getZExtValue();
      if (Val == 0) {
        Result = DAG.getTargetConstant(0, DL, Type);
        break;
      }
    }
    return;
  case 'G': // floating-point zero
    if (ConstantFPSDNode *C = dyn_cast<ConstantFPSDNode>(Op)) {
      if (C->isZero()) {
        EVT Type = Op.getValueType();
        Result = DAG.getTargetConstantFP(0, DL, Type);
        break;
      }
    }
    return;
  case 'K': // unsigned 12 bit immediate
    if (ConstantSDNode *C = dyn_cast<ConstantSDNode>(Op)) {
      EVT Type = Op.getValueType();
      uint64_t Val = (uint64_t)C->getZExtValue();
      if (isUInt<12>(Val)) {
        Result = DAG.getTargetConstant(Val, DL, Type);
        break;
      }
    }
    return;
  }

  if (Result.getNode()) {
    Ops.push_back(Result);
    return;
  }

  TargetLowering::LowerAsmOperandForConstraint(Op, Constraint, Ops, DAG);
}

bool LoongArchTargetLowering::isLegalAddressingMode(const DataLayout &DL,
                                               const AddrMode &AM, Type *Ty,
                                               unsigned AS, Instruction *I) const {
  // No global is ever allowed as a base.
  if (AM.BaseGV)
    return false;

  switch (AM.Scale) {
  case 0: // "r+i" or just "i", depending on HasBaseReg.
    break;
  case 1:
    if (!AM.HasBaseReg) // allow "r+i".
      break;
    return false; // disallow "r+r" or "r+r+i".
  default:
    return false;
  }

  return true;
}

bool
LoongArchTargetLowering::isOffsetFoldingLegal(const GlobalAddressSDNode *GA) const {
  // The LoongArch target isn't yet aware of offsets.
  return false;
}

EVT LoongArchTargetLowering::getOptimalMemOpType(
    const MemOp &Op, const AttributeList &FuncAttributes) const {
  if (!FuncAttributes.hasFnAttribute(Attribute::NoImplicitFloat)) {
    if (Op.size() >= 16) {
      if (Op.size() >= 32 && Subtarget.hasLASX()) {
        return MVT::v32i8;
      }
      if (Subtarget.hasLSX())
        return MVT::v16i8;
    }
  }

  if (Subtarget.is64Bit())
    return MVT::i64;

  return MVT::i32;
}

/// isFPImmLegal - Returns true if the target can instruction select the
/// specified FP immediate natively. If false, the legalizer will
/// materialize the FP immediate as a load from a constant pool.
bool LoongArchTargetLowering::isFPImmLegal(const APFloat &Imm, EVT VT,
                                           bool ForCodeSize) const {
  if (VT != MVT::f32 && VT != MVT::f64)
    return false;
  if (Imm.isNegZero())
    return false;
  return (Imm.isZero() || Imm.isExactlyValue(+1.0));
}

bool LoongArchTargetLowering::useSoftFloat() const {
  return Subtarget.useSoftFloat();
}

// Return whether the an instruction can potentially be optimized to a tail
// call. This will cause the optimizers to attempt to move, or duplicate,
// return instructions to help enable tail call optimizations for this
// instruction.
bool LoongArchTargetLowering::mayBeEmittedAsTailCall(const CallInst *CI) const {
  return CI->isTailCall();
}

void LoongArchTargetLowering::copyByValRegs(
    SDValue Chain, const SDLoc &DL, std::vector<SDValue> &OutChains,
    SelectionDAG &DAG, const ISD::ArgFlagsTy &Flags,
    SmallVectorImpl<SDValue> &InVals, const Argument *FuncArg,
    unsigned FirstReg, unsigned LastReg, const CCValAssign &VA,
    LoongArchCCState &State) const {
  MachineFunction &MF = DAG.getMachineFunction();
  MachineFrameInfo &MFI = MF.getFrameInfo();
  unsigned GPRSizeInBytes = Subtarget.getGPRSizeInBytes();
  unsigned NumRegs = LastReg - FirstReg;
  unsigned RegAreaSize = NumRegs * GPRSizeInBytes;
  unsigned FrameObjSize = std::max(Flags.getByValSize(), RegAreaSize);
  int FrameObjOffset;
  ArrayRef<MCPhysReg> ByValArgRegs = ABI.GetByValArgRegs();

  if (RegAreaSize)
    FrameObjOffset = -(int)((ByValArgRegs.size() - FirstReg) * GPRSizeInBytes);
  else
    FrameObjOffset = VA.getLocMemOffset();

  // Create frame object.
  EVT PtrTy = getPointerTy(DAG.getDataLayout());
  // Make the fixed object stored to mutable so that the load instructions
  // referencing it have their memory dependencies added.
  // Set the frame object as isAliased which clears the underlying objects
  // vector in ScheduleDAGInstrs::buildSchedGraph() resulting in addition of all
  // stores as dependencies for loads referencing this fixed object.
  int FI = MFI.CreateFixedObject(FrameObjSize, FrameObjOffset, false, true);
  SDValue FIN = DAG.getFrameIndex(FI, PtrTy);
  InVals.push_back(FIN);

  if (!NumRegs)
    return;

  // Copy arg registers.
  MVT RegTy = MVT::getIntegerVT(GPRSizeInBytes * 8);
  const TargetRegisterClass *RC = getRegClassFor(RegTy);

  for (unsigned I = 0; I < NumRegs; ++I) {
    unsigned ArgReg = ByValArgRegs[FirstReg + I];
    unsigned VReg = addLiveIn(MF, ArgReg, RC);
    unsigned Offset = I * GPRSizeInBytes;
    SDValue StorePtr = DAG.getNode(ISD::ADD, DL, PtrTy, FIN,
                                   DAG.getConstant(Offset, DL, PtrTy));
    SDValue Store = DAG.getStore(Chain, DL, DAG.getRegister(VReg, RegTy),
                                 StorePtr, MachinePointerInfo(FuncArg, Offset));
    OutChains.push_back(Store);
  }
}

// Copy byVal arg to registers and stack.
void LoongArchTargetLowering::passByValArg(
    SDValue Chain, const SDLoc &DL,
    std::deque<std::pair<unsigned, SDValue>> &RegsToPass,
    SmallVectorImpl<SDValue> &MemOpChains, SDValue StackPtr,
    MachineFrameInfo &MFI, SelectionDAG &DAG, SDValue Arg, unsigned FirstReg,
    unsigned LastReg, const ISD::ArgFlagsTy &Flags,
    const CCValAssign &VA) const {
  unsigned ByValSizeInBytes = Flags.getByValSize();
  unsigned OffsetInBytes = 0; // From beginning of struct
  unsigned RegSizeInBytes = Subtarget.getGPRSizeInBytes();
  Align Alignment =
      std::min(Flags.getNonZeroByValAlign(), Align(RegSizeInBytes));
  EVT PtrTy = getPointerTy(DAG.getDataLayout()),
      RegTy = MVT::getIntegerVT(RegSizeInBytes * 8);
  unsigned NumRegs = LastReg - FirstReg;

  if (NumRegs) {
    ArrayRef<MCPhysReg> ArgRegs = ABI.GetByValArgRegs();
    bool LeftoverBytes = (NumRegs * RegSizeInBytes > ByValSizeInBytes);
    unsigned I = 0;

    // Copy words to registers.
    for (; I < NumRegs - LeftoverBytes; ++I, OffsetInBytes += RegSizeInBytes) {
      SDValue LoadPtr = DAG.getNode(ISD::ADD, DL, PtrTy, Arg,
                                    DAG.getConstant(OffsetInBytes, DL, PtrTy));
      SDValue LoadVal = DAG.getLoad(RegTy, DL, Chain, LoadPtr,
                                    MachinePointerInfo(), Alignment);
      MemOpChains.push_back(LoadVal.getValue(1));
      unsigned ArgReg = ArgRegs[FirstReg + I];
      RegsToPass.push_back(std::make_pair(ArgReg, LoadVal));
    }

    // Return if the struct has been fully copied.
    if (ByValSizeInBytes == OffsetInBytes)
      return;

    // Copy the remainder of the byval argument with sub-word loads and shifts.
    if (LeftoverBytes) {
      SDValue Val;

      for (unsigned LoadSizeInBytes = RegSizeInBytes / 2, TotalBytesLoaded = 0;
           OffsetInBytes < ByValSizeInBytes; LoadSizeInBytes /= 2) {
        unsigned RemainingSizeInBytes = ByValSizeInBytes - OffsetInBytes;

        if (RemainingSizeInBytes < LoadSizeInBytes)
          continue;

        // Load subword.
        SDValue LoadPtr = DAG.getNode(ISD::ADD, DL, PtrTy, Arg,
                                      DAG.getConstant(OffsetInBytes, DL,
                                                      PtrTy));
        SDValue LoadVal = DAG.getExtLoad(
            ISD::ZEXTLOAD, DL, RegTy, Chain, LoadPtr, MachinePointerInfo(),
            MVT::getIntegerVT(LoadSizeInBytes * 8), Alignment);
        MemOpChains.push_back(LoadVal.getValue(1));

        // Shift the loaded value.
        unsigned Shamt;

        Shamt = TotalBytesLoaded * 8;

        SDValue Shift = DAG.getNode(ISD::SHL, DL, RegTy, LoadVal,
                                    DAG.getConstant(Shamt, DL, MVT::i32));

        if (Val.getNode())
          Val = DAG.getNode(ISD::OR, DL, RegTy, Val, Shift);
        else
          Val = Shift;

        OffsetInBytes += LoadSizeInBytes;
        TotalBytesLoaded += LoadSizeInBytes;
        Alignment = std::min(Alignment, Align(LoadSizeInBytes));
      }

      unsigned ArgReg = ArgRegs[FirstReg + I];
      RegsToPass.push_back(std::make_pair(ArgReg, Val));
      return;
    }
  }

  // Copy remainder of byval arg to it with memcpy.
  unsigned MemCpySize = ByValSizeInBytes - OffsetInBytes;
  SDValue Src = DAG.getNode(ISD::ADD, DL, PtrTy, Arg,
                            DAG.getConstant(OffsetInBytes, DL, PtrTy));
  SDValue Dst = DAG.getNode(ISD::ADD, DL, PtrTy, StackPtr,
                            DAG.getIntPtrConstant(VA.getLocMemOffset(), DL));
  Chain = DAG.getMemcpy(
      Chain, DL, Dst, Src, DAG.getConstant(MemCpySize, DL, PtrTy),
      Align(Alignment), /*isVolatile=*/false, /*AlwaysInline=*/false,
      /*isTailCall=*/false, MachinePointerInfo(), MachinePointerInfo());
  MemOpChains.push_back(Chain);
}

void LoongArchTargetLowering::writeVarArgRegs(std::vector<SDValue> &OutChains,
                                         SDValue Chain, const SDLoc &DL,
                                         SelectionDAG &DAG,
                                         CCState &State) const {
  ArrayRef<MCPhysReg> ArgRegs = ABI.GetVarArgRegs();
  unsigned Idx = State.getFirstUnallocated(ArgRegs);
  unsigned RegSizeInBytes = Subtarget.getGPRSizeInBytes();
  MVT RegTy = MVT::getIntegerVT(RegSizeInBytes * 8);
  const TargetRegisterClass *RC = getRegClassFor(RegTy);
  MachineFunction &MF = DAG.getMachineFunction();
  MachineFrameInfo &MFI = MF.getFrameInfo();
  LoongArchFunctionInfo *LoongArchFI = MF.getInfo<LoongArchFunctionInfo>();

  // Offset of the first variable argument from stack pointer.
  int VaArgOffset, VarArgsSaveSize;

  if (ArgRegs.size() == Idx) {
    VaArgOffset = alignTo(State.getNextStackOffset(), RegSizeInBytes);
    VarArgsSaveSize = 0;
  } else {
    VarArgsSaveSize = (int)(RegSizeInBytes * (ArgRegs.size() - Idx));
    VaArgOffset = -VarArgsSaveSize;
  }

  // Record the frame index of the first variable argument
  // which is a value necessary to VASTART.
  int FI = MFI.CreateFixedObject(RegSizeInBytes, VaArgOffset, true);
  LoongArchFI->setVarArgsFrameIndex(FI);

  // If saving an odd number of registers then create an extra stack slot to
  // ensure that the frame pointer is 2*GRLEN-aligned, which in turn ensures
  // offsets to even-numbered registered remain 2*GRLEN-aligned.
  if (Idx % 2) {
    MFI.CreateFixedObject(RegSizeInBytes, VaArgOffset - (int)RegSizeInBytes,
                          true);
    VarArgsSaveSize += RegSizeInBytes;
  }

  // Copy the integer registers that have not been used for argument passing
  // to the argument register save area. For LP32, the save area is allocated
  // in the caller's stack frame, while for LPX32/LP64, it is allocated in the
  // callee's stack frame.
  for (unsigned I = Idx; I < ArgRegs.size();
       ++I, VaArgOffset += RegSizeInBytes) {
    unsigned Reg = addLiveIn(MF, ArgRegs[I], RC);
    SDValue ArgValue = DAG.getCopyFromReg(Chain, DL, Reg, RegTy);
    FI = MFI.CreateFixedObject(RegSizeInBytes, VaArgOffset, true);
    SDValue PtrOff = DAG.getFrameIndex(FI, getPointerTy(DAG.getDataLayout()));
    SDValue Store =
        DAG.getStore(Chain, DL, ArgValue, PtrOff, MachinePointerInfo());
    cast<StoreSDNode>(Store.getNode())->getMemOperand()->setValue(
        (Value *)nullptr);
    OutChains.push_back(Store);
  }
  LoongArchFI->setVarArgsSaveSize(VarArgsSaveSize);
}

void LoongArchTargetLowering::HandleByVal(CCState *State, unsigned &Size,
                                          Align Alignment) const {
  const TargetFrameLowering *TFL = Subtarget.getFrameLowering();

  assert(Size && "Byval argument's size shouldn't be 0.");

  Alignment = std::min(Alignment, TFL->getStackAlign());

  unsigned FirstReg = 0;
  unsigned NumRegs = 0;
  unsigned RegSizeInBytes = Subtarget.getGPRSizeInBytes();
  ArrayRef<MCPhysReg> IntArgRegs = ABI.GetByValArgRegs();
  // FIXME: The LP32 case actually describes no shadow registers.
  const MCPhysReg *ShadowRegs =
      ABI.IsLP32() ? IntArgRegs.data() : LoongArch64DPRegs;

  // We used to check the size as well but we can't do that anymore since
  // CCState::HandleByVal() rounds up the size after calling this function.
  assert(Alignment >= Align(RegSizeInBytes) &&
         "Byval argument's alignment should be a multiple of RegSizeInBytes.");

  FirstReg = State->getFirstUnallocated(IntArgRegs);

  // If Alignment > RegSizeInBytes, the first arg register must be even.
  // FIXME: This condition happens to do the right thing but it's not the
  //        right way to test it. We want to check that the stack frame offset
  //        of the register is aligned.
  if ((Alignment > RegSizeInBytes) && (FirstReg % 2)) {
    State->AllocateReg(IntArgRegs[FirstReg], ShadowRegs[FirstReg]);
    ++FirstReg;
    // assert(true && "debug#######################################");
  }

  // Mark the registers allocated.
  // Size = alignTo(Size, RegSizeInBytes);
  // for (unsigned I = FirstReg; Size > 0 && (I < IntArgRegs.size());
  //     Size -= RegSizeInBytes, ++I, ++NumRegs)
  //  State->AllocateReg(IntArgRegs[I], ShadowRegs[I]);

  State->addInRegsParamInfo(FirstReg, FirstReg + NumRegs);
}

MachineBasicBlock *LoongArchTargetLowering::emitPseudoSELECT(MachineInstr &MI,
                                                        MachineBasicBlock *BB,
                                                        bool isFPCmp,
                                                        unsigned Opc) const {
  const TargetInstrInfo *TII =
      Subtarget.getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();

  // To "insert" a SELECT instruction, we actually have to insert the
  // diamond control-flow pattern.  The incoming instruction knows the
  // destination vreg to set, the condition code register to branch on, the
  // true/false values to select between, and a branch opcode to use.
  const BasicBlock *LLVM_BB = BB->getBasicBlock();
  MachineFunction::iterator It = ++BB->getIterator();

  //  thisMBB:
  //  ...
  //   TrueVal = ...
  //   setcc r1, r2, r3
  //   bNE   r1, r0, copy1MBB
  //   fallthrough --> copy0MBB
  MachineBasicBlock *thisMBB  = BB;
  MachineFunction *F = BB->getParent();
  MachineBasicBlock *copy0MBB = F->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *sinkMBB  = F->CreateMachineBasicBlock(LLVM_BB);
  F->insert(It, copy0MBB);
  F->insert(It, sinkMBB);

  // Transfer the remainder of BB and its successor edges to sinkMBB.
  sinkMBB->splice(sinkMBB->begin(), BB,
                  std::next(MachineBasicBlock::iterator(MI)), BB->end());
  sinkMBB->transferSuccessorsAndUpdatePHIs(BB);

  // Next, add the true and fallthrough blocks as its successors.
  BB->addSuccessor(copy0MBB);
  BB->addSuccessor(sinkMBB);

  if (isFPCmp) {
    // bc1[tf] cc, sinkMBB
    BuildMI(BB, DL, TII->get(Opc))
        .addReg(MI.getOperand(1).getReg())
        .addMBB(sinkMBB);
  } else {
    BuildMI(BB, DL, TII->get(Opc))
        .addReg(MI.getOperand(1).getReg())
        .addReg(LoongArch::ZERO)
        .addMBB(sinkMBB);
  }

  //  copy0MBB:
  //   %FalseValue = ...
  //   # fallthrough to sinkMBB
  BB = copy0MBB;

  // Update machine-CFG edges
  BB->addSuccessor(sinkMBB);

  //  sinkMBB:
  //   %Result = phi [ %TrueValue, thisMBB ], [ %FalseValue, copy0MBB ]
  //  ...
  BB = sinkMBB;

  BuildMI(*BB, BB->begin(), DL, TII->get(LoongArch::PHI), MI.getOperand(0).getReg())
      .addReg(MI.getOperand(2).getReg())
      .addMBB(thisMBB)
      .addReg(MI.getOperand(3).getReg())
      .addMBB(copy0MBB);

  MI.eraseFromParent(); // The pseudo instruction is gone now.

  return BB;
}

MachineBasicBlock *LoongArchTargetLowering::emitLSXCBranchPseudo(
    MachineInstr &MI, MachineBasicBlock *BB, unsigned BranchOp) const {

  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  const TargetRegisterClass *RC = &LoongArch::GPR32RegClass;
  DebugLoc DL = MI.getDebugLoc();
  const BasicBlock *LLVM_BB = BB->getBasicBlock();
  MachineFunction::iterator It = std::next(MachineFunction::iterator(BB));
  MachineFunction *F = BB->getParent();
  MachineBasicBlock *FBB = F->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *TBB = F->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *Sink = F->CreateMachineBasicBlock(LLVM_BB);
  F->insert(It, FBB);
  F->insert(It, TBB);
  F->insert(It, Sink);

  // Transfer the remainder of BB and its successor edges to Sink.
  Sink->splice(Sink->begin(), BB, std::next(MachineBasicBlock::iterator(MI)),
               BB->end());
  Sink->transferSuccessorsAndUpdatePHIs(BB);

  // Add successors.
  BB->addSuccessor(FBB);
  BB->addSuccessor(TBB);
  FBB->addSuccessor(Sink);
  TBB->addSuccessor(Sink);
  // Insert the real bnz.b instruction to $BB.
  BuildMI(BB, DL, TII->get(BranchOp))
      .addReg(LoongArch::FCC0)
      .addReg(MI.getOperand(1).getReg());

  BuildMI(BB, DL, TII->get(LoongArch::BCNEZ))
      .addReg(LoongArch::FCC0)
      .addMBB(TBB);

  // Fill $FBB.
  unsigned RD1 = RegInfo.createVirtualRegister(RC);
  BuildMI(*FBB, FBB->end(), DL, TII->get(LoongArch::ADDI_W), RD1)
      .addReg(LoongArch::ZERO)
      .addImm(0);
  BuildMI(*FBB, FBB->end(), DL, TII->get(LoongArch::B32)).addMBB(Sink);

  // Fill $TBB.
  unsigned RD2 = RegInfo.createVirtualRegister(RC);
  BuildMI(*TBB, TBB->end(), DL, TII->get(LoongArch::ADDI_W), RD2)
      .addReg(LoongArch::ZERO)
      .addImm(1);

  // Insert phi function to $Sink.
  BuildMI(*Sink, Sink->begin(), DL, TII->get(LoongArch::PHI),
          MI.getOperand(0).getReg())
      .addReg(RD1)
      .addMBB(FBB)
      .addReg(RD2)
      .addMBB(TBB);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return Sink;
}

// Emit the COPY_FW pseudo instruction.
//
// copy_fw_pseudo $fd, $vk, n
// =>
// vreplvei.w $rt, $vk, $n
// copy     $rt, $fd
//
// When n is zero, the equivalent operation can be performed with (potentially)
// zero instructions due to register overlaps.
MachineBasicBlock *
LoongArchTargetLowering::emitCOPY_FW(MachineInstr &MI,
                                     MachineBasicBlock *BB) const {
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Fd = MI.getOperand(0).getReg();
  unsigned Vk = MI.getOperand(1).getReg();
  unsigned Lane = MI.getOperand(2).getImm();

  if (Lane == 0) {
    unsigned Vj = Vk;
    BuildMI(*BB, MI, DL, TII->get(LoongArch::COPY), Fd)
        .addReg(Vj, 0, LoongArch::sub_lo);
  } else {
    unsigned Vj = RegInfo.createVirtualRegister(&LoongArch::LSX128WRegClass);
    BuildMI(*BB, MI, DL, TII->get(LoongArch::VREPLVEI_W), Vj)
        .addReg(Vk)
        .addImm(Lane);
    BuildMI(*BB, MI, DL, TII->get(LoongArch::COPY), Fd)
        .addReg(Vj, 0, LoongArch::sub_lo);
  }

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

// Emit the COPY_FD pseudo instruction.
//
// copy_fd_pseudo $fd, $vj, n
// =>
// vreplvei.d $vd, $vj, $n
// copy $fd, $vd:sub_64
//
// When n is zero, the equivalent operation can be performed with (potentially)
// zero instructions due to register overlaps.
MachineBasicBlock *
LoongArchTargetLowering::emitCOPY_FD(MachineInstr &MI,
                                     MachineBasicBlock *BB) const {
  assert(Subtarget.isFP64bit());

  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  unsigned Fd = MI.getOperand(0).getReg();
  unsigned Vk = MI.getOperand(1).getReg();
  unsigned Lane = MI.getOperand(2).getImm();
  DebugLoc DL = MI.getDebugLoc();

  if (Lane == 0)
    BuildMI(*BB, MI, DL, TII->get(LoongArch::COPY), Fd)
        .addReg(Vk, 0, LoongArch::sub_64);
  else {
    unsigned Vj = RegInfo.createVirtualRegister(&LoongArch::LSX128DRegClass);
    assert(Lane == 1);

    BuildMI(*BB, MI, DL, TII->get(LoongArch::VREPLVEI_D), Vj)
        .addReg(Vk)
        .addImm(Lane);
    BuildMI(*BB, MI, DL, TII->get(LoongArch::COPY), Fd)
        .addReg(Vj, 0, LoongArch::sub_64);
  }

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

MachineBasicBlock *
LoongArchTargetLowering::emitXCOPY_FW(MachineInstr &MI,
                                      MachineBasicBlock *BB) const {
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Fd = MI.getOperand(0).getReg();
  unsigned Xk = MI.getOperand(1).getReg();
  unsigned Lane = MI.getOperand(2).getImm();
  unsigned Rj = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);
  unsigned Xj = Xk;

  if (Lane == 0) {
    BuildMI(*BB, MI, DL, TII->get(LoongArch::COPY), Fd)
        .addReg(Xj, 0, LoongArch::sub_lo);
  } else {
    BuildMI(*BB, MI, DL, TII->get(LoongArch::XVPICKVE2GR_WU), Rj)
        .addReg(Xk)
        .addImm(Lane);
    BuildMI(*BB, MI, DL, TII->get(LoongArch::COPY), Fd).addReg(Rj);
  }

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

MachineBasicBlock *
LoongArchTargetLowering::emitXCOPY_FD(MachineInstr &MI,
                                      MachineBasicBlock *BB) const {
  assert(Subtarget.isFP64bit());

  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  unsigned Fd = MI.getOperand(0).getReg();
  unsigned Xk = MI.getOperand(1).getReg();
  unsigned Lane = MI.getOperand(2).getImm();
  DebugLoc DL = MI.getDebugLoc();

  unsigned Rj = RegInfo.createVirtualRegister(&LoongArch::GPR64RegClass);
  if (Lane == 0) {
    BuildMI(*BB, MI, DL, TII->get(LoongArch::COPY), Fd)
        .addReg(Xk, 0, LoongArch::sub_64);
  } else {
    BuildMI(*BB, MI, DL, TII->get(LoongArch::XVPICKVE2GR_DU), Rj)
        .addReg(Xk)
        .addImm(Lane);
    BuildMI(*BB, MI, DL, TII->get(LoongArch::COPY), Fd).addReg(Rj);
  }

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

MachineBasicBlock *LoongArchTargetLowering::emitCONCAT_VECTORS(
    MachineInstr &MI, MachineBasicBlock *BB, unsigned Bytes) const {

  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Xd = MI.getOperand(0).getReg();
  unsigned SubReg1 = MI.getOperand(1).getReg();
  unsigned SubReg2 = MI.getOperand(2).getReg();
  const TargetRegisterClass *RC = nullptr;

  switch (Bytes) {
  default:
    llvm_unreachable("Unexpected size");
  case 1:
    RC = &LoongArch::LASX256BRegClass;
    break;
  case 2:
    RC = &LoongArch::LASX256HRegClass;
    break;
  case 4:
    RC = &LoongArch::LASX256WRegClass;
    break;
  case 8:
    RC = &LoongArch::LASX256DRegClass;
    break;
  }

  unsigned X0 = RegInfo.createVirtualRegister(RC);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::SUBREG_TO_REG), X0)
      .addImm(0)
      .addReg(SubReg1)
      .addImm(LoongArch::sub_128);
  unsigned X1 = RegInfo.createVirtualRegister(RC);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::SUBREG_TO_REG), X1)
      .addImm(0)
      .addReg(SubReg2)
      .addImm(LoongArch::sub_128);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::XVPERMI_Q), Xd)
      .addReg(X0)
      .addReg(X1)
      .addImm(2);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

// xcopy_fw_gpr_pseudo $fd, $xs, $rk
// =>
// bb: addi.d $rt1, zero, 4
//    bge $lane, $rt1 hbb
// lbb:xvreplve.w $xt1, $xs, $lane
//    copy $rf0, $xt1
//    b sink
// hbb: addi.d $rt2, $lane, -4
//     xvpermi.q $xt2 $xs, 1
//     xvreplve.w $xt3, $xt2, $rt2
//     copy $rf1, $xt3
// sink:phi
MachineBasicBlock *
LoongArchTargetLowering::emitXCOPY_FW_GPR(MachineInstr &MI,
                                          MachineBasicBlock *BB) const {
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Xs = MI.getOperand(1).getReg();
  unsigned Lane = MI.getOperand(2).getReg();

  const TargetRegisterClass *RC = &LoongArch::GPR64RegClass;
  const BasicBlock *LLVM_BB = BB->getBasicBlock();
  MachineFunction::iterator It = std::next(MachineFunction::iterator(BB));
  MachineFunction *F = BB->getParent();
  MachineBasicBlock *HBB = F->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *LBB = F->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *Sink = F->CreateMachineBasicBlock(LLVM_BB);
  F->insert(It, LBB);
  F->insert(It, HBB);
  F->insert(It, Sink);

  Sink->splice(Sink->begin(), BB, std::next(MachineBasicBlock::iterator(MI)),
               BB->end());
  Sink->transferSuccessorsAndUpdatePHIs(BB);

  BB->addSuccessor(LBB);
  BB->addSuccessor(HBB);
  HBB->addSuccessor(Sink);
  LBB->addSuccessor(Sink);

  unsigned Rt1 = RegInfo.createVirtualRegister(RC);
  BuildMI(BB, DL, TII->get(LoongArch::ADDI_D), Rt1)
      .addReg(LoongArch::ZERO_64)
      .addImm(4);
  BuildMI(BB, DL, TII->get(LoongArch::BGE))
      .addReg(Lane)
      .addReg(Rt1)
      .addMBB(HBB);

  unsigned Xt1 = RegInfo.createVirtualRegister(&LoongArch::LASX256WRegClass);
  unsigned Rf0 = RegInfo.createVirtualRegister(&LoongArch::FGR32RegClass);
  BuildMI(*LBB, LBB->end(), DL, TII->get(LoongArch::XVREPLVE_W_N), Xt1)
      .addReg(Xs)
      .addReg(Lane);
  BuildMI(*LBB, LBB->end(), DL, TII->get(LoongArch::COPY), Rf0)
      .addReg(Xt1, 0, LoongArch::sub_lo);
  BuildMI(*LBB, LBB->end(), DL, TII->get(LoongArch::B)).addMBB(Sink);

  unsigned Xt2 = RegInfo.createVirtualRegister(&LoongArch::LASX256WRegClass);
  unsigned Xt3 = RegInfo.createVirtualRegister(&LoongArch::LASX256WRegClass);
  unsigned Rt2 = RegInfo.createVirtualRegister(RC);
  unsigned Rf1 = RegInfo.createVirtualRegister(&LoongArch::FGR32RegClass);
  BuildMI(*HBB, HBB->end(), DL, TII->get(LoongArch::ADDI_D), Rt2)
      .addReg(Lane)
      .addImm(-4);
  BuildMI(*HBB, HBB->end(), DL, TII->get(LoongArch::XVPERMI_Q), Xt2)
      .addReg(Xs)
      .addReg(Xs)
      .addImm(1);
  BuildMI(*HBB, HBB->end(), DL, TII->get(LoongArch::XVREPLVE_W_N), Xt3)
      .addReg(Xt2)
      .addReg(Rt2);
  BuildMI(*HBB, HBB->end(), DL, TII->get(LoongArch::COPY), Rf1)
      .addReg(Xt3, 0, LoongArch::sub_lo);

  BuildMI(*Sink, Sink->begin(), DL, TII->get(LoongArch::PHI),
          MI.getOperand(0).getReg())
      .addReg(Rf0)
      .addMBB(LBB)
      .addReg(Rf1)
      .addMBB(HBB);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return Sink;
}

MachineBasicBlock *
LoongArchTargetLowering::emitXINSERT_BH(MachineInstr &MI, MachineBasicBlock *BB,
                                        unsigned Size) const {
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Xd = MI.getOperand(0).getReg();
  unsigned Xd_in = MI.getOperand(1).getReg();
  unsigned Lane = MI.getOperand(2).getImm();
  unsigned Fs = MI.getOperand(3).getReg();
  const TargetRegisterClass *VecRC = nullptr;
  const TargetRegisterClass *SubVecRC = nullptr;
  unsigned HalfSize = 0;
  unsigned InsertOp = 0;

  if (Size == 1) {
    VecRC = &LoongArch::LASX256BRegClass;
    SubVecRC = &LoongArch::LSX128BRegClass;
    HalfSize = 16;
    InsertOp = LoongArch::VINSGR2VR_B;
  } else if (Size == 2) {
    VecRC = &LoongArch::LASX256HRegClass;
    SubVecRC = &LoongArch::LSX128HRegClass;
    HalfSize = 8;
    InsertOp = LoongArch::VINSGR2VR_H;
  } else {
    llvm_unreachable("Unexpected type");
  }

  unsigned Xk = Xd_in;
  unsigned Imm = Lane;
  if (Lane >= HalfSize) {
    Xk = RegInfo.createVirtualRegister(VecRC);
    BuildMI(*BB, MI, DL, TII->get(LoongArch::XVPERMI_Q), Xk)
        .addReg(Xd_in)
        .addReg(Xd_in)
        .addImm(1);
    Imm = Lane - HalfSize;
  }

  unsigned Xk128 = RegInfo.createVirtualRegister(SubVecRC);
  unsigned Xd128 = RegInfo.createVirtualRegister(SubVecRC);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::COPY), Xk128)
      .addReg(Xk, 0, LoongArch::sub_128);
  BuildMI(*BB, MI, DL, TII->get(InsertOp), Xd128)
      .addReg(Xk128)
      .addReg(Fs)
      .addImm(Imm);

  unsigned Xd256 = Xd;
  if (Lane >= HalfSize) {
    Xd256 = RegInfo.createVirtualRegister(VecRC);
  }

  BuildMI(*BB, MI, DL, TII->get(LoongArch::SUBREG_TO_REG), Xd256)
      .addImm(0)
      .addReg(Xd128)
      .addImm(LoongArch::sub_128);

  if (Lane >= HalfSize) {
    BuildMI(*BB, MI, DL, TII->get(LoongArch::XVPERMI_Q), Xd)
        .addReg(Xd_in)
        .addReg(Xd256)
        .addImm(2);
  }

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

MachineBasicBlock *
LoongArchTargetLowering::emitXINSERT_FW(MachineInstr &MI,
                                        MachineBasicBlock *BB) const {
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Xd = MI.getOperand(0).getReg();
  unsigned Xd_in = MI.getOperand(1).getReg();
  unsigned Lane = MI.getOperand(2).getImm();
  unsigned Fs = MI.getOperand(3).getReg();
  unsigned Xj = RegInfo.createVirtualRegister(&LoongArch::LASX256WRegClass);
  unsigned Rj = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);

  BuildMI(*BB, MI, DL, TII->get(LoongArch::SUBREG_TO_REG), Xj)
      .addImm(0)
      .addReg(Fs)
      .addImm(LoongArch::sub_lo);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::XVPICKVE2GR_WU), Rj)
      .addReg(Xj)
      .addImm(0);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::XVINSGR2VR_W), Xd)
      .addReg(Xd_in)
      .addReg(Rj)
      .addImm(Lane);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

// Emit the INSERT_FW pseudo instruction.
//
// insert_fw_pseudo $vd, $vd_in, $n, $fs
// =>
// subreg_to_reg $vj:sub_lo, $fs
// vpickve2gr.w rj, vj, 0
// vinsgr2vr.w, vd, rj, lane
MachineBasicBlock *
LoongArchTargetLowering::emitINSERT_FW(MachineInstr &MI,
                                       MachineBasicBlock *BB) const {
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Vd = MI.getOperand(0).getReg();
  unsigned Vd_in = MI.getOperand(1).getReg();
  unsigned Lane = MI.getOperand(2).getImm();
  unsigned Fs = MI.getOperand(3).getReg();
  unsigned Rj = RegInfo.createVirtualRegister(&LoongArch::GPR32RegClass);
  unsigned Vj = RegInfo.createVirtualRegister(&LoongArch::LSX128WRegClass);

  BuildMI(*BB, MI, DL, TII->get(LoongArch::SUBREG_TO_REG), Vj)
      .addImm(0)
      .addReg(Fs)
      .addImm(LoongArch::sub_lo);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::VPICKVE2GR_W), Rj)
      .addReg(Vj)
      .addImm(0);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::VINSGR2VR_W), Vd)
      .addReg(Vd_in)
      .addReg(Rj)
      .addImm(Lane);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

// Emit the INSERT_FD pseudo instruction.
// insert_fd_pseudo $vd, $fs, n
// =>
// subreg_to_reg $vk:sub_64, $fs
// vpickve2gr.d rj, vk, 0
// vinsgr2vr.d vd, rj, lane
MachineBasicBlock *
LoongArchTargetLowering::emitINSERT_FD(MachineInstr &MI,
                                       MachineBasicBlock *BB) const {
  assert(Subtarget.isFP64bit());

  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Vd = MI.getOperand(0).getReg();
  unsigned Vd_in = MI.getOperand(1).getReg();
  unsigned Lane = MI.getOperand(2).getImm();
  unsigned Fs = MI.getOperand(3).getReg();
  unsigned Vj = RegInfo.createVirtualRegister(&LoongArch::LSX128DRegClass);
  unsigned Rj = RegInfo.createVirtualRegister(&LoongArch::GPR64RegClass);

  BuildMI(*BB, MI, DL, TII->get(LoongArch::SUBREG_TO_REG), Vj)
      .addImm(0)
      .addReg(Fs)
      .addImm(LoongArch::sub_64);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::VPICKVE2GR_D), Rj)
      .addReg(Vj)
      .addImm(0);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::VINSGR2VR_D), Vd)
      .addReg(Vd_in)
      .addReg(Rj)
      .addImm(Lane);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

MachineBasicBlock *
LoongArchTargetLowering::emitXINSERT_FD(MachineInstr &MI,
                                        MachineBasicBlock *BB) const {
  assert(Subtarget.isFP64bit());

  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Xd = MI.getOperand(0).getReg();
  unsigned Xd_in = MI.getOperand(1).getReg();
  unsigned Lane = MI.getOperand(2).getImm();
  unsigned Fs = MI.getOperand(3).getReg();
  unsigned Xj = RegInfo.createVirtualRegister(&LoongArch::LASX256DRegClass);

  BuildMI(*BB, MI, DL, TII->get(LoongArch::SUBREG_TO_REG), Xj)
      .addImm(0)
      .addReg(Fs)
      .addImm(LoongArch::sub_64);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::XVINSVE0_D), Xd)
      .addReg(Xd_in)
      .addReg(Xj)
      .addImm(Lane);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

// Emit the FILL_FW pseudo instruction.
//
// fill_fw_pseudo $vd, $fs
// =>
// implicit_def $vt1
// insert_subreg $vt2:subreg_lo, $vt1, $fs
// vreplvei.w vd, vt2, 0
MachineBasicBlock *
LoongArchTargetLowering::emitFILL_FW(MachineInstr &MI,
                                     MachineBasicBlock *BB) const {
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Vd = MI.getOperand(0).getReg();
  unsigned Fs = MI.getOperand(1).getReg();
  unsigned Vj1 = RegInfo.createVirtualRegister(&LoongArch::LSX128WRegClass);
  unsigned Vj2 = RegInfo.createVirtualRegister(&LoongArch::LSX128WRegClass);

  BuildMI(*BB, MI, DL, TII->get(LoongArch::IMPLICIT_DEF), Vj1);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::INSERT_SUBREG), Vj2)
      .addReg(Vj1)
      .addReg(Fs)
      .addImm(LoongArch::sub_lo);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::VREPLVEI_W), Vd)
      .addReg(Vj2)
      .addImm(0);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

// Emit the FILL_FD pseudo instruction.
//
// fill_fd_pseudo $vd, $fs
// =>
// implicit_def $vt1
// insert_subreg $vt2:subreg_64, $vt1, $fs
// vreplvei.d vd, vt2, 0
MachineBasicBlock *
LoongArchTargetLowering::emitFILL_FD(MachineInstr &MI,
                                     MachineBasicBlock *BB) const {
  assert(Subtarget.isFP64bit());

  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Vd = MI.getOperand(0).getReg();
  unsigned Fs = MI.getOperand(1).getReg();
  unsigned Vj1 = RegInfo.createVirtualRegister(&LoongArch::LSX128DRegClass);
  unsigned Vj2 = RegInfo.createVirtualRegister(&LoongArch::LSX128DRegClass);

  BuildMI(*BB, MI, DL, TII->get(LoongArch::IMPLICIT_DEF), Vj1);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::INSERT_SUBREG), Vj2)
      .addReg(Vj1)
      .addReg(Fs)
      .addImm(LoongArch::sub_64);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::VREPLVEI_D), Vd)
      .addReg(Vj2)
      .addImm(0);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

// Emit the XFILL_FW pseudo instruction.
//
// xfill_fw_pseudo $xd, $fs
// =>
// implicit_def $xt1
// insert_subreg $xt2:subreg_lo, $xt1, $fs
// xvreplve0.w xd, xt2, 0
MachineBasicBlock *
LoongArchTargetLowering::emitXFILL_FW(MachineInstr &MI,
                                      MachineBasicBlock *BB) const {
  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Xd = MI.getOperand(0).getReg();
  unsigned Fs = MI.getOperand(1).getReg();
  unsigned Xj1 = RegInfo.createVirtualRegister(&LoongArch::LASX256WRegClass);
  unsigned Xj2 = RegInfo.createVirtualRegister(&LoongArch::LASX256WRegClass);

  BuildMI(*BB, MI, DL, TII->get(LoongArch::IMPLICIT_DEF), Xj1);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::INSERT_SUBREG), Xj2)
      .addReg(Xj1)
      .addReg(Fs)
      .addImm(LoongArch::sub_lo);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::XVREPLVE0_W), Xd).addReg(Xj2);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

// Emit the XFILL_FD pseudo instruction.
//
// xfill_fd_pseudo $xd, $fs
// =>
// implicit_def $xt1
// insert_subreg $xt2:subreg_64, $xt1, $fs
// xvreplve0.d xd, xt2, 0
MachineBasicBlock *
LoongArchTargetLowering::emitXFILL_FD(MachineInstr &MI,
                                      MachineBasicBlock *BB) const {
  assert(Subtarget.isFP64bit());

  const TargetInstrInfo *TII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = BB->getParent()->getRegInfo();
  DebugLoc DL = MI.getDebugLoc();
  unsigned Xd = MI.getOperand(0).getReg();
  unsigned Fs = MI.getOperand(1).getReg();
  unsigned Xj1 = RegInfo.createVirtualRegister(&LoongArch::LASX256DRegClass);
  unsigned Xj2 = RegInfo.createVirtualRegister(&LoongArch::LASX256DRegClass);

  BuildMI(*BB, MI, DL, TII->get(LoongArch::IMPLICIT_DEF), Xj1);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::INSERT_SUBREG), Xj2)
      .addReg(Xj1)
      .addReg(Fs)
      .addImm(LoongArch::sub_64);
  BuildMI(*BB, MI, DL, TII->get(LoongArch::XVREPLVE0_D), Xd).addReg(Xj2);

  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return BB;
}

bool LoongArchTargetLowering::isLegalAddImmediate(int64_t Imm) const {
  bool IsLegal = false;
  if (Subtarget.hasLSX() || Subtarget.hasLASX()) {
    return isUInt<5>(Imm);
  }
  return IsLegal;
}

bool LoongArchTargetLowering::isFMAFasterThanFMulAndFAdd(
    const MachineFunction &MF, EVT VT) const {

  VT = VT.getScalarType();

  if (!VT.isSimple())
    return false;

  switch (VT.getSimpleVT().SimpleTy) {
  case MVT::f32:
  case MVT::f64:
    return true;
  default:
    break;
  }

  return false;
}

bool LoongArchTargetLowering::isExtractSubvectorCheap(EVT ResVT, EVT SrcVT,
                                                      unsigned Index) const {
  if (!isOperationLegalOrCustom(ISD::EXTRACT_SUBVECTOR, ResVT))
    return false;

  return (
      (ResVT != MVT::v16i8) && (ResVT != MVT::v8i16) &&
      (Index == 0 || (Index == ResVT.getVectorNumElements() &&
                      (ResVT.getSizeInBits() == SrcVT.getSizeInBits() / 2))));
}

Register
LoongArchTargetLowering::getRegisterByName(const char *RegName, LLT VT,
                                           const MachineFunction &MF) const {
  // Named registers is expected to be fairly rare. For now, just support $r2
  // and $r21 since the linux kernel uses them.
  if (Subtarget.is64Bit()) {
    Register Reg = StringSwitch<unsigned>(RegName)
                       .Case("$r2", LoongArch::TP_64)
                       .Case("$r21", LoongArch::T9_64)
                       .Default(Register());
    if (Reg)
      return Reg;
  } else {
    Register Reg = StringSwitch<unsigned>(RegName)
                       .Case("$r2", LoongArch::TP)
                       .Case("$r21", LoongArch::T9)
                       .Default(Register());
    if (Reg)
      return Reg;
  }
  report_fatal_error("Invalid register name global variable");
}

bool LoongArchTargetLowering::hasAndNot(SDValue Y) const {
  return Y.getValueType().isScalarInteger() && !isa<ConstantSDNode>(Y);
}
