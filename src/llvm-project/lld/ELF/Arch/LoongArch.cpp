//===- LoongArch.cpp
//--------------------------------------------------------===//
//
//                             The LLVM Linker
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "InputFiles.h"
#include "OutputSections.h"
#include "Symbols.h"
#include "SyntheticSections.h"
#include "Target.h"
#include "Thunks.h"
#include "lld/Common/ErrorHandler.h"
#include "llvm/Object/ELF.h"
#include "llvm/Support/Endian.h"

using namespace llvm;
using namespace llvm::object;
using namespace llvm::support::endian;
using namespace llvm::ELF;
using namespace lld;
using namespace lld::elf;

namespace {
#define REL_STACK_MAX_SIZE 16
struct RelStack {
  uint64_t stack[REL_STACK_MAX_SIZE] = {};
  int top = -1;
  void push_back(uint64_t e) {
    if (top < REL_STACK_MAX_SIZE) {
      top++;
      stack[top] = e;
    } else {
      report_fatal_error("stack is overflow, top = " + Twine(top));
    }
  }

  uint64_t pop_back_val() {
    uint64_t e;
    if (top >= 0) {
      e = stack[top];
      top--;
    } else {
      report_fatal_error("stack is empty, top = " + Twine(top));
    }
    return e;
  }
};
// The lld multi-thread is used to speed up link procedure. The lld will
// create a thread for every input section to handle relocation. So we
// must use thread-safe stack for every work thread.
__thread RelStack relStack;

template <class ELFT> class LoongArch final : public TargetInfo {
public:
  LoongArch();
  uint32_t calcEFlags() const override;
  RelExpr getRelExpr(RelType type, const Symbol &s,
                     const uint8_t *loc) const override;
  RelType getDynRel(RelType type) const override;
  void writeGotHeader(uint8_t *buf) const override;
  void writeGotPlt(uint8_t *buf, const Symbol &s) const override;
  void writePltHeader(uint8_t *buf) const override;
  void writePlt(uint8_t *buf, const Symbol &sym,
                uint64_t pltEntryAddr) const override;
  void relocate(uint8_t *loc, const Relocation &rel,
                uint64_t val) const override;
};
} // namespace

template <class ELFT> LoongArch<ELFT>::LoongArch() {
  // .got[0] = _DYNAMIC
  gotHeaderEntriesNum = 1;
  // .got.plt[0] = _dl_runtime_resolve, .got.plt[1] = link_map
  gotPltHeaderEntriesNum = 2;
  defaultMaxPageSize = 65536;
  gotEntrySize = sizeof(typename ELFT::uint);
  pltEntrySize = 16;
  pltHeaderSize = 32;
  copyRel = R_LARCH_COPY;
  pltRel = R_LARCH_JUMP_SLOT;
  relativeRel = R_LARCH_RELATIVE;
  // _GLOBAL_OFFSET_TABLE_ is relative to .got
  gotBaseSymInGotPlt = false;

  if (ELFT::Is64Bits) {
    symbolicRel = R_LARCH_64;
    tlsGotRel = R_LARCH_TLS_TPREL64;
    tlsModuleIndexRel = R_LARCH_TLS_DTPMOD64;
    tlsOffsetRel = R_LARCH_TLS_DTPREL64;
    defaultImageBase = 0x120000000;
  } else {
    symbolicRel = R_LARCH_32;
    tlsGotRel = R_LARCH_TLS_TPREL32;
    tlsModuleIndexRel = R_LARCH_TLS_DTPMOD32;
    tlsOffsetRel = R_LARCH_TLS_DTPREL32;
  }
  gotRel = symbolicRel;
}

template <class ELFT> static TargetInfo *getTargetInfo() {
  static LoongArch<ELFT> target;
  return &target;
}

TargetInfo *elf::getLoongArch32TargetInfo() { return getTargetInfo<ELF32LE>(); }
TargetInfo *elf::getLoongArch64TargetInfo() { return getTargetInfo<ELF64LE>(); }

