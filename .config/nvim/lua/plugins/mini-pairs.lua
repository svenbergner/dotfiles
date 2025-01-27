--[===[ 
Minimal and fast autopairs
URL: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md 
--]===]

return {
   'echasnovski/mini.pairs',
   version = false,
   enabled = true,
   config = function()
      require('mini.pairs').setup()
   end,
}
