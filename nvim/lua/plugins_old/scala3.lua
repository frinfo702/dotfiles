-- lua/plugins/scala.lua
vim.env.JAVA_HOME = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"

return {
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      local metals = require("metals")
      local metals_config = metals.bare_config()

      -- nice defaults
      metals_config.settings = {
        showImplicitArguments = true,
        showInferredType = true,
      }
      metals_config.init_options = { statusBarProvider = "on" }

      -- cmp capabilities if you use nvim-cmp in LazyVim
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        metals_config.capabilities = cmp_lsp.default_capabilities()
      end

      metals_config.on_attach = function()
        -- DAP support
        metals.setup_dap()
      end

      -- start/attach Metals automatically
      local grp = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          metals.initialize_or_attach(metals_config)
        end,
        group = grp,
      })
    end,
  },

  -- treesitter: get Scala highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" then
        table.insert(opts.ensure_installed, "scala")
      end
    end,
  },
}
