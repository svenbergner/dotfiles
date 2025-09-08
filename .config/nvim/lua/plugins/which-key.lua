--[===[
Shows the available keymaps
URL: http://github.com/folke/which-key.nvim
--]===]

return {
   'folke/which-key.nvim',
   enabled = true,
   event = 'VeryLazy',
   dependencies = {
      { 'echasnovski/mini.icons', version = false },
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
            { '<leader>a',        group = '[a]vante',           icon = '💬' },
            { '<leader>b',        group = '[b]uffer',           icon = '' },
            { '<leader>bo',       group = '[o]rder by',         icon = ' ' },
            { '<leader>c',        group = 'vimwiki [c]alendar', icon = '' },
            { '<leader>d',        group = '[d]apui',            icon = '' },
            { '<leader>D',        group = '[D]iff',             icon = '󰕛' },
            { '<leader>f',        group = '[f]ind',             icon = '' },
            { '<leader>g',        group = '[g]it',              icon = '' },
            { '<leader>l',        group = '[l]azy',             icon = '' },
            { '<leader>m',        group = '[m]arkdown',         icon = '' },
            { '<leader>n',        group = '[n]eotree',          icon = '󱏒' },
            { '<leader>N',        group = '[N]oice and [N]ews', icon = '' },
            { '<leader>q',        group = '[q]uickfix-list',    icon = '' },
            { '<leader>s',        group = '[s]wap',             icon = '󰣁' },
            { '<leader>t',        group = '[t]oggle',           icon = '' },
            { '<leader>T',        group = '[T]est',             icon = '󰙨' },
            { '<leader>u',        group = '[u]nicode',          icon = '󰻐' },
            { '<leader>w',        group = 'vim[w]iki',          icon = '󰖬' },
            { '<leader>w<Space>', group = 'Diary',              icon = '󰖬' },
            { '<leader>W',        group = 'LSP [W]orkspace',    icon = '' },
            { '<leader>z',        group = '[z]en',              icon = '󱅻' },
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
