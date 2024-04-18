local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}

wezterm.on('gui-startup', function(cmd)
  local args = {}
  if cmd then
    args = cmd.args
  end

  local home_dir = wezterm.home_dir
  local tab, pane, window = mux.spawn_window {
    workspace = 'Development',
    cwd = home_dir,
    args = args,
  }
  local first_tab, _, _ = window:mux_window():spawn_tab {
    cwd = home_dir .. '/Repos/dotfiles/.config/nvim/',
  }
  first_tab:set_title('Dotfiles')

  local second_tab, _, _ = window:mux_window():spawn_tab {
    cwd = home_dir .. '/Repos/simply_tax_app',
  }
  second_tab:set_title('SimplyTaxApp')

  local third_tab, _, _ = window:mux_window():spawn_tab {
    cwd = home_dir .. '/Repos/SSE/Dev',
  }
  third_tab:set_title( 'SSE/TaxCoreApi' )

  local fourth_tab, _, _ = window:mux_window():spawn_tab {
    cwd = home_dir .. '/Repos/webhook-builds',
  }
  fourth_tab:set_title( 'Build-Pipelines' )

  local fifth_tab, _, _ = window:mux_window():spawn_tab {
    cwd = home_dir .. '/Repos/vimwiki',
  }
  fifth_tab:set_title( 'VimWiki' )

  local sixth_tab, _, _ = window:mux_window():spawn_tab {
    cwd = home_dir,
  }
  sixth_tab:set_title( 'Shell' )

  -- local editor_pane = build_pane:split {
  --   direction = 'Top',
  --   size = 0.6,
  --   cwd = project_dir,
  -- }
end)

return config

