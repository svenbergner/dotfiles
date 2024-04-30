local M = {}

M.setup_layout = function(wezterm)
  local mux = wezterm.mux
  local act = wezterm.action

  wezterm.on('gui-startup', function()
    local home_dir = wezterm.home_dir
    local first_tab, _, window = mux.spawn_window {
      workspace = 'Personal',
      cwd = home_dir .. '/Repos/dotfiles/.config/',
      -- args = { os.getenv('SHELL'), '-c', 'nvim ' .. wezterm.shell_quote_arg( home_dir .. '/Repos/dotfiles/.config/'  )},
    }
    first_tab:set_title('Dotfiles')

    local second_tab, _, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/vimwiki',
      -- args = { '/usr/local/bin/nvim', home_dir .. '/Repos/vimwiki' },
    }
    second_tab:set_title('VimWiki')

    act.ActivateTab(0)
  end)
end

return M
