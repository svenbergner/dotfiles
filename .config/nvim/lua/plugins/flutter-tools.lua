-- Plugin which adds some tools for developing with flutter
return {
   "akinsho/flutter-tools.nvim",
   lazy = true,
   ft = { "dart" },
   dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
      "dart-lang/dart-vim-plugin",
   },
   config = function()
      -- dart-vim-plugin options
      vim.g.dart_style_guide = 2
      vim.g.dart_format_on_save = 1
      vim.g.dart_trailing_comma_indent = true

      local line = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
      require("flutter-tools").setup({
         fvm = true,
         ui = { border = line },
         outline = { auto_open = false },
         decorations = {
            statusline = {
               app_version = true,
               device = true,
               project_config = true,
            }
         },
         debugger = {
            enabled = true,
            run_via_dap = true,
            exception_breakpoints = {},
         },
         widgets_guides = {
            enabled = true,
            debug = true,
         },
         closing_tags = {
            highlight = 'Comment',
            prefix = '//',
            enabled = true,
         },
         dev_log = {
            enabled = true,
            open_cmd = 'tabedit'
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

      local nmap = function(keys, func, desc)
         vim.keymap.set('n', keys, func, { desc = desc })
      end
      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<F2>', vim.lsp.buf.rename, '[R]e[n]ame')
      -- Replaced by actions-preview.lua plugin
      -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>Ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-S-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      nmap('<leader>Wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>Wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>Wl', function()
         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')
   end,
}
