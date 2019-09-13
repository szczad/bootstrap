#!/usr/bin/env bash

info "Installing essential tools"
package_install \
  mc \
  htop \
  firefox \
  keepassxc \
  powertop

success "Base installation done!"

