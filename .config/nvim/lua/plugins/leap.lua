-- Leap is a general-purpose motion plugin for Neovim, building and improving 
-- primarily on vim-sneak, with the ultimate goal of establishing a new standard 
-- interface for moving around in the visible area in Vim-like modal editors. 
-- It allows you to reach any target in a very fast, uniform way, and minimizes 
-- the required focus level while executing a jump.

return {
   "ggandor/leap.nvim",
   event = 'VeryLazy',
   config = function()
      require('leap').add_default_mappings()
      vim.api.nvim_create_autocmd('ColorScheme', {
         callback = function()
            require('leap').init_highlight(true)
         end,
         pattern = '*',
      })
   end
}
