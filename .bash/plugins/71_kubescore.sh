#!/usr/bin/env bash
# shellcheck disable=1090

NAME="kube-score"
VERSION="${BOOTSTRAP_KO_VERSION:="latest"}"

enabled() {
  if is_true "${BOOTSTRAP_KO_ENABLED:-"true"}" && is_true "${BOOTSTRAP_GO_ENABLED:-"true"}"; then
    return 0
  else
    return 1
  fi
}

install() {
  local iVERSION="$VERSION"
  if [[ $iVERSION != "latest" ]] && [[ $iVERSION != v* ]]; then
    iVERSION="v${iVERSION}"
  fi
  go install "github.com/google/ko@${iVERSION}"
}

run() {
  source <(ko completion bash)
}

