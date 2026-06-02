---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local hyprScripts = "~/.config/hypr/scripts"
local dotfileScripts = "~/.config/hyprland-dotfiles/scripts"

-- Applications
hl.bind(
	mainMod .. " + RETURN",
	hl.dsp.exec_cmd("~/.config/hyprland-dotfiles/settings/terminal.sh"),
	{ description = "Open the terminal" }
)
hl.bind(
	mainMod .. " + B",
	hl.dsp.exec_cmd("~/.config/hyprland-dotfiles/settings/browser.sh"),
	{ description = "Open the browser" }
)
hl.bind(
	mainMod .. " + E",
	hl.dsp.exec_cmd("~/.config/hyprland-dotfiles/settings/filemanager.sh"),
	{ description = "Open the filemanager" }
)
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker"), { description = "Pick color" })
hl.bind(
	mainMod .. " + CTRL + C",
	hl.dsp.exec_cmd("~/.config/hyprland-dotfiles/settings/calculator.sh"),
	{ description = "Open the calculator" }
)
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("gnome-calendar"), { description = "Open the calendar" })
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd("gnome-clocks"), { description = "Open the clock" })
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd("waypaper"), { description = "Open waypaper wallpaper switcher" })

-- Display
hl.bind(
	mainMod .. " + SHIFT + mouse_down",
	hl.dsp.exec_cmd(
		[[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}")]]
	),
	{ description = "Increase display zoom" }
)
hl.bind(
	mainMod .. " + SHIFT + mouse_up",
	hl.dsp.exec_cmd(
		[[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}")]]
	),
	{ description = "Decrease display zoom" }
)
hl.bind(
	mainMod .. " + SHIFT + Z",
	hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1"),
	{ description = "Reset display zoom" }
)

-- Windows
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Kill active window" })
hl.bind(
	mainMod .. " + SHIFT + Q",
	hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"),
	{ description = "Quit active window and all open instances" }
)
hl.bind(
	mainMod .. " + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen" }),
	{ description = "Set active window to fullscreen" }
)
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Maximize window" })
hl.bind(
	mainMod .. " + T",
	hl.dsp.window.float({ action = "toggle" }),
	{ description = "Toggle active windows into floating mode" }
)
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }), { description = "Move focus left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }), { description = "Move focus right" })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }), { description = "Move focus up" })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }), { description = "Move focus down" })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window with the mouse" })
hl.bind(
	mainMod .. " + mouse:273",
	hl.dsp.window.resize(),
	{ mouse = true, description = "Resize window with the mouse" }
)
hl.bind(
	mainMod .. " + SHIFT + right",
	hl.dsp.window.resize({ x = 100, y = 0, relative = true }),
	{ description = "Increase window width with keyboard" }
)
hl.bind(
	mainMod .. " + SHIFT + left",
	hl.dsp.window.resize({ x = -100, y = 0, relative = true }),
	{ description = "Reduce window width with keyboard" }
)
hl.bind(
	mainMod .. " + SHIFT + down",
	hl.dsp.window.resize({ x = 0, y = 100, relative = true }),
	{ description = "Increase window height with keyboard" }
)
hl.bind(
	mainMod .. " + SHIFT + up",
	hl.dsp.window.resize({ x = 0, y = -100, relative = true }),
	{ description = "Reduce window height with keyboard" }
)
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { description = "Toggle window group" })
hl.bind(mainMod .. " + K", hl.dsp.layout("swapsplit"), { description = "Swapsplit" })
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "l" }), { description = "Swap tiled window left" })
hl.bind(
	mainMod .. " + ALT + right",
	hl.dsp.window.swap({ direction = "r" }),
	{ description = "Swap tiled window right" }
)
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "u" }), { description = "Swap tiled window up" })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "d" }), { description = "Swap tiled window down" })
hl.bind("ALT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.bring_to_top())
end, { description = "Cycle between windows and bring active to top" })
hl.bind(mainMod .. " + period", hl.dsp.layout("move +col"), { description = "Move window right in scrolling layout" })
hl.bind(mainMod .. " + comma", hl.dsp.layout("move -col"), { description = "Move window left in scrolling layout" })
hl.bind(
	mainMod .. " + ALT + comma",
	hl.dsp.layout("swapcol l"),
	{ description = "Swap column left in scrolling layout" }
)
hl.bind(mainMod .. " + ALT + M", hl.dsp.layout("fit active"), { description = "Fit active window" })
hl.bind("SUPER + H", hl.dsp.window.move({ workspace = "special" }), { description = "Move window to scratchpad" })
hl.bind("SUPER + CTRL + Tab", hl.dsp.exec_cmd("cycle-layout"), { description = "Cycle to next layout" })
hl.bind(
	"SUPER + SHIFT + CTRL + Tab",
	hl.dsp.exec_cmd("cycle-layout --prev"),
	{ description = "Cycle to previous layout" }
)

