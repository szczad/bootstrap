#!/usr/bin/env bash

info "Installing essential tools"

dnf_install \
  mc \
  htop \
  firefox \
  keepassxc \
  powertop

apt_install \
  mc \
  htop \
  firefox \
  keepassxc \
  powertop 

mac_port_install \
  mc \
  htop

mac_brew_install \
  mc \
  htop 

success "Base installation done!"

