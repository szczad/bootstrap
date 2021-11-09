#!/usr/bin/env bash

cp -f sources.list.d/* /etc/apt/sources.list.d/

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  direnv \
  flatpak \
  htop \
  network-manager-openvpn-gnome \
  openvpn \
  tmux \
  vim-gtk
  
