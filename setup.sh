#!/usr/bin/env bash
# setup.sh — installer for hyprland-dotfiles
# (Arch Linux and Arch-based distros, tested on minimal Arch).
#
# Examples:
#   ./setup.sh                     # full install, prompting (default)
#   ./setup.sh --dry-run           # preview every mutating command
#   ./setup.sh --yes --minimal     # unattended lean install (VMs/tests)
#   ./setup.sh --restore           # revert latest backup run, then exit
#   ./setup.sh --restore 20261006T143501  # revert a specific run

set -euo pipefail

# Configuration constants (repo-relative paths, URLs, etc). All paths are absolute.
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_FILE_FULL="$REPO_DIR/packages-arch"
PKG_FILE_MINIMAL="$REPO_DIR/packages-arch-minimal"
STOW_ROOT="$REPO_DIR/dotfiles"
BACKUP_BASE="${XDG_STATE_HOME:-$HOME/.local/share/state}/hyprland-dotfiles/backups"
MEGASYNC_URL="https://mega.nz/linux/repo/Arch_Extra/x86_64/megasync-x86_64.pkg.tar.zst"
CACHYOS_REPO_URL="https://mirror.cachyos.org/cachyos-repo.tar.xz"
FLATPAK_FILE="$REPO_DIR/flatpaks"
FLATHUB_URL="https://dl.flathub.org/repo/flathub.flatpakrepo"

YES=0
DRY_RUN=0
NO_PACKAGES=0
NO_STOW=0
MINIMAL=0
RESTORE="__unset__"

log() { printf '%s\n' "$*"; }
info() { printf '\033[1;34m::\033[0m %s\n' "$*"; log_to_file "INFO" "$*"; }
WARN_COUNT=0
ERROR_COUNT=0
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; log_to_file "WARN" "$*"; WARN_COUNT=$((WARN_COUNT + 1)); }
# Non-fatal error: recorded for the validate() summary, execution continues.
record_error() { printf '\033[1;31mEE\033[0m %s\n' "$*" >&2; log_to_file "ERROR" "$*"; ERROR_COUNT=$((ERROR_COUNT + 1)); }
success() { printf '\033[1;32mOK\033[0m %s\n' "$*"; log_to_file "SUCCESS" "$*"; }
error() {
  printf '\033[1;31mXX\033[0m %s\n' "$*" >&2
  log_to_file "ERROR" "$*"
  exit 1
}

# --- Run logging -----------------------------------------------------------
# Console stays pretty (no timestamps); the file gets HH:MM:SS LEVEL lines.
# Initialized by log_init() after arg parsing, before preflight().
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hyprland-dotfiles/logs"
LOG_FILE=""

log_to_file() {
  [[ -n "$LOG_FILE" ]] || return 0
  printf '%s %-7s %s\n' "$(date +%H:%M:%S)" "$1" "$2" >>"$LOG_FILE"
}

stage() {
  printf '\n\033[1m=== %s ===\033[0m\n' "$*"
  log_to_file "STAGE" "$*"
}

log_init() {
  mkdir -p "$LOG_DIR"
  LOG_FILE="$LOG_DIR/setup-$(date +%Y%m%dT%H%M%S).log"
  local restore_state="-"
  [[ "$RESTORE" != "__unset__" ]] && restore_state="${RESTORE:-latest}"
  {
    printf '# hyprland-dotfiles setup run %s\n' "$(date -Is)"
    printf '# repo=%s flags=yes:%s dry-run:%s no-packages:%s no-stow:%s minimal:%s restore:%s\n' \
      "$REPO_DIR" "$YES" "$DRY_RUN" "$NO_PACKAGES" "$NO_STOW" "$MINIMAL" "$restore_state"
    printf '# distro=%s\n' "$(grep -E '^(ID|PRETTY_NAME)=' /etc/os-release 2>/dev/null | tr '\n' ' ')"
  } >>"$LOG_FILE"
  ln -sfn "$LOG_FILE" "$LOG_DIR/latest.log" 2>/dev/null || true
  info "Logging to $LOG_FILE"
}

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]
       $(basename "$0") --restore [timestamp]

Installer for hyprland-dotfiles (Arch Linux and Arch-based
distros). Prompts before every destructive step; idempotent where possible.

