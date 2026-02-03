return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = function()
      local util = require("conform.util")

      return {
        notify_on_error = true,
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff_format" },
          rust = { "rustfmt" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          scala = { "scalafmt" },
          go = { "goimports", "gofmt" },
          javascript = { "prettierd", "prettier", "eslint_d" },
          typescript = { "prettierd", "prettier", "eslint_d" },
          typescriptreact = { "prettierd", "prettier", "eslint_d" },
          javascriptreact = { "prettierd", "prettier", "eslint_d" },
          json = { "prettierd", "prettier" },
          yaml = { "prettierd", "prettier" },
          markdown = { "prettierd", "prettier", "mdformat" },
          sh = { "shfmt" },
          terraform = { "terraform_fmt" },

          ["_"] = { "trim_whitespace" },
        },

        format_on_save = function(bufnr)
          if util.get_buf_size(bufnr) > 256 * 1024 then
            return nil -- skip huge files
          end
          return {
            timeout_ms = 1000,
            lsp_fallback = true,
          }
        end,

        formatters = {
          prettierd = {
            condition = util.root_file({ ".prettierrc", "package.json", "prettier.config.js" }),
          },
          prettier = {
            env = {
              PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config") .. "/.config/prettier/config.cjs",
            },
          },
          eslint_d = {
            condition = util.root_file({ ".eslintrc", ".eslintrc.js", "package.json" }),
          },
        },
      }
    end,
  },
}
