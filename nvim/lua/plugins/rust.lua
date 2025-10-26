-- ~/.config/nvim/lua/plugins/rust.lua
-- LazyVim + rustaceanvim ベースの安定設定
-- 参考: LazyVim extras/lang/rust と rustaceanvim README を下敷きに、
-- 「二重の rust-analyzer 起動」を避け、Mason あり/なし双方で落ちないように分岐しています。

return {
    -- Rust/RON の Treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "rust", "ron" })
      end,
    },
  
    -- Cargo.toml 支援 (補完/hover/アクション)
    {
      "Saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      opts = {
        completion = { crates = { enabled = true } },
        lsp = { enabled = true, actions = true, completion = true, hover = true },
      },
    },
  
    -- rust-analyzer は rustaceanvim に集約（lspconfig からの重複起動を無効化）
    {
      "neovim/nvim-lspconfig",
      opts = function(_, opts)
        local diagnostics = vim.g.lazyvim_rust_diagnostics or "rust-analyzer"
        opts.servers = opts.servers or {}
        -- rustaceanvim が LSP を担うので lspconfig 側は無効化
        opts.servers.rust_analyzer = { enabled = false }
        -- Bacon を診断に使いたい場合のみ有効化（任意）
        opts.servers.bacon_ls = { enabled = diagnostics == "bacon-ls" }
      end,
    },
  
    -- Mason で codelldb などを入れる場合の指定（任意・ある場合のみ）
    {
      "mason-org/mason.nvim",
      optional = true,
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "codelldb" })
        if (vim.g.lazyvim_rust_diagnostics or "rust-analyzer") == "bacon-ls" then
          vim.list_extend(opts.ensure_installed, { "bacon" })
        end
      end,
    },
  
    -- Rust 本体: rustaceanvim
    {
      "mrcjkb/rustaceanvim",
      version = "^6", -- 破壊的変更を避けるためタグへピン
      ft = { "rust" },
      enabled = function()
        -- rustaceanvim は Neovim >= 0.11 を要求。古い場合は読み込まない（エラー回避）。
        local v = vim.version()
        return (v.major > 0) or (v.major == 0 and v.minor >= 11)
      end,
      opts = function()
        local diagnostics = vim.g.lazyvim_rust_diagnostics or "rust-analyzer"
        return {
          server = {
            on_attach = function(_, bufnr)
              local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
              end
              map("n", "<leader>cR", function()
                vim.cmd.RustLsp("codeAction")
              end, "Rust Code Action")
              map("n", "<leader>dr", function()
                vim.cmd.RustLsp("debuggables")
              end, "Rust Debuggables")
            end,
            default_settings = {
              ["rust-analyzer"] = {
                cargo = {
                  allFeatures = true,
                  loadOutDirsFromCheck = true,
                  buildScripts = { enable = true },
                },
                -- rust-analyzer を診断に使う場合のみ有効（bacon-ls 併用時は無効）
                checkOnSave = diagnostics == "rust-analyzer" and { command = "clippy" } or false,
                diagnostics = { enable = diagnostics == "rust-analyzer" },
                procMacro = { enable = true },
                files = {
                  exclude = {
                    ".direnv", ".git", ".jj", ".github", ".gitlab",
                    "bin", "node_modules", "target", "venv", ".venv",
                  },
                  -- Roots Scanned が固まる既知事象の緩和
                  watcher = "client",
                },
              },
            },
          },
          tools = {
            -- 背景テストを有効にする場合: "background"（任意）
            -- test_executor = "background",
            -- 例: hover アクションを少し使いやすく
            code_actions = { ui_select_fallback = true },
          },
        }
      end,
      config = function(_, opts)
        -- rust-analyzer が PATH にない場合でも、落とさず通知だけにする
        if vim.fn.executable("rust-analyzer") == 0 then
          vim.schedule(function()
            vim.notify(
              "rust-analyzer が見つかりません。rustup でインストールしてください: `rustup component add rust-analyzer`",
              vim.log.levels.WARN,
              { title = "rustaceanvim" }
            )
          end)
        end
  
        -- DAP(codelldb) の自動設定（Mason がある場合のみ、存在チェックつき）
        local ok_reg, registry = pcall(require, "mason-registry")
        if ok_reg then
          local ok_pkg, pkg = pcall(registry.get_package, "codelldb")
          if ok_pkg and pkg:is_installed() then
            local pkg_path = pkg:get_install_path()
            local adapter = require("rustaceanvim.config").get_codelldb_adapter(
              pkg_path .. "/codelldb",
              pkg_path .. "/extension/lldb/lib/liblldb" .. ((vim.uv or vim.loop).os_uname().sysname == "Linux" and ".so" or ".dylib")
            )
            opts.dap = { adapter = adapter }
          end
        end
  
        -- グローバル設定をマージ（他所で定義済みでも上書きしない）
        vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
      end,
    },
  }
  