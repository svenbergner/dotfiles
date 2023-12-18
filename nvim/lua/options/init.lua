vim.api.nvim_exec ('language en_US', true)

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2

vim.opt.cursorline = false
vim.opt.syntax = on

vim.cmd([[let $LANG = 'en']])
