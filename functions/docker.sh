# Adds my current (host) user/group to a docker container and enables it
# for sudo (if available).
# Syntax:
#   docker_addme {container_id} [shell]
function docker_addme() {
  local container="$1"
  local shell="${2-/bin/bash}"
  docker exec -it "$container" "$shell" -c "set -x; addgroup --gid $(id -g $USER) $USER; useradd -m -b /home --gid $(id -g $USER) --uid $(id -u $USER) $USER; echo '$USER ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
}

# Docker run as me (use after docker_addme on a container).
# Syntax:
#   docker_execme -it container_name /bin/bash
function docker_execme() {
  docker exec --user $USER "$@"
}

# Logs in interactively to a docker container (setup with docker_addme).
# Syntax:
#   docker_login {container_name}
function docker_login() {
  local container="$1"
  local shell="${2-/bin/bash}"
  docker_execme -it "$container" "$shell"
}

# Runs an interactive, named container as the default user.
# The container will be destoyed when the interactive session ends.
# Syntax:
#   docker_runit {image} {container_name} ...args...
# If the container_name is empty, does not set a specific name.
function docker_runit() {
  local image="$1"
  shift
  local container="$1"
  shift
  local name_args=""
  if ! [ -z "$container" ]; then
    name_args="--name $container"
  fi
  docker run --rm $name_args "$@" -it "$image" "/bin/bash"
}

# Starts a detached container, running as root.
# Syntax: docker_start_root {image} {container_name} ...args...
function docker_start() {
  local image="$1"
  local container="$2"
  shift
  shift
  if [ -z "$image" ] || [ -z "$container" ]; then
    echo "Expected args: {image} {container_name}"
    return 1
  fi
  echo "Starting container $container from $image..."
  docker run -d --rm "$@" --name "$container" "$image" tail -f /dev/null
}

# Ubuntu based containers do not install sudo by default. Do it.
function docker_install_sudo() {
  local container="$1"
  docker exec -it "$container" apt install -y sudo
}

# From a root image, build an image just for me, hard-coded with a user
# matching the host user and a home directory that mirrors that on the host.
function docker_build_for_me() {
  local root_image="$1"
  echo "
    FROM $root_image

    USER root
    RUN apt install -y sudo byobu git procps lsb-release gdb less nano vim clang-format
    RUN addgroup --gid $(id -g $USER) $USER
    RUN mkdir -p $(dirname $HOME) && useradd -m -d $HOME --gid $(id -g $USER) --uid $(id -u $USER) $USER
    RUN echo '$USER ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
    USER $USER
  " | docker build --tag me/${root_image} -
}

# From a root image, build an image just for me, hard-coded with a user
# matching the host user and a home directory that mirrors that on the host.
function docker_build_for_me_rhel() {
  local root_image="$1"
  echo "
    FROM $root_image

    USER root
    RUN yum install -y sudo byobu git procps gdb less nano vim
    RUN groupadd --gid $(id -g $USER) $USER
    RUN mkdir -p $(dirname $HOME) && useradd -m -d $HOME --gid $(id -g $USER) --uid $(id -u $USER) $USER
    RUN echo '$USER ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
    USER $USER
  " | docker build --tag me/${root_image} -
}
