#!/usr/bin/env bash
# shellcheck disable=1090

NAME="node"
VERSION="${BOOTSTRAP_NODEJS_VERSION:-"18.9.0"}"
HASH="${BOOTSTRAP_NODEJS_HASH:-"7fdbfdb985a48db3d22a2472330db05d94c9aff59192b09d8f9ab5fcedba76d5"}"


install() {
  export NODE_PATH="${NODE_PATH:-"$HOME/.local/node"}"

  case "$ARCHN" in
    amd64)
      NODE_ARCH="x64"
      ;;
    *)
      NODE_ARCH="$ARCHN"
  esac

  local _node_package="$(bootstrap_fetch "https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-${OS}-${NODE_ARCH}.tar.gz" "sha256:${HASH}")"
  bootstrap_unpack -s "$_node_package" "$NODE_PATH"

  rm -f "$_npm_package"

  mkdir -p "$NODE_PATH/bin" "$HOME/.local/npm/bin"
}

run() {
  export NODE_PATH="${NODE_PATH:-"$HOME/.local/node"}"
  bootstrap_append_path -d "$NODE_PATH/bin"
  bootstrap_append_path -d "$HOME/.local/npm/bin"
}
