-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "gp", "<C-o>", { desc = "Jump back (jumplist)", silent = true, noremap = true })
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo", noremap = true, silent = true })
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<leader>th", "<cmd>Telescope colorscheme<cr>", { desc = "Switch Theme" })
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Search Grep" })
vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Search Files" })
