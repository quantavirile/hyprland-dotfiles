#!/usr/bin/env bash
# filter-diff.sh — git diff with matugen/theme-script excludes
# Keep EXCLUDES in sync with references/auto-generated.md
# Usage: filter-diff.sh [--stat|--diff|--name-only] [--cached] [--help]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"

EXCLUDES=(
  ':(exclude)dotfiles/.config/hypr/colors.conf'
  ':(exclude)dotfiles/.config/hypr/colors.lua'
  ':(exclude)dotfiles/.config/waybar/colors.css'
  ':(exclude)dotfiles/.config/rofi/colors.rasi'
  ':(exclude)dotfiles/.config/gtk-3.0/colors.css'
  ':(exclude)dotfiles/.config/gtk-4.0/colors.css'
  ':(exclude)dotfiles/.config/wlogout/colors.css'
  ':(exclude)dotfiles/.config/swaync/colors.css'
  ':(exclude)dotfiles/.config/cava/themes/matugen'
  ':(exclude)dotfiles/.config/btop/themes/matugen.theme'
  ':(exclude)dotfiles/.config/kitty/themes/Matugen.conf'
  ':(exclude)dotfiles/.config/rmpc/themes/matugen.ron'
  ':(exclude)dotfiles/.config/hyprland-dotfiles/colors/'
  ':(exclude)dotfiles/.config/fuzzel/colors.ini'
  ':(exclude)dotfiles/.config/fzf/colors'
  ':(exclude)dotfiles/.zshrc.d/zsh-syntax-highlighting/themes/matugen-zsh-syntax-highlighting.zsh'
  ':(exclude)dotfiles/.config/yazi/flavors/matugen.yazi/flavor.toml'
  ':(exclude)dotfiles/.config/starship/starship-matugen.toml'
  ':(exclude)dotfiles/.config/mpv/themes/matugen.conf'
  ':(exclude)dotfiles/.config/nvim/generated.lua'
  ':(exclude)dotfiles/.config/opencode/themes/matugen.json'
  ':(exclude)dotfiles/.config/gtk-3.0/gtk.css'
  ':(exclude)dotfiles/.config/gtk-3.0/settings.ini'
  ':(exclude)dotfiles/.config/gtk-4.0/gtk.css'
  ':(exclude)dotfiles/.config/gtk-4.0/settings.ini'
  ':(exclude)dotfiles/.config/kitty/kitty.conf'
  ':(exclude)dotfiles/.config/xsettingsd/xsettingsd.conf'
  ':(exclude)dotfiles/.gtkrc-2.0'
  ':(exclude)dotfiles/.config/yazi/theme.toml'
  ':(exclude)dotfiles/.config/hypr/scripts/keybindings.sh'
  ':(exclude)dotfiles/.config/hyprland-dotfiles/settings/fuzzel-border'
  ':(exclude)dotfiles/.config/hyprland-dotfiles/scripts/cliphist.sh'
  ':(exclude)dotfiles/.config/hyprland-dotfiles/settings/wallpaper-folder'
  ':(exclude)dotfiles/.config/hyprland-dotfiles/settings/wallpaper-effect.sh'
  ':(exclude)dotfiles/.config/hyprland-dotfiles/themes/themes.sh'
  ':(exclude)dotfiles/.config/btop/btop.conf'
  ':(exclude)dotfiles/.config/cava/config'
  ':(exclude)dotfiles/.config/fuzzel/cliphist.ini'
  ':(exclude)dotfiles/.config/fuzzel/fuzzel.ini'
  ':(exclude)dotfiles/.config/fuzzel/keybinds.ini'
  ':(exclude)dotfiles/.config/fuzzel/launchers.ini'
  ':(exclude)dotfiles/.config/fuzzel/ocr-lang.ini'
  ':(exclude)dotfiles/.config/fuzzel/screenshot.ini'
  ':(exclude)dotfiles/.config/fuzzel/themes.ini'
  ':(exclude)dotfiles/.config/hypr/conf/theme.lua'
  ':(exclude)dotfiles/.config/hypr/scripts/text-extractor.sh'
  ':(exclude)dotfiles/.config/hyprland-dotfiles/scripts/launcher-switcher.sh'
  ':(exclude)dotfiles/.config/hyprland-dotfiles/scripts/screenshot.sh'
  ':(exclude)dotfiles/.config/hyprland-dotfiles/settings/launcher'
  ':(exclude)dotfiles/.config/hyprland-dotfiles/settings/waybar-theme.sh'
  ':(exclude)dotfiles/.config/mpv/mpv.conf'
  ':(exclude)dotfiles/.config/rofi/config.rasi'
  ':(exclude)dotfiles/.config/swaync/style.css'
  ':(exclude)dotfiles/.config/waybar/themeswitcher.sh'
  ':(exclude)dotfiles/.config/wlogout/style.css'
  ':(exclude)dotfiles/.config/yazi/init.lua'
)

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Run git diff with matugen/theme-script files excluded.

Options:
  --stat        Show file statistics only (default)
  --diff        Show full diff (no stat)
  --name-only   Show only changed file names
  --cached      Show staged changes (can combine with --stat/--name-only/--diff)
  --help        Show this help

Examples:
  $(basename "$0") --stat
  $(basename "$0") --diff
  $(basename "$0") --cached --stat
  $(basename "$0") --cached --name-only
EOF
}

VIEW="--stat"
CACHED=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --stat)
      VIEW="--stat"
      shift
      ;;
    --diff)
      VIEW=""
      shift
      ;;
    --name-only)
      VIEW="--name-only"
      shift
      ;;
    --cached)
      CACHED="--cached"
      shift
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      echo "Error: Unknown option '$1'" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if git rev-parse --show-toplevel >/dev/null 2>&1; then
  REPO_ROOT="$(git rev-parse --show-toplevel)"
else
  REPO_ROOT="$SKILL_ROOT/../../.."
fi

cd "$REPO_ROOT" || { echo "Error: cannot cd to repo root $REPO_ROOT" >&2; exit 2; }

if [[ -n "$VIEW" ]]; then
  # shellcheck disable=SC2086
  git diff $CACHED "$VIEW" -- . "${EXCLUDES[@]}"
else
  # shellcheck disable=SC2086
  git diff $CACHED -- . "${EXCLUDES[@]}"
fi
