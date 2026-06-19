if vim.fn.has("mac") == 1 then
  local homebrew_bin = "/opt/homebrew/bin"
  if not string.find(vim.env.PATH, homebrew_bin, 1, true) then
    vim.env.PATH = homebrew_bin .. ":" .. vim.env.PATH
  end
end

require("config.options")
require("config.keymaps")
require("config.lazy")

-- Apply the droid-black colorscheme after all dependencies are loaded.
require("config.colorscheme").setup()
