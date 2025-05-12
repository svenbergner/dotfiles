--[===[
Debugger configuration
URL: https://github.com/mfussenegger/nvim-dap

NVIM-Dap-UI:
URL: https://github.com/rcarriga/nvim-dap-ui

Default keybindings:
- edit: e
- expand: <CR> or left click
- open: o
- remove: d
- repl: r
- toggle: t

Dependencies:
one-small-step-for-vimkind a.k.a. osv is an adapter for the Neovim lua language.
It allows you to debug any lua code running in a Neovim instance.
URL: https://github.com/jbyuki/one-small-step-for-vimkind
--]===]

---@diagnostic disable: undefined-field
return {
   {
      "mfussenegger/nvim-dap",
      event = 'VeryLazy',
      dependencies = {
         "nvim-neotest/nvim-nio",
         "rcarriga/nvim-dap-ui",
         "williamboman/mason.nvim",
         'jbyuki/one-small-step-for-vimkind',
         "theHamsta/nvim-dap-virtual-text",
         "svenbergner/telescope-debugee-selector",
         "folke/lazydev.nvim",
      },
      config = function()
         require("lazydev").setup({ library = { "nvim-dap-ui" }, })
         local dap = require("dap")
         local dapui = require("dapui")

         require('nvim-dap-virtual-text').setup({
            enabled = true,                     -- enables this plugin
            enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
            highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
            highlight_new_as_changed = true,    -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
            show_stop_reason = true,            -- show stop reason when stopped for exceptions
            commented = false,                  -- prefix virtual text with comment string
            only_first_definition = false,      -- only show virtual text at first definition (if there are multiple)
            all_references = true,              -- show virtual text on all all references of the variable (not only definitions)
            clear_on_continue = false,          -- clear virtual text on "continue" (might cause flickering when stepping)
            -- A callback that determines how a variable is displayed or whether it should be omitted
            -- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
            -- @param buf number
            -- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
            -- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
            -- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
            -- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
            display_callback = function(variable, _, _, _, _)
               return '<' .. variable.name .. ' = ' .. variable.value:gsub("%s+", " ") .. '>'
            end,
            virt_text_win_col = 120,
            virt_text_pos = "inline",
         })

         dap.adapters.lldb = {
            name = "lldb",
            type = "executable",
            command = vim.fn.expand("~/.local/share/nvim/mason/bin/codelldb"),
         }

         dap.configurations.cpp = {
            {
               name = "Launch",
               type = "lldb",
               request = "launch",
               program = function()
                  vim.cmd('SetDebuggee')
               end,
               cwd = "${workspaceFolder}",
               stopOnEntry = false,
               -- env = {
               --    LZ_ROOT="/Users/sven.bergner/Downloads/package/lz/",
               --    DYLD_PRINT_LIBRARIES="YES", -- Print loaded libraries
               -- },
               args = { "" },
               -- args = { "-update" },
               -- args = { "-c", "-mnormal" },
               -- args = { "-mnormal" }, -- Start with normal mode
               -- args = { "-nih" }, -- BelegManager: no instance handling
               -- args = { "Im Modus normal liefert der Bereich Weitere Angaben (/.tdlSteuererklaerung) einen Themenfilter-Content." },
               -- args = { "Versenden der Einkommensteuer per ELSTER" },
               -- args = { "Die Dateien in einem Ordner koennen per wildcard ermittelt werden." },
               initCommands = function()
                  local commands = {}
                  table.insert(commands, "breakpoint name configure --disable cpp_exception")
                  if vim.fn.has("mac") == 1 then
                     table.insert(commands,
                        "settings set target.source-map /Users/qt/work/qt/ /Users/sven.bergner/Qt/6.7.3/Src/")
                     table.insert(commands,
                        'script -l python -- import sys; sys.path += [ "' ..
                        vim.fn.expand("$HOME") .. '/Library/Python/3.9/lib/python/site-packages" ]')
                  end
                  table.insert(commands, "settings set target.load-script-from-symbol-file true")
                  return commands
               end,
            },
            -- {
            --    type = "lldb",
            --    request = "attach",
            --    name = "Attach to process",
            --    pid = require("dap.utils").pick_process,
            --    cwd = "${workspaceFolder}",
            -- },
         }

         -- dap.adapters.dart = {
         --    type = "executable",
         --    command = "dart",
         --    args = { "debug_adapter" }
         -- }
         --
         -- dap.configurations.dart = {
         --    {
         --       type = "dart",
         --       request = "launch",
         --       name = "Launch Dart Program",
         --       program = "${file}",
         --       cwd = "${workspaceFolder}",
         --       args = { "--dart-define-from-file=emv-vars.json" },      -- Note for Dart Apps this is args, for Flutter apps toolArgs
         --       toolsArgs = { "--dart-define-from-file=emv-vars.json" }, -- Note for Dart Apps this is args, for Flutter apps toolArgs
         --    }
         -- }

         dap.configurations.lua = {
            {
               type = 'nlua',
               request = 'attach',
               name = "Attach to running Neovim instance",
            }
         }

         dap.adapters.nlua = function(callback, config)
            callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
         end

         dap.adapters.bashdb = {
            type = 'executable',
            command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
            name = 'bashdb',
         }

         dap.configurations.sh = {
            {
               type = 'bashdb',
               request = 'launch',
               name = "Launch file",
               showDebugOutput = true,
               pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
               pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
               trace = true,
               file = "${file}",
               program = "${file}",
               cwd = '${workspaceFolder}',
               pathCat = "cat",
               pathBash = "/usr/local/bin/bash",
               pathMkfifo = "mkfifo",
               pathPkill = "pkill",
               args = {},
               env = {},
               terminalKind = "integrated",
            }
         }

         vim.api.nvim_create_user_command("SetDebuggee", function()
            require('telescope').extensions.debugee_selector.selectSearchPathRoot()
         end, { nargs = 0 })

         vim.api.nvim_create_user_command("ResetDebuggee", function()
            require('telescope').extensions.debugee_selector.reset_search_path()
            require('telescope').extensions.debugee_selector.show_debugee_candidates()
         end, { nargs = 0 })

         vim.api.nvim_create_user_command("ConfigureCMakeBuild", function()
            require('telescope').extensions.cmake_preset_selector.show_cmake_configure_presets()
         end, { nargs = 0 })

         vim.api.nvim_create_user_command("ShowSelectedConfigurePreset", function()
            vim.print("Current CMake Configure Preset: ",
               require('telescope').extensions.cmake_preset_selector.get_configure_preset())
         end, { nargs = 0 })

         vim.api.nvim_create_user_command("RunCMakeBuild", function()
            require('telescope').extensions.cmake_preset_selector.show_cmake_build_presets()
         end, { nargs = 0 })

         vim.api.nvim_create_user_command("ShowSelectedBuildPreset", function()
            vim.print("Current CMake Build Preset: ",
               require('telescope').extensions.cmake_preset_selector.get_build_preset())
         end, { nargs = 0 })

         vim.api.nvim_create_user_command("ShowDebuggee", function()
            vim.print("Current debuggee: ", dap.configurations.cpp[1].program)
         end, { nargs = 0 })

         vim.api.nvim_create_user_command("DapLoadLldbForCpp", function()
            ---@diagnostic disable-next-line: deprecated
            require("dap.ext.vscode").load_launchjs(vim.fn.getcwd() .. "/.vscode/launch.json", { lldb = { "cpp" } })
         end, { nargs = 0 })

         -- dap.adapters.python = {
         --     type = "executable",
         --     command = vim.fn.expand("~/") .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
         --     args = { "-m", "debugpy.adapter" },
         -- }

         vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            desc = "Prevent colorscheme clearing self-defined DAP marker colors",
            callback = function()
               -- Reuse current SignColumn background (except for DapStoppedLine)
               local sign_column_hl = vim.api.nvim_get_hl(0, { name = 'SignColumn' })
               -- if bg or ctermbg aren't found, use bg = 'bg' (which means current Normal) and ctermbg = 'Black'
               -- convert to 6 digit hex value starting with #
               local sign_column_bg = (sign_column_hl.bg ~= nil) and ('#%06x'):format(sign_column_hl.bg) or 'bg'
               local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or 'Black'

               vim.api.nvim_set_hl(0, 'DapStopped',
                  { fg = '#98c379', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
               vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e4d3d', ctermbg = 'Green' })
               vim.api.nvim_set_hl(0, 'DapBreakpoint',
                  { fg = '#993939', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
               vim.api.nvim_set_hl(0, 'DapBreakpointRejected',
                  { fg = '#888ca6', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
               vim.api.nvim_set_hl(0, 'DapLogPoint',
                  { fg = '#61afef', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
            end
         })

         -- reload current color scheme to pick up colors override if it was set up in a lazy plugin definition fashion
         vim.cmd.colorscheme(vim.g.colors_name)

         vim.fn.sign_define("DapBreakpoint", { text = "🛑", numhl = "DapBreakpoint" })
         vim.fn.sign_define("DapStopped",
            { text = "→", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

         -- vscode-style debugging
         vim.keymap.set("n", "<M-F5>", function() vim.cmd('SetDebuggee') end, { desc = 'Set Debugee' })
         vim.keymap.set("n", "<F53>", function() vim.cmd('SetDebuggee') end, { desc = 'Set Debugee' })
         vim.keymap.set("n", "<F5>", function()
            vim.cmd("Neotree close")
            dap.continue()
         end, { desc = 'Start/Continue Debugging' })
         vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = 'Stop Debugging' })
         vim.keymap.set("n", "<F17>", dap.terminate, { desc = 'Stop Debugging' })
         vim.keymap.set("n", "<C-S-F5>", dap.run_last, { desc = 'Restart Debugging' })
         vim.keymap.set("n", "<C-F17>", dap.run_last, { desc = 'Restart Debugging' })
         vim.keymap.set("n", "<F10>", dap.step_over, { desc = 'Step over' })
         vim.keymap.set("n", "<F11>", dap.step_into, { desc = 'Step into' })
         vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = 'Step out' })
         vim.keymap.set("n", "<F23>", dap.step_out, { desc = 'Step out' })
         vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
         vim.keymap.set("n", "<leader>dq", dapui.close, { desc = '[d]apui [q]uit' })
         vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = '[d]apui [t]oggle ' })
         vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = 'Toggle [d]abui [b]reakpoint' })
         vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = 'Run to [d]abui [c]ursor' })
         vim.keymap.set("n", "<leader>dcb", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
            { desc = 'Set [d]apui [c]onditional [b]reakpoint' })
         vim.keymap.set('n', '<Leader>dtp',
            function() dap.set_breakpoint(nil, nil, vim.fn.input('Trace point message: ')) end,
            { desc = 'Set [d]apui [t]race [p]oint' })
         vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() require('dap.ui.widgets').hover() end,
            { desc = '[d]apui [h]over information' })

         vim.keymap.set('n', '<leader>dl', function() require "osv".launch({ port = 8086 }) end,
            { desc = '[l]aunch server in [d]ebuggee', noremap = true })

         vim.keymap.set('n', '<leader>df',
            function()
               local widgets = require("dap.ui.widgets")
               widgets.centered_float(widgets.frames)
            end, { desc = '[d]apui floating [f]rames' })

         dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
               icons = {
                  pause = "⏸",
                  play = "▶",
                  step_into = "",
                  step_over = "",
                  step_out = "",
                  step_back = "",
                  run_last = "",
                  terminate = "⏹",
               },
            },
         })

         dap.listeners.before.attach["dapui_config"] = dapui.open
         dap.listeners.before.launch["dapui_config"] = dapui.open
         dap.listeners.after.event_initialized["dapui_config"] = dapui.open
         -- dap.listeners.before.event_terminated["dapui_config"] = dapui.close
         -- dap.listeners.before.event_exited["dapui_config"] = dapui.close
      end,
   }
}
