# My Neovim Config

*IMPORTANT:* This is my personal neovim config and is in no way intended to be
used by someone else without knowing what it does. 
It is a collection of plugins and settings that I like to use. Take it as an
inspiration or a starting point for your own config.
**Use at your own risk!**

The config is written in lua. Based on the lazy.nvim package manager.

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

- [image: Show images inside of nvim](https://github.com3rd/image.nvim/)
- [luvit-meta: ](https://github.com/Bilal2453/luvit-meta/)
- [LuaSnip: ](https://github.com/L3MON4D3/LuaSnip)
- [telescope-tabs](https://github.com/LukasPietzschmann/telescope-tabs)
- [bigfile.nvim](https://github.com/LunarVim/bigfile.nvim/)
- [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
- [vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [harpoon](https://github.com/ThePrimeagen/harpoon)
- [actions-preview.nvim](https://github.com/aznhe21/actions-preview.nvim)
- [advanced-git-search.nvim](https://github.com/aaronhallaert/advanced-git-search.nvim)
- [flutter-tools.nvim](https://github.com/akinsho/flutter-tools.nvim/)
- [FixCursorHold.nvim](https://github.com/antoinemadec/FixCursorHold.nvim)
- [unicode.vim](https://github.com/chrisbra/unicode.vim)
- [telescope-repo.nvim](https://github.com/cljoly/telescope-repo.nvim)
- [yaml.nvim](https://github.com/cuducos/yaml.nvim)
- [telescope-floaterm.nvim](https://github.com/dawsers/telescope-floaterm.nvim)
- [telescope-undo.nvim](https://github.com/debugloop/telescope-undo.nvim)
- [mini.icons](https://github.com/echasnovski/mini.icons)
- [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim/)
- [git-blame.nvim](https://github.com/f-person/git-blame.nvim/)
- [flash.nvim](https://github.comfolke/flash.nvim/)
- [lazydev.nvim](https://github.com/folke/lazydev.nvim/)
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)
- [trouble.nvim](https://github.com/folke/trouble.nvim)
- [twilight.nvim](https://github.com/folke/twilight.nvim)
- [which-key.nvim](https://github.com/folke/which-key.nvim)
- [zen-mode.nvim](https://github.com/folke/zen-mode.nvim)
- [is.vim](https://github.com/haya14busa/is.vim/)
- [outline.nvim](https://github.com/hedyhli/outline.nvim)
- [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
- [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
- [cmp-path](https://github.com/hrsh7th/cmp-path)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp/)
- [telescope-smart-goto.nvim](https://github.com/joshmedeski/telescope-smart-goto.nvim)
- [nvim-surround](https://github.com/kylechui/nvim-surround)
- [nvim-dap-go](https://github.com/leoluz/nvim-dap-go)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim/)
- [virt-column.nvim](https://github.com/lukas-reineke/virt-column.nvim)
- [autoclose.nvim](https://github.com/m4xshen/autoclose.nvim)
- [calendar-vim](https://github.com/mattn/calendar-vim)
- [undotree](https://github.com/mbbill/undotree)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [nvim-silicon](https://github.com/michaelrommel/nvim-silicon)
- [smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)
- [zoxide.vim](https://github.com/nanotee/zoxide.vim)
- [Comment.nvim](https://github.com/numToStr/Comment.nvim/)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [neotest](https://github.com/nvim-neotest/neotest)
- [nvim-nio](https://github.com/nvim-neotest/nvim-nio)
- [telescope-dap.nvim](https://github.com/nvim-telescope/telescope-dap.nvim)
- [telescope-live-grep-args.nvim](https://github.com/nvim-telescope/telescope-live-grep-args.nvim)
- [telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [lspkind.nvim](https://github.com/onsails/lspkind.nvim)
- [vim-lexical](https://github.com/preservim/vim-lexical)
- [vim-pencil](https://github.com/preservim/vim-pencil)
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
- [auto-session](https://github.com/rmagatti/auto-session)
- [barbar.nvim](https://github.com/romgrk/barbar.nvim)
- [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
- [neotest-dart](https://github.com/sidlatau/neotest-dart)
- [inc-rename.nvim](https://github.com/smjonas/inc-rename.nvim/)
- [oil.nvim](https://github.com/stevearc/oil.nvim)
- [telescope-cmake-preset-selector](https://github.com/svenbergner/telescope-cmake-preset-selector)
- [telescope-debugee-selector](https://github.com/svenbergner/telescope-debugee-selector)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)
- [vim-rhubarb](https://github.com/tpope/vim-rhubarb)
- [vim-sleuth](https://github.com/tpope/vim-sleuth)
- [vimwiki](https://github.com/vimwiki/vimwiki)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [copilot.lua](https://github.com/zbirenbaum/copilot.lua/)
 
## Spellchecking

## Syntax Highlighting

