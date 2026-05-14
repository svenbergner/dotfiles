local M = {}
local wezterm = require('wezterm')

M.getFancyBackground = function()
   local home_dir = wezterm.home_dir
   return {
      {
         source = {
            File = home_dir .. '/.config/wezterm/background/Matrix-Wallpaper.gif',
         },
         width = '100%',
         hsb = { brightness = 0.3 },
      },
   }
end

M.getEmptyBackground = function()
   return {
      {
         -- Base color layer shown around the image
         source = { Color = '#1d2021' },
         width = '100%',
         height = '100%',
         horizontal_align = 'Center',
         vertical_align = 'Middle',
      },
   }
end

M.getSimpleBackground = function()
   local home_dir = wezterm.home_dir
   return {
      {
         -- Base color layer shown around the image
         source = { Color = '#000000' },
         width = '100%',
         height = '100%',
         horizontal_align = 'Center',
         vertical_align = 'Middle',
      },
      {
         source = {
            -- File = home_dir .. '/.config/wezterm/background/neovim3.png',
            File = home_dir .. '/.config/wezterm/background/OnoSendaiCyberspace7.jpg',
         },
         width = '50%',
         height = '50%',
         horizontal_align = 'Right',
         vertical_align = 'Top',
         repeat_x = 'NoRepeat',
         repeat_y = 'NoRepeat',
         hsb = { brightness = 0.3 },
      },
   }
end

M.toggleBackground = function(window)
   local overrides = window:get_config_overrides() or {}
   if wezterm.GLOBAL.fancy_background then
      overrides.background = M.getSimpleBackground()
      wezterm.GLOBAL.fancy_background = false
   else
      overrides.background = M.getFancyBackground()
      wezterm.GLOBAL.fancy_background = true
   end
   overrides.window_background_opacity = 1
   window:set_config_overrides(overrides)
end

M.setBlankBackground = function(config)
   config.background = M.getEmptyBackground()
   config.window_background_opacity = 1
end

return M
