#!/usr/bin/env bash
#                                      __   
#   ___ ____ ___ _  ___ __ _  ___  ___/ /__ 
#  / _ `/ _ `/  ' \/ -_)  ' \/ _ \/ _  / -_)
#  \_, /\_,_/_/_/_/\__/_/_/_/\___/\_,_/\__/ 
# /___/                                     
# 


CACHE_DIR="$HOME/.cache/hyprland-dotfiles"

# Notifications
source "$HOME/.config//hprland-dotfiles/scripts/ml4w-notification-handler"
APP_NAME="System"
NOTIFICATION_ICON="joystick"

if [ -f $HOME/.config/hprland-dotfiles/settings/gamemode-enabled ]; then
  if [ -f $CACHE_DIR/restart-wpauto ]; then
    rm $CACHE_DIR/restart-wpauto
    $HOME/.config/hprland-dotfiles/scripts/wallpaper/wallpaper-automation.sh &
  fi
  hyprctl reload
  rm $HOME/.config//hprland-dotfiles/settings/gamemode-enabled
  notify_user --a "${APP_NAME}" \
            --i "${NOTIFICATION_ICON}" \
            --s "Gamemode deactivated" \
            --m "Animations and blur are now enabled."
else
  if [ -f $CACHE_DIR/wallpaper-automation ]; then
    touch $CACHE_DIR/restart-wpauto
    $HOME/.config/hprland-dotfiles/scripts/wallpaper/wallpaper-automation.sh
  fi
  hyprctl eval "activate_gamemode()"
  touch $HOME/.config/hprland-dotfiles/settings/gamemode-enabled
  notify_user --a "${APP_NAME}" \
          --i "${NOTIFICATION_ICON}" \
          --s "Gamemode activated" \
          --m "Animations and blur are now disabled."
fi