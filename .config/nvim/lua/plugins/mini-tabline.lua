--[===[
Minimal and fast tabline showing listed buffers

# Features

- Buffers are listed in the order of their identifier.
- Different highlight groups for "states" of buffer affecting 'buffer tabs'.
- Buffer names are made unique by extending paths to files or appending unique
identifier to buffers without name.
- Current buffer is displayed "optimally centered" (in center of screen while
maximizing the total number of buffers shown) when there are many buffers open.
- 'Buffer tabs' are clickable if Neovim allows it.
- Extra information section in case of multiple Neovim tabpages.
- Truncation symbols which show if there are tabs to the left and/or right.
Exact characters are taken from 'listchars' option (precedes and extends
fields) and are shown only if 'list' option is enabled.

URL: https://github.com/echasnovski/mini.tabline

--]===]

return {
   'echasnovski/mini.tabline',
   enabled = false,
   version = '*',
   config = function()
      require('mini.tabline').setup()
      local map = vim.api.nvim_set_keymap

      -- Close buffer
      map('n', '<M-c>', '<Cmd>bdelete<CR>', { noremap = true, silent = true, desc = "Close current buffer" })
      map('n', '<M-x>', '<Cmd>bdelete<CR>', { noremap = true, silent = true, desc = "Close current buffer" })

      -- Move to previous/next
      map('n', '<M-,>', '<Cmd>bprevious<CR>', { noremap = true, silent = true, desc = "Goto previous buffer" })
      map('n', '<M-.>', '<Cmd>bnext<CR>', { noremap = true, silent = true, desc = "Goto next buffer" })

      -- Goto buffer in position...
      map('n', '<M-1>', '<Cmd>bfirst<CR>', { noremap = true, silent = true, desc = "Goto buffer 1" })
      map('n', '<M-2>', '<Cmd>bfirst | bnext 1<CR>', { noremap = true, silent = true, desc = "Goto buffer 2" })
      map('n', '<M-3>', '<Cmd>bfirst | bnext 2<CR>', { noremap = true, silent = true, desc = "Goto buffer 3" })
      map('n', '<M-4>', '<Cmd>bfirst | bnext 3<CR>', { noremap = true, silent = true, desc = "Goto buffer 4" })
      map('n', '<M-5>', '<Cmd>bfirst | bnext 4<CR>', { noremap = true, silent = true, desc = "Goto buffer 5" })
      map('n', '<M-6>', '<Cmd>bfirst | bnext 5<CR>', { noremap = true, silent = true, desc = "Goto buffer 6" })
      map('n', '<M-7>', '<Cmd>bfirst | bnext 6<CR>', { noremap = true, silent = true, desc = "Goto buffer 7" })
      map('n', '<M-8>', '<Cmd>bfirst | bnext 7<CR>', { noremap = true, silent = true, desc = "Goto buffer 8" })
      map('n', '<M-9>', '<Cmd>bfirst | bnext 8<CR>', { noremap = true, silent = true, desc = "Goto buffer 9" })
      map('n', '<M-0>', '<Cmd>blast<CR>', { noremap = true, silent = true, desc = "Goto last buffer" })
   end,
}
