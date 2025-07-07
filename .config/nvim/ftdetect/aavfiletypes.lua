-- Autocommands for setting filetypes for files with specific extensions

vim.api.nvim_create_autocmd(
   { 'BufEnter', 'BufRead', 'BufNewFile', 'VimEnter' },
   {
      pattern = {'*.htd', '*.htd.inc'},
      command = 'set filetype=html',
   }
)

