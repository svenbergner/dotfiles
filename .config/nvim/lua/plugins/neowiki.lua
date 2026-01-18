--[===[

URL: https://github.com/
--]===]

return {
   'echaya/neowiki.nvim',
   enabled = true,
   event = 'VeryLazy',
   opts = {
      wiki_dirs = {
         {
            name = 'neowiki',
            path = '~/Repos/vimwiki/',
         },
      },
   },
   keys = {
      { '<leader>WW', "<cmd>lua require('neowiki').open_wiki_floating()<cr>", desc = 'Open Wiki in Floating Window' },
   },
}
