#!/usr/bin/env bash

info "Installing tmux"

apt_install tmux
dnf_install tmux
mac_port_install tmux
mac_brew_install tmux

TMUX_GLOBAL="${TMUX_GLOBAL:-1}"

if is_true "$TMUX_GLOBAL"; then
  TMUX_CONF_DIR="/etc/tmux/"
  TMUX_CONF_FILE="/etc/tmux.conf"
else
  TMUX_CONF_DIR="$HOME/.tmux/"
  TMUX_CONF_FILE="$HOME/.tmux.conf"
fi 

# Perparing permissions on directories
info "Copying files"
make_dir "$TMUX_CONF_DIR"
copy "files/tmux/etc" "$TMUX_CONF_DIR"
copy "files/tmux/tmux.conf" "$TMUX_CONF_FILE"

if is_true "$TMUX_GLOBAL"; then
  info "Adjusting permissions"
  sudo chown -R $(get_root_owner) "$TMUX_CONF_DIR"

  # Restoring SELinux labels/contextes
  if is_linux; then
    info "Restoring contexts" 
    sudo restorecon /etc/tmux*
  fi
fi

success "TMux installation done!"

