#!/usr/bin/env bash
# shellcheck disable=SC1090

NAME="completions"

run() {
  for _file in "${HOME}/.local/share/bash-completions"/*; do
    source "$_file"
  done
}
