"__      _______ __  __ _____   _____
"\ \    / /_   _|  \/  |  __ \ / ____|
" \ \  / /  | | | \  / | |__) | |
"  \ \/ /   | | | |\/| |  _  /| |
" _ \  /   _| |_| |  | | | \ \| |____
"(_) \/   |_____|_|  |_|_|  \_\\_____|
 

" Set vim language explicitly to english for easier 
" usage with tutorials
let $LANG='en'

" Search for config files in pwd
set exrc

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on
 
" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type
filetype indent on

" Show current line number and relative line numbers
set number
set relativenumber

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

" Spellchecking
set spelllang=de,en_gb,en_us
set spell

set nohlsearch
set hidden
set noerrorbells

set shiftwidth=4
set tabstop=4
set softtabstop=4

set expandtab
set smartindent
set nowrap
set guicursor="n-v-c:block-Cursor/lCursor, ve:ver35-Cursor, o:hor50-Cursor, i-ci:ver25-Cursor/lCursor, r-cr:hor20-Cursor/lCursor, sm:block-Cursor -blinkwait175-blinkoff150-blinkon175"
set noswapfile
"set nobackup
set undodir=~/.vim/undodir
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

""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mouse Scrolling
""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=nicr

""""""""""""""""""""""""""""""""""""""""""""""""""
" => Splits and Tabbed Files
""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow splitright

" Remap splits navigation to just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Make adjusting split sizes a bit more friendly
noremap <silent> <C-Left> :vertical resize +1<CR>
noremap <silent> <C-Right> :vertical resize +1<CR>
noremap <silent> <C-Up> :resize +1<CR>
noremap <silent> <C-Down> :resize +1<CR>

" Change 2 split windows from vert to horiz or horiz to vert
map <leader>th <C-w>t<C-w>H
map <leader>tk <C-w>t<C-w>K

" Removes pipes | that act as seperators on splits
set fillchars+=vert:\

" Block visualization
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" PLUGINS ---------------------------------------------------------------- {{{
call plug#begin()
    Plug 'airblade/vim-gitgutter'
    Plug 'dart-lang/dart-vim-plugin'
    Plug 'dense-analysis/ale'
    Plug 'gruvbox-community/gruvbox'
    Plug 'haya14busa/is.vim'
    Plug 'iamcco/markdown-preview.nvim', {'do':{->mkdp#util#install()}, 'for':['markdown','vim-plug']}
    Plug 'jiangmiao/auto-pairs'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    Plug 'mattn/calendar-vim'
    Plug 'kshenoy/vim-signature'
    Plug 'miyakogi/conoline.vim'
    Plug 'nelstrom/vim-visual-star-search'
    Plug 'preservim/nerdtree'
    Plug 'preservim/vim-lexical'
    Plug 'scrooloose/nerdcommenter'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-markdown'
    Plug 'natebosch/vim-lsc'
    Plug 'natebosch/vim-lsc-dart'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'vimwiki/vimwiki'
call plug#end()
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colorscheme
""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme gruvbox

let g:conoline_auto_enable = 1
let g:lsc_auto_map = v:true

" KEY MAPPINGS ----------------------------------------------------------- {{{

" Use jk insteasd of the escape key
inoremap jk <ESC>

" Insert current date and time
nmap <F3> i<C-R>=strftime("%A, %d.%m.%Y %I:%M")<CR><Esc>
imap <F3> <C-R>=strftime("%d.%m.%Y %I:%M")<CR>

" Open Terminal
noremap <LEADER>ot :botright vertical terminal<CR>

" Toggle Goyo
nnoremap <LEADER>g :Goyo<CR>
nnoremap <LEADER>gw :Goyo 120<CR>

" Source current file
nnoremap <LEADER>s :source %<CR>

" Fold open
nnoremap <LEADER>fo :foldopen<CR>

" Fold close
nnoremap <LEADER>fc :foldclose<CR>

" Move current line down
noremap <C-Down> ddp

" Move current line up
noremap <C-Up> ddkP

" Open .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Source .vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{
" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.
" }}}

" Vim Wiki Options ------------------------------------------------------- {{{
let g:vimwiki_list = [{'syntax':'markdown'}]
au FileType vimwiki setlocal shiftwidth=6 tabstop=6 noexpandtab

command! Diary VimwikiDiaryIndex
augroup vimwikigroup
   autocmd!
   " automatically update links on read diary
   autocmd BufRead,BufNewFile diary.wiki VimwikiDiaryGenerateLinks
   autocmd BufNewFile */diary/[0-9]*.wiki :silent 0r !echo "\# `date +'\%d.\%m.\%Y'`"
   autocmd BufNewFile */diary/[0-9]*.md :silent 0r !echo "\# `date +'\%d.\%m.\%Y'`"
augroup end
" }}}

" STATUS LINE ------------------------------------------------------------ {{{
" Status bar code goes here.
let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#wordcount#filetypes = '\vasciidoc|help|mail|markdown|markdown.pandoc|org|rst|tex|text'
let g:airline_powerline_fonts = 1
set laststatus=2
" }}}


