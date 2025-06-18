--[===[

URL: https://github.com/mason-org/mason.nvim
URL: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
URL: https://github.com/j-hui/fidget.nvim
URL: https://github.com/saghen/blink.cmp
--]===]

return {
   'mason-org/mason.nvim',
   dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- Allows extra capabilities provided by blink-cmp
      'saghen/blink.cmp',
   },
   opts = {
      ui = {
         icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
         }
      },
   },
   config = function(_, opts)
      require('mason').setup(opts)
      require('mason-tool-installer').setup({
         ensure_installed = opts.ensure_installed,
         auto_update = true,
         run_on_start = true,
         run_on_change = true,
      })
   end,
}
