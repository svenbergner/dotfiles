-- Telescope extension to search for a bookmark 
-- and open it with the system defauult browser
return {
  'dhruvmanila/browser-bookmarks.nvim',
  version = '*',
  opts = {
    selected_browser = 'chrome'
  },
  dependencies = {
    'nvim-telescope/telescope.nvim',
  }
}
