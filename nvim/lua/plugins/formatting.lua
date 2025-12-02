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
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        scala = { "scalafmt" },

        ["_"] = { "trim_whitespace" },
      },

      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
