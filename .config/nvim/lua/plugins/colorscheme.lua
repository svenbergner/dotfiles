--[===[
Current used colorscheme is gruvbox
URL: https://www.github.com/ellisonleao/gruvbox.nvim
--]===]

vim.o.background = "dark"

return {
   "ellisonleao/gruvbox.nvim",
   enabled = true,
   priority = 1000,
   opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
         strings = true,
         emphasis = true,
         comments = true,
         operators = false,
         folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
   },
   config = function()
      vim.cmd.colorscheme("gruvbox")
   end
}

-- Alternative source: 'gruvbox-community/gruvbox'
