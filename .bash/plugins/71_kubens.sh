#!/usr/bin/env bash
# shellcheck disable=1090

NAME="kubens"

enabled() {
  return  $(is_true "${BOOTSTRAP_KUBERNETES_ENABLED:-"true"}")
}

install() {
  _kubens_file="$(bootstrap_fetch "https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens")"
  bootstrap_local_install "$_kubens_file"
  unset _kubens_file
}

