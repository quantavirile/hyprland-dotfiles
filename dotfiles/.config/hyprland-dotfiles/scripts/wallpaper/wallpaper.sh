#!/usr/bin/env bash

# Default variables
IMAGE_PATH=""
EFFECT=""
NOTIFICATIONS=false
SKIP=false
CACHE_FOLDER="$HOME/.cache/hyprland-dotfiles"
EFFECTS_CACHE="$CACHE_FOLDER/effects"
CACHE_FILE="$CACHE_FOLDER/current_wallpaper"
DEFAULT_WALLPAPER="/usr/share/hypr/wall0.png"
BLURRED_WALLPAPER="$CACHE_FOLDER/blurred_wallpaper.png"
SQUARE_WALLPAPER="$CACHE_FOLDER/square_wallpaper.png"
RASI_FILE="$CACHE_FOLDER/current_wallpaper.rasi"

# Settings
SETTINGS_BLUR="$HOME/.config/hyprland-dotfiles/settings/blur.sh"
SETTINGS_WALLPAPER_FOLDER="$HOME/.config/hyprland-dotfiles/settings/wallpaper-folder"
SETTINGS_WALLPAPER_EFFECT="$HOME/.config/hyprland-dotfiles/settings/wallpaper-effect.sh"
SETTINGS_TRANSITION_EFFECT=$(cat "$HOME/.config/hyprland-dotfiles/settings/wallpaper-transition-effect")
# Blur
BLUR="50x30"
BLUR=$(cat "$SETTINGS_BLUR")

# Colors for UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- UI Functions (Redirected to stderr) ---
info() { echo -e "${GREEN}[INFO]${NC} $1" >&2; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

generate_firefox_usercontent() {
  local colors_json="$1"
  local label="${2:-Firefox}"
  local chrome_dir="$HOME/.mozilla/firefox/hbjpfw2v.default-release/chrome"
  [ ! -d "$HOME/.mozilla/firefox/hbjpfw2v.default-release" ] && return 1
  mkdir -p "$chrome_dir"
  local color6=$(jq -r '.colors.color6 // "#1e1e2e"' "$colors_json" 2>/dev/null)
  local color15=$(jq -r '.colors.color15 // "#cdd6f4"' "$colors_json" 2>/dev/null)
  local color3=$(jq -r '.colors.color3 // "#cba6f7"' "$colors_json" 2>/dev/null)
  local color8=$(jq -r '.colors.color8 // "#181825"' "$colors_json" 2>/dev/null)
  local color7=$(jq -r '.colors.color7 // "#585b70"' "$colors_json" 2>/dev/null)
  cat >"$chrome_dir/userContent.css" <<EOF
@-moz-document url-prefix("about:preferences"),
               url-prefix("about:addons"),
               url-prefix("about:protections"),
               url-prefix("about:config") {
  :root {
    --background-color-canvas: ${color6} !important;
    --in-content-page-color: ${color15} !important;
    --in-content-text-color: ${color15} !important;
    --link-color: ${color3} !important;
    --link-color-hover: ${color3} !important;
    --color-accent-primary: ${color3} !important;
    --in-content-box-background: ${color8} !important;
    --in-content-box-border-color: ${color3} !important;
    --in-content-button-background-hover: ${color7} !important;
    --in-content-button-background-active: ${color7} !important;
  }
}
EOF
  info "$label: Firefox userContent.css regenerated"
}

# ==========================================
# Functions
# ==========================================

show_help() {
  echo "Usage: ml4w-wallpaper PATH_TO_IMAGE [OPTIONS]"
  echo "  DEFAULT:               $DEFAULT_WALLPAPER"
  echo ""
  echo "Core Parameters:"
  echo "  PATH_TO_IMAGE          Path to the image file to set as wallpaper."
  echo ""
  echo "Optional Parameters:"
  echo "  --effect NAME          Apply a specific wallpaper effect."
  echo "  --random FOLDER        Select a random image from FOLDER."
  echo "  --notifications false  Disable desktop notifications."
  echo "  --help                 Show this help message and exit."
  echo "  --skip                 Will skip setting the wallpaper with awww."
  echo ""
}

send_notification() {
  local title="$1"
  local message="$2"
  if [ "$NOTIFICATIONS" = true ]; then
    # You can adjust the icon or app name here
    notify-send -a "ml4w-wallpaper" -i "preferences-desktop-wallpaper-symbolic" "$title" "$message"
  fi
}

# ==========================================
# Parameter Parsing
# ==========================================

# If no arguments are passed, show help
if [[ $# -eq 0 ]]; then
  show_help
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
  --skip)
    SKIP=true
    shift 1
    ;;
  --effect)
    EFFECT="$2"
    shift 2
    ;;
  --random)
    if [[ -n "$2" && "$2" != -* ]]; then
      RANDOM_FOLDER="$2"
      shift 2
    else
      # Default folder if none is provided
      RAW_FOLDER=$(cat "$SETTINGS_WALLPAPER_FOLDER")
      # Safely expand $HOME and ~
      RANDOM_FOLDER="${RAW_FOLDER//\$HOME/$HOME}"
      RANDOM_FOLDER="${RANDOM_FOLDER//\~/$HOME}"
      shift 1
    fi

    if [[ -d "$RANDOM_FOLDER" ]]; then
      # Select a random image from the resolved folder
      IMAGE_PATH=$(find "$RANDOM_FOLDER" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

      if [[ -z "$IMAGE_PATH" ]]; then
        error "No valid images (jpg, jpeg, png) found in -> $RANDOM_FOLDER"
        exit 1
      fi
      info "Random wallpaper selected: $IMAGE_PATH"
    else
      error "Directory does not exist -> $RANDOM_FOLDER"
      exit 1
    fi
    ;;
  --notifications)
    if [[ "$2" == "false" ]]; then
      NOTIFICATIONS=false
    fi
    shift 2
    ;;
  --help)
    show_help
    exit 0
    ;;
  -*)
    echo "Error: Unknown option $1"
    show_help
    exit 1
    ;;
  *)
    # If it's not a flag, we assume it's the image path
    if [[ -z "$IMAGE_PATH" ]]; then
      IMAGE_PATH="$1"
    else
      echo "Error: Multiple image paths provided or unknown argument -> $1"
      exit 1
    fi
    shift
    ;;
  esac
