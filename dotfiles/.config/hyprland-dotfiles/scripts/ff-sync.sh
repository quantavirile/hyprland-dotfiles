#!/bin/bash
set -euo pipefail

CENTRAL="$HOME/.config/hyprland-dotfiles/firefox/user.js"
FIREFOX_DIR="$HOME/.mozilla/firefox"
TS=$(date +%Y%m%d%H%M%S)

[ -f "$CENTRAL" ] || { echo "Central user.js not found at $CENTRAL"; exit 1; }

for dir in "$FIREFOX_DIR"/*/; do
  name=$(basename "$dir")
  case "$name" in
    "Crash Reports"|"Pending Pings"|"Profile Groups"|*"-backup-"*) continue ;;
  esac

  target="$dir/user.js"

  if [ -f "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up $name/user.js -> user.js-backup-$TS"
    mv "$target" "$target-backup-$TS"
  elif [ -L "$target" ]; then
    rm "$target"
  fi

  ln -s "$CENTRAL" "$target"
  echo "Linked $name/user.js"
done
