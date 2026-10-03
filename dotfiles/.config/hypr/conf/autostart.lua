-- Reference: https://wiki.hypr.land/Configuring/Basics/Autostart/

---- AUTOSTART ----

hl.on("hyprland.start", function()
	local HOME = os.getenv("HOME")

	-- Environment Variables, Security, and Utilities
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("gnome-keyring-daemon --start")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("hyprctl setcursor Bibata-Morden-Ice 24")
	hl.exec_cmd(HOME .. "/.config/hypr/scripts/gtk.sh")
	hl.exec_cmd("hyprpm reload")

	-- System Daemons
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("/usr/lib/kdeconnectd")
	hl.exec_cmd("snappy-switcher --daemon")

	-- Desktop Shell
	hl.exec_cmd("swaync")
	hl.exec_cmd(HOME .. "/.config/hyprland-dotfiles/scripts/wallpaper/wallpaper-restore.sh")
	hl.exec_cmd(HOME .. "/.config/hyprland-dotfiles/scripts/listeners.sh --startall")
	hl.exec_cmd(HOME .. "/.config/waybar/launch.sh")
	hl.exec_cmd(HOME .. "/.config/nwg-dock-hyprland/launch.sh")

	-- Application Services
	hl.exec_cmd("elephant")
	hl.exec_cmd("walker --gapplication-service")
	hl.exec_cmd("/usr/local/libexec/file_manager_dbus")
	-- hl.exec_cmd("syncthing serve --no-browser --logfile=default")
	hl.exec_cmd("sleep 3 && docker start bgutil-provider")

	-- Tray Indicaors
	hl.exec_cmd("udiskie --smart-tray")
	-- hl.exec_cmd("blueman-applet")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("kdeconnect-indicator")
	hl.exec_cmd("cachy-update --tray")
	hl.exec_cmd("sleep 2 && awatcher")
	hl.exec_cmd("sleep 2 && jamesdsp -t")
	hl.exec_cmd("sleep 3 && safeeyes")
	hl.exec_cmd("sleep 3 && megasync")
end)
