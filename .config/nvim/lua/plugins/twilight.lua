-- Twilight dims inactive portions of the code you're editing.

return {
   "folke/twilight.nvim",
   opts = {},
   config = function()
      require('twilight').setup()
   end
}
