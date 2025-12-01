return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard" -- "medium", "soft", "hard"
      vim.g.gruvbox_material_foreground = "material"
    end,
  },
  { "nyoom-engineering/oxocarbon.nvim", name = "oxocarbon" },
  { "folke/tokyonight.nvim", name = "tokyonight" },
  { "Mofiqul/vscode.nvim", name = "vscode" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "rebelot/kanagawa.nvim", name = "kanagawa" },
  { "tiesen243/vercel.nvim", name = "vercel" },
  { "dapovich/anysphere.nvim", name = "anysphere" },
  { "alexanderbluhm/black.nvim", name = "black" },
}
