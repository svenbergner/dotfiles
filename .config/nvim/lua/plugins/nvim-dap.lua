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
            command = '/Users/sven.bergner/.local/share/nvim/mason/bin/codelldb',--vim.fn.exepath("codelldb"),
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
            args = { "--dart-define-from-file=emv-vars.json"}, -- Note for Dart Apps this is args, for Flutter apps toolArgs
            toolsArgs = { "--dart-define-from-file=emv-vars.json"}, -- Note for Dart Apps this is args, for Flutter apps toolArgs
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

      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

      -- vim-style debugging
      vim.keymap.set("n", "<leader>d", dap.continue, { desc = 'Start/Continue Debugging' })
      vim.keymap.set("n", "<leader>D", dap.terminate, { desc = 'Stop Debugging' })
      vim.keymap.set("n", "<leader><C-S>d", dap.run_last, { desc = 'Restart Debugging' })
      vim.keymap.set("n", "<leader>l", dap.step_over, { desc = 'Step over' })
      vim.keymap.set("n", "<leader>j", dap.step_into, { desc = 'Step into' })
      vim.keymap.set("n", "<leader>k", dap.step_out, { desc = 'Step out' })
      vim.keymap.set("n", "<leader>h", dap.step_back, { desc = 'Step back' })
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })

      -- vscode-style debugging
      vim.keymap.set("n", "<F5>", dap.continue, { desc = 'Start/Continue Debugging' })
      vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = 'Stop Debugging' })
      vim.keymap.set("n", "<C-S-F5>", dap.run_last, { desc = 'Restart Debugging' })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = 'Step over' })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = 'Step into' })
      vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = 'Step out' })
      vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
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
