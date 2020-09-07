function mlir_configure_debug() {
  # -DCMAKE_CXX_FLAGS="-fsanitize=address -fno-omit-frame-pointer" \
  export CC=clang-10
  export CXX=clang++-10
  unset LDFLAGS
  export LDFLAGS
  cmake llvm/ -GNinja -Bbuild \
    -DLLVM_USE_LINKER=lld \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_OPTIMIZED_TABLEGEN=ON \
    -DMLIR_BINDINGS_PYTHON_ENABLED=ON \
    "$@"
}

