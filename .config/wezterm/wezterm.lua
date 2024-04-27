--- wezterm.lua
--- $ figlet -f small Wezterm
--- __      __      _
--- \ \    / /__ __| |_ ___ _ _ _ __
---  \ \/\/ / -_)_ /  _/ -_) '_| '  \
---   \_/\_/\___/__|\__\___|_| |_|_|_|
---
--- My Wezterm config file

local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
local act = wezterm.action

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then config = wezterm.config_builder() end

-- Setup default layout
require("layouts.personal").setup_layout(wezterm)
require("layouts.development").setup_layout(wezterm)

-- Settings
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}

config.colors = {
  visual_bell = '#202020'
}

-- config.background = require('utils/background').getBackground()
-- config.window_background_opacity = 0.5
config.window_background_opacity = 0.95
config.color_scheme = "Gruvbox Dark (Gogh)"
config.font = wezterm.font_with_fallback({
  { family = "JetBrainsMono Nerd Font Mono", scale = 1.2, weight = "Medium", },
})
-- config.text_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 10000
config.default_workspace = "Development"

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5
}

config.window_frame = {
  border_top_color = '#3c3836',
  border_top_height = '0.25cell',
  border_left_width = '0.5cell',
  border_right_width = '0.5cell',
}

-- Keys
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
  -- We can make separate keybindings for resizing panes
  -- But Wezterm offers custom "mode" in the name of "KeyTable"
  { key = "r",          mods = "LEADER",      action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

  -- Tab keybindings
  { key = "t",          mods = "LEADER",      action = act.SpawnTab("CurrentPaneDomain") },
  { key = "LeftArrow",  mods = "CMD",         action = act.ActivateTabRelative(-1) },
  { key = "RightArrow", mods = "CMD",         action = act.ActivateTabRelative(1) },
  { key = "n",          mods = "LEADER",      action = act.ShowTabNavigator },
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

-- Tab Format
require('utils/tabs_format')

-- Tab bar
-- I don't like the look of "fancy" tab bar
config.use_fancy_tab_bar = false
config.tab_max_width = 20
config.status_update_interval = 1000
config.tab_bar_at_bottom = false
config.tab_and_split_indices_are_zero_based = false
wezterm.on("update-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  local stat_color_bg = "#3c3836"
  local stat_color_fg = "#3c3836"
  local stat_icon = wezterm.nerdfonts.oct_table
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color_bg = "#fabd2f"
    stat_icon = wezterm.nerdfonts.fa_keyboard_o
  end
  if window:leader_is_active() then
    stat = "LEAD"
    stat_color_bg = "#83a598"
    stat_icon = wezterm.nerdfonts.md_football
  end

  local basename = function(s)
    -- Nothing a little regex can't fix
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end

  -- Current working directory
  local cwd = pane:get_current_working_dir()
  if cwd then
    cwd = basename(cwd.file_path)
    -- cwd = cwd.file_path
  else
    cwd = ""
  end

  -- Current command
  local cmd = pane:get_foreground_process_name()
  -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
  cmd = cmd and basename(cmd) or ""

  -- Time
  local time = wezterm.strftime("%d.%m.%y %H:%M")

  local gitstatus = require('utils/gitstatus').get_gitstatus(pane:get_current_working_dir().file_path)

  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format({}))

  -- Right status
  window:set_right_status(gitstatus .. wezterm.format({
    -- Wezterm has a built-in nerd fonts
    -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
    { Foreground = { Color = '#d65d0e' }, },
    { Text = "" },
    { Background = { Color = '#d65d0e' }, },
    { Foreground = { AnsiColor = 'Black' }, },
    { Text = wezterm.nerdfonts.md_folder .. " " },
    "ResetAttributes",
    { Text = " " .. cwd },
    "ResetAttributes",
    { Text = " " },
    { Foreground = { Color = "#e0af68" } },
    { Text = "" },
    { Background = { Color = "#e0af68" } },
    { Foreground = { AnsiColor = 'Black' }, },
    { Text = wezterm.nerdfonts.fa_code .. " " },
    "ResetAttributes",
    { Text = " " .. cmd },
    "ResetAttributes",
    { Text = " " },
    { Foreground = { Color = '#83a598' }, },
    { Text = "" },
    { Background = { Color = '#83a598' }, },
    { Foreground = { AnsiColor = 'Black' }, },
    { Text = wezterm.nerdfonts.md_calendar_clock .. " " },
    "ResetAttributes",
    { Text = " " .. time },
    { Text = " " },
    { Foreground = { Color = '#b8bb26' }, },
    { Background = { AnsiColor = 'Black' }, },
    { Text = "" },
    { Background = { Color = '#b8bb26' }, },
    { Foreground = { AnsiColor = 'Black' }, },
    { Text = stat_icon .. " " },
    "ResetAttributes",
    { Background = { Color = stat_color_bg }, },
    { Text = " " .. stat .. " " },
  }))
end)


--[[ Appearance setting for when I need to take pretty screenshots
config.enable_tab_bar = false
config.window_padding = {
  left = '0.5cell',
  right = '0.5cell',
  top = '0.5cell',
  bottom = '0cell',
}
--]]

smart_splits.apply_to_config(config, {
  -- the default config is here, if you'd like to use the default keys,
  -- you can omit this configuration table parameter and just use
  -- smart_splits.apply_to_config(config)

  -- directional keys to use in order of: left, down, up, right
  direction_keys = { 'h', 'j', 'k', 'l' },
  -- modifier keys to combine with direction_keys
  modifiers = {
    move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
    resize = 'META', -- modifier to use for pane resize, e.g. META+h to resize to the left
  },
})

return config
