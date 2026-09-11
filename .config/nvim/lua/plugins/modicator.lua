--[===[
Modicator.nvim 💡
Cursor line number mode indicator.

A small Neovim plugin that changes the color of your cursor's line number based on the current Vim mode.

Modicator has lualine.nvim support out of the box
https://github.com/mawkler/modicator.nvim
--]===]

return {
   'mawkler/modicator.nvim',
   enabled = true,
   dependencies = 'ellisonleao/gruvbox.nvim', -- Add your colorscheme plugin here
   init = function()
      -- These are required for Modicator to work
      vim.o.cursorline = true
      vim.o.number = true
      vim.o.termguicolors = true
   end,
   opts = {
      -- Warn if any required option above is missing. May emit false positives
      -- if some other plugin modifies them, which in that case you can just
      -- ignore. Feel free to remove this line after you've gotten Modicator to
      -- work properly.
      show_warnings = true,
      highlights = {
         -- Default options for bold/italic
         defaults = {
            bold = true,
            italic = true,
         },
         -- Use `CursorLine`'s background color for `CursorLineNr`'s background
         use_cursorline_background = false,
      },
      integration = {
         lualine = {
            enabled = true,
            -- Letter of lualine section to use (if `nil`, gets detected automatically)
            mode_section = nil,
            -- Whether to use lualine's mode highlight's foreground or background
            highlight = 'bg',
         },
      },
   },
}
