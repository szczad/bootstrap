#!/usr/bin/env bash

NAME="GRP Curl"

enabled() {
  return $(is_true "${BOOTSTRAP_GRPCURL_ENABLED:-"true"}")
}

install() {
  go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
}
