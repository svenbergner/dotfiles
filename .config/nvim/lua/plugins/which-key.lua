-- Shows the available keymaps
-- http://www.github.com/folke/which-key.nvim

return {
   'folke/which-key.nvim',
   event = 'VeryLazy',
   dependencies = {
      { 'echasnovski/mini.icons', version = false },
   },
   config = function()
      require('which-key').setup({
         preset = "modern",
         icons = {
            mappings = true,
            keys = {},
         },
         spec = {
            { '<leader>a', group = '[a]vante' },
            { '<leader>b', group = '[b]uffer' },
            { '<leader>c', group = '[c]ode' },
            { '<leader>d', group = '[d]apui' },
            { '<leader>f', group = '[f]ind', },
            { '<leader>g', group = '[g]it', },
            { '<leader>n', group = '[n]eotree' },
            { '<leader>t', group = '[t]est' },
            { '<leader>w', group = 'vim[w]iki', },
            { '<leader>W', group = 'LSP [W]orkspace', },
            { '<leader>z', group = '[z]en' },

            --    { '<leader>r', group = '[R]ename' },
            --    { '<leader>s', group = '[S]earch' },
            --    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
         },
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
