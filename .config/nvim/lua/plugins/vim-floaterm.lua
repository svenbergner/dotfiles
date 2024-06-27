-- A terminal in a floating window
return {
   'voldikss/vim-floaterm',
   event = 'VeryLazy',
   config = function()
      vim.keymap.set('n', '<leader>tf', ':FloatermNew<CR>', { silent = true, desc = 'New [t]erm [f]loating' })
      vim.keymap.set('t', '<leader>tf', '<C-\\><C-n>:FloatermNew<CR>', { silent = true, desc = 'New [t]erm [f]loating' })
      vim.keymap.set('n', '<leader>tp', ':FloatermPrev<CR>', { silent = true, desc = 'Goto [t]erm [p]revious' })
      vim.keymap.set('t', '<leader>tp', '<C-\\><C-n>:FloatermPrev<CR>', { silent = true, desc = 'Goto [t]erm [p]revious' })
      vim.keymap.set('n', '<leader>tn', ':FloatermNext<CR>', { silent = true, desc = 'Goto [t]erm [n]ext' })
      vim.keymap.set('t', '<leader>tn', '<C-\\><C-n>:FloatermNext<CR>', { silent = true, desc = 'Goto [t]erm [n]ext' })
      vim.keymap.set('n', '<leader>tt', ':FloatermToggle<CR>', { silent = true, desc = '[T]oggle Float[T]erm' })
      vim.keymap.set('t', '<leader>tt', '<C-\\><C-n>:FloatermToggle<CR>', { silent = true, desc = '[T]oggle Float[T]erm' })
      vim.keymap.set('n', '<leader>tk', ':FloatermKill<CR>', { silent = true, desc = 'Float[T]erm [K]ill' })
      vim.keymap.set('t', '<leader>tk', '<C-\\><C-n>:FloatermKill<CR>', { silent = true, desc = 'Float[T]erm [K]ill' })
      vim.keymap.set('n', '<leader>tl', ':Telescope floaterm<CR>', { silent = true, desc = '' })
      -- vim.keymap.set('x', '<leader>ts', ':FloatermSend<CR>', { silent = true, desc = '' })
   end
}
