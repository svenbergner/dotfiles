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

local getFormattedElement = function(fg, bg, attr, text)
  if attr then
    return wezterm.format({
      getForegroundColorElement(fg),
      getBackgroundColorElement(bg),
      { Attribute = { Intensity = "Bold" } },
      { Text = text },
    })
  else
    return wezterm.format({
      getForegroundColorElement(fg),
      getBackgroundColorElement(bg),
      { Attribute = { Intensity = "Normal" } },
      { Text = text },
    })
  end
end

local splitGitmuxString = function(gitmux)
  local gitmux_len = #gitmux
  local gitmuxElements = {}
  local startOfElement = 1
  local endOfElement = 2
  while startOfElement < gitmux_len do
    endOfElement = gitmux:find('#', startOfElement + 1)
    if endOfElement == nil then
      endOfElement = #gitmux
    else
      endOfElement = endOfElement - 1
    end

    local gitmuxElement = gitmux:sub(startOfElement, endOfElement)
    table.insert(gitmuxElements, gitmuxElement)
    startOfElement = endOfElement + 1
  end

  return gitmuxElements
end

local parseElement = function(element)
  local fg = element:match("fg=(%w+)")
  local bg = element:match("bg=(%w+)")
  local attr = string.find(element, "bold", 1, true)
  local text = element:gsub("#%[.*%]", "")

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

    local gitstatus = getFormattedElement('#fb4934', '#000', false, '') ..
        getFormattedElement('#000', '#fb4934', false, wezterm.nerdfonts.custom_folder_git .. ' ')

    for _, element in ipairs(gitmuxElements) do
      local fg, bg, attr, text = parseElement(element)
      gitstatus = gitstatus .. getFormattedElement(fg, bg, attr, text)
    end
    return gitstatus .. " "
  else
    return stderr
  end
end

return M

