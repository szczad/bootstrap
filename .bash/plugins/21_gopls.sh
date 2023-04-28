#!/usr/bin/env bash

NAME="gopls"

enabled() {
  return $(is_true "${BOOTSTRAP_GO_ENABLED:-"true"}")
}

install() {
  go install golang.org/x/tools/gopls@latest
}
