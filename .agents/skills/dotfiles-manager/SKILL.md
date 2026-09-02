---
name: dotfiles-manager
description: Deploy and manage Hyprland dotfiles with GNU Stow — verify and repair stow symlinks, deploy timestamped backups, add or move app configs, and provide reload instructions for Hyprland-related services (Waybar, Kitty, Neovim). Use this skill when editing, adding, or repairing Hyprland dotfiles.
license: MIT
---

## Repository Structure

Short: `dotfiles/` is the stow root (mirrors `$HOME`), `deploy.sh` creates backups and runs `stow -t ~ .`, and `packages-arch` lists Arch packages. See [references/structure.md](references/structure.md) for the full tree and maintainer notes.

## Quickstart

- Check a symlink (example):

```bash
ls -la ~/.config/waybar/style.css
# expect: -> ../dotfiles/.config/waybar/style.css
```

- Deploy (creates timestamped backup then stows):

```bash
./deploy.sh
```

- Verify:

```bash
ls -la ~/.zshrc
# expect: -> ../dotfiles/.zshrc
```

## Prerequisites

- Operating system: Linux desktop (Hyprland-focused)
- Tools: `stow`, `git`, `hyprctl` (for reload), `pidof`, `bash`

## Workflows

Purpose: verify the environment, ensure dotfiles are stowed, make edits safely in-repo, and reload only the necessary services.

1. Environment precheck

- Run the included precheck and fix fatal issues before proceeding:

```bash
./.agents/skills/dotfiles-manager/scripts/check-env.sh
```

2. Verify symlinks (quick)

- Confirm the most-relevant targets are symlinked to `dotfiles/`:

```bash
ls -la ~/.zshrc
ls -la ~/.config/waybar/style.css
```

- If targets are missing or are regular files, do not edit `$HOME` directly. Continue to the deploy step.

3. Deploy if needed

- Run `./deploy.sh` to create timestamped backups and stow the `dotfiles/` tree. Review the script output to locate backups before removing or modifying files.

```bash
./deploy.sh
```

4. Edit in-repo (safe workflow)

- Make all changes inside the `dotfiles/` tree. When symlinks exist, edits are live in `$HOME`.
- Do not commit or push here. Use the `dotfiles-commit` skill (or ask the user to run it) to stage, review, commit, and push changes after verification.

5. Verify & reload

- Verify the edited files are present and, if necessary, reload services selectively (see full mapping in [Config Anatomy — reloads](references/config-anatomy.md#config-anatomy---entry-point-roadmap)):

```bash
hyprctl reload                  # Hyprland config reload
~/.config/waybar/launch.sh      # restart waybar
kill -SIGUSR1 $(pidof kitty)    # reload kitty
```

6. Add new app/config

- Purpose: safely import or add a new application configuration into the stow tree. This is a distinct workflow because it often requires copying live files and removing originals.

- Steps:

- Check whether the target already exists in the repo:

```bash
ls dotfiles/.config/<app> 2>/dev/null || ls dotfiles/.<file> 2>/dev/null
```

- If the app already exists in the repo:
  - Verify the stow state: `ls -la ~/.config/<app>`
    - If it's a symlink to the repo, skip import.
    - If it's a regular file (not stowed), prompt the user before removing the original.

- If importing from the live home config (safe import):

```bash
cp -r ~/.config/<app> dotfiles/.config/    # preserve permissions
git add dotfiles/.config/<app>
```

- Back up and remove the original only after explicit user confirmation:

```bash
# Example — run only after user confirmation
rm -rf ~/.config/<app>
./deploy.sh
```

- Verify the symlink was created and points to the repo:

```bash
ls -la ~/.config/<app>
# expect: -> ../dotfiles/.config/<app>
```

- Do not commit or push here. Use the `dotfiles-commit` skill (or ask the user to run it) to stage, review, commit, and push changes. Agents must not run `git commit` or `git push` directly without explicit user instruction.

## Config Anatomy

Short summary: this skill manages dotfiles for Waybar, Hyprland, Kitty, Zsh, Neovim, and several other app configs under `dotfiles/`. Detailed per-app anatomy, theme systems, and script lists have been moved to a reference file to keep this `SKILL.md` concise.

See [references/config-anatomy.md](references/config-anatomy.md) for full details and examples.

## Constraints

- `~/.config` must be a real directory (never a symlink). `deploy.sh` enforces this guard — do not run it as root unless you understand the implications.
- Verify symlinks before editing. Example verification commands:

```bash
ls -la ~/.config/waybar/style.css
ls -la ~/.zshrc
```

- If a required item is not symlinked to the repo, run `./deploy.sh` to create timestamped backups and re-stow the tree. Check `deploy.sh` output to locate backups before removing or modifying files.
- Edits under `dotfiles/` are live at `$HOME` when stowed. Avoid editing the live `$HOME` copy directly; make changes inside `dotfiles/` and let the symlink reflect them.
- When adding or importing an app config, preserve directory structure and permissions. Use `cp -r` to copy existing files into the `dotfiles/` tree.
- Avoid destructive actions without confirmation. Before deleting any file, check whether it is tracked in git:

```bash
git ls-files <path> || echo "untracked"
```

- If the file is tracked use `git rm <path>` to stage removal; if it is untracked `rm <path>` is sufficient. Agents must prompt users before running `rm -rf` or other destructive commands.
- `stow` will create symlinks with `stow -t ~ .` — ensure no conflicting regular files exist in the target location before running `stow` or `deploy.sh`.
- This skill expects to run as the normal user who owns the dotfiles. Running as `root` may change ownership and break expected behavior.

Recommended quick verifications after deployment or edits:

```bash
ls -la ~/.zshrc            # shows symlink to ../dotfiles/.zshrc
ls -la ~/.config/kitty    # shows symlink to ../dotfiles/.config/kitty
```

If you are unsure, ask for confirmation before making changes that modify or remove user files.

Automated prechecks:

Run the included non-destructive precheck to validate environment and quick symlink state:

```bash
./.agents/skills/dotfiles-manager/scripts/check-env.sh
```

Exit codes: `0` = ok, `1` = warnings (non-fatal), `2` = fatal missing prerequisites.
