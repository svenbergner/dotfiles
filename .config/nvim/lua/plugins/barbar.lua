--[===[
Tabs, as understood by any other editor.
barbar.nvim is a tabline plugin with re-orderable, auto-sizing, clickable tabs,
icons, nice highlighting, sort-by commands and a magic jump-to-buffer mode.
Plus the tab names are made unique when two filenames match.
In jump-to-buffer mode, tabs display a target letter instead of their icon.
Jump to any buffer by simply typing their target letter. Even better, the
target letter stays constant for the lifetime of the buffer, so if you're
working with a set of files you can even type the letter ahead from memory.
URL: https://github.com/romgrk/barbar.nvim
--]===]
---@diagnostic disable: inject-field

return {
   {
      'romgrk/barbar.nvim',
      enabled = true,
      dependencies = {
         'lewis6991/gitsigns.nvim',
         'nvim-tree/nvim-web-devicons',
      },
      init = function()
         vim.g.barbar_auto_setup = false
         local map = vim.api.nvim_set_keymap
         local keymap_options = { noremap = true, silent = true }

         -- Move to previous/next
         map('n', '<M-,>', '<Cmd>BufferPrevious<CR>', keymap_options)
         map('n', '<M-.>', '<Cmd>BufferNext<CR>', keymap_options)
         -- Re-order to previous/next
         map('n', '<M-<>', '<Cmd>BufferMovePrevious<CR>', keymap_options)
         map('n', '<M->>', '<Cmd>BufferMoveNext<CR>', keymap_options)
         -- Goto buffer in position...
         map('n', '<M-1>', '<Cmd>BufferGoto 1<CR>', keymap_options)
         map('n', '<M-2>', '<Cmd>BufferGoto 2<CR>', keymap_options)
         map('n', '<M-3>', '<Cmd>BufferGoto 3<CR>', keymap_options)
         map('n', '<M-4>', '<Cmd>BufferGoto 4<CR>', keymap_options)
         map('n', '<M-5>', '<Cmd>BufferGoto 5<CR>', keymap_options)
         map('n', '<M-6>', '<Cmd>BufferGoto 6<CR>', keymap_options)
         map('n', '<M-7>', '<Cmd>BufferGoto 7<CR>', keymap_options)
         map('n', '<M-8>', '<Cmd>BufferGoto 8<CR>', keymap_options)
         map('n', '<M-9>', '<Cmd>BufferGoto 9<CR>', keymap_options)
         map('n', '<M-0>', '<Cmd>BufferLast<CR>', keymap_options)
         -- Pin/unpin buffer
         map('n', '<M-p>', '<Cmd>BufferPin<CR>', keymap_options)
         -- Close buffer
         map('n', '<M-c>', '<Cmd>BufferClose<CR>', keymap_options)
         map('n', '<M-x>', '<Cmd>BufferClose<CR>', keymap_options)
         -- Wipeout buffer
         --                 :BufferWipeout
         -- Close commands
         --                 :BufferCloseAllButCurrent
         --                 :BufferCloseAllButPinned
         --                 :BufferCloseAllButCurrentOrPinned
         --                 :BufferCloseBuffersLeft
         --                 :BufferCloseBuffersRight
         -- Magic buffer-picking mode
         -- map('n', '<C-p>', '<Cmd>BufferPick<CR>', keymap_options)
         -- -- Sort automatically by...
         -- map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', keymap_options)
         -- map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', keymap_options)
         -- map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', keymap_options)
         -- map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', keymap_options)
         -- map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', keymap_options)
      end,
      opts = {
         animation = true,
         auto_hide = false,
         clickable = true,
         insert_at_end = true,
         insert_at_start = false,
         tabpages = true,
         exclude_ft = { 'terminal' },
         exclude_name = { 'NvimTree', '__FLUTTER_DEV_LOG__' },
         icons = {
            button = "✗", -- alternative: ❌
            buffer_index = true,
            filetype = { enable = true },
            -- Enables / disables diagnostic symbols
            diagnostics = {
               [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
               [vim.diagnostic.severity.WARN] = { enabled = false },
               [vim.diagnostic.severity.INFO] = { enabled = false },
               [vim.diagnostic.severity.HINT] = { enabled = true },
            },
            visible = { modified = { buffer_number = false } },
            gitsigns = {
               added = { enabled = true, icon = " " },
               changed = { enabled = true, icon = " " },
               deleted = { enabled = true, icon = "⊟ " },
            },
         },
         sidebar_filetypes = {
            NvimTree = true,
            ['neo-tree'] = { event = 'BufWipeout' },
         },
      },
   },
}
