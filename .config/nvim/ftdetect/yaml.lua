-- This file is part of the Neovim configuration for managing YAML files.
vim.api.nvim_create_autocmd(
   { 'BufEnter', 'BufRead', 'BufNewFile', 'VimEnter' },
   {
      pattern = { '*.yaml', '*.yml' },
      command = 'set filetype=yaml',
   }
)

