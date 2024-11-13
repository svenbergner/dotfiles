local M = {}

M.addTab = function(window, cwd, title, command)
  local tab, pane, _ = window:spawn_tab {
    cwd = cwd,
  }
  tab:set_title(title)
  pane:send_text(command)
  return tab
end

M.setup_layout = function(wezterm)
  local mux = wezterm.mux

  wezterm.on('gui-startup', function()
    local home_dir = wezterm.home_dir
    if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
      home_dir = '/C'
    end

    local first_tab, _, window = mux.spawn_window {
      workspace = 'Development',
      cwd = home_dir .. '/Repos/simply_tax_app',
    }
    first_tab:set_title('SimplyTaxApp')

    local activateTab = M.addTab(window, home_dir .. '/Repos/SSE/Dev', 'SSE/TaxCoreApi', 'nvim .\n')
    M.addTab(window, home_dir .. '/Repos/webhook-builds', 'Build-Pipelines', 'nvim .\n')
    M.addTab(window, home_dir .. '/Repos/Content/StP/30/DMSource', 'Content StP', 'nvim .\n')

    activateTab:activate()
    window:gui_window():maximize()

  end)
end

return M
