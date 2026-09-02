---
name: dotfiles-commit
description: Stage and commit Hyprland dotfiles changes using Conventional Commits with chunk-aware hunk grouping. Use when user asks to commit, stage, save changes, or mentions git diff/status/commit, conventional commits, or wants to group changes by concern (e.g., cava/GTK/btop).
license: MIT
---

## Commit Convention

This repo uses Conventional Commits: `<type>[optional scope]: <description>`

[optional body]

[optional footer(s)]

- `feat:` — new functionality or config (MINOR)
- `fix:` — bug fix (PATCH)
- `refactor:` — restructuring without functional change
- `docs:` — documentation only
- `chore:` — maintenance, tooling, housekeeping, file removals/deletions
- `style:` — formatting, whitespace, theme tweaks with no logic change
- `revert:` — revert a previous change — include `Refs: <SHA>` footer

Keep description concise: `type[optional scope]: what changed` (50-72 chars). Scope is **optional** — lowercase noun in parens when change is scoped to one area, e.g. `feat(waybar): add cava toggle`, `fix(kitty): correct theme path`, `chore(deps): update yazi plugins`. Omit scope for broad batches across many areas, e.g. `feat: add cava, GTK, btop, and rmpc theme switching`.

Prefer single-line messages; add body after one blank line if context needed, footers after one blank line (`Refs: 676104e`, `Refs: #123`). For rare breaking changes per spec, `!` after type/scope or `BREAKING CHANGE:` / `BREAKING-CHANGE:` footer may be used but is not expected in dotfiles — `!` is only for breaking changes.

Spec allows any type (point 14) and scope optional (point 4), but this repo restricts types to the list above for consistent `git log` — never invent custom types like `clean:` or use bare `feat:` when a scope fits a single-area change. See [Commit Message Template](#commit-message-template).

## Commit Message Template

```text
type[optional scope]: concise what changed
```

Example (scoped): `feat(waybar): add cava toggle`
Example (broad): `feat: add cava, GTK, btop, and rmpc theme switching`
Revert: `revert(kitty): restore theme path` + footer `Refs: 3510085`
Breaking (rare): `feat(waybar)!: drop rofi backend` + footer `BREAKING CHANGE: rofi configs removed, use fuzzel`

For batch changes across multiple files, mention features concisely without "to X" qualifiers.

## Gotchas

- **matugen auto-generates colors.* files** — skip them unless user explicitly asks. Only load `references/auto-generated.md` when `git diff` shows color/theme files; it holds the full exclude list.
- **Contiguous unrelated hunks** — `git add -p` cannot split them. Workaround: temporarily edit file to remove unrelated lines, stage + commit, restore unrelated lines, commit separately.
- **Never `git add .`** — stages auto-generated files and unintended changes.
- **Deleted files** — stage with `git rm <file>`.
- **Renamed files** — use `git mv <old> <new>` (stages both sides).
- **Untracked files** — `git status` lists them; stage separately after tracked workflow.
- **If unsure about grouping** — ask the user before staging.

## Workflow Checklist

Progress:
- [ ] Step 1: Check changes — `bash .agents/skills/dotfiles-commit/scripts/filter-diff.sh --stat` for tracked, `git status` for untracked
- [ ] Step 2: Analyze chunks per file (related vs unrelated hunks)
- [ ] Step 3: Determine grouping strategy (see table below)
- [ ] Step 4: Present grouping + proposed `type[optional scope]: message` to user — ask `Commit this as 'type[optional scope]: message'? [y/n]` before staging
- [ ] Step 5: Stage, commit, and validate (see Staging, Commit & Validation)

## Grouping Strategy

Hunks in same function/block/concern → **related** → one commit; different concerns → **unrelated** → separate. `cava` vs `GTK` vs `btop` vs `rmpc` are different concerns even if diffs look similar.

| Scenario | Strategy | Commit example |
|----------|----------|----------------|
| All hunks share one concern (single or multiple files) | One commit | `feat(waybar): add cava toggle` (single) or broad `feat: add cava, GTK, btop, and rmpc theme switching` (omit scope) |
| Mixed concerns in one or more files | Commit per concern (per hunk group or per file) | `style(waybar): tweak spacing` vs `feat(hypr): update keybind` → separate |
| Subset: shared hunks + subset-only hunks | Shared → one commit; subset-only → separate commit | Shared cava/GTK/btop/rmpc across 4 themes → `feat: ...`; rofi only in modern/transparent → `feat(rofi): add theme` |

## Staging, Commit & Validation

Default: `git add -p` for chunk-aware staging; verify with `git diff --cached`. Only use `git add <path>` without `-p` when all hunks in the file are related.

```bash
git add -p <file1> <file2>      # explicit paths, per-hunk
git diff --cached               # verify staged content
git commit -m "type[optional scope]: message"
```

Validation loop:
1. Stage hunks with `git add -p`
2. Run `git diff --cached` to verify
3. If wrong hunks staged: `git restore --staged -p <file>` (or `git reset -p HEAD <file>` on older git) and re-stage
4. Only when staged content matches intended commit: run `git commit -m "type[optional scope]: message"`
5. Show commit hash and continue with next group

## References

- Full auto-generated file list (load only when diff shows color/theme files): [references/auto-generated.md](references/auto-generated.md)
- Filter script: `bash .agents/skills/dotfiles-commit/scripts/filter-diff.sh [--stat|--diff|--name-only] [--cached]`
