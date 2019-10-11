#!/usr/bin/env bash

AVAILABLE_SCRIPTS=($( ( cd $BASE_DIR; find scripts -type f -name \*.sh | sed -e 's@scripts/@@g' -e 's@\.sh$@@g') ))
SCRIPTS=()

SUDO_BIN="$(which sudo)"
DNF_BIN="/usr/bin/dnf"
YUM_BIN="/usr/bin/yum"
APT_BIN="/usr/bin/apt-get"
BREW_BIN="/usr/local/bin/brew"
PORT_BIN="/opt/local/bin/port"

# Log info message
function info() {
  echo -e "\e[96m$@\e[39m" >&2
}

# Log warining message
function warn() {
  echo -e "\e[93m$@\e[39m" >&2
}

# Log success message
function success() {
  echo -e "\e[92m$@\e[39m" >&2
}

# Log error message
function error() {
  echo -e "\e[91m$@\e[39m" >&2
}

# Show scripts available for execution
function available_scripts_help() {
  info "Available scripts:\n${AVAILABLE_SCRIPTS[@]}"
}

# Show help
function help() {
  info "Usage:"
  info "  $0 [-h|--help] [-l|--list] [-a|--all]"
  info "  $0 [script|script_group...]"
  info ""
  info "Where:"
  info "\t-h|--help           - print this help"
  info "\t-u|--usage          - print short usage help"
  info "\t-l|--list           - list all available scripts and script groups"
  info "\t-a|--all            - run all available scripts and script groups"
  info "\tscript|script_group - scripts to execute. If no scripts are provided the default list is executed."
  info "\t\tdefaults: ${DEFAULT_SCRIPTS[@]}"
}

function file_contains() {
  # SRC: https://stackoverflow.com/questions/31540902/how-to-check-if-one-file-is-part-of-other
  awk 'FNR==NR {a[FNR]=$0; next}
     FNR==1 && NR>1 {for (i in a) len++}
     {for (i=last; i<=len; i++) {
         if (a[i]==$0)
            {last=i; next}
     } status=1}
     END {exit status+0}' "$1" "$2"
  return $?
}

function patch_file() {
  if [ ! -e "$1" ]; then
    error "Source file does not exist! ($1)"
    exit 1
  fi

  conditional_sudo $(is_user_dir "$2") bash -c "cat \"$1\" >> \"$2\""
}

# Helper to check if the node is directory
function is_dir() {
  [ -d "$1" ] && return 0 || return 1
}

# Helper to check if the node is file
function is_file() {
  [ -f "$1" ] && return 0 || return 1 
}

# Helper to check if the node is readable
function is_readable() {
  [ -r "$1" ] && return 0 || return 1
}

# Helper to check if the node is writable
function is_writable() {
  [ -w "$1" ] && return 0 || return 1
}

# Helper to check if the node is executable
function is_executable() {
  [ -x "$1" ] && return 0 || return 1
}

# Extract real path of the object
function real_path() {
  if [ ! -e "$1" ]; then
    return 1
  fi

  ( cd "$1"; pwd -P )
}

# Get GID of the user
function get_gid() {
  if [ "$#" -lt 1 ]; then
    set $UID
  fi

  echo "$(id -g $1)"
}

# Get current UID
function get_uid() {
  echo $UID
}

# Get owner:group for current platform
function get_root_owner() {
  if is_mac; then
    echo "root:wheel"
  else
    echo "root:root"
  fi
}

# Check if the object is located in user directory
function is_user_dir() {
  if [[ $UID -ne 0 ]] && [[ $1 = ${HOME}* ]]; then
    return 1
  else
    return 0
  fi
}

function dir_name() {
  if [ -d "$1" ]; then
    RET="${1%/}/"
  else
    RET="$(dirname "$1")/"
  fi

  echo "${RET//\/\//\/}"
}

function copy() {
  if is_dir "$1"; then
    copy_dir "$@"
  else
    copy_file "$@"
  fi
}

# Copy directory content from one place to another
function copy_dir() {
  local DOTGLOB_LAST="$(shopt -p dotglob || true)"
  local SRC="${1%/}/"
  local DST="${2%/}/"

  shopt -s dotglob
  is_readable "$SRC" || make_dir "$SRC"
  sudo cp -Rv "$SRC"/* "$DST"
  $DOTGLOB_LAST
}

function copy_file() {
  local _dir
  if [[ "$2" = */ ]]; then
    _dir="$2"
  else
    _dir="$(dir_name "$2")"
  fi

  if [ ! -e "$_dir" ]; then
    make_dir "$_dir" 
  fi

  sudo cp -v "$1" "$2" 
}

