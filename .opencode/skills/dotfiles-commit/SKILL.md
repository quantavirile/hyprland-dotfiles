---
name: dotfiles-commit
description: Stage and commit changes using Conventional Commits
license: MIT
---

## Commit Convention

This repo uses Conventional Commits: `type: message`

- `feat:` — new functionality or config
- `fix:` — bug fix
- `refactor:` — restructuring without functional change
- `docs:` — documentation only
- `chore:` — maintenance, tooling, housekeeping, file removals/deletions
- `revert:` — revert a previous change

Keep the message concise: `type: what changed`.
- Prefer single-line messages (no body) unless a multi-line message adds meaningful context
- For batch changes across multiple files, mention features concisely without "to X" qualifiers
  (e.g. `feat: add cava, GTK, btop, and rmpc theme switching`)
- Use only valid types from the list above — never invent custom types like `clean:`
- Always show the user the proposed commit message and ask if it's okay before committing
Do not ask the user for a commit message — analyze the diff, propose one, and ask for approval.

## Workflow

### Commit with chunk awareness

When asked to commit changes, analyze chunks to decide grouping.

**Step 1 — Check tracked changes**
```bash
git diff                     # unstaged changes
git diff --cached            # staged changes
git diff --stat              # file list only
```

Only tracked files are considered. Untracked files are handled separately.

**Step 2 — Analyze chunks per file**
For each changed file, examine the hunks in the diff:
- Hunks in the same function/block/concern → **related**
- Hunks in different concerns (e.g., changing colors AND keybinds in same file) → **unrelated**

**Step 3 — Determine grouping strategy**

| Scenario | Strategy |
|----------|----------|
| Single file, all hunks related | One commit |
| Single file, unrelated hunks | Commit per hunk group |
| Multiple files, all hunks across files related | One commit |
| Multiple files, similar hunks across files | Group similar hunks together, commit separately |
| Multiple files, hunks only in a subset | Shared hunks → one commit; subset-only hunks → separate commit |
| Multiple files, unrelated hunks | Commit per file / per hunk group |

**Step 4 — Present to user**
Show proposed grouping with explanation:
- What hunks are similar/different
- Which files are grouped together and why
- Ask: *"Commit this as 'type: message'? [y/n]"*

**Step 5 — Stage and commit**
```bash
git add <file1> <file2>      # explicit paths only, never git add .
git commit -m "type: message"
```
- If unrelated hunks are mixed in the same git hunk (contiguous lines), `git add -p` can't split them.
  Instead: temporarily edit the file to remove unrelated lines, stage + commit, then restore the
  unrelated lines and commit them separately.

**Example scenarios:**

- *Single file, one concern:* `btop.conf` changes theme → single commit
- *Single file, mixed:* `theme.sh` changes cava + GTK + btop → commit per concern
- *Multiple files, same concern:* All 4 `theme.sh` scripts adding btop → one commit
- *Multiple files, subset hunks:* cava/GTK/btop/rmpc across all 4 theme scripts → commit 1; rofi only in modern/transparent → commit 2
- *Multiple files, mixed:* `btop.conf` theme change + `config.ron` cava change → two commits

## Auto-generated files

These files are written by matugen (color/template engine) or its post-hooks.
Changes to them are automatic, not manual — skip them when presenting tracked changes:

- `dotfiles/.config/hypr/colors.conf`
- `dotfiles/.config/hypr/colors.lua`
- `dotfiles/.config/waybar/colors.css`
- `dotfiles/.config/rofi/colors.rasi`
- `dotfiles/.config/gtk-3.0/colors.css`
- `dotfiles/.config/gtk-4.0/colors.css`
- `dotfiles/.config/wlogout/colors.css`
- `dotfiles/.config/swaync/colors.css`
- `dotfiles/.config/cava/themes/matugen`
- `dotfiles/.config/btop/themes/matugen.theme`
- `dotfiles/.config/kitty/colors-matugen.conf`
- `dotfiles/.config/rmpc/themes/matugen.ron`
- `dotfiles/.config/hyprland-dotfiles/colors/`
- `dotfiles/.config/fuzzel/colors.ini`
- `dotfiles/.config/yazi/flavors/matugen.yazi/flavor.toml`
- `dotfiles/.config/starship/starship-matugen.toml`

