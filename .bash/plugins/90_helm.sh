#!/usr/bin/env bash

NAME="Helm"
VERSION="${BOOTSTRAP_HELM_VERSION:-"3.10.0"}"

install() {
  local _helm_tar="$(bootstrap_fetch "https://get.helm.sh/helm-v${VERSION}-${OS}-${ARCHN}.tar.gz")"
  local _tmpdir="$(mktemp -d)"

  bootstrap_unpack -s "$_helm_tar" "$_tmpdir"
  bootstrap_local_install "${_tmpdir}/helm"
  rm -rf "$_tmpdir"
}

run() {
  # shellcheck disable=SC1090
  source <(helm completion bash)
}
