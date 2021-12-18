#!/usr/bin/env bash
# shellcheck disable=1090

if command_exists alacritty; then
  log_debug "Registering Alacritty terminal helpers"

  alacritty_size() {
    if [[ $1 -lt 10 ]]; then
      printf "Invalid value specified: %s\n" "$1"
      exit 1
    fi
    sed -i -e "s@^\(\s\+size\):.*@\1: ${1}.0@g" ~/.config/alacritty/alacritty.yml
  }
fi

