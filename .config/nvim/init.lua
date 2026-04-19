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

-- vim._core.ui2 is disabled to avoid conflicts with noice.nvim.
require('vim._core.ui2').enable({
   enable = false,
   msg = { -- Options related to the message module.
      ---@type 'cmd'|'msg' Default message target, either in the
      ---cmdline or in a separate ephemeral message window.
      ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
      ---or table mapping |ui-messages| kinds and triggers to a target.
      targets = 'msg',
      cmd = { -- Options related to messages in the cmdline window.
         height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
      },
      dialog = { -- Options related to dialog window.
         height = 0.5, -- Maximum height.
      },
      msg = { -- Options related to msg window.
         height = 0.5, -- Maximum height.
         timeout = 4000, -- Time a message is visible in the message window.
      },
      pager = { -- Options related to message window.
         height = 0.5, -- Maximum height.
      },
   },
})

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
   ui = {
      border = 'rounded',
   },
})
