function mlir_configure_debug() {
  export CC=clang-10
  export CXX=clang++-10
  cmake llvm/ -GNinja -Bbuild \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DLLVM_USE_SPLIT_DWARF=ON \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_USE_SPLIT_DWARF=ON \
    -DLLVM_USE_LINKER=lld \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DMLIR_BINDINGS_PYTHON_ENABLED=ON \
    "$@"
}
