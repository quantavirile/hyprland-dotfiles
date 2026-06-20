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
sed -i 's#~/.config/rofi/ml4w/config-screenshot.rasi#~/.config/rofi/catppuccin/config-screenshot.rasi#' $HOME/.config/hyprland-dotfiles/scripts/screenshot.sh
sed -i 's#~/.config/rofi/ml4w/config-cliphist.rasi#~/.config/rofi/catppuccin/config-cliphist.rasi#' $HOME/.config/hyprland-dotfiles/scripts/cliphist.sh
sed -i 's#~/.config/rofi/ml4w/config-keybinds.rasi#~/.config/rofi/catppuccin/config-keybinds.rasi#' $HOME/.config/hypr/scripts/keybindings.sh
sed -i 's#~/.config/rofi/ml4w/config-hyprland-themes.rasi#~/.config/rofi/catppuccin/config-hyprland-themes.rasi#' $HOME/.config/hyprland-dotfiles/themes/themes.sh
sed -i 's#~/.config/rofi/ml4w/config-waybar-themes.rasi#~/.config/rofi/catppuccin/config-waybar-themes.rasi#' $HOME/.config/waybar/themeswitcher.sh
sed -i 's#~/.config/rofi/ml4w/config-launchers.rasi#~/.config/rofi/catppuccin/config-launchers.rasi#' $HOME/.config/hyprland-dotfiles/scripts/launcher-switcher.sh
sed -i 's#~/.config/rofi/ml4w/config-ocr-lang.rasi#~/.config/rofi/catppuccin/config-ocr-lang.rasi#' $HOME/.config/hypr/scripts/text-extractor.sh

# Set fuzzel configs
sed -i 's#colors.ini#catppuccin-mocha/mauve.ini#g' $HOME/.config/fuzzel/*.ini
echo -e "[border]\nwidth=2\nselection-radius=10" >$HOME/.config/hyprland-dotfiles/settings/fuzzel-border

# Set kitty
sed -i 's/include colors-matugen.conf/include mocha.conf/' $HOME/.config/kitty/kitty.conf
sed -i 's/^background_opacity.*/background_opacity 1.0/' "$HOME/.config/kitty/kitty.conf"
pkill -SIGUSR1 kitty

# Set cava
sed -i "s/^theme = '.*'/theme = 'mocha'/" $HOME/.config/cava/config

# Set GTK
echo '@import "catppuccin-mocha-mauve.css";' >$HOME/.config/gtk-3.0/gtk.css
echo '@import url("./catppuccin-mocha-mauve.css");' >$HOME/.config/gtk-4.0/gtk.css
echo '@import url("./gtk4-vars.css");' >>$HOME/.config/gtk-4.0/gtk.css
echo '@import url("./catppuccin-mocha-mauve.css");' >$HOME/.config/gtk-4.0/gtk-dark.css
echo '@import url("./gtk4-vars.css");' >>$HOME/.config/gtk-4.0/gtk-dark.css

# Set btop
sed -i 's/^color_theme = ".*"/color_theme = "catppuccin_mocha"/' $HOME/.config/btop/btop.conf

# Set rmpc
sed -i 's/theme: Some("matugen")/theme: Some("catppuccin-mocha")/' $HOME/.config/rmpc/config.ron

# Set yazi
echo -e '[flavor]\ndark = "mocha"' >"$HOME/.config/yazi/theme.toml"

# Set Firefox
cp "$HOME/.config/hyprland-dotfiles/firefox/catppuccin-wal-colors.json" "$HOME/.cache/wal/colors.json"
pywalfox update
CHROME_DIR="$HOME/.mozilla/firefox/hbjpfw2v.default-release/chrome"
mkdir -p "$CHROME_DIR"
cp "$HOME/.config/hyprland-dotfiles/firefox/userChrome.css" "$CHROME_DIR/userChrome.css"
COLOR6=$(jq -r '.colors.color6 // "#1e1e2e"' "$HOME/.cache/wal/colors.json")
COLOR15=$(jq -r '.colors.color15 // "#cdd6f4"' "$HOME/.cache/wal/colors.json")
COLOR3=$(jq -r '.colors.color3 // "#cba6f7"' "$HOME/.cache/wal/colors.json")
COLOR8=$(jq -r '.colors.color8 // "#181825"' "$HOME/.cache/wal/colors.json")
COLOR7=$(jq -r '.colors.color7 // "#585b70"' "$HOME/.cache/wal/colors.json")
cat >"$CHROME_DIR/userContent.css" <<EOF
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

# Set wallpaper folder
echo '~/Pictures/catppuccin' >$HOME/.config/hyprland-dotfiles/settings/wallpaper-folder
sed -i 's|^folder = .*|folder = ~/Pictures/catppuccin|' $HOME/.config/waypaper/config.ini
$HOME/.config/hyprland-dotfiles/scripts/wallpaper/wallpaper.sh --random

echo ":: Theme set to Catppuccin"
