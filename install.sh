#!/usr/bin/env bash

# Be more strict about errors
set -euo pipefail

BASE_DIR="$(python -c "import os, sys; print(os.path.dirname(os.path.realpath(sys.argv[1])))" "$0")"

# Read explicit configuration and common routines
source "$BASE_DIR/install.vars"
source "$BASE_DIR/lib.sh"

# Force 4 space wide tab character
tabs -4

for ARG in "$@"; do
  case "$ARG" in
    -h|--help)
      help
      exit 0
      ;;
    -l|--list)
      available_scripts_help
      exit 0
      ;;
    -a|--all)
      SCRIPTS=("${AVAILABLE_SCRIPTS[@]}")
      ;;
    *)
      if [[ -f "$BASE_DIR/scripts/$ARG.sh" ]]; then
        SCRIPTS+=("$ARG")
      elif [[ -d "$BASE_DIR/scripts/$ARG" ]]; then
        SCRIPTS+=($( (cd $BASE_DIR; find "scripts/$ARG" -type f ! -name .\* | sed -e 's@scripts/@@g' -e 's@\.sh$@@g') ))
      else
        warn "Script \"$ARG\" does not exist"
      fi
      ;;
  esac
done

if [ "${#SCRIPTS[@]}" -eq "0" ]; then
  SCRIPTS=("${DEFAULT_SCRIPTS[@]}")
fi

for SCRIPT in "${SCRIPTS[@]}"; do
  source "scripts/${SCRIPT}.sh"
done

success "All done!"

