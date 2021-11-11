#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
  printf 'Usage: %s <list.pkg>\n' "$0"
  exit 1
fi

printf 'Starting flatpak packages installation...\n' >&2
while read -r repo pkg; do
  if [[ ${repo:0:1} = "#" ]] || { [[ $repo = "" ]] && [[ $pkg = "" ]]; }; then
    continue
  fi
  if [[ $pkg = "" ]] && [[ $repo != "" ]]; then
    printf 'Warning: package %s does not have repository assigned! using "flathub"\n' "$repo" >&2
    pkg="$repo"
    repo="flathub"
  fi
  flatpak install --noninteractive --or-update "$repo" "$pkg"
done <"$1"
printf 'Finished flatpak packags installation!\n' >&2
