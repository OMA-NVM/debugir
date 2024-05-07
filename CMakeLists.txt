#building out of llvm sources  is not possible, see:
#https://lists.llvm.org/pipermail/llvm-dev/2019-March/130706.html
message (STATUS "Found tool DebugIR")

#cmake_minimum_required(VERSION 3.5.1)

project("DebugIR")

set(LLVM_LINK_COMPONENTS
  ${LLVM_TARGETS_TO_BUILD}
  support
  core
  irreader
  transformutils
  Passes
  )

message (STATUS "${PROJECT_BINARY_DIR}")
message (STATUS "${PROJECT_SOURCE_DIR}")

include_directories(include)

add_llvm_tool(DebugIR
  ${PROJECT_SOURCE_DIR}/Main.cpp
  )

add_subdirectory(lib)

target_link_libraries (DebugIR PRIVATE debugIrFramework)
