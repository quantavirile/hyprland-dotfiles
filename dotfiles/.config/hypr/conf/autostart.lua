-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
local apps = require("conf.applications")
hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("swaync")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("hyprctl setcursor Bibata-Morden-Ice 24")
	hl.exec_cmd("sleep 30; megasync")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("awatcher")
	hl.exec_cmd("sleep 30; aw-notify start")
	hl.exec_cmd("walker --gapplication-service")
	hl.exec_cmd("sleep 30; safeeyes")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("syncthing serve --no-browser --logfile=default")
	hl.exec_cmd("docker start bgutil-provider")
	hl.exec_cmd("superproductivity")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("hyprpm reload")
	hl.exec_cmd("gnome-keyring-daemon --start")
	hl.exec_cmd("udiskie --smart-tray &")
	hl.exec_cmd("cachy-update --tray")
	hl.exec_cmd("elephant")
	hl.exec_cmd("kdeconnect-indicator&!")
	hl.exec_cmd("env GDK_BACKEND=x11 thunderbird")
	-- Libs
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("/usr/lib/kdeconnectd&!")
	hl.exec_cmd("/usr/local/libexec/file_manager_dbus")
	-- Scripts
	hl.exec_cmd("~/.config/hyprland-dotfiles/scripts/listeners.sh --startall")
	hl.exec_cmd("~/.config/hypr/scripts/wallpaper-restore.sh")
	hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")
	hl.exec_cmd("bash ~/.config/hyprland-dotfiles/scripts/safeeyes-media-afk.sh")
end)
