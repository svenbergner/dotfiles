local M = {}

M.setup_layout = function(wezterm)
  local mux = wezterm.mux
  local act = wezterm.action

  wezterm.on('gui-startup', function()
    local home_dir = wezterm.home_dir

    local first_tab, first_pane, window = mux.spawn_window {
      workspace = 'Development',
      cwd = home_dir .. '/Repos/simply_tax_app',
    }
    first_tab:set_title('SimplyTaxApp')
    first_pane:send_text('nvim .\n')

    local second_tab, second_pane, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/SSE/Dev',
    }
    second_tab:set_title('SSE/TaxCoreApi')
    second_pane:send_text('nvim .\n')

    local third_tab, third_pane, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/webhook-builds',
    }
    third_tab:set_title('Build-Pipelines')
    third_pane:send_text('nvim .\n')

    window:gui_window():maximize()
    act.ActivateTab(0)

    -- local editor_pane = build_pane:split {
    --   direction = 'Top',
    --   size = 0.6,
    --   cwd = project_dir,
    -- }
  end)
end

return M
