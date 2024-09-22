"__      _______ __  __ _____   _____
"\ \    / /_   _|  \/  |  __ \ / ____|
" \ \  / /  | | | \  / | |__) | |
"  \ \/ /   | | | |\/| |  _  /| |
" _ \  /   _| |_| |  | | | \ \| |____
"(_) \/   |_____|_|  |_|_|  \_\\_____|
 

" Set vim language explicitly to english for easier usage with tutorials
let $LANG='en'

set encoding=utf-8

" Search for config files in pwd
set exrc

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable filetype detection. Vim will be able to try to detect the type of file in use.
" Enable plugins and load plugin for the detected file type.
" Load an indent file for the detected file type
filetype plugin indent on

" Backspace behaviour
set backspace=indent,eol,start

" Show current line number and relative line numbers
set number relativenumber

" Toggle relative line numbers based on focus
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Turn syntax highlighting on.
syntax on

" Show lineendings
set list

" Highlight cursor line
set cursorline

" Remap leader key
nnoremap <SPACE> <Nop>
let mapleader = " "
let maplocalleader = " "

set nohlsearch
set hidden
set noerrorbells

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set nowrap

set backspace=indent,eol,start

set guicursor="n-v-c:block-Cursor/lCursor, ve:ver35-Cursor, o:hor50-Cursor, i-ci:ver25-Cursor/lCursor, r-cr:hor20-Cursor/lCursor, sm:block-Cursor -blinkwait175-blinkoff150-blinkon175"
set noswapfile
set undodir=~/.local/state/undo/vim/
set undofile
set incsearch
set scrolloff=5
set signcolumn=yes
set cmdheight=2
set timeoutlen=1000
set ttimeoutlen=100

" Ignore capital letters during search.
set ignorecase
set smartcase

set showcmd
set showmatch
set hlsearch
set history=10000

set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Mouse Scrolling
set mouse=nicr

" Splits and Tabbed Files
set splitbelow splitright

" Move between splits with CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Removes pipes | that act as seperators on splits
set fillchars+=vert:\

" Block visualization
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Colorscheme
set background=dark

" KEY MAPPINGS
" Prevent x and the delete key from overriding what's in the clipboard.
noremap x "_x
noremap X "_X
noremap <Del> "_x

" Use jk insteasd of the escape key
inoremap jk <ESC>

" Source current file
nnoremap <LEADER><LEADER>x :w<CR>:source %<CR>

" Switch Buffers
map <PageUp> :bp<CR>
map <PageDown> :bn<CR>

" STATUS LINE
set laststatus=2

