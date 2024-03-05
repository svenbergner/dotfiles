-- Detect aavdrm and interpret it as dosini file

vim.api.nvim_create_autocmd(
   {'BufRead','BufNewFile'},
   {
      pattern = '*.aavdrm',
      command = 'set filetype=dosini',
   }
)

