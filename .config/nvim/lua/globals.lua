-- This file contains global variables that are used in the configuration
-- Map leader and localleader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Backspace deletes indent, end of line and
vim.g.backspace = "indent,eol,start"

vim.g.noerrorbells = true
vim.g.nohlsearch = true
-- vim.cmd("packadd nohlsearch")

-- disable some default providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
