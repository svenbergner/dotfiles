--[===[
Unit Test support

See :h neotest.run.run() for parameters

URLs:
https://github.com/nvim-neotest/neotest
https://github.com/orjangj/neotest-ctest
https://github.com/Shatur/neovim-tasks
--]===]

return {
   'nvim-neotest/neotest',
   enabled = true,
   keys = {
      { '<leader>TN', mode = 'n', desc = '[T]est: run [N]earest' },
      { '<leader>TS', mode = 'n', desc = '[T]est: [s]top running test' },
      { '<leader>TA', mode = 'n', desc = '[T]ests run [A]ll in file' },
      { '<leader>TD', mode = 'n', desc = '[T]est: [D]ebug nearest test' },
      { '<leader>TR', mode = 'n', desc = 'Show [T]est [R]esults' },
      { '<leader>TT', mode = 'n', desc = '[T]oggle [T]est summary' },
   },
   dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'sidlatau/neotest-dart',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-plenary',
      'antoinemadec/FixCursorHold.nvim',
      'Shatur/neovim-tasks',
      'orjangj/neotest-ctest',
   },
   config = function()
      require('tasks').setup({})

      -- Monkey-patch ctest:new() so it resolves the build directory from
      -- compile_commands.json when called with the SOURCE directory (which is
      -- what root() now returns for a clean neotest summary tree).
      local ok, ctest_mod = pcall(require, 'neotest-ctest.ctest')
      if ok then
         local nio = require('nio')
         local orig_new = ctest_mod.new
         ctest_mod.new = function(self, cwd)
            -- Fast path 1: cwd is already a build dir with CTestTestfile.cmake.
            if vim.loop.fs_stat(cwd .. '/CTestTestfile.cmake') then
               local session = {
                  _test_dir = cwd,
                  _output_junit_path = nio.fn.tempname(),
                  _output_log_path = nio.fn.tempname(),
               }
               setmetatable(session, self)
               self.__index = self
               return session
            end
            -- Fast path 2: cwd is a source dir with a compile_commands.json symlink
            -- that resolves to a build dir containing CTestTestfile.cmake.
            local cc = cwd .. '/compile_commands.json'
            if vim.loop.fs_stat(cc) then
               local real = vim.loop.fs_realpath(cc)
               if real then
                  local build_dir = vim.fn.fnamemodify(real, ':h')
                  if vim.loop.fs_stat(build_dir .. '/CTestTestfile.cmake') then
                     local session = {
                        _test_dir = build_dir,
                        _output_junit_path = nio.fn.tempname(),
                        _output_log_path = nio.fn.tempname(),
                     }
                     setmetatable(session, self)
                     self.__index = self
                     return session
                  end
               end
            end
            return orig_new(self, cwd)
         end
      end

      local neotest = require('neotest')
      neotest.setup({
         adapters = {
            require('neotest-dart')({
               command = 'fvm flutter',
               use_lsp = true,
               -- Useful when using custom test names with @isTest annotation
               custom_test_method_names = {},
            }),
            require('neotest-python')({
               runner = 'pytest',
               python = 'python',
               use_lsp = true,
            }),
            require('neotest-plenary')({}),
            require('neotest-ctest').setup({
               is_test_file = function(file_path)
                  return file_path:match('test_.*%.c$') ~= nil
                     or file_path:match('.*_test%.c$') ~= nil
                     or file_path:match('test_.*%.cpp$') ~= nil
                     or file_path:match('.*Test%.cpp$') ~= nil
               end,
               framework = { 'catch2' },
               -- compile_commands.json in the source root is a symlink to the
               -- build directory. root() gibt das SOURCE-Verzeichnis zurück damit
               -- die neotest-Summary die Quell-Struktur zeigt (nicht den Build-Dir).
               -- Der Monkey-Patch in ctest:new() löst daraus das Build-Dir auf.
               root = function(dir)
                  -- Walk up from 'dir' to find compile_commands.json
                  local path = vim.fn.isdirectory(dir) == 1 and dir or vim.fn.fnamemodify(dir, ':h')
                  local home = vim.loop.os_homedir()
                  while path and path ~= home and path ~= '/' do
                     local cc = path .. '/compile_commands.json'
                     if vim.loop.fs_stat(cc) then
                        return path -- Source-Dir zurückgeben, nicht das aufgelöste Build-Dir
                     end
                     local parent = vim.fn.fnamemodify(path, ':h')
                     if parent == path then
                        break
                     end
                     path = parent
                  end
                  return nil
               end,
            }),
         },
      })

      vim.keymap.set('n', '<leader>TN', function()
         vim.cmd('wa')
         neotest.run.run()
      end, { desc = '[T]est: run [N]earest' })

      vim.keymap.set('n', '<leader>TS', function()
         neotest.run.stop()
      end, { desc = '[T]est: [s]top running test' })

      vim.keymap.set('n', '<leader>TA', function()
         vim.cmd('wa')
         neotest.run.run(vim.fn.expand('%'))
      end, { desc = '[T]ests run [A]ll in file' })

      vim.keymap.set('n', '<leader>TD', function()
         neotest.run.run({ strategy = 'dap' })
      end, { desc = '[T]est: [D]ebug nearest test' })

      vim.keymap.set('n', '<leader>TR', function()
         neotest.output.open({ enter = true, quiet = true, auto_close = true, last_run = true })
      end, { desc = 'Show [T]est [R]esults' })

      vim.keymap.set('n', '<leader>TT', function()
         neotest.summary.toggle()
      end, { desc = '[T]oggle [T]est summary' })
   end,
}
