-- droid-black ─ A black & white Neovim colorscheme with orange accents.
--
-- Design principles:
--   • Black background, white/gray text — the canvas stays clean.
--   • Orange is the sole theme accent (keywords, functions, titles).
--   • Semantic colors (red/green/yellow/blue…) follow convention and are used
--     sparingly so they retain their meaning when they appear.

local M = {}

-- ═══════════════════════════════════════════════════════════════  Palette

local c = {
  -- Backgrounds (near-black, never pure #000 for readability on OLED)
  bg              = "#0c0c0c",
  bg_alt          = "#141414",
  bg_float        = "#161616",
  bg_popup        = "#1a1a1a",
  bg_cursorline   = "#181818",
  bg_statusline   = "#080808",
  bg_sidebar      = "#0e0e0e",
  bg_highlight    = "#222222",
  bg_search       = "#3a2400",
  bg_visual       = "#262626",
  bg_hover        = "#1e1e1e",
  bg_mixin        = "#1c1c1c",

  -- Text (crisp whites and grays)
  fg              = "#e8e8e8",
  fg_dim          = "#c8c8c8",
  fg_muted        = "#888888",
  fg_alt          = "#aaaaaa",

  -- Theme accent: orange
  orange          = "#ff7700",
  orange_bright   = "#ff9933",
  orange_dim      = "#cc6600",
  orange_subtle   = "#3a2200",

  -- Semantic (used sparingly)
  red             = "#ff4455",
  red_bright      = "#ff6677",
  green           = "#44cc66",
  green_bright    = "#66dd88",
  yellow          = "#eebb00",
  blue            = "#4499ff",
  purple          = "#aa66ff",
  cyan            = "#22cccc",
  pink            = "#ff88aa",

  -- Diff / Git
  git_add         = "#44cc66",
  git_change      = "#ff7700",
  git_delete      = "#ff4455",

  -- UI chrome
  line_nr         = "#3a3a3a",
  cursor_nr       = "#ff7700",
  whitespace      = "#2a2a2a",
  border          = "#2a2a2a",
  comment         = "#555555",
  nontext         = "#333333",
  fold            = "#2a2a2a",
  conceal         = "#666666",
  error           = "#ff4455",
  warning         = "#eebb00",
  info            = "#4499ff",
  hint            = "#888888",
}

-- ═══════════════════════════════════════════════════════════════  Helpers

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function link(group, target)
  vim.api.nvim_set_hl(0, group, { link = target })
end

-- ═══════════════════════════════════════════════════════════════  Editor UI

local function setup_editor_ui()
  -- Base
  hl("Normal",        { fg = c.fg, bg = c.bg })
  hl("NormalFloat",   { fg = c.fg, bg = c.bg_float })
  hl("NormalNC",      { fg = c.fg, bg = c.bg })

  -- Cursor
  hl("Cursor",        { fg = c.bg, bg = c.fg })
  hl("CursorLine",    { bg = c.bg_cursorline })
  hl("CursorColumn",  { bg = c.bg_cursorline })
  hl("CursorLineNr",  { fg = c.cursor_nr, bold = true })
  hl("LineNr",        { fg = c.line_nr })
  hl("CursorIM",      { link = "Cursor" })
  hl("lCursor",       { link = "Cursor" })

  -- Selection
  hl("Visual",        { bg = c.bg_visual })
  hl("VisualNOS",     { bg = c.bg_visual })
  hl("Search",        { fg = c.fg, bg = c.bg_search })
  hl("IncSearch",     { fg = c.bg, bg = c.orange })
  hl("CurSearch",     { link = "IncSearch" })

  -- Popup menu
  hl("Pmenu",         { fg = c.fg, bg = c.bg_popup })
  hl("PmenuSel",      { fg = c.bg, bg = c.orange })
  hl("PmenuSbar",     { bg = c.bg_alt })
  hl("PmenuThumb",    { bg = c.orange_dim })
  hl("WildMenu",      { link = "PmenuSel" })

  -- Status / Tab line
  hl("StatusLine",    { fg = c.fg_dim, bg = c.bg_statusline })
  hl("StatusLineNC",  { fg = c.fg_muted, bg = c.bg_statusline })
  hl("StatusLineTerm",   { link = "StatusLine" })
  hl("StatusLineTermNC", { link = "StatusLineNC" })
  hl("TabLine",       { fg = c.fg_muted, bg = c.bg_alt })
  hl("TabLineSel",    { fg = c.orange, bg = c.bg })
  hl("TabLineFill",   { bg = c.bg })

  -- Splits / Separators
  hl("WinSeparator",  { fg = c.border, bg = c.bg })
  hl("VertSplit",     { link = "WinSeparator" })

  -- Folding
  hl("Folded",        { fg = c.fg_muted, bg = c.fold })
  hl("FoldColumn",    { fg = c.comment })

  -- Sidebar / Signcolumn
  hl("SignColumn",    { bg = c.bg })
  hl("SignColumnSB",  { bg = c.bg_sidebar })

  -- Misc UI
  hl("NonText",       { fg = c.nontext })
  hl("SpecialKey",    { fg = c.whitespace })
  hl("Whitespace",    { fg = c.whitespace })
  hl("Conceal",       { fg = c.conceal })
  hl("EndOfBuffer",   { fg = c.bg })
  hl("ColorColumn",   { bg = c.bg_cursorline })
  hl("Title",         { fg = c.orange, bold = true })
  hl("MatchParen",    { fg = c.orange, bold = true, underline = true })
  hl("ModeMsg",       { fg = c.fg_dim })
  hl("MsgArea",       { fg = c.fg })
  hl("MsgSeparator",  { fg = c.border })

  -- Messages
  hl("ErrorMsg",      { fg = c.red, bold = true })
  hl("WarningMsg",    { fg = c.yellow })
  hl("MoreMsg",       { fg = c.green })
  hl("InfoMsg",       { fg = c.blue })
  hl("Question",      { fg = c.green })

  -- Diff (highlighting in buffer)
  hl("DiffAdd",       { fg = c.git_add, bg = c.bg })
  hl("DiffChange",    { fg = c.git_change, bg = c.bg })
  hl("DiffDelete",    { fg = c.git_delete, bg = c.bg })
  hl("DiffText",      { bg = c.orange_subtle })

  -- Spelling
  hl("SpellBad",      { sp = c.red, undercurl = true })
  hl("SpellCap",      { sp = c.blue, undercurl = true })
  hl("SpellRare",     { sp = c.purple, undercurl = true })
  hl("SpellLocal",    { sp = c.cyan, undercurl = true })

  -- Quickfix / Location list
  hl("QuickFixLine",  { bg = c.bg_highlight })

  -- Float / Border
  hl("FloatBorder",   { fg = c.orange, bg = c.bg_float })
  hl("FloatTitle",    { fg = c.orange, bold = true })

  -- Help
  hl("HelpCommand",   { fg = c.orange })
  hl("HelpExample",   { fg = c.green })
  hl("HelpHeader",    { fg = c.orange, bold = true })

  -- Directory / Netrw
  hl("Directory",     { fg = c.orange })
end

-- ═══════════════════════════════════════════════════════════════  Syntax

local function setup_syntax()
  -- Core groups (Vim 2k+ theme compat)
  hl("Normal",       { fg = c.fg, bg = c.bg })
  hl("Comment",      { fg = c.comment, italic = true })
  hl("Constant",     { fg = c.purple })
  hl("String",       { fg = c.green })
  hl("Character",    { fg = c.green })
  hl("Number",       { fg = c.purple })
  hl("Boolean",      { fg = c.purple })
  hl("Float",        { fg = c.purple })

  hl("Identifier",   { fg = c.fg })
  hl("Function",     { fg = c.orange })
  hl("Method",       { fg = c.orange })

  hl("Statement",    { fg = c.orange_bright, bold = true })
  hl("Conditional",  { fg = c.orange_bright, bold = true })
  hl("Repeat",       { fg = c.orange_bright, bold = true })
  hl("Label",        { fg = c.orange })
  hl("Operator",     { fg = c.fg })
  hl("Keyword",      { fg = c.orange_bright, bold = true })
  hl("Exception",    { fg = c.orange_bright, bold = true })

  hl("PreProc",      { fg = c.orange })
  hl("Include",      { fg = c.orange })
  hl("Define",       { fg = c.orange })
  hl("Macro",        { fg = c.orange })
  hl("PreCondit",    { fg = c.orange })

  hl("Type",         { fg = c.cyan })
  hl("StorageClass", { fg = c.orange })
  hl("Structure",    { fg = c.cyan })
  hl("Typedef",      { fg = c.cyan })

  hl("Special",       { fg = c.fg_dim })
  hl("SpecialChar",   { fg = c.pink })
  hl("Tag",           { fg = c.orange })
  hl("Delimiter",     { fg = c.fg_muted })
  hl("SpecialComment",{ fg = c.comment, italic = true })
  hl("Debug",         { fg = c.red })

  hl("Underlined",    { underline = true })
  hl("Ignore",        { fg = c.fg_muted })
  hl("Error",         { fg = c.red })
  hl("Todo",          { fg = c.orange, bold = true, reverse = true })
end

-- ═══════════════════════════════════════════════════════════════  Treesitter

local function setup_treesitter()
  -- Keywords
  hl("@keyword",            { fg = c.orange_bright, bold = true })
  hl("@keyword.function",   { fg = c.orange })
  hl("@keyword.return",     { fg = c.orange_bright })
  hl("@keyword.operator",   { fg = c.orange })
  hl("@keyword.import",     { fg = c.orange })
  hl("@keyword.repeat",     { fg = c.orange_bright, bold = true })
  hl("@keyword.conditional",{ fg = c.orange_bright, bold = true })
  hl("@keyword.exception",  { fg = c.orange_bright, bold = true })
  hl("@keyword.debug",      { fg = c.red })
  hl("@keyword.storage",    { fg = c.orange })
  hl("@keyword.directive",  { fg = c.orange_dim })

  -- Punctuation
  hl("@punctuation.delimiter", { fg = c.fg_muted })
  hl("@punctuation.bracket",   { fg = c.fg_muted })
  hl("@punctuation.special",   { fg = c.fg_dim })

  -- Comments
  hl("@comment",            { fg = c.comment, italic = true })
  hl("@comment.todo",       { fg = c.orange, bold = true })
  hl("@comment.warning",    { fg = c.yellow, bold = true })
  hl("@comment.error",      { fg = c.red, bold = true })
  hl("@comment.note",       { fg = c.blue, bold = true })

  -- Literals
  hl("@string",             { fg = c.green })
  hl("@string.regex",       { fg = c.green_bright })
  hl("@string.escape",      { fg = c.orange })
  hl("@string.special",     { fg = c.pink })
  hl("@string.documentation", { fg = c.green, italic = true })

  hl("@number",             { fg = c.purple })
  hl("@number.float",       { fg = c.purple })
  hl("@boolean",            { fg = c.purple })

  -- Types
  hl("@type",               { fg = c.cyan })
  hl("@type.builtin",       { fg = c.cyan })
  hl("@type.definition",    { fg = c.cyan })
  hl("@type.qualifier",     { fg = c.cyan })

  -- Functions / Methods
  hl("@function",           { fg = c.orange })
  hl("@function.builtin",   { fg = c.orange_bright })
  hl("@function.method",    { fg = c.orange })
  hl("@function.call",      { fg = c.orange })
  hl("@function.method.call", { fg = c.orange })

  hl("@constructor",        { fg = c.orange })
  hl("@attribute",          { fg = c.fg_dim })
  hl("@property",           { fg = c.fg_alt })

  -- Variables
  hl("@variable",           { fg = c.fg })
  hl("@variable.builtin",   { fg = c.fg_dim })
  hl("@variable.parameter", { fg = c.fg_dim })
  hl("@variable.member",    { fg = c.fg_alt })

  -- Constants
  hl("@constant",           { fg = c.purple })
  hl("@constant.builtin",   { fg = c.purple })
  hl("@constant.macro",     { fg = c.purple })

  -- Namespace / Module
  hl("@namespace",          { fg = c.fg_alt })
  hl("@module",             { fg = c.fg_alt })
  hl("@symbol",             { fg = c.pink })

  -- Labels / Includes
  hl("@label",              { fg = c.orange })
  hl("@include",            { fg = c.orange })
  hl("@preproc",            { fg = c.orange })

  -- Operators
  hl("@operator",           { fg = c.fg })

  -- Tags (HTML/XML)
  hl("@tag",                { fg = c.orange })
  hl("@tag.attribute",      { fg = c.fg_dim })
  hl("@tag.delimiter",      { fg = c.fg_muted })

  -- Text / Markup
  hl("@text",               { fg = c.fg })
  hl("@text.strong",        { bold = true })
  hl("@text.emphasis",      { italic = true })
  hl("@text.underline",     { underline = true })
  hl("@text.strike",        { strikethrough = true })
  hl("@text.title",         { fg = c.orange, bold = true })
  hl("@text.literal",       { fg = c.green })
  hl("@text.uri",           { fg = c.blue, underline = true })
  hl("@text.math",          { fg = c.purple })
  hl("@text.environment",   { fg = c.orange })
  hl("@text.environment.name", { fg = c.orange_dim })
  hl("@text.reference",     { fg = c.orange, underline = true })
  hl("@text.todo",          { fg = c.orange, bold = true })
  hl("@text.note",          { fg = c.blue, bold = true })
  hl("@text.warning",       { fg = c.yellow, bold = true })
  hl("@text.danger",        { fg = c.red, bold = true })
  hl("@text.diff.add",      { fg = c.green })
  hl("@text.diff.delete",   { fg = c.red })
  hl("@text.diff.change",   { fg = c.orange })

  -- Markdown specific
  hl("@markup.heading",     { fg = c.orange, bold = true })
  hl("@markup.link",        { fg = c.blue, underline = true })
  hl("@markup.link.label",  { fg = c.fg_dim })
  hl("@markup.link.url",    { fg = c.blue, underline = true })
  hl("@markup.list",        { fg = c.orange })
  hl("@markup.raw",         { fg = c.green })
  hl("@markup.quote",       { fg = c.fg_muted, italic = true })
end

-- ═══════════════════════════════════════════════════════════════  LSP / Diagnostic

local function setup_lsp()
  -- Diagnostic text highlights
  hl("DiagnosticError",       { fg = c.red })
  hl("DiagnosticWarn",        { fg = c.yellow })
  hl("DiagnosticInfo",        { fg = c.blue })
  hl("DiagnosticHint",        { fg = c.hint })
  hl("DiagnosticOk",          { fg = c.green })

  -- Underline decorations
  hl("DiagnosticUnderlineError", { sp = c.red, undercurl = true })
  hl("DiagnosticUnderlineWarn",  { sp = c.yellow, undercurl = true })
  hl("DiagnosticUnderlineInfo",  { sp = c.blue, undercurl = true })
  hl("DiagnosticUnderlineHint",  { sp = c.hint, undercurl = true })
  hl("DiagnosticUnderlineOk",    { sp = c.green, undercurl = true })

  -- Sign column
  hl("DiagnosticSignError",   { fg = c.red })
  hl("DiagnosticSignWarn",    { fg = c.yellow })
  hl("DiagnosticSignInfo",    { fg = c.blue })
  hl("DiagnosticSignHint",    { fg = c.hint })
  hl("DiagnosticSignOk",      { fg = c.green })

  -- Floating window
  hl("DiagnosticFloatingError", { fg = c.red })
  hl("DiagnosticFloatingWarn",  { fg = c.yellow })
  hl("DiagnosticFloatingInfo",  { fg = c.blue })
  hl("DiagnosticFloatingHint",  { fg = c.hint })
  hl("DiagnosticFloatingOk",    { fg = c.green })

  -- Virtual text
  hl("DiagnosticVirtualTextError", { fg = c.red })
  hl("DiagnosticVirtualTextWarn",  { fg = c.yellow })
  hl("DiagnosticVirtualTextInfo",  { fg = c.blue })
  hl("DiagnosticVirtualTextHint",  { fg = c.hint })
  hl("DiagnosticVirtualTextOk",    { fg = c.green })

  -- LSP references
  hl("LspReferenceText",     { bg = c.bg_highlight })
  hl("LspReferenceRead",     { bg = c.bg_highlight })
  hl("LspReferenceWrite",    { bg = c.bg_highlight })

  -- LSP inlay hints
  hl("LspInlayHint",        { fg = c.hint, bg = c.bg_alt })

  -- LSP semantic tokens (fallback to Treesitter groups is standard)
  hl("@lsp.type.keyword",       { link = "@keyword" })
  hl("@lsp.type.string",        { link = "@string" })
  hl("@lsp.type.number",        { link = "@number" })
  hl("@lsp.type.boolean",       { link = "@boolean" })
  hl("@lsp.type.function",      { link = "@function" })
  hl("@lsp.type.method",        { link = "@function.method" })
  hl("@lsp.type.variable",      { link = "@variable" })
  hl("@lsp.type.parameter",     { link = "@variable.parameter" })
  hl("@lsp.type.property",      { link = "@property" })
  hl("@lsp.type.type",          { link = "@type" })
  hl("@lsp.type.class",         { link = "@type" })
  hl("@lsp.type.interface",     { link = "@type" })
  hl("@lsp.type.namespace",     { link = "@namespace" })
  hl("@lsp.type.enum",          { link = "@type" })
  hl("@lsp.type.enumMember",    { link = "@constant" })
  hl("@lsp.type.macro",         { link = "@constant.macro" })
  hl("@lsp.type.decorator",     { link = "@attribute" })
  hl("@lsp.type.comment",       { link = "@comment" })

  -- Code actions
  hl("LspCodeLens",           { fg = c.fg_muted })
  hl("LspCodeLensSeparator",  { fg = c.border })
  hl("LspSignatureActiveParameter", { fg = c.orange, bold = true })
end

-- ═══════════════════════════════════════════════════════════════  Plugins

local function setup_plugins()
  -- Git signs
  hl("GitSignsAdd",         { fg = c.git_add })
  hl("GitSignsChange",      { fg = c.git_change })
  hl("GitSignsDelete",      { fg = c.git_delete })
  hl("GitSignsAddLn",       { fg = c.git_add })
  hl("GitSignsChangeLn",    { fg = c.git_change })
  hl("GitSignsDeleteLn",    { fg = c.git_delete })

  hl("GitSignsAddInline",       { fg = c.git_add })
  hl("GitSignsDeleteInline",    { fg = c.git_delete })
  hl("GitSignsChangeInline",    { fg = c.git_change })

  -- Telescope
  hl("TelescopeNormal",           { fg = c.fg, bg = c.bg_sidebar })
  hl("TelescopeBorder",           { fg = c.border, bg = c.bg_sidebar })
  hl("TelescopePromptNormal",     { fg = c.fg, bg = c.bg_alt })
  hl("TelescopePromptBorder",     { fg = c.border, bg = c.bg_alt })
  hl("TelescopePromptCounter",    { fg = c.comment })
  hl("TelescopeResultsTitle",     { fg = c.comment })
  hl("TelescopePreviewTitle",     { fg = c.comment })
  hl("TelescopePromptTitle",      { fg = c.orange, bold = true })
  hl("TelescopeSelection",        { bg = c.bg_highlight })
  hl("TelescopeSelectionCaret",   { fg = c.orange })
  hl("TelescopeMultiSelection",   { bg = c.bg_highlight })
  hl("TelescopeMatching",         { fg = c.orange, bold = true })
  hl("TelescopeResultsDiffAdd",    { fg = c.git_add })
  hl("TelescopeResultsDiffChange", { fg = c.git_change })
  hl("TelescopeResultsDiffDelete", { fg = c.git_delete })

  -- WhichKey
  hl("WhichKey",          { fg = c.orange })
  hl("WhichKeyGroup",     { fg = c.cyan })
  hl("WhichKeyDesc",      { fg = c.fg })
  hl("WhichKeySeparator", { fg = c.comment })
  hl("WhichKeyBorder",    { fg = c.border })
  hl("WhichKeyFloat",     { bg = c.bg_float })
  hl("WhichKeyTitle",     { fg = c.orange, bold = true })

  -- lazy.nvim
  hl("LazyNormal",           { fg = c.fg, bg = c.bg_float })
  hl("LazyButton",           { fg = c.fg, bg = c.bg_highlight })
  hl("LazyButtonActive",     { fg = c.bg, bg = c.orange })
  hl("LazyTitle",            { fg = c.orange, bold = true })
  hl("LazyReasonRuntime",    { fg = c.blue })
  hl("LazyReasonCmd",        { fg = c.green })
  hl("LazyReasonSource",     { fg = c.cyan })
  hl("LazyReasonEvent",      { fg = c.purple })
  hl("LazyReasonStart",      { fg = c.green })
  hl("LazyReasonPlugin",     { fg = c.orange })
  hl("LazyReasonImport",     { fg = c.blue })
  hl("LazyReasonKeys",       { fg = c.orange })
  hl("LazyReasonFt",         { fg = c.cyan })
  hl("LazyH1",               { fg = c.orange, bold = true })
  hl("LazyH2",               { fg = c.fg_dim, bold = true })
  hl("LazyProp",             { fg = c.fg_muted })
  hl("LazySpecial",          { fg = c.green })
  hl("LazyUrl",              { fg = c.blue, underline = true })
  hl("LazyCommit",           { fg = c.cyan })
  hl("LazyCommitScope",      { fg = c.orange })
  hl("LazyCommitType",       { fg = c.purple })
  hl("LazyTaskOutput",       { fg = c.fg })

  -- Notify
  hl("NotifyBackground",     { bg = c.bg_float })
  hl("NotifyERRORBorder",    { fg = c.red })
  hl("NotifyWARNBorder",     { fg = c.yellow })
  hl("NotifyINFOBorder",     { fg = c.blue })
  hl("NotifyDEBUGBorder",    { fg = c.comment })
  hl("NotifyTRACEBorder",    { fg = c.comment })
  hl("NotifyERRORIcon",      { fg = c.red })
  hl("NotifyWARNIcon",       { fg = c.yellow })
  hl("NotifyINFOIcon",       { fg = c.blue })
  hl("NotifyDEBUGIcon",      { fg = c.comment })
  hl("NotifyTRACEIcon",      { fg = c.comment })
  hl("NotifyERRORTitle",     { fg = c.red, bold = true })
  hl("NotifyWARNTitle",      { fg = c.yellow, bold = true })
  hl("NotifyINFOTitle",      { fg = c.blue, bold = true })
  hl("NotifyDEBUGTitle",     { fg = c.comment, bold = true })
  hl("NotifyTRACETitle",     { fg = c.comment, bold = true })
  hl("NotifyERRORBody",      { fg = c.fg })
  hl("NotifyWARNBody",       { fg = c.fg })
  hl("NotifyINFOBody",       { fg = c.fg })
  hl("NotifyDEBUGBody",      { fg = c.fg_dim })
  hl("NotifyTRACEBody",      { fg = c.fg_dim })

  -- Alpha (dashboard)
  hl("AlphaHeader",          { fg = c.orange, bold = true })
  hl("AlphaHeaderLabel",     { fg = c.orange })
  hl("AlphaButtons",         { fg = c.fg })
  hl("AlphaShortcut",        { fg = c.orange, bold = true })
  hl("AlphaFooter",          { fg = c.comment })

  -- WhichKey (alias that alpha uses)
  hl("DashboardHeader",      { fg = c.orange, bold = true })
  hl("DashboardCenter",      { fg = c.fg })
  hl("DashboardCenterIcon",  { fg = c.orange })
  hl("DashboardShortcut",    { fg = c.orange })
  hl("DashboardFooter",      { fg = c.comment })

  -- nvim-treesitter-context
  hl("TreesitterContext",             { bg = c.bg_alt })
  hl("TreesitterContextLineNumber",   { fg = c.line_nr })

  -- Flash
  hl("FlashLabel",           { fg = c.bg, bg = c.orange, bold = true })
  hl("FlashMatch",           { fg = c.orange, bold = true })
  hl("FlashCurrent",         { fg = c.orange_bright, bold = true })

  -- Mini
  hl("MiniCompletionActiveParameter", { underline = true })
  hl("MiniCursorword",                { underline = true })
  hl("MiniIndentscopeSymbol",         { fg = c.whitespace })
  hl("MiniJump",                      { fg = c.orange, bold = true })
  hl("MiniStarterCurrent",            { link = "AlphaShortcut" })
  hl("MiniStatuslineDevinfo",         { fg = c.fg_muted })
  hl("MiniStatuslineFileinfo",        { fg = c.fg_muted })
  hl("MiniTablineModifiedCurrent",    { fg = c.orange })
  hl("MiniTablineModifiedVisible",    { fg = c.fg_dim })
  hl("MiniTablineModifiedHidden",     { fg = c.comment })
  hl("MiniTrailspace",                { bg = c.red })
end

-- ═══════════════════════════════════════════════════════════════  Terminal

local function setup_terminal()
  local term_colors = {
    c.nontext,        -- 0  Black
    c.red,            -- 1  Red
    c.green,          -- 2  Green
    c.yellow,         -- 3  Yellow
    c.blue,           -- 4  Blue
    c.purple,         -- 5  Magenta / Purple
    c.cyan,           -- 6  Cyan
    c.fg_muted,       -- 7  White
    c.comment,        -- 8  Bright Black
    c.red_bright,     -- 9  Bright Red
    c.green_bright,   -- 10 Bright Green
    c.yellow,         -- 11 Bright Yellow
    c.blue,           -- 12 Bright Blue
    c.purple,         -- 13 Bright Magenta
    c.cyan,           -- 14 Bright Cyan
    c.fg,             -- 15 Bright White
  }

  -- Apply to all terminal UI contexts
  vim.g.terminal_color_0  = term_colors[1]
  vim.g.terminal_color_1  = term_colors[2]
  vim.g.terminal_color_2  = term_colors[3]
  vim.g.terminal_color_3  = term_colors[4]
  vim.g.terminal_color_4  = term_colors[5]
  vim.g.terminal_color_5  = term_colors[6]
  vim.g.terminal_color_6  = term_colors[7]
  vim.g.terminal_color_7  = term_colors[8]
  vim.g.terminal_color_8  = term_colors[9]
  vim.g.terminal_color_9  = term_colors[10]
  vim.g.terminal_color_10 = term_colors[11]
  vim.g.terminal_color_11 = term_colors[12]
  vim.g.terminal_color_12 = term_colors[13]
  vim.g.terminal_color_13 = term_colors[14]
  vim.g.terminal_color_14 = term_colors[15]
  vim.g.terminal_color_15 = term_colors[16]
end

-- ═══════════════════════════════════════════════════════════════  Public API

function M.setup()
  vim.api.nvim_command("hi clear")
  if vim.g.colors_name then
    vim.api.nvim_command("hi clear")
  end
  vim.g.colors_name = "droid-black"

  setup_editor_ui()
  setup_syntax()
  setup_treesitter()
  setup_lsp()
  setup_plugins()
  setup_terminal()
end

return M