These files are modified by theme scripts (side effects of theme switching), not manually:

- `dotfiles/.config/gtk-3.0/gtk.css`
- `dotfiles/.config/gtk-3.0/settings.ini`
- `dotfiles/.config/gtk-4.0/gtk.css`
- `dotfiles/.config/gtk-4.0/settings.ini`
- `dotfiles/.config/kitty/kitty.conf`
- `dotfiles/.config/xsettingsd/xsettingsd.conf`
- `dotfiles/.gtkrc-2.0`
- `dotfiles/.config/yazi/theme.toml`
- `dotfiles/.config/hypr/scripts/keybindings.sh`
- `dotfiles/.config/hyprland-dotfiles/settings/fuzzel-border`
- `dotfiles/.config/hyprland-dotfiles/scripts/cliphist.sh`

When checking changes, filter these out:

```bash
git diff --stat -- . \
  ':(exclude)dotfiles/.config/hypr/colors.conf' \
  ':(exclude)dotfiles/.config/hypr/colors.lua' \
  ':(exclude)dotfiles/.config/waybar/colors.css' \
  ':(exclude)dotfiles/.config/rofi/colors.rasi' \
  ':(exclude)dotfiles/.config/gtk-3.0/colors.css' \
  ':(exclude)dotfiles/.config/gtk-4.0/colors.css' \
  ':(exclude)dotfiles/.config/wlogout/colors.css' \
  ':(exclude)dotfiles/.config/swaync/colors.css' \
  ':(exclude)dotfiles/.config/cava/themes/matugen' \
  ':(exclude)dotfiles/.config/btop/themes/matugen.theme' \
  ':(exclude)dotfiles/.config/kitty/colors-matugen.conf' \
  ':(exclude)dotfiles/.config/rmpc/themes/matugen.ron' \
  ':(exclude)dotfiles/.config/hyprland-dotfiles/colors/' \
  ':(exclude)dotfiles/.config/fuzzel/colors.ini' \
  ':(exclude)dotfiles/.config/yazi/flavors/matugen.yazi/flavor.toml' \
  ':(exclude)dotfiles/.config/starship/starship-matugen.toml' \
  ':(exclude)dotfiles/.config/gtk-3.0/gtk.css' \
  ':(exclude)dotfiles/.config/gtk-3.0/settings.ini' \
  ':(exclude)dotfiles/.config/gtk-4.0/gtk.css' \
  ':(exclude)dotfiles/.config/gtk-4.0/settings.ini' \
  ':(exclude)dotfiles/.config/kitty/kitty.conf' \
  ':(exclude)dotfiles/.config/xsettingsd/xsettingsd.conf' \
  ':(exclude)dotfiles/.gtkrc-2.0' \
  ':(exclude)dotfiles/.config/yazi/theme.toml' \
  ':(exclude)dotfiles/.config/hypr/scripts/keybindings.sh' \
  ':(exclude)dotfiles/.config/hyprland-dotfiles/settings/fuzzel-border' \
  ':(exclude)dotfiles/.config/hyprland-dotfiles/scripts/cliphist.sh'
```

Do not suggest staging or committing these files unless the user explicitly asks.

## Notes

- If a file was deleted, stage the deletion: `git rm <file>`
- If a file was renamed, use `git mv <old> <new>` — it stages both sides automatically
- If unsure about grouping, ask the user before staging
- This workflow only considers tracked files. Untracked files are identified and staged separately

- **Use `git add -p`** (per-hunk) instead of `git add <file>` when a file has unrelated hunks.
  Staging a whole file is error-prone — it will commit unintended changes that belong elsewhere.
  Always verify staged content with `git diff --cached` before committing.
