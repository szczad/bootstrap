#!/usr/bin/env bash

NAME="virtualbox"

enabled() {
  return $(is_true "${BOOTSTRAP_VIRTUALBOX_ENABLED:-"true"}")
}

install() {
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian ${DISTRIBUTION} contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list >/dev/null
  curl --silent --location --fail "https://www.virtualbox.org/download/oracle_vbox_2016.asc" | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
  bootstrap_apt_update
  bootstrap_apt_install "virtualbox-6.1"

  if ! groups "$(id -un)" | grep -q "vboxusers"; then
    bootstrap_log_info "Adding user $(id -un) to group vboxusers..."
    sudo gpasswd -a "$(id -un)" vboxusers
  fi
}
