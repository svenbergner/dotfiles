local M = {}

M.setup_layout = function(wezterm)
  local mux = wezterm.mux

  wezterm.on('gui-startup', function()
    local home_dir = wezterm.home_dir
    if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
      home_dir = '/C'
    end
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

    local third_tab, third_pane, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/telescope-cmake-preset-selector',
    }
    third_tab:set_title('CMake Preset Selector')
    third_pane:send_text('nvim .\n')

    local fourth_tab, fourth_pane, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/telescope-debugee-selector',
    }
    fourth_tab:set_title('Debugee Selector')
    fourth_pane:send_text('nvim .\n')

    first_tab:activate()
  end)
end

return M
