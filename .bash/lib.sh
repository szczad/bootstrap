add_path() {
  local _path="$1"

  if [[ -d $_path ]] && [[ $PATH != *"$_path"* ]]; then
    log_debug "Adding \"$_path\" to PATH"
    PATH="${PATH}:$_path"
  fi
}

command_exists() {
  command -v "$1" >/dev/null
}

log_debug() {
  if [[ $BASH_DEBUG != "" ]]; then
    printf "INF: %s\n" "$@" >&2
  fi
}

log_error() {
  printf "ERR: %s\n" "$@" >&2
}
