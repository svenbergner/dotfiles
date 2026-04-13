--[===[
Treesitter configuration
https://github.com/nvim-treesitter/nvim-treesitter
--]===]

return {
   'nvim-treesitter/nvim-treesitter',
   enabled = true,
   branch = 'main',
   lazy = false,
   build = ':TSUpdate',
   config = function()
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldcolumn = '1'
      vim.keymap.set('n', '<CR>', 'za', { noremap = true, silent = true, desc = 'Toggle current fold' })
   end,
}
