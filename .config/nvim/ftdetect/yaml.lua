-- Based on this medium article
-- https://itnext.io/better-kubernetes-yaml-editing-with-neo-vim-af7da9a1b150
vim.api.nvim_create_autocmd(
   {'BufRead','BufNewFile'},
   {
      pattern = '*.yaml',
      command = 'set filetype=yaml',
   }
)

vim.api.nvim_create_autocmd(
   {'BufRead','BufNewFile'},
   {
      pattern = '*.yml',
      command = 'set filetype=yaml',
   }
)

