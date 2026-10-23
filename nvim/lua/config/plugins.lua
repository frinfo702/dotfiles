-- Every plugin lives in this list. Nothing else installs anything:
-- revisions are pinned in nvim-pack-lock.json, and plugins removed from
-- this list are deleted from disk on the next start.
-- Update: :lua vim.pack.update()   (review, then :write to apply)
local S = require("config.settings")

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig", -- server defaults only (cmd, filetypes, root markers)
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") }, -- prebuilt binary
  "https://github.com/stevearc/conform.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/folke/snacks.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/nvim-mini/mini.nvim",
}, { confirm = false })

local orphans = vim
  .iter(vim.pack.get(nil, { info = false }))
  :filter(function(p)
    return not p.active
  end)
  :map(function(p)
    return p.spec.name
  end)
  :totable()
if #orphans > 0 then
  vim.pack.del(orphans)
end

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
require("mini.pairs").setup()
require("mini.diff").setup({
  view = { style = "sign", signs = { add = "▍", change = "▍", delete = "▁" } },
})

require("snacks").setup({
  picker = { ui_select = true },
  explorer = { replace_netrw = true },
  input = {},
  indent = {
    enabled = S.get("ui.indent_guides"),
    indent = { char = "╎" },
    scope = { enabled = false },
    animate = { enabled = false },
  },
  lazygit = {},
})

require("which-key").setup({ preset = "helix", delay = 300 })

require("blink.cmp").setup({
  keymap = { preset = "default" },
  completion = {
    menu = {
      auto_show = function()
        return S.get("lsp.completion_auto")
      end,
    },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
  signature = { enabled = true },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})

require("conform").setup({
  default_format_opts = { lsp_format = "fallback", stop_after_first = true },
  format_on_save = function()
    if S.get("editor.format_on_save") then
      return { timeout_ms = 1000 }
    end
  end,
})
-- read formatters from settings on every lookup, so :Settings / project files apply live
require("conform").formatters_by_ft = setmetatable({}, {
  __index = function(_, ft)
    return S.get("format.by_ft")[ft]
  end,
})

-- Treesitter: helix ships every grammar; here a missing parser is installed
-- the first time its filetype is opened.
vim.filetype.add({ pattern = { [".*%.mongodb"] = "javascript" } })
local available
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang then
      return
    end
    local function start()
      if vim.api.nvim_buf_is_valid(ev.buf) and pcall(vim.treesitter.start, ev.buf, lang) then
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        return true
      end
    end
    if start() then
      return
    end
    available = available or require("nvim-treesitter").get_available()
    if vim.tbl_contains(available, lang) then
      require("nvim-treesitter").install(lang):await(vim.schedule_wrap(start))
    end
  end,
})
