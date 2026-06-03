--[===[
Unit Test support

See :h neotest.run.run() for parameters

URLs:
https://github.com/nvim-neotest/neotest
https://github.com/orjangj/neotest-ctest
https://github.com/Shatur/neovim-tasks

Dependencies:
https://github.com/mfussenegger/nvim-dap
https://github.com/nvim-neotest/nvim-nio
https://github.com/nvim-lua/plenary.nvim
https://github.com/nvim-treesitter/nvim-treesitter
https://github.com/sidlatau/neotest-dart
https://github.com/nvim-neotest/neotest-python
https://github.com/nvim-neotest/neotest-plenary
https://github.com/antoinemadec/FixCursorHold.nvim -- The repo claims it is no longer needed but it is still recommended
https://github.com/Shatur/neovim-tasks
https://github.com/orjangj/neotest-ctest
--]===]

return {
   'nvim-neotest/neotest',
   enabled = true,
   keys = {
      { '<leader>tn', mode = 'n', desc = '[t]est: run [n]earest' },
      { '<leader>ts', mode = 'n', desc = '[t]est: [s]top running test' },
      { '<leader>ta', mode = 'n', desc = '[t]ests run [a]ll in file' },
      { '<leader>td', mode = 'n', desc = '[t]est: [d]ebug nearest test' },
      { '<leader>tf', mode = 'n', desc = '[t]est: run all [f]ailed' },
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
      { 'svenbergner/neotest-dmctest', dev = true },
   },
   config = function()
      require('tasks').setup({})

      -- Custom consumer: places a gutter sign for every discovered test position,
      -- so tests are visible even before they have been run.
      -- Also stores a reference to the client for the "run failed" keymap below.
      local neotest_client = nil
      local function test_signs_consumer(client)
         neotest_client = client
         local sign_name = 'NeotestDefined'
         local sign_group = 'neotest-defined'

         local function define_sign()
            vim.fn.sign_define(sign_name, { text = ' 󰙨', texthl = 'GruvboxGreen' })
         end

         local function render_file(adapter_id, file_path)
            define_sign()
            local bufnr = vim.fn.bufnr(file_path)
            if bufnr == -1 or not vim.api.nvim_buf_is_valid(bufnr) then
               return
            end
            pcall(vim.fn.sign_unplace, sign_group, { buffer = bufnr })
            local tree = client:get_position(file_path, { adapter = adapter_id })
            if not tree then
               return
            end
            for _, node in tree:iter_nodes() do
               local pos = node:data()
               if pos.range and pos.type == 'test' then
                  pcall(vim.fn.sign_place, 0, sign_group, sign_name, bufnr, { lnum = pos.range[1] + 1 })
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

      local ok_subprocess, subprocess = pcall(function()
         return require('neotest.lib').subprocess
      end)
      if ok_subprocess and not subprocess._aav_add_treesitter_root then
         local add_paths_to_rtp = subprocess.add_paths_to_rtp
         subprocess.add_paths_to_rtp = function(paths)
            local ts_init = vim.api.nvim_get_runtime_file('lua/nvim-treesitter/init.lua', false)[1]
               or vim.api.nvim_get_runtime_file('lua/nvim-treesitter.lua', false)[1]
            if ts_init then
               local ts_root = ts_init:match('(.+)/lua/nvim%-treesitter/init%.lua')
                  or ts_init:match('(.+)/lua/nvim%-treesitter%.lua')
               if ts_root and ts_root ~= '' then
                  local seen = false
                  for _, path in ipairs(paths) do
                     if path == ts_root then
                        seen = true
                        break
                     end
                  end
                  if not seen then
                     paths[#paths + 1] = ts_root
                  end
               end
            end
            return add_paths_to_rtp(paths)
         end
         subprocess._aav_add_treesitter_root = true
      end

      local function existing_ctest_dir(path)
         if path and vim.loop.fs_stat(path .. '/CTestTestfile.cmake') then
            return path
         end
         return nil
      end

      local function sse_ctest_root(root, position)
         if not root or not position or not position.path then
            return root
         end
         if vim.loop.os_uname().sysname ~= 'Darwin' then
            return root
         end
         local cc = root .. '/compile_commands.json'
         if not vim.loop.fs_stat(cc) then
            vim.notify('neotest-ctest: compile_commands.json nicht gefunden: ' .. cc, vim.log.levels.ERROR)
            return root
         end

         local real = vim.loop.fs_realpath(cc)
         if not real then
            vim.notify(
               'neotest-ctest: compile_commands.json konnte nicht aufgeloest werden: ' .. cc,
               vim.log.levels.ERROR
            )
            return root
         end

         local build_dir = vim.fn.fnamemodify(real, ':h')
         if not existing_ctest_dir(build_dir) then
            vim.notify(
               'neotest-ctest: Build-Ordner aus compile_commands.json ist kein CTest-Root: ' .. build_dir,
               vim.log.levels.ERROR
            )
            return root
         end

         return build_dir
      end

      local neotest = require('neotest')
      neotest.setup({
         running = {
            concurrent = false,
         },
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
               ctest_root = sse_ctest_root,
               is_test_file = function(file_path)
                  if file_path:match('/CatchMain%.cpp$') then
                     return false
                  end
                  if file_path:match('/%.!%d+!.*') then
                     return false
                  end
                  if file_path:find('/ExternalLibs/', 1, true) or file_path:find('/kdsoap/', 1, true) then
                     return false
                  end
                  if not (file_path:match('%.c$') or file_path:match('%.cpp$')) then
                     return false
                  end
                  if
                     not (file_path:match('/Test/') or file_path:match('Test%.cpp$') or file_path:match('Tests%.cpp$'))
                  then
                     return false
                  end

                  local file = io.open(file_path, 'r')
                  if not file then
                     return false
                  end
                  local content = file:read(8192) or ''
                  file:close()
                  return content:find('#include%s+[<"]catch2/') ~= nil
                     or content:find('#include%s+[<"]catch_amalgamated%.hpp') ~= nil
               end,
               hide_unavailable_tests = true,
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
            require('neotest-dmctest')({
               -- Defaults point at /Users/sven.bergner/Repos/Content/StP/31.
               -- Override these when using a different checkout or LZ.
               product_root = '/Users/sven.bergner/Repos/Content/StP/31',
               lz_root = '/Users/sven.bergner/Repos/Content/StP/31/lz',
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

      vim.keymap.set('n', '<leader>tA', function()
         require('neotest').run.run({ suite = true })
      end, { desc = '[t]ests run [A]ll in tree' })

      vim.keymap.set('n', '<leader>td', function()
         neotest.run.run({ strategy = 'dap' })
      end, { desc = '[t]est: [d]ebug nearest test' })

      vim.keymap.set('n', '<leader>tr', function()
         neotest.output.open({ enter = true, quiet = true, auto_close = true, last_run = true })
      end, { desc = 'Show [t]est [r]esults' })

      vim.keymap.set('n', '<leader>tt', function()
         neotest.summary.toggle()
      end, { desc = '[t]oggle [t]est summary' })

      vim.keymap.set('n', '<leader>tR', function()
         local ctest_adapter = require('neotest-ctest')
         if ctest_adapter.clear_cache then
            ctest_adapter.clear_cache()
         end

         if not neotest_client then
            vim.notify('neotest: no adapter active yet', vim.log.levels.WARN)
            return
         end

         local file_path = vim.fn.expand('%:p')
         require('nio').run(function()
            local adapter_id = neotest_client:get_adapter(file_path)
            if not adapter_id then
               vim.schedule(function()
                  vim.notify('neotest: no adapter for current file', vim.log.levels.WARN)
               end)
               return
            end

            local root = neotest.state.positions(adapter_id)
            local root_path = root and root:data().path or vim.loop.cwd()
            neotest_client:_update_positions(root_path, { adapter = adapter_id })
            vim.schedule(function()
               vim.notify('neotest: test tree refreshed', vim.log.levels.INFO)
            end)
         end)
      end, { desc = '[t]est: [R]efresh tree' })

      vim.keymap.set('n', '<leader>tf', function()
         if not neotest_client then
            vim.notify('neotest: no adapter active yet', vim.log.levels.WARN)
            return
         end
         local failed_ids = {}
         for _, adapter_id in ipairs(neotest.state.adapter_ids()) do
            local results = neotest_client:get_results(adapter_id)
            local positions = neotest.state.positions(adapter_id)
            if positions then
               for _, node in positions:iter_nodes() do
                  local pos = node:data()
                  if pos.type == 'test' then
                     local result = results[pos.id]
                     if result and (result.status == 'failed' or result.status == 'skipped') then
                        failed_ids[#failed_ids + 1] = pos.id
                     end
                  end
               end
            end
         end
         if #failed_ids == 0 then
            vim.notify('neotest: no failed tests', vim.log.levels.INFO)
            return
         end
         for _, pos_id in ipairs(failed_ids) do
            neotest.run.run(pos_id)
         end
      end, { desc = '[t]est: run all [f]ailed' })

      vim.keymap.set('n', '<leader>tjn', function()
         neotest.jump.next({ status = 'failed' })
      end, { desc = '[t]est [j]ump to [n]ext failed' })

      vim.keymap.set('n', '<leader>tjp', function()
         neotest.jump.prev({ status = 'failed' })
      end, { desc = '[t]est [j]ump to [p]revious failed' })
   end,
}
