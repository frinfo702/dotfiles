-- Static options. Anything you'd want to toggle lives in settings.lua / :Settings instead.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.showmode = false
opt.cmdheight = 0
opt.laststatus = 3
opt.fillchars = { eob = " " }
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.smoothscroll = true
opt.scrolloff = 5
opt.undofile = true
opt.updatetime = 300
opt.timeoutlen = 400
opt.completeopt = { "menuone", "noselect", "popup" }
opt.pumheight = 12
