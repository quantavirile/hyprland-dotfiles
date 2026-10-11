#!/usr/bin/env bash
#                _ _
# __      ____ _| | |_ __   __ _ _ __   ___ _ __
# \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__|
#  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |
#   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|
#                   |_|         |_|
#
# -----------------------------------------------------
# Restore last wallpaper
# -----------------------------------------------------

CACHE_DIR="$HOME/.cache/hyprland-dotfiles"
CACHE_FILE="$CACHE_DIR/current_wallpaper"

mkdir -p "$CACHE_DIR"

# -----------------------------------------------------
# Get current wallpaper
# -----------------------------------------------------

wallpaper=""

if [ -f "$CACHE_FILE" ]; then
  cached="$(cat "$CACHE_FILE" 2>/dev/null)"
  # Expand leading ~ and $HOME without mutating the cache file.
  case "$cached" in
  "~"/*) cached="$HOME/${cached#~/}" ;;
  esac
  cached="${cached//\$HOME/$HOME}"
  if [ -n "$cached" ] && [ -f "$cached" ]; then
    echo ":: Wallpaper $cached exists"
    wallpaper="$cached"
  else
    echo ":: Wallpaper $cached does not exist." >&2
  fi
else
  echo ":: $CACHE_FILE does not exist." >&2
fi

if [ -z "$wallpaper" ]; then
  echo ":: ERROR: no cached wallpaper found." >&2
  exit 1
fi

# -----------------------------------------------------
# Ensure backend daemon is running (mirrors wallpaper.sh)
# -----------------------------------------------------

if ! pgrep -x "awww-daemon" >/dev/null 2>&1; then
  mkdir -p "$HOME/.cache/awww"
  echo ":: Starting awww-daemon..."
  awww-daemon &
  sleep 1
fi

# -----------------------------------------------------
# Set wallpaper
# -----------------------------------------------------

echo ":: Setting wallpaper with source image $wallpaper"
if ! command -v waypaper >/dev/null 2>&1; then
  echo ":: ERROR: waypaper not found in PATH." >&2
  exit 1
fi
waypaper --wallpaper "$wallpaper"
