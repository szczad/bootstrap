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

rh_install() {
  LC_ALL=C LANG=C sudo dnf install -y "$@"
}

debian_install() {
  DEBIAN_NONINTERACTIVE=1 apt install -y "$@"
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
