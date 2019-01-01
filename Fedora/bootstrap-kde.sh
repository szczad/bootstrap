#!/bin/bash

if [ "$EUID" != "0" ]; then
  exec sudo "$0" "$@"
fi

mkdir -p /tmp/bootstrap /tmp/bootstrap/nobody
chown nobody:nobody /tmp/bootstrap/nobody
cd /tmp/bootstrap

# Packages
dnf upgrade -y
dnf groupinstall -y "$(echo $(dnf grouplist | grep KDE))"
dnf install -y \
  akonadiconsole \
  amarok \
  ansible \
  chromium \
  curl \
  docker \
  flatpak \
  git \
  htop \
  iptraf-ng \
  keepassxc \
  kmail \
  ktp-accounts-kcm \
  ktp-approver \
  ktp-auth-handler \
  ktp-common-internals \
  ktp-contact-list \
  ktp-contact-runner \
  ktp-desktop-applets \
  ktp-filetransfer-handler \
  ktp-kded-integration-module \
  ktp-send-file \
  ktp-text-ui \
  libreoffice \
  libvirt \
  mc \
  network-manager-applet \
  nfs4-acl-tools-gui \
  okular \
  openvpn \
  plasma-drkonqi \
  remmina \
  telepathy-accounts-signon \
  telepathy-farstream \
  telepathy-filesystem \
  telepathy-gabble \
  telepathy-glib \
  telepathy-haze \
  telepathy-logger \
  telepathy-logger-qt \
  telepathy-mission-control \
  telepathy-qt5 \
  telepathy-rakia \
  telepathy-salut \
  tmux \
  vim-enhanced \
  wget \
  wine

dnf debuginfo-install -y kernel xorg-x11-drv-nouveau plasma-drkonqi

# RPM Fusion
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf groupupdate -y core
dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
dnf install -y xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda kmod kmodtool akmods akmod-nvidia vdpauinfo libva-vdpau-driver libva-utils vulkan 
dnf update -y
(cd /tmp/bootstrap/nobody; sudo -u nobody akmodsbuild /usr/src/akmods/nvidia-kmod.latest)

# Sysctl
cat > /etc/sysctl.d/50-custom.conf <<'EOF'
vm.swappiness = 5
EOF

# TMux
curl -L 'https://gist.githubusercontent.com/szczad/422d9a3e045d4feb85b556b8e1d1a344/raw/32078c1b50519e993ca0d78714a3dcedd40b77b2/tmux.conf' -o /etc/tmux.conf

# VIM
mkdir -p /etc/vim
curl 'https://gist.githubusercontent.com/szczad/cea668108f4dbcb5d76c9d8f0093923d/raw/c98be5b9b71bdb952138256b8ec0415802365ea8/vimrc.local' -o /etc/vim/vimrc.local

# SSH
systemctl enable sshd.socket
systemctl start sshd.socket

# Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub \
  com.spotify.Client \
  io.dbeaver.DBeaverCommunity \
  com.visualstudio.code \
  com.github.wwmm.pulseeffects

