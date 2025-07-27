-- Set Vim language explicitly to English for easier usage with tutorials
vim.api.nvim_exec2("language en_US.UTF-8", { output = true })

vim.opt.compatible = false

vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Enable mouse support
vim.opt.mouse = 'a'

vim.opt.guicursor = {
	"n-v-c:block",                           -- Normal, visual, command-line: block cursor
	"i-ci-ve:ver25",                         -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
	"r-cr:hor20",                            -- Replace, command-line replace: horizontal bar cursor with 20% height
	"o:hor50",                               -- Operator-pending: horizontal bar cursor with 50% height
	"a:blinkwait700-blinkoff400-blinkon250", -- All modes: blinking settings
	"sm:block-blinkwait175-blinkoff150-blinkon175", -- Show match: block cursor with specific blinking settings
}

-- Show the current line number and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable virtual editing in block mode
vim.opt.virtualedit = "block"

-- Tab settings
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Keep the cursor of the edges while scrolling
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

-- Buffer and swapfile settings
vim.opt.hidden = true
vim.opt.swapfile = false

-- Line wrapping
vim.opt.wrap = false
vim.wo.wrap = false

-- New splits open to the right and below
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Highlight cursor line
vim.opt.cursorline = true

-- Enable syntax highlighting
vim.opt.syntax = "on"

-- Show tab stops, trailing whitespace, and line endings
vim.opt.list = true
vim.opt.listchars = { tab = '> ', trail = '~', eol = '↲', extends = '→', precedes = '←', space = '∙' }

-- File search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true -- Override the 'ignorecase' option if the search pattern contains uppercase characters
vim.opt.hlsearch = true  -- Highlight search results
vim.opt.incsearch = true
vim.opt.history = 1000

-- Status line settings
vim.opt.laststatus = 3
vim.opt.cmdheight = 2
vim.opt.showcmd = true
vim.opt.showmode = true -- change to false after
vim.opt.showmatch = true
vim.opt.updatetime = 500
vim.opt.timeoutlen = 800
vim.opt.ttimeoutlen = 100

-- Show signs on the left
vim.opt.signcolumn = 'yes'

-- Wild menu settings
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full"
vim.opt.wildignore:append({ "*.docx", "*.jpg", "*.png", "*.gif", "*.pdf", "*.pyc", "*.exe", "*.flv", "*.img", "*.xlsx" })

-- Spell checking settings
-- Manual download at http://ftp.vim.org/vim/runtime/spell/
if vim.fn.has('linux') then
	vim.opt.spelllang = 'de,en'
else
	vim.opt.spelllang = 'de_de,en_gb'
end
vim.opt.spell = true
vim.cmd("highlight SpellBad cterm=bold,undercurl gui=bold,undercurl guisp=Red")

-- Undo settings
local prefix = vim.fn.expand("~/.local/state/undo/")
vim.opt.undodir = { prefix .. "nvim/" }
vim.opt.undofile = true

vim.opt.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,localoptions'

-- Number formats
vim.opt.nrformats = 'bin,hex,octal,unsigned'
