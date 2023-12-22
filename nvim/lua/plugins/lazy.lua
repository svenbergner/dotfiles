local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
"nvim-lua/plenary.nvim",
'vimwiki/vimwiki',
require('plugins.lsp-config'),
require('plugins.treesitter'),
require('plugins.telescope'),
require('plugins.colorscheme'),
require('plugins.fzf'),
require('plugins.surround')
}


require("lazy").setup(plugins)

