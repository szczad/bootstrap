#!/usr/bin/env bash
# shellcheck disable=1090

NAME="kubectx"

enabled() {
  return  $(is_true "${BOOTSTRAP_KUBERNETES_ENABLED:-"true"}")
}

install() {
  _kubectx_file="$(bootstrap_fetch "https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx")"
  bootstrap_local_install "$_kubectx_file" "kubectx"
  rm -f "$_kubectx_file"
  unset _kubectx_file
}

