alias venv="python3 -m venv"
VENV_ROOT="$HOME/.venv"

function venv_create() {
  local name="$1"
  if [ -z "$name" ]; then
    echo "Syntax: venv_create {name}"
    return 1
  fi
  python3 -m venv "$VENV_ROOT/$name"
}

function venv_activate() {
  local name="$1"
  local script="$VENV_ROOT/$name/bin/activate"
  if ! [ -f "$script" ]; then
    echo "Virtual env '$name' not found at $script"
    return 1
  fi
  source "$script"
}


if ! [ -z "$VIRTUAL_ENV" ]; then
  echo "Re-activating venv $VIRTUAL_ENV"
  source "$VIRTUAL_ENV/bin/activate"
fi
