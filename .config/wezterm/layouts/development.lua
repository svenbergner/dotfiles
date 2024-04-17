local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local args = {}
  if cmd then
    args = cmd.args
  end

  local home_dir = wezterm.home_dir
  local _, _, window = mux.spawn_window {
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


  -- _, third_pane, _ = window:spawn_tab {
  --   workspace = 'SimplyTaxApp',
  --   cwd = home_dir .. '/Repos/simply_tax_app',
  --   args = args,
  -- }
  -- tab, build_pane, window = mux.spawn_window {
  --   workspace = 'SSE/TaxCoreApi',
  --   cwd = home_dir .. '/Repos/SSE/Dev',
  --   args = args,
  -- }
  --
  -- local editor_pane = build_pane:split {
  --   direction = 'Top',
  --   size = 0.6,
  --   cwd = project_dir,
  -- }
end)

