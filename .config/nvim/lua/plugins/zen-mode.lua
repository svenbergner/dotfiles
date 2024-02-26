return {
   'folke/zen-mode.nvim',
   event = 'VeryLazy',
   opts = {},
   config = function()
      require('zen-mode').setup({
         window = {
            height = 0.75
         }
      })
      local toggleZenMode = function()
         if vim.g.zen_mode_active then
            require("zen-mode").close()
            vim.g.zen_mode_active = false
            vim.opt.wrap = false
         else
            require("zen-mode").open()
            vim.g.zen_mode_active = true
            vim.opt.wrap = true
         end
      end
      vim.keymap.set('n', '<leader>zm', toggleZenMode, { desc = 'Toggle [Z]en[Mode]' })
   end
}
