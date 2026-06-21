return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File Tree" },
      { "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus File Tree" },
    },
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf" },
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = {
          enabled = true,
          leave_on_close = false,
        },
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          never_show = { ".DS_Store", "thumbs.db" },
        },
        window = {
          mappings = {
            -- Override default mappings for common operations
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
          },
        },
      },
      buffers = {
        follow_current_file = { enabled = true },
        group_empty_dirs = true,
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",
            ["d"] = "buffer_delete",
          },
        },
      },
      git_status = {
        window = {
          mappings = {
            ["A"] = "git_add_file",
            ["u"] = "git_unstage_file",
          },
        },
      },
      default_component_configs = {
        indent = { with_markers = true, with_expanders = true },
        icon = { folder_closed = " ", folder_open = " ", folder_empty = " " },
        modified = { symbol = "●" },
        git_status = {
          symbols = {
            added = "+",
            modified = "~",
            deleted = "-",
            renamed = "r",
            untracked = "?",
            ignored = "i",
            unstaged = "u",
            staged = "s",
            conflict = "!",
          },
        },
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["l"] = "open",
          ["h"] = "close_node",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["w"] = "open_with_window_picker",
          ["C"] = "close_all_subnodes",
          ["z"] = "close_all_nodes",
          ["Z"] = "expand_all_nodes",
          ["a"] = { "add", config = { show_path = "relative" } },
          ["A"] = { "add_directory", config = { show_path = "relative" } },
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["m"] = "move",
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NeotreeDirectory", {}),
        desc = "Open neo-tree when entering a directory",
        callback = function(args)
          if vim.fn.isdirectory(args.file) == 1 then
            vim.cmd("Neotree " .. args.file)
          end
        end,
      })
    end,
  },
}
