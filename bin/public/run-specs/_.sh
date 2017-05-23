
# === {{CMD}}
run-specs () {
  cd "$THIS_DIR"

  echo "=== Compiling..."
  crystal build specs/mu-uri.spec.cr
  mv mu-uri.spec tmp/

  local +x IFS=$'\n'
  if [[ -z "$@" ]]; then
    local +x FILES="$(find specs -maxdepth 1 -mindepth 1 -type d | sort)"
  else
    local +x FILES="$(find specs -maxdepth 1 -mindepth 1 -type d -iname "*$@*" | sort)"
  fi

  if [[ -z "$FILES" ]]; then
    sh_color RED "!!! {{No specs found}}: $@"
    exit 1
  else
    for DIR in $(echo "$FILES") ; do
      tmp/mu-uri.spec "$DIR" | sh_color GREEN
    done
  fi
} # === end function
