-- Cross-instance yank ability,
require("session"):setup({
	sync_yanked = true,
})

require("full-border"):setup()

require("recycle-bin"):setup()

require("starship"):setup({
	config_file = "~/.config/starship/starship-catppuccin.toml",
})

-- Always show device selection
-- require("kdeconnect-send"):setup({
--     auto_select_single = false,
-- })

-- Show symlink in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)
