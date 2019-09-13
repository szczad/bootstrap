#!/usr/bin/env bash

info "Installing tmux"
LC_ALL=C LANG=C sudo dnf install -y tmux

# Perparing permissions on directories
info "Adjusting permissions"
copy_dir "files/tmux/root" "/"
sudo chown root:root /etc/tmux*

# Restoring SELinux labels/contextes
info "Restoring contexts" 
sudo restorecon /etc/tmux*

success "TMux installation done!"

