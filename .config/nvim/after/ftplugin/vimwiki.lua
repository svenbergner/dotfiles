-- This file is part of the Neovim configuration for managing VimWiki files.
local group_id = vim.api.nvim_create_augroup("VimWikiSettings", { clear = true })

vim.api.nvim_create_autocmd(
   { "BufEnter", "BufNewFile", "BufRead", "VimEnter" },
   {
   group = group_id,
   pattern = "*.md",
   callback = function()
      vim.cmd('setlocal textwidth=120')
   end,
   desc = "Set some settings for vimwiki markdown files",
})

