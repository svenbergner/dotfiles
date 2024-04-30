local M = {}

M.setup_layout = function(wezterm)
  local mux = wezterm.mux
  local act = wezterm.action

  wezterm.on('gui-startup', function()
    local home_dir = wezterm.home_dir
    local first_tab, first_pane, window = mux.spawn_window {
      workspace = 'Personal',
      cwd = home_dir .. '/Repos/dotfiles/.config/',
    }
    first_tab:set_title('Dotfiles')
    first_pane:send_text('nvim .\n')

    local second_tab, second_pane, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/vimwiki',
    }
    second_tab:set_title('VimWiki')
    second_pane:send_text('nvim .\n')

    act.ActivateTab(0)
  end)
end

return M
