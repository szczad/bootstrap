#!/bin/bash -x

# Be more strict about errors
set -euo pipefail
BASE_DIR="$(dirname "$(readlink -f "$0")")"
GID="$(id -g $USER)"
SCRIPTS=()

info() {
  echo -e "\e[96m$@\e[39m" >&2
}

warn() {
  echo -e "\e[93m$@\e[39m" >&2
}

success() {
  echo -e "\e[92m$@\e[39m" >&2
}

error() {
  echo -e "\e[91m$@\e[39m" >&2
}

file_contains() {
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

copy_dir() {
  set +e
  DOTGLOB_LAST="$(shopt -p dotglob)"
  shopt -s dotglob
  sudo cp -av "files/$1"/* "$2"
  $DOTGLOB_LAST
  set -e
}

make_dir() {
  local _path="${1%/}/"
  local _user="${2:-}"
  local _group="${3:-}"
  local _mode="${4:-}"

  local _cmd="mkdir -p '$_path'"
  
  if [[ $_user != "" ]]; then
    _cmd+="; chown '$_user' '$_path'"
  fi

  if [[ $_group != "" ]]; then
    _cmd+="; chgrp '$_group' '$_path'"
  fi

  if [[ $_mode != "" ]]; then
    _cmd+="; chmod '$_mode' '$_path'"
  fi

  if [[ ! $_path =~ /home/$USER/.* ]]; then
    _cmd="sudo bash -c '$_cmd'"
  fi

  eval $_cmd
}

make_dir_new() {
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

yes_no_check() {
  local VAL="${1,,}"

  if [ "$VAL" = "yes" ] || [ "$VAL" = "1" ] || [ "$VAL" = "true" ]; then
    return 0
  else
    return 1
  fi
}

conditional_include() {
  local VAR="$1"
  shift
  local VALUE="$@"
  if yes_no_check "$VAR"; then
    echo ${VALUE[@]}
  fi
}

conditional_sudo() {
  if [[ $UID -ne 0 ]]; then
    sudo "$@"
  else
    "$@"
  fi
}

rh_install() {
  LC_ALL=C LANG=C conditional_sudo dnf install -y "$@"
}

debian_install() {
  LC_ALL=C LANG=C DEBIAN_NONINTERACTIVE=1 conditional_sudo apt install -y "$@"
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
elif [[ "$OSTYPE" == *"bsd"* ]]; then
  OS="bsd"
else
  error "Unknown operating system!"
  exit 1
fi

# Read explicit configuration
source "$BASE_DIR/install.vars"

AVAILABLE_SCRIPTS=($(find scripts -type f -name \*.sh -printf "%P " | sed -e 's/\.sh//g'))
available_scripts_help() {
  echo -e "Available scripts:\n${AVAILABLE_SCRIPTS[@]}"
  exit 0
}

for ARG in "$@"; do
  case "$ARG" in
    -a|--all)
      SCRIPTS=("${AVAILABLE_SCRIPTS[@]}")
      ;;
    -l|--list)
      available_scripts_help
      ;;
    *)
      if [[ -e "$BASE_DIR/scripts/$ARG.sh" ]]; then
        SCRIPTS+="$ARG"
      else
        warn "Script \"$ARG\" does not exist"
      fi
      ;;
  esac
done

if [ "${#SCRIPTS[@]}" -eq "0" ]; then
  available_scripts_help
fi

for SCRIPT in "${SCRIPTS[@]}"; do
  source "scripts/${SCRIPT}.sh"
done

info "All done!"
