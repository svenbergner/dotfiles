--[===[
Plugin to improve viewing Markdown files in Neovim
URL: https://github.com/MeanderingProgrammer/markdown.nvim
--]===]

return {
   "MeanderingProgrammer/markdown.nvim",
   enabled = true,
   main = 'render-markdown',
   opts = {},
   name = 'render-markdown',
   dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-web-devicons',
   },
   config = function()
      require('render-markdown').setup({
         file_types = { 'markdown', 'vimwwiki', },
         vim.treesitter.language.register('markdown', 'vimwiki')
      })
   end
}
