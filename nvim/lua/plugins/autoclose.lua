-- Automatically add the closing element
return {
   "m4xshen/autoclose.nvim",
   config = function()
      require("autoclose").setup()
   end,
}
