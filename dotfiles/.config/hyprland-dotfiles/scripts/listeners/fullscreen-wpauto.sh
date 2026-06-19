#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache/hyprland-dotfiles"
CACHE_FILE="$CACHE_DIR/wallpaper-automation"

if hyprctl activewindow | grep -q "fullscreen: 2"; then
  is_fullscreen=1
  rm -f "$CACHE_FILE"
else
  is_fullscreen=0
  [ ! -f "$CACHE_FILE" ] && touch "$CACHE_FILE"
fi

while true; do
  if hyprctl activewindow | grep -q "fullscreen: 2"; then
    if [ "$is_fullscreen" -eq 0 ]; then
      rm -f "$CACHE_FILE"
      is_fullscreen=1
    fi
  else
    if [ "$is_fullscreen" -eq 1 ]; then
      touch "$CACHE_FILE"
      is_fullscreen=0
    fi
  fi
  sleep 2
done
