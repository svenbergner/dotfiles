--[===[
Neogit
https://github.com/NeogitOrg/neogit

A git interface for Neovim, inspired by Magit.

Dependencies:
https://github.com/esmuellert/codediff.nvim
--]===]

return {
   'NeogitOrg/neogit',
   enabled = true,
   dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'esmuellert/codediff.nvim', -- optional - Diff integration
      'folke/snacks.nvim', -- optional
   },
   cmd = 'Neogit',
   opts = {
      kind = 'floating',
      integrations = {
         codediff = true, -- integrate with codediff.nvim
         snacks = true, -- integrate with snacks.nvim
      },
      diff_viewer = 'codediff',
   },
   keys = {
      { '<leader>GG', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
   },
}
