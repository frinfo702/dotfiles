-- ~/.config/nvim/lua/plugins/javascript.lua
return {
  -- Treesitter: JS/TS を確実に入れる
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "javascript",
        "jsdoc",
      })
    end,
  },

  -- Lint: eslint_d を JS 系に割当て
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        -- TS 側にも効かせたい人は typescript.lua にも同様に書く（重複OK）
      })
    end,
  },

  -- Format: conform.nvim で prettier / biome を条件付きで
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local util = require("conform.util")
      -- 既存設定にマージ
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascript = { "biome_or_prettier" },
        javascriptreact = { "biome_or_prettier" },
        json = { "biome_or_prettier" },
        jsonc = { "biome_or_prettier" },
      })

      -- biome があれば biome、なければ prettier/prettierd を使う
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        biome_or_prettier = {
          condition = function(ctx)
            -- プロジェクトルートに biome 設定がある？
            return util.root_file({
              "biome.json",
              "biome.jsonc",
            })(ctx)
          end,
          -- condition が true のときは biome、false のときは prettier 系へフォールバック
          inherit = false,
          command = "biome",
          args = { "format", "--stdin-file-path", "$FILENAME" },
          stdin = true,
          timeout_ms = 30000,
          -- フォールバック（biome が無い場合）
          fallback_formatter = { "prettierd", "prettier" },
        },
      })

      -- LazyVim の自動フォーマット方針を壊さない（公式注意点）
      -- https://www.lazyvim.org/plugins/formatting
    end,
  },
}
