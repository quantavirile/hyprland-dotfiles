# Repository Structure (full)

This file contains the full repository tree and notes for maintainers. Keep `SKILL.md` brief; agents should read this file for detailed layout when needed.

```
hyprland-dotfiles/
├── dotfiles/           # Stow root — mirrors $HOME layout
│   ├── .config/        # App configs (hypr, waybar, kitty, nvim, etc.)
│   ├── .zshrc          # Zsh config
│   └── ...             # Other dotfiles at $HOME root
├── deploy.sh           # Full stow: backs up existing → stow -t ~ .
├── packages-arch       # Arch Linux package list
└── .agents/            # Skill bundles and metadata (also readable via .opencode, .claude)
    └── skills/
        ├── dotfiles-manager/
        └── dotfiles-commit/
```

Notes:

- `dotfiles/` is the stow source tree; run `stow -t ~ .` from within `dotfiles/` (use `./deploy.sh` instead of running `stow` manually).
- `deploy.sh` creates timestamped backups of existing files before stowing — check its output to find backup locations.
- `packages-arch` lists packages useful when provisioning an Arch system for this config.

Recommended usage for agents/humans:

- Use `ls -la ~/.zshrc` and `ls -la ~/.config/<app>` to confirm symlinks before editing.
- When adding a new app, follow the steps in `SKILL.md` under "Step 5 — Add new app to repo".
