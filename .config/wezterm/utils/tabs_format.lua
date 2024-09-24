local wezterm = require( 'wezterm' )

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = ""

-- The filled in variant of the > symbol
-- local SOLID_RIGHT_ARROW = ""

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on('format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#3c3836'
    local background = '#1b1032'
    local foreground = '#808080'

    if tab.is_active then
      background = '#fe8019'
      foreground = '#1d2021'
    else
      background = '#83a598'
      foreground = '#1d2021'
    end

    local edge_foreground = "#fbf1cf"

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    local title_intensity = "Normal"
    local zoom_indicator = ""
    local p = tab.active_pane
    if p.is_zoomed then
      zoom_indicator = " " .. wezterm.nerdfonts.oct_zoom_in
    end

    local tab_index_intensity = "Normal"
    if tab.is_active then
      tab_index_intensity = "Bold"
    end
    return {
      { Background = { Color = edge_background } },
      { Text = " " },
      { Foreground = { Color = background } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Attribute = { Intensity = tab_index_intensity } },
      { Text = tab.tab_index + 1 .. zoom_indicator .. " " },
      { Attribute = { Intensity = "Normal" } },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Attribute = { Intensity = title_intensity } },
      { Text = " " .. title },
      { Attribute = { Intensity = "Normal" } },
    }
  end
)

return {}

-- scheme: "Gruvbox dark, hard"
-- base00: "#1d2021" # ----
-- base01: "#3c3836" # ---
-- base02: "#504945" # --
-- base03: "#665c54" # -
-- base04: "#bdae93" # +
-- base05: "#d5c4a1" # ++
-- base06: "#ebdbb2" # +++
-- base07: "#fbf1c7" # ++++
-- base08: "#fb4934" # red
-- base09: "#fe8019" # orange
-- base0A: "#fabd2f" # yellow
-- base0B: "#b8bb26" # green
-- base0C: "#8ec07c" # aqua/cyan
-- base0D: "#83a598" # blue
-- base0E: "#d3869b" # purple
-- base0F: "#d65d0e" # brown
