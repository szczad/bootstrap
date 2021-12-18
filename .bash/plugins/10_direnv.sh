#!/usr/bin/env bash
# shellcheck disable=1090

if command -v direnv >/dev/null; then
  log_debug "Setting DIRENV hook"

  _direnv_hook() {
    local previous_exit_status=$?;
    trap -- '' SIGINT;
    eval "$("/usr/bin/direnv" export bash)";
    trap - SIGINT;
    return $previous_exit_status;
  };
  if ! [[ "${PROMPT_COMMAND:-}" =~ _direnv_hook ]]; then
    PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
  fi
  alias .reload='direnv reload'
fi

