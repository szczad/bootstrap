#!/usr/bin/bash

dnf upgrade -y
dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
dnf groupupdate -y core
dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
dnf debuginfo-install -y kernel xorg-x11-drv-nouveau plasma-drkonqi

dnf install -y \
  curl \
  flatpak \
  git \
  htop \
  iptraf-ng \
  openvpn \
  tmux \
  vim-enhanced \
  wget

# SSH
systemctl enable sshd.socket
systemctl start sshd.socket

