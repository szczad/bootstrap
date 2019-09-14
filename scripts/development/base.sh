#!/usr/bin/env bash

info "Installing Development environment"
package_install \
  clang \
  cmake \
  $(conditional_include "$DEVELOPMENT_CODE_BLOCKS" codeblocks) \
  $(conditional_include "$DEVELOPMENT_QT_CREATOR" qt-creator)

success "Development environment installation done!"

