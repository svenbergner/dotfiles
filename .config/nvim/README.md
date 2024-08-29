# My Neovim Config

*IMPORTANT:* This is my personal neovim config and is in no way intended to be
used by someone else without knowing what it does. 
It is a collection of plugins and settings that I like to use. Take it as an
inspiration or a starting point for your own config.
**Use at your own risk!**

The config is written in lua. External packages are getting installed and updated
using the lazy.nvim package manager.

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

- [Comment: Add or remove line or block comments](https://github.com/numToStr/Comment.nvim/)
- [actions-preview: Shows a preview of the code action before applying it](https://github.com/aznhe21/actions-preview.nvim)
- [advanced-git-search: Advanced git search extension for Telescope and fzf-lua](https://github.com/aaronhallaert/advanced-git-search.nvim)
  - [telescope: a highly extendable fuzzy finder over lists](https://github.com/nvim-telescope/telescope.nvim)
  - [vim-fugitive: ](https://github.com/tpope/vim-fugitive)
  - [vim-rhubarb: ](https://github.com/tpope/vim-rhubarb)
- [auto-session: Automatically manage vim sessions](https://github.com/rmagatti/auto-session)
- [autoclose: Automatically add the closing element](https://github.com/m4xshen/autoclose.nvim)
- [barbar: Tabs, as understood by any other editor](https://github.com/romgrk/barbar.nvim)
- [bigfile: Helps to open really big files by disabling resource hungry features](https://github.com/LunarVim/bigfile.nvim/)
- [copilot: Support for Github Copilot](https://github.com/zbirenbaum/copilot.lua/)
- [flash: lets you navigate your code](https://github.comfolke/flash.nvim/)
- [flutter-tools: Tools for writing flutter and dart apps](https://github.com/akinsho/flutter-tools.nvim/)
- [git-blame: Show git blame at the end of each line](https://github.com/f-person/git-blame.nvim/)
- [gitsigns: Adds custom signs for current git status](https://github.com/lewis6991/gitsigns.nvim)
- [gruvbox: My current colorscheme](https://github.com/ellisonleao/gruvbox.nvim/)
- [harpoon: Getting you where you want with the fewest keystrokes.](https://github.com/ThePrimeagen/harpoon)
- [inc-rename: Incremental renaming plugin](https://github.com/smjonas/inc-rename.nvim/)
- [indent-blankline: Adds indentation guides to Neovim.](https://github.com/lukas-reineke/indent-blankline.nvim/)
- [is: Improved incremental search](https://github.com/haya14busa/is.vim/)
- [lazydev: Configures LuaLS for editing your Neovim config by lazily updating your workspace libraries](https://github.com/folke/lazydev.nvim/)
  - [luvit-meta: This project is a collection of definition files for the framework Luvit](https://github.com/Bilal2453/luvit-meta/)
- [mason: Easily install and manage LSP servers, DAP servers, linters, and formatters](https://github.com/williamboman/mason.nvim)
- [mini.icons: Icon provider](https://github.com/echasnovski/mini.icons)
- [neotest: A framework for interacting with tests within Neovim](https://github.com/nvim-neotest/neotest)
  - [neotest-dart: Support for running dart unit test](https://github.com/sidlatau/neotest-dart)
- [nvim-cmp: ](https://github.com/hrsh7th/nvim-cmp/)
  - [LuaSnip: ](https://github.com/L3MON4D3/LuaSnip)
  - [cmp-buffer: ](https://github.com/hrsh7th/cmp-buffer)
  - [cmp-cmdline: ](https://github.com/hrsh7th/cmp-cmdline)
  - [cmp-nvim-lsp: ](https://github.com/hrsh7th/cmp-nvim-lsp)
  - [cmp-path: ](https://github.com/hrsh7th/cmp-path)
  - [cmp_luasnip: ](https://github.com/saadparwaiz1/cmp_luasnip)
  - [friendly-snippets: ](https://github.com/rafamadriz/friendly-snippets)
  - [lspkind: ](https://github.com/onsails/lspkind.nvim)
- [nvim-colorizer: ](https://github.com/NvChad/nvim-colorizer.lua)
- [nvim-dap-go: ](https://github.com/leoluz/nvim-dap-go)
- [nvim-dap-ui: ](https://github.com/rcarriga/nvim-dap-ui)
- [nvim-dap: ](https://github.com/mfussenegger/nvim-dap)
- [nvim-nio: ](https://github.com/nvim-neotest/nvim-nio)
- [nvim-silicon: ](https://github.com/michaelrommel/nvim-silicon)
- [nvim-surround: ](https://github.com/kylechui/nvim-surround)
- [nvim-treesitter-textobjects: ](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [nvim-treesitter: ](https://github.com/nvim-treesitter/nvim-treesitter)
- [oil: ](https://github.com/stevearc/oil.nvim)
- [outline: ](https://github.com/hedyhli/outline.nvim)
- [plenary: ](https://github.com/nvim-lua/plenary.nvim)
- [smart-splits: ](https://github.com/mrjones2014/smart-splits.nvim)
- [telescope: a highly extendable fuzzy finder over lists](https://github.com/nvim-telescope/telescope.nvim)
  - [telescope-cmake-preset-selector: Searches for all presets in a cmake project and lets you select one to build with](https://github.com/svenbergner/telescope-cmake-preset-selector)
  - [telescope-dap: ](https://github.com/nvim-telescope/telescope-dap.nvim)
  - [telescope-debugee-selector: Searches for all executables inside of a given basedir and sets it as debug target](https://github.com/svenbergner/telescope-debugee-selector)
  - [telescope-floaterm: ](https://github.com/dawsers/telescope-floaterm.nvim)
  - [telescope-live-grep-args: ](https://github.com/nvim-telescope/telescope-live-grep-args.nvim)
  - [telescope-repo: ](https://github.com/cljoly/telescope-repo.nvim)
  - [telescope-smart-goto: ](https://github.com/joshmedeski/telescope-smart-goto.nvim)
  - [telescope-tabs: ](https://github.com/LukasPietzschmann/telescope-tabs)
  - [telescope-ui-select: ](https://github.com/nvim-telescope/telescope-ui-select.nvim)
  - [telescope-undo: ](https://github.com/debugloop/telescope-undo.nvim)
- [todo-comments: ](https://github.com/folke/todo-comments.nvim)
- [trouble: A pretty list for showing diagnostics, references, telescope results, quickfix and location lists to help you solve all the trouble your code is causing.](https://github.com/folke/trouble.nvim)
  - [nvim-web-devicons: ](https://github.com/nvim-tree/nvim-web-devicons)
- [twilight: ](https://github.com/folke/twilight.nvim)
- [undotree: ](https://github.com/mbbill/undotree)
- [unicode: ](https://github.com/chrisbra/unicode.vim)
- [vim-illuminate: ](https://github.com/RRethy/vim-illuminate)
- [vim-lexical: ](https://github.com/preservim/vim-lexical)
- [vim-pencil: ](https://github.com/preservim/vim-pencil)
- [vim-sleuth: ](https://github.com/tpope/vim-sleuth)
- [vimwiki: ](https://github.com/vimwiki/vimwiki)
  - [calendar: ](https://github.com/mattn/calendar-vim)
- [virt-column: ](https://github.com/lukas-reineke/virt-column.nvim)
- [which-key: ](https://github.com/folke/which-key.nvim)
- [yaml: ](https://github.com/cuducos/yaml.nvim)
- [zen-mode: ](https://github.com/folke/zen-mode.nvim)
- [zoxide: ](https://github.com/nanotee/zoxide.vim)
 
## Spellchecking

## Syntax Highlighting

