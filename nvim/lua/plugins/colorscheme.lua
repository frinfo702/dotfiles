return {
  {
    "rebelot/kanagawa.nvim",
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
}
