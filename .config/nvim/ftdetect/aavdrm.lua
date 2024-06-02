-- Detect aavdrm and interpret it as DOS Ini-file to have syntax highlighting

vim.api.nvim_create_autocmd(
   {'BufRead','BufNewFile'},
   {
      pattern = '*.aavdrm',
      command = 'set filetype=dosini',
   }
)

