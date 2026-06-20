#!/bin/bash

set -euo pipefail

# Target PiP size
PIP_W=640
PIP_H=360

# Edge padding for bottom positions
PAD=20
PIP_POSITION="top-right"

# Limit to active mpv window
ACTIVE_CLASS=$(hyprctl activewindow -j | jq -r '.class')
ACTIVE_PID=$(hyprctl activewindow -j | jq -r '.pid')
ACTIVE_MONITOR=$(hyprctl activewindow -j | jq -r '.monitor')

if [[ "$ACTIVE_CLASS" != "mpv" ]]; then
  exit 1
fi

# Monitor dimensions
MON_DATA=$(hyprctl monitors -j | jq -r ".[] | select(.id == $ACTIVE_MONITOR) | {width, height}")
MON_W=$(echo "$MON_DATA" | jq -r '.width')
MON_H=$(echo "$MON_DATA" | jq -r '.height')

# Detect Waybar height so PiP clears it on top positions
WAYBAR_DATA=$(hyprctl layers -j | jq -r '.[].levels."2"[] | select(.namespace == "waybar") | {y, h}')
WAYBAR_Y=$(echo "$WAYBAR_DATA" | jq -r '.y // empty')
WAYBAR_H=$(echo "$WAYBAR_DATA" | jq -r '.h // empty')
if [[ -n "$WAYBAR_Y" && -n "$WAYBAR_H" ]]; then
  TOP_PAD=$((WAYBAR_Y + WAYBAR_H + 12))
else
  TOP_PAD=$PAD
fi

# Compute position from monitor dimensions and padding
case "$PIP_POSITION" in
top-left)
  PIP_X=$PAD
  PIP_Y=$TOP_PAD
  ;;
top-right)
  PIP_X=$((MON_W - PIP_W - PAD))
  PIP_Y=$TOP_PAD
  ;;
bottom-left)
  PIP_X=$PAD
  PIP_Y=$((MON_H - PIP_H - PAD))
  ;;
bottom-right)
  PIP_X=$((MON_W - PIP_W - PAD))
  PIP_Y=$((MON_H - PIP_H - PAD))
  ;;
esac

# Toggle PiP
W_FLOATING=$(hyprctl clients -j | jq -r ".[] | select(.pid == $ACTIVE_PID) | .floating")

if [[ "$W_FLOATING" == "true" ]]; then
  # Exit PiP: unfloat back to tiled
  hyprctl dispatch 'hl.dsp.window.float({})'
else
  # Enter PiP: float, resize to target, pin, reposition
  hyprctl dispatch 'hl.dsp.window.float({})'

  # Read current floating size and compute resize delta
  WIN_DATA=$(hyprctl clients -j | jq -r ".[] | select(.pid == $ACTIVE_PID) | {size: .size, at: .at}")
  W_CUR_W=$(echo "$WIN_DATA" | jq -r '.size[0]')
  W_CUR_H=$(echo "$WIN_DATA" | jq -r '.size[1]')
  DELTA_W=$((PIP_W - W_CUR_W))
  DELTA_H=$((PIP_H - W_CUR_H))

  hyprctl dispatch "hl.dsp.window.resize({x=$DELTA_W, y=$DELTA_H})"
  hyprctl dispatch 'hl.dsp.window.pin({})'
  hyprctl dispatch "hl.dsp.window.move({x=$PIP_X, y=$PIP_Y})"
fi
