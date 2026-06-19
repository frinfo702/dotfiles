return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = { ui = { border = "rounded" } },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ruff",
        "clangd",
      },
      automatic_installation = true,
      handlers = {
        function(server_name)
          local servers_skip = { "lua_ls" }
          if not vim.tbl_contains(servers_skip, server_name) then
            require("lspconfig")[server_name].setup({})
          end
        end,
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          })
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
          vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
          vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
  {
    "Saghen/blink.cmp",
    build = function()
      require("blink.cmp").build():pwait()
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "saghen/blink.lib",
    },
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        menu = { auto_show = true, border = "rounded", winhighlight = "Normal:NormalFloat" },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      signature = { enabled = true },
    },
  },
}
