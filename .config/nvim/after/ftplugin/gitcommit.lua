-- Git commit buffer in floating window
-- This ftplugin opens git commit buffers in a centered floating window

local function open_in_floating_window()
   local buf = vim.api.nvim_get_current_buf()
   local win = vim.api.nvim_get_current_win()

   -- Verify buffer is valid
   if not vim.api.nvim_buf_is_valid(buf) then
      return
   end

   -- Get editor dimensions
   local ui = vim.api.nvim_list_uis()[1]
   if not ui then
      return
   end

   local width = ui.width
   local height = ui.height

   -- Calculate floating window size (80% of screen)
   local float_width = math.floor(width * 0.8)
   local float_height = math.floor(height * 0.8)

   -- Calculate center position
   local row = math.floor((height - float_height) / 2)
   local col = math.floor((width - float_width) / 2)

   -- Create floating window configuration
   local opts = {
      relative = 'editor',
      width = float_width,
      height = float_height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
      title = ' Git Commit ',
      title_pos = 'center',
   }

   -- Create the floating window first
   local float_win = vim.api.nvim_open_win(buf, true, opts)

   -- Close the original window if it's not the only one
   local windows = vim.api.nvim_list_wins()
   if #windows > 1 and vim.api.nvim_win_is_valid(win) and win ~= float_win then
      pcall(vim.api.nvim_win_close, win, false)
   end

   -- Set window options
   vim.api.nvim_set_option_value('winblend', 0, { win = float_win })
   vim.api.nvim_set_option_value('winhighlight', 'Normal:Normal,FloatBorder:FloatBorder', { win = float_win })

   -- Add keymaps to close the floating window
   local close_float = function()
      if vim.api.nvim_win_is_valid(float_win) then
         vim.api.nvim_win_close(float_win, true)
      end
   end

   -- Map <Esc><Esc> to close (but not single <Esc> since it's needed in insert mode)
   vim.keymap.set('n', '<Esc><Esc>', close_float, { buffer = buf, noremap = true, silent = true, desc = 'Close git commit window' })
   vim.keymap.set('n', 'q', close_float, { buffer = buf, noremap = true, silent = true, desc = 'Close git commit window' })

   -- Also allow closing with ZZ, :q or :wq as normal
   vim.api.nvim_create_autocmd('BufWinLeave', {
      buffer = buf,
      once = true,
      callback = close_float,
   })
end

-- Trigger the floating window creation with a delay to ensure buffer is fully loaded
-- This ftplugin is executed when the gitcommit filetype is set
vim.schedule(function()
   local buf = vim.api.nvim_get_current_buf()
   if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == 'gitcommit' then
      open_in_floating_window()
   end
end)

