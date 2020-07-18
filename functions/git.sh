function git_root() {
  set +e
  git rev-parse --show-toplevel
}

function current_build_dir() {
  set +e
  local build_dir
  if [ -z "$CURRENT_BUILD_DIR" ]; then
    build_dir="$(git_root)/build"
    [ -d "$build_dir" ] || die "Build directory not found: $build_dir"
  else
    build_dir="$CURRENT_BUILD_DIR"
  fi
  echo "$build_dir"
}

# From a source directory, runs ninja.
function sninja() {
  set +e
  local build_dir
  build_dir="$(current_build_dir)"
  #echo "Running from build dir: $build_dir" 1>&2
  (cd "$build_dir" && ninja "$@")
}

function srun() {
  set +e
  local target="$1"
  shift
  local build_dir
  build_dir="$(current_build_dir)"
  (cd "$build_dir" && ninja "$target") && "$build_dir/$target" "$@"  
}


