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
   return {}
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
            File = home_dir ..
               '/.config/wezterm/background/OnoSendaiCyberspace7.jpg',
         },
         width = '50%',
         height = '50%',
         horizontal_align = 'Center',
         vertical_align = 'Middle',
         repeat_x = 'NoRepeat',
         repeat_y = 'NoRepeat',
         hsb = { brightness = 0.3 },
      },
   }
end

M.toggleBackground = function(config)
   if wezterm.GLOBAL.fancy_background then
      config.background = M.getFancyBackground()
      config.window_background_opacity = 1
      wezterm.GLOBAL.fancy_background = false
   else
      config.background = M.getSimpleBackground()
      config.window_background_opacity = 1
      wezterm.GLOBAL.fancy_background = true
   end
end

return M
