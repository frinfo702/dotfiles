-- lua/plugins/go.lua
-- Minimal, error-free Go setup for LazyVim without extras.
-- Components: Treesitter, gopls (LSP), Conform (format), nvim-lint (lint), nvim-dap-go (debug)

return {
  -- 1) Treesitter parsers for Go
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      for _, lang in ipairs({ "go", "gomod" }) do
        if not vim.tbl_contains(opts.ensure_installed, lang) then
          table.insert(opts.ensure_installed, lang)
        end
      end
      return opts
    end,
  },

  -- 2) Make sure Go tools are installed via Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      local tools = {
        -- LSP
        "gopls",
        -- Debugger
        "delve",
        -- Formatters
        "gofumpt",
        "goimports",
        -- Linter
        "golangci-lint",
      }
      for _, t in ipairs(tools) do
        if not vim.tbl_contains(opts.ensure_installed, t) then
          table.insert(opts.ensure_installed, t)
        end
      end
      return opts
    end,
  },

  -- 3) LSP: gopls with sensible defaults
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          -- gopls settings: https://tip.golang.org/gopls/settings
          settings = {
            gopls = {
              gofumpt = true, -- format style
              staticcheck = true, -- extra analyses powered by staticcheck
              analyses = {
                unusedparams = true,
                unreachable = true,
                nilness = true,
              },
              hints = {
                rangeVariableTypes = true,
                parameterNames = true,
                constantValues = true,
                compositeLiteralFields = true,
              },
              -- If your monorepo is big, bump these if you see "package not found"
              directoryFilters = { "-node_modules" },
            },
          },
        },
      },
    },
  },

  -- 4) Formatting: Conform (on save) → gofumpt then goimports
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- Run gofumpt first, then goimports to fix imports.
      opts.formatters_by_ft.go = { "gofumpt", "goimports" }

      -- Respect any global LazyVim setting, but ensure Go formats on save.
      -- If you already set format_on_save elsewhere, this won't fight it.
      opts.format_on_save = opts.format_on_save
        or function(bufnr)
          -- async formatting keeps editing snappy; increase timeout for big files
          return { lsp_fallback = true, async = true, timeout_ms = 5000 }
        end

      return opts
    end,
  },

  -- 5) Linting: nvim-lint with golangci-lint
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts = opts or {}
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.go = { "golangcilint" }

      -- Optional: re-run linter on write/leave/insert changes.
      -- Safe and quiet if you already have similar autocommands.
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
        group = vim.api.nvim_create_augroup("GoNvimLint", { clear = true }),
        pattern = "*.go",
        callback = function()
          require("lint").try_lint()
        end,
      })

      return opts
    end,
  },

  -- 6) Debugging: nvim-dap-go (uses Delve)
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-go").setup()

      -- Handy keymaps (only when editing Go)
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.add({
          { "<leader>d", group = "debug" },
          {
            "<leader>dt",
            function()
              require("dap-go").debug_test()
            end,
            desc = "Debug nearest test",
            mode = "n",
            ft = "go",
          },
          {
            "<leader>dl",
            function()
              require("dap-go").debug_last()
            end,
            desc = "Debug last test",
            mode = "n",
            ft = "go",
          },
        })
      else
        vim.keymap.set("n", "<leader>dt", function()
          require("dap-go").debug_test()
        end, { desc = "Debug nearest test", silent = true })
        vim.keymap.set("n", "<leader>dl", function()
          require("dap-go").debug_last()
        end, { desc = "Debug last test", silent = true })
      end
    end,
  },
}
