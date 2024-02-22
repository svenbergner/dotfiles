-- neoclip is a clipboard manager for Neovim inspired by for example clipmenu.
-- It records everything that gets yanked in your vim session (up to a limit 
-- which is by default 1000 entries but can be configured). You can then select 
-- an entry in the history using telescope or fzf-lua which then gets populated 
-- in a register of your choice.

return {
   "AckslD/nvim-neoclip.lua",
   dependencies = {
      'nvim-telescope/telescope.nvim',
   },
   config = function()
      require('neoclip').setup()
   end,
}
