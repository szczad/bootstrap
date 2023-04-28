#!/usr/bin/env bash
# shellcheck disable=1090

NAME="Tanka"
VERSION="${BOOTSTRAP_TANKA_VERSION:-"latest"}"

enabled() {
  if is_true "${BOOTSTRAP_GO_ENABLED:-"true"}" && is_true "${BOOTSTRAP_TANKA_ENABLED:-"true"}"; then
    return 0
  else
    return 1
  fi
}

install() {
  local iVERSION="$VERSION"
  if [[ $iVERSION != "latest" ]] && [[ $iVERSION != v* ]]; then
    iVERSION="v${iVERSION}"
  fi

  go install "github.com/grafana/tanka/cmd/tk@${VERSION}"
}
