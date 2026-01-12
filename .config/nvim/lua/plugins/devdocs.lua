--[===[
Nvim Devdocs Plugin

URL: https://github.com/luckasRanarison/nvim-devdocs
--]===]

return {
   'luckasRanarison/nvim-devdocs',
   cmd = {
      'DevdocsOpen',
      'DevdocsInstall',
      'DevdocsOpenFloat',
   },
   dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter',
   },
   opts = {},
}
