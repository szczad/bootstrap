#!/usr/bin/env bash

info "Installing Gnome"
LC_ALL=C LANG=C sudo dnf install -y "@GNOME Desktop Environment"

success "Gnome installation done!"

