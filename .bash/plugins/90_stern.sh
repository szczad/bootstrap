#!/usr/bin/env bash
# shellcheck disable=1090

if command_exists stern; then
  log_debug "Add Stern completion"

  source <(stern --completion bash)
fi
