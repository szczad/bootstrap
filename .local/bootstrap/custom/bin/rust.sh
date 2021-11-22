#!/usr/bin/env bash
# shellcheck disable=1091

set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

printf 'Installing RUST...\n'
tmp="$(mktemp)"
code=0
if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o "$tmp" && bash "$tmp" -y; then
  printf 'Installation successful!\n'
else
  printf 'Installation failed!\n'
  code=1
fi

rm -f "$tmp"
return $code
