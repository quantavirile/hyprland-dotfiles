-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Ensure pnpm-managed binaries are on PATH (for Mason, Copilot, etc.)
local pnpm_bin = vim.fn.expand("$HOME/.local/share/pnpm/bin")
if vim.fn.isdirectory(pnpm_bin) == 1 then
  vim.env.PATH = pnpm_bin .. ":" .. vim.env.PATH
end

-- Show deprecation warnings
vim.g.deprecation_warnings = true

-- Configure Copilot LSP
vim.lsp.enable("copilot")