Options:
  -y, --yes                   Skip confirmation prompts (defaults: yay, full package list)
      --dry-run               Print every mutating command, change nothing
      --no-packages           Skip repos, system update, packages, and Flatpak
      --no-stow               Skip the stow stage
      --minimal               Install packages-arch-minimal instead of packages-arch
      --restore [timestamp]   Revert a backup run (latest when [timestamp] omitted).
  -h, --help                  Show this help

Examples:
  ./setup.sh                    Full install, prompting at each stage
  ./setup.sh --dry-run          Preview only; also writes a preview log
  ./setup.sh --yes --minimal    Unattended lean install
  ./setup.sh --restore          Revert the latest backup run

EOF
}

run() {
  if [[ "$DRY_RUN" == 1 ]]; then
    log "+ $*"
    log_to_file "CMD" "+ $*"
  else
    "$@"
  fi
}

confirm() {
  local prompt="${1:-Proceed?}"
  if [[ "$YES" == 1 ]]; then return 0; fi
  if command -v gum >/dev/null 2>&1; then
    gum confirm "$prompt" --default=false
  else
    local ans=""
    read -rp "$prompt [y/N] " ans || true
    [[ "$ans" == [Yy] || "$ans" == [Yy][Ee][Ss] ]]
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -y | --yes)
    YES=1
    shift
    ;;
  --dry-run)
    DRY_RUN=1
    shift
    ;;
  --no-packages)
    NO_PACKAGES=1
    shift
    ;;
  --no-stow)
    NO_STOW=1
    shift
    ;;
  --minimal)
    MINIMAL=1
    shift
    ;;
  --restore)
    # Optional timestamp: --restore [timestamp]. Bare flag restores latest.
    if [[ $# -ge 2 && "$2" != -* ]]; then
      RESTORE="$2"
      shift 2
    else
      RESTORE=""
      shift
    fi
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *) error "Unknown option: $1 (see --help)" ;;
  esac
done

log_init

preflight() {
  stage "Preflight"
  [[ "${EUID:-$(id -u)}" -ne 0 ]] || error "Do not run as root. Run as your user (sudo is used internally)."
  [[ -f /etc/os-release ]] || error "/etc/os-release not found. Arch Linux or Arch-based distro required."
  grep -qiE '^(ID|ID_LIKE)=.*arch' /etc/os-release ||
    error "Unsupported distro. This installer supports Arch Linux and Arch-based distros only."
  if ! ping -c1 -W3 1.1.1.1 >/dev/null 2>&1; then
    # ICMP is blocked in some sandboxes/VMs; fall back to HTTPS before failing.
    curl -sSI --max-time 10 https://aur.archlinux.org >/dev/null 2>&1 ||
      error "No internet connectivity (ping 1.1.1.1 + https://aur.archlinux.org failed)."
  fi
  command -v sudo >/dev/null 2>&1 || error "sudo not found."
  run sudo -v || error "sudo authentication failed."
  command -v git >/dev/null 2>&1 || error "git not found. Install base-devel + git first."
  [[ -d "$STOW_ROOT" ]] || error "Stow root not found: $STOW_ROOT"

  # Base tools (stow needed for the stow stage, gum for AUR helper selection and confirmation prompts).
  if ! command -v stow >/dev/null 2>&1 || ! command -v gum >/dev/null 2>&1; then
    info "Installing stow + git + gum..."
    run sudo pacman -S --needed --noconfirm stow git gum
  fi
  if ! pacman -Qg base-devel >/dev/null 2>&1; then
    info "Installing base-devel (needed for AUR builds)..."
    run sudo pacman -S --needed --noconfirm base-devel
  fi

  ensure_aur_helper

  local pkg_file="$PKG_FILE_FULL"
  [[ "$MINIMAL" == 1 ]] && pkg_file="$PKG_FILE_MINIMAL"
  [[ -f "$pkg_file" ]] || error "Package file not found: $pkg_file"
  success "Preflight OK (repo: $REPO_DIR, pkg file: $(basename "$pkg_file"))."
}

AUR_HELPER=""
ensure_aur_helper() {
  local yay_present=0 paru_present=0
  command -v yay >/dev/null 2>&1 && yay_present=1
  command -v paru >/dev/null 2>&1 && paru_present=1

  if [[ "$yay_present" == 1 && "$paru_present" == 0 ]]; then
    AUR_HELPER="yay"
    info "AUR helper present (yay)."
    return 0
  fi
  if [[ "$yay_present" == 0 && "$paru_present" == 1 ]]; then
    AUR_HELPER="paru"
    info "AUR helper present (paru)."
    return 0
  fi
  if [[ "$yay_present" == 1 && "$paru_present" == 1 ]]; then
    info "Both yay and paru installed."
    AUR_HELPER="$(select_aur_helper "use")"
    info "Using $AUR_HELPER as AUR helper."
    return 0
  fi

  info "No AUR helper installed."
  AUR_HELPER="$(select_aur_helper "install")"
  info "Installing $AUR_HELPER as AUR helper..."
  confirm "Clone + build $AUR_HELPER from AUR?" \
    || error "$AUR_HELPER is required to install AUR packages, aborting."
  if [[ "$DRY_RUN" == 1 ]]; then
    log "+ git clone (yay-bin|paru from AUR, tmp dir) && makepkg -si --noconfirm"
    return 0
  fi
  install_aur_helper "$AUR_HELPER"
  command -v "$AUR_HELPER" >/dev/null 2>&1 || error "$AUR_HELPER bootstrap failed."
}

select_aur_helper() {
  local purpose="$1" choice=""
  if [[ "$YES" == 1 ]]; then
    echo "yay"
    return 0
  fi
  # Choosing requires interaction; fail fast instead of looping forever
  # when gum has no TTY to read from.
  [[ -t 0 ]] || error "AUR helper choice needs a TTY; re-run with --yes for the default (yay)."
  while [[ "$choice" != "yay" && "$choice" != "paru" ]]; do
    choice="$(gum choose "yay" "paru" --header "Select AUR helper to $purpose")" || true
  done
  echo "$choice"
}

install_aur_helper() {
  local helper="$1" repo_url tmp
  if [[ "$helper" == "yay" ]]; then
    repo_url="https://aur.archlinux.org/yay-bin.git"
  else
    repo_url="https://aur.archlinux.org/paru.git"
  fi
  tmp="$(mktemp -d -t "$helper-XXXXXX")"
  # Expand now (not on EXIT) so `set -u` is safe after locals go out of scope.
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" EXIT
  git clone --depth 1 "$repo_url" "$tmp"
  (cd "$tmp" && makepkg -si --noconfirm)
  trap - EXIT
  rm -rf "$tmp"
}

system_update() {
  stage "System update"
  info "Updating system (pacman -Syu)..."
  run sudo pacman -Syu --noconfirm
}

# Adds CachyOS optimized repos on non-CachyOS systems lacking them; skips when
# already configured (re-runs are safe).
# See https://wiki.cachyos.org/features/optimized_repos/
ensure_cachyos_repos() {
  stage "CachyOS repos"
  if grep -qi '^ID=cachyos' /etc/os-release 2>/dev/null; then
    info "CachyOS detected, optimized repos built-in, skipping."
    return 0
  fi
  # Anchored so commented-out entries (#[cachyos]) don't count as configured.
  if grep -q '^\[cachyos' /etc/pacman.conf 2>/dev/null; then
    info "CachyOS repos already configured, skipping."
    return 0
  fi
  info "Adding CachyOS optimized repos..."
  confirm "Download + run cachyos-repo.sh?" || {
    warn "CachyOS repos skipped by user."
    return 0
  }
  if [[ "$DRY_RUN" == 1 ]]; then
    log "+ curl -o \$TMPDIR/cachyos-repo.tar.xz $CACHYOS_REPO_URL"
    log "+ tar -xf \$TMPDIR/cachyos-repo.tar.xz -C \$TMPDIR"
    log "+ (cd \$TMPDIR/cachyos-repo && sudo ./cachyos-repo.sh)"
    return 0
  fi
  local tmp
  tmp="$(mktemp -d -t cachyos-repo-XXXXXX)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" EXIT
  curl -o "$tmp/cachyos-repo.tar.xz" "$CACHYOS_REPO_URL"
  tar -xf "$tmp/cachyos-repo.tar.xz" -C "$tmp"
  (cd "$tmp/cachyos-repo" && sudo ./cachyos-repo.sh)
  trap - EXIT
  rm -rf "$tmp"
  # No explicit sync needed: system_update() runs pacman -Syu right after.
}

install_packages() {
  stage "Packages"
  local pkg_file="$PKG_FILE_FULL"
  [[ "$MINIMAL" == 1 ]] && pkg_file="$PKG_FILE_MINIMAL"
  local count
  count="$(grep -cve '^[[:space:]]*$' "$pkg_file")"
  info "Installing $count packages from $(basename "$pkg_file") via $AUR_HELPER..."
  confirm "Install $count packages?" || {
    warn "Package install skipped by user."
    return 0
  }
  if [[ "$DRY_RUN" == 1 ]]; then
    log "+ $AUR_HELPER -S --needed --noconfirm - < $pkg_file"
  else
    "$AUR_HELPER" -S --needed --noconfirm - <"$pkg_file"
  fi
  install_megasync
}

# megasync is intentionally NOT in packages-arch; use the official MEGA repo build.
install_megasync() {
  stage "megasync (official repo build)"
  if pacman -Qi megasync >/dev/null 2>&1; then
    info "megasync already installed, skipping."
    return 0
  fi
  info "Installing megasync from official MEGA repo build..."
  confirm "Download + install megasync?" || {
    warn "megasync skipped by user."
    return 0
  }
  if [[ "$DRY_RUN" == 1 ]]; then
    log "+ wget -O \$TMPDIR/megasync-x86_64.pkg.tar.zst $MEGASYNC_URL"
    log "+ sudo pacman -U --noconfirm \$TMPDIR/megasync-x86_64.pkg.tar.zst"
    return 0
  fi
  local tmp
  tmp="$(mktemp -d -t megasync-XXXXXX)"
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" EXIT
  wget -O "$tmp/megasync-x86_64.pkg.tar.zst" "$MEGASYNC_URL"
  sudo pacman -U --noconfirm "$tmp/megasync-x86_64.pkg.tar.zst"
  trap - EXIT
  rm -rf "$tmp"
}

setup_flatpak() {
  stage "Flatpak"
  command -v flatpak >/dev/null 2>&1 || { warn "flatpak not found, skipping Flatpak setup."; return 0; }
  [[ -f "$FLATPAK_FILE" ]] || { warn "Flatpak list not found: $FLATPAK_FILE, skipping."; return 0; }
  local count
  count="$(grep -cve '^[[:space:]]*$' "$FLATPAK_FILE")"
  info "Setting up Flathub remote + $count Flatpak apps (system-wide)..."
  confirm "Install $count Flatpak apps system-wide?" || { warn "Flatpak setup skipped by user."; return 0; }
  if [[ "$DRY_RUN" == 1 ]]; then
    log "+ sudo flatpak remote-add --if-not-exists flathub $FLATHUB_URL"
  else
    sudo flatpak remote-add --if-not-exists flathub "$FLATHUB_URL"
  fi
  local app
  while IFS= read -r app || [[ -n "$app" ]]; do
    [[ -z "${app//[[:space:]]/}" ]] && continue
    if flatpak info "$app" >/dev/null 2>&1; then
      info "$app already installed, skipping."
    elif [[ "$DRY_RUN" == 1 ]]; then
      log "+ sudo flatpak install -y flathub $app"
    else
      sudo flatpak install -y flathub "$app"
    fi
  done < "$FLATPAK_FILE"
}

do_stow() {
  stage "Stow dotfiles"
  info "Deploying dotfiles (self-contained stow)..."
  confirm "Stow $STOW_ROOT -> $HOME (backups to $BACKUP_BASE)?" ||
    {
      warn "Stow skipped by user."
      return 0
    }

  local run_dir="$BACKUP_BASE/$(date +%Y%m%dT%H%M%S)"
  if [[ "$DRY_RUN" == 1 ]]; then
    log "+ mkdir -p $run_dir"
  else
    mkdir -p "$run_dir"
  fi

  # ~/.config must be a real directory, never a symlink (stow would nest through it).
  if [[ -L "$HOME/.config" ]]; then
    warn "$HOME/.config is a symlink, replacing with a real directory."
    run rm "$HOME/.config"
    run mkdir -p "$HOME/.config"
  elif [[ ! -d "$HOME/.config" ]]; then
    run mkdir -p "$HOME/.config"
  fi

  local items=()
  while IFS= read -r line; do
    [[ -n "$line" ]] && items+=("$line")
  done < <(cd "$STOW_ROOT" && find . -maxdepth 2 \( -type f -o -type d \) ! -name "." ! -name "*-backup-*" | sed 's|^\./||' | sort)

  local manifest="$run_dir/MANIFEST.log"
  if [[ "$DRY_RUN" == 1 ]]; then
    log "+ backup ${#items[@]} items to $run_dir, then: stow -t $HOME (in $STOW_ROOT)"
  else
    : >"$manifest"
    echo "# backup run $(date -Is) repo=$REPO_DIR" >>"$manifest"
  fi

  local item full_path dest
  for item in "${items[@]}"; do
    [[ "$item" == ".config" ]] && continue
    full_path="$HOME/$item"
    if [[ -e "$full_path" || -L "$full_path" ]]; then
      dest="$run_dir/$item"
      if [[ "$DRY_RUN" == 1 ]]; then
        log "+ backup $full_path -> $dest"
      else
        mkdir -p "$(dirname "$dest")"
        if [[ -L "$full_path" ]]; then
          local real_path
          real_path="$(readlink -f "$full_path")"
          info "Backing up symlink target $real_path -> $dest"
          cp -a "$real_path" "$dest"
          echo "symlink-target $full_path -> $real_path stored at $dest" >>"$manifest"
          rm "$full_path"
        else
          info "Backing up $full_path -> $dest"
          echo "move $full_path -> $dest" >>"$manifest"
          mv "$full_path" "$dest"
        fi
      fi
    fi
  done

  if [[ "$DRY_RUN" == 1 ]]; then
    log "+ (cd $STOW_ROOT && stow -t $HOME .)"
  else
    (cd "$STOW_ROOT" && stow -t "$HOME" .)
    success "Stow complete. Backups in $run_dir"
  fi
}

# Restore mode needs no network, sudo, or packages — just identity + stow.
preflight_lite() {
  stage "Preflight (restore)"
  [[ "${EUID:-$(id -u)}" -ne 0 ]] || error "Do not run as root. Run as your user."
  command -v stow >/dev/null 2>&1 || error "stow not found, cannot unstow."
  [[ -d "$STOW_ROOT" ]] || error "Stow root not found: $STOW_ROOT"
  [[ -d "$BACKUP_BASE" ]] || error "No backups found in $BACKUP_BASE."
}

# Prints the selected backup run dir. Empty RESTORE = latest by mtime.
resolve_restore_dir() {
  local dir
  if [[ -n "$RESTORE" ]]; then
    dir="$BACKUP_BASE/$RESTORE"
    [[ -d "$dir" ]] || error "Backup run not found: $dir"
  else
    dir="$(find "$BACKUP_BASE" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2- || true)"
    [[ -n "$dir" && -d "$dir" ]] || error "No backup runs found in $BACKUP_BASE."
  fi
  [[ -f "$dir/MANIFEST.log" ]] || error "MANIFEST.log missing in $dir, cannot restore safely."
  printf '%s\n' "$dir"
}

restore_run() {
  stage "Restore"
  local run_dir manifest count restored=0 skipped=0
  run_dir="$(resolve_restore_dir)"
  manifest="$run_dir/MANIFEST.log"
  count="$(grep -cvE '^[[:space:]]*(#|$)' "$manifest" || true)"
  info "Restoring backup run $(basename "$run_dir") ($count recorded items)..."
  confirm "Unstow repo configs and move backups back from $(basename "$run_dir")?" || {
    warn "Restore skipped by user."
    return 0
  }

  if [[ "$DRY_RUN" == 1 ]]; then
    log "+ (cd $STOW_ROOT && stow -D -t $HOME .)"
  else
    (cd "$STOW_ROOT" && stow -D -t "$HOME" .)
  fi

  local line src dst link target copy rest
  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      \#* | "") continue ;;
    esac
    if [[ "$line" == move\ * ]]; then
      # Format: move $HOME/<item> -> $run_dir/<item>  (reverse it)
      rest="${line#move }"
      src="${rest%% -> *}"
      dst="${rest#* -> }"
      if [[ -e "$src" || -L "$src" ]]; then
        warn "SKIP: $src already exists, leaving backup in place."
        skipped=$((skipped + 1))
      elif [[ "$DRY_RUN" == 1 ]]; then
        log "+ mv $dst $src"
        restored=$((restored + 1))
      else
        mkdir -p "$(dirname "$src")"
        mv "$dst" "$src"
        info "Restored $src"
        restored=$((restored + 1))
      fi
    elif [[ "$line" == symlink-target\ * ]]; then
      # Format: symlink-target $HOME/<item> -> <real_path> stored at $run_dir/<item>
      rest="${line#symlink-target }"
      link="${rest%% -> *}"
      rest="${rest#* -> }"
      target="${rest%% stored at *}"
      copy="${rest#* stored at }"
      if [[ -e "$link" || -L "$link" ]]; then
        warn "SKIP: $link already exists, leaving backup in place."
        skipped=$((skipped + 1))
      elif [[ -n "$target" && -e "$target" ]]; then
        if [[ "$DRY_RUN" == 1 ]]; then
          log "+ ln -s $target $link"
        else
          mkdir -p "$(dirname "$link")"
          ln -s "$target" "$link"
          info "Rebuilt symlink $link -> $target"
        fi
        restored=$((restored + 1))
      elif [[ -e "$copy" ]]; then
        warn "$target is gone; restoring content copy as regular file."
        if [[ "$DRY_RUN" == 1 ]]; then
          log "+ mv $copy $link"
        else
          mkdir -p "$(dirname "$link")"
          mv "$copy" "$link"
          info "Restored $link (content copy)"
        fi
        restored=$((restored + 1))
      else
        warn "SKIP: neither target nor backup copy exists for $link."
        skipped=$((skipped + 1))
      fi
    else
      warn "SKIP: unrecognized manifest line: $line"
      skipped=$((skipped + 1))
    fi
  done <"$manifest"

  # NOTE: edits made through repo symlinks after stowing live in the repo
  # working tree and are untouched by restore (recover via git if committed).
  success "Restore complete: $restored restored, $skipped skipped. Run dir kept at $run_dir"
  return 0
}

post_services() {
  stage "Services + shell"
  info "Enabling services + shell..."
  if command -v xdg-user-dirs-update >/dev/null 2>&1; then
    run xdg-user-dirs-update || warn "xdg-user-dirs-update failed."
  fi

  if command -v zsh >/dev/null 2>&1; then
    local zsh_path
    zsh_path="$(command -v zsh)"
    if [[ "${SHELL:-}" != "$zsh_path" ]]; then
      info "Setting default shell to $zsh_path (needs password, non-fatal on failure)..."
      if [[ "$DRY_RUN" == 1 ]]; then
        log "+ chsh -s $zsh_path"
      else
        chsh -s "$zsh_path" || record_error "chsh failed; run manually: chsh -s $zsh_path"
      fi
    fi
  fi

  local svc
  for svc in NetworkManager bluetooth sddm power-profiles-daemon thermald cups vnstat; do
    if systemctl cat "$svc" >/dev/null 2>&1 || systemctl cat "$svc.service" >/dev/null 2>&1; then
      run sudo systemctl enable --now "$svc" || record_error "Failed to enable $svc."
    else
      info "Service $svc not installed, skipping."
    fi
  done

  if systemctl --user cat syncthing.service >/dev/null 2>&1; then
    run systemctl --user enable --now syncthing || record_error "Failed to enable user syncthing."
  fi
}

post_toolchains() {
  stage "Toolchains"
  # yazi plugins track dotfiles/.config/yazi/package.toml.
  if command -v ya >/dev/null 2>&1; then
    info "Installing yazi plugins (ya pkg install)..."
    if [[ "$DRY_RUN" == 1 ]]; then
      log "+ ya pkg install"
    else
      ya pkg install || record_error "yazi plugin install failed."
    fi
  else
    info "ya not found, skipping yazi plugins (available after opening yazi)."
  fi
}

validate() {
  stage "Validate"
  info "Runtime tally: $ERROR_COUNT error(s), $WARN_COUNT warning(s) — see $LOG_FILE"
  if [[ "$ERROR_COUNT" == 0 ]]; then
    success "Setup complete. Backups: $BACKUP_BASE | Log: $LOG_FILE | Reboot now to apply changes."
  else
    warn "Setup finished with $ERROR_COUNT error(s) needing attention ($WARN_COUNT warning(s) noted). See $LOG_FILE"
  fi
  if [[ "$DRY_RUN" == 0 ]]; then
    if gum confirm "Reboot now?" --default=true 2>/dev/null; then
      sudo systemctl reboot
    fi
  fi
  [[ "$ERROR_COUNT" == 0 ]]
}

main() {
  if [[ "$RESTORE" != "__unset__" ]]; then
    preflight_lite
    restore_run
    return 0
  fi
  preflight
  if [[ "$NO_PACKAGES" == 0 ]]; then
    ensure_cachyos_repos
    system_update
    install_packages
    setup_flatpak
  else
    info "Skipping packages (--no-packages)."
  fi
  if [[ "$NO_STOW" == 0 ]]; then
    do_stow
  else
    info "Skipping stow (--no-stow)."
  fi
  post_services
  post_toolchains
  validate
}

main "$@"
