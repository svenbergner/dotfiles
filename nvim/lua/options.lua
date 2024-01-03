-- Set vim language explicitly to english for easier usage with tutorials
vim.api.nvim_exec("language en_US", true)

vim.opt.compatible = false

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Show current line number and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- tab
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = false

vim.opt.scrolloff = 5

--
vim.opt.hidden = true
vim.opt.swapfile = false

-- linewrap
vim.opt.wrap = false
vim.wo.wrap = false

-- split behaviour
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.equalalways = true

-- Highlight cursor line
vim.opt.cursorline = true

-- Turn syntax highlighting on.
vim.opt.syntax = "on"

-- Show lineendings
vim.opt.list = true
vim.opt.listchars = { tab = "> ", trail = "-", eol = "↵" }

vim.g.noerrorbells = true
vim.g.nohlsearch = true

-- file search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.history = 1000

-- statusline
vim.opt.laststatus = 2
vim.opt.cmdheight = 2
vim.opt.showcmd = true
vim.opt.showmode = true -- change to false after
vim.opt.showmatch = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 100

-- show signs on the left
vim.opt.signcolumn = "yes"

-- Wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full"
vim.opt.wildignore:append({ "*.docx", "*.jpg", "*.png", "*.gif", "*.pdf", "*.pyc", "*.exe", "*.flv", "*.img", "*.xlsx" })

-- Check for neovim equivalent
-- Spellchecking
-- set spelllang=de,en_gb,en_us
-- set spell

-- Undo
local prefix = vim.fn.expand("~/.config")
vim.opt.undodir = { prefix .. "/nvim/.undo//" }
vim.opt.undofile = true
