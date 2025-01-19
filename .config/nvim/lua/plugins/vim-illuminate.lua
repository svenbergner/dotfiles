--[===[
Neovim plugin for automatically highlighting other uses of the word
 under the cursor using either LSP, Tree-sitter, or regex matching.
URL: https://www.github.com/RRethy/vim-illuminate
--]===]

return {
   "RRethy/vim-illuminate",
   enabled = false,
   config = function()
      require("illuminate").configure({
         providers = {
            "lsp",
            "treesitter",
            "regex",
         },
         under_cursor = true,
         delay = 0,
      })
   end,
}