# Create directory with given set of paramteres: path, user, group, mode
function make_dir() {
  local _path="$1"
  local _user="${2:-}"
  local _group="${3:-}"
  local _mode="${4:-}"

  local _cmd="mkdir -p '$_path'"
  
  if [ "$_user" != "" ]; then
    _cmd+="; chown '$_user' '$_path'"
  fi

  if [[ $_group != "" ]]; then
    _cmd+="; chgrp '$_group' '$_path'"
  fi

  if [[ $_mode != "" ]]; then
    _cmd+="; chmod '$_mode' '$_path'"
  fi

  if ! is_writable "$_path"; then
    _cmd="sudo bash -c '$_cmd'"
  fi

  eval $_cmd
}

# Obsolete version of make_dir_new()
function make_dir_new() {
  warn "make_dir_new() is deprecated"

  local _mode="$1"
  local _user="$2"
  local _group="$3"
  local _path="$4"

  local _old_ifs="$IFS"
  local _existing_path=""

  if [ ! -e "$_path" ]; then
    IFS=$'\n'

    # Get path
    set -- $(namei -v "$4")
    shift 2

    for line in "$@"; do
      if [ "$(echo "$line" | cut -b 1-2)" = "d " ]; then
        _existing_path="${_existing_path}/$(echo "$line" | cut -b 3-)"
      fi
    done

    : ${_existing_path:=/}
    
    IFS="$_old_ifs"
  else
    if [ ! -d "$_path" ]; then
      error "Paths \"$_path\" is not a directory"
      exit 1
    fi
  fi

  if [ "$(stat -c "%u" "$_existing_path")" = "$(id -u $_user)" ]; then
    :  
  else
    :
  fi
}

function is_true() {
  local VAL="${1,,}"

  if [[ $VAL =~ ^([yY]([eE][sS])?|1|[Tt][rR][uU][eE]|[oO][nN])$ ]]; then
    return 0
  else
    return 1
  fi
}

function yes_no_check() {
  warn "yes_no_check is depreceted"
  is_true "$@"
}

function conditional_include() {
  local VAR="$1"
  shift
  if yes_no_check "$VAR"; then
    echo "$@"
  fi
}

function sudo() {
  if [[ $UID -ne 0 ]]; then
    command sudo "$@"
  else
    "$@"
  fi
}

function conditional_sudo() {
  local path="$(real_path "$1")"
  shift

  if is_writable "$path"; then
    "$@"
  else
    sudo "$@"
  fi 
}

function dnf_install() {
  if [ -x "$DNF_BIN" ]; then
    LC_ALL=C LANG=C sudo $DNF_BIN install -y "$@"
  elif [ -x "$YUM_BIN" ]; then
    LC_ALL=C LANG=C sudo $YUM_BIN install -y "$@"
  fi
}

function apt_install() {
  if [ -x "/usr/bin/apt-get" ]; then
    LC_ALL=C LANG=C DEBIAN_NONINTERACTIVE=1 sudo $APT_BIN install -y "$@"
  fi
}

function mac_port_install() {
  if [ -x "$PORT_BIN" ]; then
    LC_ALL=C LANG=C sudo $PORT_BIN install "$@"
  fi
}

function mac_brew_install() {
  if [ -x "/usr/local/bin/brew" ]; then
    LC_ALL=C LANG=C brew install "$@"
  fi
}

function is_linux() {
  [[ "$OSTYPE" = linux* ]] && return 0 || return 1
}

function is_mac() {
  [[ "$OSTYPE" = darwin* ]] && return 0 || return 1
}

function is_bsd() {
  [[ "$OSTYPE" = *bsd* ]] && return 0 || return 1
}

if [[ "$OSTYPE" == "linux"* ]]; then
  OS="linux"
  DISTRO="$(sed -e '/^ID=/!d;s/^ID=//g' /etc/os-release)"

  if [[ "${DISTRO,,}" =~ fedora|redhat|centos ]]; then
    package_install() {
      rh_install "$@" 
    }
  elif [[ "${DISTRO,,}" =~ debian|ubuntu ]]; then
    package_install() {
      debian_install "$@" 
    }
  else
    error "Unknown Linux distribution"
    exit 1
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="mac"

  if which brew >/dev/null; then 
    package_install() {
      mac_brew_install "$@"
    }
  elif which port >/dev/null; then
    package_install() {
      mac_port_install "$@"
    }
  else
    error "Cannot determine packaging system on MacOS"
    exit 1
  fi
elif [[ "$OSTYPE" == *"bsd"* ]]; then
  OS="bsd"
else
  error "Unknown operating system!"
  exit 1
fi

IS_COLOR_ENABLED=

