## Config Anatomy

## Config Anatomy — Entry-point Roadmap

This file is an agent-friendly roadmap of entry points for configs stored in the `dotfiles/` tree. It covers both per-app directories under `dotfiles/.config/` and top-level dotfiles at the repo root (e.g. `.zshrc`, `.Xresources`, `.gtkrc-2.0`). For each item: `Location`, `Entrypoints` (files to open first), `Reload` (command to apply changes, or `none`), `Quick checks` (copyable commands), and short `Notes`.

### Waybar

- Location: `dotfiles/.config/waybar/`
- Entrypoints: `launch.sh`, `modules.json`, `themes/<name>/style.css`
- Reload: `~/.config/waybar/launch.sh` (restarts waybar)
- Quick checks:

```bash
ls -la ~/.config/waybar/style.css
cat dotfiles/.config/waybar/launch.sh | sed -n '1,120p'
```

- Notes: edit theme files or `modules.json` in-repo; preserve CSS/JSON formatting.

### Hyprland (Lua-first)

- Location: `dotfiles/.config/hypr/`
- Entrypoints: `hyprland.lua`, `conf/theme.lua`, `conf/keybinds.lua`, `conf/windowrules.lua`
- Reload: `hyprctl reload`
- Quick checks:

```bash
ls -la ~/.config/hypr/hyprland.lua
hyprctl activewindow || true
```

- Notes: repo is Lua-first. Edit `conf/*.lua` modules. Legacy `.conf` files may exist for deploy compatibility but are not primary.

### Kitty

- Location: `dotfiles/.config/kitty/`
- Entrypoints: `kitty.conf`, `themes/*` files
- Reload: `kill -SIGUSR1 $(pidof kitty)`
- Quick checks:

```bash
ls -la ~/.config/kitty/kitty.conf
```

### Zsh

- Location: `dotfiles/.zshrc`, `dotfiles/.zshrc.d/`
- Entrypoints: `.zshrc`, files under `.zshrc.d/`
- Reload: `source ~/.zshrc` (manual)
- Quick checks:

```bash
ls -la ~/.zshrc
grep -n "source .*\.zshrc.d" dotfiles/.zshrc || true
```

### Neovim

- Location: `dotfiles/.config/nvim/`
- Entrypoints: `init.lua`, `lua/config/lazy.lua`, `lua/plugins/`
- Reload: none (restart Neovim or use plugin reloads)
- Quick checks:

```bash
ls -la dotfiles/.config/nvim/init.lua
```

### MPV

- Location: `dotfiles/.config/mpv/`
- Entrypoints: `mpv.conf`, `input.conf`, `scripts/`
- Reload: none (restart mpv)
- Quick checks:

```bash
ls -la ~/.config/mpv/mpv.conf
```

### MPD

- Location: `dotfiles/.config/mpd/`
- Entrypoints: `mpd.conf`
- Reload: `systemctl --user restart mpd` (if run as user service)
- Quick checks:

```bash
ls -la ~/.config/mpd/mpd.conf
```

### Waypaper

- Location: `dotfiles/.config/waypaper/`
- Entrypoints: `config.ini`, `keybindings.ini`
- Reload: `waypaper` CLI or restart wallpaper helper
- Quick checks:

```bash
ls -la ~/.config/waypaper/config.ini
```

### Wlogout

- Location: `dotfiles/.config/wlogout/`
- Entrypoints: `layout`, `style.css`
- Reload: none (restart wlogout session as needed)

### Rofi

- Location: `dotfiles/.config/rofi/`
- Entrypoints: `config.rasi`, theme files
- Reload: none (restart rofi invocation)

### Swaync

- Location: `dotfiles/.config/swaync/`
- Entrypoints: CSS files and config
- Reload: `swaync-client --reload-css` or `swaync-client --reload-config`

### Starship

- Location: `dotfiles/.config/starship/`
- Entrypoints: `starship.toml`
- Reload: `exec $SHELL` or `source ~/.zshrc`

### Misc small apps (quick list)

- `bat`: `dotfiles/.config/bat/config`
- `btop`: `dotfiles/.config/btop/config`
- `cava`: `dotfiles/.config/cava/config`
- `fuzzel`: `dotfiles/.config/fuzzel/config`
- `gdu`: `dotfiles/.config/gdu/config`
- `yazi`: `dotfiles/.config/yazi/` (renderer styles)
- `yt-dlp`: `dotfiles/.config/yt-dlp/` (download configs)

---

### Top-level repo dotfiles

These files live at the root of `dotfiles/` and are commonly symlinked directly to `$HOME`.

- `.zshrc`
  - Location: `dotfiles/.zshrc`
  - Entrypoints: `.zshrc`, files in `dotfiles/.zshrc.d/`
  - Reload: `source ~/.zshrc` — run manually or restart shell
  - Quick checks:

  ```bash
  ls -la ~/.zshrc
  head -n 60 dotfiles/.zshrc
  ```

- `.Xresources`
  - Location: `dotfiles/.Xresources`
  - Entrypoints: `.Xresources`
  - Reload: `xrdb ~/.Xresources`
  - Quick checks:

  ```bash
  ls -la ~/.Xresources
  xrdb -query | head -n 50
  ```

- `.gtkrc-2.0`
  - Location: `dotfiles/.gtkrc-2.0`
  - Entrypoints: `.gtkrc-2.0`
  - Reload: none (GTK2 apps read on startup)
  - Quick checks:

  ```bash
  ls -la ~/.gtkrc-2.0
  ```

- `.fzfrc`
  - Location: `dotfiles/.fzfrc`
  - Entrypoints: `.fzfrc`
  - Reload: none (read by fzf/fzf-based launchers)
  - Quick checks:
  ```bash
  ls -la ~/.fzfrc
  ```

Guidance for agents

- Use `Entrypoints` to decide which files to open first.
- Run `Quick checks` before making edits; if checks fail, run `./deploy.sh` and re-check.
- Prefer small, targeted reload commands rather than restarting the whole session.
- If an app has complex anatomy, ask the user before making risky changes.
