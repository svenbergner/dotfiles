--[===[ 

URL: https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-diff.md 
--]===]

return {
   'nvim-mini/mini.diff',
   version = false,
   enabled = true,
   config = function()
      require('mini.diff').setup()
      vim.keymap.set('n', '<leader>go', function() require('mini.diff').toggle_overlay(0) end, { desc = 'Toggle Diff Overlay' })

   end,
}
