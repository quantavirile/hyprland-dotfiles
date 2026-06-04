#!/usr/bin/env bash
# Catppuccin Theme

# Set hyprland
echo 'require("conf.themes.catppuccin")' >"$HOME/.config/hypr/conf/theme.lua"

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
sed -i 's#~/.config/rofi/ml4w/config-screenshot.rasi#~/.config/rofi/catppuccin/config-screenshot.rasi#' $HOME/.config/hypr/scripts/screenshot.sh
sed -i 's#~/.config/rofi/ml4w/config-cliphist.rasi#~/.config/rofi/catppuccin/config-cliphist.rasi#' $HOME/.config/hyprland-dotfiles/scripts/cliphist.sh
sed -i 's#~/.config/rofi/ml4w/config-keybinds.rasi#~/.config/rofi/catppuccin/config-keybinds.rasi#' $HOME/.config/hypr/scripts/keybindings.sh
sed -i 's#~/.config/rofi/ml4w/config-hyprland-themes.rasi#~/.config/rofi/catppuccin/config-hyprland-themes.rasi#' $HOME/.config/hyprland-dotfiles/themes/themes.sh
sed -i 's#~/.config/rofi/ml4w/config-waybar-themes.rasi#~/.config/rofi/catppuccin/config-waybar-themes.rasi#' $HOME/.config/waybar/themeswitcher.sh
sed -i 's#~/.config/rofi/ml4w/config-launchers.rasi#~/.config/rofi/catppuccin/config-launchers.rasi#' $HOME/.config/hyprland-dotfiles/scripts/launcher-switcher.sh
sed -i 's#~/.config/rofi/ml4w/config-ocr-lang.rasi#~/.config/rofi/catppuccin/config-ocr-lang.rasi#' $HOME/.config/hypr/scripts/text-extractor.sh

# Set kitty
sed -i 's/include colors-matugen.conf/include mocha.conf/' $HOME/.config/kitty/kitty.conf
pkill -SIGUSR1 kitty

echo ":: Theme set to Catppuccin"
