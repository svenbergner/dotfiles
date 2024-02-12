return {
   'folke/zen-mode.nvim',
   opts = {},
   config = function()
      require('zen-mode').setup({
         window = {
            height = 0.75
         }
      })
   end
}
