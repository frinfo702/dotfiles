-- ghostty-dark -- Minimal: black background only, Neovim defaults for everything else.

local M = {}

local function setup_editor_ui()
  vim.api.nvim_set_hl(0, "Normal",      { bg = "#000000" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
  vim.api.nvim_set_hl(0, "NormalNC",    { bg = "#000000" })
end

function M.setup()
  vim.cmd("hi clear")
  if vim.g.colors_name then vim.cmd("hi clear") end
  vim.g.colors_name = "ghostty-dark"
  setup_editor_ui()
end

return M