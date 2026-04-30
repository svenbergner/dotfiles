--[===[
LSP Diagnostics Key Mappings
--]===]
-- Key mappings for LSP
vim.keymap.set('n', '<F6>', function()
   vim.diagnostic.jump({ count = 1, float = true })
   vim.cmd('normal! zz')
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<S-F6>', function()
   vim.diagnostic.jump({ count = -1, float = true })
   vim.cmd('normal! zz')
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', '<F18>', function()
   vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { desc = 'LSP: Rename <F2>' })
vim.keymap.set('n', 'K', function()
   vim.lsp.buf.hover({ border = 'rounded' })
end, { desc = 'LSP: Hover Documentation' })
vim.keymap.set('n', '<C-S-k>', vim.lsp.buf.signature_help, { desc = 'LSP: Signature Documentation' })
vim.keymap.set('n', '<leader>Wa', vim.lsp.buf.add_workspace_folder, { desc = 'LSP: [W]orkspace [A]dd Folder' })
vim.keymap.set('n', '<leader>Wr', vim.lsp.buf.remove_workspace_folder, { desc = 'LSP: [W]orkspace [R]emove Folder' })
vim.keymap.set('n', '<leader>Wl', function()
   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = 'LSP: [W]orkspace [L]ist Folders' })

vim.api.nvim_buf_create_user_command(0, 'Format', function(_)
   vim.lsp.buf.format()
end, { desc = 'Format current buffer with LSP' })
vim.keymap.set('n', '<S-F7>', '<cmd>ConfigureCMakeBuild<CR>', { desc = 'Run cmake configure' })
vim.keymap.set('n', '<F19>', '<cmd>ConfigureCMakeBuild<CR>', { desc = 'Run cmake configure' })
vim.keymap.set('n', '<C-F7>', '<cmd>StopCMakeBuild<CR>', { desc = 'Stop cmake build' })
vim.keymap.set('n', '<F31>', '<cmd>StopCMakeBuild<CR>', { desc = 'Stop cmake build' })
vim.keymap.set('n', '<F43>', '<cmd>RunCMakeBuildWithTarget<CR>', { desc = 'Run cmake build with target' })
vim.keymap.set('n', '<C-S-F7>', '<cmd>RunCMakeBuildWithTarget<CR>', { desc = 'Run cmake build with target' })
vim.keymap.set('n', '<M-F7>', '<cmd>ShowLastBuildMessage<CR>', { desc = 'Show message from last build' })
vim.keymap.set('n', '<F55>', '<cmd>ShowLastBuildMessage<CR>', { desc = 'Show message from last build' })
vim.keymap.set('n', '<M-S-F7>', '<cmd>ShowLastBuildMessages<CR>', { desc = 'Show messages from last build' })
vim.keymap.set('n', '<F67>', '<cmd>ShowLastBuildMessages<CR>', { desc = 'Show messages from last build' })
vim.keymap.set('n', '<F7>', function()
   require('dap').terminate()
   vim.cmd({ cmd = 'StopCMakeBuild', args = { 'true' } })
   vim.cmd('RunCMakeBuild')
   -- Switch to normal mode only if currently in insert mode
   vim.schedule(function()
      local mode = vim.api.nvim_get_mode().mode
      if mode == 'i' or mode == 'ic' or mode == 'ix' then
         vim.cmd('stopinsert')
      end
   end)
end, { desc = 'LSP: Run cmake build' })

-- Switch between source and header files in C/C++
local sw = '<cmd>LspClangdSwitchSourceHeader<CR>'
vim.keymap.set('n', '<F4>', sw, { desc = 'LSP: F4 - switch source/header' })
vim.keymap.set('n', '<A-o>', sw, { desc = 'LSP: Alt + o - switch source/header' })
vim.keymap.set('n', '<M-o>', sw, { desc = 'LSP: Meta + o - switch source/header' })
vim.keymap.set('i', '<A-o>', sw, { desc = 'LSP: Alt + o - switch source/header' })
vim.keymap.set('i', '<M-o>', sw, { desc = 'LSP: Meta + o - switch source/header' })

vim.keymap.set('n', '<leader>bf', vim.lsp.buf.format, { desc = 'Format the current buffer' })

-- Coding Keymaps
vim.keymap.set('n', '<leader>cf', function()
   vim.lsp.buf.format({ async = true })
end, { desc = '[c]ode [f]ormat', noremap = true, silent = true })

vim.keymap.set('n', 'gra', function()
   vim.lsp.buf.code_action()
end, { desc = '[g]lobal [r]un [c]code action', noremap = true, silent = true })

vim.keymap.set('n', 'grn', function()
   vim.lsp.buf.rename()
end, { desc = '[g]lobal [r]e[n]ame', noremap = true, silent = true })

vim.keymap.set('n', '<leader>cd', function()
   vim.lsp.buf.definition()
end, { desc = '[c]ode [d]efinition', noremap = true, silent = true })

vim.keymap.set('n', '<leader>cD', function()
   vim.lsp.buf.declaration()
end, { desc = '[c]ode [D]eclaration', noremap = true, silent = true })

vim.keymap.set('n', '<leader>ct', function()
   vim.lsp.buf.type_definition()
end, { desc = '[c]ode [t]ype definition', noremap = true, silent = true })

vim.keymap.set('n', '<leader>ci', function()
   vim.lsp.buf.implementation()
end, { desc = '[c]ode [i]mplementation', noremap = true, silent = true })

vim.keymap.set('n', '<leader>cR', function()
   vim.lsp.buf.references()
end, { desc = '[c]ode [R]eferences', noremap = true, silent = true })

vim.keymap.set('n', '<leader>cs', function()
   vim.lsp.buf.signature_help()
end, { desc = '[c]ode [s]ignature help', noremap = true, silent = true })

vim.keymap.set('n', '<leader>cS', function()
   vim.lsp.buf.workspace_symbol()
end, { desc = '[c]ode [S]ymbols in workspace', noremap = true, silent = true })

vim.keymap.set('n', '<leader>ch', function()
   vim.lsp.buf.hover()
end, { desc = '[c]ode [h]over', noremap = true, silent = true })

vim.keymap.set('n', '<leader>cH', function()
   vim.lsp.buf.hover({ focusable = true })
end, { desc = '[c]ode [H]over with focus', noremap = true, silent = true })

vim.keymap.set('n', '<leader>ce', function()
   vim.lsp.buf.show_line_diagnostics({ border = 'rounded' })
end, { desc = '[c]ode [e]rror diagnostics', noremap = true, silent = true })

vim.keymap.set('n', '<leader>cW', function()
   vim.lsp.buf.workspace_symbol()
end, { desc = '[c]ode [W]orkspace symbols', noremap = true, silent = true })

vim.keymap.set('n', '<leader>cL', function()
   vim.lsp.buf.incoming_calls()
end, { desc = '[c]ode [L]ist incoming calls', noremap = true, silent = true })

vim.keymap.set('n', '<leader>cO', function()
   vim.lsp.buf.outgoing_calls()
end, { desc = '[c]ode [O]utgoing calls', noremap = true, silent = true })

