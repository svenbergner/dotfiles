--[===[
Smear cursor for Neovim
Neovim plugin to animate the cursor with a smear effect in all terminals.
Inspired by Neovide's animated cursor.

This plugin is intended for terminals/GUIs that can only display text and do
not have graphical capabilities (unlike Neovide, or the Kitty terminal).

URL: https://github.com/sphamba/smear-cursor.nvim
--]===]

return {
   "sphamba/smear-cursor.nvim",
   opts = {
      -- smear_to_cmd = false, -- can be removed in nvim 0.12.*
      cursor_color = "#ff8800", -- Cursor color, can be a hex color or a color name
      stiffness = 0.3,
      trailing_stiffness = 0.1,
      stiffness_insert_mode = 0.7,
      trailing_stiffness_insert_mode = 0.7,
      trailing_exponent = 5,
      damping = 0.5,
      damping_insert_mode = 0.8,
      distance_stop_animating = 0.5,
      gama = 1,
      hide_target_hack = false,
      never_draw_over_target = false,
   },
}
