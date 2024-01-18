-- Set vim language explicitly to English for easier usage with tutorials
vim.api.nvim_exec("language en_US.UTF-8", true)

vim.opt.compatible = false

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.termguicolors = true

-- Show current line number and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable virtual edit in block mode
vim.opt.virtualedit = "block"
-- tab
vim.opt.expandtab = true
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.scrolloff = 5

--
vim.opt.hidden = true
vim.opt.swapfile = false

-- linewrap
vim.opt.wrap = false
vim.wo.wrap = false

-- New splits open to the right and below
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.equalalways = true -- all windows automatically made same size after splitting or closing a window

-- Highlight cursor line
vim.opt.cursorline = true

-- Turn syntax highlighting on.
vim.opt.syntax = "on"

-- Show lineendings
vim.opt.list = true
vim.opt.listchars = { tab = "> ", trail = "-", eol = "↵" }

vim.g.noerrorbells = true
vim.g.nohlsearch = true
vim.g.icm = "nosplit"

-- file search
vim.opt.ignorecase = true
vim.opt.smartcase = true -- Override 'ignorecase' option if search pattern contains upper case characters
vim.opt.hlsearch = true  -- Highlight search matches
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
