function npcomp_docker() {
  docker run \
    --mount type=bind,source=$HOME/src/mlir-npcomp,target=/npcomp,readonly \
    --mount source=npcomp-pytorch-1.6-build,target=/build \
    --rm -it local/npcomp:build-pytorch-1.6 /bin/bash
}