done

# ==========================================
# Validation
# ==========================================

if [[ -z "$IMAGE_PATH" ]]; then
  info "Setting wallpaper with default image -> $DEFAULT_WALLPAPER"
  IMAGE_PATH="$DEFAULT_WALLPAPER"
fi

if [[ ! -f "$IMAGE_PATH" ]]; then
  error "Image file does not exist at -> $IMAGE_PATH"
  exit 1
fi

# ==========================================
# Core Logic
# ==========================================

# Create cache folder
if [ ! -d "$CACHE_FOLDER" ]; then
  mkdir -p "$CACHE_FOLDER"
fi

# Ensure awww-daemon is running
if ! pgrep -x "awww-daemon" >/dev/null; then
  mkdir -p "$HOME/.cache/awww"
  info "Starting awww-daemon..."
  awww-daemon &

  # Give the daemon a brief moment to initialize before sending commands
  sleep 1
fi

# Write image path to cache file
if [ ! -f "$CACHE_FILE" ]; then
  touch "$CACHE_FILE"
fi
echo "$IMAGE_PATH" >"$CACHE_FILE"
info "Cache file written with $IMAGE_PATH"

# Process image with wallpaper effect
if [ -f "$SETTINGS_WALLPAPER_EFFECT" ]; then
  EFFECT=$(cat "$SETTINGS_WALLPAPER_EFFECT")
  if [ ! "$EFFECT" == "off" ]; then
    info "Applying Wallpaper Effect $EFFECT"
    mkdir -p "$EFFECTS_CACHE"
    EFFECT_CACHED="$EFFECTS_CACHE/$EFFECT-$(basename "$IMAGE_PATH")"
    if [ -f "$EFFECT_CACHED" ]; then
      IMAGE_PATH="$EFFECT_CACHED"
      info "Using cached processed wallpaper"
    else
      cp "$IMAGE_PATH" "$EFFECT_CACHED"
      IMAGE_PATH="$EFFECT_CACHED"
      source "$HOME/.config/hypr/effects/wallpaper/$EFFECT"
    fi
  fi
fi

# Set the Wallpaper
if [ "$SKIP" = true ]; then
  info "Setting wallpaper skipped"
