#!/usr/bin/env bash

package_install git

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

success "Git installed and pre-configured"

