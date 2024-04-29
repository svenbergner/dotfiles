local M = {}

M.add_to_config = function(config, wezterm, act)
  config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }
  config.keys = {
    -- Send C-s when pressing C-s twice
    { key = "s",          mods = "LEADER|CTRL", action = act.SendKey { key = "s", mods = "CTRL" } },
    -- Send C-l when pressing C-s C-l
    { key = "l",          mods = "LEADER|CTRL", action = act.SendKey { key = "l", mods = "CTRL" } },
    -- Send C-k when pressing C-s C-k
    { key = "k",          mods = "LEADER|CTRL", action = act.SendKey { key = "k", mods = "CTRL" } },
    -- TODO: How does CopyMode work??
    { key = "c",          mods = "LEADER",      action = act.ActivateCopyMode },
    -- Shows all available commands in a popup menu
    { key = "phys:Space", mods = "LEADER",      action = act.ActivateCommandPalette },

    -- Pane keybindings
    { key = "s",          mods = "LEADER",      action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "v",          mods = "LEADER",      action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "q",          mods = "LEADER",      action = act.CloseCurrentPane { confirm = true } },
    { key = "z",          mods = "LEADER",      action = act.TogglePaneZoomState },
    { key = "o",          mods = "LEADER",      action = act.RotatePanes "Clockwise" },
    { key = "O",          mods = "LEADER",      action = act.RotatePanes "CounterClockwise" },
    {
      key = "b",
      mods = "LEADER",
      action = wezterm.action_callback(
        function()
          require('utils.background').toggleBackground(config)
          wezterm.reload_configuration()
        end)
    },
    -- We can make separate keybindings for resizing panes
    -- But Wezterm offers custom "mode" in the name of "KeyTable"
    { key = "r",          mods = "LEADER", action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

    -- Tab keybindings
    { key = "t",          mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "LeftArrow",  mods = "CMD",    action = act.ActivateTabRelative(-1) },
    { key = "RightArrow", mods = "CMD",    action = act.ActivateTabRelative(1) },
    { key = "n",          mods = "LEADER", action = act.ShowTabNavigator },
    {
      key = "e",
      mods = "LEADER",
      action = act.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = "Bold" } },
          { Text = "Renaming Tab Title...:" },
        },
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end)
      }
    },
    -- Key table for moving tabs around
    { key = "m", mods = "LEADER",       action = act.ActivateKeyTable { name = "move_tab", one_shot = false } },
    -- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
    { key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
    { key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

    -- Lastly, workspace
    { key = "w", mods = "LEADER",       action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },
    { key = 'n', mods = 'CTRL',         action = act.SwitchWorkspaceRelative(1) },
    { key = 'p', mods = 'CTRL',         action = act.SwitchWorkspaceRelative(-1) },
  }
  -- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = "LEADER",
      action = act.ActivateTab(i - 1)
    })
  end

  config.key_tables = {
    resize_pane = {
      { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
      { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
      { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
      { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter",  action = "PopKeyTable" },
    },
    move_tab = {
      { key = "h",      action = act.MoveTabRelative(-1) },
      { key = "j",      action = act.MoveTabRelative(-1) },
      { key = "k",      action = act.MoveTabRelative(1) },
      { key = "l",      action = act.MoveTabRelative(1) },
      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter",  action = "PopKeyTable" },
    }
  }
end

return M
