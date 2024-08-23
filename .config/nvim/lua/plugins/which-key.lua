-- Shows the available keymaps
return {
   'folke/which-key.nvim',
   event = 'VeryLazy',
   dependencies = {
      { 'echasnovski/mini.icons', version = false },
   },
   config = function()
      require('which-key').setup({
         preset = "modern",
         notify = true,
         win = {
            width = { min = 20, max = 200 },

            no_overlap = true,
            border = "single",
            wo = {
               winblend = 10,
            },
         },
         layout = {
            align = "center",
         },
         show_help = true,
         show_keys = true,
         disable = {
            ft = { "lazygit", "LazyGit", "float" }
         }
      })
   end
}
