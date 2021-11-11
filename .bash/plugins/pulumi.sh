# shellcheck disable=1090
if command -v pulumi >/dev/null; then
  add_path "$HOME/.pulumi/bin"
fi

