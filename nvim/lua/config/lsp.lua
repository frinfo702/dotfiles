-- LSP, helix style: no installer, servers come from the project first, then PATH.
-- Config layers per server (later wins):
--   nvim-lspconfig defaults < nvim/lsp/<name>.lua < settings.json "lsp.config" < <project>/.nvim/settings.json "lsp.config"
-- Binary lookup: <root>/node_modules/.bin, <root>/.venv/bin, <root>/venv/bin, then $PATH.
local S = require("config.settings")
local M = {}

-- lspconfig ships these as functions; plain argv lets the lookup below handle them too.
local argv = {
  ts_ls = { "typescript-language-server", "--stdio" },
  biome = { "biome", "lsp-proxy" },
  yamlls = { "yaml-language-server", "--stdio" },
  jsonls = { "vscode-json-language-server", "--stdio" },
  html = { "vscode-html-language-server", "--stdio" },
  cssls = { "vscode-css-language-server", "--stdio" },
}
local cmds = {} -- name -> argv before wrapping

local function local_bin(root, bin)
  for _, dir in ipairs({ "node_modules/.bin", ".venv/bin", "venv/bin" }) do
    local path = vim.fs.joinpath(root, dir, bin)
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
end

--- Absolute path of a server binary, or nil when it isn't installed.
function M.resolve(bin, root)
  if bin:find("/") then
    return vim.fn.executable(bin) == 1 and bin or nil
  end
  local path = (root and local_bin(root, bin)) or local_bin(S.project_root, bin)
  if path then
    return path
  end
  return vim.fn.executable(bin) == 1 and vim.fn.exepath(bin) or nil
end

--- Binary path + where it came from, for the settings panel.
function M.status(name)
  local cmd = cmds[name]
  if not cmd then
    return nil, "no config"
  end
  return M.resolve(cmd[1]), cmd[1]
end

function M.enable(name, on)
  if on and not cmds[name] then
    return
  end
  vim.lsp.enable(name, on and M.status(name) ~= nil)
end

function M.setup()
  for name in pairs(S.get("lsp.servers")) do
    local override = S.get("lsp.config." .. name) or {}
    if next(override) then
      vim.lsp.config(name, override)
    end
    local ok, cfg = pcall(function()
      return vim.lsp.config[name]
    end)
    local cmd = override.cmd or argv[name] or (ok and cfg and cfg.cmd)
    if type(cmd) == "table" then
      cmds[name] = cmd
      vim.lsp.config(name, {
        cmd = function(dispatchers, config)
          local c = vim.deepcopy(cmd)
          c[1] = M.resolve(c[1], config.root_dir) or c[1]
          return vim.lsp.rpc.start(c, dispatchers, {
            cwd = config.cmd_cwd or config.root_dir,
            env = config.cmd_env,
            detached = config.detached,
          })
        end,
      })
    end
  end

  vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "●",
        [vim.diagnostic.severity.WARN] = "●",
        [vim.diagnostic.severity.INFO] = "●",
        [vim.diagnostic.severity.HINT] = "●",
      },
    },
    float = { source = "if_many" },
  })

  vim.api.nvim_create_autocmd("LspProgress", {
    callback = function()
      vim.cmd.redrawstatus()
    end,
  })
end

return M
