-- Telescope extension to search for a bookmark
-- and open it with the system default browser
return {
   'dhruvmanila/browser-bookmarks.nvim',
   version = '*',
   event = 'VeryLazy',
   opts = {
      selected_browser = 'chrome'
   },
   dependencies = {
      'nvim-telescope/telescope.nvim',
   },
   config = function()
      vim.keymap.set('n', '<leader>bb', require('browser_bookmarks').select,
         { desc = 'Search a [b]rowser-[b]ookmark and open it' })
   end
}
