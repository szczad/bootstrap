#!/usr/bin/env bash
# shellcheck disable=1090

NAME="kubectl"

enabled() {
  return  $(is_true "${BOOTSTRAP_KUBERNETES_ENABLED:-"true"}")
}

install() {
  sudo bash -c 'echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
  sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  bootstrap_apt_update
  bootstrap_apt_install kubectl
}

run() {
  source <(kubectl completion bash)
}

