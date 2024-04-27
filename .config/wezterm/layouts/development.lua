local M = {}

M.setup_layout = function(wezterm)
  local mux = wezterm.mux
  local act = wezterm.action
  wezterm.on('gui-startup', function(cmd)
    local args = {}
    if cmd then
      args = cmd.args
    end

    local home_dir = wezterm.home_dir
    local first_tab, _, window = mux.spawn_window {
      workspace = 'Development',
      cwd = home_dir .. '/Repos/simply_tax_app',
      args = { '/usr/local/bin/nvim', '.' },
    }
    first_tab:set_title('SimplyTaxApp')

    local second_tab, _, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/SSE/Dev',
      args = { '/usr/local/bin/nvim', '.' },
    }
    second_tab:set_title('SSE/TaxCoreApi')

    local third_tab, _, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/webhook-builds',
      args = { '/usr/local/bin/nvim', '.' },
    }
    third_tab:set_title('Build-Pipelines')

    act.ActivateTab(1)

    -- local editor_pane = build_pane:split {
    --   direction = 'Top',
    --   size = 0.6,
    --   cwd = project_dir,
    -- }
  end)
end

return M
