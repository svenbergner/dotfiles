--[===[
These are custom snippets created using LuaSnip

URL: https://github.com/L3MON4D3/LuaSnip

I have added a few snippets for markdown files, including code blocks and links.
I took the idea from this video:
URL: https://youtu.be/FmHhonPjvvA?si=8NrcRWu4GGdmTzee
--]===]

return {
   'L3MON4D3/LuaSnip',
   enabled = true,
   opts = function(_, opts)
      -- Load my personal snippets
      local snippets_path = vim.fn.stdpath('config') .. '/snippets'
      require('luasnip.loaders.from_vscode').lazy_load({ paths = { snippets_path } })

      opts = vim.tbl_deep_extend('force', opts, {
         history = true,
         delete_check_events = 'TextChanged',
      })

      vim.keymap.set('i', '<C-c>', function()
         require('luasnip.extras.select_choice')()
      end, { desc = 'select snippt choice' })
      vim.keymap.set('n', '<C-c>', function()
         require('luasnip.extras.select_choice')()
      end, { desc = 'select snippt choice' })
      return opts
   end,
}
