#!/usr/bin/env bash
# shellcheck disable=1090

NAME="direnv"

enabled() {
  return $(is_true "${BOOTSTRAP_DIRENV_ENABLED:-"true"}")
}

install() {
  curl -sfL https://direnv.net/install.sh | bin_path="$HOME/.local/bin" bash
}

run() {
  _direnv_hook() {
    local previous_exit_status=$?;
    trap -- '' SIGINT;
    eval "$("$(which direnv)" export bash)";
    trap - SIGINT;
    return $previous_exit_status;
  };

  if ! [[ "${PROMPT_COMMAND:-}" =~ _direnv_hook ]]; then
    PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
  fi

  alias .reload='direnv reload'
}
