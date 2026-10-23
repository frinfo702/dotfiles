local map = vim.keymap.set
local pick = function(name, opts)
  return function()
    Snacks.picker[name](opts)
  end
end

map("i", "jk", "<Esc>")
map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gl", vim.diagnostic.open_float, { desc = "Diagnostic float" })

-- helix A-j / A-k: move line(s)
map("n", "<M-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<M-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("x", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move lines down", silent = true })
map("x", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move lines up", silent = true })

-- helix goto mode (g*). Drop nvim's gr* defaults so `gr` doesn't wait for more keys.
for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
  pcall(vim.keymap.del, "n", lhs)
end
pcall(vim.keymap.del, "x", "gra")
map("n", "gd", pick("lsp_definitions"), { desc = "Goto definition" })
map("n", "gD", pick("lsp_declarations"), { desc = "Goto declaration" })
map("n", "gy", pick("lsp_type_definitions"), { desc = "Goto type definition" })
map("n", "gi", pick("lsp_implementations"), { desc = "Goto implementation" })
map("n", "gr", pick("lsp_references"), { desc = "Goto references", nowait = true })

-- helix space mode
map("n", "<leader>f", pick("files"), { desc = "File picker" })
map("n", "<leader>b", pick("buffers"), { desc = "Buffer picker" })
map("n", "<leader>j", pick("jumps"), { desc = "Jumplist picker" })
map("n", "<leader>s", pick("lsp_symbols"), { desc = "Symbol picker" })
map("n", "<leader>S", pick("lsp_workspace_symbols"), { desc = "Workspace symbol picker" })
map("n", "<leader>d", pick("diagnostics_buffer"), { desc = "Diagnostic picker" })
map("n", "<leader>D", pick("diagnostics"), { desc = "Workspace diagnostic picker" })
map("n", "<leader>/", pick("grep"), { desc = "Global search" })
map("n", "<leader>'", pick("resume"), { desc = "Last picker" })
map("n", "<leader>?", pick("commands"), { desc = "Command palette" })
map("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "File explorer" })
map("n", "<leader>k", vim.lsp.buf.hover, { desc = "Hover" })
map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "x" }, "<leader>F", function()
  require("conform").format({ async = true })
end, { desc = "Format" })
map("n", "<leader>c", "gcc", { desc = "Toggle comment", remap = true })
map("x", "<leader>c", "gc", { desc = "Toggle comment", remap = true })
map("n", "<leader>,", "<cmd>Settings<cr>", { desc = "Settings" })

map("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "LazyGit" })
map("n", "<leader>gs", pick("git_status"), { desc = "Changed files" })
map("n", "<leader>gd", function()
  Snacks.terminal("lazydocker")
end, { desc = "LazyDocker" })

require("which-key").add({
  { "<leader>g", group = "Git / Docker" },
  { "<leader>y", group = "Yank path", mode = { "n", "x" } },
})
