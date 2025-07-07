-- This file is part of the Neovim configuration for managing shell scripts.
vim.api.nvim_create_autocmd(
   { 'BufEnter', 'BufRead', 'BufNewFile', 'VimEnter' },
   {
      pattern = { '.zsh*' },
      command = 'set filetype=zsh',
   }
)

