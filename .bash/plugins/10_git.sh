#!/usr/bin/env bash
# shellcheck disable=1090,SC2154

NAME="git"

enabled() {
  return $(is_true "${BOOTSTRAP_GIT_ENABLED:-"true"}")
}

install() {
  bootstrap_apt_install git
}

run() {

  if ! type __git_complete >/dev/null 2>&1; then
    . /usr/share/bash-completion/completions/git
  fi

  # Allow completions
  __git_complete ga _git_add
  __git_complete gb _git_branch
  __git_complete gc _git_checkout
  __git_complete gco _git_checkout
  __git_complete gcp _git_cherry_pick
  __git_complete gd _git_diff
  __git_complete gdc _git_diff
  __git_complete gf _git_fetch
  __git_complete gl _git_pull
  __git_complete gll _git_log
  __git_complete gm _git_merge
  __git_complete gp _git_push
  __git_complete gr _git_remote
  __git_complete grb _git_rebase
  __git_complete grbi _git_rebase
  __git_complete grbc _git_rebase
  __git_complete gs _git_status
  __git_complete gsh _git_show
  __git_complete gst _git_stash
  __git_complete gt _git_tag
  __git_complete gw _git_worktree

  alias g='git'

  # add
  alias ga='git add'
  alias gall='git add -A'
  alias gap='git add -p'
  alias gav='git add -v'

  # branch
  alias gb='git branch'
  alias gba='git branch --all'
  alias gbd='git branch -d'
  alias gbD='git branch -D'
  alias gbl='git branch --list'
  alias gbla='git branch --list --all'
  alias gblr='git branch --list --remotes'
  alias gbm='git branch --move'
  alias gbr='git branch --remotes'
  alias gbt='git branch --track'
  alias gdel='git branch -D'

  # for-each-ref
  alias gbc='git for-each-ref --format="%(authorname) %09 %(if)%(HEAD)%(then)*%(else)%(refname:short)%(end) %09 %(creatordate)" refs/remotes/ --sort=authorname DESC' # FROM https://stackoverflow.com/a/58623139/10362396

  # commit
  alias gc='git commit -v'
  alias gca='git commit -v -a'
  alias gcah='git commit --amend -C HEAD'
  alias gcaa='git commit -a --amend -C HEAD' # Add uncommitted and unstaged changes to the last commit
  alias gcam='git commit -v -am'
  alias gcamd='git commit --amend'
  alias gcm='git commit -v -m'
  alias gci='git commit --interactive'
  alias gcsam='git commit -S -am'

  # checkout
  # alias gcb='git checkout -b'
  alias gco='git checkout'
  alias gcob='git checkout -b'
  # alias gcobu='git checkout -b ${USER}/'
  alias gcom='git checkout $(get_default_branch)'
  # alias gcpd='git checkout $(get_default_branch); git pull; git branch -D'
  alias gct='git checkout --track'

  # clone
  # alias gcl='git clone'

  # clean
  alias gclean='git clean -fd'

  # cherry-pick
  alias gcp='git cherry-pick'
  alias gcpx='git cherry-pick -x'

  # diff
  alias gd='git diff'
  alias gds='git diff --staged'
  alias gdt='git difftool'

  # archive
  # alias gexport='git archive --format zip --output'

  # fetch
  alias gfa='for _dir in *; do echo -e " \e[31m* \e[32mFetching ${_dir}...\e[0m"; cd "$_dir"; git fetch; cd ..; done'
  alias gf='git fetch --all --prune'
  alias gft='git fetch --all --prune --tags'
  alias gftv='git fetch --all --prune --tags --verbose'
  alias gfv='git fetch --all --prune --verbose'
  # alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/$(get_default_branch)'
  alias gup='git fetch && git rebase'

  # log
  alias gg='git log --graph --pretty=format:'\''%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset'\'' --abbrev-commit --date=relative'
  alias ggf='git log --graph --date=short --pretty=format:'\''%C(auto)%h %Cgreen%an%Creset %Cblue%cd%Creset %C(auto)%d %s'\'''
  alias ggs='gg --stat'
  alias ggup='git log --branches --not --remotes --no-walk --decorate --oneline' # FROM https://stackoverflow.com/questions/39220870/in-git-list-names-of-branches-with-unpushed-commits
  alias gll='git log --graph --pretty=oneline --abbrev-commit'
  alias gnew='git log HEAD@{1}..HEAD@{0}' # Show commits since last pull, see http://blogs.atlassian.com/2014/10/advanced-git-aliases/
  alias gwc='git whatchanged'

  # ls-files
  alias gu='git ls-files . --exclude-standard --others' # Show untracked files
  alias glsut='gu'
  alias glsum='git diff --name-only --diff-filter=U' # Show unmerged (conflicted) files

  # gui
  # alias ggui='git gui'

  # home
  alias ghm='cd "$(git rev-parse --show-toplevel)"' # Git home

  # merge
  alias gm='git merge'

  # mv
  alias gmv='git mv'

  # patch
  alias gpatch='git format-patch -1'

  # push
  alias gp='git push'
  alias gpd='git push --delete'
  alias gpf='git push --force'
  alias gpo='git push origin HEAD'
  alias gpom='git push origin $(get_default_branch)'
  alias gpu='git push --set-upstream'
  alias gpunch='git push --force-with-lease'
  alias gpuo='git push --set-upstream origin'
  alias gpuoc='git push --set-upstream origin $(git symbolic-ref --short HEAD)'

  # pull
  alias gl='git pull'
  alias glum='git pull upstream $(get_default_branch)'
  alias gpl='git pull'
  alias gpp='git pull && git push'
  alias gpr='git pull --rebase'

  # remote
  alias gr='git remote'
  alias gra='git remote add'
  alias grv='git remote -v'

  # rm
  alias grm='git rm'

  # rebase
  alias grb='git rebase'
  alias grbc='git rebase --continue'
  alias grbi='git rebase --interactive'
  alias grbm='git rebase $(get_default_branch)'
  alias grbmi='git rebase $(get_default_branch) -i'
  alias grbma='GIT_SEQUENCE_EDITOR=: git rebase  $(get_default_branch) -i --autosquash'
  alias gprom='git fetch origin $(get_default_branch) && git rebase origin/$(get_default_branch) && git update-ref refs/heads/$(get_default_branch) origin/$(get_default_branch)' # Rebase with latest remote

  # reset
  alias gus='git reset HEAD'
  alias gpristine='git reset --hard && git clean -dfx'

  # status
  alias gs='git status'
  alias gss='git status -s'

  # shortlog
  alias gcount='git shortlog -sn'
  alias gsl='git shortlog -sn'

  # show
  alias gsh='git show'

  # svn
  # alias gsd='git svn dcommit'
  # alias gsr='git svn rebase' # Git SVN

  # stash
  alias gst='git stash'
  alias gstb='git stash branch'
  alias gstd='git stash drop'
  alias gstl='git stash list'
  alias gstp='git stash pop'  # kept due to long-standing usage
  alias gstpo='git stash pop' # recommended for it's symmetry with gstpu (push)

  ## 'stash push' introduced in git v2.13.2
  alias gstpu='git stash push'
  alias gstpum='git stash push -m'

  ## 'stash save' deprecated since git v2.16.0, alias is now push
  alias gsts='git stash push'
  alias gstsm='git stash push -m'

  # submodules
  alias gsu='git submodule update --init --recursive'

  # switch
  # these aliases requires git v2.23+
  alias gsw='git switch'
  alias gswc='git switch --create'
  alias gswm='git switch $(get_default_branch)'
  alias gswt='git switch --track'

  # tag
  alias gt='git tag'
  alias gta='git tag -a'
  alias gtd='git tag -d'
  alias gtl='git tag -l'
  
  # Worktree
  alias gw='git worktree'
  alias gwa='git worktree add'
  alias gwl='git worktree list'
  alias gwr='git worktree remove'
  alias gwp='git worktree prune'

  # Custom
  alias gfrbm='git fetch --all --prune && git rebase origin/$(get_default_branch)'

  case $OSTYPE in
    darwin*)
      alias gtls="git tag -l | gsort -V"
      ;;
    *)
      alias gtls='git tag -l | sort -V'
      ;;
  esac

  # functions
  function gdv() {
    git diff --ignore-all-space "$@" | vim -R -
  }

  function get_default_branch() {
    if git branch | grep -q '^. main\s*$'; then
      echo main
    else
      echo master
    fi
  }
}
