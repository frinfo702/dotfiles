-- lua/plugins/python.lua
-- Python setup for LazyVim that prioritizes Astral tools (uv, ruff, ruff-lsp).
-- No `require("uv")` (Neovim exposes libuv as vim.uv / vim.loop).

return {
  -- 1) LSP (Pyright + Ruff LSP), using uvx so no local pip install needed
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig = require("lspconfig")

      -- helper: select python from a project venv if present (uv creates .venv by default)
      local function project_python()
        local cwd = (vim.uv or vim.loop).cwd()
        local venv_dir = vim.fs.find({ ".venv", "venv" }, { path = cwd, upward = true, type = "directory" })[1]
        if venv_dir and vim.fn.has("win32") == 0 then
          return venv_dir .. "/bin/python"
        elseif venv_dir then
          return venv_dir .. "\\Scripts\\python.exe"
        end
        return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python"
      end

      opts.servers = opts.servers or {}

      -- Ruff LSP: diagnostics + code actions (no hovers/completion)
      opts.servers.ruff_lsp = {
        mason = false, -- don't auto-install via Mason
        cmd = { "uvx", "ruff-lsp" }, -- run with uvx
        init_options = { settings = {} }, -- use pyproject.toml / ruff.toml if present
        on_attach = function(client, _)
          -- let Pyright provide hover; Ruff LSP doesn't need to
          client.server_capabilities.hoverProvider = false
        end,
      }

      -- Pyright: completion, goto, type checking
      opts.servers.pyright = {
        mason = false,
        cmd = { "pyright-langserver", "--stdio" },
        settings = {
          python = {
            pythonPath = project_python(),
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
            },
          },
        },
      }

      -- (Optional) if LazyVim tries to auto-enable basedpyright/ruff by extras, keep them off
      for _, s in ipairs({ "basedpyright", "ruff" }) do
        opts.servers[s] = vim.tbl_deep_extend("force", opts.servers[s] or {}, { enabled = false })
      end

      -- actually register (needed if user disabled automatic lspconfig setup)
      lspconfig.ruff_lsp.setup(opts.servers.ruff_lsp)
      lspconfig.pyright.setup(opts.servers.pyright)
    end,
  },

  -- 2) Formatting with Ruff (via uvx) through conform.nvim (LazyVim's default formatter)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- prefer Ruff's formatter for Python
      opts.formatters_by_ft.python = { "ruff_format" }

      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        ruff_format = {
          command = "uvx",
          args = { "ruff", "format", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
      })
    end,
  },

  -- 3) nvim-lint: let Ruff LSP handle diagnostics; keep lint empty for Python
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.python = {} -- diagnostics come from ruff-lsp
    end,
  },
}
