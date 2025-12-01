-- ~/.config/nvim/lua/plugins/typescript.lua
return {
  -- Treesitter: TS/TSX を確実に入れる
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "tsx",
      })
    end,
  },

  -- LSP: vtsls を使う（tsserver/ts_ls は無効化）
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      -- tsserver/ts_ls は無効。LazyVim公式の流儀
      opts.servers.tsserver = { enabled = false }
      opts.servers.ts_ls = { enabled = false }

      opts.servers.vtsls = vim.tbl_deep_extend("force", opts.servers.vtsls or {}, {
        -- JS/TS 両対応にするため filetypes を明示（公式 Extra を踏襲）
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = { enableServerSideFuzzyMatch = true },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
        keys = {
          {
            "gD",
            function()
              local params = vim.lsp.util.make_position_params()
              require("lazyvim.util").lsp.execute({
                command = "typescript.goToSourceDefinition",
                arguments = { params.textDocument.uri, params.position },
                open = true,
              })
            end,
            desc = "Goto Source Definition",
          },
          {
            "gR",
            function()
              require("lazyvim.util").lsp.execute({
                command = "typescript.findAllFileReferences",
                arguments = { vim.uri_from_bufnr(0) },
                open = true,
              })
            end,
            desc = "File References",
          },
          { "<leader>co", require("lazyvim.util").lsp.action["source.organizeImports"], desc = "Organize Imports" },
          {
            "<leader>cM",
            require("lazyvim.util").lsp.action["source.addMissingImports.ts"],
            desc = "Add missing imports",
          },
          {
            "<leader>cu",
            require("lazyvim.util").lsp.action["source.removeUnused.ts"],
            desc = "Remove unused imports",
          },
          { "<leader>cD", require("lazyvim.util").lsp.action["source.fixAll.ts"], desc = "Fix all diagnostics" },
        },
      })

      -- Deno と Node (vtsls) を同居させる人は LazyVim公式の root_dir 切替ロジックを参考に
      -- https://www.lazyvim.org/extras/lang/typescript
    end,
  },

  -- Lint: TS 系にも eslint_d を割当て（必要なら JS 側と重複してOK）
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      })
    end,
  },

  -- Format: JS 側と同じポリシー（Biome>Prettier）
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        typescript = { "biome_or_prettier" },
        typescriptreact = { "biome_or_prettier" },
      })
      -- フォーマッタ定義自体（biome_or_prettier）は javascript.lua で済み
      -- そこが読み込まれていれば共有される
    end,
  },
}
