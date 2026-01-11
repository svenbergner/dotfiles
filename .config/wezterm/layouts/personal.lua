local M = {}

M.addTab = function(window, cwd, title, command)
   local tab, pane, _ = window:spawn_tab {
      cwd = cwd,
   }
   tab:set_title(title)
   if #command > 0 then
      pane:send_text(command)
   end
end

M.setup_layout = function(wezterm)
   local mux = wezterm.mux

   wezterm.on('gui-startup', function()
      local home_dir = wezterm.home_dir
      if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
         home_dir = '/C'
      end
      local first_tab, first_pane, window = mux.spawn_window {
         workspace = 'Personal',
         cwd = home_dir .. '/Repos/dotfiles/',
      }
      first_tab:set_title('Dotfiles')
      first_pane:send_text('')

      M.addTab(window, home_dir .. '/Repos/vimwiki', 'VimWiki', '')
      M.addTab(window, home_dir .. '/Repos/telescope-cmake-preset-selector', 'CMake Preset Selector', '')
      M.addTab(window, home_dir .. '/Repos/telescope-debugee-selector', 'Debugee Selector', '')
      M.addTab(window, home_dir .. '/Repos/presenter.nvim', 'Presenter', '')
      -- M.addTab(window, home_dir .. '/Repos/snacks.nvim', 'Snacks', '')

      first_tab:activate()
   end)
end

return M
