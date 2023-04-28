#!/usr/bin/env bash
# shellcheck disable=1090

NAME="stern"

enabled() {
  if is_true "${BOOTSTRAP_KUBERNETES_ENABLED:-"true"}" && is_true "${BOOTSTRAP_GO_ENABLED:-"true"}"; then
    return 0
  else
    return 1
  fi
}

install() {
  go install github.com/stern/stern@latest
}

run() {
  source <(stern --completion bash)
}

