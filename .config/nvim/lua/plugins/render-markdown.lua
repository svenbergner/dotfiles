return {
   "MeanderingProgrammer/markdown.nvim",
   main = 'render-markdown',
   opts = {},
   name = 'render-markdown',
   dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-web-devicons',
   },
   config = function()
      require('render-markdown').setup({
         file_type = { 'markdown', 'vimwwiki', },
         vim.treesitter.language.register( 'markdown', 'vimwiki')
      })
   end
}
