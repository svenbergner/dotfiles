" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on 

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type
filetype indent on

" Show relative line numbers
set number relativenumber

" Turn syntax highlighting on.
syntax on

" Highlight cursor line
set cursorline

" Remap leader key
nnoremap <SPACE> <Nop>
let mapleader = " "
let maplocalleader = " "

" Keymap for open Terminal
noremap <LEADER>ot :botright vertical terminal<CR>

" Keymap toggle Goyo
nnoremap <LEADER>g :Goyo<CR>
nnoremap <LEADER>gw :Goyo 120<CR>

" Keymap source current file
nnoremap <LEADER>s :source %<CR>

" Spellchecking
set spelllang=de_de,en_gb,en_us
set spell

set shiftwidth=3
set tabstop=4
set expandtab
set nowrap
set scrolloff=10
set incsearch

" Ignore capital letters during search.
set ignorecase
set smartcase

set showcmd
set showmatch
set hlsearch
set history=1000

set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Block visualization
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

updatetime=50

" PLUGINS ---------------------------------------------------------------- {{{
call plug#begin('~/.vim/plugged')

    Plug 'dense-analysis/ale'
    Plug 'preservim/nerdtree'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-markdown'
    Plug 'junegunn/goyo.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
    Plug 'vimwiki/vimwiki'
    Plug 'mattn/calendar-vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'gruvbox-community/gruvbox'
    Plug 'miyakogi/conoline.vim'
call plug#end()
" }}}

set background=dark
colorscheme gruvbox

let g:conoline_auto_enable = 1

" KEY MAPPINGS ----------------------------------------------------------- {{{

" Fold open
nnoremap <LEADER>fo :foldopen<CR>

" Fold close
nnoremap <LEADER>fc :foldclose<CR>

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
set statusline=
set statusline+=\ %F\ %M\ %Y\ %R
set statusline+=%=
set statusline+=[%{strftime('%c')}]\ row:\ %l\ col:\ %c\ %p%%
set laststatus=2
" }}}

