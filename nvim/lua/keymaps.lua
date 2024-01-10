vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Prevent x and the delete key from overriding what's in the clipboard.
vim.keymap.set("n", "x", '"_x', { desc = "Delete without yank" })
vim.keymap.set("n", "X", '"_X')
vim.keymap.set("n", "<Del>", '"_x')

vim.keymap.set("n", "<LEADER>?", ":Maps<CR>")

vim.g.backspace = "indent,eol,start"

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("i", "jk", "<ESC>", { desc = "ESC" })

vim.g.splitbelow = true
vim.g.splitright = true

-- Move between splits with CTRL + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Make adjusting split sizes a bit more friendly
vim.keymap.set("n", "<C-S-Left>", ":vertical resize +1<CR>", {silent = true})
vim.keymap.set("n", "<C-S-Right>", ":vertical resize -1<CR>", {silent = true})
vim.keymap.set("n", "<C-S-Up>", ":resize +1<CR>", {silent = true})
vim.keymap.set("n", "<C-S-Down>", ":resize -1<CR>", {silent = true})

-- Change 2 split windows from vert to horiz or horiz to vert
vim.keymap.set("n", "<leader>th", "<C-w>t<C-w>H")
vim.keymap.set("n", "<leader>tk", "<C-w>t<C-w>K")

-- Create and change tabs
vim.keymap.set("n", "te", ":tabedit")
vim.keymap.set("n", "<tab>", ":tabnext<Return>")
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>")

vim.keymap.set("v", "p", '"_dP')
vim.keymap.set("n", "Y", "y$")

-- LazyGit
vim.keymap.set("n", "<LEADER>gg", ":LazyGit<CR>")

-- Move current line down and up
vim.keymap.set( "n", "<C-Down>","ddp")
vim.keymap.set( "n", "<C-Up>","ddkP")

-- Source current file
vim.keymap.set("n","<LEADER>s", ":w<CR>:source %<CR>")

-- Switch Buffers
vim.keymap.set("n","<PageUp>", ":bp<CR>")
vim.keymap.set("n","<PageDown>", ":bn<CR>")
