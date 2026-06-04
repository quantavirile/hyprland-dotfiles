#!/usr/bin/env bash
# ML4W Theme Glass

# Set hyprland
echo 'require("conf.themes.glass")' >"$HOME/.config/hypr/conf/theme.lua"

# Set waybar
echo "/ml4w-glass;/ml4w-glass/default" >$HOME/.config/hyprland-dotfiles/settings/waybar-theme.sh
$HOME/.config/waybar/launch.sh &

# Set nwg-dock-hyprland
# echo "glass" > $HOME/.config/hyprland-dotfiles/settings/dock-theme
# $HOME/.config/nwg-dock-hyprland/launch.sh &

# Set swaync
echo '@import "themes/glass/style.css";' >$HOME/.config/swaync/style.css
swaync-client -rs

# Set wlogout
echo '@import "themes/glass/style.css";' >$HOME/.config/wlogout/style.css

# Set launcher
echo 'walker' >$HOME/.config/hyprland-dotfiles/settings/launcher

# Set walker theme
echo 'glass' >$HOME/.config/hyprland-dotfiles/settings/walker-theme

# Set rofi configs
sed -i 's#~/.config/rofi/catppuccin/config-screenshot.rasi#~/.config/rofi/ml4w/config-screenshot.rasi#' $HOME/.config/hypr/scripts/screenshot.sh
sed -i 's#~/.config/rofi/catppuccin/config-cliphist.rasi#~/.config/rofi/ml4w/config-cliphist.rasi#' $HOME/.config/hyprland-dotfiles/scripts/cliphist.sh
sed -i 's#~/.config/rofi/catppuccin/config-keybinds.rasi#~/.config/rofi/ml4w/config-keybinds.rasi#' $HOME/.config/hypr/scripts/keybindings.sh
sed -i 's#~/.config/rofi/catppuccin/config-waybar-themes.rasi#~/.config/rofi/ml4w/config-waybar-themes.rasi#' $HOME/.config/waybar/themeswitcher.sh
sed -i 's#~/.config/rofi/catppuccin/config-hyprland-themes.rasi#~/.config/rofi/ml4w/config-hyprland-themes.rasi#' $HOME/.config/hyprland-dotfiles/themes/themes.sh
sed -i 's#~/.config/rofi/catppuccin/config-launchers.rasi#~/.config/rofi/ml4w/config-launchers.rasi#' $HOME/.config/hyprland-dotfiles/scripts/launcher-switcher.sh
sed -i 's#~/.config/rofi/catppuccin/config-ocr-lang.rasi#~/.config/rofi/ml4w/config-ocr-lang.rasi#' $HOME/.config/hypr/scripts/text-extractor.sh

# Set rofi
echo '* { border-width: 1px; }' >$HOME/.config/hyprland-dotfiles/settings/rofi-border.rasi

# Set kitty theme
sed -i 's/include mocha.conf/include colors-matugen.conf/' $HOME/.config/kitty/kitty.conf
pkill -SIGUSR1 kitty

echo ":: Theme set to Glass"
