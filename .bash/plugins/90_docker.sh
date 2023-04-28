#!/usr/bin/env bash

NAME="docker"

enabled() {
  return $(is_true "${BOOTSTRAP_DOCKER_ENABLED:-"true"}")
}

install() {
  # SRC: https://docs.docker.com/engine/install/ubuntu/
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  bootstrap_apt_update
  bootstrap_apt_install docker-ce docker-ce-cli containerd.io docker-compose-plugin

  sudo gpasswd -a "$(id -un)" docker
}

