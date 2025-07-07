-- Detect aavdrm and interpret it as DOS Ini-file to have syntax highlighting

vim.api.nvim_create_autocmd(
   { 'BufEnter', 'BufRead', 'BufNewFile', 'VimEnter' },
   {
      pattern = '*.aavdrm',
      command = 'set filetype=dosini',
   }
)

