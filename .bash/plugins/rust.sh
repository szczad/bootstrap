# shellcheck disable=1090
if command -v rustup; then
  add_path "$HOME/.cargo/bin"

  source <(rustup completions bash rustup)
  source <(rustup completions bash cargo)
fi
