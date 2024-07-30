-- Tabs, as understood by any other editor.
-- barbar.nvim is a tabline plugin with re-orderable, auto-sizing, clickable tabs,
-- icons, nice highlighting, sort-by commands and a magic jump-to-buffer mode.
-- Plus the tab names are made unique when two filenames match.
-- In jump-to-buffer mode, tabs display a target letter instead of their icon.
-- Jump to any buffer by simply typing their target letter. Even better, the
-- target letter stays constant for the lifetime of the buffer, so if you're
-- working with a set of files you can even type the letter ahead from memory.

return {
   {
      'romgrk/barbar.nvim',
      dependencies = {
         'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
         'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function()
         vim.g.barbar_auto_setup = false
         local map = vim.api.nvim_set_keymap
         local opts = { noremap = true, silent = true }

         -- Move to previous/next
         map('n', '<M-,>', '<Cmd>BufferPrevious<CR>', opts)
         map('n', '<M-.>', '<Cmd>BufferNext<CR>', opts)
      -- Re-order to previous/next
      map('n', '<M-<>', '<Cmd>BufferMovePrevious<CR>', opts)
      map('n', '<M->>', '<Cmd>BufferMoveNext<CR>', opts)
      -- Goto buffer in position...
      map('n', '<M-1>', '<Cmd>BufferGoto 1<CR>', opts)
      map('n', '<M-2>', '<Cmd>BufferGoto 2<CR>', opts)
      map('n', '<M-3>', '<Cmd>BufferGoto 3<CR>', opts)
      map('n', '<M-4>', '<Cmd>BufferGoto 4<CR>', opts)
      map('n', '<M-5>', '<Cmd>BufferGoto 5<CR>', opts)
      map('n', '<M-6>', '<Cmd>BufferGoto 6<CR>', opts)
      map('n', '<M-7>', '<Cmd>BufferGoto 7<CR>', opts)
      map('n', '<M-8>', '<Cmd>BufferGoto 8<CR>', opts)
      map('n', '<M-9>', '<Cmd>BufferGoto 9<CR>', opts)
      map('n', '<M-0>', '<Cmd>BufferLast<CR>', opts)
      -- Pin/unpin buffer
      map('n', '<M-p>', '<Cmd>BufferPin<CR>', opts)
      -- Close buffer
      map('n', '<M-c>', '<Cmd>BufferClose<CR>', opts)
      -- Wipeout buffer
      --                 :BufferWipeout
      -- Close commands
      --                 :BufferCloseAllButCurrent
      --                 :BufferCloseAllButPinned
      --                 :BufferCloseAllButCurrentOrPinned
      --                 :BufferCloseBuffersLeft
      --                 :BufferCloseBuffersRight
      -- Magic buffer-picking mode
      -- map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
      -- -- Sort automatically by...
      -- map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
      -- map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
      -- map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
      -- map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
      -- map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
      end,
      opts = {
         animation = true,
         insert_at_start = false,
         auto_hide = false,
         tabpages = true,
         sidebar_filetypes = {
            NvimTree = true,
            ['neo-tree'] = { event = 'BufWipeout' },
         },
      },
      version = '^1.0.0', -- optional: only update when a new 1.x version is released
   },
}
