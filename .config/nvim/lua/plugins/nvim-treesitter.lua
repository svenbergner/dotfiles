--[===[
Treesitter configuration
Uses Neovim's built-in treesitter APIs plus local parser/query management.
--]===]

return {
   dir = vim.fn.stdpath('config'),
   name = 'local-treesitter',
   lazy = false,
   config = function()
      require('treesitter').setup()
   end,
}
