--[===[
Collection of plugins that are fun to use
1. URL: https://github.com/eandrju/cellular-automaton.nvim
2. URL: https://github.com/tamton-aquib/duck.nvim
3. URL: https://github.com/AndrewRadev/typewriter.vim
4. URL: https://github.com/rhysd/vim-syntax-christmas-tree
5. URL: https://github.com/AndrewRadev/dealwithit.vim
6. URL: https://github.com/folke/drop.nvim 
7. URL: https://github.com/ThePrimeagen/vim-be-good
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
   -- { 'AndrewRadev/typewriter.vim' },
   -- { 'rhysd/vim-syntax-christmas-tree', -- Shows a christmas tree in a split with :MerryChristmas },
   -- { 'AndrewRadev/dealwithit.vim' },
   -- { "folke/drop.nvim",
   --    opt = {
   --       screensaver = 1000 * 60 * 5, -- show after 5 minutes. Set to false, to disable
   --       filetype = { "markdown", "vimwiki", "text", "lua" },
   --    },
   -- },
   -- { "ThePrimeagen/vim-be-good", }
   { "svenbergner/sudokusolver.nvim", dev = true }
}
