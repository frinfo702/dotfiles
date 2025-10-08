return {
  {
    "tiesen243/vercel.nvim",
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
