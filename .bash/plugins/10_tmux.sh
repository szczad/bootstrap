#!/usr/bin/env bash

NAME="tmux"

enabled() {
  return $(is_true "${BOOTSTRAP_TMUX_ENABLED:-"true"}")
}

install() {
  bootstrap_apt_install tmux
}

run() {
  alias tmux-start='tmux new-session -A -s main'
}
