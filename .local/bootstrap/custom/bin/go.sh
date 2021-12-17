#!/usr/bin/env bash
# shellcheck disable=1091

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "${SCRIPT_DIR}/../lib/common.sh"

version="1.17.3"

while getopts ":v:" opt; do
  case "$opt" in
    v)
      version="$OPTARG"
      ;;
    \?)
      printf 'Must provide value for -%s\n' "$OPTARG"
      ;;
    :)
      printf 'Invalid argument: -%s\n' "$OPTARG"
      ;;
  esac
done


os="$(uname -s)"
case "$(uname -m)" in
  i386)
    arch="$(uname -m)"
    ;;
  x86_64)
    arch=amd64
    ;;
  *)
    printf 'Not supported arch!\n'
    exit 1
    ;;
esac
url="https://golang.org/dl/go${version}.${os,,}-${arch}.tar.gz"
dest="${HOME}/.local"

printf 'Installing GO. OS: %s, Arch: %s, Version: %s\n' "${os,,}" "$arch" "$version"
mkdir -p "$dest"
if install_archive "$url" "$dest"; then
  mv "$dest/go/bin"/* "$HOME/.local/bin"
  printf 'Installation successful! You can access Go at %s/go/bin\n' "$dest"
else
  printf 'Installation failed!\n'
  return 1
fi
