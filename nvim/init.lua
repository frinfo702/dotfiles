-- Neovim起動時にPATHを拡張
if vim.fn.has("mac") == 1 then
  local homebrew_bin = "/opt/homebrew/bin"
  if not string.find(vim.env.PATH, homebrew_bin, 1, true) then
    vim.env.PATH = homebrew_bin .. ":" .. vim.env.PATH
  end
end

-- bootstrap lazy.nvim, LazyVim and your plugins

require("config.options")
require("config.keymaps")
require("config.lazy")
