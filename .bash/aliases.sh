# General
alias .reload='direnv reload'

# Git aliases (extends what BASH-IT provides)
alias gcah="git commit --amend -C HEAD"
alias gpos='git push -u origin "$(git rev-parse --abbrev-ref HEAD)"'
