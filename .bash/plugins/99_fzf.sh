#!/usr/bin/env bash
# shellcheck disable=1090

if command_exists fzf; then
  log_debug "Loading FZF key bindings"

  # FZF search replacement
  source "$BOOTSTRAP_DIR/.bash/share/fzf/key-bindings.bash"
fi
