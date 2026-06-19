#!/usr/bin/env bash
#     _         _         __        ______
#    / \  _   _| |_ ___   \ \      / /  _ \
#   / _ \| | | | __/ _ \   \ \ /\ / /| |_) |
#  / ___ \ |_| | || (_) |   \ V  V / |  __/
# /_/   \_\__,_|\__\___/     \_/\_/  |_|
#

# Configuration
CACHE_DIR="$HOME/.cache/hyprland-dotfiles"
interval=$(cat ~/.config/hyprland-dotfiles/settings/wallpaper-automation)

# Notifications
source "$HOME/.config/hyprland-dotfiles/scripts/ml4w-notification-handler"
APP_NAME="Waypaper"
NOTIFICATION_ICON="preferences-desktop-wallpaper-symbolic"

_setWallpaperRandomly() {
  if [ -f $CACHE_DIR/wallpaper-automation ]; then
    $HOME/.config/hyprland-dotfiles/scripts/wallpaper/wallpaper.sh --random
    echo ":: Next wallpaper in $interval seconds..."
  fi
  sleep $interval
  _setWallpaperRandomly
}

if [ ! -f $CACHE_DIR/wallpaper-automation ]; then
  touch $CACHE_DIR/wallpaper-automation
  echo ":: Start wallpaper automation script"
  notify_user \
    --a "${APP_NAME}" \
    --i "${NOTIFICATION_ICON}" \
    --m "Wallpaper automation process started.\nWallpaper will be changed every $interval seconds."
  _setWallpaperRandomly
else
  rm $CACHE_DIR/wallpaper-automation
  notify_user \
    --a "${APP_NAME}" \
    --i "${NOTIFICATION_ICON}" \
    --m "Wallpaper automation process stopped."
  echo ":: Wallpaper automation script process $wp stopped"
  wp=$(pgrep -f wallpaper-automation.sh)
  kill -KILL $wp
fi
