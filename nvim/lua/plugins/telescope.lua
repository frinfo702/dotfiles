return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>th", "<cmd>Telescope colorscheme<cr>", desc = "Switch Theme" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Search Grep" },
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Search Files" },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { ".git/", "node_modules" },
      },
    },
  },
}
