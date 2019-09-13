#!/usr/bin/env bash

info "Installing Flatpak"
package_install flatpak

info "Adding Flathub Flatpak repository"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

success "Flatpak installed and configured!"

