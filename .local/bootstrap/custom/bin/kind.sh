#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

if ! command -v "go" >/dev/null; then
  "${SCRIPT_DIR}/go.sh"
  source "$SCRIPT_DIR/../../../../.bash/lib.sh"
fi

go get sigs.k8s.io/kind
