return {
  -- config内で colorscheme() を呼ばないように注意してください（自動管理と競合するため）
  -- Don't call colorscheme() within config (It can be competitive with auto-manager)

  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_foreground = "material"
    end,
  },

  { "nyoom-engineering/oxocarbon.nvim", priority = 1000 },
  { "folke/tokyonight.nvim", priority = 1000 },
  { "rebelot/kanagawa.nvim", priority = 1000 },

  {
    "dapovich/anysphere.nvim",
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
}
