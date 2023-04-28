#!/usr/bin/env bash

NAME="k9s"
VERSION="${BOOTSTRAP_K9S_VERSION:-"latest"}"

enabled() {
  return $(is_true "${BOOTSTRAP_K9S_ENABLED:-"true"}")
}

install() {
  local iVERSION="$VERSION"
  if [[ ${iVERSION} = "latest" ]]; then
    iVERSION="master"
  elif [[ ${iVERSION} != v* ]]; then
    iVERSION="v${iVERSION}"
  fi

  local _k9s_work="$(mktemp -d)"
  bootstrap_clone "https://github.com/derailed/k9s.git" "$iVERSION" "$_k9s_work"
  (
    cd "$_k9s_work" || true
    go install
  )
  rm -rf "$_k9s_work"
}
