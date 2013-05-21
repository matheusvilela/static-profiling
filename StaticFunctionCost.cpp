#include "StaticFunctionCost.h"
#include "BlockEdgeFrequencyPass.h"

using namespace llvm;

char StaticFunctionCostPass::ID = 0;

static RegisterPass<StaticFunctionCostPass>
X("static-functin-cost", "Statically estimate a function cost based on basic block and edge frequencies",
  false, true);

StaticFunctionCostPass::StaticFunctionCostPass() : FunctionPass(ID) {
}

StaticFunctionCostPass::~StaticFunctionCostPass() {
}

void StaticFunctionCostPass::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequired<BlockEdgeFrequencyPass>();
  AU.setPreservesAll();
}

bool StaticFunctionCostPass::runOnFunction(Function &F) {
  BEFP = &getAnalysis<BlockEdgeFrequencyPass>();

  return false;
}

void StaticFunctionCostPass::print(raw_ostream &O, const Module *M) const {
}

