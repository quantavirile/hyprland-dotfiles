-- Show hidden files in Snacks Explorer by default
-- Press `H` in the explorer list to toggle this on/off at runtime.
-- https://github.com/folke/snacks.nvim
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
        },
      },
    },
  },
}
