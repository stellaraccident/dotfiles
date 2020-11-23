function npcomp_docker_build() {
  if ! [ -f "docker/pytorch-1.6/Dockerfile" ]; then
    echo "Please run out of mlir-npcomp/ source directory..."
    return 1
  fi
  echo "Building out of $(pwd)..."
  docker build docker/pytorch-1.6 --tag npcomp:build-pytorch-1.6
  docker_build_for_me npcomp:build-pytorch-1.6
}

function npcomp_docker_start() {
  docker_start me/npcomp:build-pytorch-1.6 npcomp \
    --mount type=bind,source=$HOME/src/mlir-npcomp,target=/src/mlir-npcomp \
    #--mount source=npcomp-build,target=/build \
}

function npcomp_docker_stop() {
  docker stop npcomp
}

function npcomp_docker_login() {
  docker_login npcomp
}