template <class ELFT>
RelExpr LoongArch<ELFT>::getRelExpr(RelType type, const Symbol &s,
                                    const uint8_t *loc) const {
  switch (type) {
  case R_LARCH_64:
  case R_LARCH_32:
    return R_ABS;
  case R_LARCH_SOP_PUSH_PCREL:
    return R_PC;
  case R_LARCH_SOP_PUSH_TLS_GOT:
    return R_GOT_OFF;
  case R_LARCH_SOP_PUSH_TLS_GD:
    return R_TLSGD_GOT;
  case R_LARCH_SOP_PUSH_TLS_TPREL:
    return R_TPREL;
  case R_LARCH_SOP_PUSH_GPREL:
    return R_LARCH_GOTREL;
  case R_LARCH_SOP_PUSH_PLT_PCREL:
    return R_PLT_PC;
  case R_LARCH_ADD8:
  case R_LARCH_ADD16:
  case R_LARCH_ADD32:
  case R_LARCH_ADD64:
    return R_LARCH_PC;
  default:
    return R_LARCH_ABS;
  }
}

template <class ELFT> static uint32_t getEFlags(InputFile *F) {
  return cast<ObjFile<ELFT>>(F)->getObj().getHeader().e_flags;
}

static Twine getAbiName(uint32_t eflags) {
  switch (eflags) {
  case EF_LARCH_ABI_LP64:
    return Twine("LP64");
  case EF_LARCH_ABI_LP32:
    return Twine("LP32");
  case EF_LARCH_ABI_LPX32:
    return Twine("LPX32");
  default:
    return Twine("Unknown ABI");
  }
}

template <class ELFT> uint32_t LoongArch<ELFT>::calcEFlags() const {
  assert(!objectFiles.empty());

  uint32_t target = getEFlags<ELFT>(objectFiles.front());

  for (InputFile *f : objectFiles) {
    uint32_t eflags = getEFlags<ELFT>(f);
    if (eflags != EF_LARCH_ABI_LP64 && eflags != EF_LARCH_ABI_LP32 &&
        eflags != EF_LARCH_ABI_LPX32)
      error(toString(f) + ": unrecognized e_flags: " + Twine(eflags));
    if (eflags != target)
      error(toString(f) + ": ABI '" + getAbiName(eflags) +
            "' is incompatible with target ABI '" + getAbiName(target) + "'");
  }

  return target;
}

template <class ELFT> RelType LoongArch<ELFT>::getDynRel(RelType type) const {
  if (type == R_LARCH_32 || type == R_LARCH_64)
    return type;
  return R_LARCH_NONE;
}

template <class ELFT> void LoongArch<ELFT>::writeGotHeader(uint8_t *buf) const {
  if (ELFT::Is64Bits)
    write64le(buf, mainPart->dynamic->getVA());
  else
    write32le(buf, mainPart->dynamic->getVA());
}

template <class ELFT>
void LoongArch<ELFT>::writeGotPlt(uint8_t *buf, const Symbol &s) const {
  if (ELFT::Is64Bits)
    write64le(buf, in.plt->getVA());
  else
    write32le(buf, in.plt->getVA());
}

/* Add 0x800 to maintain the sign bit */
static uint32_t hi20(uint32_t val) { return (val + 0x800) >> 12; }
static uint32_t lo12(uint32_t val) { return val & 0xfff; }

