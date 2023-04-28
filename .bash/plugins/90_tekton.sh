#!/usr/bin/env bash
# shellcheck disable=1090

NAME="Tekton"
VERSION="${BOOTSTRAP_TEKTON_VERSION:-"0.30.1"}"

enabled() {
  return $(is_true "${BOOTSTRAP_TEKTON_ENABLED:-"true"}")
}

run() {
  source <(tkn completion bash)
}

install() {
  local _tekton_tar="$(bootstrap_fetch "https://github.com/tektoncd/cli/releases/download/v${VERSION}/tkn_${VERSION^}_${OS}_${ARCH}.tar.gz")"
  local _tekton_tmp="$(mktemp -d)"

  bootstrap_unpack "$_tekton_tar" "$_tekton_tmp"
  bootstrap_local_install "${_tekton_tmp}/tkn"
}
