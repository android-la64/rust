//===---- LoongArchABIInfo.h - Information about LoongArch ABI's --------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHABIINFO_H
#define LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHABIINFO_H

#include "llvm/ADT/Triple.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/MC/MCRegisterInfo.h"

namespace llvm {

template <typename T> class ArrayRef;
class MCTargetOptions;
class StringRef;
class TargetRegisterClass;

class LoongArchABIInfo {
public:
  enum class ABI { Unknown, LP32, LPX32, LP64 };

protected:
  ABI ThisABI;

public:
  LoongArchABIInfo(ABI ThisABI) : ThisABI(ThisABI) {}

  static LoongArchABIInfo Unknown() { return LoongArchABIInfo(ABI::Unknown); }
  static LoongArchABIInfo LP32() { return LoongArchABIInfo(ABI::LP32); }
  static LoongArchABIInfo LPX32() { return LoongArchABIInfo(ABI::LPX32); }
  static LoongArchABIInfo LP64() { return LoongArchABIInfo(ABI::LP64); }
  static LoongArchABIInfo computeTargetABI(const Triple &TT, StringRef CPU,
                                      const MCTargetOptions &Options);

  bool IsKnown() const { return ThisABI != ABI::Unknown; }
  bool IsLP32() const { return ThisABI == ABI::LP32; }
  bool IsLPX32() const { return ThisABI == ABI::LPX32; }
  bool IsLP64() const { return ThisABI == ABI::LP64; }
  ABI GetEnumValue() const { return ThisABI; }

  /// The registers to use for byval arguments.
  ArrayRef<MCPhysReg> GetByValArgRegs() const;

  /// The registers to use for the variable argument list.
  ArrayRef<MCPhysReg> GetVarArgRegs() const;

  /// Ordering of ABI's
  /// LoongArchGenSubtargetInfo.inc will use this to resolve conflicts when given
  /// multiple ABI options.
  bool operator<(const LoongArchABIInfo Other) const {
    return ThisABI < Other.GetEnumValue();
  }

  unsigned GetStackPtr() const;
  unsigned GetFramePtr() const;
  unsigned GetBasePtr() const;
  unsigned GetNullPtr() const;
  unsigned GetZeroReg() const;
  unsigned GetPtrAddOp() const;
  unsigned GetPtrAddiOp() const;
  unsigned GetPtrSubOp() const;
  unsigned GetPtrAndOp() const;
  unsigned GetGPRMoveOp() const;
  inline bool ArePtrs64bit() const { return IsLP64(); }
  inline bool AreGprs64bit() const { return IsLPX32() || IsLP64(); }

  unsigned GetEhDataReg(unsigned I) const;
};
}

#endif
