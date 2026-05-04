#!/bin/bash

REPO_URL="https://github.com/quantavirile/hyprland-dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# # Clone repo if ~/dotfiles doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning hyprland-dotfiles repo..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
  echo "Repository cloned to $DOTFILES_DIR"
else
  echo "$DOTFILES_DIR already exists. Backing up existing directory and cloning hyprland-dotfiles repo..."
  mv $DOTFILES_DIR "${DOTFILES_DIR}-backup-${TIMESTAMP}"
  git clone "$REPO_URL" "$DOTFILES_DIR"
  echo "Repository cloned to $DOTFILES_DIR"
fi

# # Detect distro and install packages
if [ -f /etc/os-release ]; then
  . /etc/os-release

  PACKAGES_FILE="$DOTFILES_DIR/packages-$ID.txt"

  if [ ! -f "$PACKAGES_FILE" ]; then
    echo "✗ No package file found for $ID"
    exit 1
  fi

  case "$ID" in
  arch)
    echo "Installing packages for Arch..."
    sudo pacman -S $(cat "$PACKAGES_FILE" | tr '\n' ' ') --needed --noconfirm
    ;;
  fedora)
    echo "Installing packages for Fedora..."
    sudo dnf install $(cat "$PACKAGES_FILE" | tr '\n' ' ') -y
    ;;
  debian | ubuntu)
    echo "Installing packages for Debian/Ubuntu..."
    sudo apt install $(cat "$PACKAGES_FILE" | tr '\n' ' ') -y
    ;;
  *)
    echo "Unsupported distro: $ID"
    exit 1
    ;;
  esac
fi

Backup existing configs that stow will manage
if [ -e "$HOME/.testrc" ]; then
  echo "Backing up existing .testrc to .testrc.bak"
  mv "$HOME/.testrc" "$HOME/.testrc.bak"
fi

if [ -e "$HOME/.config/matugen" ]; then
  echo "Backing up existing .config/matugen to .config/matugen.bak"
  mv "$HOME/.config/matugen" "$HOME/.config/matugen.bak"
fi

# Dynamically discover items that stow will manage
mapfile -t STOW_ITEMS < <(cd "$DOTFILES_DIR/dotfiles" && find . -maxdepth 2 \( -type f -o -type d \) ! -name "." | sed 's|^\./||' | sort)

# Check and back up each item
for item in "${STOW_ITEMS[@]}"; do
  full_path="$HOME/$item"

  # Skip .config directory in top-level per instructions
  if [ "$item" = ".config" ]; then
    echo "Skipping .config (top-level) as per instructions"
    continue
  fi

  if [ -e "$full_path" ]; then
    echo "Found: $full_path"

    base_name=$(basename "$full_path")

    # Determine if it's a file or directory
    if [ -d "$full_path" ]; then
      # It's a directory
      backup_name="${base_name}-backup-${TIMESTAMP}"
    else
      # It's a file
<<<<<<< HEAD
      backup_name="${item}-backup-${TIMESTAMP}"
=======
      backup_name="${base_name}-backup-${TIMESTAMP}"
>>>>>>> 4706998 (Updates)
    fi

    # Get the parent directory
    parent_dir=$(dirname "$full_path")
    backup_path="$parent_dir/$backup_name"

    echo "  Backing up to: $backup_path"
    mv "$full_path" "$backup_path"
  else
    echo "Not found: $full_path"
  fi
done

echo "Backup complete"

# Stow dotfiles
cd "$DOTFILES_DIR/dotfiles" || exit 1
stow -t ~ .
echo "Installation complete"
