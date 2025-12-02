return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    ft = { "scala", "sbt", "java" }, -- Load when .scala file are opend
    config = function()
      local metals_config = require("metals").bare_config()

      -- 1. 基本設定
      metals_config.settings = {
        showImplicitArguments = true,
        showInferredType = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

      -- init_options (for scala3)
      metals_config.init_options.statusBarProvider = "off"

      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()

        local map = vim.keymap.set
        map("n", "<leader>mc", function()
          require("telescope").extensions.metals.commands()
        end, { desc = "Metals commands" })
        map("n", "<leader>mi", function()
          require("metals").commands("MetalsOrganizeImports")
        end, { desc = "Metals Organize Imports" })
      end

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}
