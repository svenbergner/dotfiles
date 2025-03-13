--[===[
All LSP configurations go here
URL: https://github.com/neovim/nvim-lspconfig
--]===]

return {
   'neovim/nvim-lspconfig',
   enabled = true,
   dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',
      { 'j-hui/fidget.nvim', opts = {} },
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
         nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
         nmap('<leader>Ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
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
         nmap('<leader>df', vim.lsp.buf.format, 'LSP: format document')
         nmap('<S-F7>', '<cmd>ConfigureCMakeBuild<CR>', 'Run cmake configure')
         nmap('<F19>', '<cmd>ConfigureCMakeBuild<CR>', 'Run cmake configure')
         nmap('<F7>', '<cmd>RunCMakeBuild<CR>', 'Run cmake build')
         vim.lsp.inlay_hint.enable(true)
      end

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
                           "E402", -- module level import not at top of file
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

      local default_capabilities = vim.lsp.protocol.make_client_capabilities()
      local capabilities = require('blink.cmp').get_lsp_capabilities(default_capabilities)

      require('mason').setup()
      local mason_lspconfig = require('mason-lspconfig')
      mason_lspconfig.setup {
         ensure_installed = vim.tbl_keys(servers),
         automatic_installation = true,
      }
      mason_lspconfig.setup_handlers {
         function(server_name)
            require('lspconfig')[server_name].setup {
               capabilities = capabilities,
               on_attach = on_attach,
               settings = servers[server_name],
               handlers = {
                  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' }),
                  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })
               },
            }
         end,
      }

      require('mason-tool-installer').setup({
         ensure_installed = {}
      }
      )
      vim.api.nvim_command('MasonToolsInstall')
   end
}
