#!/usr/bin/env bash

if [ ! -e "$HOME/.bash_it" ]; then
  info "Cloning BASH IT to the user directory..."
  git clone --depth=1 https://github.com/Bash-it/bash-it.git "$HOME/.bash_it"
  ~/.bash_it/install.sh --silent
else
  info "BASH IT already cloned!"
fi

info "Patching .bashrc file"
sed -i -e 's/^export BASH_IT_THEME=.*/export BASH_IT_THEME="powerline"/g' ~/.bashrc

success "BASH IT installation complete!"

