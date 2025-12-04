--[===[
Mason.nvim configuration for Neovim
Provides a portable package manager for Neovim that allows installing and managing
LSP servers, DAP servers, linters, and formatters.

URL: https://github.com/mason-org/mason.nvim
URL: https://github.com/mason-org/mason-lspconfig.nvim
URL: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
URL: https://github.com/neovim/nvim-lspconfig
URL: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
URL: https://github.com/j-hui/fidget.nvim
URL: https://github.com/saghen/blink.cmp
--]===]

return {
   'mason-org/mason-lspconfig.nvim',
   enabled = true,
   opts = {
      ensure_installed = {
         -- LSPs
         'azure_pipelines_ls',
         'bashls',
         'clangd',
         'cmake',
         'elixirls',
         'jsonls',
         'lua_ls',
         'marksman',
         'pico8_ls',
         'pylsp',
         'spectral',
         'terraformls',
         'tinymist',
      },
   },
   dependencies = {
      {
         'mason-org/mason.nvim',
         opts = {
            ui = {
               border = 'rounded',
               icons = {
                  package_installed = "✓",
                  package_pending = "➜",
                  package_uninstalled = "✗",
               }
            },
         },
      },
      'neovim/nvim-lspconfig',
      {
         'WhoIsSethDaniel/mason-tool-installer.nvim',
         opts = {
            ensure_installed = {
               -- LSPs
               'codelldb',
               'sonarlint-language-server',

               -- DAPs
               'bash-debug-adapter',
               'dart-debug-adapter',

               -- Formatters and Linters
               'clang-format',
               'cmakelint',
               'flake8',
               'hclfmt',
               'markdown-toc',
               'pyright',
               'stylua',
               'terraform',
            },
         },
      },
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- Allows extra capabilities provided by blink-cmp
      'saghen/blink.cmp',
   },
}
