return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = { "" }

      dashboard.section.buttons.val = {
        dashboard.button("n", " NEW FILE", "<cmd>ene <BAR> startinsert <CR>"),
        dashboard.button("f", " FIND FILE", "<cmd>Telescope find_files<CR>"),
        dashboard.button("g", " LIVE GREP", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("r", " RECENT", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("c", " CONFIG", "<cmd>e $MYVIMRC <CR>"),
        dashboard.button("q", " QUIT", "<cmd>qa<CR>"),
      }

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 3

      require("alpha").setup(dashboard.config)
    end,
  },
}
