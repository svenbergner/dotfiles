-- Set vim language explicitly to english for easier usage with tutorials
vim.api.nvim_exec ('language en_US', true)

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Show current line number and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth=4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hidden = true
vim.opt.wrap = false
vim.wo.wrap = false

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Highlight cursor line
vim.opt.cursorline = true

-- Turn syntax highlighting on.
vim.opt.syntax = on

-- Show lineendings
vim.opt.list = true

vim.g.noerrorbells = true
vim.g.nohlsearch = true
