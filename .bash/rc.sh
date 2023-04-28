# shellcheck disable=1090
complete -r
: "${BOOTSTRAP_DIR:="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"}"

if [[ ! -d "$BOOTSTRAP_DIR" ]]; then
  printf "\"\$BOOTSTRAP_DIR\" is unset!\n" >&2
  return
fi

mkdir -p "${BOOTSTRAP_DIR}/var/installed"

CACHE_FILE="${HOME}/.cache/bash/startup.bash"

source "${BOOTSTRAP_DIR}/lib.sh"
case "$1" in
  install)
    for _plugin in "${BOOTSTRAP_DIR}/plugins"/*; do
      NAME="${_plugin:3}"
      VERSION="latest"
      enabled() { return 0; }

      source "$_plugin"
      if enabled && declare -F install >/dev/null; then
        if ! bootstrap_is_installed "$NAME" "${VERSION:-"latest"}"; then
          bootstrap_log_debug "Installing plugin: $NAME"
          if install; then
            bootstrap_register_installation "$NAME" "${VERSION:-"latest"}"
            bootstrap_log_debug "Plugin installed!"
          else
            bootstrap_log_error "Plugin installation failed!"
          fi
        else
          bootstrap_log_debug "Plugin already installed: $NAME. Skipping."
        fi
      fi
      unset NAME VERSION HASH enabled install run
    done
    ;;
  cache)
    bootstrap_log_info "Cleaning up the cache..."
    mkdir -p "$(dirname "$CACHE_FILE")"
    : > "$CACHE_FILE"

    bootstrap_log_info "Recreating cache..."
    printf 'start="$(date \"+%%s.%%N\")"\n' >> "$CACHE_FILE"
    printf 'BOOTSTRAP_DIR="%s"\n' "$BOOTSTRAP_DIR" >> "$CACHE_FILE"
    printf 'source "${BOOTSTRAP_DIR}/lib.sh"\n' >> "$CACHE_FILE"
    for _plugin in "${BOOTSTRAP_DIR}/plugins"/*; do
      NAME="${_plugin:3}"
      VERSION="latest"
      enabled() { return 0; }

      source "$_plugin"
      if enabled && declare -F run >/dev/null; then
        bootstrap_log_debug "Caching plugin: $NAME"
        printf '\n# START Plugin: %s\n' "$_plugin" >> "$CACHE_FILE"
        # printf 'bootstrap_log_debug "%s"\n' "Running plugin: $NAME" >> "$CACHE_FILE"
        declare -f "run" | tail -n +3 | head -n -1 >> "$CACHE_FILE"
        printf '# END Plugin: %s\n' "$_plugin">> "$CACHE_FILE"
      fi
      unset NAME VERSION HASH enabled install run
    done
    printf 'bootstrap_log_debug "Finished (time: $(LC_ALL=C printf "%%.3fs" "0$(echo "$(date \"+%%s.%%N\")" - "$start" | bc)"))"\n' >> "$CACHE_FILE"
    ;;
  run)
    for _plugin in "${BOOTSTRAP_DIR}/plugins"/*; do
      NAME="${_plugin:3}"
      VERSION="latest"
      enabled() { return 0; }

      source "$_plugin"
      if enabled && declare -F run >/dev/null; then
        start="$(date '+%s.%N')"
        bootstrap_log_debug "Running plugin: $NAME"
        run
        bootstrap_log_debug "Finished plugin: $NAME (time: $(LC_ALL=C printf "%.3fs" "0$(echo "$(date '+%s.%N')" - "$start" | bc)"))"
      fi
      unset NAME VERSION HASH enabled install run
    done
    ;;
  load)
    if [[ ! -e "$CACHE_FILE" ]]; then
      "${BOOTSTRAP_DIR}/rc.sh" cache
    fi

    source "$CACHE_FILE"
    ;;
  *)
    bootstrap_log_error "Invalid command provided!"
    ;;
esac

# Cannot register this as a trap hook. We're inside the shell after this
# script finishes.
bootstrap_cleanup

# vim: filetype=sh
