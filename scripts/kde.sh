#!/usr/bin/env bash

info "Installing KDE"
LC_ALL=C LANG=C sudo dnf install -y "@KDE Plasma Workspaces"

success "KDE installation done!"

