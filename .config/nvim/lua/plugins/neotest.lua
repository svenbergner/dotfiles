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
      { '<leader>tn', mode = 'n', desc = '[t]est: run [n]earest' },
      { '<leader>ts', mode = 'n', desc = '[t]est: [s]top running test' },
      { '<leader>ta', mode = 'n', desc = '[t]ests run [a]ll in file' },
      { '<leader>td', mode = 'n', desc = '[t]est: [d]ebug nearest test' },
      { '<leader>tr', mode = 'n', desc = 'Show [t]est [r]esults' },
      { '<leader>tt', mode = 'n', desc = '[t]oggle [t]est summary' },
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
      { 'orjangj/neotest-ctest', dev = true },
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
            -- Fast path 2: cwd is a source dir with a compile_commands.json symlink.
            -- Resolve the build dir, then find the shallowest CTestTestfile.cmake
            -- (depth=2) so we pick the top-level test directory (e.g. SSE/) rather
            -- than a randomly ordered sub-module directory.
            local cc = cwd .. '/compile_commands.json'
            if vim.loop.fs_stat(cc) then
               local real = vim.loop.fs_realpath(cc)
               if real then
                  local build_dir = vim.fn.fnamemodify(real, ':h')
                  if vim.loop.fs_stat(build_dir) then
                     local lib = require('neotest.lib')
                     local scandir = require('plenary.scandir')
                     local roots = scandir.scan_dir(build_dir, {
                        respect_gitignore = false,
                        depth = 2,
                        search_pattern = 'CTestTestfile.cmake',
                        silent = true,
                     })
                     if roots and #roots > 0 then
                        -- Sort by path length so the shallowest entry comes first.
                        table.sort(roots, function(a, b)
                           return #a < #b
                        end)
                        local test_dir = lib.files.parent(roots[1])
                        local session = {
                           _test_dir = test_dir,
                           _output_junit_path = nio.fn.tempname(),
                           _output_log_path = nio.fn.tempname(),
                        }
                        setmetatable(session, self)
                        self.__index = self
                        return session
                     end
                     return orig_new(self, build_dir)
                  end
               end
            end
            return orig_new(self, cwd)
         end
      end

      -- Custom consumer: places a gutter sign for every discovered test position,
      -- so tests are visible even before they have been run.
      local function test_signs_consumer(client)
         local sign_name = 'NeotestDefined'
         local sign_group = 'neotest-defined'
         vim.fn.sign_define(sign_name, { text = ' 󰙨', texthl = 'GruvboxGreen' })

         local function render_file(adapter_id, file_path)
            local bufnr = vim.fn.bufnr(file_path)
            if bufnr == -1 or not vim.api.nvim_buf_is_valid(bufnr) then
               return
            end
            vim.fn.sign_unplace(sign_group, { buffer = bufnr })
            local tree = client:get_position(file_path, { adapter = adapter_id })
            if not tree then
               return
            end
            for _, node in tree:iter_nodes() do
               local pos = node:data()
               if pos.range and pos.type == 'test' then
                  vim.fn.sign_place(0, sign_group, sign_name, bufnr, { lnum = pos.range[1] + 1 })
               end
            end
         end

         client.listeners.discover_positions = function(adapter_id, tree)
            local data = tree:data()
            if data.type == 'file' then
               render_file(adapter_id, data.path)
            end
         end

         client.listeners.test_file_focused = function(adapter_id, file_path)
            render_file(adapter_id, file_path)
         end
      end

      local neotest = require('neotest')
      neotest.setup({
         floating = {
            border = 'rounded',
            max_height = 0.6,
            max_width = 0.6,
         },
         consumers = {
            test_signs = test_signs_consumer,
         },
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
               dap_adapter = 'lldb',
               dap_args = { stopOnEntry = false, exception_breakpoints = {} },
               is_test_file = function(file_path)
                  return file_path:match('test_.*%.c$') ~= nil
                     or file_path:match('.*_test%.c$') ~= nil
                     or file_path:match('test_.*%.cpp$') ~= nil
                     or file_path:match('.*Test%.cpp$') ~= nil
                     or file_path:match('.*Tests%.cpp$') ~= nil
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

      vim.keymap.set('n', '<leader>tn', function()
         neotest.run.run()
      end, { desc = '[t]est: run [n]earest' })

      vim.keymap.set('n', '<leader>ts', function()
         neotest.run.stop()
      end, { desc = '[t]est: [s]top running test' })

      vim.keymap.set('n', '<leader>ta', function()
         neotest.run.run(vim.fn.expand('%'))
      end, { desc = '[t]ests run [a]ll in file' })

      vim.keymap.set('n', '<leader>td', function()
         neotest.run.run({ strategy = 'dap' })
      end, { desc = '[t]est: [d]ebug nearest test' })

      vim.keymap.set('n', '<leader>tr', function()
         neotest.output.open({ enter = true, quiet = true, auto_close = true, last_run = true })
      end, { desc = 'Show [t]est [r]esults' })

      vim.keymap.set('n', '<leader>tt', function()
         neotest.summary.toggle()
      end, { desc = '[t]oggle [t]est summary' })

      vim.keymap.set('n', '<leader>tjn', function()
         neotest.jump.next({ status = 'failed' })
      end, { desc = '[t]est [j]ump to [n]ext failed' })

      vim.keymap.set('n', '<leader>tjp', function()
         neotest.jump.previous({ status = 'failed' })
      end, { desc = '[t]est [j]ump to [p]revious failed' })
   end,
}
