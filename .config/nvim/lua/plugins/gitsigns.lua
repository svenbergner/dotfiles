--[===[
Gitsigns
Deep buffer integration for Git
Adds custom signs for current git status

URL: https://github.com/lewis6991/gitsigns.nvim
--]===]

---@diagnostic disable: param-type-mismatch
return {
   'lewis6991/gitsigns.nvim',
   dev = false,
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
         word_diff = false, -- Toggle word diff
         current_line_blame = true, -- Show git blame info for current line
         current_line_blame_formatter = '  <author> • <author_time:%R> • <summary>  ',
         current_line_blame_formatter_nc = '  Not Committed Yet  ',
         current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
            delay = 0,
            ignore_whitespace = false,
            virt_text_priority = 100,
            use_focus = true,
         },
         preview_config = {
            border = 'rounded',
         },
      })
      vim.keymap.set('n', '<leader>gb', function()
         require('gitsigns').blame_line({ full = true })
      end, { desc = '[g]it [b]lame current line' })
      vim.keymap.set('n', '<leader>gB', function()
         require('gitsigns').blame()
      end, { desc = '[g]it [B]lame current buffer' })
      vim.keymap.set('n', '<leader>gD', require('gitsigns').diffthis, { desc = '[g]it [D]iff this' })
      vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { desc = '[g]it preview [h]unk' })
      vim.keymap.set('n', '<leader>gn', function()
         require('gitsigns').nav_hunk('next')
      end, { desc = '[g]it Hunk [n]ext' })
      vim.keymap.set('n', '<leader>gN', function()
         require('gitsigns').nav_hunk('prev')
      end, { desc = '[g]it hu[N]k previous' })
      vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { desc = '[g]it [r]eset hunk' })
      vim.keymap.set('n', '<leader>gR', require('gitsigns').reset_buffer, { desc = '[g]it [R]eset buffer' })
      vim.keymap.set('n', '<leader>gs', require('gitsigns').stage_hunk, { desc = '[g]it [s]tage or unstage hunk' })
      vim.keymap.set('n', '<leader>gS', require('gitsigns').stage_buffer, { desc = '[g]it [S]tage current buffer' })
      vim.keymap.set(
         'n',
         '<leader>gt',
         require('gitsigns').toggle_current_line_blame,
         { desc = '[g]it [t]oggle current line blame' }
      )
      vim.keymap.set('n', '<leader>gt', require('gitsigns').preview_hunk_inline, { desc = '[g]it [T]oggle deleted' })
      vim.keymap.set('n', '<leader>gw', require('gitsigns').toggle_word_diff, { desc = '[g]it toggle [w]ord diff' })

      -- Remove last search highlight after cursor moved
      local autocmd = vim.api.nvim_create_autocmd
      local augroup = vim.api.nvim_create_augroup
      autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
         once = true,
         group = augroup('gitsigns-set-lineblamecolor', { clear = true }),
         callback = function()
            vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', {
               fg = vim.api.nvim_get_hl(0, { name = 'GruvboxBlueSign' }).fg,
            })
         end,
      })
   end,
}
