#!/usr/bin/env bash
# shellcheck disable=1090

if command_exists npm; then
  log_debug "Adding binaries installed via NPM"

  append_path "$HOME/.local/npm/bin"
fi
