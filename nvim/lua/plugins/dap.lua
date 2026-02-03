return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
      {
        "<leader>b",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ui setup
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      local mason_nvim_dap = require("mason-nvim-dap")
      local registry = require("mason-registry")

      mason_nvim_dap.setup({
        ensure_installed = { "codelldb", "python", "delve" },
        automatic_installation = true,
        handlers = {
          function(config)
            mason_nvim_dap.default_setup(config)
          end,
          python = function(config)
            mason_nvim_dap.default_setup(config)

            local ok, dap_python = pcall(require, "dap-python")
            if not ok then
              return
            end

            local success, debugpy = pcall(registry.get_package, "debugpy")
            if not success then
              return
            end

            local install_path = debugpy:get_install_path()
            local python_path = install_path .. "/venv/bin/python"
            dap_python.setup(python_path)
          end,
        },
      })

      local ok, dap_go = pcall(require, "dap-go")
      if ok then
        dap_go.setup()
      end

      --------------------------------------
      --- clang
      --------------------------------------
      dap.configurations.c = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") -- select compiled files
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      --------------------------------------
      --- c++
      --------------------------------------
      dap.configurations.cpp = dap.configurations.c

      --------------------------------------
      --- python
      --------------------------------------
      dap.configurations.python = dap.configurations.python or {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          justMyCode = false,
        },
      }
    end,
  },
}
