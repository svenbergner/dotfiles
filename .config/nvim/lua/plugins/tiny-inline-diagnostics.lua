--[===[

URL: https://github.com/
--]===]

return {
   'rachartier/tiny-inline-diagnostic.nvim',
   enabled = true,
   event = 'VeryLazy',
   priority = 1000,
   config = function()
      require('tiny-inline-diagnostic').setup({
         preset = 'amongus',
         options = {
            override_open_float = true,
            add_messages = {
               display_count = true,
            },
            multilines = {
               enabled = true,
            },
            show_sources = {
               enabled = true,
            },
         },
      })
      vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
   end,
}
