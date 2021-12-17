# shellcheck disable=1090

source "$HOME/.bash/lib.sh"

add_path "$HOME/bin"
add_path "$HOME/.local/bin"

for plugin in plugins/*; do
  source "$plugin"
done

# vim: filetype=sh
