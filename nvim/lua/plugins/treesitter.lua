return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "bash", "c", "cpp", "lua", "python", "rust", "scala", "vim", "vimdoc", "markdown", "zig", "go"
        },
        highlight = { enable = true }, -- enable highlighting
        indent = { enable = true },    -- enable event
      })
    end,
  }
}
