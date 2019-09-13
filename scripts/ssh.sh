#!/usr/bin/env bash

info "Installing SSH"
package_install openssh

: ${SSH_KEY_LOCATION:=$HOME/.ssh}
: ${SSH_KEY_TYPE:=ed25519}
: ${SSH_KEYS:=id_ed25519}
: ${SSHD_ENABLED:=yes}

mkdir -p -m 700 "$SSH_KEY_LOCATION"
for KEY in "${SSH_KEYS[@]}"; do
  if [ -e "$SSH_KEY_LOCATION/$KEY" ]; then
    info "Key \"$KEY\" already in place. Skipping..."
  else
    info "Generating key for \"$KEY\"..."
    ssh-keygen -t "$SSH_KEY_TYPE" -N '' -f "$SSH_KEY_LOCATION/$KEY"
  fi
done

unset KEY

if yes_no_check "$SSHD_ENABLED"; then
  info "Enabling OpenSSH server"
  systemctl enable --now sshd
else
  info "Disabling OpenSSH server"
  systemctl disable --now sshd
fi

success "SSH Installed and configured properly."

