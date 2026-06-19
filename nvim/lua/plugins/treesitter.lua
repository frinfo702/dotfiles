-- Note: Requires tree-sitter CLI >= 0.26.1 (install via `brew install tree-sitter-cli`).
-- This config targets the rewritten `main` branch, which supports Neovim 0.12+.
local ensure_parsers = {
  "bash",
  "c",
  "cpp",
  "lua",
  "python",
  "rust",
  "scala",
  "vim",
  "vimdoc",
  "markdown",
  "zig",
  "go",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- The new plugin does not support lazy-loading; load at startup.
    init = function()
      -- Install any missing parsers on startup.
      local installed = require("nvim-treesitter.config").get_installed()
      local to_install = vim.iter(ensure_parsers)
        :filter(function(p)
          return not vim.tbl_contains(installed, p)
        end)
        :totable()
      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end

      -- Enable treesitter highlighting for all filetypes (replaces old
      -- highlight = { enable = true } option which no longer exists).
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- Enable experimental treesitter-based indentation.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
