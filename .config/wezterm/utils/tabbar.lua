local M = {}

M.apply_to_config = function(config, wezterm)
  config.use_fancy_tab_bar = false
  config.tab_max_width = 20
  config.status_update_interval = 1000
  config.tab_bar_at_bottom = false
  config.tab_and_split_indices_are_zero_based = false

  wezterm.on("update-status", function(window, pane)
    -- Workspace name
    local stat = window:active_workspace()
    local stat_color_bg = "#3c3836"
    -- local stat_color_fg = "#3c3836"
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
      if window:get_dimensions().pixel_width < 1500 then
        cwd = basename(cwd.file_path)
      else
        cwd = cwd.file_path
      end
    else
      cwd = ""
    end

    -- Current command
    local cmd = pane:get_foreground_process_name()
    -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
    cmd = cmd and basename(cmd) or ""

    -- Time
    local time = wezterm.strftime("%d.%m.%y %H:%M")

    local gitstatus = require('utils.gitstatus').get_gitstatus(pane:get_current_working_dir().file_path)

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
end

return M
