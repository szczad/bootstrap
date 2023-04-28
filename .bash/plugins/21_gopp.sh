#!/usr/bin/env bash
# shellcheck disable=1090

NAME="pp"

enabled() {
  return $(is_true "${BOOTSTRAP_GO_ENABLED:-"true"}")
}

install() {
  go install github.com/maruel/panicparse/v2/cmd/pp@latest
}

