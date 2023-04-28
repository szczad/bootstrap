#!/usr/bin/env bash
# shellcheck disable=1090

NAME="argo_cd"

enabled() {
  return $(is_true "${BOOTSTRAP_ARGOCD_ENABLED:="false"}")
}

install() {
  bootstrap_log_error "Not implemented!"
}

run() {
  source <(argocd completion bash)
}
