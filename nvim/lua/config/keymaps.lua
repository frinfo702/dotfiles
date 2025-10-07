-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "gp", "<C-o>", { desc = "Jump back (jumplist)", silent = true, noremap = true })
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo", noremap = true, silent = true })
