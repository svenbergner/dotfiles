-- Common keymaps for neovim which are not plugin specific.
-- use jk as alternative for ESC key to go back to normal mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "ESC back to normal mode" })

-- Prevent x and the delete key from overriding what's in the clipboard.
vim.keymap.set("n", "x", '"_x', { desc = "Delete char under cursor without yank" })
vim.keymap.set("n", "X", '"_X', { desc = "Delete char before cursor without yank" })
vim.keymap.set("n", "<Del>", '"_x', { desc = "Delete char under cursor without yank" })
vim.keymap.set("n", "<BS>", '"_X', { desc = "Delete char before cursor without yank" })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Switch Buffers
vim.keymap.set("n", "<PageUp>", "<cmd>bp<CR>", { silent = true, desc = "Goto next buffer" })
vim.keymap.set("n", "<PageDown>", "<cmd>bn<CR>", { silent = true, desc = "Goto previous buffer" })

-- Replace visual selection by pasting without changing paste buffer
vim.keymap.set("v", "p", '"_dP', { desc = "Replace visual selection" })

-- Yank from cursor till end of line
vim.keymap.set("n", "Y", "y$", { desc = "Yank from cursor till end of line" })

-- Save and source current file
-- vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { silent = true, desc = "Source the current line." })
vim.keymap.set("n", "<leader><leader>x", "<cmd>w<CR><cmd>source %<CR>",
   { silent = true, desc = "Safe and source the current file." })

-- Format current buffer
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format current buffer" })

-- Toggle folds
vim.keymap.set("n", "<leader>zz", "za", { silent = true, desc = "Toggle current fold" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <c-\><c-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Escape Escape exits terminal mode' })
vim.keymap.set('n', '<esc><esc>', '<c-w><c-q>', { desc = 'Escape Escape closes current buffer' })

-- Use `Q` to play the macro recorded in `@q`
vim.keymap.set('n', 'Q', '@q')

-- Goto prev/next item in quickfixlist
vim.keymap.set('n', '<F8>', ':cn<CR>', { silent = true, desc = 'Goto next item in Quickfix-List' })
vim.keymap.set('n', '<S-F8>', ':cp<CR>', { silent = true, desc = 'Goto previous item in Quickfix-List' })
vim.keymap.set('n', '<F20>', ':cp<CR>', { silent = true, desc = 'Goto previous item in Quickfix-List' })

-- Copy filename to clipboard
vim.keymap.set('n', '<leader>cfn', '<cmd>let @+=@%<CR>', { silent = true, desc = 'Copy filename to clipboard' })
