vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Prevent x and the delete key from overriding what's in the clipboard.
vim.keymap.set("n", "x", '"_x', { desc = "Delete char under cursor without yank" })
vim.keymap.set("n", "X", '"_X', { desc = "Delete char before cursor without yank" })
vim.keymap.set("n", "<Del>", '"_x', { desc = "Delete char under cursor without yank" })

vim.g.backspace = "indent,eol,start"

vim.keymap.set("i", "jk", "<ESC>", { desc = "ESC back to normal mode" })

vim.g.splitbelow = true
vim.g.splitright = true

-- Switch Buffers
vim.keymap.set("n", "<PageUp>", ":bp<CR>", { silent = true, desc = "Goto next buffer" })
vim.keymap.set("n", "<PageDown>", ":bn<CR>", { silent = true, desc = "Goto previous buffer" })

-- Move between splits with CTRL + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Make adjusting split sizes a bit more friendly
vim.keymap.set("n", "<C-S-Left>", ":vertical resize -1<CR>", { silent = true, desc = "Increase current window width" })
vim.keymap.set("n", "<C-S-Right>", ":vertical resize +1<CR>", { silent = true, desc = "Decrease current window width" })
vim.keymap.set("n", "<C-S-Up>", ":resize +1<CR>", { silent = true, desc = "Increase current window height" })
vim.keymap.set("n", "<C-S-Down>", ":resize -1<CR>", { silent = true, desc = "Decrease current window height" })

-- Change 2 split windows from vert to horiz or horiz to vert
vim.keymap.set("n", "<leader>th", "<C-w>t<C-w>H")
vim.keymap.set("n", "<leader>tk", "<C-w>t<C-w>K")

-- Create and change tabs
vim.keymap.set("n", "te", ":tabedit", { desc = "Open new tab" })
vim.keymap.set("n", "<tab>", ":tabnext<Return>", { silent = true, desc = "Goto next tab" })
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>", { silent = true, desc = "Goto previous tab" })

vim.keymap.set("v", "p", '"_dP')
vim.keymap.set("n", "Y", "y$")

-- LazyGit
vim.keymap.set("n", "<LEADER>gg", ":LazyGit<CR>", { silent = true, desc = "Open LazyGit overlay" })

-- Move current line down and up
vim.keymap.set("n", "<C-Down>", "ddp", { desc = "Move current line up" })
vim.keymap.set("n", "<C-Up>", "ddkP", { desc = "Move current line down" })

-- Save and source current file
vim.keymap.set("n", "<LEADER><LEADER>x", ":w<CR>:source %<CR>",
    { silent = true, desc = "Safe and source the current file." })

vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
