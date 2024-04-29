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
  if config.window_background_opacity == 0.95 then
    config.background = M.getFancyBackground()
    config.window_background_opacity = 0.5
  else
    config.background = M.getEmptyBackground()
    config.window_background_opacity = 0.95
  end
end

return M
