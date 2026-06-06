#!/usr/bin/env bash
# ML4W Theme Modern

# Set hyprland
sed -i 's#source = ~/.config/hypr/mocha.conf#source = ~/.config/hypr/colors.conf#' "$HOME"/.config/hypr/hyprland.conf

# Set waybar
echo "/ml4w-modern;/ml4w-modern/default" >$HOME/.config/hyprland-dotfiles/settings/waybar-theme.sh
$HOME/.config/waybar/launch.sh &

# Set nwg-dock-hyprland
echo "modern" >$HOME/.config/hyprland-dotfiles/settings/dock-theme
$HOME/.config/nwg-dock-hyprland/launch.sh &

# Set swaync
echo '@import "themes/modern/style.css";' >$HOME/.config/swaync/style.css
swaync-client -rs

# Set wlogout
echo '@import "themes/modern/style.css";' >$HOME/.config/wlogout/style.css

# Set launcher
echo 'walker' >$HOME/.config/hyprland-dotfiles/settings/launcher

# Set walker theme
echo 'modern' >$HOME/.config/hyprland-dotfiles/settings/walker-theme

# Set Window Border
echo 'source = ~/.config/hypr/conf/windows/border-2.conf' >$HOME/.config/hypr/conf/window.conf

# Set kitty theme
sed -i 's/include mocha.conf/include colors-matugen.conf/' $HOME/.config/kitty/kitty.conf
pkill -SIGUSR1 kitty

# Set rofi main config
echo '@import "ml4w/config.rasi"' >$HOME/.config/rofi/config.rasi

# Set rofi
echo '* { border-width: 2px; }' >$HOME/.config/hyprland-dotfiles/settings/rofi-border.rasi

# Set cava
sed -i "s/^theme = '.*'/theme = 'matugen'/" $HOME/.config/cava/config

# Set GTK
echo '@import "colors.css";' > $HOME/.config/gtk-3.0/gtk.css
echo '@import url("./colors.css");' > $HOME/.config/gtk-4.0/gtk.css
echo '@import url("./colors.css");' > $HOME/.config/gtk-4.0/gtk-dark.css

# Set btop
sed -i 's/^color_theme = ".*"/color_theme = "matugen"/' $HOME/.config/btop/btop.conf

# Set rmpc
sed -i 's/theme: Some("catppuccin-mocha")/theme: Some("matugen")/' $HOME/.config/rmpc/config.ron

echo ":: Theme set to Modern"

