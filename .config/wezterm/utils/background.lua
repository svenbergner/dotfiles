local M = {}

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


return M
