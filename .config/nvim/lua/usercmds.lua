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

-- Write quickfix list to a file
vim.api.nvim_create_user_command('WriteQuickfixToFile', function(opts)
   local filename = opts.args ~= '' and opts.args or 'quickfix.txt'
   local qflist = vim.fn.getqflist()

   if #qflist == 0 then
      vim.notify('Quickfix list is empty', vim.log.levels.WARN)
      return
   end

   local lines = {}
   for _, entry in ipairs(qflist) do
      local file = entry.bufnr ~= 0 and vim.fn.bufname(entry.bufnr) or entry.filename or ''
      local line = entry.lnum or 0
      local col = entry.col or 0
      local text = entry.text or ''
      table.insert(lines, string.format('%s:%d:%d: %s', file, line, col, text))
   end

   vim.fn.writefile(lines, filename)
   vim.notify(string.format('Quickfix list written to %s (%d entries)', filename, #lines), vim.log.levels.INFO)
end, {
   nargs = '?',
   complete = 'file',
   desc = 'Write quickfix list to a file (default: quickfix.txt)',
})
