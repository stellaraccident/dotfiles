#!/bin/bash

function die() {
  echo "$*"
  exit 1
}

# Must be running in llvm-project.
build_type_cmake="RelWithDebInfo"
build_dir_suffix="debug"
src_dir="$PWD"
[ -f "$src_dir/iree/compiler/CMakeLists.txt" ] || die "Must be running in an iree tree (in $src_dir)"
build_dir="$(realpath $src_dir/../build-iree-$build_dir_suffix)"
install_dir="$(realpath $src_dir/../install-iree-$build_dir_suffix)"

cmake_options=(
  -GNinja
  "-H$src_dir"
  "-B$build_dir"
  -DCMAKE_C_COMPILER=clang-10
  -DCMAKE_CXX_COMPILER=clang++-10
  "-DCMAKE_INSTALL_PREFIX=$install_dir"
  -DCMAKE_BUILD_TYPE=$build_type_cmake
  -DLLVM_ENABLE_ASSERTIONS=On
)

echo "Configuring into $build_dir..."
echo "Invoking: cmake ${cmake_options[@]}"
cmake "${cmake_options[@]}" || die "Error invoking CMAKE with args ${cmake_options[@]}"
echo "CMake configure complete."
echo "Build dir: $build_dir"
