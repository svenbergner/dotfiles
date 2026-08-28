--[===[
avante.nvim
https://github.com/yetone/avante.nvim

Dependencies:
https://github.com/HakonHarnes/img-clip.nvim
https://github.com/MeanderingProgrammer/render-markdown.nvim
https://github.com/MunifTanjim/nui.nvim
https://github.com/nvim-lua/plenary.nvim
https://github.com/nvim-tree/nvim-web-devicons
https://github.com/nvim-treesitter/nvim-treesitter
https://github.com/zbirenbaum/copilot.lua

A Neovim plugin designed to emulate the behaviour of the Cursor AI IDE.
It provides users with AI-driven code suggestions and the ability to apply
these recommendations directly to their source files with minimal effort.
--]===]

local response_api_models = {
   ['gpt-5.6-luna'] = true,
   ['gpt-5.6-terra'] = true,
   ['gpt-5.6-sol'] = true,
}

local function copilot_uses_response_api(provider)
   local model = provider and provider.model
   return type(model) == 'string'
      and (response_api_models[model] == true or model:match('gpt%-%d+%.?%d*%-codex') ~= nil)
end

return {
   'yetone/avante.nvim',
   enabled = true,
   event = 'VeryLazy',
   keys = { '<leader>a', mode = { 'n', 'v' }, desc = 'Avante' },
   version = false, -- Never set this value to "*"! Never!
   opts = {
      provider = 'copilot',
      providers = {
         copilot = {
            -- model = 'claude-sonnet-5',
            -- model = 'gpt-5.3-codex',
            -- model = 'gpt-5.6-luna', -- (Lightweight): 80 % cheaper
            -- model = 'gpt-5.6-terra',   -- (Standard): cheaper
            model = 'gpt-5.6-sol',  -- (High-End): same price as before, but more powerful
            use_response_api = copilot_uses_response_api,
            extra_request_body = {
               -- You can add extra request body parameters here.
               -- For example, you can add the `temperature` parameter to control the randomness of the response.
               temperature = 0,
               max_tokens = 8192,
            },
         },
      },
      auto_suggestions_provider = 'copilot',
      behaviour = {
         auto_suggestions = false, -- Experimental stage
         auto_set_highlight_group = true,
         auto_set_keymaps = true,
         auto_apply_diff_after_generation = false,
         auto_approve_tool_permissions = {
            'git_diff',
            'glob',
            'read_file',
            'read_file_toplevel_symbols',
            'search_keyword',
         },
         support_paste_from_clipboard = true,
      },
      mappings = {
         --- @class AvanteConflictMappings
         diff = {
            ours = 'co',
            theirs = 'ct',
            all_theirs = 'ca',
            both = 'cb',
            cursor = 'cc',
            next = ']x',
            prev = '[x',
         },
         suggestion = {
            accept = '<M-Tab>',
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
         },
         jump = {
            next = ']]',
            prev = '[[',
         },
         submit = {
            normal = '<CR>',
            insert = '<C-s>',
         },
      },
      selector = {
         provider = 'snacks',
         provider_opts = {},
      },
      windows = {
         ---@type "right" | "left" | "top" | "bottom"
         position = 'right', -- the position of the sidebar
         wrap = true, -- similar to vim.o.wrap
         width = 30, -- default % based on available width
         sidebar_header = {
            align = 'center', -- left, center, right for title
            rounded = true,
         },
         edit = {
            border = 'rounded',
            start_insert = true,
         },
         ask = {
            floating = false,
            border = 'rounded',
            start_insert = true,
         },
      },
      highlights = {
         ---@class AvanteConflictHighlights
         diff = {
            current = 'DiffText',
            incoming = 'DiffAdd',
         },
      },
      --- @class AvanteConflictUserConfig
      diff = {
         autojump = true,
         ---@type string | fun(): any
         list_opener = 'copen',
      },
   },
   config = function(_, opts)
      require('avante').setup(opts)
      -- Re-apply border highlights after Avante's auto_set_highlight_group
      -- to ensure they are not overridden by Avante's defaults.
      local function set_border_highlights()
         vim.api.nvim_set_hl(0, 'AvantePromptInputBorder', { link = 'FloatBorder' })
         vim.api.nvim_set_hl(0, 'AvanteSidebarWinSeparator', { link = 'WinSeparator' })
      end
      set_border_highlights()
      local highlight_group = vim.api.nvim_create_augroup('AvanteHighlights', { clear = true })
      vim.api.nvim_create_autocmd('ColorScheme', {
         group = highlight_group,
         pattern = '*',
         callback = set_border_highlights,
      })
   end,
   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
   build = 'make',
   -- To force a rebuild from source, you can use the following command:
   -- build = 'make clean && make',
   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
   dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-tree/nvim-web-devicons', -- or nvim-mini/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
         -- support for image pasting
         'HakonHarnes/img-clip.nvim',
         event = 'VeryLazy',
         opts = {
            -- recommended settings
            default = {
               embed_image_as_base64 = false,
               prompt_for_file_name = false,
               drag_and_drop = {
                  insert_mode = true,
               },
               -- required for Windows users
               use_absolute_path = true,
            },
         },
      },
      {
         -- Make sure to set this up properly if you have lazy=true
         'MeanderingProgrammer/render-markdown.nvim',
         opts = {
            file_types = { 'markdown', 'Avante' },
         },
         ft = { 'markdown', 'Avante' },
      },
   },
}
