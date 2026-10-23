-- Helix-like chrome: statusline, bufferline, message area, editor autocmds.
local S = require("config.settings")
local M = {}

-- ui2: messages in a floating area instead of "Press ENTER" prompts.
require("vim._core.ui2").enable({ msg = { targets = "msg" } })

local modes = {
  n = { "NOR", "HxModeNormal" },
  i = { "INS", "HxModeInsert" },
  v = { "SEL", "HxModeSelect" },
  V = { "SEL", "HxModeSelect" },
  ["\22"] = { "SEL", "HxModeSelect" },
  s = { "SEL", "HxModeSelect" },
  R = { "REP", "HxModeInsert" },
  c = { "CMD", "HxModeNormal" },
  t = { "TER", "HxModeInsert" },
}
local spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function highlights()
  local sl = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
  for _, group in ipairs({ "HxModeNormal", "HxModeInsert", "HxModeSelect" }) do
    vim.api.nvim_set_hl(0, group, { link = "StatusLine", default = true })
  end
  for _, sev in ipairs({ "Error", "Warn", "Info", "Hint" }) do
    local d = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. sev, link = false })
    vim.api.nvim_set_hl(0, "HxStatus" .. sev, { fg = d.fg, bg = sl.bg })
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = highlights })
highlights()

local function esc(s)
  return (s:gsub("%%", "%%%%"))
end

function M.statusline()
  local mode = modes[vim.fn.mode():sub(1, 1)] or modes.n
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  name = name == "" and "[scratch]" or vim.fn.fnamemodify(name, ":~:.")
  local left = {
    ("%%#%s# %s %%*"):format(mode[2], mode[1]),
    " ",
  }
  local progress = vim.lsp.status()
  if progress ~= "" then
    left[#left + 1] = spinner[math.floor(vim.uv.hrtime() / 1e8) % #spinner + 1] .. " "
  end
  left[#left + 1] = esc(name)
  if vim.bo[buf].modified then
    left[#left + 1] = " [+]"
  end
  if vim.bo[buf].readonly then
    left[#left + 1] = " [readonly]"
  end

  local right = {}
  local counts = vim.diagnostic.count(buf)
  for sev, key in ipairs({ "Error", "Warn", "Info", "Hint" }) do
    if (counts[sev] or 0) > 0 then
      right[#right + 1] = ("%%#HxStatus%s#● %d%%* "):format(key, counts[sev])
    end
  end
  if vim.bo[buf].fileencoding ~= "" and vim.bo[buf].fileencoding ~= "utf-8" then
    right[#right + 1] = vim.bo[buf].fileencoding .. " "
  end
  right[#right + 1] = vim.bo[buf].filetype .. "  %l:%c "
  return table.concat(left) .. "%=" .. table.concat(right)
end

function M.tabline()
  local out = {}
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted then
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
      name = name == "" and "[scratch]" or name
      local hl = buf == current and "%#TabLineSel#" or "%#TabLine#"
      out[#out + 1] = ("%s%%%d@v:lua.require'config.ui'.click@ %s%s %%X"):format(
        hl,
        buf,
        esc(name),
        vim.bo[buf].modified and "[+]" or ""
      )
    end
  end
  return table.concat(out) .. "%#TabLineFill#"
end

function M.click(buf)
  vim.api.nvim_set_current_buf(buf)
end

function M.update_tabline()
  local mode = S.get("ui.bufferline")
  local listed = #vim.tbl_filter(function(b)
    return vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())
  vim.o.showtabline = (mode == "always" or (mode == "multiple" and listed > 1)) and 2 or 0
end

vim.o.statusline = "%!v:lua.require'config.ui'.statusline()"
vim.o.tabline = "%!v:lua.require'config.ui'.tabline()"
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufWipeout", "OptionSet" }, {
  callback = vim.schedule_wrap(M.update_tabline),
})

-- helix: auto-save = true (on focus lost)
vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    if S.get("editor.auto_save") then
      vim.cmd("silent! wall")
    end
  end,
})

-- helix: trim-trailing-whitespace / trim-final-newlines (.editorconfig still applies on top)
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(ev)
    if not S.get("editor.trim_whitespace") or not vim.bo[ev.buf].modifiable or vim.bo[ev.buf].binary then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns silent! %s/\s\+$//e]])
    local last = vim.fn.prevnonblank(vim.fn.line("$"))
    if last > 0 and last < vim.fn.line("$") then
      vim.api.nvim_buf_set_lines(ev.buf, last, -1, false, {})
    end
    vim.fn.winrestview(view)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})

return M
