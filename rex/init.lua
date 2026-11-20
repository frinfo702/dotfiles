require("rexdiff")

-- ===========================================================================
-- tmux (~/.tmux.conf, ~/.tmux/base.conf): nothing to bind.
-- Every line is an option, a copy-mode-vi binding, a plugin or a startup
-- shell command, none of which has a counterpart in Rex.
-- ===========================================================================

-- ===========================================================================
-- Herdr (~/.config/herdr/config.toml): nothing to bind (only `onboarding`).
-- ===========================================================================

-- ===========================================================================
-- Ghostty (~/.config/ghostty/config): nothing to bind (font/theme/window
-- settings only; set font and theme in Rex Settings).
-- ===========================================================================

-- ===========================================================================
-- zellij (~/.config/zellij/config.kdl)
-- The file has no clear-defaults=true, so zellij's own defaults were also in
-- effect there; only the bindings written in the file are migrated.
-- normal mode = no Rex mode. locked/resize/pane/move/tab/tmux = Rex modes.
-- scroll, search, entersearch, session, renametab, renamepane are not created:
-- none of their actions has a Rex counterpart (see migration report).
-- ===========================================================================
rex.action{
  name  = "then_normal",
  title = "Run an action and return to normal mode",
  args  = { action = "string", args = "object?" },
  run   = function(ctx, args)
    rex.client.queue(args.action, args.args or {})
    rex.client.queue("client.mode.exit_all")
  end,
}

for _, m in ipairs({ "resize", "pane", "move", "tab", "tmux" }) do
  rex.mode(m, { exclusive = true })
end

-- Keys zellij binds in every mode except locked (shared_except "locked" and
-- the shared_except "<mode>" "locked" mode switches). prefix "" = normal mode.
local function shared(prefix, self)
  rex.bind(prefix .. "ctrl+g", "client.mode.enter", { name = "locked" })  -- config.kdl:178
  rex.bind(prefix .. "alt+n", "pane.split", { direction = "auto" })       -- :181
  rex.bind(prefix .. "alt+i", "client.tab.move", { direction = "backward" }) -- :182
  rex.bind(prefix .. "alt+o", "client.tab.move", { direction = "forward" })  -- :183
  rex.bind(prefix .. "alt+h", "pane.focus", { direction = "left" })       -- :184
  rex.bind(prefix .. "alt+left", "pane.focus", { direction = "left" })    -- :184
  rex.bind(prefix .. "alt+l", "pane.focus", { direction = "right" })      -- :185
  rex.bind(prefix .. "alt+right", "pane.focus", { direction = "right" })  -- :185
  rex.bind(prefix .. "alt+j", "pane.focus", { direction = "down" })       -- :186
  rex.bind(prefix .. "alt+down", "pane.focus", { direction = "down" })    -- :186
  rex.bind(prefix .. "alt+k", "pane.focus", { direction = "up" })         -- :187
  rex.bind(prefix .. "alt+up", "pane.focus", { direction = "up" })        -- :187
  local enters = { ["ctrl+p"] = "pane", ["ctrl+n"] = "resize", ["ctrl+t"] = "tab",
                   ["ctrl+h"] = "move", ["ctrl+b"] = "tmux" }             -- :199-217
  for key, mode in pairs(enters) do
    if mode == self then
      rex.bind(prefix .. key, "client.mode.exit_all")                     -- own key leaves the mode
    else
      rex.bind(prefix .. key, "client.mode.enter", { name = mode })
    end
  end
  if prefix ~= "" then
    rex.bind(prefix .. "enter", "client.mode.exit_all")                   -- :196
    rex.bind(prefix .. "esc", "client.mode.exit_all")                     -- :196
  end
end

shared("", nil)
for _, m in ipairs({ "resize", "pane", "move", "tab", "tmux" }) do
  shared(m .. "/", m)
end

-- locked: keys pass through to the program; ctrl+g returns to normal (:8)
rex.bind("locked/ctrl+g", "client.mode.exit_all")
for _, k in ipairs({ "alt+n", "alt+i", "alt+o", "alt+h", "alt+left", "alt+l", "alt+right",
                     "alt+j", "alt+down", "alt+k", "alt+up", "ctrl+p", "ctrl+n", "ctrl+t",
                     "ctrl+h", "ctrl+b" }) do
  rex.bind("locked/" .. k, "pane.send_key", { key = k })
end

-- resize (:10-21)
for _, d in ipairs({ { "h", "left" }, { "j", "down" }, { "k", "up" }, { "l", "right" } }) do
  rex.bind("resize/" .. d[1], "pane.resize", { direction = d[2] })
  rex.bind("resize/" .. d[2], "pane.resize", { direction = d[2] })
end

-- pane (:23-41)
for _, d in ipairs({ { "h", "left" }, { "l", "right" }, { "j", "down" }, { "k", "up" } }) do
  rex.bind("pane/" .. d[1], "pane.focus", { direction = d[2] })
  rex.bind("pane/" .. d[2], "pane.focus", { direction = d[2] })
