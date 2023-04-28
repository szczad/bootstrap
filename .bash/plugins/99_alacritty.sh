#!/usr/bin/env bash
# shellcheck disable=1090

NAME="alacritty"

enabled() {
  return $(is_true "${BOOTSTRAP_ALACRITTY_ENABLE:-"true"}")
}

install() {
  local _al_tmp="$(mktemp -d)"
  bootstrap_clone "https://github.com/alacritty/alacritty.git" "master" "$_al_tmp"
  (
    cd "$_al_tmp" || return
    bootstrap_apt_install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
    cargo build --release
    cp target/release/alacritty "$HOME/.local/bin/"
    mkdir -p "$HOME/.local/share/icons" "$HOME/.local/share/applications"
    cp extra/logo/alacritty-term.svg "$HOME/.local/share/icons/Alacritty.svg"
    cp extra/linux/Alacritty.desktop "$HOME/.local/share/applications"
    update-desktop-database -q || true
  )
  rm -rf "$_al_tmp"
}

