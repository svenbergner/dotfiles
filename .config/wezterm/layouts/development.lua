local M = {}

M.addTab = function(window, cwd, title, text_to_send)
  local tab, pane, _ = window:spawn_tab {
    cwd = cwd,
  }
  tab:set_title(title)
  if #text_to_send > 0 then
    pane:send_text(text_to_send)
  end
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

    local activatedTab = M.addTab(window, home_dir .. '/Repos/SSE/Dev', 'SSE/TaxCoreApi', 'nvim\n')
    M.addTab(window, home_dir .. '/Repos/Content/StP/30', 'Content StP', 'nvim\n')
    M.addTab(window, home_dir .. '/Repos/SSE/Tools', 'Tools', 'nvim\n')
    M.addTab(window, home_dir .. '/Repos/DevTools', 'DevTools', 'nvim\n')
    M.addTab(window, home_dir .. '/Repos/SetupSSE', 'SetupSSE', 'nvim\n')

    activatedTab:activate()
    window:gui_window():maximize()

  end)
end

return M
