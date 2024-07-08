#ifndef LLVM_TRANSFORMS_LAYERRELATION_H
#define LLVM_TRANSFORMS_LAYERRELATION_H

#include "llvm/IR/PassManager.h"

namespace llvm {

class LayerRelationPass : public PassInfoMixin<LayerRelationPass> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM);
  void parseFile(std::string Filename);
  bool parseLine(std::string Line, int LineNumber);
  int lineHasLineNumber(std::string Line);
  bool isHex(std::string& In);
};

} // namespace llvm

#endif 
