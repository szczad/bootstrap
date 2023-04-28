#!/usr/bin/env bash

NAME="GitHub"
VERSION="${BOOTSTRAP_GH_VERSION:-"2.27.0"}"

install() {
  _app_tar="$(bootstrap_fetch "https://github.com/cli/cli/releases/download/v${BOOTSTRAP_GH_VERSION}/gh_${BOOTSTRAP_GH_VERSION}_${OS}_${ARCHN}.tar.gz")"
  _app_tmp="$(mktemp -d)"
  bootstrap_unpack -s "$_app_tar" "$_app_tmp"
  bootstrap_local_install "${_app_tmp}/bin/gh"
  rm -rf "$_app_tmp"
}

run() {
  alias gh-pr='gh pr create -a @mc -f -w'

  source <(gh completion -s bash)
}
