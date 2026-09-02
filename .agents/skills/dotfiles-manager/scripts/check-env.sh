#!/usr/bin/env bash
set -euo pipefail

# check-env.sh — non-destructive environment precheck for dotfiles-manager
# Exit codes:
#   0 = all checks passed
#   1 = warnings (non-fatal issues)
#   2 = fatal missing prerequisites

WARN=0
FATAL=0

info() { printf "[INFO] %s\n" "$*"; }
warn() { printf "[WARN] %s\n" "$*"; WARN=1; }
err() { printf "[ERROR] %s\n" "$*"; FATAL=1; }

check_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    err "Required command not found: $1"
  else
    info "Found: $1"
  fi
}

info "Running environment checks for hyprland-dotfiles"

# OS check
if [[ "$(uname -s)" != "Linux" ]]; then
  warn "Non-Linux OS detected ($(uname -s)). This skill targets Linux desktops."
else
  info "OS: Linux"
fi

# Required commands
for cmd in stow git bash; do
  check_cmd "$cmd"
done

# Optional but recommended
for cmd in hyprctl pidof; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    warn "Optional command not found: $cmd (some reloads may be unavailable)"
  else
    info "Found: $cmd"
  fi
done

# ~/.config must be a real directory
if [[ ! -d "$HOME/.config" ]]; then
  err "$HOME/.config does not exist or is not a directory"
elif [[ -L "$HOME/.config" ]]; then
  err "$HOME/.config is a symlink (must be a real directory). Run deploy.sh or fix manually."
else
  info "$HOME/.config is a real directory"
fi

# Quick symlink checks (non-fatal)
check_symlink() {
  local target="$1"
  if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
    warn "$target exists but is not a symlink to the repo"
  elif [[ ! -e "$target" ]]; then
    warn "$target does not exist"
  else
    info "$target is present (may be symlink)"
  fi
}

check_symlink "$HOME/.zshrc"
check_symlink "$HOME/.config/waybar/style.css"

# Summarize
if (( FATAL )); then
  echo
  err "One or more fatal preconditions failed. Fix the errors above before proceeding."
  exit 2
fi

if (( WARN )); then
  echo
  warn "Checks completed with warnings. Review output; use ./deploy.sh to (re)stow if appropriate."
  exit 1
fi

info "All checks passed. Safe to proceed."
exit 0
