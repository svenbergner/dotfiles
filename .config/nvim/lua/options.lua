-- Set vim language explicitly to English for easier usage with tutorials
vim.api.nvim_exec("language en_US.UTF-8", true)

vim.opt.compatible = false

vim.opt.termguicolors = true

-- Enable mouse mode
vim.opt.mouse = 'a'

vim.opt.guicursor = {
	"n-v-c:block", -- Normal, visual, command-line: block cursor
	"i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
	"r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor with 20% height
	"o:hor50", -- Operator-pending: horizontal bar cursor with 50% height
	"a:blinkwait700-blinkoff400-blinkon250", -- All modes: blinking settings
	"sm:block-blinkwait175-blinkoff150-blinkon175", -- Show match: block cursor with specific blinking settings
}

-- Show current line number and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable virtual edit in block mode
vim.opt.virtualedit = "block"

-- tab
vim.opt.expandtab = true
-- vim.opt.tabstop = 3
-- vim.opt.softtabstop = 3
-- vim.opt.shiftwidth = 3
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.scrolloff = 5

--
vim.opt.hidden = true
vim.opt.swapfile = false

-- line wrap
vim.opt.wrap = false
vim.wo.wrap = false

-- New splits open to the right and below
vim.opt.splitbelow = true
vim.opt.splitright = true

-- all windows automatically made same size after splitting or closing a window
vim.opt.equalalways = true

-- Highlight cursor line
vim.opt.cursorline = true

-- Turn syntax highlighting on.
vim.opt.syntax = "on"

-- Show tab stops, trailing whitespace and line endings
vim.opt.list = true
vim.opt.listchars = { tab = '> ', trail = '.', eol = '↵' }

vim.g.noerrorbells = true
vim.g.nohlsearch = true
vim.g.icm = "nosplit"

-- file search
vim.opt.ignorecase = true
vim.opt.smartcase = true -- Override 'ignorecase' option if search pattern contains upper case characters
vim.opt.hlsearch = true  -- Highlight search matches
vim.opt.incsearch = true

-- Clear highlighting on pressing Escape
vim.keymap.set('n', '<Esc>', '<esc>:nohlsearch<CR>', { silent = true })

vim.opt.history = 1000

-- status-line
vim.opt.laststatus = 2
vim.opt.cmdheight = 2
vim.opt.showcmd = true
vim.opt.showmode = true -- change to false after
vim.opt.showmatch = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 800
vim.opt.ttimeoutlen = 100

-- show signs on the left
vim.opt.signcolumn = 'yes'

-- Wild menu
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full"
vim.opt.wildignore:append({ "*.docx", "*.jpg", "*.png", "*.gif", "*.pdf", "*.pyc", "*.exe", "*.flv", "*.img", "*.xlsx" })

-- Check for Neovim equivalent
-- Spellchecking
if vim.fn.has('linux') then
   vim.opt.spelllang = 'de,en'
else
   vim.opt.spelllang = 'de_de,en_gb'
end
vim.opt.spell = true
vim.cmd("highlight SpellBad cterm=bold,undercurl gui=bold,undercurl guisp=Red")

-- Undo
local prefix = vim.fn.expand("~/.config")
vim.opt.undodir = { prefix .. "/nvim/.undo//" }
vim.opt.undofile = true

-- Better completion
vim.opt.completeopt = { "menuone" }

