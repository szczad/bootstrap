#!/bin/bash

if [ "$EUID" != "0" ]; then
  exec sudo "$0" "$@"
fi

# Games
flatpak install -y flathub \
  com.valvesoftware.Steam \
  org.openttd.OpenTTD \
  com.jagex.RuneScape
