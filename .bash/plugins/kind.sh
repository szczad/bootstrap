# shellcheck disable=1090
if command_exists kind; then
  source <(kind completion bash)
fi
