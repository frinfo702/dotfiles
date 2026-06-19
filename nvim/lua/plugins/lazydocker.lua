return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      direction = "float",
      float_opts = { border = "rounded" },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      local lazydocker = Terminal:new({
        cmd = "lazydocker",
        hidden = true,
        direction = "float",
      })

      vim.keymap.set("n", "<leader>do", function()
        lazydocker:toggle()
      end, { desc = "LazyDocker" })
    end,
  },
}