template <class ELFT> void LoongArch<ELFT>::writePltHeader(uint8_t *buf) const {
  uint32_t offset = in.gotPlt->getVA() - in.plt->getVA();

  /* pcaddu12i  $t2, %hi(%pcrel(.got.plt))
     sub.[wd]   $t1, $t1, $t3
     ld.[wd]    $t3, $t2, %lo(%pcrel(.got.plt)) # _dl_runtime_resolve
     addi.[wd]  $t1, $t1, -(PLT_HEADER_SIZE + 12) + 4
     addi.[wd]  $t0, $t2, %lo(%pcrel(.got.plt))
     srli.[wd]  $t1, $t1, log2(16 / GOT_ENTRY_SIZE)
     ld.[wd]    $t0, $t0, GOT_ENTRY_SIZE
     jirl       $r0, $t3, 0 */

  if (ELFT::Is64Bits) {
    write32le(buf + 0, 0x1c00000e | hi20(offset) << 5);
    write32le(buf + 4, 0x0011bdad);
    write32le(buf + 8, 0x28c001cf | lo12(offset) << 10);
    write32le(buf + 12, 0x02c001ad | ((-(pltHeaderSize + 12) + 4) & 0xfff)
                                         << 10);
    write32le(buf + 16, 0x02c001cc | lo12(offset) << 10);
    write32le(buf + 20, 0x004501ad | 0x400);
    write32le(buf + 24, 0x28c0018c | gotEntrySize << 10);
    write32le(buf + 28, 0x4c0001e0);
  } else {
    write32le(buf + 0, 0x1c00000e | hi20(offset) << 5);
    write32le(buf + 4, 0x00113dad);
    write32le(buf + 8, 0x288001cf | lo12(offset) << 10);
    write32le(buf + 12, 0x028001ad | ((-(pltHeaderSize + 12)) & 0xfff) << 10);
    write32le(buf + 16, 0x028001cc | lo12(offset) << 10);
    write32le(buf + 20, 0x004481ad | 0x800);
    write32le(buf + 24, 0x2880018c | gotEntrySize << 10);
    write32le(buf + 28, 0x4c0001e0);
  }

  return;
}

template <class ELFT>
void LoongArch<ELFT>::writePlt(uint8_t *buf, const Symbol &sym,
                               uint64_t pltEntryAddr) const {
  uint32_t offset = sym.getGotPltVA() - pltEntryAddr;

  /* pcaddu12i  $t3, %hi(%pcrel(.got.plt entry))
     ld.[wd]    $t3, $t3, %lo(%pcrel(.got.plt entry))
     pcaddu12i  $t1, 0
     jirl       $r0, $t3, 0 */

  write32le(buf, 0x1c00000f | hi20(offset) << 5);
  if (ELFT::Is64Bits)
    write32le(buf + 4, 0x28c001ef | lo12(offset) << 10);
  else
    write32le(buf + 4, 0x288001ef | lo12(offset) << 10);
  write32le(buf + 8, 0x1c00000d);
  write32le(buf + 12, 0x4c0001e0);

  return;
}

// Extract bits v[hi:lo], where range is inclusive, and hi must be < 63.
static uint32_t extractBits(uint64_t v, uint32_t hi, uint32_t lo) {
  return (v & ((1ULL << (hi + 1)) - 1)) >> lo;
}

// Clean bits v[hi:lo] to 0, where range is inclusive, and hi must be
// < 32.
static uint32_t cleanInstrImm(uint32_t v, uint32_t hi, uint32_t lo) {
  return v & ~((((1ULL << (hi + 1)) - 1) >> lo) << lo);
}

