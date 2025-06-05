--[===[
avante.nvim is a Neovim plugin designed to emulate the behaviour of the
Cursor AI IDE. It provides users with AI-driven code suggestions and the
ability to apply these recommendations directly to their source files
with minimal effort.
URL: https://github.com/yetone/avante.nvim
--]===]

return {
   "yetone/avante.nvim",
   enabled = true,
   event = "VeryLazy",
   version = false, -- Never set this value to "*"! Never!
   opts = {
      provider = "copilot",
      providers = {
         -- You can use multiple providers, but only one will be used at a time.
         -- The first provider that is available will be used.
         -- If you want to use multiple providers, you can set the `provider` option to a function that returns the provider name.
         -- The function will be called with the current buffer and the current file type.
         -- The function should return the provider name as a string.
         copilot = {
            model = 'claude-3.7-sonnet',
            extra_request_body = {
               -- You can add extra request body parameters here.
               -- For example, you can add the `temperature` parameter to control the randomness of the response.
               temperature = 0,
               max_tokens = 8192,
            },
         },
      },
      auto_suggestions_provider = "copilot",
      behaviour = {
         auto_suggestions = false, -- Experimental stage
         auto_set_highlight_group = true,
         auto_set_keymaps = true,
         auto_apply_diff_after_generation = false,
         support_paste_from_clipboard = true,
         enable_cursor_planning_mode = true,
      },
      mappings = {
         --- @class AvanteConflictMappings
         diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
         },
         suggestion = {
            accept = "<M-Tab>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
         },
         jump = {
            next = "]]",
            prev = "[[",
         },
         submit = {
            normal = "<CR>",
            insert = "<C-s>",
         },
      },
      hints = { enabled = true },
      file_selector = {
         provider = "snacks",
         provider_opts = {},
      },
      windows = {
         ---@type "right" | "left" | "top" | "bottom"
         position = "right",  -- the position of the sidebar
         wrap = true,         -- similar to vim.o.wrap
         width = 30,          -- default % based on available width
         sidebar_header = {
            align = "center", -- left, center, right for title
            rounded = true,
         },
         edit = {
            border = "rounded",
            start_insert = true,
         },
         ask = {
            floating = false,
            border = "rounded",
            start_insert = true,
         }
      },
      highlights = {
         ---@class AvanteConflictHighlights
         diff = {
            current = "DiffText",
            incoming = "DiffAdd",
            modified = "DiffChange", -- Neue Option
            deleted = "DiffDelete",  -- Neue Option
         },
      },
      --- @class AvanteConflictUserConfig
      diff = {
         autojump = true,
         ---@type string | fun(): any
         list_opener = "copen",
      },
   },
   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
   build = "make",
   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
   dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'
      {
         -- support for image pasting
         "HakonHarnes/img-clip.nvim",
         event = "VeryLazy",
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
            file_types = { "markdown", "Avante" },
         },
         ft = { "markdown", "Avante" },
      },
   },
}
