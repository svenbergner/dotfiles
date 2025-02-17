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

--]===]

return {
   'saghen/blink.cmp',
   enabled = true,
   -- optional: provides snippets for the snippet source
   dependencies = {
      'rafamadriz/friendly-snippets',
   },

   -- use a release tag to download pre-built binaries
   version = '*',
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
         -- Disable for Telescope buffers
         if filetype == "TelescopePrompt" or filetype == "minifiles" or
             filetype == "snacks_picker_input" then
            return false
         end
         return true
      end,
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = 'super-tab' },

      appearance = {
         -- Sets the fallback highlight groups to nvim-cmp's highlight groups
         -- Useful for when your theme doesn't support blink.cmp
         -- Will be removed in a future release
         use_nvim_cmp_as_default = false,
         -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
         -- Adjusts spacing to ensure icons are aligned
         nerd_font_variant = 'mono'
      },

      completion = {
         keyword = {
            -- 'prefix' will fuzzy match on the text before the cursor
            -- 'full' will fuzzy match on the text before *and* after the cursor
            -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
            range = "full",
         },
         menu = {
            border = "single",
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
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
         default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
   },
   opts_extend = { "sources.default" }
}