template <class ELFT>
void LoongArch<ELFT>::relocate(uint8_t *loc, const Relocation &rel,
                               uint64_t val) const {
  switch (rel.type) {
  case R_LARCH_32:
    write32le(loc, val);
    break;
  case R_LARCH_TLS_DTPREL32:
    write32le(loc, val);
    break;
  case R_LARCH_64:
    write64le(loc, val);
    return;
  case R_LARCH_TLS_DTPREL64:
    write64le(loc, val);
    break;
  case R_LARCH_TLS_DTPMOD32:
    write32le(loc, val);
    break;
  case R_LARCH_TLS_DTPMOD64:
    write64le(loc, val);
    break;
  case R_LARCH_MARK_LA:
  case R_LARCH_MARK_PCREL:
  case R_LARCH_NONE:
    break;
  case R_LARCH_SOP_PUSH_PCREL:
  case R_LARCH_SOP_PUSH_ABSOLUTE:
  case R_LARCH_SOP_PUSH_GPREL:
  case R_LARCH_SOP_PUSH_TLS_TPREL:
  case R_LARCH_SOP_PUSH_TLS_GOT:
  case R_LARCH_SOP_PUSH_TLS_GD:
  case R_LARCH_SOP_PUSH_PLT_PCREL:
    relStack.push_back(val);
    break;
  case R_LARCH_SOP_PUSH_DUP: {
    uint64_t opr1 = relStack.pop_back_val();
    relStack.push_back(opr1);
    relStack.push_back(opr1);
  } break;
  case R_LARCH_SOP_ASSERT: {
    uint64_t opr1 = relStack.pop_back_val();
    assert(opr1 == 0 && "R_LARCH_SOP_ASSERT relocation type assert fail.");
  } break;
  case R_LARCH_SOP_NOT: {
    uint64_t opr1 = relStack.pop_back_val();
    relStack.push_back(!opr1);
  } break;
  case R_LARCH_SOP_SUB: {
    uint64_t opr2 = relStack.pop_back_val();
    uint64_t opr1 = relStack.pop_back_val();
    relStack.push_back(opr1 - opr2);
  } break;
  case R_LARCH_SOP_SL: {
    uint64_t opr2 = relStack.pop_back_val();
    uint64_t opr1 = relStack.pop_back_val();
    relStack.push_back(opr1 << opr2);
  } break;
  case R_LARCH_SOP_SR: {
    uint64_t opr2 = relStack.pop_back_val();
    uint64_t opr1 = relStack.pop_back_val();
    relStack.push_back((int64_t)opr1 >> opr2);
  } break;
  case R_LARCH_SOP_ADD: {
    uint64_t opr2 = relStack.pop_back_val();
    uint64_t opr1 = relStack.pop_back_val();
    relStack.push_back(opr1 + opr2);
  } break;
  case R_LARCH_SOP_AND: {
    uint64_t opr2 = relStack.pop_back_val();
    uint64_t opr1 = relStack.pop_back_val();
    relStack.push_back(opr1 & opr2);
  } break;
  case R_LARCH_SOP_IF_ELSE: {
    uint64_t opr3 = relStack.pop_back_val();
    uint64_t opr2 = relStack.pop_back_val();
    uint64_t opr1 = relStack.pop_back_val();
    relStack.push_back(opr1 ? opr2 : opr3);
  } break;
  case R_LARCH_SOP_POP_32_S_10_5: {
    uint64_t opr1 = relStack.pop_back_val();
    checkInt(loc, static_cast<int64_t>(opr1), 5, rel);
    uint32_t imm10_5 = extractBits(opr1, 4, 0) << 10;
    uint32_t ins = cleanInstrImm(read32le(loc), 14, 10);
    write32le(loc, ins | imm10_5);
  } break;
  case R_LARCH_SOP_POP_32_S_10_12: {
    uint64_t opr1 = relStack.pop_back_val();
    checkInt(loc, static_cast<int64_t>(opr1), 12, rel);
    uint32_t imm10_12 = extractBits(opr1, 11, 0) << 10;
    uint32_t ins = cleanInstrImm(read32le(loc), 21, 10);
    write32le(loc, ins | imm10_12);
  } break;
  case R_LARCH_SOP_POP_32_S_10_16: {
    uint64_t opr1 = relStack.pop_back_val();
    checkInt(loc, static_cast<int64_t>(opr1), 16, rel);
    uint32_t imm10_16 = extractBits(opr1, 15, 0) << 10;
    uint32_t ins = cleanInstrImm(read32le(loc), 25, 10);
    write32le(loc, ins | imm10_16);
  } break;
  case R_LARCH_SOP_POP_32_S_10_16_S2: {
    int64_t opr1 = (int64_t)relStack.pop_back_val();
    checkInt(loc, static_cast<int64_t>(opr1), 18, rel);
    checkAlignment(loc, opr1, 4, rel);
    uint32_t imm10_16 = extractBits(opr1, 17, 2) << 10;
    uint32_t ins = cleanInstrImm(read32le(loc), 25, 10);
    write32le(loc, ins | imm10_16);
  } break;
  case R_LARCH_SOP_POP_32_U_10_12: {
    uint64_t opr1 = relStack.pop_back_val();
    checkUInt(loc, opr1, 12, rel);
    uint32_t imm10_12 = extractBits(opr1, 11, 0) << 10;
    uint32_t ins = cleanInstrImm(read32le(loc), 21, 10);
    write32le(loc, ins | imm10_12);
  } break;
  case R_LARCH_SOP_POP_32_S_5_20: {
    uint64_t opr1 = relStack.pop_back_val();
    checkInt(loc, static_cast<int64_t>(opr1), 20, rel);
    uint32_t imm5_20 = extractBits(opr1, 19, 0) << 5;
    uint32_t ins = cleanInstrImm(read32le(loc), 24, 5);
    write32le(loc, ins | imm5_20);
  } break;
  case R_LARCH_SOP_POP_32_S_0_5_10_16_S2: {
    uint64_t opr1 = relStack.pop_back_val();
    checkInt(loc, static_cast<int64_t>(opr1), 23, rel);
    checkAlignment(loc, opr1, 4, rel);
    uint32_t imm0_5 = extractBits(opr1, 22, 18);
    uint32_t imm10_16 = extractBits(opr1, 17, 2) << 10;
    uint32_t ins = cleanInstrImm(read32le(loc), 4, 0);
    ins = cleanInstrImm(ins, 25, 10);
    write32le(loc, ins | imm0_5 | imm10_16);
  } break;
  case R_LARCH_SOP_POP_32_S_0_10_10_16_S2: {
    uint64_t opr1 = relStack.pop_back_val();
    checkInt(loc, static_cast<int64_t>(opr1), 28, rel);
    checkAlignment(loc, opr1, 4, rel);
    uint32_t imm0_10 = extractBits(opr1, 27, 18);
    uint32_t imm10_16 = extractBits(opr1, 17, 2) << 10;
    uint32_t ins = cleanInstrImm(read32le(loc), 25, 0);
    write32le(loc, ins | imm0_10 | imm10_16);
  } break;
  case R_LARCH_SOP_POP_32_U: {
    uint64_t opr1 = relStack.pop_back_val();
    checkUInt(loc, opr1, 32, rel);
    write32le(loc, (uint32_t)opr1);
  } break;
  case R_LARCH_ADD8:
    *loc += val;
    break;
  case R_LARCH_ADD16:
    write16le(loc, read16le(loc) + val);
    break;
  case R_LARCH_ADD24:
    write32le(loc, (read32le(loc) | *(loc + 2) << 16) + val);
    break;
  case R_LARCH_ADD32:
    write32le(loc, read32le(loc) + val);
    break;
  case R_LARCH_ADD64:
    write64le(loc, read64le(loc) + val);
    break;
  case R_LARCH_SUB8:
    *loc -= val;
    break;
  case R_LARCH_SUB16:
    write16le(loc, read16le(loc) - val);
    break;
  case R_LARCH_SUB24:
    write16le(loc, (read16le(loc) | *(loc + 2) << 16) - val);
    break;
  case R_LARCH_SUB32:
    write32le(loc, read32le(loc) - val);
    break;
  case R_LARCH_SUB64:
    write64le(loc, read64le(loc) - val);
    break;
  // GNU C++ vtable hierarchy
  case R_LARCH_GNU_VTINHERIT:
  // GNU C++ vtable member usage
  case R_LARCH_GNU_VTENTRY:
    break;
  default:
    error(getErrorLocation(loc) + "unrecognized reloc " + Twine(rel.type));
  }
}
