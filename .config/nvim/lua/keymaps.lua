-- Common keymaps for Neovim that are not plugin-specific.

-- Prevent x and the delete key from overriding what's in the clipboard.
vim.keymap.set("n", "x", '"_x', { desc = "Delete char under cursor without yank" })
vim.keymap.set("n", "X", '"_X', { desc = "Delete char before cursor without yank" })
vim.keymap.set("n", "<Del>", '"_x', { desc = "Delete char under cursor without yank" })
vim.keymap.set("n", "<BS>", '"_X', { desc = "Delete char before cursor without yank" })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Switch Buffers
vim.keymap.set("n", "<PageUp>", "<cmd>bp<CR>", { silent = true, desc = "Go to previous buffer" })
vim.keymap.set("n", "<PageDown>", "<cmd>bn<CR>", { silent = true, desc = "Go to next buffer" })

-- Replace the visual selection by pasting without changing the paste buffer
vim.keymap.set("v", "p", '"_dP', { desc = "Replace visual selection" })

-- Yank from cursor to end of line
vim.keymap.set("n", "Y", "y$", { desc = "Yank from cursor to end of line" })

-- Save and source the current file
vim.keymap.set("n", "<leader>x",
   "<cmd>w<CR><cmd>source %<CR><cmd>lua print('File ' .. vim.fn.expand('%:t') .. ' sourced.')<CR>",
   { silent = true, desc = "Save and e[x]ecute the current file" })

-- Source the current line
vim.keymap.set("n", "<leader>X", ":.lua<CR><cmd>lua print('Current line sourced.')<CR>",
   { silent = true, desc = "E[X]ecute the current line" })

-- Source the current selection
vim.keymap.set("v", "<leader>X", ":lua<CR><cmd>lua print('Current selection sourced.')<CR>",
   { silent = true, desc = "E[X]ecute the current selection" })

vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, { desc = "Format the current buffer" })

-- Exit terminal mode in the built-in terminal with a shortcut that is easier to discover.
-- Otherwise, you normally need to press <c-\><c-n>, which is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Press Escape twice to exit terminal mode' })
vim.keymap.set('n', '<esc><esc>', '<c-w><c-q>', { desc = 'Press Escape twice to close current buffer' })

vim.keymap.set('n', 'Q', '@q', { desc = 'Use [Q] to play the macro recorded in @q' })

-- Go to the previous/next item in the Quickfix-List
vim.keymap.set('n', '<F8>', ':cn<CR>', { silent = true, desc = 'Go to next item in Quickfix-List' })
vim.keymap.set('n', '<S-F8>', ':cp<CR>', { silent = true, desc = 'Go to previous item in Quickfix-List' })
vim.keymap.set('n', '<F20>', ':cp<CR>', { silent = true, desc = 'Go to previous item in Quickfix-List' })

vim.keymap.set('n', '<leader>cfn', '<cmd>let @+=@%<CR>', { silent = true, desc = 'Copy the filename to clipboard' })

vim.keymap.set('n', '<BS>', '^', { desc = 'Move to the first non-blank character in the line' })

-- visual mode keymaps
vim.keymap.set('v', '<leader>r', '\"hy:%s/<C-r>h//g<left><left>', { desc = 'Replace the selection' })
vim.keymap.set('v', '<leader>R', '\"hy:%s/<C-r>h//gc<left><left>', { desc = 'Replace the selection with confirmation' })
vim.keymap.set('v', '<C-s>', ':sort<CR>', { desc = 'Sort the selection' })
vim.keymap.set('v', '<leader>z', ':sort u<CR>', { desc = 'Sort the selection uniquely' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move the selection one line down' })
vim.keymap.set('v', 'K', ":m '>-2<CR>gv=gv", { desc = 'Move the selection one line up' })
