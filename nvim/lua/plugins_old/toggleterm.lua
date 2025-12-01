return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>t1", "<cmd>ToggleTerm id=1<cr>", desc = "Terminal 1", mode = { "n", "t" } },
      { "<leader>t2", "<cmd>ToggleTerm id=2<cr>", desc = "Terminal 2", mode = { "n", "t" } },
      { "<leader>t3", "<cmd>ToggleTerm id=3<cr>", desc = "Terminal 3", mode = { "n", "t" } },
      { "<leader>tt", "<cmd>ToggleTerm id=1<cr>", desc = "Default Terminal 1", mode = { "n", "t" } },
    },
    config = function()
      require("toggleterm").setup({
        size = 15,
        direction = "horizontal",
        persist_size = true,
        persist_mode = true,
        shade_terminals = false,
        start_in_insert = true,
      })
    end,
  },
}
