#!/usr/bin/env bash
# shellcheck disable=1090

NAME="kind"
VERSION="${BOOTSTRAP_KIND_VERSION:-"0.15.0"}"

install() {
  local iVERSION="$VERSION"
  if [[ ${iVERSION} = "latest" ]]; then
    iVERSION="master"
  elif [[ ${iVERSION} != v* ]]; then
    iVERSION="v${iVERSION}"
  fi
  go install "sigs.k8s.io/kind@${iVERSION}"
}

run() {
  source <(kind completion bash)
}
