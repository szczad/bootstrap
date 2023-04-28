#!/usr/bin/env bash

NAME="dive"
VERSION="${BOOSTRAP_DIVE_VERSION:="0.10.0"}"

enabled() {
  return $(is_true "${ENABLED:-"true"}")
}

install() {
  _dive_tar="$(bootstrap_fetch "https://github.com/wagoodman/dive/releases/download/v${VERSION}/dive_${VERSION}_${OS}_${ARCHN}.tar.gz")"
  _dive_tmp="$(mktemp -d)"
  bootstrap_unpack "$_dive_tar" "$_dive_tmp"
  bootstrap_local_install "${_dive_tmp}/dive"
  rm -rf "$_dive_tmp"
}
