-- Detect qmake files

vim.api.nvim_create_autocmd(
   {'BufRead','BufNewFile'},
   {
      pattern = '*.pro',
      command = 'set filetype=qmake',
   }
)

vim.api.nvim_create_autocmd(
   {'BufRead','BufNewFile'},
   {
      pattern = '*.pri',
      command = 'set filetype=qmake',
   }
)

