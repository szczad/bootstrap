#!/usr/bin/env bash
# shellcheck disable=1090

NAME="terraform"
VERSION="${BOOTSTRAP_TERRAFORM_VERSION:-"1.4.5"}"

install() {
  local _terraform_tar="$(bootstrap_fetch "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_${OS}_${ARCHN}.zip")"
  local _tmp_dir="$(mktemp -d)"
  bootstrap_unpack "$_terraform_tar" "$_tmp_dir"
  bootstrap_local_install "${_tmp_dir}/terraform"
  rm -rf "$_terraform_tar" "$_tmp_dir"
}

