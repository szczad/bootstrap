#!/usr/bin/env bash
# shellcheck disable=1090

NAME="minikube"
VERSION="${BOOTSTRAP_MINIKUBE_VERSION:-"1.30.1"}"

enabled() {
  return  $(is_true "${BOOTSTRAP_KUBERNETES_ENABLED:-"true"}")
}

install() {
  local iVERSION="$VERSION"
  if [[ $iVERSION != "latest" ]] && [[ $iVERSION != v* ]]; then
    iVERSION="v${iVERSION}"
  fi

  _minikube_file="$(bootstrap_fetch "https://storage.googleapis.com/minikube/releases/${iVERSION}/minikube-${OS}-${ARCHN}")"
  bootstrap_local_install "$_minikube_file" "minikube"
  rm -f "$_minikube_file"
  unset _minikube_file
}

run() {
  source <(minikube completion bash)
  alias minikube-docker-env='eval $(minikube docker-env)'
}

