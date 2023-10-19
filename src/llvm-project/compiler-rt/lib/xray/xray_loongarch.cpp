//===-- xray_loongarch.cpp -----------------------------------------*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of XRay, a dynamic runtime instrumentation system.
//
// Implementation of loongarch-specific routines.
//
//===----------------------------------------------------------------------===//
#include "sanitizer_common/sanitizer_common.h"
#include "xray_defs.h"
#include "xray_interface_internal.h"
#include <atomic>

namespace __xray {

// The machine codes for some instructions used in runtime patching.
enum PatchOpcodes : uint32_t {
  PO_ADDID = 0x02c00000,  // addi.d rd, rj, imm
  PO_SD = 0x29c00000,     // st.d rd, base, offset
  PO_LU12IW = 0x14000000, // lu12i.w rd, imm
  PO_ORI = 0x03800000,    // ori rd, rs, imm
  PO_LU32ID = 0x16000000, // lu32i.d rd, imm
  PO_LU52ID = 0x03000000, // lu52i.d rd, rj, imm
  PO_JIRL = 0x4c000000,   // jirl rd, rj, 0
  PO_LD = 0x28c00000,     // ld.d rd, base, offset
  PO_B48 = 0x50003000,    // b #48
};

enum RegNum : uint32_t {
  RN_T0 = 0xC,
  RN_T1 = 0xD,
  RN_RA = 0x1,
  RN_SP = 0x3,
};

// addi.d lu521.d ori ld.d st.d
inline static uint32_t
encodeInstruction_i12(uint32_t Opcode, uint32_t Rd, uint32_t Rj,
                      uint32_t Imm) XRAY_NEVER_INSTRUMENT {
  return (Opcode | Rj << 5 | Rd | Imm << 10);
}

// lu12i.w lu32i.d
inline static uint32_t
encodeInstruction_si20(uint32_t Opcode, uint32_t Rd,
                       uint32_t Imm) XRAY_NEVER_INSTRUMENT {
  return (Opcode | Rd | Imm << 5);
}

// jirl
inline static uint32_t
encodeInstruction_si16(uint32_t Opcode, uint32_t Rd, uint32_t Rj,
                       uint32_t Imm) XRAY_NEVER_INSTRUMENT {
  return (Opcode | Rj << 5 | Rd | Imm << 10);
}

inline static bool patchSled(const bool Enable, const uint32_t FuncId,
                             const XRaySledEntry &Sled,
                             void (*TracingHook)()) XRAY_NEVER_INSTRUMENT {
  // When |Enable| == true,
  // We replace the following compile-time stub (sled):
  //
  // xray_sled_n:
  //	B .tmpN
  //	11 NOPs (44 bytes)
  //	.tmpN
  //
  // With the following runtime patch:
  // xray_sled_n (64-bit):
  // addi.d sp,sp, -16                     ;create stack frame
  // st.d ra, sp, 8                        ;save return address
  // lu12i.w t0,%%abs_hi20(__xray_FunctionEntry/Exit)
  // ori t0,t0,%%abs_lo12(__xray_FunctionEntry/Exit)
  // lu32i.d t0,%%abs64_lo20(__xray_FunctionEntry/Exit)
  // lu52i.d t0,t0,%%abs64_hi12(__xray_FunctionEntry/Exit)
  // lu12i.w t1,%%abs_hi20(function_id)
  // ori t1,t1,%%abs_lo12(function_id)      ;pass function id
  // jirl ra, t0, 0                         ;call Tracing hook
  // ld.d ra, sp, 8                         ;restore return address
  // addi.d sp, sp, 16                      ;delete stack frame
  //
  // Replacement of the first 4-byte instruction should be the last and atomic
  // operation, so that the user code which reaches the sled concurrently
  // either jumps over the whole sled, or executes the whole sled when the
  // latter is ready.
  //
  // When |Enable|==false, we set back the first instruction in the sled to be
  //   B #48

  uint32_t *Address = reinterpret_cast<uint32_t *>(Sled.address());
  if (Enable) {
    uint32_t LoTracingHookAddr = reinterpret_cast<int64_t>(TracingHook) & 0xfff;
    uint32_t HiTracingHookAddr =
        (reinterpret_cast<int64_t>(TracingHook) >> 12) & 0xfffff;
    uint32_t HigherTracingHookAddr =
        (reinterpret_cast<int64_t>(TracingHook) >> 32) & 0xfffff;
    uint32_t HighestTracingHookAddr =
        (reinterpret_cast<int64_t>(TracingHook) >> 52) & 0xfff;
    uint32_t LoFunctionID = FuncId & 0xfff;
    uint32_t HiFunctionID = (FuncId >> 12) & 0xfffff;
    Address[1] = encodeInstruction_i12(PatchOpcodes::PO_SD, RegNum::RN_RA,
                                       RegNum::RN_SP, 0x8);
    Address[2] = encodeInstruction_si20(PatchOpcodes::PO_LU12IW, RegNum::RN_T0,
                                        HiTracingHookAddr);
    Address[3] = encodeInstruction_i12(PatchOpcodes::PO_ORI, RegNum::RN_T0,
                                       RegNum::RN_T0, LoTracingHookAddr);
    Address[4] = encodeInstruction_si20(PatchOpcodes::PO_LU32ID, RegNum::RN_T0,
                                        HigherTracingHookAddr);
    Address[5] = encodeInstruction_i12(PatchOpcodes::PO_LU52ID, RegNum::RN_T0,
                                       RegNum::RN_T0, HighestTracingHookAddr);
    Address[6] = encodeInstruction_si20(PatchOpcodes::PO_LU12IW, RegNum::RN_T1,
                                        HiFunctionID);
    Address[7] = encodeInstruction_i12(PatchOpcodes::PO_ORI, RegNum::RN_T1,
                                       RegNum::RN_T1, LoFunctionID);
    Address[8] = encodeInstruction_si16(PatchOpcodes::PO_JIRL, RegNum::RN_RA,
                                        RegNum::RN_T0, 0);
    Address[9] = encodeInstruction_i12(PatchOpcodes::PO_LD, RegNum::RN_RA,
                                        RegNum::RN_SP, 0x8);
    Address[10] = encodeInstruction_i12(PatchOpcodes::PO_ADDID, RegNum::RN_SP,
                                        RegNum::RN_SP, 0x10);
    uint32_t CreateStackSpace = encodeInstruction_i12(
        PatchOpcodes::PO_ADDID, RegNum::RN_SP, RegNum::RN_SP, 0xff0);
    std::atomic_store_explicit(
        reinterpret_cast<std::atomic<uint32_t> *>(Address), CreateStackSpace,
        std::memory_order_release);
  } else {
    std::atomic_store_explicit(
        reinterpret_cast<std::atomic<uint32_t> *>(Address),
        uint32_t(PatchOpcodes::PO_B48), std::memory_order_release);
  }
  return true;
}

bool patchFunctionEntry(const bool Enable, const uint32_t FuncId,
                        const XRaySledEntry &Sled,
                        void (*Trampoline)()) XRAY_NEVER_INSTRUMENT {
  return patchSled(Enable, FuncId, Sled, Trampoline);
}

bool patchFunctionExit(const bool Enable, const uint32_t FuncId,
                       const XRaySledEntry &Sled) XRAY_NEVER_INSTRUMENT {
  return patchSled(Enable, FuncId, Sled, __xray_FunctionExit);
}

bool patchFunctionTailExit(const bool Enable, const uint32_t FuncId,
                           const XRaySledEntry &Sled) XRAY_NEVER_INSTRUMENT {
  // FIXME: In the future we'd need to distinguish between non-tail exits and
  // tail exits for better information preservation.
  return patchSled(Enable, FuncId, Sled, __xray_FunctionExit);
}

bool patchCustomEvent(const bool Enable, const uint32_t FuncId,
                      const XRaySledEntry &Sled) XRAY_NEVER_INSTRUMENT {
  // FIXME: Implement in loongarch?
  return false;
}

bool patchTypedEvent(const bool Enable, const uint32_t FuncId,
                     const XRaySledEntry &Sled) XRAY_NEVER_INSTRUMENT {
  // FIXME: Implement in loongarch?
  return false;
}
} // namespace __xray

extern "C" void __xray_ArgLoggerEntry() XRAY_NEVER_INSTRUMENT {
  // FIXME: this will have to be implemented in the trampoline assembly file
}
