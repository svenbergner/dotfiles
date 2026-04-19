--[===[
Shows the available keymaps
http://github.com/folke/which-key.nvim
http://github.com/nvim-mini/mini.icons
--]===]

return {
   'folke/which-key.nvim',
   enabled = true,
   event = 'VeryLazy',
   dependencies = {
      { 'nvim-mini/mini.icons', version = false },
   },
   config = function()
      require('which-key').setup({
         preset = "modern",
         delay = 500,
         icons = {
            mappings = true,
            keys = {},
         },
         spec = {
            { 'g',                group = '[g]lobal',                   icon = '', },
            { '<leader>a',        group = '[a]vante',                   icon = '' },
            { '<leader>b',        group = '[b]uffer',                   icon = '' },
            { '<leader>bo',       group = '[o]rder by',                 icon = ' ' },
            { '<leader>c',        group = '[c]ode',                     icon = '' },
            { '<leader>d',        group = '[d]ap',                      icon = '' },
            { '<leader>dj',       group = '[d]apview [j]ump to',        icon = '' },
            { '<leader>ds',       group = '[d]apview [s]how',           icon = '' },
            { '<leader>D',        group = '[D]iff',                     icon = '󰕛' },
            { '<leader>e',        group = '[e]lixir',                   icon = '' },
            { '<leader>f',        group = '[f]ind',                     icon = '' },
            { '<leader>g',        group = '[g]it',                      icon = '' },
            { '<leader>G',        group = '[G]it',                      icon = '' },
            { '<leader>l',        group = '[l]azy',                     icon = '' },
            { '<leader>m',        group = '[m]arkdown',                 icon = '' },
            { '<leader>n',        group = '[n]eotree',                  icon = '󱏒' },
            { '<leader>N',        group = '[N]oice and [N]ews',         icon = '' },
            { '<leader>o',        group = '[o]rg mode',                 icon = '' },
            { '<leader>q',        group = '[q]uickfix list',            icon = '' },
            { '<leader>r',        group = 'org [r]oam',                 icon = '' },
            { '<leader>s',        group = '[s]wap',                     icon = '󰣁' },
            { '<leader>t',        group = '[t]oggle',                   icon = '' },
            { '<leader>T',        group = '[T]est',                     icon = '󰙨' },
            { '<leader>u',        group = '[u]nicode',                  icon = '󰻐' },
            { '<leader>v',        group = '[v]im pack',                 icon = ' ' },
            { '<leader>w',        group = 'vim[w]iki',                  icon = '󰖬' },
            { '<leader>w<Space>', group = 'Diary',                      icon = '󰖬' },
            { '<leader>W',        group = 'LSP [W]orkspace',            icon = '' },
            { '<leader>X',        group = 'E[X]ecute the current line', icon = '' },
            { '<leader>y',        group = '[y]ank',                     icon = '' },
            { '<leader>z',        group = '[z]en',                      icon = '󱅻' },
         },
         notify = true,
         win = {
            width = { min = 20, max = 200 },

            no_overlap = true,
            border = "rounded",
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
