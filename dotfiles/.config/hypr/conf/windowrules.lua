-- Reference: https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Reference: https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

---- LAYER RULES ----

hl.layer_rule({
	name = "swaync-control-center",
	match = { namespace = "swaync-control-center" },
	blur = true,
	ignore_alpha = 0.5,
	dim_around = true,
})

hl.layer_rule({
	name = "swaync-notifications",
	match = { namespace = "swaync-notification-window" },
	blur = true,
	ignore_alpha = 0.5,
	dim_around = true,
})

hl.layer_rule({
	name = "rofi",
	match = { namespace = "rofi" },
	blur = true,
	dim_around = true,
	ignore_alpha = 0.0,
	no_anim = true,
})

---- WINDOW RULES ----

hl.window_rule({
	name = "pavucontrol",
	match = { class = "(.*org.pulseaudio.pavucontrol.*)" },
	float = true,
	center = true,
	pin = true,
	size = { 700, 600 },
})

hl.window_rule({
	name = "waypaper",
	match = { class = "(.*waypaper.*)" },
	float = true,
	center = true,
	pin = true,
	size = { 900, 700 },
})

hl.window_rule({
	name = "newelle",
	match = { class = "(io.github.qwersyk.Newelle)" },
	float = true,
	center = true,
	pin = true,
	size = { 1000, 700 },
})

hl.window_rule({
	name = "ml4w-sidebar",
	match = { class = "(com.ml4w.sidebar)" },
	float = true,
	move = "monitor_w-window_w-18 91",
	pin = true,
	size = { 400, 660 },
})

hl.window_rule({
	name = "blueman-manager",
	match = { class = "(blueman-manager)" },
	float = true,
	center = true,
	size = { 800, 600 },
})

hl.window_rule({
	name = "nwg-look",
	match = { class = "(nwg-look)" },
	float = true,
	center = true,
	size = { 700, 600 },
})

hl.window_rule({
	name = "missioncenter",
	match = { class = "(io.missioncenter.MissionCenter)" },
	float = true,
	center = true,
	size = { 900, 600 },
})

hl.window_rule({
	name = "hyprland-share-picker",
	match = { class = "(hyprland-share-picker)" },
	float = true,
	pin = true,
	center = true,
	size = { 600, 400 },
})

hl.window_rule({
	name = "nm-connection-editor",
	match = { class = "(nm-connection-editor)" },
	float = true,
	center = true,
	size = { 800, 700 },
})

hl.window_rule({
	name = "dotfiles-floating",
	match = { class = "(dotfiles-floating)" },
	float = true,
	center = true,
	size = { 1000, 700 },
})

hl.window_rule({
	name = "dotfiles-sidepad",
	match = { class = "(dotfiles-sidepad)" },
	float = true,
	pin = true,
	center = true,
	size = { 1000, 700 },
})

hl.window_rule({
	name = "about-mozilla",
	match = { title = "^(About Mozilla.*)" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "about-zen-browser",
	match = { title = "^(About Zen Browser)$" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "junction",
	match = { title = "^(Junction)$" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "DesktopEditors",
	match = { class = "DesktopEditors" },
	center = true,
})

hl.window_rule({
	name = "gnome-calendar",
	match = { class = "org.gnome.Calendar" },
	float = true,
	size = { 360, 600 },
	pin = true,
})

hl.window_rule({
	name = "gnome-clocks",
	match = { class = "org.gnome.clocks" },
	float = true,
	size = { 360, 600 },
	pin = true,
})

hl.window_rule({
	name = "gnome-calculator",
	match = { class = "org.gnome.Calculator" },
	float = true,
	size = { 360, 620 },
	pin = true,
})

hl.window_rule({
	name = "megasync",
	match = { class = "nz.co.mega.megasync" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "youtube",
	match = { title = ".* - YouTube.*" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "firefox",
	match = {
		title = "^(Mozilla Firefox)$|^(New Tab .*)$|.* — Coding — Mozilla Firefox|.* — Work — Mozilla Firefox",
	},
	opacity = 1.0,
})

hl.window_rule({
	name = "loupe",
	match = { class = "org.gnome.Loupe" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "mpv",
	match = { class = "mpv" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "freetube",
	match = { class = "freetube" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "ente",
	match = { class = "ente" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "waydroid",
	match = { class = "Waydroid" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "foliate",
	match = { class = "com.github.johnfactotum.Foliate" },
	opacity = "1.0 override 0.85 override",
})

hl.window_rule({
	name = "calibre-ebook-viewer",
	match = { class = "calibre-ebook-viewer" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "imv",
	match = { class = "imv" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "newsflash",
	match = { class = "io.gitlab.news_flash.NewsFlash" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "onlyoffice",
	match = { class = "ONLYOFFICE" },
	opacity = "1.0 override 1.0 override",
})

hl.window_rule({
	name = "trakt-web-app",
	match = { title = "^(Trakt)$" },
	size = { "(monitor_w*0.7)", "(monitor_h*0.7)" },
	float = true,
})

hl.window_rule({
	name = "waydroid-window",
	match = { class = "Waydroid" },
	size = { 1550, 872 },
	float = true,
	center = true,
})

hl.window_rule({
	name = "picture-in-picture",
	match = { title = "^([Pp]icture[- ][Ii]n[- ][Pp]icture)(.*)$" },
	opacity = 1.0,
	float = true,
	pin = true,
	size = { 640, 320 },
})

hl.window_rule({
	name = "wihotspot",
	match = { class = "wihotspot" },
	float = true,
	center = true,
	size = { 900, 600 },
})

hl.window_rule({
	name = "file-pickers",
	match = { title = "^(Open.*|Save.*)" },
	float = true,
	center = true,
	size = { 800, 600 },
})

hl.window_rule({
	name = "dusky_wayclick",
	match = { class = "^(dusky_wayclick%.sh)$" },
	float = true,
	size = { 831, 572 },
})

hl.window_rule({
	name = "dusky_tui_wayclick",
	match = { class = "^(dusky_tui_wayclick%.sh)$" },
	float = true,
	size = { 780, 510 },
})

hl.window_rule({
	name = "wayclick_soundpacks_download",
	match = { class = "^(wayclick_soundpacks_download%.sh)$" },
	float = true,
	size = { 580, 810 },
})

hl.window_rule({
	name = "superproductivity",
	match = { class = "superproductivity-bin" },
	opacity = "1.0 override 0.85 override",
})
