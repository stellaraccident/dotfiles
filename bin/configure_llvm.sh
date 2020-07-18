#!/bin/bash

function die() {
  echo "$*"
  exit 1
}

# Must be running in llvm-project.
build_type_cmake="Debug"
build_dir_suffix="debug"
src_dir="$PWD"
[ -f "$src_dir/llvm/CMakeLists.txt" ] || die "Must be running in an llvm-project tree (in $src_dir)"
build_dir="$(realpath $src_dir/../build-llvm-$build_dir_suffix)"
install_dir="$(realpath $src_dir/../install-llvm-$build_dir_suffix)"

cmake_options=(
  -GNinja
  "-H$src_dir/llvm"
  "-B$build_dir"
  -DLLVM_ENABLE_PROJECTS=mlir
  -DLLVM_TARGETS_TO_BUILD="X86;AArch64"
  -DLLVM_INCLUDE_TOOLS=ON
  -DLLVM_INCLUDE_TESTS=ON
  "-DCMAKE_INSTALL_PREFIX=$install_dir"
  -DCMAKE_BUILD_TYPE=$build_type_cmake
  -DLLVM_ENABLE_ASSERTIONS=On
)

echo "Configuring into $build_dir..."
echo "Invoking: cmake ${cmake_options[@]}"
cmake "${cmake_options[@]}" || die "Error invoking CMAKE with args ${cmake_options[@]}"
echo "CMake configure complete."
echo "Build dir: $build_dir"
