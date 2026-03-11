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
      { '<leader>TN', mode = 'n' },
      { '<leader>TS', mode = 'n' },
      { '<leader>TA', mode = 'n' },
      { '<leader>TD', mode = 'n' },
      { '<leader>TR', mode = 'n' },
      { '<leader>TT', mode = 'n' },
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
               -- build directory. Resolve it to find where CTestTestfile.cmake is.
               root = function(dir)
                  -- Walk up from 'dir' to find compile_commands.json
                  local path = vim.fn.isdirectory(dir) == 1 and dir or vim.fn.fnamemodify(dir, ':h')
                  local home = vim.loop.os_homedir()
                  while path and path ~= home and path ~= '/' do
                     local cc = path .. '/compile_commands.json'
                     if vim.loop.fs_stat(cc) then
                        local real = vim.loop.fs_realpath(cc)
                        if real then
                           local build_dir = vim.fn.fnamemodify(real, ':h')
                           if build_dir ~= path then
                              return build_dir
                           end
                        end
                        return path
                     end
                     local parent = vim.fn.fnamemodify(path, ':h')
                     if parent == path then break end
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
