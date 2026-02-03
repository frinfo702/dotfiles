return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "stevanmilic/neotest-scala",
      "rouge8/neotest-rust",
    },
    keys = function()
      local neotest = require("neotest")
      return {
        { "<leader>tt", function() neotest.run.run() end, desc = "Test nearest" },
        { "<leader>tT", function() neotest.run.run(vim.fn.getcwd()) end, desc = "Test workspace" },
        { "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, desc = "Test file" },
        { "<leader>ts", function() neotest.summary.toggle() end, desc = "Toggle summary" },
        { "<leader>to", function() neotest.output.open({ enter = true }) end, desc = "Show output" },
        { "<leader>tO", function() neotest.output_panel.toggle() end, desc = "Toggle output panel" },
        { "<leader>tS", function() neotest.run.stop() end, desc = "Stop test" },
        { "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, desc = "Debug nearest" },
      }
    end,
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-python")({
            runner = "pytest",
            dap = { justMyCode = false },
          }),
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
          }),
          require("neotest-scala")({
            args = { "test" },
          }),
          require("neotest-rust")({
            args = { "--nocapture" },
          }),
        },
        diagnostic = { enabled = true },
        quickfix = {
          enabled = true,
          open = function()
            if not require("neotest.utils").is_test_suite_running() then
              vim.cmd("copen")
            end
          end,
        },
        running = {
          concurrent = true,
        },
        summary = {
          open = "botright vsplit | vertical resize 40",
        },
      })
    end,
  },
}
