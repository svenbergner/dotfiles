--[===[
All LSP configurations go here
URL: https://github.com/neovim/nvim-lspconfig
--]===]

return {
   'neovim/nvim-lspconfig',
   enabled = true,
   dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Allows extra capabilities provided by blink-cmp
      'saghen/blink.cmp',
   },
   config = function()
      vim.lsp.set_log_level('OFF')
      vim.keymap.set('n', '<F6>', function()
         vim.diagnostic.goto_next()
         vim.cmd('normal! zz')
      end
      , { desc = "Go to next diagnostic message" })
      vim.keymap.set('n', '<S-F6>', function()
         vim.diagnostic.goto_prev()
         vim.cmd('normal! zz')
      end, { desc = "Go to previous diagnostic message" })
      vim.keymap.set('n', '<F18>', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })

      vim.diagnostic.config({
         float = {
            source = true,
            border = "single"
         },
      })

      local on_attach = function(_, bufnr)
         local nmap = function(keys, func, desc)
            if desc then
               desc = 'LSP: ' .. desc
            end
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
         end
         local imap = function(keys, func, desc)
            if desc then
               desc = 'LSP: ' .. desc
            end
            vim.keymap.set('i', keys, func, { buffer = bufnr, desc = desc })
         end
         local is_clangd = function()
            for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
               if client.name == "clangd" then
                  return true
               end
               return false
            end
         end
         if is_clangd() then
            local sw = '<cmd>ClangdSwitchSourceHeader<CR>'
            nmap('<F4>', sw, 'F4 - switch source/header')
            nmap('<A-o>', sw, 'Alt + o - switch source/header')
            nmap('<M-o>', sw, 'Meta + o - switch source/header')
            imap('<A-o>', sw, 'Alt + o - switch source/header')
            imap('<M-o>', sw, 'Meta + o - switch source/header')
         end
         nmap('<F2>', vim.lsp.buf.rename, 'Rename <F2>')
         nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
         nmap('<C-S-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
         nmap('<leader>Wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
         nmap('<leader>Wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
         nmap('<leader>Wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
         end, '[W]orkspace [L]ist Folders')

         vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format()
         end, { desc = 'Format current buffer with LSP' })
         nmap('<S-F7>', '<cmd>ConfigureCMakeBuild<CR>', 'Run cmake configure')
         nmap('<F19>', '<cmd>ConfigureCMakeBuild<CR>', 'Run cmake configure')
         nmap('<F7>', '<cmd>RunCMakeBuild<CR>', 'Run cmake build')
         vim.lsp.inlay_hint.enable(true)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

      local servers = {
         bashls = {},
         clangd = {
            capabilities = {
               offsetEncoding = { "utf-16" },
            },
            cmd = {
               "clangd",
               "--background-index",
               "--clang-tidy",
               "--header-insertion=iwyu",
               "--completion-style=detailed",
               "--function-arg-placeholders",
               "--fallback-style=llvm",
            },
            init_options = {
               usePlaceholders = true,
               completeUnimported = true,
               clangdFileStatus = true,
            },
            inlay_hints = {
               includeInlayEnumMemberValueHints = true,
               includeInlayFunctionLikeReturnTypeHints = true,
               includeInlayFunctionParameterTypeHints = true,
               includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
               includeInlayParameterNameHintsWhenArgumentMatchesName = true,
               includeInlayPropertyDeclarationTypeHints = true,
               includeInlayVariableTypeHints = true,
            }
         },
         cssls = {},
         cmake = {},
         dockerls = {},
         jsonls = {},
         lua_ls = {
            Lua = {
               workspace = { checkThirdParty = false },
               telemetry = { enable = false },
               format = {
                  enable = true,
                  defaultConfig = {
                     align_continuous_assign_statement = false,
                     align_continuous_rect_table_field = false
                  },
               },
               diagnostics = {
                  disable = { 'missing-fields' },
                  globals = {
                     'vim',
                     "require",
                     "package",
                     "Snacks"
                  },
               },
            },
            inlay_hints = {
               includeInlayEnumMemberValueHints = true,
               includeInlayFunctionLikeReturnTypeHints = true,
               includeInlayFunctionParameterTypeHints = true,
               includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
               includeInlayParameterNameHintsWhenArgumentMatchesName = true,
               includeInlayPropertyDeclarationTypeHints = true,
               includeInlayVariableTypeHints = false,
            }
         },
         marksman = {},
         pylsp = {
            settings = {
               pylsp = {
                  plugins = {
                     pycodestyle = {
                        ignore = {
                           "E501", -- line too long
                           "E402", -- Module level import not at top of file
                        },
                        maxLineLength = 120,
                     }
                  }
               }
            }
         },
         pyright = {
            settings = {
               python = {
                  analysis = {
                     typeCheckingMode = "strict",
                     maxLineLength = 120,
                     autoSearchPaths = true,
                     useLibraryCodeForTypes = true,
                     diagnosticMode = "workspace",
                     -- stubPath = "/usr/lib/python3.9/site-packages",
                  }
               }
            },
         },
         yamlls = {},
         -- azure_pipelines_ls = {
         --    settings = {
         --       yaml = {
         --          schemas = {
         --             ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = { "*.y*l", }
         --          }
         --       }
         --    }
         -- },
      }

      vim.diagnostic.config({
         severity_sort = true,
         float = { border = 'rounded', source = 'if_many' },
         underline = { severity = vim.diagnostic.severity.ERROR },
         signs = {
            text = {
               [vim.diagnostic.severity.ERROR] = ' ',
               [vim.diagnostic.severity.WARN] = ' ',
               [vim.diagnostic.severity.INFO] = ' ',
               [vim.diagnostic.severity.HINT] = '󰌶 ',
            },
         } or {},
         virtual_lines = {
            source = 'if_many',
            spacing = 2,
            format = function(diagnostic)
               local diagnostic_message = {
                  [vim.diagnostic.severity.ERROR] = diagnostic.message,
                  [vim.diagnostic.severity.WARN] = diagnostic.message,
                  [vim.diagnostic.severity.INFO] = diagnostic.message,
                  [vim.diagnostic.severity.HINT] = diagnostic.message,
               }
               return diagnostic_message[diagnostic.severity]
            end,
         },
      })

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua' })

      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      require('mason').setup()
      local mason_lspconfig = require('mason-lspconfig')
      mason_lspconfig.setup {
         ensure_installed = {},
         automatic_installation = false,
      }
      mason_lspconfig.setup_handlers {
         function(server_name)
            require('lspconfig')[server_name].setup({
               on_attach = on_attach,
               capabilities = capabilities,
               settings = servers[server_name],
               handlers = {
                  ["textDocument/hover"] = vim.lsp.buf.hover,
                  { border = 'single' },
                  ["textDocument/signatureHelp"] = vim.lsp.buf.signature_help,
                  { border = 'single' },
               }
            })
         end,
      }

      vim.api.nvim_command('MasonToolsInstall')
      vim.api.nvim_create_autocmd('LspAttach', {
         callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client == nil then
               return
            end
            if client:supports_method('textDocument/completion') then
               vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            end
         end,
      })
   end
}
