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

# Set rofi main config
echo '@import "ml4w/config.rasi"' >$HOME/.config/rofi/config.rasi

# Set rofi configs
sed -i 's#~/.config/rofi/catppuccin/config-screenshot.rasi#~/.config/rofi/ml4w/config-screenshot.rasi#' $HOME/.config/hyprland-dotfiles/scripts/screenshot.sh
sed -i 's#~/.config/rofi/catppuccin/config-cliphist.rasi#~/.config/rofi/ml4w/config-cliphist.rasi#' $HOME/.config/hyprland-dotfiles/scripts/cliphist.sh
sed -i 's#~/.config/rofi/catppuccin/config-keybinds.rasi#~/.config/rofi/ml4w/config-keybinds.rasi#' $HOME/.config/hypr/scripts/keybindings.sh
sed -i 's#~/.config/rofi/catppuccin/config-waybar-themes.rasi#~/.config/rofi/ml4w/config-waybar-themes.rasi#' $HOME/.config/waybar/themeswitcher.sh
sed -i 's#~/.config/rofi/catppuccin/config-hyprland-themes.rasi#~/.config/rofi/ml4w/config-hyprland-themes.rasi#' $HOME/.config/hyprland-dotfiles/themes/themes.sh
sed -i 's#~/.config/rofi/catppuccin/config-launchers.rasi#~/.config/rofi/ml4w/config-launchers.rasi#' $HOME/.config/hyprland-dotfiles/scripts/launcher-switcher.sh
sed -i 's#~/.config/rofi/catppuccin/config-ocr-lang.rasi#~/.config/rofi/ml4w/config-ocr-lang.rasi#' $HOME/.config/hypr/scripts/text-extractor.sh

# Set fuzzel configs
sed -i 's#catppuccin-mocha/mauve.ini#colors.ini#g' $HOME/.config/fuzzel/*.ini
echo -e "[border]\nwidth=1\nselection-radius=10" >$HOME/.config/hyprland-dotfiles/settings/fuzzel-border

# Set rofi
echo '* { border-width: 1px; }' >$HOME/.config/hyprland-dotfiles/settings/rofi-border.rasi

# Set kitty theme
sed -i 's/include themes\/mocha.conf/include themes\/Matugen.conf/' $HOME/.config/kitty/kitty.conf
sed -i 's/^background_opacity.*/background_opacity 0.85/' "$HOME/.config/kitty/kitty.conf"
pkill -SIGUSR1 kitty

# Set cava
sed -i "s/^theme = '.*'/theme = 'matugen'/" $HOME/.config/cava/config

# Set GTK
echo '@import "colors.css";' >$HOME/.config/gtk-3.0/gtk.css
echo '@import "colors.css";' >$HOME/.config/gtk-4.0/gtk.css

# Set btop
sed -i 's/^color_theme = ".*"/color_theme = "matugen"/' $HOME/.config/btop/btop.conf

# Set rmpc
sed -i 's/theme: Some("catppuccin-mocha")/theme: Some("matugen")/' $HOME/.config/rmpc/config.ron

# Set yazi
echo -e '[flavor]\ndark = "matugen"' >"$HOME/.config/yazi/theme.toml"
sed -i 's|config_file = ".*"|config_file = "~/.config/starship/starship-matugen.toml"|' "$HOME/.config/yazi/init.lua"

# Set spicetify
$HOME/.spicetify/spicetify config current_theme Sleek
$HOME/.spicetify/spicetify config color_scheme matugen
$HOME/.spicetify/spicetify config inject_css 1 inject_theme_js 1 replace_colors 1 overwrite_assets 1
$HOME/.spicetify/spicetify apply

# Set starship
sed -i 's|^export STARSHIP_CONFIG=.*|export STARSHIP_CONFIG="$HOME/.config/starship/starship-matugen.toml"|' "$HOME/.zshrc"

# Set opencode
sed -i 's|"theme": ".*"|"theme": "matugen"|' "$HOME/.config/opencode/tui.json"

# Set mpv
sed -i 's|^include=.*|include=~/.config/mpv/themes/matugen.conf|' "$HOME/.config/mpv/mpv.conf"
echo '{"command": ["load-config-file", "~/.config/mpv/themes/matugen.conf"]}' | socat - /tmp/mpv-socket 2>/dev/null || true

# Set wallpaper folder
echo '~/Pictures/wallpaper' >$HOME/.config/hyprland-dotfiles/settings/wallpaper-folder
sed -i 's|^folder = .*|folder = ~/Pictures/wallpaper|' $HOME/.config/waypaper/config.ini
$HOME/.config/hyprland-dotfiles/scripts/wallpaper/wallpaper.sh --random

# Set Firefox
CHROME_DIR="$HOME/.mozilla/firefox/hbjpfw2v.default-release/chrome"
mkdir -p "$CHROME_DIR"
cp "$HOME/.config/hyprland-dotfiles/firefox/userChrome.css" "$CHROME_DIR/userChrome.css"

echo ":: Theme set to Glass"
