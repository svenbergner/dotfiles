-- Debugger configuration
return {
   "mfussenegger/nvim-dap",
   event = 'VeryLazy',
   dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "williamboman/mason.nvim",
      "leoluz/nvim-dap-go",
      "svenbergner/telescope-debugee-selector",
   },
   config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.adapters.bashdb = {
         type = 'executable',
         command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
         name = 'bashdb',
      }

      dap.adapters.lldb = {
         name = "lldb",
         type = "server",
         port = "${port}",
         executable = {
            command = '/Users/sven.bergner/.local/share/nvim/mason/bin/codelldb', --vim.fn.exepath("codelldb"),
            args = { "--port", "${port}" },
         },
      }

      dap.configurations.cpp = {
         {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
               return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
            initCommands = function()
               local commands = {}
               table.insert(commands, "breakpoint name configure --disable cpp_exception")
               return commands
            end,
         },
      }

      dap.adapters.dart = {
         type = "executable",
         command = "dart",
         args = { "debug_adapter" }
      }

      dap.configurations.dart = {
         {
            type = "dart",
            request = "launch",
            name = "Launch Dart Program",
            program = "${file}",
            cwd = "${workspaceFolder}",
            args = { "--dart-define-from-file=emv-vars.json" },      -- Note for Dart Apps this is args, for Flutter apps toolArgs
            toolsArgs = { "--dart-define-from-file=emv-vars.json" }, -- Note for Dart Apps this is args, for Flutter apps toolArgs
         }
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

      vim.api.nvim_create_user_command("SelectDebuggeeSearchPath", function()
         require('telescope').extensions.debugee_selector.selectSearchPathRoot()
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("SetDebuggee", function()
         require('telescope').extensions.debugee_selector.show_debugee_candidates()
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("ConfigureCMakeBuild", function()
         require('telescope').extensions.cmake_preset_selector.show_cmake_configure_presets()
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("ShowSelectedConfigurePreset", function()
         vim.print("Current CMake Configure Preset: ", require('telescope').extensions.cmake_preset_selector.get_configure_preset())
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("RunCMakeBuild", function()
         require('telescope').extensions.cmake_preset_selector.show_cmake_build_presets()
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("ShowSelectedBuildPreset", function()
         vim.print("Current CMake Build Preset: ", require('telescope').extensions.cmake_preset_selector.get_build_preset())
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("ResetDebuggee", function()
         dap.configurations.cpp = {
            {
               name = "Launch",
               type = "lldb",
               request = "launch",
               program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
               end,
               cwd = "${workspaceFolder}",
               stopOnEntry = false,
               args = {},
            },
         }
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("ShowDebuggee", function()
         vim.print("Current debuggee: ", dap.configurations.cpp[1].program)
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("DapLoadLldbForCpp", function()
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

            vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
            vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e4d3d', ctermbg = 'Green' })
            vim.api.nvim_set_hl(0, 'DapBreakpoint',
               { fg = '#993939', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
            vim.api.nvim_set_hl(0, 'DapBreakpointRejected',
               { fg = '#888ca6', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
            vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
         end
      })

      -- reload current color scheme to pick up colors override if it was set up in a lazy plugin definition fashion
      vim.cmd.colorscheme(vim.g.colors_name)

      vim.fn.sign_define("DapBreakpoint", { text = "🛑", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

      -- vscode-style debugging
      vim.keymap.set("n", "<F5>", dap.continue, { desc = 'Start/Continue Debugging' })
      vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = 'Stop Debugging' })
      vim.keymap.set("n", "<C-S-F5>", dap.run_last, { desc = 'Restart Debugging' })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = 'Step over' })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = 'Step into' })
      vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = 'Step out' })
      vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      vim.keymap.set("n", "<leader>B", function()
         dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = 'Set conditional breakpoint' })

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

      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
   end,
}
