-- Language Server Protocol configuration for Lua
-- URL: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls

return {
   cmd = { 'lua-language-server' },
   filetypes = { 'lua' },
   root_markers = {
      '.git',
      '.luacheckrc',
      '.stylua.toml',
      'stylua.toml',
   },
   settings = {
      Lua = {
         hint = { enable = true },
         workspace = {
            checkThirdParty = false,
            library = {
               vim.env.VIMRUNTIME,
               '${3rd}/luv/library',
            },
         },
         telemetry = { enable = false },
         format = {
            enable = true,
         },
         diagnostics = {
            disable = { 'missing-fields' },
            globals = {
               'vim',
               'filetypes',
               'require',
               'package',
               'Snacks',
            },
         },
      },
      inlay_hints = {
         includeInlayEnumMemberValueHints = true,
         includeInlayFunctionLikeReturnTypeHints = true,
         includeInlayFunctionParameterTypeHints = true,
         includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
         includeInlayParameterNameHintsWhenArgumentMatchesName = true,
         includeInlayPropertyDeclarationTypeHints = true,
         includeInlayVariableTypeHints = false,
      },
   },
   single_file_support = true,
   log_level = vim.lsp.protocol.MessageType.Warning,
}
