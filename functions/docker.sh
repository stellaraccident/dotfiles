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

# Runs an interactive, named container as root.
# The container will be destoyed when the interactive session ends.
# Syntax:
#   docker_runit_root {image} {container_name} [{shell}] ...args...
# If the container_name is empty, does not set a specific name.
function docker_runit_root() {
  local image="$1"
  local container="$2"
  local shell="${3-/bin/bash}"
  local name_args=""
  if ! [ -z "$container" ]; then
    name_args="--name $container"
  fi
  docker run --rm $name_args "$@" -it "$image" "$shell"
}

# Starts a detached container, running as root.
# Syntax: docker_start_root {image} {container_name} ...args...
function docker_start_root() {
  local image="$1"
  local container="$2"
  docker run -d --rm --name "$container" "$image" tail -f /dev/null
}

# Ubuntu based containers do not install sudo by default. Do it.
function docker_install_sudo() {
  local container="$1"
  docker exec -it "$container" apt install -y sudo
}
