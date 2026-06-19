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
    opts = {
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
        if vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 256 * 1024 then
          return nil
        end
        return {
          timeout_ms = 1000,
          lsp_fallback = true,
        }
      end,
      formatters = {
        prettierd = {
          condition = function()
            return vim.fn.executable("prettierd") == 1
          end,
        },
        eslint_d = {
          condition = function()
            return vim.fn.executable("eslint_d") == 1
          end,
        },
      },
    },
  },
}
