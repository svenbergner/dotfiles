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

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Switch Buffers
vim.keymap.set("n", "<PageUp>", ":bp<CR>", { silent = true, desc = "Goto next buffer" })
vim.keymap.set("n", "<PageDown>", ":bn<CR>", { silent = true, desc = "Goto previous buffer" })

-- Move between splits with CTRL + hjkl
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { silent = true, desc = "Move to the left split" })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true, desc = "Move to the down split" })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { silent = true, desc = "Move to the upper split" })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true, desc = "Move to the right split" })

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

-- 
vim.keymap.set("v", "p", '"_dP', { desc = "" })
vim.keymap.set("n", "Y", "y$", { desc = "" })

-- Move current line down and up
vim.keymap.set("n", "<M-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<M-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Save and source current file
vim.keymap.set("n", "<leader><leader>x", ":w<CR>:source %<CR>",
   { silent = true, desc = "Safe and source the current file." })

-- Format current buffer
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format current buffer" })

-- Toggle folds
vim.keymap.set("n", "zz", "za", { silent = true, desc = "Toggle current fold" })

-- Close current buffer without closing the window
vim.keymap.set("n", "<leader>Q", ":enew<bar>bd #<CR>",
   { silent = true, desc = "Close current buffer but leave window open" })

-- Insert empty lines without switch to insert mode
vim.keymap.set("n", "<return>", ':<C-u>call append(line("."), repeat([""], v:count1))<CR>',
   { silent = true, desc = "Insert empty line below current line without switch to insert mode" })
vim.keymap.set("n", "<leader><return>", ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
   { silent = true, desc = "Insert empty line above current line without switch to insert mode" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <c-\><c-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Escape Escape exits terminal mode' })

-- `U` to undo
vim.keymap.set('n', 'U', '<C-R>')

-- Use `Q` to play the macro recorded in `@q`
vim.keymap.set('n', 'Q', '@q')

-- Better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', '>', '>>_')
vim.keymap.set('n', '<', '<<_')
