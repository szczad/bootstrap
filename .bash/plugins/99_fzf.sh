#!/usr/bin/env bash
# shellcheck disable=1090

NAME="fzf"
VERSION="${BOOTSTRAP_FZF_VERSION:="0.33.0"}"

enabled() {
  return $(is_true "${BOOTSTRAP_FZF_ENABLED:-"true"}")
}

install() {
  _fzf_tar="$(bootstrap_fetch "https://github.com/junegunn/fzf/releases/download/${VERSION}/fzf-${VERSION}-${OS}_${ARCHN}.tar.gz")"
  bootstrap_unpack "$_fzf_tar" "${HOME}/.local/bin"
  rm -f "$_fzf_tar"

  _fzf_completion="$(bootstrap_fetch "https://raw.githubusercontent.com/junegunn/fzf/${VERSION}/shell/completion.bash")"
  command install -m 0755 "$_fzf_completion" "$LOCAL_BASH_COMLPETION_DIR/fzf.bash"
}

run() {
  source "$BOOTSTRAP_DIR/share/fzf/key-bindings.bash"
}

