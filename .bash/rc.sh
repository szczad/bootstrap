# shellcheck disable=1090
add_path() {
  local _path="$1"

  if [[ -d $_path ]] && [[ $PATH != *"$_path"* ]]; then
    PATH="${PATH}:$_path"
  fi
}

add_path "$HOME/bin"
add_path "$HOME/.local/bin"

source aliases.sh
source functions.sh

for plugin in plugins/*; do
  source "$plugin"
done

# vim: filetype=sh
