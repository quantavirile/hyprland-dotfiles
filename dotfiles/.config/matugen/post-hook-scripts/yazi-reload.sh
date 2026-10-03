#!/usr/bin/env bash

# Yazi theme reload via DDS - triggered by matugen after flavor update
# Broadcasts theme reload to all running yazi instances
if ! command -v ya >/dev/null 2>&1; then
  export PATH="$HOME/.cargo/bin:/usr/local/bin:/usr/bin:$PATH"
  command -v ya >/dev/null 2>&1 || exit 0
fi

if ! pgrep -x yazi >/dev/null 2>&1 && ! pgrep -f "[y]azi" >/dev/null 2>&1; then
  exit 0
fi

LOG="${XDG_CACHE_HOME:-$HOME/.cache}/hyprland-dotfiles/yazi-reload.log"
mkdir -p "$(dirname "$LOG")"
{
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] wallpaper -> yazi theme reload"
  ya emit-to 0 app:theme 2>&1 || echo "emit app:theme failed"
  # Re-render the starship plugin header (it only refreshes on cd/tab, so a
  # theme-only update would keep stale colors until the next cd).
  # NOTE: the --str body is required; a bodiless pub is accepted by the DDS
  # server but never dispatched to sub_remote subscribers.
  ya pub-to 0 starship-theme --str refresh 2>&1 || echo "pub starship-theme failed"
} >>"$LOG" 2>&1 || true
