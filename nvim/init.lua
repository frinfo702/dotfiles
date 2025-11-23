-- if vim.fn.has("mac") == 1 then
--   local homebrew_bin = "/opt/homebrew/bin"
--   if not string.find(vim.env.PATH, homebrew_bin, 1, true) then
--     vim.env.PATH = homebrew_bin .. ":" .. vim.env.PATH
--   end
-- end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Neovim起動時にPATHを拡張
-- vim.env.PATH = vim.env.PATH .. ":/opt/homebrew/bin"

vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "j", "gj")
vim.keymap.set("i", "k", "gk")
