#!/usr/bin/env bash

NAME="NeoVim"

install() {
  snap install --classic nvim
}

run() {
  export EDITOR='nvim'
  alias vim='nvim'
}
