--[===[
Orgmode clone written in Lua for Neovim

URL: https://github.com/nvim-orgmode/orgmode
--]===]

return {
   'nvim-orgmode/orgmode',
   enabled = true,
   event = 'VeryLazy',
   ft = { 'org' },
   config = function()
      -- Setup orgmode
      require('orgmode').setup({
         org_agenda_files = '~/Repos/orgfiles/**/*',
         org_default_notes_file = '~/Repos/orgfiles/refile.org',
      })
   end,
}
