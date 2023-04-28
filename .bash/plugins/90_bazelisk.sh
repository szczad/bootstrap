#!/usr/bin/env bash
# shellcheck disable=2139

NAME="bazelisk"
VERSION="${BOOTSTRAP_BAZELISK_VERSION:="1.14.0"}"

install() {
  _bazelisk_bin="$(bootstrap_fetch "https://github.com/bazelbuild/bazelisk/releases/download/v${BOOTSTRAP_BAZELISK_VERSION}/bazelisk-${OS}-${ARCHN}")"
  bootstrap_local_install "$_bazelisk_bin"
  rm -f "$_bazelisk_bin"

  ln -f -s "${HOME}/.local/bin/bazelisk-${OS}-${ARCHN}" "${HOME}/.local/bin/bazelisk"
  ln -f -s "${HOME}/.local/bin/bazelisk-${OS}-${ARCHN}" "${HOME}/.local/bin/bazel"
}
