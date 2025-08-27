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

vim.keymap.set('n', '<M-q>', '@q', { desc = 'Use [M-q] to play the macro recorded in @q' })

-- Go to the previous/next item in the Quickfix-List
vim.keymap.set('n', '<F8>', ':cn<CR>', { silent = true, desc = 'Go to next item in Quickfix-List' })
vim.keymap.set('n', '<S-F8>', ':cp<CR>', { silent = true, desc = 'Go to previous item in Quickfix-List' })
vim.keymap.set('n', '<F20>', ':cp<CR>', { silent = true, desc = 'Go to previous item in Quickfix-List' })

vim.keymap.set('n', '<leader>F', '<cmd>let @+=@%<CR><cmd>lua vim.notify("Filename copied to clipboard")<CR>',
   { silent = true, desc = 'copy [F]ilename to clipboard' })

vim.keymap.set('n', '<BS>', '^', { desc = 'Move to the first non-blank character in the line' })

-- visual mode keymaps
vim.keymap.set('v', '<leader>r', '\"hy:%s/<C-r>h//g<left><left>', { desc = 'Replace the selection' })
vim.keymap.set('v', '<leader>R', '\"hy:%s/<C-r>h//gc<left><left>', { desc = 'Replace the selection with confirmation' })
vim.keymap.set('v', '<C-s>', ':sort<CR>', { desc = 'Sort the selection' })
vim.keymap.set('v', '<leader>z', ':sort u<CR>', { desc = 'Sort the selection uniquely' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move the selection one line down' })
vim.keymap.set('v', 'K', ":m '>-2<CR>gv=gv", { desc = 'Move the selection one line up' })

-- Spelling
vim.keymap.set('n', 'gs', ']s', { desc = 'Next misspelled word' })

-- Add empty lines before and after cursor line
vim.keymap.set('n', 'gO', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
vim.keymap.set('n', 'go', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")

-- Toggle Diff Mode
local function toggle_diff_mode()
   if vim.o.diff then
      vim.cmd('windo diffoff')
   else
      vim.cmd('Neotree close')
      vim.cmd('windo diffthis')
   end
end
vim.keymap.set('n', '<leader>DD', function() toggle_diff_mode() end,
   { desc = 'Toggle [D]iff [D]iff', noremap = true, silent = true })
vim.keymap.set('n', '<leader>DT', ':Neotree close<CR>:windo diffthis<cr>',
   { desc = '[D]iff [T]his', noremap = true, silent = true })
vim.keymap.set('n', '<leader>Do', ':windo diffoff<cr>', { desc = '[D]iff [o]ff', noremap = true, silent = true })

vim.keymap.set('n', '<leader>DC', ':DiffviewClose<cr>', { desc = '[D]iffview [C]lose', noremap = true, silent = true })
vim.keymap.set('n', '<leader>DF', ':DiffviewToggleFiles<cr>',
   { desc = '[D]iffview Toggle [F]iles', noremap = true, silent = true })
vim.keymap.set('n', '<leader>DO', ':DiffviewOpen<cr>', { desc = '[D]iffview [O]pen', noremap = true, silent = true })
vim.keymap.set('n', '<leader>DR', ':DiffviewRefresh<cr>',
   { desc = '[D]iffview [R]efresh', noremap = true, silent = true })

-- Better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', '>', '>>_')
vim.keymap.set('n', '<', '<<_')

-- Quickfix-List
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { silent = true, desc = '[q]uickfix-list: [o]pen ' })
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', { silent = true, desc = '[q]uickfix-list: [c]lose' })
vim.keymap.set('n', '<leader>qq', ':cclose<CR>', { silent = true, desc = '[q]uickfix-list: [q]uit' })
vim.keymap.set('n', '<leader>qf', ':cfirst<CR>', { silent = true, desc = '[q]uickfix-list: Go to [f]irst item' })
vim.keymap.set('n', '<leader>ql', ':clast<CR>', { silent = true, desc = '[q]uickfix-list: Go to [l]ast item' })
vim.keymap.set('n', '<leader>qn', ':cnext<CR>', { silent = true, desc = '[q]uickfix-list: Go to [n]ext item' })
vim.keymap.set('n', '<leader>qp', ':cprevious<CR>', { silent = true, desc = '[q]uickfix-list: Go to [p]revious item' })

-- Toggle true false
local function toggle_true_false()
   vim.cmd('normal! yiw')
   local current_word = vim.fn.getreg('"')
   if current_word == 'true' then
      vim.cmd('normal! ciwfalse')
   elseif current_word == 'false' then
      vim.cmd('normal! ciwtrue')
   end
end

vim.keymap.set('n', '<leader>Tb', function() toggle_true_false() end,
   { desc = '[T]oggle [b]ool', noremap = true, silent = true })
