# shellcheck disable=1090

NAME="rust"

enabled() {
  return $(is_true "${BOOTSTRAP_RUST_ENABLED:-"true"}")
}

install() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --profile default -y
}

run() {
  bootstrap_append_path -d "$HOME/.cargo/bin"

  source <(rustup completions bash rustup)
  source <(rustup completions bash cargo)
}
