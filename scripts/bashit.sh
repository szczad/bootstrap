#!/usr/bin/env bash

if [ "$BASHIT_GLOBAL" ]; then
  BASHIT_LOCATION="/opt/bash_it"
else
  BASHIT_LOCATION="$HOME/.bash_it"
fi

if [ ! -e "$BASHIT_LOCATION" ]; then
  info "Cloning BASH IT to the user directory..."
  git clone --depth=1 https://github.com/Bash-it/bash-it.git "$BASHIT_LOCATION"
  "$BASHIT_LOCATION/install.sh" --silent
else
  info "BASH IT already cloned!"
fi

info "Patching .bashrc file"
sed -i -e 's/^export BASH_IT_THEME=.*/export BASH_IT_THEME="powerline"/g' ~/.bashrc

success "BASH IT installation complete!"

