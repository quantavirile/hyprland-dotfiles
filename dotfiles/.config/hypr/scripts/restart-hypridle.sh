#!/usr/bin/env bash

# Notifications
source "$HOME/.config/hyprland-dotfiles/scripts/ml4w-notification-handler"

killall hypridle
sleep 1
hypridle &

notify_user --a "Hypridle" \
        --s "Hypridle has been restarted." \
        --m ""
