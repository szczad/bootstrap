# shellcheck disable=1090
if command_exists go; then
  log_debug "Exporting Go environment"
  export GOROOT="$HOME/.local/go"
  export GOPATH="$HOME/.cache/go"
  export GOBIN="$HOME/.local/bin"

  add_path "$GOROOT/bin"
fi
