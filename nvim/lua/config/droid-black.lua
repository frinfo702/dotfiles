-- droid-black -- Black background with light foreground for visibility.

local M = {}

local function setup_editor_ui()
  -- Base: black background with light text
  vim.api.nvim_set_hl(0, "Normal",      { fg = "#c8c8c8", bg = "#000000" })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#c8c8c8", bg = "#161616" })
  vim.api.nvim_set_hl(0, "NormalNC",    { fg = "#888888", bg = "#000000" })

  -- Cursor / selection / visual
  vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#1c1c1c" })
  vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#1c1c1c" })
  vim.api.nvim_set_hl(0, "Visual",       { bg = "#3a3a3a" })
  vim.api.nvim_set_hl(0, "Search",       { fg = "#000000", bg = "#2EAA7B" })

  -- Line numbers
  vim.api.nvim_set_hl(0, "LineNr",       { fg = "#585858" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#aaaaaa" })

  -- Status line / tab line
  vim.api.nvim_set_hl(0, "StatusLine",   { fg = "#c8c8c8", bg = "#1c1c1c" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#585858", bg = "#1c1c1c" })
  vim.api.nvim_set_hl(0, "TabLine",      { fg = "#888888", bg = "#0e0e0e" })
  vim.api.nvim_set_hl(0, "TabLineSel",   { fg = "#c8c8c8", bg = "#1c1c1c" })
  vim.api.nvim_set_hl(0, "TabLineFill",  { bg = "#0e0e0e" })

  -- Pmenu (autocomplete popup)
  vim.api.nvim_set_hl(0, "Pmenu",      { fg = "#c8c8c8", bg = "#161616" })
  vim.api.nvim_set_hl(0, "PmenuSel",   { fg = "#000000", bg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "PmenuSbar",  { bg = "#1c1c1c" })
  vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#3a3a3a" })

  -- Diagnostics
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff6e6e" })
  vim.api.nvim_set_hl(0, "DiagnosticWarn",  { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "DiagnosticInfo",  { fg = "#5fafd7" })
  vim.api.nvim_set_hl(0, "DiagnosticHint",  { fg = "#87af87" })

  -- Diff
  vim.api.nvim_set_hl(0, "DiffAdd",    { fg = "#87af87", bg = "#0e1c0e" })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#d75f5f", bg = "#1c0e0e" })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = "#d7af5f", bg = "#0e1c1a" })
  vim.api.nvim_set_hl(0, "DiffText",   { fg = "#d7af5f", bg = "#2c2c0e" })

  -- Misc UI
  vim.api.nvim_set_hl(0, "VertSplit",    { fg = "#1c1c1c" })
  vim.api.nvim_set_hl(0, "SignColumn",   { bg = "#000000" })
  vim.api.nvim_set_hl(0, "ColorColumn",  { bg = "#1c1c1c" })
  vim.api.nvim_set_hl(0, "FoldColumn",   { fg = "#585858", bg = "#000000" })
  vim.api.nvim_set_hl(0, "Folded",       { fg = "#585858", bg = "#0e0e0e" })
  vim.api.nvim_set_hl(0, "NonText",      { fg = "#3a3a3a" })
  vim.api.nvim_set_hl(0, "SpecialKey",   { fg = "#3a3a3a" })
  vim.api.nvim_set_hl(0, "Whitespace",   { fg = "#3a3a3a" })
  vim.api.nvim_set_hl(0, "MatchParen",   { fg = "#2EAA7B", bg = "#2c2c2c" })
  vim.api.nvim_set_hl(0, "Directory",    { fg = "#5fafd7" })
  vim.api.nvim_set_hl(0, "Title",        { fg = "#2EAA7B", bold = true })
  vim.api.nvim_set_hl(0, "Question",     { fg = "#87af87" })
  vim.api.nvim_set_hl(0, "ModeMsg",      { fg = "#c8c8c8" })
  vim.api.nvim_set_hl(0, "MoreMsg",      { fg = "#5fafd7" })
  vim.api.nvim_set_hl(0, "WarningMsg",   { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "ErrorMsg",     { fg = "#ff6e6e" })

  -- Treesitter / Syntax
  vim.api.nvim_set_hl(0, "Comment",        { fg = "#585858", italic = true })
  vim.api.nvim_set_hl(0, "String",         { fg = "#87af87" })
  vim.api.nvim_set_hl(0, "Character",      { fg = "#87af87" })
  vim.api.nvim_set_hl(0, "Number",         { fg = "#d7af5f" })
  vim.api.nvim_set_hl(0, "Boolean",        { fg = "#d7af5f" })
  vim.api.nvim_set_hl(0, "Float",          { fg = "#d7af5f" })
  vim.api.nvim_set_hl(0, "Constant",       { fg = "#d7af5f" })
  vim.api.nvim_set_hl(0, "Identifier",     { fg = "#c8c8c8" })
  vim.api.nvim_set_hl(0, "Function",       { fg = "#5fafd7" })
  vim.api.nvim_set_hl(0, "Statement",      { fg = "#af5faf" })
  vim.api.nvim_set_hl(0, "Conditional",    { fg = "#af5faf" })
  vim.api.nvim_set_hl(0, "Repeat",         { fg = "#af5faf" })
  vim.api.nvim_set_hl(0, "Label",          { fg = "#af5faf" })
  vim.api.nvim_set_hl(0, "Operator",       { fg = "#c8c8c8" })
  vim.api.nvim_set_hl(0, "Keyword",        { fg = "#af5faf" })
  vim.api.nvim_set_hl(0, "Exception",      { fg = "#af5faf" })
  vim.api.nvim_set_hl(0, "PreProc",        { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "Include",        { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "Define",         { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "Macro",          { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "PreCondit",      { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "Type",           { fg = "#d7af5f" })
  vim.api.nvim_set_hl(0, "StorageClass",   { fg = "#d7af5f" })
  vim.api.nvim_set_hl(0, "Structure",      { fg = "#d7af5f" })
  vim.api.nvim_set_hl(0, "Typedef",        { fg = "#d7af5f" })
  vim.api.nvim_set_hl(0, "Special",        { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "SpecialChar",    { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "Tag",            { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "Delimiter",      { fg = "#aaaaaa" })
  vim.api.nvim_set_hl(0, "SpecialComment", { fg = "#585858", italic = true })
  vim.api.nvim_set_hl(0, "Debug",          { fg = "#2EAA7B" })
  vim.api.nvim_set_hl(0, "Underlined",     { fg = "#5fafd7", underline = true })
  vim.api.nvim_set_hl(0, "Ignore",         { fg = "#3a3a3a" })
  vim.api.nvim_set_hl(0, "Error",          { fg = "#ff6e6e" })
  vim.api.nvim_set_hl(0, "Todo",           { fg = "#2EAA7B", bg = "#0e1c1a" })

  -- @spell / @nospell etc
  vim.api.nvim_set_hl(0, "SpellBad",   { sp = "#ff6e6e", undercurl = true })
  vim.api.nvim_set_hl(0, "SpellCap",   { sp = "#5fafd7", undercurl = true })
  vim.api.nvim_set_hl(0, "SpellRare",  { sp = "#af5faf", undercurl = true })
  vim.api.nvim_set_hl(0, "SpellLocal", { sp = "#5fafd7", undercurl = true })
end

function M.setup()
  vim.cmd("hi clear")
  if vim.g.colors_name then vim.cmd("hi clear") end
  vim.g.colors_name = "droid-black"
  setup_editor_ui()
end

return M
