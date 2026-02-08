--[===[
Neogit
A git interface for Neovim, inspired by Magit.

URL: https://github.com/NeogitOrg/neogit
--]===]

return {
   'NeogitOrg/neogit',
   enabled = true,
   dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'folke/snacks.nvim', -- optional
   },
   cmd = 'Neogit',
   keys = {
      { '<leader>GG', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
   },
}
