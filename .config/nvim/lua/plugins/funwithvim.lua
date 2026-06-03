--[===[
Collection of plugins that are fun to use
https://github.com/eandrju/cellular-automaton.nvim
https://github.com/tamton-aquib/duck.nvim
https://github.com/rhysd/vim-syntax-christmas-tree
https://github.com/folke/drop.nvim
https://github.com/ThePrimeagen/vim-be-good
https://github.com/svenbergner/sudokusolver.nvim
--]===]

return {
   -- { 'eandrju/cellular-automaton.nvim' },
   -- { 'tamton-aquib/duck.nvim',
   --    config = function()
   --       vim.keymap.set('n', '<leader>dd', function() require("duck").hatch() end, {})
   --       vim.keymap.set('n', '<leader>dk', function() require("duck").cook() end, {})
   --       vim.keymap.set('n', '<leader>da', function() require("duck").cook_all() end, {})
   --    end
   -- },
   -- { 'rhysd/vim-syntax-christmas-tree', -- Shows a christmas tree in a split with :MerryChristmas },
   -- { "folke/drop.nvim",
   --    opt = {
   --       screensaver = 1000 * 60 * 5, -- show after 5 minutes. Set to false, to disable
   --       filetype = { "markdown", "vimwiki", "text", "lua" },
   --    },
   -- },
   -- { "ThePrimeagen/vim-be-good", }
   { 'svenbergner/sudokusolver.nvim', enabled = true, cmd = 'SudokuSolverStart', dev = true },
}
