-- Autocommands for setting filetypes for files with specific extensions

vim.api.nvim_create_autocmd(
   {'BufRead','BufNewFile'},
   {
      pattern = {'*.htd', '*.htd.inc'},
      command = 'set filetype=html',
   }
)

