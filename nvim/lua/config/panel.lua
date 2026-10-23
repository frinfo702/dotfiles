-- :Settings — a GUI-like settings panel. Every change is applied live and
-- written to settings.json (Global) or <project>/.nvim/settings.json (Project).
local S = require("config.settings")
local M = {}

local ns = vim.api.nvim_create_namespace("settings_panel")
local WIDTH = 80
local state = { scope = "global", row = nil }

local function options(item)
  return type(item.options) == "function" and item.options() or item.options
end

-- Flatten schema + one row per LSP server.
local function rows()
  local out = {}
  for _, item in ipairs(S.schema) do
    if item.servers then
      local names = vim.tbl_keys(S.get("lsp.servers"))
      table.sort(names)
      for _, name in ipairs(names) do
        local label = #name > 27 and name:sub(1, 26) .. "…" or name
        out[#out + 1] = { key = "lsp.servers." .. name, label = label, server = name }
      end
    else
      out[#out + 1] = item
    end
  end
  return out
end

local function fmt(v)
  if type(v) == "boolean" then
    return v and "● on" or "○ off"
  end
  return tostring(v)
end

local function render(buf)
  local lines, marks = {}, {}
  local function add(text, hls)
    lines[#lines + 1] = text
    for _, h in ipairs(hls or {}) do
      marks[#marks + 1] = { #lines - 1, h[1], h[2], h[3] }
    end
  end

  local g, p = " Global ", " Project "
  local tabs = g .. "  " .. p
  local root = vim.fn.fnamemodify(S.project_root, ":~")
  local room = WIDTH - #tabs - 6
  if vim.fn.strchars(root) > room then
    root = "…" .. vim.fn.strcharpart(root, vim.fn.strchars(root) - room + 1)
  end
  add(" " .. tabs .. "   " .. root, {
    { 1, 1 + #g, state.scope == "global" and "PmenuSel" or "Comment" },
    { 3 + #g, 3 + #g + #p, state.scope == "project" and "PmenuSel" or "Comment" },
    { 4 + #tabs, -1, "Comment" },
  })

  local items = {}
  for _, item in ipairs(rows()) do
    if item.section then
      add("")
      add(" " .. item.section:upper(), { { 0, -1, "Title" } })
    else
      local value = S.get(item.key)
      local here = S.raw(state.scope, item.key) ~= nil
      local right = item.table and "{…} edit JSON" or fmt(value)
      local label = (here and " • " or "   ") .. item.label
      local hls = {}
      if here then
        hls[#hls + 1] = { 1, 4, "DiagnosticInfo" } -- set in this scope's file
      elseif state.scope == "project" and not item.table then
        hls[#hls + 1] = { 4, #label, "Comment" } -- inherited from global
      end
      if item.server then
        local path, bin = require("config.lsp").status(item.server)
        local status = path and ("✓ " .. vim.fn.fnamemodify(path, ":~")) or ("✗ " .. (bin or "?") .. " not found")
        local max = WIDTH - 32 - vim.fn.strdisplaywidth(right) - 4
        if vim.fn.strchars(status) > max then
          status = "…" .. vim.fn.strcharpart(status, vim.fn.strchars(status) - max + 1)
        end
        local start = #label + 1
        label = label .. (" "):rep(math.max(1, 32 - vim.fn.strdisplaywidth(label))) .. status
        hls[#hls + 1] = { start, #label, path and "DiagnosticOk" or "DiagnosticWarn" }
      end
      local pad = WIDTH - vim.fn.strdisplaywidth(label) - vim.fn.strdisplaywidth(right) - 2
      local line = label .. (" "):rep(math.max(pad, 1)) .. right
      hls[#hls + 1] = {
        #line - #right,
        #line,
        item.table and "Comment" or value == true and "DiagnosticOk" or value == false and "Comment" or "Special",
      }
      add(line, hls)
      items[#lines] = item
    end
  end

  add("")
  local cur = items[state.row]
  local line = ""
  for word in ((cur and cur.desc) or ""):gmatch("%S+") do
    if #line + #word > WIDTH - 4 then
      add(" " .. line, { { 0, -1, "Comment" } })
      line = word
    else
      line = line == "" and word or line .. " " .. word
    end
  end
  add(" " .. line, { { 0, -1, "Comment" } })
  add(" j/k move  h/l/␣ change  ⏎ choose  r reset  ⇥ scope  e edit JSON  q close", { { 0, -1, "NonText" } })

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for _, m in ipairs(marks) do
    local len = #lines[m[1] + 1]
    vim.api.nvim_buf_set_extmark(buf, ns, m[1], math.min(m[2], len), {
      end_col = m[3] == -1 and len or math.min(m[3], len),
      hl_group = m[4],
    })
  end
  return items, #lines
end

function M.open()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "settings"
  local items, height = render(buf)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = WIDTH,
    height = math.min(height + 2, vim.o.lines - 4),
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - WIDTH) / 2),
    style = "minimal",
    title = " Settings ",
    title_pos = "center",
  })
  vim.wo[win].cursorline = true
  vim.wo[win].winhighlight = "CursorLine:PmenuSel"

  local function rows_list()
    local list = vim.tbl_keys(items)
    table.sort(list)
    return list
  end
  local function redraw()
    if not vim.api.nvim_win_is_valid(win) then
      return
    end
    items, height = render(buf)
    vim.api.nvim_win_set_height(win, math.min(height + 2, vim.o.lines - 4))
    vim.api.nvim_win_set_cursor(win, { state.row, 0 })
    vim.cmd.redraw()
  end
  local function move(delta)
    local list = rows_list()
    local idx = 1
    for i, r in ipairs(list) do
      if r == state.row then
        idx = i
      end
    end
    state.row = list[math.max(1, math.min(#list, idx + delta))]
    redraw()
  end
  local function current()
    return items[state.row]
  end
  local function set(value)
    local item = current()
    S.set(state.scope, item.key, value)
    vim.schedule(redraw) -- after a colorscheme change has settled
  end
  local function cycle(delta)
    local item = current()
    if item.table then
      return
    end
    local value = S.get(item.key)
    if type(value) == "boolean" then
      return set(not value)
    end
    local opts = options(item)
    local idx = 0
    for i, o in ipairs(opts) do
      if o == value then
        idx = i
      end
    end
    set(opts[(idx - 1 + delta) % #opts + 1])
  end
  local function edit_json()
    local path = S.path(state.scope)
    vim.api.nvim_win_close(win, true)
    if not vim.uv.fs_stat(path) then
      vim.fn.mkdir(vim.fs.dirname(path), "p")
      vim.fn.writefile({ "{}" }, path)
    end
    vim.cmd.edit(vim.fn.fnameescape(path))
    local key = current() and current().key
    if key then
      vim.fn.search('"' .. key:match("[^.]+$") .. '"')
    end
  end
  local function choose()
    local item = current()
    if item.table then
      return edit_json()
    end
    if item.key == "ui.theme" then
      local before = vim.g.colors_name
      return Snacks.picker.colorschemes({
        confirm = function(picker, pick)
          picker:close()
          if pick then
            set(pick.text)
          else
            pcall(vim.cmd.colorscheme, before)
          end
        end,
      })
    end
    if type(S.get(item.key)) == "boolean" then
      return cycle(1)
    end
    vim.ui.select(options(item), { prompt = item.label, format_item = tostring }, function(choice)
      if choice ~= nil then
        set(choice)
      end
    end)
  end

  local map = function(lhs, fn)
    vim.keymap.set("n", lhs, fn, { buffer = buf, nowait = true })
  end
  map("j", function()
    move(1)
  end)
  map("k", function()
    move(-1)
  end)
  map("<Down>", function()
    move(1)
  end)
  map("<Up>", function()
    move(-1)
  end)
  map("l", function()
    cycle(1)
  end)
  map("h", function()
    cycle(-1)
  end)
  map("<Right>", function()
    cycle(1)
  end)
  map("<Left>", function()
    cycle(-1)
  end)
  map("<Space>", function()
    cycle(1)
  end)
  map("<CR>", choose)
  map("<LeftMouse>", function()
    local pos = vim.fn.getmousepos()
    if pos.winid == win and items[pos.line] then
      state.row = pos.line
      cycle(1)
    end
  end)
  map("r", function()
    set(nil)
  end)
  map("<Tab>", function()
    state.scope = state.scope == "global" and "project" or "global"
    redraw()
  end)
  map("e", edit_json)
  map("q", function()
    vim.api.nvim_win_close(win, true)
  end)
  map("<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end)

  state.row = state.row and items[state.row] and state.row or rows_list()[1]
  vim.api.nvim_win_set_cursor(win, { state.row, 0 })
end

vim.api.nvim_create_user_command("Settings", M.open, { desc = "Open settings panel" })

return M
