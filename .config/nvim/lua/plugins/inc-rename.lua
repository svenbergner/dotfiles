--[===[
Incremental renaming plugin
URL: https://github.com/smjonas/inc-rename.nvim
--]===]

return {
   "smjonas/inc-rename.nvim",
   enabled = true,
   config = function()
      require("inc_rename").setup({})
   end,
}
