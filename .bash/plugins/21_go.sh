#!/usr/bin/env bash
# shellcheck disable=1090

NAME="go"
VERSION="${GOVERSION:-"1.19.1"}"
HASH="${GOHASH:-"sha256:acc512fbab4f716a8f97a8b3fbaa9ddd39606a28be6c2515ef7c6c6311acffde"}"

enabled() {
  return $(is_true "${BOOTSTRAP_GO_ENABLED:-"true"}")
}

install() {
  export GOROOT="${GOROOT:-"$HOME/.local/go"}"
  export GOPATH="${GOPATH:-"$HOME/.cache/go"}"
  export GOBIN="${GOBIN:-"$HOME/.local/bin"}"

  bootstrap_log_debug "Fetching package..."
  _go_tar="$(bootstrap_fetch "https://go.dev/dl/go${VERSION}.${OS}-${ARCHN}.tar.gz" "$HASH")"

  bootstrap_log_debug "Unpacking..."
  mkdir -p "$GOROOT"
  bootstrap_unpack -s "$_go_tar" "$GOROOT"

  bootstrap_log_debug "Removing leftovers..."
  rm -f "$_go_tar"
}

run() {
  export GOROOT="${GOROOT:-"$HOME/.local/go"}"
  export GOPATH="${GOPATH:-"$HOME/.cache/go"}"
  export GOBIN="${GOBIN:-"$HOME/.local/bin"}"

  bootstrap_append_path -d "$GOROOT/bin"
}
