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
  while endOfElement ~= nil do
    endOfElement = remainingGitmux:find('#', endOfElement+1)
    if( endOfElement == nil ) then break end

    local gitmuxElement = remainingGitmux:sub(1,endOfElement-1)
    remainingGitmux = remainingGitmux:gsub(gitmuxElement, '')
    table.insert(gitmuxElements, gitmuxElement)
  end
  return gitmuxElements
end

local parseElement = function (element)
  local fg = "#FF00BB"
  local bg = "#000"
  local attr = "attr"-- element.gmatch("bold")
  local text = "text"

  return fg, bg, attr, text
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

    for _, element in ipairs(gitmuxElements) do
      local fg, bg, attr, text = parseElement(element)
      -- gitstatus = gitstatus .. fg .. bg .. attr .. text
      gitstatus = gitstatus .. getFormattedElement(fg, bg, text)
    end
    -- -- local gitmuxElement = gitmux:match('#%[.*%][^#]*')
    -- -- gitstatus = gitstatus .. getFormattedElement('', '', gitmuxElement)
    -- -- gitstatus = gitstatus .. getFormattedElement('', '', gitmuxElements)
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
