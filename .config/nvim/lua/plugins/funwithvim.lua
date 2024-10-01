-- Collection of plugins that are fun to use
-- 1. https://github.com/eandrju/cellular-automaton.nvim
-- 2. https://github.com/tamton-aquib/duck.nvim
-- 3. https://github.com/AndrewRadev/typewriter.vim
-- 4. https://github.com/rhysd/vim-syntax-christmas-tree
-- 5. https://github.com/AndrewRadev/dealwithit.vim

return {
   {
      'eandrju/cellular-automaton.nvim'
   },
   {
      'tamton-aquib/duck.nvim',
      config = function()
         vim.keymap.set('n', '<leader>dd', function() require("duck").hatch() end, {})
         vim.keymap.set('n', '<leader>dk', function() require("duck").cook() end, {})
         vim.keymap.set('n', '<leader>da', function() require("duck").cook_all() end, {})
      end
   },
   {
      'AndrewRadev/typewriter.vim'
   },
   {
      'rhysd/vim-syntax-christmas-tree'
   },
   {
      'AndrewRadev/dealwithit.vim'
   }
}
