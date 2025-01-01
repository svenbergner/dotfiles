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
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Additional reload path
wezterm.add_to_config_reload_watch_list('layouts')
wezterm.add_to_config_reload_watch_list('utils')

-- Setup default layout
require("layouts.personal").setup_layout(wezterm)
require("layouts.development").setup_layout(wezterm)

require('utils.background').toggleBackground(config)

-- Settings
config.max_fps = 120
config.enable_kitty_graphics = true
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

config.color_scheme = "Gruvbox Dark (Gogh)"
config.font = wezterm.font_with_fallback({
  { family = "JetBrainsMono Nerd Font Mono", scale = 1.2, weight = "Medium", },
})
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
require('keymappings').add_to_config(config, wezterm, act)

-- Tab Format
require('utils/tabs_format')

-- Tab bar
require('utils.tabbar').apply_to_config(config, wezterm)

-- Appearance setting for when I need to take pretty screenshots
-- require('utils.pretty_screenshots').apply_to_config(config)

-- Navigating through wezterm and neovim panes with the same keybindings
smart_splits.apply_to_config(config, require('utils.smart_splits_config'))

return config
