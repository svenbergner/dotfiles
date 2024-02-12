-- Highlight current line only in active buffer
return {
   'miyakogi/conoline.vim',
   config = function()
      vim.g.conoline_auto_enable = 1
   end
}
