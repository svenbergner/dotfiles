local M = {}
local wezterm = require("wezterm")

M.getFancyBackground = function()
  local home_dir = wezterm.home_dir
  return {
    {
      source = {
        File = home_dir .. "/.config/wezterm/background/Matrix-Wallpaper.gif"
      },
      width = '100%',
      hsb = { brightness = .3 },
    }
  }
end

M.getEmptyBackground = function()
  return {}
end

M.toggleBackground = function(config)
  if wezterm.GLOBAL.fancy_background then
    config.background = M.getFancyBackground()
    config.window_background_opacity = 1
    wezterm.GLOBAL.fancy_background = false
  else
    config.background = M.getEmptyBackground()
    config.window_background_opacity = 1
    wezterm.GLOBAL.fancy_background = true
  end
end

return M
