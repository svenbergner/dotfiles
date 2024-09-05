-- Detect a terminal buffer and set it's filetype to terminal

vim.api.nvim_create_autocmd(
   {'TermOpen'},
   {
      once = true,
      command = 'set filetype=terminal',
   }
)

