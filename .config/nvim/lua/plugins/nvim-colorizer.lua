-- Color highlighter shows rgb and hex values as real color 
return {
   "NvChad/nvim-colorizer.lua",
   config = function()
      require("colorizer").setup({})
   end,
}
