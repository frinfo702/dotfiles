return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        spelling = {
          enabled = true,
          suggestions = 20,
        },
      },
      window = {
        border = "rounded",
        padding = { 2, 2, 2, 2 },
      },
      layout = {
        spacing = 6,
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.register({
        ["<leader>c"] = { name = "Code" },
        ["<leader>d"] = { name = "Debug" },
        ["<leader>g"] = { name = "Git" },
        ["<leader>t"] = { name = "Test" },
        ["<leader>s"] = { name = "Search" },
      }, { mode = "n" })
    end,
  },
}
