require("globals")
require("options")
require("keymaps")
require("autocmds")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

require("lazy").setup(
   {
      { import = "plugins" },
   },
   {
      -- Path to local development folder which is used if option dev = true
      -- is set in the plugin definition
      dev = {
         path = '~/Repos/'
      },
      checker = {
         enable = true,
      },
      install = {
         missing = true,
         colorscheme = { "gruvbox" },
      },
      change_detection = {
         enable = true,
      }
   }
)
