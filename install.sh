#!/usr/bin/env

# Checking for proper environment
if [ "${BOOTSTRAP_SOURCED:-_NOT_SET_}" == "_NOT_SET_" ]; then
  echo "Please source \"install.vars\" before running this script" >&2
  exit 1
fi

# Be more strict about errors
set -euo pipefail

# Installing basic tool set
LC_ALL=C LANG=C dnf install -y \
  vim-enhanced \
  tmux \
  clang \
  cmake \
  git \
  mc \
  qt-creator \
  firefox-wayland

# Patching desktop 
if [ "$DESKTOP_ENV" = "gnome" ]; then
  dnf install -y "@GNOME Desktop Environment"
elif [ "$DESKTOP_ENV" = "kde" ]; then
  dnf install -y "@KDE Plasma Workspaces"
fi

# Perparing permissions on directories
sudo chown root:root root -R
sudo chown $USER:users user -R

# Copy files with enhanced globbing
DOTGLOB_DISABLE=`shopt -p dotglob`
shopt -s dotglob
cp -av root/* /
cp -av user/* /home/$USER/
$DOTGLOB_DISABLE

# Restoring SELinux labels/contextes
restorecon -R /

