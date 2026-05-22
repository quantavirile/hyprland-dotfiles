#!/bin/bash

# MPV Picture-in-Picture Manager for Hyprland
# This script toggles mpv windows between normal and PiP mode

set -euo pipefail

# Configuration
PIP_WIDTH="30%"          # Width as percentage of monitor
PIP_HEIGHT="30%"         # Height as percentage of monitor
PIP_POSITION="top-right" # top-left, top-right, bottom-left, bottom-right

# Get active window info
ACTIVE_CLASS=$(hyprctl activewindow -j | jq -r '.class')
ACTIVE_PID=$(hyprctl activewindow -j | jq -r '.pid')

# Only process mpv windows
if [[ "$ACTIVE_CLASS" != "mpv" ]]; then
  echo "Not an mpv window. Exiting."
  exit 1
fi

# Check if window is already in PiP mode (check for floating state)
WINDOW_STATE=$(hyprctl clients -j | jq -r ".[] | select(.pid == $ACTIVE_PID) | .floating")

if [[ "$WINDOW_STATE" == "true" ]]; then
  # Exit PiP mode - restore tiling
  echo "Exiting PiP mode..."
  hyprctl dispatch togglefloating "pid:$ACTIVE_PID"
else
  # Enter PiP mode - make floating and pinned
  echo "Entering PiP mode..."
  hyprctl dispatch togglefloating "pid:$ACTIVE_PID"
  hyprctl dispatch pin "pid:$ACTIVE_PID"

  # Apply size and position based on config
  case "$PIP_POSITION" in
  top-right)
    hyprctl dispatch resizewindowpixel "exact $PIP_WIDTH $PIP_HEIGHT,pid:$ACTIVE_PID"
    hyprctl dispatch movewindowpixel "exact 1330 64,pid:$ACTIVE_PID"
    ;;
  top-left)
    hyprctl dispatch resizewindowpixel "exact $PIP_WIDTH $PIP_HEIGHT,pid:$ACTIVE_PID"
    hyprctl dispatch movewindowpixel "exact 0 0,pid:$ACTIVE_PID"
    ;;
  bottom-right)
    hyprctl dispatch resizewindowpixel "exact $PIP_WIDTH $PIP_HEIGHT,pid:$ACTIVE_PID"
    hyprctl dispatch movewindowpixel "exact 100%-$PIP_WIDTH 100%-$PIP_HEIGHT,pid:$ACTIVE_PID"
    ;;
  bottom-left)
    hyprctl dispatch resizewindowpixel "exact $PIP_WIDTH $PIP_HEIGHT,pid:$ACTIVE_PID"
    hyprctl dispatch movewindowpixel "exact 0 100%-$PIP_HEIGHT,pid:$ACTIVE_PID"
    ;;
  esac
fi
