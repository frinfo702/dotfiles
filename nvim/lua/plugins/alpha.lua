return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("n", "  New file", "<cmd>ene <BAR> startinsert <CR>"),
        dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
        dashboard.button("g", "  Live Grep", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("r", "  Recent", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("c", "  Config", "<cmd>e $MYVIMRC <CR>"),
        dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
      }

      -- レイアウト設定
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 5 -- 上の余白

      require("alpha").setup(dashboard.config)
    end,
  },
}
