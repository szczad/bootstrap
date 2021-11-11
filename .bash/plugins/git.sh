  # Git aliases (extends what BASH-IT provides)
if command_exists git; then
  alias gcah="git commit --amend -C HEAD"
  alias gpos='git push -u origin "$(git rev-parse --abbrev-ref HEAD)"'
fi
