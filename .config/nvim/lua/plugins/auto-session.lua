--[===[
Automatically manage vim sessions
https://github.com/rmagatti/auto-session
--]===]

return {
   'rmagatti/auto-session',
   enabled = true,
   config = function()
      require('auto-session').setup({
         session_lens = {
            picker = 'snacks',
            buftypes_to_ignore = {},
            load_on_setup = true,
            theme_conf = { border = true },
         },
         suppress_dirs = { '~/', '~/Download', '/' },
      })
      vim.keymap.set('n', '<leader>sd', '<cmd>AutoSession delete<CR>', { desc = 'auto-[s]ession [d]elete' })
      vim.keymap.set('n', '<leader>sD', '<cmd>AutoSession <CR>', { desc = 'auto-[s]ession [D]isable' })
      vim.keymap.set('n', '<leader>se', '<cmd>AutoSession enable<CR>', { desc = 'auto-[s]ession [e]nable' })
      vim.keymap.set('n', '<leader>sp', '<cmd>AutoSession deletePicker<CR>', { desc = 'auto-[s]ession delete[p]icker' })
      vim.keymap.set('n', '<leader>sP', '<cmd>AutoSession purgeOrphaned<CR>', { desc = 'auto-[s]ession purge[o]rphaned' })
      vim.keymap.set('n', '<leader>sr', '<cmd>AutoSession restore<CR>', { desc = 'auto-[s]ession [r]estore' })
      vim.keymap.set('n', '<leader>sS', '<cmd>AutoSession search<CR>', { desc = 'auto-[s]ession [S]earch' })
      vim.keymap.set('n', '<leader>st', '<cmd>AutoSession toggle<CR>', { desc = 'auto-[s]ession [t]oggle' })
      vim.keymap.set('n', '<leader>ss', '<cmd>AutoSession save<CR>', { desc = 'auto-[s]ession [s]ave' })
   end,
}
