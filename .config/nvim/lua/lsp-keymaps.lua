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
   local contentdev = require('contentdev')
   if contentdev.is_contentdev_buffer(0) then
      pcall(function() vim.cmd({ cmd = 'StopCMakeBuild', args = { 'true' } }) end)
      contentdev.build_current_buffer()
   else
      vim.cmd({ cmd = 'StopCMakeBuild', args = { 'true' } })
      vim.cmd('RunCMakeBuild')
   end
   -- Switch to normal mode only if currently in insert mode
   vim.schedule(function()
      local mode = vim.api.nvim_get_mode().mode
      if mode == 'i' or mode == 'ic' or mode == 'ix' then
         vim.cmd('stopinsert')
      end
   end)
end, { desc = 'LSP: Run build' })

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

-- Compile only the current buffer's file using the entry in compile_commands.json
local function compile_current_file()
   local file_path = vim.fn.expand('%:p')
   if file_path == '' then
      vim.notify('CompileCurrentFile: no active file buffer', vim.log.levels.WARN)
      return
   end

   -- Walk up from the file's directory to find compile_commands.json
   local dir = vim.fn.fnamemodify(file_path, ':h')
   local home = vim.loop.os_homedir()
   local cc_path = nil
   while dir and dir ~= home and dir ~= '/' do
      local candidate = dir .. '/compile_commands.json'
      if vim.loop.fs_stat(candidate) then
         cc_path = candidate
         break
      end
      local parent = vim.fn.fnamemodify(dir, ':h')
      if parent == dir then
         break
      end
      dir = parent
   end

   if not cc_path then
      vim.notify('CompileCurrentFile: compile_commands.json not found', vim.log.levels.WARN)
      return
   end

   -- Read and parse compile_commands.json
   local f = io.open(cc_path, 'r')
   if not f then
      vim.notify('CompileCurrentFile: cannot read compile_commands.json', vim.log.levels.ERROR)
      return
   end
   local content = f:read('*all')
   f:close()

   local ok, db = pcall(vim.fn.json_decode, content)
   if not ok or not db then
      vim.notify('CompileCurrentFile: failed to parse compile_commands.json', vim.log.levels.ERROR)
      return
   end

   -- Find the entry for the current file (resolve symlinks for a reliable match)
   local real_file = vim.loop.fs_realpath(file_path) or file_path
   local entry = nil
   for _, e in ipairs(db) do
      local real_e = vim.loop.fs_realpath(e.file) or e.file
      if real_e == real_file then
         entry = e
         break
      end
   end

   if not entry then
      vim.notify(
         'CompileCurrentFile: no compile command found for ' .. vim.fn.fnamemodify(file_path, ':t'),
         vim.log.levels.WARN
      )
      return
   end

   -- Build the shell command; prefer the 'command' string, fall back to 'arguments' array
   local compile_cmd
   if entry.command then
      compile_cmd = entry.command
   elseif entry.arguments then
      local parts = {}
      for _, a in ipairs(entry.arguments) do
         parts[#parts + 1] = vim.fn.shellescape(a)
      end
      compile_cmd = table.concat(parts, ' ')
   else
      vim.notify('CompileCurrentFile: compile_commands.json entry has no command', vim.log.levels.ERROR)
      return
   end

   -- Prefix with the compile directory so relative paths in the command resolve correctly
   if entry.directory then
      compile_cmd = 'cd ' .. vim.fn.shellescape(entry.directory) .. ' && ' .. compile_cmd
   end

   local ok2, cmake_runner = pcall(require, 'cmake_runner')
   if not ok2 then
      vim.notify('CompileCurrentFile: cmake_runner not available', vim.log.levels.ERROR)
      return
   end

   cmake_runner.run_cmake_build({
      cmd = compile_cmd,
      label = vim.fn.fnamemodify(file_path, ':t'),
      preset = 'single-file',
   })
end

vim.api.nvim_create_user_command('CompileCurrentFile', compile_current_file, {
   desc = 'Compile the current buffer file via compile_commands.json',
})
vim.keymap.set('n', '<leader>CC', compile_current_file, {
   desc = '[C]ompile [C]urrent file',
   noremap = true,
   silent = true,
})
