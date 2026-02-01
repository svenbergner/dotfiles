--[===[
org-roam.nvim
Port of Org-roam to neovim using nvim-orgmode.

URL: https://github.com/chipsenkbeil/org-roam.nvim
--]===]

return {
   'chipsenkbeil/org-roam.nvim',
   enabled = true,
   dependencies = {
      'nvim-orgmode/orgmode',
   },
   config = function()
      require('org-roam').setup({
         directory = '~/Repos/orgfiles/roam',
         bindings = {
            prefix = '<Leader>r',
         }
      })
   end,
}
