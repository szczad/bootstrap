# shellcheck disable=1090
 
if command_exists rustup; then
  log_debug "Add Rust/Cargo to PATH and load completions"

  append_path "$HOME/.cargo/bin"

  source <(rustup completions bash rustup)
  source <(rustup completions bash cargo)
fi
