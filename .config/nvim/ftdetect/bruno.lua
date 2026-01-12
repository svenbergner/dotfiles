-- Detect bruno files

vim.api.nvim_create_autocmd(
   { 'BufEnter', 'BufRead', 'BufNewFile', 'VimEnter' },
   {
      pattern = { '*.bru' },
      command = 'set filetype=bruno',
   }
)


