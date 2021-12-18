#!/usr/bin/env bash
# shellcheck disable=1090

if command_exists minikube; then
  log_debug "Loading Minikube completion"

  source <(minikube completion bash)
fi
