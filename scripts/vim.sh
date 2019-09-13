#!/bin/bash -x

# Additional variables
VIM_DIR="${VIM_DIR:-/etc/vim}"
BUNDLE_DIR="${VIM_BUNDLE_DIR:-$VIM_DIR/bundle}"

info "Installing VIM"
package_install vim-enhanced

info "Adding bundles"
if [ ! -d "$BUNDLE_DIR" ]; then
  sudo mkdir -p /etc/vim/bundle
fi

if [ ! -e "$BUNDLE_DIR/Vundle.vim" ]; then
  sudo git clone https://github.com/VundleVim/Vundle.vim.git /etc/vim/bundle/Vundle.vim
fi

# Perparing permissions on directories
info "Adjusting permissions"
copy_dir "vim/root" "/"
sudo chown -R root:root /etc/vim*

info "Patching files"
if ! file_contains "/etc/vimrc" "vim/vimrc.incl"; then
  log "Patching file /etc/vimrc"
  sudo bash -c 'cat vim/vimrc.incl >> /etc/vimrc'
fi

info "Installing VIM plugins"
echo | echo | sudo vim +PluginInstall +qall

# Restoring SELinux labels/contextes
info "Restoring contexts" 
sudo restorecon -R /etc/vim*

success "All done!"
