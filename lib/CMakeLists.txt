message(STATUS "Found DebugIR Framework LIB")

add_llvm_library(debugIrFramework
DebugIR.cpp
DEPENDS LLVMCore
)
