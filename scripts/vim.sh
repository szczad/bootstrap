#!/usr/bin

VIM_GLOBAL="${VIM_GLOBAL:-1}"
if is_mac; then
  VIM_GLOBAL=0
fi

# Additional variables
is_true "$VIM_GLOBAL" && VIM_DIR="${VIM_DIR:-/etc/vim}" || VIM_DIR="${VIM_DIR:-$HOME/.vim/}"

info "Installing VIM"
dnf_install vim-enhanced
apt_install vim-enhanced
mac_port_install vim +python37
mac_brew_install vim

if [ ! -e "$VIM_DIR/autoload/plug.vim" ]; then
  info "Adding Vim-Plug"
  conditional_sudo "$VIM_GLOBAL" curl -fLo "$VIM_DIR/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

info "Copying files"
copy_dir "files/vim/root" "$VIM_DIR"

if is_true "$VIM_GLOBAL"; then
  info "Adjusting permissions"
  sudo chown -R root:root /etc/vim*

  if ! file_contains "/etc/vimrc" "files/vim/vimrc.incl"; then
    info "Patching master config file /etc/vimrc"
    patch_file "files/vim/vimrc.incl" "/etc/vimrc"
  fi
fi

info "Installing VIM plugins"
if is_true "$VIM_GLOBAL"; then
  echo | echo | sudo vim +PlugInstall +qall

  # Restoring SELinux labels/contextes
  if is_linux; then
    info "Restoring contexts" 
    sudo restorecon -R /etc/vim*
  fi
else
  echo | echo | vim +PlugInstall +qall
fi

success "All done!"

