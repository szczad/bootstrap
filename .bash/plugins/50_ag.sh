#!/usr/bin/env bash

NAME=ag

enabled() {
  return $(is_true "${BOOTSTRAP_AG_ENABLED:-"true"}")
}

install() {
  bootstrap_apt_install silversearcher-ag
}
