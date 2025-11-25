--[===[
Adds custom signs for current git status
URL: https://github.com/lewis6991/gitsigns.nvim
--]===]

---@diagnostic disable: param-type-mismatch
return {
   'lewis6991/gitsigns.nvim',
   enabled = true,
   event = 'VeryLazy',
   config = function()
      require('gitsigns').setup({
         -- See `:help gitsigns.txt`
         signs = {
            add = { text = '' },

            change = { text = '' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '' },
         },
         numhl = true, -- Change color of line number
      })
      vim.keymap.set('n', '<leader>gb', function() require('gitsigns').blame_line({ full = true }) end,
         { desc = '[g]it [b]lame current line' })
      vim.keymap.set('n', '<leader>gB', function() require('gitsigns').blame() end,
         { desc = '[g]it [B]lame current buffer' })
      vim.keymap.set('n', '<leader>gD', require('gitsigns').diffthis, { desc = '[G]it [D]iff this' })
      vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { desc = '[g]it preview [h]unk' })
      vim.keymap.set('n', '<leader>gn', function() require('gitsigns').nav_hunk('next') end,
         { desc = '[g]it Hunk [n]ext' })
      vim.keymap.set('n', '<leader>gN', function() require('gitsigns').nav_hunk('prev') end,
         { desc = '[g]it hu[N]k previous' })
      vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { desc = '[g]it [r]eset hunk' })
      vim.keymap.set('n', '<leader>gR', require('gitsigns').reset_buffer, { desc = '[g]it [R]eset buffer' })
      -- vim.keymap.set('n', '<leader>gs', require('gitsigns').stage_hunk, { desc = '[g]it [s]tage or unstage hunk' })
      -- vim.keymap.set('n', '<leader>gS', require('gitsigns').stage_buffer, { desc = '[g]it [S]tage current buffer' })
      -- vim.keymap.set('n', '<leader>gt', require('gitsigns').preview_hunk_inline, { desc = '[g]it [t]oggle deleted' })
   end
}
