--[=====[
 _   _         __     ___             _                   ____             __ _
| \ | | ___  __\ \   / (_)_ __ ___   | |   _   _  __ _   / ___|___  _ __  / _(_) __ _
|  \| |/ _ \/ _ \ \ / /| | '_ ` _ \  | |  | | | |/ _` | | |   / _ \| '_ \| |_| |/ _` |
| |\  |  __/ (_) \ V / | | | | | | | | |__| |_| | (_| | | |__| (_) | | | |  _| | (_| |
|_| \_|\___|\___/ \_/  |_|_| |_| |_| |_____\__,_|\__,_|  \____\___/|_| |_|_| |_|\__, |
                                                                                |___/

Starting point for the configuration of Neovim. This file is loaded when Neovim
is started and is responsible for setting up the configuration.
URL: https://githhub.com/svenbergner/dotfiles

URL: https://neovim.io/doc/user/lua.html
URL: https://github.com/folke/lazy.nvim
--]=====]

require('mason-path')
require('lsp-config')
require('globals')
require('options')
require('keymaps')
require('keymaps-markdown')
require('autocmds')
require('usercmds')

-- Bootstrap the lazy.nvim package manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
   vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- use the latest stable release
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
   { import = 'plugins' },
}, {
   -- Path to local development folder which is used if option dev = true
   -- is set in the plugin definition
   dev = {
      path = '~/Repos/',
   },
   checker = {
      enable = true,
   },
   install = {
      missing = true,
      colorscheme = { 'gruvbox' },
   },
   change_detection = {
      enable = true,
   },
})
