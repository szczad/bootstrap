#!/usr/bin/env bash
# shellcheck disable=1090

if command_exists tkn; then
  log_debug "Adding Tekton completion"

  source <(tkn completion bash)
fi
