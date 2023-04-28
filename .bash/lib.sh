# Location at which binaries will be installed
BOOTSTRAP_LOCAL_BIN_PATH="${BOOTSTRAP_LOCAL_BIN_PATH:-"${HOME}/.local/bin"}"
BOOTSTRAP_LOCAL_BIN_MODE="0755"
BOOTSTRAP_CACHE_DIR="${HOME}/.cache/bash"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -p)"
DISTRIBUTION="$(grep DISTRIB_CODENAME /etc/*-release | awk -F= '{ print $2 }')"

case "$ARCH" in
  x86_64) 
    ARCHN="amd64"
    ;;
  *)
    ARCHN="$ARCH"
    ;;
esac

export OS ARCH ARCHN DISTRIBUTION

# Cleans up the environment once everything is set.
bootstrap_cleanup() {
  # shellcheck disable=SC2046
  unset $(declare -F | cut -d" " -f 3 | grep ^bootstrap)
}

bootstrap_is_installed() {
  local name="${BOOTSTRAP_CACHE_DIR}/installed/$1"
  local version="${2:-latest}"

  if [[ -e "$name" ]] && [[ $(cat "$name") == "$version" ]]; then
    return 0
  else
    return 1
  fi
}

bootstrap_register_installation() {
  local name="${BOOTSTRAP_CACHE_DIR}/installed/$1"
  local version="${2:-latest}"

  echo -n "$version" > "$name"
}

bootstrap_log() {
  local eol="\n" pre=""
  if [[ $1 = "-n" ]]; then
    eol=""
    shift
  fi

  if [[ $# -gt 1 ]]; then
    pre="${1}: "
    shift
  fi

  printf "${pre}%s${eol}" "$@" >&2
}

bootstrap_log_debug() {
  if is_true "$BOOTSTRAP_DEBUG"; then
    bootstrap_log "DBG" "$@"
  fi
}

bootstrap_log_info() {
  bootstrap_log "INF" "$@"
}

bootstrap_log_warning() {
  bootstrap_log "WRN" "$@"
}

bootstrap_log_error() {
  bootstrap_log "ERR" "$@"
}

# Prepends path to the end of the PATH variable
# if "-d" is passed as the first argument then no checks for directory
# existence is done
bootstrap_prepend_path() {
  local _check="1"
  if [ "$1" = "-d" ]; then
    _check="0"
    shift
  fi

  local _path="$1"
  if [[ ":${PATH}:" != *:"$_path":* ]]; then
    if [[ $_check = "0" ]] || [[ -d "$_path" ]]; then
      bootstrap_log_debug "Prepending \"$_path\" to PATH"
      PATH="${_path}:${PATH}"
    fi
  fi
}

# Appends path to the end of the PATH variable
# if "-d" is passed as the first argument then no checks for directory
# existence is done
bootstrap_append_path() {
  local _check="1"
  if [ "$1" = "-d" ]; then
    _check="0"
    shift
  fi

  local _path="$1"
  if [[ ":${PATH}:" != *:"$_path":* ]]; then
    if [[ $_check = "0" ]] || [[ -d "$_path" ]]; then
      bootstrap_log_debug "Appending \"$_path\" to PATH"
      PATH="${PATH}:${_path}"
    fi
  fi
}

bootstrap_group_add() {
  local group="$1"

  if ! command groups "$(id -un)" | tr ' ' '\n' | tail -n +3 | grep -q "^${group}$"; then
    bootstrap_log_debug "Adding user \"$USER\" to group \"$group\"..."
    command sudo gpasswd -a "$USER" "$group"
  fi
}

bootstrap_command_exists() {
  command -v "$1" >/dev/null
}

bootstrap_install() {
  local src="$1"
  local dest="${2:-}"
  local _file

  if [[ $src =~ ^(http|https|ftp): ]]; then
    _file="$(bootstrap_fetch "$src")"
  else
    bootstrap_log_error "Invalid URL specified!"
    return 1
  fi

  bootstrap_local_install "$_file" "$dest"
}

bootstrap_local_install() {
  local src="$1"
  local dest="${BOOTSTRAP_LOCAL_BIN_PATH}/${2:-"$(basename "$1")"}"

  command install -m "$BOOTSTRAP_LOCAL_BIN_MODE" "$src" "$dest"
  command rm -f "$src"
}

bootstrap_apt() {
  command sudo apt-get "$@"
}

bootstrap_apt_exist() {
  command dpkg -s "$@" >/dev/null 2>&1
}

bootstrap_apt_update() {
  bootstrap_apt update
}

bootstrap_apt_install() {
  if ! bootstrap_apt_exist "$@"; then
    bootstrap_apt install -y --no-install-recommends "$@"
  fi
}

bootstrap_fetch() {
  local _url="$1"
  local _hash="${2:-}"
  local _localhash
  local _tmp

  _tmp="$(command mktemp -d)"
  if ! command curl --progress-bar  --location --fail --output-dir "$_tmp" --remote-name "$_url"; then
    bootstrap_log_error "Could not fetch $_url"
    return 1
  fi

  case "${_hash%%:*}" in
    sha256)
      _localhash="$(sha256sum -b "$_tmp"/* | cut -d" " -f 1)"
      ;;
    sha384)
      _localhash="$(sha384sum -b "$_tmp"/* | cut -d" " -f 1)"
      ;;
    sha512)
      _localhash="$(sha512sum -b "$_tmp"/* | cut -d" " -f 1)"
      ;;
    *)
      _localhash=""
  esac

  if [ "$_localhash" != "" ] && [ "${_hash#*:}" != "$_localhash" ]; then
    bootstrap_log_error "Invalid file hash for \"$_url\". Expected: ${_hash#*:}, found: $_localhash"
    command rm -rf "$_tmp"
    return 1
  fi

  echo "$_tmp"/*
}

# Unpacks anything into the destination directory.
# Usage: unpack [-s] <compressed file> <destination>
bootstrap_unpack() {
  local _strip=""
  if [[ "$1" = "-s" ]]; then
    _strip="1"
    shift
  fi

  local _filename="$1"
  local _destination="$2"
  local _type="none"

  if [[ $_filename = *.tar.* ]]; then
    _type="tar"
  elif [[ $_filename = *.tgz ]]; then
    _type="tar"
  elif [[ $_filename = *.zip ]]; then
    _type="zip"
  fi

  case "$_type" in
    tar)
      command mkdir -p "$_destination"
      command tar xaf "$_filename" ${_strip:+--strip-components 1} -C "$_destination"
      ;;
    zip)
      command mkdir -p "$_destination"
      command unzip -o "$_filename" -d "$_destination"
      ;;
    *)
      bootstrap_log_error "Unknown compression algorithm for file: $_filename"
      return 1
  esac
}

bootstrap_clone() {
  local _url="$1"
  local _ref="$2"
  local _destination="$3"

  command git clone --single-branch --branch "$_ref" --depth "${GIT_CLONE_DEPTH:-1}" "$_url" "$_destination"
}

is_true() {
  while [[ $# -gt 0 ]]; do
    if [[ ! $1 =~ ^[1-9]|([Tt][Rr][Uu][Ee])|([Yy][Ee][Ss]) ]]; then
      return 1
    fi
    shift
  done

  return 0
}

# vim: filetype=sh
