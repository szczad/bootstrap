install_archive() {
  if [[ $# -lt 2 ]]; then
    printf 'install_archive <url> <dest> [files...]\n'
    return 1
  fi

  local url="$1" dest="$2" tmp code=0
  shift 2
  local files=("$@")
  
  tmp=$(mktemp) 
  if curl -# -L -o "$tmp" "$url"; then
    tar -xaf "$tmp" -C "$dest" "${files[@]}"
  else
    code=1
  fi

  rm -f "$tmp"
  return $code
}

