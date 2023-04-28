#!/usr/bin/env bash

NAME="skaffold"
VERSION="${BOOTSTRAP_SKAFFOLD_VERSION:-"2.3.1"}"

enabled() {
  return $(is_true "${BOOTSTRAP_SKAFFOLD_ENABLED:-"true"}")
}

run() {
  # shellcheck disable=SC1090
  source <(skaffold completion bash)
}

install() {
  local iVERSION="$VERSION"
  if [[ ${iVERSION} = "latest" ]]; then
    iVERSION="master"
  elif [[ ${iVERSION} != v* ]]; then
    iVERSION="v${iVERSION}"
  fi

  local _skaffold_file="$(bootstrap_fetch "https://storage.googleapis.com/skaffold/releases/${iVERSION}/skaffold-${OS}-${ARCHN}")"
  bootstrap_local_install "$_skaffold_file" "skaffold"
  rm -f "$_skaffold_file"
}
