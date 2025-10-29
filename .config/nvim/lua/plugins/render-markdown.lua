--[===[
Plugin to improve viewing Markdown files in Neovim
URL: https://github.com/MeanderingProgrammer/render-markdown.nvim
--]===]

return {
   "MeanderingProgrammer/render-markdown.nvim",
   enabled = true,
   dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-web-devicons',
   },
   config = function()
      require('render-markdown').setup({
         latex = { enabled = false, },
         file_types = { 'markdown', 'vimwwiki', },
         vim.treesitter.language.register('markdown', 'vimwiki')
      })
   end
}