-- Actions
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Reload Hyprland configuration" })
hl.bind(
	mainMod .. " + SHIFT + A",
	hl.dsp.exec_cmd(hyprScripts .. "/toggle-animations.sh"),
	{ description = "Toggle animations" }
)
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd(hyprScripts .. "/screenshot.sh"), { description = "Take a screenshot" })
hl.bind(
	mainMod .. " + ALT + F",
	hl.dsp.exec_cmd(hyprScripts .. "/screenshot.sh --instant"),
	{ description = "Take an instant full-screen screenshot" }
)
hl.bind(
	mainMod .. " + ALT + S",
	hl.dsp.exec_cmd(hyprScripts .. "/screenshot.sh --instant-area"),
	{ description = "Take an instant area screenshot" }
)
hl.bind(
	mainMod .. " + ALT + A",
	hl.dsp.exec_cmd(hyprScripts .. "/text-extractor.sh"),
	{ description = "Extract text from an area" }
)
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd(dotfileScripts .. "/wlogout.sh"), { description = "Start wlogout" })
hl.bind(
	mainMod .. " + SHIFT + W",
	hl.dsp.exec_cmd(dotfileScripts .. "/wallpaper/wallpaper.sh --random"),
	{ description = "Change the wallpaper" }
)
hl.bind(
	mainMod .. " + ALT + W",
	hl.dsp.exec_cmd(dotfileScripts .. "/wallpaper/wallpaper-automation.sh"),
	{ description = "Start random wallpaper script" }
)
hl.bind(
	mainMod .. " + SPACE",
	hl.dsp.exec_cmd(hyprScripts .. "/launcher.sh"),
	{ description = "Open application launcher" }
)
hl.bind(
	mainMod .. " + ALT + SPACE",
	hl.dsp.exec_cmd(dotfileScripts .. "/launcher-switcher.sh"),
	{ description = "Switch launcher" }
)
hl.bind(
	mainMod .. " + CTRL + K",
	hl.dsp.exec_cmd(hyprScripts .. "/keybindings.sh"),
	{ description = "Show keybindings" }
)
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/.config/waybar/launch.sh"), { description = "Reload waybar" })
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("~/.config/waybar/toggle.sh"), { description = "Toggle waybar" })
hl.bind(
	mainMod .. " + SHIFT + R",
	hl.dsp.exec_cmd(hyprScripts .. "/loadconfig.sh"),
	{ description = "Reload hyprland config" }
)
hl.bind(
	mainMod .. " + V",
	hl.dsp.exec_cmd(dotfileScripts .. "/cliphist.sh"),
	{ description = "Open clipboard manager" }
)
hl.bind(
	mainMod .. " + CTRL + T",
	hl.dsp.exec_cmd("~/.config/waybar/themeswitcher.sh"),
	{ description = "Open waybar theme switcher" }
)
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd(hyprScripts .. "/gamemode.sh"), { description = "Toggle game mode" })
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(hyprScripts .. "/power.sh lock"), { description = "Lock screen" })
hl.bind(
	mainMod .. " + SHIFT + H",
	hl.dsp.exec_cmd(hyprScripts .. "/hyprshade.sh"),
	{ description = "Toggle hyprshade" }
)
hl.bind(
	"CTRL + ALT + T",
	hl.dsp.exec_cmd("~/.config/hyprland-dotfiles/themes/themes.sh"),
	{ description = "Select Hyprland theme" }
)
hl.bind(
	mainMod .. " + SHIFT + M",
	hl.dsp.exec_cmd(dotfileScripts .. "/toggle-theme.sh"),
	{ description = "Toggle light/dark theme" }
)
hl.bind(
	"SUPER + P",
	hl.dsp.exec_cmd(dotfileScripts .. "/mpv-pip.sh"),
	{ description = "Toggle mpv picture-in-picture" }
)
hl.bind(
	mainMod .. " + U",
	hl.dsp.exec_cmd(dotfileScripts .. "/dusky_wayclick.sh"),
	{ description = "Toggle key press sounds" }
)

-- Workspaces
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Open workspace " .. i })
	hl.bind(
		mainMod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move active window to workspace " .. i }
	)
	hl.bind(
		mainMod .. " + CTRL + " .. key,
		hl.dsp.exec_cmd(hyprScripts .. "/moveTo.sh " .. i),
		{ description = "Move all windows to workspace " .. i }
	)
end

hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "m+1" }), { description = "Open next workspace" })
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }), { description = "Open previous workspace" })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Open next workspace" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Open previous workspace" })
hl.bind(
	mainMod .. " + CTRL + down",
	hl.dsp.focus({ workspace = "empty" }),
	{ description = "Open the next empty workspace" }
)

-- Fn keys
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("swayosd-client --brightness +5"),
	{ repeating = true, description = "Increase brightness" }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("swayosd-client --brightness -5"),
	{ repeating = true, description = "Reduce brightness" }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume +2"),
	{ locked = true, repeating = true, description = "Increase volume" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume -2"),
	{ locked = true, repeating = true, description = "Reduce volume" }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
	{ locked = true, description = "Toggle mute" }
)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Audio play pause" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { description = "Audio pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Audio next" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Audio previous" })
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"),
	{ description = "Toggle microphone" }
)
-- hl.bind("XF86Calculator", hl.dsp.exec_cmd("~/.config/hyprland-dotfiles/settings/calculator.sh"), { description = "Open calculator" })
-- hl.bind("XF86Lock", hl.dsp.exec_cmd("hyprlock"), { description = "Open screenlock" })
