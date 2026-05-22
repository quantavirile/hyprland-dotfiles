#!/usr/bin/env bash
# ML4W Theme Glass

# Set hyprland
sed -i 's#source = ~/.config/hypr/mocha.conf#source = ~/.config/hypr/colors.conf#' "$HOME"/.config/hypr/hyprland.conf

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

# Set Window Border
echo 'source = ~/.config/hypr/conf/windows/default.conf' >$HOME/.config/hypr/conf/window.conf

# Set rofi
echo '* { border-width: 1px; }' >$HOME/.config/hyprland-dotfiles/settings/rofi-border.rasi

# Set kitty theme
sed -i 's/include mocha.conf/include colors-matugen.conf/' $HOME/.config/kitty/kitty.conf
pkill -SIGUSR1 kitty

echo ":: Theme set to Glass"
