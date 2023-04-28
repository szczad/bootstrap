#!/usr/bin/env bash
# shellcheck disable=1090

NAME="ko"
VERSION="${BOOTSTRAP_KO_VERSION:="latest"}"

enabled() {
  return $(is_true "${BOOTSTRAP_GO_ENABLED:-"true"}")
}

install() {
  if [[ $BOOTSTRAP_KO_VERSION != "latest" ]] && [[ $BOOTSTRAP_KO_VERSION != v* ]]; then
    BOOTSTRAP_KO_VERSION="v${BOOTSTRAP_KO_VERSION}"
  fi

  go install "github.com/google/ko@${BOOTSTRAP_KO_VERSION}"
}

run() {
  source <(ko completion bash)
}

