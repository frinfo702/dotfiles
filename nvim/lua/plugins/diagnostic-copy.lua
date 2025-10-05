return {
  {
    -- no extra plugin; we just add keymaps on VeryLazy
    "lazyvim/lazyvim",
    opts = function()
      -- Copy the first diagnostic on the current line to both + and * clipboards
      vim.keymap.set("n", "<leader>yD", function()
        local line = vim.fn.line(".") - 1
        local diags = vim.diagnostic.get(0, { lnum = line })
        if #diags == 0 then
          vim.notify("No diagnostics on this line", vim.log.levels.INFO)
          return
        end
        -- If multiple exist, grab the most severe
        table.sort(diags, function(a, b)
          return a.severity < b.severity
        end)
        local msg = diags[1].message
        vim.fn.setreg("+", msg) -- system clipboard (macOS/Linux)
        vim.fn.setreg("*", msg) -- primary selection (X11) or same as +
        vim.notify("Copied diagnostic: " .. msg, vim.log.levels.INFO)
      end, { desc = "Copy diagnostic under cursor" })

      -- Copy **all** diagnostics in the current buffer
      vim.keymap.set("n", "<leader>yA", function()
        local diags = vim.diagnostic.get(0)
        if #diags == 0 then
          vim.notify("No diagnostics in buffer", vim.log.levels.INFO)
          return
        end
        table.sort(diags, function(a, b)
          if a.lnum == b.lnum then
            return a.severity < b.severity
          end
          return a.lnum < b.lnum
        end)
        local lines = {}
        for _, d in ipairs(diags) do
          table.insert(lines, string.format("%d:%d %s", d.lnum + 1, (d.col or 0) + 1, d.message))
        end
        local text = table.concat(lines, "\n")
        vim.fn.setreg("+", text)
        vim.fn.setreg("*", text)
        vim.notify("Copied buffer diagnostics (" .. #diags .. " lines)", vim.log.levels.INFO)
      end, { desc = "Copy all buffer diagnostics" })
    end,
  },
}
