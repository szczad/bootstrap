#!/usr/bin/env bash

NAME="pre-commit"

enabled() {
  return $(is_true "${BOOTSTRAP_PRE_COMMIT_ENABLED:-"true"}")
}

install() {
  pip install --user pre-commit --upgrade
}
