#!/usr/bin/env bash

NAME="packer"

enabled() {
  return $(is_true "${BOOTSTRAP_PACKER_ENABLED:-"true"}")
}

install() {
  curl --silent --fail --location https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
  bootstrap_apt_update
  bootstrap_apt_install packer
}
