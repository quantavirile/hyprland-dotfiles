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

# Set rofi
echo '* { border-width: 1px; }' >$HOME/.config/hyprland-dotfiles/settings/rofi-border.rasi

# Set kitty theme
sed -i 's/include mocha.conf/include colors-matugen.conf/' $HOME/.config/kitty/kitty.conf
pkill -SIGUSR1 kitty

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

# Set Firefox
WALLPAPER=$(cat "$HOME/.cache/hyprland-dotfiles/current_wallpaper")
if [[ -n "$WALLPAPER" && -f "$WALLPAPER" ]]; then
  matugen image "$WALLPAPER" --source-color-index 0 -m "dark"
fi
pywalfox update
CHROME_DIR="$HOME/.mozilla/firefox/hbjpfw2v.default-release/chrome"
mkdir -p "$CHROME_DIR"
cp "$HOME/.config/hyprland-dotfiles/firefox/userChrome.css" "$CHROME_DIR/userChrome.css"
COLOR6=$(jq -r '.colors.color6 // "#1e1e2e"' "$HOME/.cache/wal/colors.json")
COLOR15=$(jq -r '.colors.color15 // "#cdd6f4"' "$HOME/.cache/wal/colors.json")
COLOR3=$(jq -r '.colors.color3 // "#cba6f7"' "$HOME/.cache/wal/colors.json")
COLOR8=$(jq -r '.colors.color8 // "#181825"' "$HOME/.cache/wal/colors.json")
COLOR7=$(jq -r '.colors.color7 // "#585b70"' "$HOME/.cache/wal/colors.json")
cat > "$CHROME_DIR/userContent.css" << EOF
@-moz-document url-prefix("about:preferences"),
               url-prefix("about:addons"),
               url-prefix("about:protections"),
               url-prefix("about:config") {
  :root {
    --background-color-canvas: ${COLOR6} !important;
    --in-content-page-color: ${COLOR15} !important;
    --in-content-text-color: ${COLOR15} !important;
    --link-color: ${COLOR3} !important;
    --link-color-hover: ${COLOR3} !important;
    --color-accent-primary: ${COLOR3} !important;
    --in-content-box-background: ${COLOR8} !important;
    --in-content-box-border-color: ${COLOR3} !important;
    --in-content-button-background-hover: ${COLOR7} !important;
    --in-content-button-background-active: ${COLOR7} !important;
  }
}
EOF

echo ":: Theme set to Glass"
