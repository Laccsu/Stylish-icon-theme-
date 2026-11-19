#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(
  cd "$(dirname "$0")" && pwd -P
)
REPO_ROOT=$(
  cd "$SCRIPT_DIR/.." && pwd -P
)

for places_dir in "$REPO_ROOT"/src/Stylish-Dark/*/places; do
  [ -d "$places_dir" ] || continue

  find "$places_dir" -type l | while IFS= read -r link; do
    target=$(readlink "$link")
    case "$target" in
      *blue*)
        new_target=$(printf '%s\n' "$target" | sed 's/blue/black/g')
        ln -sf "$new_target" "$link"
        printf 'Atualizado: %s -> %s\n' "$link" "$new_target"
        ;;
    esac
  done
done
