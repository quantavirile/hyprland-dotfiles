#!/usr/bin/env bash
#   ____ _ _       _     _     _
#  / ___| (_)_ __ | |__ (_)___| |_
# | |   | | | '_ \| '_ \| / __| __|
# | |___| | | |_) | | | | \__ \ |_
#  \____|_|_| .__/|_| |_|_|___/\__|
#           |_|
#

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------
launcher=$(cat $HOME/.config/hyprland-dotfiles/settings/launcher)
if [ "$launcher" == "walker" ]; then
  $HOME/.config/walker/launch.sh -m clipboard -N -H
elif [ "$launcher" == "fuzzel" ]; then
  case $1 in
  d)
    cliphist list | fuzzel --dmenu --config="$HOME/.config/fuzzel/cliphist.ini" | cliphist delete
    ;;
  w)
    cliphist wipe
    ;;
  *)
    cliphist list | fuzzel --dmenu --with-nth 2 --config="$HOME/.config/fuzzel/cliphist.ini" | cliphist decode | wl-copy
    ;;
  esac
else
  case $1 in
  d)
    cliphist list | rofi -dmenu -replace -config ~/.config/rofi/ml4w/config-cliphist.rasi | cliphist delete
    ;;
  w)
    cliphist wipe
    ;;
  *)
    cliphist list | rofi -dmenu -display-columns 2 -replace -config ~/.config/rofi/ml4w/config-cliphist.rasi | cliphist decode | wl-copy
    ;;
  esac
fi
