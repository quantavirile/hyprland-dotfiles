-------------------
---- GESTURES ----
-------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/

-- Workspaces
hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "workspace",
})

-- Scrolling
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "scroll_move",
	scale = 0.9,
})

-- Fullscreen on
hl.gesture({
	fingers = 4,
	direction = "up",
	action = function()
		hl.dispatch(hl.dsp.window.fullscreen({ action = "set" }))
	end,
})

-- Fullscreen off
hl.gesture({
	fingers = 4,
	direction = "down",
	action = function()
		hl.dispatch(hl.dsp.window.fullscreen({ action = "unset" }))
	end,
})
