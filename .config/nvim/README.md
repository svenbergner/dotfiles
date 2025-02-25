# My Neovim Config

*IMPORTANT:* This is my personal neovim config and is in no way intended to be
used by someone else without knowing what it does. 
It is a collection of plugins and settings that I like to use. Take it as an
inspiration or a starting point for your own config.
**Use at your own risk!**

The config is written in lua. External packages are getting installed and updated
using the lazy.nvim package manager.

## My currently used version

```
NVIM v0.10.2
Build type: Release
LuaJIT 2.1.1727870382
```

# Recommended Youtube Videos

## Kickstarter
- [The Only Video You Need to Get Started with Neovim](https://www.youtube.com/watch?v=m8C0Cq9Uv9o)

## The starting point: init.lua

It's the main entry point of the config. It sets up the package manager and
requires the other lua files (autocmds, globals, keymaps and options) in the 
config folder.

## File type detection

In the subfolder `ftdetect` there are some files to detect the file type of some
files that are not detected by default.

- Treat files ending with aavdrm as dosini files to get proper syntax highlighting.
- Set explicitly *.pri and *.pro files to qmake syntax.
- Set explicitly *.yaml and *.yml files to filetype yaml.

## lua

### Plugins Folder

Here is a list of the plugins that I use in my config with the correspondig
links to their github repos.

- [actions-preview: Shows a preview of the code action before applying it](https://github.com/aznhe21/actions-preview.nvim)
- [advanced-git-search: Advanced git search extension for Telescope and fzf-lua](https://github.com/aaronhallaert/advanced-git-search.nvim)
  - [telescope: a highly extendable fuzzy finder over lists](https://github.com/nvim-telescope/telescope.nvim)
  - [vim-fugitive: ](https://github.com/tpope/vim-fugitive)
  - [vim-rhubarb: ](https://github.com/tpope/vim-rhubarb)
- [auto-session: Automatically manage vim sessions](https://github.com/rmagatti/auto-session)
- [autoclose: Automatically add the closing element](https://github.com/m4xshen/autoclose.nvim)
- [avante: A cursor like AI ide frontend](https://github.com/avante/avante.nvim)
- [barbar: Tabs, as understood by any other editor](https://github.com/romgrk/barbar.nvim)
- [better escape: Better solution for using jk or jj instead of esc](https://github.com/max397574/better-escape.nvim) 
- [colorscheme: My current colorscheme is gruvbox](https://github.com/ellisonleao/gruvbox.nvim/)
- [comment: Add or remove line or block comments](https://github.com/numToStr/Comment.nvim/)
- [flash: lets you navigate your code](https://github.comfolke/flash.nvim/)
- [flutter-tools: Tools for writing flutter and dart apps](https://github.com/akinsho/flutter-tools.nvim/)
- [fun with (neo)vim: Collection of funny plugins](./lua/plugins/funwithvim.lua)
  - [cellular-automaton]( https://github.com/eandrju/cellular-automaton.nvim )
  - [duck]( https://github.com/tamton-aquib/duck.nvim )
  - [typewriter]( https://github.com/AndrewRadev/typewriter.vim )
  - [christmas tree]( https://github.com/rhysd/vim-syntax-christmas-tree )
  - [deal with it]( https://github.com/AndrewRadev/dealwithit.vim )
  - [drop]( https://github.com/folke/drop.nvim  )
  - [VimBeGood]( "https://github.com/ThePrimeagen/vim-be-good" )
  - [SudokuSolver]( "https://github.com/svenbergner/sudokusolver.nvim" )
- [git-blame: Show git blame at the end of each line](https://github.com/f-person/git-blame.nvim/)
- [github-copilot: Support for Github Copilot](https://github.com/zbirenbaum/copilot.lua/)
- [gitsigns: Adds custom signs for current git status](https://github.com/lewis6991/gitsigns.nvim)
- [helpview: Decorations for vimdoc/help files in Neovim](https://github.com/OXY2DEV/helpview.nvim)
- [image: Show images inside of neovim: ](https://github.com/3rd/image.nvim/)
- [inc-rename: Incremental renaming plugin](https://github.com/smjonas/inc-rename.nvim/)
- [is: Improved incremental search](https://github.com/haya14busa/is.vim/)
- [lazydev: Configures LuaLS for editing your Neovim config by lazily updating your workspace libraries](https://github.com/folke/lazydev.nvim/)
  - [luvit-meta: This project is a collection of definition files for the framework Luvit](https://github.com/Bilal2453/luvit-meta/)
- [mason: Easily install and manage LSP servers, DAP servers, linters, and formatters](https://github.com/williamboman/mason.nvim)
- [lualine: Neovim status line configuration](https://github.com/nvim-lualine/lualine.nvim )
- [luarocks: A luarocks frontend for neovim](https://github.com/vhyrro/luarocks.nvim)
- [luasnip: These are custom snippets created using LuaSnip](./lua/plugins/luasnip.lua)
- [mini.ai: Extend and create a/i textobjects](https://github.com/echasnovski/mini.ai)
- [mini.hipatterns: Highlight patterns in neovim](https://github.com/echasnovski/mini.hipatterns)
- [mini.surround: Fast and feature-rich surround actions](https://github.com/echasnovski/mini.surround)
- [neo-tree: Plugin to browse the file system, buffers and git changes in a tree](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [noice: Plugin that replaces the UI for messages, cmdline and popupmenu](https://github.com/folke/noice.nvim)
- [nvim-bqf: Nvim Better QuickFix](https://github.com/kevinhwang91/nvim-bqf)
- [nvim-cmp: A completion engine plugin for neovim written in Lua](https://github.com/hrsh7th/nvim-cmp/)
  - [LuaSnip: ](https://github.com/L3MON4D3/LuaSnip)
  - [cmp-buffer: nvim-cmp source for buffer words](https://github.com/hrsh7th/cmp-buffer)
  - [cmp-cmdline: nvim-cmp source for vim's cmdline](https://github.com/hrsh7th/cmp-cmdline)
  - [cmp-nvim-lsp: ](https://github.com/hrsh7th/cmp-nvim-lsp)
  - [cmp-path: nvim-cmp source for neovim's built-in language server client](https://github.com/hrsh7th/cmp-path)
  - [cmp_luasnip: ](https://github.com/saadparwaiz1/cmp_luasnip)
  - [friendly-snippets: luasnip completion source for nvim-cmp](https://github.com/rafamadriz/friendly-snippets)
  - [lspkind: ](https://github.com/onsails/lspkind.nvim)
- [nvim-dap: Debug adapter](https://github.com/mfussenegger/nvim-dap)
  - [nvim-dap-ui: Debug TUI](https://github.com/rcarriga/nvim-dap-ui)
  - [nvim-nio: A library for asynchronous IO in Neovim](https://github.com/nvim-neotest/nvim-nio)
  - [nvim-dap-virtual-text: Shows var content inline](https://github.com/theHamsta/nvim-dap-virtual-text)
- [nvim-neotest: A framework for interacting with tests within Neovim](https://github.com/nvim-neotest/neotest)
  - [neotest-dart: Support for running dart unit test](https://github.com/sidlatau/neotest-dart)
  - [nvim-nio: A library for asynchronous IO in Neovim](https://github.com/nvim-neotest/nvim-nio)
- [nvim-silicon: ](https://github.com/michaelrommel/nvim-silicon)
- [nvim-treesitter: ](https://github.com/nvim-treesitter/nvim-treesitter)
  - [nvim-treesitter-textobjects: ](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [oil: ](https://github.com/stevearc/oil.nvim)
- [outline: A treeview of the current file content](https://github.com/hedyhli/outline.nvim)
- [plenary: A collection of lua functions](https://github.com/nvim-lua/plenary.nvim)
- [smart-splits: ](https://github.com/mrjones2014/smart-splits.nvim)
- [snacks: A QoL plugin for Neovim by Folke](https://github.com/folke/snacks.nvim)
  - List of used snacks plugins:
    - bigfile
    - bufdelete
    - dim
    - git
    - gitbrowse
    - indent
    - lazygit
    - notify
    - notifier
    - quickfile
    - scroll
    - statuscolumn
    - terminal
    - toggle
    - words
    - zen
- [rest: A very fast HTTP client written in lus](https://github.com/rest-nvim/rest.nvim)
- [telescope: a highly extendable fuzzy finder over lists](https://github.com/nvim-telescope/telescope.nvim)
  - [telescope-cmake-preset-selector: Searches for all presets in a cmake project and lets you select one to build with](https://github.com/svenbergner/telescope-cmake-preset-selector)
  - [telescope-dap: Integration for nvim-dap](https://github.com/nvim-telescope/telescope-dap.nvim)
  - [telescope-debugee-selector: Searches for all executables inside of a given basedir and sets it as debug target](https://github.com/svenbergner/telescope-debugee-selector)
  - [telescope-live-grep-args: ](https://github.com/nvim-telescope/telescope-live-grep-args.nvim)
  - [telescope-repo: ](https://github.com/cljoly/telescope-repo.nvim)
  - [telescope-smart-goto: ](https://github.com/joshmedeski/telescope-smart-goto.nvim)
  - [telescope-tabs: ](https://github.com/LukasPietzschmann/telescope-tabs)
  - [telescope-ui-select: ](https://github.com/nvim-telescope/telescope-ui-select.nvim)
  - [telescope-undo: ](https://github.com/debugloop/telescope-undo.nvim)
- [todo-comments: Highlight todo, notes, etc in comments](https://github.com/folke/todo-comments.nvim)
- [trouble: A pretty list for showing diagnostics, references, telescope results, quickfix and location lists to help you solve all the trouble your code is causing.](https://github.com/folke/trouble.nvim)
  - [nvim-web-devicons: ](https://github.com/nvim-tree/nvim-web-devicons)
- [twilight: ](https://github.com/folke/twilight.nvim)
- [undotree: ](https://github.com/mbbill/undotree)
- [unicode: ](https://github.com/chrisbra/unicode.vim)
- [vim-lexical: ](https://github.com/preservim/vim-lexical)
- [vim-pencil: ](https://github.com/preservim/vim-pencil)
- [vim-sleuth: ](https://github.com/tpope/vim-sleuth)
- [vimwiki: ](https://github.com/vimwiki/vimwiki)
  - [calendar: ](https://github.com/mattn/calendar-vim)
- [virt-column: ](https://github.com/lukas-reineke/virt-column.nvim)
- [which-key: ](https://github.com/folke/which-key.nvim)
  - [mini.icons: Icon provider](https://github.com/echasnovski/mini.icons)
- [yaml: ](https://github.com/cuducos/yaml.nvim)
- [zoxide: ](https://github.com/nanotee/zoxide.vim)
 
## Spellchecking

The folder spell contains spell checking files for the German language.

## Syntax Highlighting

The folder syntax contains a vimscript file which adds syntax highlighting for
Qt qmake files.
