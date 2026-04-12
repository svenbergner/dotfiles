--[=====[
 _   _         __     ___             _                   ____             __ _
| \ | | ___  __\ \   / (_)_ __ ___   | |   _   _  __ _   / ___|___  _ __  / _(_) __ _
|  \| |/ _ \/ _ \ \ / /| | '_ ` _ \  | |  | | | |/ _` | | |   / _ \| '_ \| |_| |/ _` |
| |\  |  __/ (_) \ V / | | | | | | | | |__| |_| | (_| | | |__| (_) | | | |  _| | (_| |
|_| \_|\___|\___/ \_/  |_|_| |_| |_| |_____\__,_|\__,_|  \____\___/|_| |_|_| |_|\__, |
                                                                                |___/

Starting point for the configuration of Neovim. This file is loaded when Neovim
is started and is responsible for setting up the configuration

URLs:
https://githhub.com/svenbergner/dotfiles
https://neovim.io/doc/user/lua.html
https://github.com/folke/lazy.nvim
--]=====]

require('mason-path')
require('lsp-config')
require('globals')
require('options')
require('keymaps')
require('autocmds')
require('usercmds')
require('lsp-keymaps')

-- Bootstrap the lazy.nvim package manager
vim.pack.add({ 'https://github.com/folke/lazy.nvim' })

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
