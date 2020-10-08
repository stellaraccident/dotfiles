function npcomp_docker_build() {
  cd $HOME/src/mlir-npcomp
  echo "Building out of $(pwd)..."
  docker build docker/pytorch-1.6 --tag local/npcomp:build-pytorch-1.6
  docker_build_for_me local/npcomp:build-pytorch-1.6
}

function npcomp_docker_start() {
  docker_start_root me/local/npcomp:build-pytorch-1.6 npcomp \
    --mount source=npcomp-build,target=/build \
    --mount type=bind,source=$HOME/src/mlir-npcomp,target=/src/mlir-npcomp
}

function npcomp_docker_stop() {
  docker stop npcomp
}
