function mlir_configure_debug() {
  # -DCMAKE_CXX_FLAGS="-fsanitize=address -fno-omit-frame-pointer" \
  export CC=clang-10
  export CXX=clang++-10
  unset LDFLAGS
  export LDFLAGS
  cmake llvm/ -GNinja -Bbuild \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DLLVM_USE_SPLIT_DWARF=ON \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_BUILD_LLVM_DYLIB=ON \
    -DLLVM_USE_SPLIT_DWARF=ON \
    -DLLVM_USE_LINKER=lld \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_OPTIMIZED_TABLEGEN=ON \
    -DMLIR_BINDINGS_PYTHON_ENABLED=ON \
    "$@"
}

function mlir_configure_debug_bfd_static() {
  # -DCMAKE_CXX_FLAGS="-fsanitize=address -fno-omit-frame-pointer" \
  export CC=clang-10
  export CXX=clang++-10
  unset LDFLAGS
  export LDFLAGS
  cmake llvm/ -GNinja -Bbuild \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DLLVM_USE_SPLIT_DWARF=ON \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_USE_SPLIT_DWARF=ON \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_OPTIMIZED_TABLEGEN=ON \
    -DMLIR_BINDINGS_PYTHON_ENABLED=ON \
    "$@"
}
