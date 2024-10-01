local M = {}

M.setup_layout = function(wezterm)
  local mux = wezterm.mux

  wezterm.on('gui-startup', function()
    local home_dir = wezterm.home_dir
    if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
      home_dir = '/C'
    end

    local first_tab, _, window = mux.spawn_window {
      workspace = 'Development',
      cwd = home_dir .. '/Repos/simply_tax_app',
    }
    first_tab:set_title('SimplyTaxApp')

    local second_tab, _, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/SSE/Dev',
    }
    second_tab:set_title('SSE/TaxCoreApi')

    local third_tab, _, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/webhook-builds',
    }
    third_tab:set_title('Build-Pipelines')


    local fourth_tab, _, _ = window:spawn_tab {
      cwd = home_dir .. '/Repos/Content/StP/30/DMSource',
    }
    fourth_tab:set_title('Content StP')

    first_tab:activate()
    window:gui_window():maximize()

    -- local editor_pane = build_pane:split {
    --   direction = 'Top',
    --   size = 0.6,
    --   cwd = project_dir,
    -- }
  end)
end

return M
