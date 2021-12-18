#!/usr/bin/env bash
# shellcheck disable=1090

_paths=("$HOME/bin" "$HOME/.local/bin")

for _path in "${_paths[@]}"; do
  if [[ -d "$_path" ]]; then
    append_path "$_path"
  fi
done

