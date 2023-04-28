#!/usr/bin/env bash
# shellcheck disable=1091

NAME="sdkman"

enabled() {
  return $(is_true "${BOOTSTRAP_SDKMAN_ENABLED:-"true"}")
}

install() {
  curl --fail --location --silent "https://get.sdkman.io?rcupdate=false" | SDKMAN_DIR="${SDKMAN_DIR:-"$HOME/.sdkman"}" bash
}

run() {
  export SDKMAN_DIR="${SDKMAN_DIR:-"$HOME/.sdkman"}"
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
}