end
rex.bind("pane/p", "pane.focus_next")
rex.bind("pane/n", "then_normal", { action = "pane.split", args = { direction = "auto" } })
rex.bind("pane/d", "then_normal", { action = "pane.split", args = { direction = "down" } })
rex.bind("pane/r", "then_normal", { action = "pane.split", args = { direction = "right" } })
rex.bind("pane/x", "then_normal", { action = "pane.close" })
rex.bind("pane/f", "then_normal", { action = "pane.zoom" })
rex.bind("pane/c", "then_normal", { action = "pane.rename" })

-- move (:42-50)
for _, d in ipairs({ { "h", "left" }, { "j", "down" }, { "k", "up" }, { "l", "right" } }) do
  rex.bind("move/" .. d[1], "pane.move", { direction = d[2] })
  rex.bind("move/" .. d[2], "pane.move", { direction = d[2] })
end

-- tab (:51-72)
rex.bind("tab/r", "then_normal", { action = "client.tab.rename" })
for _, k in ipairs({ "h", "left", "up", "k" }) do rex.bind("tab/" .. k, "client.tab.previous") end
for _, k in ipairs({ "l", "right", "down", "j" }) do rex.bind("tab/" .. k, "client.tab.next") end
rex.bind("tab/n", "then_normal", { action = "client.tab.new" })
rex.bind("tab/x", "then_normal", { action = "client.tab.close" })
rex.bind("tab/b", "then_normal", { action = "pane.move_to_new_tab" })
for i = 1, 9 do
  rex.bind("tab/" .. i, "then_normal", { action = "client.tab.goto", args = { index = i } })
end

-- tmux (:154-176)
rex.bind("tmux/ctrl+b", "then_normal", { action = "pane.send_key", args = { key = "ctrl+b" } })
rex.bind("tmux/shift+'", "then_normal", { action = "pane.split", args = { direction = "down" } })
rex.bind("tmux/shift+5", "then_normal", { action = "pane.split", args = { direction = "right" } })
rex.bind("tmux/z", "then_normal", { action = "pane.zoom" })
rex.bind("tmux/c", "then_normal", { action = "client.tab.new" })
rex.bind("tmux/,", "then_normal", { action = "client.tab.rename" })
rex.bind("tmux/p", "then_normal", { action = "client.tab.previous" })
rex.bind("tmux/n", "then_normal", { action = "client.tab.next" })
for _, d in ipairs({ { "h", "left" }, { "l", "right" }, { "j", "down" }, { "k", "up" } }) do
  rex.bind("tmux/" .. d[1], "then_normal", { action = "pane.focus", args = { direction = d[2] } })
  rex.bind("tmux/" .. d[2], "then_normal", { action = "pane.focus", args = { direction = d[2] } })
end
rex.bind("tmux/o", "pane.focus_next")
rex.bind("tmux/x", "then_normal", { action = "pane.close" })


-- ===========================================================================
-- Pickers (rex.ui.pick): cd the focused terminal into a project under ~/src
-- (laid out ghq-style as <host>/<owner>/<repo>) or a git worktree.
-- Replaces `g` (ghq-fzf) in zsh/dotzshrc.
-- ===========================================================================
local TERMINAL = "com.superlogical.terminal"
local HOME = os.getenv("HOME")
-- Lua doesn't expand ~, so swap it for $HOME here.
local SRC = ("~/src"):gsub("^~", function() return HOME end)

local function sh(argv, opts)
  local r, err = rex.exec(argv, opts)
  if r == nil then error(err, 0) end
  if not r.ok then error(r.stderr, 0) end
  return r.stdout
end

local function tilde(path)
  return (path:gsub("^" .. HOME:gsub("%p", "%%%0"), "~"))
end

-- cd_to types `cd '<dir>'` at the focused terminal's prompt.
local function cd_to(ctx, dir)
  rex.block.call(TERMINAL, "write", {
    block_id = ctx.block_id,
    data = "cd '" .. dir:gsub("'", "'\\''") .. "'\r",
  })
end

-- cwd_of returns the directory the focused terminal is in.
local function cwd_of(ctx)
  local p = rex.block.call(TERMINAL, "pwd", { block_id = ctx.block_id })
  if p and p.pwd then return p.pwd end
  local proc = rex.block.call(TERMINAL, "process", { block_id = ctx.block_id })
  return proc and proc.foreground and proc.foreground.cwd
end

rex.action{
  name  = "project_picker",
  title = "Go to Project…",
  run   = function(ctx)
    local items = {}
    -- .git is a file in worktrees, so match any type.
    local out = sh({ "find", SRC, "-mindepth", "4", "-maxdepth", "4", "-name", ".git" })
    for git in out:gmatch("[^\n]+") do
      local path = git:gsub("/%.git$", "")
      items[#items + 1] = { id = path, title = path:match("[^/]+/[^/]+$"),
                            subtitle = tilde(path), icon = "folder" }
    end
    local dir = rex.ui.pick{ title = "Go to project", placeholder = "Filter projects", items = items }
    if dir then cd_to(ctx, dir) end
  end,
}

