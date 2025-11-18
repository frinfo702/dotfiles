return {
  {
    "folke/tokyonight.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      light_style = "day",
      transparent = false,
    },
  },
  {
    "Mofiqul/vscode.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {
      -- Cursor Dark に寄せるなら dark を基本に微調整
      -- style = "dark",  -- 必要なら明示
      italic_comments = true,
      underline_links = true,
      terminal_colors = true,
      -- ここでUIの境界やフロートのコントラストを微調整
      group_overrides = function(c)
        return {
          WinSeparator = { fg = "#2b2b2b" },
          VertSplit = { fg = "#2b2b2b" },
          FloatBorder = { fg = "#3a3a3a" },
          NormalFloat = { bg = "#1e1e1e" },
        }
      end,
    },
    config = function(_, opts)
      local vs = require("vscode")
      if type(opts.group_overrides) == "function" then
        local c = require("vscode.colors").get_colors()
        opts.group_overrides = opts.group_overrides(c)
      end
      vs.setup(opts)
      vim.cmd.colorscheme("vscode")
    end,
  },
  {
    "rose-pine/neovim",
    enabled = false,
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    name = "kanagawa",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "wave", -- select from "wave", "dragon", "lotus"
        background = {
          dark = "wave",
          light = "lotus",
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  {
    "tiesen243/vercel.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("vercel").setup({
        theme = "dark",
        -- ここに他のオプションを書く場合はコンマを忘れずに
      })
      vim.cmd.colorscheme("vercel")
    end,
  },
  {
    "dapovich/anysphere.nvim",
    enabled = false,
    config = function()
      require("anysphere").setup({
        -- your options
      })
    end,
  },
}
