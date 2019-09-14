#!/usr/bin/env bash

ANDROID_STUDIO_DEFAULT_URL="https://dl.google.com/dl/android/studio/ide-zips/3.5.0.21/android-studio-ide-191.5791312-linux.tar.gz"
ANDROID_STUDIO_DEFAULT_SHA256="5794fd6edca6e4daa31f5ed710670d0b425534549a6c4aa2e3e9753ae116736f"
ANDROID_STUDIO_TMP_FILE="$(mktemp --suffix=.tar.gz)"

: ${ANDROID_STUDIO_URL:=$ANDROID_STUDIO_DEFAULT_URL}
: ${ANDROID_STUDIO_SHA256:=$ANDROID_STUDIO_DEFAULT_SHA256}
: ${ANDROID_STUDIO_GLOBAL:=1}

info "Installing Android Studio"

if yes_no_check "$ANDROID_STUDIO_GLOBAL"; then
  ANDROID_STUDIO_LOCATION="/opt/android"
else
  ANDROID_STUDIO_LOCATION="$USER/Applications/android"
fi

if [ -e "$ANDROID_STUDIO_LOCATION" ]; then
  warn "Android Studio already installed at \"$ANDROID_STUDIO_LOCATION\"."
else
  info "Downloading Android Studio"
  wget -O "$ANDROID_STUDIO_TMP_FILE" "$ANDROID_STUDIO_URL"
  RESULT=($(sha256sum "$ANDROID_STUDIO_TMP_FILE"))

  info "Checking SHA256 sum"
  if [ "$ANDROID_STUDIO_SHA256" != "${RESULT[0]}" ]; then
    error "Invalid Android Studio IDE SHA256 sum on downloaded file:\n\t$ANDROID_STUDIO_SHA256 != ${RESULT[0]}"
    rm -f "$ANDROID_STUDIO_TMP_FILE"
    exit 1
  fi

  info "Unpacking Android studio to \"$ANDROID_STUDIO_LOCATION\"."
  make_dir "$ANDROID_STUDIO_LOCATION"
  sudo tar xaf "$ANDROID_STUDIO_TMP_FILE" -C "$ANDROID_STUDIO_LOCATION"

  success "Installed Android Studio!"
fi
