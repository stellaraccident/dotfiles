function cmake_use_ccache() {
  cmake . -DCMAKE_CXX_COMPILER_LAUNCHER=ccache
}

