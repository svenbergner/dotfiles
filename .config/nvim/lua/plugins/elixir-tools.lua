--[===[
elixir-tools.nvim provides a nice experience for writing Elixir applications with Neovim.

NOTE: This plugin does not provide autocompletion, I recommend using nvim-cmp.
NOTE: This plugin does not provide syntax highlighting, I recommend using nvim-treesitter.

Features:
- Next LS installation and configuration.
- ElixirLS installation and configuration.
- :Mix command with autocomplete
- vim-projectionist support

URL: https://github.com/elixir-tools/elixir-tools.nvim
--]===]

return {
   'elixir-tools/elixir-tools.nvim',
   enabled = true,
   version = '*',
   event = { 'BufReadPre', 'BufNewFile' },
   config = function()
      local elixir = require('elixir')
      local elixirls = require('elixir.elixirls')

      elixir.setup({
         nextls = { enable = true },
         elixirls = {
            enable = true,
            settings = elixirls.settings({
               dialyzerEnabled = false,
               enableTestLenses = false,
            }),
            on_attach = function(_, _)
               vim.keymap.set(
                  'n',
                  '<leader>efp',
                  ':ElixirFromPipe<cr>',
                  { desc = 'Convert pipe operator to nested expressions.', buffer = true, noremap = true }
               )
               vim.keymap.set(
                  'n',
                  '<leader>etp',
                  ':ElixirToPipe<cr>',
                  { desc = 'Convert nested expressions to the pipe operator.', buffer = true, noremap = true }
               )
               vim.keymap.set(
                  'v',
                  '<leader>eem',
                  ':ElixirExpandMacro<cr>',
                  {
                     desc = 'For the given [range], expand any macros and display it in a floating window.',
                     buffer = true,
                     noremap = true,
                  }
               )
            end,
         },
         projectionist = {
            enable = true,
         },
      })
   end,
   dependencies = {
      'nvim-lua/plenary.nvim',
   },
}
