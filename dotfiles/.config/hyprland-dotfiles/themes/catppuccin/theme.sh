#!/usr/bin/env bash
# Catppuccin Theme

# Set hyprland
echo 'require("conf.themes.catppuccin")' > "$HOME/.config/hypr/conf/theme.lua"

# Set waybar
echo "/catppuccin;/catppuccin" >$HOME/.config/hyprland-dotfiles/settings/waybar-theme.sh
$HOME/.config/waybar/launch.sh &

# Set swaync
echo '@import "themes/catppuccin/style.css";' >$HOME/.config/swaync/style.css
swaync-client -rs

# Set wlogout
echo '@import "themes/catppuccin/style.css";' >$HOME/.config/wlogout/style.css

# Set launcher
echo 'rofi' >$HOME/.config/hyprland-dotfiles/settings/launcher

# Set walker theme
echo 'glass' >$HOME/.config/hyprland-dotfiles/settings/walker-theme

# Set rofi
# echo '* { border-width: 1px; }' >$HOME/.config/hyprland-dotfiles/settings/rofi-border.rasi

# Set Rofi theme
echo '@import "catppuccin/config.rasi"' >$HOME/.config/rofi/config.rasi
sed -i 's#~/.config/rofi/config-cliphist.rasi#~/.config/rofi/catppuccin/config.rasi#' $HOME/.config/hyprland-dotfiles/scripts/cliphist.sh
sed -i 's#~/.config/rofi/config-compact.rasi#~/.config/rofi/catppuccin/config.rasi#' $HOME/.config/hyprland-dotfiles/themes/themes.sh

# Set kitty
sed -i 's/include colors-matugen.conf/include mocha.conf/' $HOME/.config/kitty/kitty.conf
pkill -SIGUSR1 kitty

echo ":: Theme set to Catppuccin"
