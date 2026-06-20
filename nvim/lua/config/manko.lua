local M = {
  lines = {
    " __   __ ",
    "|  \\/  |",
    "| \\  / |",
    "| |\\/| |",
    "|_|   |_|",
    "        ",
    "        ",
    "        ",
  },
  w = 9,
  h = 8,
  off = 0,
}

local A = {
  lines = {
    "        ",
    "   /\\   ",
    "  /  \\  ",
    " / /\\\\ ",
    "/ _____\\",
    "/_/   \\_\\",
    "        ",
    "        ",
  },
  w = 9,
  h = 8,
  off = 9,
}

local N = {
  lines = {
    " _     _",
    "| \\  | |",
    "|  \\ | |",
    "| | \\  |",
    "|_|  \\_|",
    "        ",
    "        ",
    "        ",
  },
  w = 8,
  h = 8,
  off = 20,
}

local K = {
  lines = {
    " _  __",
    "| |/ /",
    "| ' / ",
    "|   \\",
    "| . \\",
    "|_|\\_\\",
    "      ",
    "      ",
  },
  w = 6,
  h = 8,
  off = 30,
}

local O = {
  lines = {
    "  ____  ",
    " / __ \\ ",
    "| |  | |",
    "| |  | |",
    "| |__| |",
    " \\____/ ",
    "        ",
    "        ",
  },
  w = 8,
  h = 8,
  off = 38,
}

local letters = { M, A, N, K, O }

local function show_manko()
  vim.cmd("hi default MankoNormal guifg=#FFD700 guibg=#000000 gui=bold")
  vim.cmd("hi default MankoFlash guifg=#FFFFFF guibg=#000000 gui=bold")

  local cols, rows = vim.o.columns, vim.o.lines
  local base_col = math.floor(cols / 2) - 23
  local final_row = math.floor((rows - 8) / 2) - 1

  local wins = {}
  for i, lt in ipairs(letters) do
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lt.lines)
    vim.bo[buf].modifiable = false

    local fc = base_col + lt.off
    local sr, sc
    if i == 1 then
      sr, sc = final_row, -lt.w - 2
    elseif i == 2 then
      sr, sc = -lt.h - 2, fc
    elseif i == 3 then
      sr, sc = final_row, cols + 2
    elseif i == 4 then
      sr, sc = rows + 2, fc
    else
      sr, sc = -lt.h - 2, cols + 2
    end

    local win = vim.api.nvim_open_win(buf, false, {
      relative = "editor",
      width = lt.w,
      height = lt.h,
      row = sr,
      col = sc,
      style = "minimal",
      focusable = false,
    })
    vim.api.nvim_win_set_option(win, "winhighlight", "Normal:MankoNormal")
    wins[i] = { win = win, buf = buf, lt = lt, sr = sr, sc = sc, fr = final_row, fc = fc }
  end

  local frames, frame = 35, 0
  local function animate()
    frame = frame + 1
    local t = math.min(frame / frames, 1)
    local e = 1 - (1 - t) * (1 - t) * (1 - t)

    for _, w in ipairs(wins) do
      if not vim.api.nvim_win_is_valid(w.win) then
        return
      end
      local r = math.floor(w.sr + (w.fr - w.sr) * e + 0.5)
      local c = math.floor(w.sc + (w.fc - w.sc) * e + 0.5)
      vim.api.nvim_win_set_config(w.win, { relative = "editor", row = r, col = c })
    end

    if t < 1 then
      vim.defer_fn(animate, 60)
    else
      local fl = false
      local ft = vim.fn.timer_start(120, function()
        fl = not fl
        local hl = fl and "MankoFlash" or "MankoNormal"
        for _, w in ipairs(wins) do
          if not vim.api.nvim_win_is_valid(w.win) then
            vim.fn.timer_stop(ft)
            return
          end
          vim.api.nvim_win_set_option(w.win, "winhighlight", "Normal:" .. hl)
        end
      end, { ["repeat"] = -1 })

      vim.fn.timer_start(3500, function()
        vim.fn.timer_stop(ft)
        for _, w in ipairs(wins) do
          if vim.api.nvim_win_is_valid(w.win) then
            vim.api.nvim_win_close(w.win, true)
          end
        end
      end)
    end
  end

  animate()
end

vim.api.nvim_create_user_command("Manko", show_manko, {
  desc = "ASCII art MANKO flying in from screen edges",
  range = false,
})
