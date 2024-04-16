local wezterm = require("wezterm")

local M = {}

local getForegroundColorElement = function(color)
  if color == nil or color == '' then
    return { Text = '' }
  else
    return { Foreground = { Color = color } }
  end
end

local getBackgroundColorElement = function(color)
  if color == nil or color == '' then
    return { Text = '' }
  else
    return { Background = { Color = color } }
  end
end

local getFormattedElement = function(fg, bg, text)
  return wezterm.format({
    getForegroundColorElement(fg),
    getBackgroundColorElement(bg),
    { Text = text },
  })
end

local splitGitmuxString = function(gitmux)
  local remainingGitmux = gitmux
  local gitmuxElements = {}
  local endOfElement = 1
  while not endOfElement == nil do
    local endOfElement = remainingGitmux:find('#', endOfElement)
    if( endOfElement == nil ) then break end

    local gitmuxElement = remainingGitmux:sub(1,endOfElement)
    remainingGitmux = remainingGitmux:gsub(gitmuxElement, '')
    table:insert(gitmuxElements, gitmuxElement)
  end
  return gitmuxElements
end

M.get_gitstatus = function(cwd)
  local success, stdout, stderr = wezterm.run_child_process { '/usr/local/bin/gitmux', '-cfg', '/Users/svenbergner/.gitmux.conf', cwd }
  if success then
    if stdout == nil or stdout == '' then
      return ''
    end
    local gitmux = stdout
    gitmux = gitmux:gsub('#%[none%]', '')
    local gitmuxElements = splitGitmuxString(gitmux)

    local gitstatus = getFormattedElement('#fb4934', '#000', '') ..
                      getFormattedElement('#000', '#fb4934', wezterm.nerdfonts.custom_folder_git .. ' ')
    gitstatus = gitstatus .. getFormattedElement('', '', 'E-S:')
    -- gitstatus = gitstatus .. getFormattedElement('#fff', '', gitmux)
    -- local gitmuxElement = gitmux:match('#%[.*%][^#]*')
    -- gitstatus = gitstatus .. getFormattedElement('', '', gitmuxElement)
    -- gitstatus = gitstatus .. getFormattedElement('', '', gitmuxElements)
    gitstatus = gitstatus .. getFormattedElement('', '', ' E-E')
    gitstatus = gitstatus .. getFormattedElement('', '', ' ')
    return gitstatus
  else
    return stderr
  end
end

return M
-- #[fg=blue,bold,bg=default]string
--
-- local gitstatus = wezterm.format({
--  { Foreground = { Color = '#fb4934' }, },
--   { Text = "" },
--   { Background = { Color = '#fb4934' }, },
--   { Foreground = { AnsiColor = 'Black' }, },
--   { Text = wezterm.nerdfonts.custom_folder_git .. " " },
--   "ResetAttributes",
--   { Text = " " .. gitmux },
--   "ResetAttributes",
--   { Text = " " },
-- })
