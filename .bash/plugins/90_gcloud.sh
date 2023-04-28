#!/usr/bin/env bash

NAME="gcloud"

install() {
  sudo bash -c 'echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list'
  curl --location --fail --silent https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
  bootstrap_apt_update
  bootstrap_apt_install google-cloud-cli
}
