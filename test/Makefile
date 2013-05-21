LLVM_PATH=../../../..
DEBUG_PATH=$(LLVM_PATH)/Debug+Asserts
BIN_PATH=$(DEBUG_PATH)/bin

compile:
	$(BIN_PATH)/clang -emit-llvm -c teste2.c -o teste0.bc
	$(BIN_PATH)/opt -mem2reg teste0.bc > teste.bc
run: compile
	$(BIN_PATH)/opt -load $(DEBUG_PATH)/lib/static-profiling.dylib -branch-prediction-dot -analyze teste.bc > graph.dot
	sed -i'.bkp' '1d' graph.dot
dot: graph.dot
	dot -Tpng -o graph.png graph.dot
view: run dot
	open graph.png
