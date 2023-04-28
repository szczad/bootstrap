#!/usr/bin/env bash
# shellcheck disable=1090

NAME="terragrunt"
VERSION="${BOOTSTRAP_TERRAGRUNT_VERSION:-"0.45.4"}"

install() {
  local _terragrunt_file="$(bootstrap_fetch "https://github.com/gruntwork-io/terragrunt/releases/download/v${VERSION}/terragrunt_${OS}_${ARCHN}")"
  bootstrap_local_install "$_terragrunt_file" "terragrunt"
  rm -f "$_terragrunt_file"
  unset _terragrunt_file
}

