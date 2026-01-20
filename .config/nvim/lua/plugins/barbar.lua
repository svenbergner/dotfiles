--[===[
BarBar
Tabs, as understood by any other editor.

The barbar.nvim is a tabline plugin with re-orderable, auto-sizing, clickable tabs,
icons, nice highlighting, sort-by commands and a magic jump-to-buffer mode.

Plus the tab names are made unique when two filenames match.
In jump-to-buffer mode, tabs display a target letter instead of their icon.
Jump to any buffer by simply typing their target letter. Even better, the
target letter stays constant for the lifetime of the buffer, so if you're
working with a set of files you can even type the letter ahead from memory.

URL: https://github.com/romgrk/barbar.nvim
--]===]

return {
   {
      'romgrk/barbar.nvim',
      enabled = true,
      dependencies = {
         'lewis6991/gitsigns.nvim',
         -- { 'svenbergner/gitsigns.nvim', dev = true },
         'nvim-tree/nvim-web-devicons',
      },
      init = function()
         vim.g.barbar_auto_setup = false
         local map = vim.api.nvim_set_keymap

         -- Move to previous/next
         map('n', '<M-,>', '<Cmd>BufferPrevious<CR>', { noremap = true, silent = true, desc = 'Goto previous buffer' })
         map('n', '<M-.>', '<Cmd>BufferNext<CR>', { noremap = true, silent = true, desc = 'Goto next buffer' })

         -- Re-order to previous/next
         map(
            'n',
            '<M-<>',
            '<Cmd>BufferMovePrevious<CR>',
            { noremap = true, silent = true, desc = 'Move current buffer to the left' }
         )
         map(
            'n',
            '<M->>',
            '<Cmd>BufferMoveNext<CR>',
            { noremap = true, silent = true, desc = 'Move current buffer to the right' }
         )

         -- Goto buffer in position...
         map('n', '<M-1>', '<Cmd>BufferGoto 1<CR>', { noremap = true, silent = true, desc = 'Goto buffer 1' })
         map('n', '<M-2>', '<Cmd>BufferGoto 2<CR>', { noremap = true, silent = true, desc = 'Goto buffer 2' })
         map('n', '<M-3>', '<Cmd>BufferGoto 3<CR>', { noremap = true, silent = true, desc = 'Goto buffer 3' })
         map('n', '<M-4>', '<Cmd>BufferGoto 4<CR>', { noremap = true, silent = true, desc = 'Goto buffer 4' })
         map('n', '<M-5>', '<Cmd>BufferGoto 5<CR>', { noremap = true, silent = true, desc = 'Goto buffer 5' })
         map('n', '<M-6>', '<Cmd>BufferGoto 6<CR>', { noremap = true, silent = true, desc = 'Goto buffer 6' })
         map('n', '<M-7>', '<Cmd>BufferGoto 7<CR>', { noremap = true, silent = true, desc = 'Goto buffer 7' })
         map('n', '<M-8>', '<Cmd>BufferGoto 8<CR>', { noremap = true, silent = true, desc = 'Goto buffer 8' })
         map('n', '<M-9>', '<Cmd>BufferGoto 9<CR>', { noremap = true, silent = true, desc = 'Goto buffer 9' })
         map('n', '<M-0>', '<Cmd>BufferLast<CR>', { noremap = true, silent = true, desc = 'Goto last buffer' })

         -- Pin/unpin buffer
         map('n', '<M-p>', '<Cmd>BufferPin<CR>', { noremap = true, silent = true, desc = 'Pin current buffer' })

         -- Close buffer
         -- :BufferCloseAllButCurrent
         -- :BufferCloseAllButPinned
         -- :BufferWipeout
         map('n', '<M-c>', '<Cmd>BufferClose<CR>', { noremap = true, silent = true, desc = 'Close current buffer' })
         map('n', '<M-x>', '<Cmd>BufferClose<CR>', { noremap = true, silent = true, desc = 'Close current buffer' })
         map('n', '<D-x>', '<Cmd>BufferClose<CR>', { noremap = true, silent = true, desc = 'Close current buffer' })
         map(
            'n',
            '<Leader>br',
            '<Cmd>BufferCloseBuffersRight<CR>',
            { noremap = true, silent = true, desc = 'Close all buffers to right' }
         )
         map(
            'n',
            '<Leader>bl',
            '<Cmd>BufferCloseBuffersLeft<CR>',
            { noremap = true, silent = true, desc = 'Close all buffers to the left' }
         )
         map(
            'n',
            '<Leader>bc',
            '<Cmd>BufferCloseAllButCurrentOrPinned<CR>',
            { noremap = true, silent = true, desc = 'Close all buffers but the current and pinned' }
         )

         -- Magic buffer-picking mode
         map(
            'n',
            '<Leader>bp',
            '<Cmd>BufferPick<CR>',
            { noremap = true, silent = true, desc = 'Magic buffer-picking mode' }
         )

         -- Sort automatically by...
         map(
            'n',
            '<Leader>bob',
            '<Cmd>BufferOrderByBufferNumber<CR>',
            { noremap = true, silent = true, desc = '[b]uffer number' }
         )
         map(
            'n',
            '<Leader>bon',
            '<Cmd>BufferOrderByName<CR>',
            { noremap = true, silent = true, desc = 'buffer [n]ame' }
         )
         map(
            'n',
            '<Leader>bod',
            '<Cmd>BufferOrderByDirectory<CR>',
            { noremap = true, silent = true, desc = 'buffer [d]irectory' }
         )
         map(
            'n',
            '<Leader>bol',
            '<Cmd>BufferOrderByLanguage<CR>',
            { noremap = true, silent = true, desc = 'buffer [l]anguage' }
         )
         map(
            'n',
            '<Leader>bow',
            '<Cmd>BufferOrderByWindowNumber<CR>',
            { noremap = true, silent = true, desc = '[w]indow number' }
         )

         vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            callback = function()
               vim.api.nvim_set_hl(0, 'BufferCurrentMod', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferVisibleMod', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferDefaultCurrentModBtn', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferDefaultVisibleModBtn', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferCurrentModBtn', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferVisibleModBtn', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferInactiveMod', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferDefaultInactiveModBtn', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferInactiveModBtn', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferAlternateMod', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferDefaultAlternateModBtn', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferAlternateModBtn', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferDefaultCurrentMod', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferDefaultVisibleMod', { link = 'GruvboxOrange' })
               vim.api.nvim_set_hl(0, 'BufferDefaultInactiveMod', { link = 'GruvboxOrange' })
            end,
         })
      end,
      opts = {
         animation = false,
         auto_hide = false,
         clickable = true,
         insert_at_end = true,
         insert_at_start = false,
         tabpages = false,
         exclude_ft = { 'terminal' },
         exclude_name = { 'NvimTree', '__FLUTTER_DEV_LOG__' },
         icons = {
            button = '✗', -- alternative: ❌
            buffer_index = true,
            filetype = { enable = true },
            -- Enables / disables diagnostic symbols
            diagnostics = {
               [vim.diagnostic.severity.ERROR] = { enabled = true, icon = ' ' },
               [vim.diagnostic.severity.WARN] = { enabled = true, icon = ' ' },
               [vim.diagnostic.severity.INFO] = { enabled = true, icon = ' ' },
               [vim.diagnostic.severity.HINT] = { enabled = true, icon = ' ' },
            },
            visible = { modified = { buffer_number = false } },
            gitsigns = {
               added = { enabled = true, icon = ' ' },
               changed = { enabled = true, icon = ' ' },
               deleted = { enabled = true, icon = '⊟ ' },
            },
         },
         sidebar_filetypes = {
            NvimTree = true,
            ['neo-tree'] = { event = 'BufWipeout' },
         },
      },
   },
}
