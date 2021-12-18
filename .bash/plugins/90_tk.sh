#!/usr/bin/env bash
# shellcheck disable=1090

if command_exists "tk"; then
  log_debug "Adding Tanka completion"

  complete -C tk tk
fi