rex.action{
  name  = "worktree_picker",
  title = "Go to Worktree…",
  run   = function(ctx)
    local cwd = cwd_of(ctx)
    if cwd == nil then error("can't tell the focused terminal's directory", 0) end
    local items, cur = {}, nil
    -- Kept in a local: `for x in (f() .. s):gmatch(...)` crashes Rex's Lua VM.
    local out = sh({ "git", "worktree", "list", "--porcelain" }, { cwd = cwd })
    for line in out:gmatch("[^\n]+") do
      local path = line:match("^worktree (.+)")
      if path then
        cur = { id = path, title = path:match("[^/]+$"), subtitle = tilde(path), icon = "branch" }
        items[#items + 1] = cur
      elseif cur then
        local branch = line:match("^branch refs/heads/(.+)")
        if branch then cur.title = branch end
        if line == "detached" then cur.detail = "detached" end
      end
    end
    local dir = rex.ui.pick{ title = "Go to worktree", placeholder = "Filter worktrees", items = items }
    if dir then cd_to(ctx, dir) end
  end,
}

-- clone_path maps a clone URL to <host>/<owner>/<repo>, as ghq does:
-- https://github.com/a/b(.git), git@github.com:a/b.git, ssh://git@host:22/a/b.
local function clone_path(url)
  local p = url:gsub("^%s+", ""):gsub("%s+$", "")
  p = p:gsub("^%a[%w+.-]*://", ""):gsub("^[^@/]+@", "")
  p = p:gsub("^([^/:]+):%d+/", "%1/"):gsub("^([^/:]+):", "%1/")
  p = p:gsub("/+$", ""):gsub("%.git$", "")
  if not p:match("^[^/]+/[^/]+/[^/]+$") or p:match("%.%.") then return nil end
  return p
end

rex.action{
  name  = "clone_repository",
  title = "Clone Repository…",
  run   = function(ctx)
    local title, url = "Clone repository", nil
    local rel
    while true do
      url = rex.ui.input{ title = title, placeholder = "Repository URL", value = url, confirm = "Clone" }
      if url == nil or url:match("^%s*$") then return end
      rel = clone_path(url)
      if rel then break end
      title = "Not a <host>/<owner>/<repo> URL: " .. url
    end
    local dir = SRC .. "/" .. rel
    -- Already cloned: just go there.
    if not rex.exec({ "test", "-e", dir }).ok then
      sh({ "git", "clone", "--", (url:gsub("^%s+", ""):gsub("%s+$", "")), dir })
    end
    cd_to(ctx, dir)
  end,
}

-- New worktrees go in <main>/.worktrees/<branch>, not beside <main>, so
-- Go to Project doesn't list them as projects.
rex.action{
  name  = "worktree_new",
  title = "New Worktree…",
  run   = function(ctx)
    local cwd = cwd_of(ctx)
    if cwd == nil then error("can't tell the focused terminal's directory", 0) end
    local common = sh({ "git", "rev-parse", "--path-format=absolute", "--git-common-dir" }, { cwd = cwd })
    local git_dir = common:gsub("%s+$", "")
    local root = git_dir:gsub("/%.git$", "")
    -- Ask again on an invalid name instead of failing the action.
    local title, branch = "New worktree", nil
    while true do
      branch = rex.ui.input{ title = title, placeholder = "Branch name", value = branch, confirm = "Create" }
      if branch == nil then return end
      branch = branch:gsub("^%s+", ""):gsub("%s+$", "")
      if branch == "" then return end
      local r = rex.exec({ "git", "check-ref-format", "--branch", branch }, { cwd = root })
      if r and r.ok then break end
      title = "Not a valid branch name: " .. branch
    end
    -- Ignore .worktrees locally so the main checkout's status stays clean.
    sh({ "/bin/sh", "-c", 'mkdir -p "$1/info" && { grep -qxF /.worktrees/ "$1/info/exclude" 2>/dev/null || echo /.worktrees/ >> "$1/info/exclude"; }',
         "sh", git_dir })
    local path = root .. "/.worktrees/" .. branch
    local function has(ref) local r = rex.exec({ "git", "show-ref", "--verify", "--quiet", ref }, { cwd = root }); return r and r.ok end
    if has("refs/heads/" .. branch) or has("refs/remotes/origin/" .. branch) then
      sh({ "git", "worktree", "add", path, branch }, { cwd = root })
    else
      sh({ "git", "worktree", "add", "-b", branch, path }, { cwd = root })
    end
    cd_to(ctx, path)
  end,
}

rex.bind("alt+cmd+p", "project_picker")
rex.bind("alt+cmd+w", "worktree_picker")
rex.bind("alt+cmd+n", "worktree_new")
rex.bind("alt+cmd+c", "clone_repository")
