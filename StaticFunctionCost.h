#include <sstream>
#include <string>
#include <iostream>

#include "llvm/Pass.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/Support/raw_ostream.h"


namespace llvm {

  class BlockEdgeFrequencyPass;

  class StaticFunctionCostPass : public FunctionPass {
  public:
  private:
    // Branch probabilities calculated.
    BlockEdgeFrequencyPass *BEFP;

  public:
    static char ID; // Class identification, replacement for typeinfo.

    StaticFunctionCostPass();
    ~StaticFunctionCostPass();

    virtual void getAnalysisUsage(AnalysisUsage &AU) const;
    virtual bool runOnFunction(Function &F);
    void print(raw_ostream &O, const Module *M) const;
  };

}
