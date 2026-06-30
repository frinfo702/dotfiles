if vim.fn.has("mac") == 1 then
  local homebrew_bin = "/opt/homebrew/bin"
  if not string.find(vim.env.PATH, homebrew_bin, 1, true) then
    vim.env.PATH = homebrew_bin .. ":" .. vim.env.PATH
  end
end

require("config.options")
require("config.keymaps")
require("config.lazy")

-- Apply droid-black (black background only, everything else default).
require("config.droid-black").setup()

-- :Nigga command - お祭り絵文字が飛び出る
require("config.nigga-party")

-- :Manko command - パチンコ確定演出
require("config.manko")
