#!/usr/bin/env bash
# shellcheck disable=1090,SC2034

# Setup some variables
NAME=os

install() {
  declare -a PACKAGES

  PACKAGES+=(curl ca-certificates)
  PACKAGES+=(flatpak)
  PACKAGES+=(gettext jq net-tools)
  PACKAGES+=(gimp)
  PACKAGES+=(ssh-askpass-gnome)

  bootstrap_apt_install "${PACKAGES[@]}"

  unset PACKAGES
}

run() {
  export TERM="screen-256color"
  export XDG_DATA_DIRS="${XDG_DATA_DIRS}:${HOME}/.local/share"
  export LOCAL_BASH_COMLPETION_DIR="$HOME/.local/share/bash-completions"
  export SSH_ASKPASS="/usr/bin/ssh-askpass"
  export SUDO_ASKPASS="/usr/bin/ssh-askpass"

  # Setup standard directories
  mkdir -p "$HOME/.local/share/icons" "$LOCAL_BASH_COMLPETION_DIR"

  _paths=("$HOME/bin" "$HOME/.local/bin")
  for _path in "${_paths[@]}"; do
    bootstrap_append_path "$_path"
  done
}
