local colors = require("colors")

hl.config({
	general = {
		gaps_in = 10,
		gaps_out = 20,

		border_size = 1,

		col = {
			active_border = { colors = { colors.primary, colors.on_primary }, angle = 90 },
			inactive_border = colors.on_primary,
		},

		resize_on_border = true,

		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 12,
		rounding_power = 2,

		active_opacity = 0.85,
		inactive_opacity = 0.75,
		fullscreen_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 32,
			render_power = 2,
			color = 0x50000000,
		},

		blur = {
			enabled = true,
			size = 8,
			passes = 3,
			new_optimizations = true,
			ignore_opacity = true,
			vibrancy = 0.2,
		},
	},

	animations = {
		enabled = true,
	},
})
