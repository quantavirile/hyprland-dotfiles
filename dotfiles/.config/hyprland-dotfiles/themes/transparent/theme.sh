#!/usr/bin/env bash
# ML4W Theme Glass

# Set waybar
echo "/ml4w-glass;/ml4w-transparent/default" > $HOME/.config/hyprland-dotfiles/settings/waybar-theme.sh
$HOME/.config/waybar/launch.sh &

# Set nwg-dock-hyprland
echo "transparent" > $HOME/.config/hyprland-dotfiles/settings/dock-theme
$HOME/.config/nwg-dock-hyprland/launch.sh &

# Set swaync
echo '@import "themes/glass/style.css";' > $HOME/.config/swaync/style.css
swaync-client -rs

# Set wlogout
echo '@import "themes/transparent/style.css";' > $HOME/.config/wlogout/style.css

# Set launcher
echo 'rofi' > $HOME/.config/hyprland-dotfiles/settings/launcher

# Set walker theme
echo 'glass' > $HOME/.config/hyprland-dotfiles/settings/walker-theme

# Set Window Border
echo 'source = ~/.config/hypr/conf/windows/transparent.conf' > $HOME/.config/hypr/conf/window.conf

# Set rofi
echo '* { border-width: 1px; }' > $HOME/.config/hyprland-dotfiles/settings/rofi-border.rasi

echo ":: Theme set to Transparent"