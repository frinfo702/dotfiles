local function copy(text)
  vim.fn.setreg("+", text)
  vim.fn.setreg("*", text)
  vim.fn.setreg('"', text)
  vim.notify("Copied: " .. text)
end

local function current_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return nil
  end
  return file
end

local function line_range(line1, line2)
  if line1 == line2 then
    return tostring(line1)
  end
  return string.format("%d-%d", line1, line2)
end

local function git(dir, args)
  local cmd = { "git", "-C", dir }
  vim.list_extend(cmd, args)
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(table.concat(out, "\n"))
end

local function remote_to_web(url)
  url = url:gsub("%s+$", "")
  url = url:gsub("%.git$", "")
  url = url:gsub("^git@(.-):", "https://%1/")
  url = url:gsub("^ssh://git@", "https://")
  url = url:gsub("^git://", "https://")
  url = url:gsub("^https://[^@]+@", "https://")
  return url
end

local function copy_rel()
  local file = current_file()
  if not file then
    return
  end
  copy(vim.fn.fnamemodify(file, ":."))
end

local function copy_abs()
  local file = current_file()
  if not file then
    return
  end
  copy(vim.fn.fnamemodify(file, ":p"))
end

local function copy_file_line(line1, line2)
  local file = current_file()
  if not file then
    return
  end
  copy(vim.fn.fnamemodify(file, ":t") .. ":" .. line_range(line1, line2))
end

local function copy_permalink(line1, line2)
  local file = current_file()
  if not file then
    return
  end

  local dir = vim.fn.fnamemodify(file, ":h")
  local root = git(dir, { "rev-parse", "--show-toplevel" })
  local sha = git(dir, { "rev-parse", "HEAD" })
  local remote = git(dir, { "remote", "get-url", "origin" })

  if not root or not sha or not remote then
    vim.notify("Not in a git repository with origin", vim.log.levels.WARN)
    return
  end

  local rel
  if file:sub(1, #root) == root then
    rel = file:sub(#root + 2)
  else
    rel = vim.fn.fnamemodify(file, ":.")
  end
  rel = rel:gsub("\\", "/")
  local web = remote_to_web(remote)
  local fragment
  if line1 == line2 then
    fragment = "#L" .. line1
  else
    fragment = string.format("#L%d-L%d", line1, line2)
  end

  copy(string.format("%s/blob/%s/%s%s", web, sha, rel, fragment))
end

vim.api.nvim_create_user_command("CopyRelPath", copy_rel, {
  desc = "Copy current file relative path",
})
vim.api.nvim_create_user_command("CopyAbsPath", copy_abs, {
  desc = "Copy current file absolute path",
})
vim.api.nvim_create_user_command("CopyFileLine", function(opts)
  copy_file_line(opts.line1, opts.line2)
end, {
  range = true,
  desc = "Copy filename with line number",
})
vim.api.nvim_create_user_command("CopyPermalink", function(opts)
  copy_permalink(opts.line1, opts.line2)
end, {
  range = true,
  desc = "Copy GitHub permalink",
})

vim.keymap.set("n", "<leader>yr", "<cmd>CopyRelPath<cr>", { desc = "Copy relative path" })
vim.keymap.set("n", "<leader>ya", "<cmd>CopyAbsPath<cr>", { desc = "Copy absolute path" })
vim.keymap.set("n", "<leader>yl", "<cmd>CopyFileLine<cr>", { desc = "Copy filename:line" })
vim.keymap.set("n", "<leader>yp", "<cmd>CopyPermalink<cr>", { desc = "Copy permalink" })
vim.keymap.set("x", "<leader>yl", ":CopyFileLine<cr>", { desc = "Copy filename:line", silent = true })
vim.keymap.set("x", "<leader>yp", ":CopyPermalink<cr>", { desc = "Copy permalink", silent = true })
