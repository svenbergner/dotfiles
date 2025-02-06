--[===[
Decorations for vimdoc/help files in Neovim.
URL: https://github.com/OXY2DEV/helpview.nvim
--]===]

return {
   "OXY2DEV/helpview.nvim",
   lazy = true,
   enabled = true,

   ft = "help",

   dependencies = {
      "nvim-treesitter/nvim-treesitter"
   }
}
