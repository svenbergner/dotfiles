vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<C-p>", ":Files<CR>")
vim.keymap.set("n", "<LEADER>?", ":Maps<CR>")

vim.g.backspace = "indent,eol,start"

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("i", "jk", "<ESC>")

vim.g.splitbelow = true
vim.g.splitright = true

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")


