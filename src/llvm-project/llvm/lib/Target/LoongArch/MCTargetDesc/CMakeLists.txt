  add_llvm_component_library(LLVMLoongArchDesc
  LoongArchABIInfo.cpp
  LoongArchAnalyzeImmediate.cpp
  LoongArchAsmBackend.cpp
  LoongArchELFObjectWriter.cpp
  LoongArchELFStreamer.cpp
  LoongArchInstPrinter.cpp
  LoongArchMCAsmInfo.cpp
  LoongArchMCCodeEmitter.cpp
  LoongArchMCExpr.cpp
  LoongArchMCTargetDesc.cpp
  LoongArchTargetStreamer.cpp

  LINK_COMPONENTS
  MC
  LoongArchInfo
  Support

  ADD_TO_COMPONENT
  LoongArch
  )
