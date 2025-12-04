local M = {}

M.addTab = function(window, cwd, title, command)
   local tab, pane, _ = window:spawn_tab {
      cwd = cwd,
   }
   tab:set_title(title)
   if #command > 0 then
      pane:send_text(command)
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

      local first_tab, first_pane, window = mux.spawn_window {
         workspace = 'Development',
         cwd = home_dir .. '/Repos/DevTools',
      }
      first_tab:set_title('DevTools')
      first_pane:send_text('nvim\n')

      local activatedTab = M.addTab(window, home_dir .. '/Repos/SSE/Dev', 'SSE/TaxCoreApi', 'nvim\n')
      M.addTab(window, home_dir .. '/Repos/SSE28', 'SSE 28', 'nvim\n')
      M.addTab(window, home_dir .. '/Repos/SSE27', 'SSE 27', 'nvim\n')
      M.addTab(window, home_dir .. '/Repos/Content/StP/31', 'Content StP 31', 'nvim\n')
      M.addTab(window, home_dir .. '/Repos/SSE/Tools', 'Tools', 'nvim\n')
      -- M.addTab(window, home_dir .. '/Repos/SetupSSE', 'SetupSSE', 'nvim\n')
      -- M.addTab(window, home_dir .. '/Repos/BuildAgentIAC', 'BuildAgentIAC', 'nvim\n')

      activatedTab:activate()
      window:gui_window():maximize()
   end)
end

return M