else
  info "Setting wallpaper: $IMAGE_PATH"
  info "Using wallpaper effect $SETTINGS_TRANSITION_EFFECT"
  awww img "$IMAGE_PATH" --transition-type "$SETTINGS_TRANSITION_EFFECT"
fi

# Detect Theme
SETTINGS_FILE="$HOME/.config/gtk-3.0/settings.ini"
THEME_PREF=$(grep -E '^gtk-application-prefer-dark-theme=' "$SETTINGS_FILE" | awk -F'=' '{print $2}')

# Execute matugen
if [ "$THEME_PREF" -eq 1 ]; then
  matugen image "$IMAGE_PATH" --source-color-index 0 -m "dark"
else
  matugen image "$IMAGE_PATH" --source-color-index 0 -m "light"
fi
info "Matugen updated"

# Update Quickshell theme
# qs ipc call theme-manager reload
# info "Quickshell Theme updated"

# Update ML4W Dotfiles Settings theme
# qs -p $HOME/.local/share/ml4w-dotfiles-settings/quickshell ipc call theme-manager reload
# info "ML4W Dotfiles Settings Theme updated"

# Reload Waybar
if pgrep -x "waybar" >/dev/null; then
  info "Waybar is currently running."
  pkill -SIGUSR2 waybar
else
  info "Waybar is not running."
  nohup bash -c "$HOME/.config/waybar/launch.sh" >/dev/null 2>&1 &
  disown
fi
info "Waybar reloaded"

# Reload nwg-dock-hyprland
nohup bash -c "$HOME/.config/nwg-dock-hyprland/launch.sh" >/dev/null 2>&1 &
disown
info "nwg-dock-hyprland reloaded"

# Update Pywalfox
if type pywalfox >/dev/null 2>&1; then
  pywalfox update
  info "pywalfox updated"
fi

# Update Firefox userContent.css for about:* pages
generate_firefox_usercontent "$HOME/.cache/wal/colors.json"

# Re-apply catppuccin colors if catppuccin theme is active
if grep -q "catppuccin" "$HOME/.config/hypr/conf/theme.lua" 2>/dev/null; then
  CATPPUCCIN_WAL="$HOME/.config/hyprland-dotfiles/firefox/catppuccin-wal-colors.json"
  if [ -f "$CATPPUCCIN_WAL" ]; then
    cp "$CATPPUCCIN_WAL" "$HOME/.cache/wal/colors.json"
    if type pywalfox >/dev/null 2>&1; then
      pywalfox update
      info "catppuccin: pywalfox re-applied"
    fi
    generate_firefox_usercontent "$HOME/.cache/wal/colors.json" "catppuccin"
  fi
fi

# Update SwayNC
sleep 0.1
swaync-client -rs
info "SwayNC refreshed"

# Create blurred image
magick "$IMAGE_PATH" -resize 75% "$BLURRED_WALLPAPER"
info "$(basename "$IMAGE_PATH") resized to 75% -> $(basename "$BLURRED_WALLPAPER")"
if [ ! "$BLUR" == "0x0" ]; then
  magick "$BLURRED_WALLPAPER" -blur "$BLUR" "$BLURRED_WALLPAPER"
  info "$(basename "$BLURRED_WALLPAPER") blurred with $BLUR"
fi

# Create square image
magick "$IMAGE_PATH" -gravity Center -extent 1:1 "$SQUARE_WALLPAPER"
info "$(basename "$SQUARE_WALLPAPER") created"

# Create rasi file
if [ ! -f "$RASI_FILE" ]; then
  touch "$RASI_FILE"
fi
echo "* { current-image: url(\"$BLURRED_WALLPAPER\", height); }" >"$RASI_FILE"
info "$(basename "$RASI_FILE") written with $(basename "$BLURRED_WALLPAPER")"

# Apply Effects (Placeholder for your specific effect logic)
# if [[ -n "$EFFECT" ]]; then
#     info "Applying effect: $EFFECT"
#     send_notification "Wallpaper Effect" "Applying $EFFECT to $(basename "$IMAGE_PATH")"
# fi

# Notification
send_notification "Wallpaper Update Completed" "Successfully set and processed $(basename "$IMAGE_PATH")"
info "Wallpaper Updated: Successfully set $(basename "$IMAGE_PATH")"
exit 0
