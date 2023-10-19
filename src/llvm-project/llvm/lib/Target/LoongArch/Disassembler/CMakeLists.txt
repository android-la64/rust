add_llvm_component_library(LLVMLoongArchDisassembler
  LoongArchDisassembler.cpp

  LINK_COMPONENTS
  MCDisassembler
  LoongArchInfo
  Support

  ADD_TO_COMPONENT
  LoongArch
  )
