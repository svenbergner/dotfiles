--[===[
Smarter and more intuitive split pane management that uses a mental model of
left/right/up/down instead of wider/narrower/taller/shorter for resizing.
Supports seamless navigation between Neovim and terminal multiplexer split panes. 
--]===]

return
{
   'mrjones2014/smart-splits.nvim',
   enabled = true,
   config = function()
      -- recommended mappings
      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
      local smartsplits = require('smart-splits')

      vim.keymap.set('n', '<A-h>', smartsplits.resize_left, { desc = "Change width of pane" })
      vim.keymap.set('n', '<A-j>', smartsplits.resize_down, { desc = "Change height of pane" })
      vim.keymap.set('n', '<A-k>', smartsplits.resize_up, { desc = "Change height of pane" })
      vim.keymap.set('n', '<A-l>', smartsplits.resize_right, { desc = "Change width of pane" })
      vim.keymap.set('v', '<A-h>', smartsplits.resize_left, { desc = "Change width of pane" })
      vim.keymap.set('v', '<A-j>', smartsplits.resize_down, { desc = "Change height of pane" })
      vim.keymap.set('v', '<A-k>', smartsplits.resize_up, { desc = "Change height of pane" })
      vim.keymap.set('v', '<A-l>', smartsplits.resize_right, { desc = "Change width of pane" })

      -- moving between splits
      vim.keymap.set('n', '<C-h>', smartsplits.move_cursor_left, { desc = "Move focus to the left pane" })
      vim.keymap.set('n', '<C-j>', smartsplits.move_cursor_down, { desc = "Move focus to the bottom pane" })
      vim.keymap.set('n', '<C-k>', smartsplits.move_cursor_up, { desc = "Move focus to the top pane" })
      vim.keymap.set('n', '<C-l>', smartsplits.move_cursor_right, { desc = "Move focus to the right pane" })
      vim.keymap.set('n', '<C-\\>', smartsplits.move_cursor_previous, { desc = "Move focus to the previous pane" })
      vim.keymap.set('v', '<C-h>', smartsplits.move_cursor_left, { desc = "Move focus to the left pane" })
      vim.keymap.set('v', '<C-j>', smartsplits.move_cursor_down, { desc = "Move focus to the bottom pane" })
      vim.keymap.set('v', '<C-k>', smartsplits.move_cursor_up, { desc = "Move focus to the top pane" })
      vim.keymap.set('v', '<C-l>', smartsplits.move_cursor_right, { desc = "Move focus to the right pane" })
      vim.keymap.set('v', '<C-\\>', smartsplits.move_cursor_previous, { desc = "Move focus to the previous pane" })

      -- swapping buffers between windows
      vim.keymap.set('n', '<leader>sh', smartsplits.swap_buf_left, { desc = "Swap current pane with the left" })
      vim.keymap.set('n', '<leader>sj', smartsplits.swap_buf_down, { desc = "Swap current pane with the bottom" })
      vim.keymap.set('n', '<leader>sk', smartsplits.swap_buf_up, { desc = "Swap current pane with the top" })
      vim.keymap.set('n', '<leader>sl', smartsplits.swap_buf_right, { desc = "Swap current pane with the right" })
      vim.keymap.set('v', '<leader>sh', smartsplits.swap_buf_left, { desc = "Swap current pane with the left" })
      vim.keymap.set('v', '<leader>sj', smartsplits.swap_buf_down, { desc = "Swap current pane with the bottom" })
      vim.keymap.set('v', '<leader>sk', smartsplits.swap_buf_up, { desc = "Swap current pane with the top" })
      vim.keymap.set('v', '<leader>sl', smartsplits.swap_buf_right, { desc = "Swap current pane with the right" })
   end
}
