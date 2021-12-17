# shellcheck disable=1090

source "$HOME/.bash/lib.sh"

add_path "$HOME/bin"
add_path "$HOME/.local/bin"

for plugin in "$HOME/.bash/plugins"/*; do
  log_debug "Running plugin $plugin"
  source "$plugin"
done

# vim: filetype=sh
