#!/usr/bin/env bash
# shellcheck disable=1090

NAME="goreleaser"

enabled() {
  return $(is_true "${BOOTSTRAP_GO_ENABLED:-"true"}")
}

install() {
  go install github.com/goreleaser/goreleaser@latest
}

