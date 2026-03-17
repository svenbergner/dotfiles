-- Remove divider comments
vim.api.nvim_create_user_command('RemoveDividerComments', function()
   vim.api.nvim_command('silent! %s/^\\/\\/\\**\\n//')
   vim.api.nvim_command('write')
   vim.api.nvim_command('nohlsearch')
end, { nargs = 0 })

-- Change include guards to #pragma once
vim.api.nvim_create_user_command('ChangeIncludeGuardToPragmaOnce', function()
   vim.api.nvim_command('silent! %s/^#ifndef\\s\\+\\w\\+\\s*\\n#define\\s\\+\\w\\+\\s*\\n/#pragma once\\r/')
   vim.api.nvim_command('silent! %s/\\n\\(\\s*\\n\\)*#endif[^\\n]*\\n\\?\\%$//')
   vim.api.nvim_command('silent! %s/^#pragma once\\n\\(\\s*\\n\\)*\\(#include\\)/#pragma once\\r\\r\\2/')
   vim.api.nvim_command('write')
   vim.api.nvim_command('nohlsearch')
end, { nargs = 0 })


