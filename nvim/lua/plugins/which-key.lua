return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      win = {
        border = "rounded",
        padding = { 2, 2, 2, 2 },
      },
      layout = {
        spacing = 6,
      },
      icons = {
        group = "",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.add({
        { "<leader>c", group = "Code", mode = "n" },
        { "<leader>d", group = "Debug", mode = "n" },
        { "<leader>g", group = "Git", mode = "n" },
        { "<leader>t", group = "Test", mode = "n" },
        { "<leader>s", group = "Search", mode = "n" },
      })
    end,
  },
}
