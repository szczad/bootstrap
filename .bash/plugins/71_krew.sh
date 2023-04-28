#!/usr/bin/env bash
# shellcheck disable=1090

NAME="krew"

enabled() {
  return  $(is_true "${BOOTSTRAP_KUBERNETES_ENABLED:-"true"}")
}

install() {
  local _krew_file="$(bootstrap_fetch "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-${OS}_${ARCHN}.tar.gz")"
  local _tmp="$(mktemp -d)"
  tar -xzf "$_krew_file" -C "$_tmp"
  "$_tmp/krew-${OS}_${ARCHN}" install krew
  rm -rf "$_krew_file" "$_tmp"
}

run() {
  bootstrap_append_path "${HOME}/.krew/bin"
}

