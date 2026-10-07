# hyprland-dotfiles

## Introduction

Welcome to my personal Hyprland dotfiles repository.

This setup is tailored for high performance, minimalist aesthetics, and maximum productivity for a keyboard and terminal driven workflow.

> [!WARNING]
> Highly opinionated personal dotfiles, tuned to my workflow and hardware.
>
> Take these as a **source of inspiration, not a 1:1 copy**. I did the same
> with the projects listed under [Credits](#Credits). Blindly using
> someone's dotfiles is how you end up with keybinds you
> hate and services you don't understand.

## Stack

| Role          | Choice   |
| ------------- | -------- |
| Bar           | waybar   |
| Notifications | swaync   |
| Launcher      | walker   |
| Terminal      | kitty    |
| Shell         | zsh      |
| Prompt        | starship |
| Editor        | neovim   |
| File manager  | yazi     |
| Theming       | matugen  |

## Requirements

- **Arch Linux or an Arch-based distro** (CachyOS, EndeavourOS, …).
- **Tested only on a minimal Arch Linux install.** Other derivatives are
  accepted on a best-effort basis.
- Of course, internet.

## Installation

```bash
git clone https://github.com/quantavirile/hyprland-dotfiles.git
cd hyprland-dotfiles
./setup.sh
```

| Flag                    | Effect                                                   |
| ----------------------- | -------------------------------------------------------- |
| `-y, --yes`             | Skip all prompts (defaults: `yay`, full package list)    |
| `--dry-run`             | Print every mutating command, change nothing             |
| `--no-packages`         | Skip repos, update, packages, Flatpak                    |
| `--no-stow`             | Skip the stow stage                                      |
| `--minimal`             | Install `packages-arch-minimal` instead of the full list |
| `--restore [timestamp]` | Revert a backup run (latest when [timestamp] omitted)    |

## Safety nets

- **Backups:** conflicts move to timestamped dirs under
  `~/.local/share/state/hyprland-dotfiles/backups/` (with `MANIFEST.log`).
- **Logs:** per-run logs under `~/.local/state/hyprland-dotfiles/logs/`
  (`latest.log` → newest).

## Restore / uninstall

Revert configs to a previous backup run:

```bash
./setup.sh --restore [timestamp]
```

With no timestamp it restores the latest run: repo symlinks are removed,
backed-up files moved back, and replaced symlinks rebuilt. Occupied
destinations are skipped, never overwritten. The used backup dir is kept.

> [!CAUTION]
> Restore covers **configs only**. Installed packages (system, AUR,
> Flatpak), the AUR helper, CachyOS repos, and shell/service changes stay
> in place. Remove packages manually and selectively — bulk-removing the
> package list will also remove critical system components and leave the system broken.

## Credits

These configs are my extensive effort of discovering and sourcing dotfiles repos that align with my workflow. Below are projects that inspired this setup:

- https://github.com/mylinuxforwork/dotfiles
  the structure of these configs and several scripts adapted from this project.

More sources will be credited here as they get absorbed.

Like I did, take what's useful and leave the rest.
