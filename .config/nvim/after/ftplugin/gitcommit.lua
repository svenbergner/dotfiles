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

   -- Transform the existing window into a floating window using nvim_win_set_config.
   -- This avoids closing and re-opening windows, which would break git's process flow
   -- since git waits for Neovim to exit after the commit message is written.
   vim.api.nvim_win_set_config(win, {
      relative = 'editor',
      width = float_width,
      height = float_height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
      title = ' Git Commit ',
      title_pos = 'center',
   })

   -- Set window options
   vim.api.nvim_set_option_value('winhighlight', 'Normal:Normal,FloatBorder:FloatBorder', { win = win })

   -- Add keymaps to abort the commit (close without saving)
   local close_float = function()
      if vim.api.nvim_win_is_valid(win) then
         vim.cmd('q!')
      end
   end

   -- Map <Esc><Esc> to close (but not single <Esc> since it's needed in insert mode)
   vim.keymap.set(
      'n',
      '<Esc><Esc>',
      close_float,
      { buffer = buf, noremap = true, silent = true, desc = 'Close git commit window' }
   )
   vim.keymap.set(
      'n',
      'q',
      close_float,
      { buffer = buf, noremap = true, silent = true, desc = 'Close git commit window' }
   )

   -- Also allow closing with ZZ, :q or :wq as normal
   vim.api.nvim_create_autocmd('WinClosed', {
      pattern = tostring(float_win),
      once = true,
      callback = close_float,
   })
end

-- Trigger the floating window creation with a delay to ensure buffer is fully loaded
-- This ftplugin is executed when the gitcommit filetype is set
local buf = vim.api.nvim_get_current_buf()
vim.schedule(function()
   if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == 'gitcommit' then
      open_in_floating_window()
   end
end)
