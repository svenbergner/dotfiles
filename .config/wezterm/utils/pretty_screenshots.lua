local M = {}

M.apply_to_config = function(config)
   config.enable_tab_bar = false
   config.window_padding = {
      left = '0.5cell',
      right = '0.5cell',
      top = '0.5cell',
      bottom = '0cell',
   }
end

return M
