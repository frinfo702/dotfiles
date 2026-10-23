if vim.fn.has("mac") == 1 then
  local homebrew_bin = "/opt/homebrew/bin"
  if not string.find(vim.env.PATH, homebrew_bin, 1, true) then
    vim.env.PATH = homebrew_bin .. ":" .. vim.env.PATH
  end
end

require("config.options")
local settings = require("config.settings")
settings.load()
require("config.plugins")
require("config.lsp").setup()
require("config.ui")
require("config.panel")
require("config.keymaps")
require("config.copy")
settings.apply_all()

-- :Nigga command - お祭り絵文字が飛び出る
require("config.nigga-party")

-- :Manko command - パチンコ確定演出
require("config.manko")
