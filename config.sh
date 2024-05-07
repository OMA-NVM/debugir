#!/bin/bash

LLVM_VER="llvm-project-17.0.6"


cmake \
  -S llvm-project-*.src/llvm \
  -B build \
  -GNinja\
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_BUILD_TYPE=MinSizeRel \
  -DLLVM_OPTIMIZED_TABLEGEN=ON \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
  -DLLVM_TARGETS_TO_BUILD="AArch64;X86" \
  -DLLVM_EXTERNAL_DEBUGIR_SOURCE_DIR=. \
  -DLLVM_EXTERNAL_PROJECTS="DebugIR"

cd build || exit

mv compile_commands.json ../compile_commands.json

cd ..
