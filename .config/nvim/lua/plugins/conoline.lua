-- Highlight current line only in active buffer
return {
   'miyakogi/conoline.vim',
   event = 'VeryLazy',
   config = function()
      vim.g.conoline_auto_enable = 1
      vim.g.conoline_use_colorscheme_default_normal = 1
      vim.g.conoline_use_colorscheme_default_insert = 1
   end
}
