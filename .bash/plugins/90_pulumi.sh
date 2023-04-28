#!/usr/bin/env bash

NAME="pulumi"

install() {
  curl -fsSL https://get.pulumi.com | sh
}

run() {
  bootstrap_append_path "$HOME/.pulumi/bin"
}

