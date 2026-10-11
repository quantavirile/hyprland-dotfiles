#!/bin/bash

# Switch launchers on the fly

current_launcher=~/.config/hyprland-dotfiles/settings/launcher
menu_command=$(cat "$current_launcher")

launchers=(
  "rofi"
  "walker"
  "fuzzel"
)

# Detect available menu program
define_menu() {
  if ! command -v $menu_command; then
    if command -v fuzzel >/dev/null 2>&1; then
      menu_command="fuzzel"
    elif command -v rofi >/dev/null 2>&1; then
      menu_command="rofi"
    elif command -v walker >/dev/null 2>&1; then
      menu_command="walker"
    else
      echo "No menu program found (fuzzel, rofi, walker)" >&2
      exit 1
    fi
  fi
}

# Fuzzel menu
fuzzel_menu() {
  printf '%s\n' "${launchers[@]}" | fuzzel \
    --dmenu \
    --config="$HOME/.config/fuzzel/launchers.ini"
}

# Rofi menu
rofi_menu() {
  printf '%s\n' "${launchers[@]}" | rofi \
    -dmenu \
    -config ~/.config/rofi/ml4w/config-launchers.rasi
}

# Walker menu
walker_menu() {
  printf '%s\n' "${launchers[@]}" | $HOME/.config/walker/launch.sh \
    -d -N -H \
    -p "Search Launchers"
}

define_menu

# Show selection menu using the current launcher
case $menu_command in
"fuzzel") choice=$(fuzzel_menu) ;;
"rofi") choice=$(rofi_menu) ;;
"walker") choice=$(walker_menu) ;;
esac

[[ -z "$choice" ]] && exit 0

echo "$choice" >"$current_launcher"
