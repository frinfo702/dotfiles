-- Single source of truth for user settings.
--   defaults (schema below) < nvim/settings.json (global) < <project>/.nvim/settings.json
-- The settings panel (:Settings) edits those JSON files; nothing is stored anywhere else.
-- Files hold only values that differ from the layer below, so a diff shows exactly what you changed.
local M = {}

M.global_path = vim.fs.joinpath(vim.fn.stdpath("config"), "settings.json")

local function each_win(fn)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      fn(win)
    end
  end
end

local function win_opt(name, value)
  vim.go[name] = value
  each_win(function(win)
    vim.wo[win][name] = value
  end)
end

-- h/l cycles through this config's colors/ (the ported helix themes); the picker shows all.
local function themes()
  local names = vim.tbl_map(function(f)
    return vim.fn.fnamemodify(f, ":t:r")
  end, vim.fn.globpath(vim.fn.stdpath("config"), "colors/*.lua", false, true))
  table.sort(names)
  return names
end

-- Panel rows, in display order. `apply` runs at startup and on every change.
M.schema = {
  { section = "Appearance" },
  {
    key = "ui.theme",
    label = "Theme",
    default = "arc-raiders-dark",
    options = themes,
    desc = "Colorscheme. Helix themes are ported via nvim/scripts/helix2nvim.py. <CR> opens a live-preview picker.",
    apply = function(v)
      if not pcall(vim.cmd.colorscheme, v) then
        vim.notify("theme not found: " .. v, vim.log.levels.WARN)
      end
    end,
  },
  {
    key = "ui.line_number",
    label = "Line numbers",
    default = "relative",
    options = { "relative", "absolute", "off" },
    apply = function(v)
      win_opt("number", v ~= "off")
      win_opt("relativenumber", v == "relative")
    end,
  },
  {
    key = "ui.cursorline",
    label = "Highlight cursor line",
    default = true,
    apply = function(v)
      win_opt("cursorline", v)
    end,
  },
  {
    key = "ui.indent_guides",
    label = "Indent guides",
    default = true,
    apply = function(v)
      if v then
        Snacks.indent.enable()
      else
        Snacks.indent.disable()
      end
    end,
  },
  {
    key = "ui.whitespace",
    label = "Render whitespace",
    default = "trailing",
    options = { "trailing", "all", "none" },
    apply = function(v)
      local chars = { tab = "→ ", trail = "·", nbsp = "⍽" }
      if v == "all" then
        chars.space, chars.eol = "·", "⏎"
      end
      vim.opt.listchars = chars
      win_opt("list", v ~= "none")
    end,
  },
  {
    key = "ui.wrap",
    label = "Soft wrap",
    default = false,
    apply = function(v)
      win_opt("wrap", v)
    end,
  },
  {
    key = "ui.border",
    label = "Popup border",
    default = "rounded",
    options = { "rounded", "single", "solid", "none" },
    apply = function(v)
      vim.o.winborder = v
    end,
  },
  {
    key = "ui.bufferline",
    label = "Buffer line",
    default = "multiple",
    options = { "multiple", "always", "never" },
    desc = "Like helix: `multiple` shows the buffer line only when more than one buffer is open.",
    apply = function()
      require("config.ui").update_tabline()
    end,
  },

  { section = "Editor" },
  { key = "editor.auto_save", label = "Auto save on focus lost", default = true },
  { key = "editor.format_on_save", label = "Format on save", default = true },
  { key = "editor.trim_whitespace", label = "Trim trailing whitespace / final newlines", default = true },
  {
    key = "editor.tab_width",
    label = "Tab width",
    default = 2,
    options = { 2, 4, 8 },
    desc = "Default indent width. Filetype plugins and .editorconfig still win.",
    apply = function(v)
      vim.o.tabstop, vim.o.shiftwidth = v, v
    end,
  },
  {
    key = "editor.mouse",
    label = "Mouse",
    default = true,
    apply = function(v)
      vim.o.mouse = v and "a" or ""
    end,
  },
  {
    key = "format.by_ft",
    label = "Formatters per filetype",
    table = true,
    desc = "Edit in JSON (press e).",
    default = {
      lua = { "stylua" },
      python = { "ruff_format" },
      rust = { "rustfmt" },
      go = { "goimports", "gofmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      scala = { "scalafmt" },
      javascript = { "biome", "prettier" },
      javascriptreact = { "biome", "prettier" },
      typescript = { "biome", "prettier" },
      typescriptreact = { "biome", "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      markdown = { "mdformat" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      terraform = { "terraform_fmt" },
      hcl = { "terraform_fmt" },
    },
  },

  { section = "LSP" },
  {
    key = "lsp.inlay_hints",
    label = "Inlay hints",
    default = true,
    apply = function(v)
      vim.lsp.inlay_hint.enable(v)
    end,
  },
  {
    key = "lsp.diagnostics",
    label = "Diagnostics display",
    default = "virtual_text",
    options = { "virtual_text", "current_line", "signs_only" },
    desc = "virtual_text: message at line end. current_line: full message under the cursor line only.",
    apply = function(v)
      vim.diagnostic.config({
        virtual_text = v == "virtual_text" and { spacing = 2, prefix = "●" } or false,
        virtual_lines = v == "current_line" and { current_line = true } or false,
      })
    end,
  },
  { key = "lsp.completion_auto", label = "Auto-show completion", default = true, desc = "Off: open with <C-Space>." },
  {
    key = "lsp.config",
    label = "Server settings",
    table = true,
    default = {},
    desc = 'Per-server overrides merged over nvim/lsp/<name>.lua, e.g. {"pyright": {"settings": {...}}}. Edit in JSON (press e).',
  },
  { servers = true }, -- one row per server in lsp.servers, rendered by the panel
}

-- `true`: start when the binary is found (project node_modules/.venv first, then PATH).
M.servers_default = {
  pyright = true,
  basedpyright = false,
  ruff = true,
  ts_ls = true,
  biome = true,
  gopls = true,
  golangci_lint_ls = true,
  rust_analyzer = true,
  clangd = true,
  lua_ls = true,
  metals = true,
  tinymist = true,
  dockerls = true,
  docker_compose_language_service = true,
  bashls = true,
  taplo = true,
  yamlls = true,
  jsonls = true,
  marksman = true,
  html = true,
  cssls = true,
  terraformls = true,
  zls = true,
}

M.by_key = {}
for _, item in ipairs(M.schema) do
  if item.key then
    M.by_key[item.key] = item
  end
end

local layers = { global = {}, project = {} }
M.project_root = nil

local function read_json(path, secure)
  local text
  if secure then
    text = vim.secure.read(path) -- asks once whether to trust this project file
  else
    local f = io.open(path)
    text = f and f:read("a")
    if f then
      f:close()
    end
  end
  if not text or vim.trim(text) == "" then
    return {}
  end
  local ok, data = pcall(vim.json.decode, text, { luanil = { object = true, array = true } })
  if not ok then
    vim.notify(("settings: invalid JSON in %s\n%s"):format(path, data), vim.log.levels.ERROR)
    return {}
  end
  return data
end

local function path_get(t, key)
  for part in key:gmatch("[^.]+") do
    if type(t) ~= "table" then
      return nil
    end
    t = t[part]
  end
  return t
end

local function path_set(t, key, value)
  local parts = vim.split(key, ".", { plain = true })
  local chain = { t }
  for i = 1, #parts - 1 do
    t[parts[i]] = t[parts[i]] or {}
    t = t[parts[i]]
    chain[#chain + 1] = t
  end
  t[parts[#parts]] = value
  for i = #parts - 1, 1, -1 do -- drop tables emptied by a reset
    if next(chain[i + 1]) == nil then
      chain[i][parts[i]] = nil
    end
  end
end

function M.default(key)
  if M.by_key[key] then
    return M.by_key[key].default
  end
  local server = key:match("^lsp%.servers%.(.+)$")
  if server then
    return M.servers_default[server] or false
  end
  if key == "lsp.servers" then
    return M.servers_default
  end
end

--- Effective value. Tables are deep-merged across layers, scalars take the topmost layer.
function M.get(key, upto)
  local d, g, p = M.default(key), path_get(layers.global, key), path_get(layers.project, key)
  if upto == "global" then
    p = nil
  end
  if type(d) == "table" or type(g) == "table" or type(p) == "table" then
    return vim.tbl_deep_extend("force", d or {}, g or {}, p or {})
  end
  if p ~= nil then
    return p
  elseif g ~= nil then
    return g
  end
  return d
end

function M.raw(scope, key)
  return path_get(layers[scope], key)
end

function M.path(scope)
  if scope == "global" then
    return M.global_path
  end
  return vim.fs.joinpath(M.project_root, ".nvim", "settings.json")
end

local function save(scope)
  local path = M.path(scope)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local data = next(layers[scope]) and layers[scope] or vim.empty_dict()
  local text = vim.json.encode(data, { indent = "  ", sort_keys = true }) .. "\n"
  local f = assert(io.open(path, "w"))
  f:write(text)
  f:close()
  if scope == "project" then
    vim.secure.trust({ action = "allow", path = path }) -- we wrote it, so it's trusted
  end
end

function M.apply(key)
  local item = M.by_key[key]
  local server = key:match("^lsp%.servers%.(.+)$")
  if item and item.apply then
    item.apply(M.get(key))
  elseif server then
    require("config.lsp").enable(server, M.get(key))
  end
end

--- value = nil resets the key in that scope.
function M.set(scope, key, value)
  local below = scope == "project" and M.get(key, "global") or M.default(key)
  if value == below then
    value = nil -- same as the layer below: keep the file minimal
  end
  path_set(layers[scope], key, value)
  save(scope)
  M.apply(key)
end

function M.load()
  local cwd = vim.fn.getcwd()
  local file = vim.fs.find(".nvim/settings.json", { upward = true, path = cwd })[1]
  M.project_root = file and vim.fs.dirname(vim.fs.dirname(file)) or vim.fs.root(cwd, ".git") or cwd
  layers.global = read_json(M.global_path, false)
  local project = M.path("project")
  layers.project = vim.uv.fs_stat(project) and read_json(project, true) or {}
end

function M.apply_all()
  for _, item in ipairs(M.schema) do
    if item.apply then
      item.apply(M.get(item.key))
    end
  end
  for name in pairs(M.get("lsp.servers")) do
    M.apply("lsp.servers." .. name)
  end
end

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    M.load()
    M.apply_all()
  end,
})

return M
