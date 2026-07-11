-- Reference: https://wiki.hypr.land/Configuring/Basics/Autostart/

---- AUTOSTART ----

hl.on("hyprland.start", function()
	local HOME = os.getenv("HOME") -- Resolve home dir in Lua; avoids shell ~ expansion

	-- Wallpaper daemon
	hl.exec_cmd("awww-daemon") -- Animated wallpaper daemon for Wayland

	-- Notifications & idle
	hl.exec_cmd("swaync") -- Notification center
	hl.exec_cmd("hypridle") -- Idle management daemon

	-- Clipboard
	hl.exec_cmd("wl-paste --watch cliphist store") -- Cache clipboard history

	-- Cursor
	hl.exec_cmd("hyprctl setcursor Bibata-Morden-Ice 24") -- Set cursor theme

	-- Application launcher
	hl.exec_cmd("elephant") -- Walker launcher data provider
	hl.exec_cmd("walker --gapplication-service") -- App launcher frontend

	-- Health & well-being
	hl.exec_cmd("sleep 3 && safeeyes") -- Eye break reminder (delayed)
	hl.exec_cmd("hyprsunset") -- Blue light filter

	-- Sync & storage
	hl.exec_cmd("syncthing serve --no-browser --logfile=default") -- File sync daemon
	hl.exec_cmd("sleep 3 && megasync") -- Cloud sync (delayed)
	hl.exec_cmd("docker start bgutil-provider") -- yt-dlp PO Token provider (bypass YouTube bot detection)

	-- Productivity
	hl.exec_cmd("superproductivity") -- Time tracking app
	hl.exec_cmd("awatcher") -- ActivityWatch watcher
	-- hl.exec_cmd("sleep 3 && aw-notify start") -- ActivityWatch notifications (delayed)

	-- Desktop integration
	hl.exec_cmd("swayosd-server") -- On-screen display daemon
	hl.exec_cmd("hyprpm reload") -- Reload Hyprland plugins
	hl.exec_cmd("gnome-keyring-daemon --start") -- Unlock keyring for apps
	hl.exec_cmd("udiskie --smart-tray &") -- Auto-mount removable drives
	hl.exec_cmd("kdeconnect-indicator") -- KDE Connect system tray indicator
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- Export env to systemd

	-- Hardware / system
	hl.exec_cmd("blueman-applet") -- Bluetooth tray
	hl.exec_cmd("nm-applet --indicator") -- Network manager tray
	hl.exec_cmd("snappy-switcher --daemon") -- Alt+Tab window switcher daemon for Hyprland
	hl.exec_cmd("jamesdsp") -- Audio equalizer

	-- hl.exec_cmd("env GDK_BACKEND=x11 thunderbird") -- Thunderbird with X11 backend

	-- System services
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1") -- Polkit auth agent
	hl.exec_cmd("cachy-update --tray") -- CachyOS update notifier
	hl.exec_cmd("/usr/lib/kdeconnectd") -- KDE Connect daemon
	hl.exec_cmd("/usr/local/libexec/file_manager_dbus") -- File manager DBus service

	-- User scripts
	hl.exec_cmd(HOME .. "/.config/hyprland-dotfiles/scripts/listeners.sh --startall") -- Start event listeners
	hl.exec_cmd(HOME .. "/.config/waybar/launch.sh") -- Status bar
	hl.exec_cmd(HOME .. "/.config/hyprland-dotfiles/scripts/wallpaper/wallpaper-restore.sh") -- Restore wallpaper
	hl.exec_cmd(HOME .. "/.config/hypr/scripts/gtk.sh") -- Load GTK settings
	hl.exec_cmd(HOME .. "/.config/hyprland-dotfiles/scripts/safeeyes-media-afk.sh") -- SafeEyes media AFK hook
end)
