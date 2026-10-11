#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# -----------------------------------------------------
# Load Launcher
# -----------------------------------------------------
launcher=$(cat $HOME/.config/hyprland-dotfiles/settings/launcher)

# -----------------------------------------------------
# Themes
# -----------------------------------------------------
if command -v walker >/dev/null 2>&1; then
  # Walker installed
  THEME_OPTIONS=$(find "$SCRIPT_DIR" -maxdepth 1 -mindepth 1 -type d | awk -F/ '{ print $NF }')
else
  # Walker not installed
  THEME_OPTIONS=$(find "$SCRIPT_DIR" -maxdepth 1 -mindepth 1 -type d -not -name "*walker*" | awk -F/ '{ print $NF }')
fi
# -----------------------------------------------------
# Start Launcher
# -----------------------------------------------------

if [ "$launcher" == "walker" ]; then
  selected_theme=$($HOME/.config/walker/launch.sh -d -N -H -p "Search Themes" <<<"$THEME_OPTIONS")
elif [ "$launcher" == "fuzzel" ]; then
  selected_theme=$(printf '%s\n' "$THEME_OPTIONS" | fuzzel --dmenu --config="$HOME/.config/fuzzel/themes.ini")
else
  selected_theme=$(rofi -dmenu -i -markup -replace -config ~/.config/rofi/ml4w/config-hyprland-themes.rasi <<<"$THEME_OPTIONS")
fi

# -----------------------------------------------------
# Source selected theme
# -----------------------------------------------------

source $HOME/.config/hyprland-dotfiles/themes/$selected_theme/theme.sh

# Reload Hyprland to remove errors displayed
hyprctl reload
