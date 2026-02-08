--[===[
Minimal and fast autopairs
URL: https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-pairs.md
--]===]

return {
   'nvim-mini/mini.pairs',
   version = false,
   enabled = true,
   config = function()
      require('mini.pairs').setup()
   end,
}
