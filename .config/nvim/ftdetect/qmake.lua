-- Detect qmake files

vim.api.nvim_create_autocmd(
   { 'BufEnter', 'BufRead', 'BufNewFile', 'VimEnter' },
   {
      pattern = { '*.pro', '*.pri' },
      command = 'set filetype=qmake',
   }
)

