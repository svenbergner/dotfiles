--[===[
Neovim Treesitter context
https://github.com/nvim-treesitter/nvim-treesitter-context

A Neovim plugin that shows the context of the currently visible buffer contents.
It's supposed to work on a wide range of file types, but is probably most useful
when looking at source code files. In most programming languages this context
will show you which function you're looking at, and within that function which
loops or conditions are surrounding the visible code.
--]===]

return {
--    'nvim-treesitter/nvim-treesitter-context',
--    enabled = true,
--    branch = 'master',
--    event = 'VeryLazy',
--    opts = {
--       enable = true,
--       mode = 'cursor',
--       max_lines = 0,
--    },
--    keys = {
--       {
--          '<leader>TC',
--          function()
--             local tsc = require('treesitter-context')
--             tsc.toggle()
--          end,
--          desc = '[T]oggle Treesitter [C]ontext',
--       },
--    },
}
