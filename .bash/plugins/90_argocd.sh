#!/usr/bin/env bash
# shellcheck disable=1090

if command_exists argocd; then
  log_debug "Add ArgoCD completion"

  source <(argocd completion bash)
fi
