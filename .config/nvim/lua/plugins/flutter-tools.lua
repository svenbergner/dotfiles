--[===[ Plugin which adds some tools for developing with flutter
URL: https://github.com/akinsho/flutter-tools.nvim
--]===]

return {
   "akinsho/flutter-tools.nvim",
   enabled = true,
   lazy = true,
   ft = { "dart" },
   dependencies = {
      "nvim-lua/plenary.nvim",
      "dart-lang/dart-vim-plugin",
   },
   config = function()
      -- dart-vim-plugin options
      vim.g.dart_style_guide = 2
      vim.g.dart_format_on_save = 1
      vim.g.dart_trailing_comma_indent = true

      -- local line = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
      require("flutter-tools").setup({
         fvm = true,
         ui = {
            border = "rounded",
            notification_style = 'native',
         },
         decorations = {
            statusline = {
               app_version = true,
               device = true,
               project_config = true,
            }
         },
         debugger = {
            enabled = true,
            register_configurations = function(_)
               require("dap").configurations.dart = {
                  {
                     type = "dart",
                     request = "launch",
                     name = "Launch Dart Program",
                     program = "${file}",
                     cwd = "${workspaceFolder}",
                     args = { "--dart-define-from-file=env-vars.json" },      -- Note for Dart Apps this is args, for Flutter apps toolArgs
                     toolsArgs = { "--dart-define-from-file=env-vars.json" }, -- Note for Dart Apps this is args, for Flutter apps toolArgs
                  },
                  {
                     type = "dart",
                     request = "launch",
                     name = "Launch Dart Web App (Chrome)",
                     program = "${file}",
                     cwd = "${workspaceFolder}",
                     args = { "-d chrome", "--web-port=1337", "--dart-define-from-file=env-vars.json" },      -- Note for Dart Apps this is args, for Flutter apps toolArgs
                     toolsArgs = { "-d chrome", "--web-port=1337", "--dart-define-from-file=env-vars.json" }, -- Note for Dart Apps this is args, for Flutter apps toolArgs
                  }
               }
               ---@diagnostic disable-next-line: deprecated
               require("dap.ext.vscode").load_launchjs()
            end,
            -- run_via_dap = true,
            -- exception_breakpoints = {},
         },
         widgets_guides = {
            enabled = true,
            debug = true,
         },
         closing_tags = {
            highlight = 'Comment',
            prefix = '// ',
            enabled = true,
         },
         dev_log = {
            enabled = true,
            open_cmd = '15split',
            focus_on_open = false,
            notity_errors = true,
         },
         dev_tools = {
            autostart = true,
            auto_open_browser = true,
         },
         outline = {
            open_cmd = '30vnew',
            auto_open = false,
         },
         lsp = {
            color = {
               enabled = true,
               background = true,
               virtual_text = false,
            },
            settings = {
               showTodos = true,
               lineLength = 120,
               renameFilesWithClasses = 'always',
               documentation = 'full',
               updateImportsOnRename = true,
               completeFunctionCalls = true,
               enableSnippets = true,
            }
         }
      })

      -- require("flutter-tools").setup_project({
      --    {
      --       name = 'simplytaxapp',
      --       flavor = 'dev',
      --       target = 'lib/main.dart',
      --    }
      -- })

      local nmap = function(keys, func, desc)
         vim.keymap.set('n', keys, func, { desc = desc })
      end
      nmap('<F2>', vim.lsp.buf.rename, 'Rename <F2>')
      nmap('<C-S-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      nmap('<F5>', function() vim.cmd('FlutterDebug') end, 'Start/Continue Debugging')
   end,
}
