add_path() {
  local _path="$1"

  if [[ -d $_path ]] && [[ $PATH != *"$_path"* ]]; then
    PATH="${PATH}:$_path"
  fi
}

command_exists() {
  command -v "$1" >/dev/null
}


