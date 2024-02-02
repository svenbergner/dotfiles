-- Map leader and localleader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Prevent x and the delete key from overriding what's in the clipboard.
vim.keymap.set("n", "x", '"_x', { desc = "Delete char under cursor without yank" })
vim.keymap.set("n", "X", '"_X', { desc = "Delete char before cursor without yank" })
vim.keymap.set("n", "<Del>", '"_x', { desc = "Delete char under cursor without yank" })

-- Backspace deletes indent, end of line and
vim.g.backspace = "indent,eol,start"

-- use jk as alternative for ESC key to go back to normal mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "ESC back to normal mode" })

-- Switch Buffers
vim.keymap.set("n", "<PageUp>", ":bp<CR>", { silent = true, desc = "Goto next buffer" })
vim.keymap.set("n", "<PageDown>", ":bn<CR>", { silent = true, desc = "Goto previous buffer" })

-- Move between splits with CTRL + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to the left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to the down split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to the upper split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to the right split" })

-- Make adjusting split sizes a bit more friendly
vim.keymap.set("n", "<C-S-Left>", ":vertical resize -1<CR>", { silent = true, desc = "Increase current window width" })
vim.keymap.set("n", "<C-S-Right>", ":vertical resize +1<CR>", { silent = true, desc = "Decrease current window width" })
vim.keymap.set("n", "<C-S-Up>", ":resize +1<CR>", { silent = true, desc = "Increase current window height" })
vim.keymap.set("n", "<C-S-Down>", ":resize -1<CR>", { silent = true, desc = "Decrease current window height" })

-- Change 2 split windows from vert to horiz or horiz to vert
vim.keymap.set("n", "<leader>th", "<C-w>t<C-w>H", { desc = "" })
vim.keymap.set("n", "<leader>tk", "<C-w>t<C-w>K", { desc = "" })

-- Create and change tabs
vim.keymap.set("n", "te", ":tabedit", { desc = "Open new tab" })
vim.keymap.set("n", "<tab>", ":tabnext<Return>", { silent = true, desc = "Goto next tab" })
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>", { silent = true, desc = "Goto previous tab" })

vim.keymap.set("v", "p", '"_dP', { desc = "" })
vim.keymap.set("n", "Y", "y$", { desc = "" })

-- Move current line down and up
vim.keymap.set("n", "<C-Down>", "ddp", { desc = "Move current line up" })
vim.keymap.set("n", "<C-Up>", "ddkP", { desc = "Move current line down" })

-- Save and source current file
vim.keymap.set("n", "<leader><leader>x", ":w<CR>:source %<CR>",
   { silent = true, desc = "Safe and source the current file." })

-- Format current buffer
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format current buffer" })

-- Toggle folds
vim.keymap.set("n", "zz", "za", { silent = true, desc = "Toggle current fold" } )

-- Close current buffer without closing the window
vim.keymap.set("n", "<leader>Q", ":enew<bar>bd #<CR>", { silent = true, desc = "Close current buffer but leave window open" } )
