-- when launched outside a login shell (GUI, launchd), still find nix-installed tools
local nix_bin = vim.fs.normalize("~/.nix-profile/bin")
if not string.find(vim.env.PATH, nix_bin, 1, true) then
  vim.env.PATH = nix_bin .. ":" .. vim.env.PATH
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
