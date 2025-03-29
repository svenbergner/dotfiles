--[===[
Blink Completion
blink.cmp is a completion plugin with support for LSPs and external sources
that updates on every keystroke with minimal overhead (0.5-4ms async).
It use a custom SIMD fuzzy searcher to easily handle >20k items.
It provides extensibility via hooks into the trigger, sources and rendering
pipeline. Plenty of work has been put into making each stage of the pipeline
as intelligent as possible, such as frecency and proximity bonus on fuzzy
matching, and this work is on-going.

URL: https://github.com/saghen/blink.cmp
Docs: https://cmp.saghen.dev/

--]===]

return {
   'saghen/blink.cmp',
   enabled = true,
   event = "InsertEnter",
   -- optional: provides snippets for the snippet source
   dependencies = {
      'Kaiser-Yang/blink-cmp-avante',
      'rafamadriz/friendly-snippets',
   },

   -- use a release tag to download pre-built binaries
   version = '1.*',
   -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
   -- build = 'cargo build --release',
   -- If you use nix, you can build from source using latest nightly rust with:
   -- build = 'nix run .#build-plugin',

   ---@module 'blink.cmp'
   ---@type blink.cmp.Config
   opts = {
      enabled = function()
         -- Get the current buffer's filetype
         local filetype = vim.bo[0].filetype
         -- Disable for the following buffers
         if filetype == "TelescopePrompt" or
             filetype == "minifiles" or
             filetype == "snacks_picker_input" or
             filetype == "neo-tree" or
             filetype == "neo-tree-popup"
         then
            return false
         end
         return true
      end,
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
         preset = 'enter',
         ['<Tab>'] = { 'select_next', 'fallback' },
         ['<S-Tab>'] = { 'select_prev', 'fallback' },
      },

      appearance = {
         -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
         -- Adjusts spacing to ensure icons are aligned
         nerd_font_variant = 'mono'
      },

      -- Experimental signature help support
      signature = {
         enabled = true,
         trigger = {
            -- Show the signature help automatically
            enabled = true,
            -- Show the signature help window after typing any of alphanumerics, `-` or `_`
            show_on_keyword = false,
            blocked_trigger_characters = {},
            blocked_retrigger_characters = {},
            -- Show the signature help window after typing a trigger character
            show_on_trigger_character = true,
            -- Show the signature help window when entering insert mode
            show_on_insert = true,
            -- Show the signature help window when the cursor comes after a trigger character when entering insert mode
            show_on_insert_on_trigger_character = true,
         },
         window = {
            min_width = 1,
            max_width = 100,
            max_height = 10,
            border = nil, -- Defaults to `vim.o.winborder` on nvim 0.11+ or 'padded' when not defined/<=0.10
            winblend = 0,
            winhighlight = 'Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder',
            scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
            -- Which directions to show the window,
            -- falling back to the next direction when there's not enough space,
            -- or another window is in the way
            direction_priority = { 's', 'n' },
            -- Disable if you run into performance issues
            treesitter_highlighting = true,
            show_documentation = true,
         },
      },

      completion = {
         keyword = {
            -- 'prefix' will fuzzy match on the text before the cursor
            -- 'full' will fuzzy match on the text before *and* after the cursor
            -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
            range = "full",
         },
         list = {
            selection = {
               preselect = function(ctx)
                  return ctx.mode ~= 'cmdline' and not require('blink.cmp').snippet_active({ direction = 1 })
               end,
               auto_insert = function(ctx) return ctx.mode ~= 'cmdline' end,
            },
         },
         menu = {
            border = "rounded",
            auto_show = true,
         },
         documentation = {
            auto_show = true,
            window = {
               border = "single",
            },
         },
         -- Displays a preview of the selected item on the current line
         ghost_text = {
            enabled = true,
         },
      },
      cmdline = {
         keymap = {
            ['<Tab>'] = {
               function(cmp)
                  if cmp.is_ghost_text_visible() then return cmp.accept() end
               end,
               'show_and_insert',
               'select_next',
            },
            ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },
            ['<down>'] = { 'select_next', 'fallback' },
            ['<up>'] = { 'select_prev', 'fallback' },
         },
         completion = {
            menu = {
               auto_show = function()
                  return vim.fn.getcmdtype() == ':'
                  -- enable for inputs as well, with:
                  -- or vim.fn.getcmdtype() == '@'
               end,
            },
         }
      },
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
         default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
         providers = {
            avante = {
               module = 'blink-cmp-avante',
               name = 'Avante',
               opts = {
                  -- options for blink-cmp-avante
               }
            }
         },
      },
      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
   },
   opts_extend = { "sources.default" }
}
