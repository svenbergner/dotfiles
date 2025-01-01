-- Remove divider comments
vim.api.nvim_create_user_command('RemoveDividerComments', function ()
   vim.api.nvim_command('silent! %s/^\\/\\/\\**\\n//')
   vim.api.nvim_command('write')
   vim.api.nvim_command('nohlsearch')
end, {nargs = 0})
