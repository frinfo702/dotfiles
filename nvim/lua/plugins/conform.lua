-- lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = { lsp_format = "prefer", timeout_ms = 2000 },
    -- no explicit formatter for scala -> Conform will call Metals' LSP formatter
  },
}
