#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache/hyprland-dotfiles"
CACHE_FILE="$CACHE_DIR/wallpaper-automation"
WP_AUTOMATION_SCRIPT="$HOME/.config/hyprland-dotfiles/scripts/wallpaper/wallpaper-automation.sh"
is_fullscreen=0
killed_automation=0

while true; do
  if hyprctl activewindow | grep -q "fullscreen: 2"; then
    if [ "$is_fullscreen" -eq 0 ]; then
      if pgrep -f "wallpaper-automation\.sh" >/dev/null; then
        pkill -f "wallpaper-automation\.sh" 2>/dev/null || true
        rm -f "$CACHE_FILE"
        killed_automation=1
      fi
      is_fullscreen=1
    fi
  else
    if [ "$is_fullscreen" -eq 1 ]; then
      if [ "$killed_automation" -eq 1 ]; then
        nohup "$WP_AUTOMATION_SCRIPT" >/dev/null 2>&1 &
        killed_automation=0
      fi
      is_fullscreen=0
    fi
  fi
  sleep 2
done
