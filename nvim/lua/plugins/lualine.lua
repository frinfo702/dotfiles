return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local theme = {
        normal = {
          a = { fg = "#0c0c0c", bg = "#ff7700", gui = "bold" },
          b = { fg = "#e8e8e8", bg = "#1a1a1a" },
          c = { fg = "#e8e8e8", bg = "#0c0c0c" },
        },
        insert = {
          a = { fg = "#0c0c0c", bg = "#44cc66", gui = "bold" },
          b = { fg = "#e8e8e8", bg = "#1a1a1a" },
          c = { fg = "#e8e8e8", bg = "#0c0c0c" },
        },
        visual = {
          a = { fg = "#0c0c0c", bg = "#aa66ff", gui = "bold" },
          b = { fg = "#e8e8e8", bg = "#1a1a1a" },
          c = { fg = "#e8e8e8", bg = "#0c0c0c" },
        },
        command = {
          a = { fg = "#0c0c0c", bg = "#eebb00", gui = "bold" },
          b = { fg = "#e8e8e8", bg = "#1a1a1a" },
          c = { fg = "#e8e8e8", bg = "#0c0c0c" },
        },
        replace = {
          a = { fg = "#0c0c0c", bg = "#ff4455", gui = "bold" },
          b = { fg = "#e8e8e8", bg = "#1a1a1a" },
          c = { fg = "#e8e8e8", bg = "#0c0c0c" },
        },
        terminal = {
          a = { fg = "#0c0c0c", bg = "#22cccc", gui = "bold" },
          b = { fg = "#e8e8e8", bg = "#1a1a1a" },
          c = { fg = "#e8e8e8", bg = "#0c0c0c" },
        },
        inactive = {
          a = { fg = "#888888", bg = "#141414", gui = "bold" },
          b = { fg = "#888888", bg = "#141414" },
          c = { fg = "#888888", bg = "#141414" },
        },
      }

      return {
        options = {
          theme = theme,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "alpha", "neo-tree" },
          globalstatus = true,
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(m)
                local modes = {
                  ["NORMAL"] = " NORMAL ",
                  ["INSERT"] = " INSERT ",
                  ["VISUAL"] = " VISUAL ",
                  ["V-LINE"] = " V-LINE ",
                  ["V-BLOCK"] = " V-BLK ",
                  ["REPLACE"] = " REPLACE ",
                  ["COMMAND"] = " COMMAND ",
                  ["TERMINAL"] = " TERM ",
                  ["SELECT"] = " SELECT ",
                }
                return modes[m] or (" " .. m .. " ")
              end,
              padding = 0,
            },
          },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
          },
          lualine_c = {
            {
              "filename",
              path = 1,
              padding = { left = 1, right = 0 },
            },
          },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
            },
            { "encoding" },
            { "fileformat" },
          },
          lualine_y = {
            { "filetype", colored = false },
          },
          lualine_z = {
            {
              "location",
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { "filename", path = 1 },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {
          lualine_a = {
            {
              "tabs",
              mode = 1,
              tabs_color = {
                active = { fg = "#0c0c0c", bg = "#ff7700", gui = "bold" },
                inactive = { fg = "#888888", bg = "#141414" },
              },
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            { "buffers", show_filename_only = true, hide_filename_extension = false, symbols = { alternate_file = "" } },
          },
        },
        extensions = { "neo-tree", "fugitive" },
      }
    end,
  },
}
