-- Remove divider comments
vim.api.nvim_create_user_command('RemoveDividerComments', function ()
   vim.api.nvim_command('silent! %s/^\\/\\/\\**\\n//')
end, {nargs = 0})
