# shellcheck disable=1090

if [[ ! -d "$BOOTSTRAP_DIR" ]]; then
  printf "\"\$BOOTSTRAP_DIR\" is unset!\n" >&2
  return
fi

source "$HOME/.bash/lib.sh"

for plugin in "$HOME/.bash/plugins"/*; do
  log_debug "Running plugin: $plugin"
  source "$plugin"
done

# vim: filetype=sh
