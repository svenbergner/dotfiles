local M = {}
Fancy_background = false

M.getBackground = function()
  return {
    {
      source = {
        File = "/Users/svenbergner/.config/wezterm/background/Matrix-Wallpaper.gif"
      },
      width = '100%',
      hsb = { brightness = .3 },
    }
  }
end

M.toggleBackground = function(config)
  if not Fancy_background then
    config.background = M.getBackground()
    config.window_background_opacity = 0.5
  else
    config.background = {}
    config.window_background_opacity = 0.95
  end
    Fancy_background = not Fancy_background
end

return M
