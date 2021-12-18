#!/usr/bin/env bash
# shellcheck disable=1090

if command_exists kind; then
  log_debug "Loading Kind completion"

  source <(kind completion bash)
fi
