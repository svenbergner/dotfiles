# My Neovim Config

*IMPORTANT:* This is my personal neovim config and is in no way intended to be
used by someone else without knowing what it does. 
It is a collection of plugins and settings that I like to use. Take it as an
inspiration or a starting point for your own config.
**Use at your own risk!**

The whole config is written in lua. Based on Folkes lazy.nvim package manager.
And using a lot of his plugins as well.

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

- [actions-preview.nvim](https://github.com/aznhe21/actions-preview.nvim)
- [advanced-git-search.nvim](https://github.com/aaronhallaert/advanced-git-search.nvim)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
- [tpope/vim-rhubarb](https://github.com/tpope/vim-rhubarb)
- [rmagatti/auto-session](https://github.com/rmagatti/auto-session)
- [m4xshen/autoclose.nvim](https://github.com/m4xshen/autoclose.nvim)
- [romgrk/barbar.nvim](https://github.com/romgrk/barbar.nvim)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [LunarVim/bigfile.nvim](https://github.comLunarVim/bigfile.nvim/)
- [ellisonleao/gruvbox.nvim](https://github.comellisonleao/gruvbox.nvim/)
- [numToStr/Comment.nvim](https://github.comnumToStr/Comment.nvim/)
- [folke/flash.nvim](https://github.comfolke/flash.nvim/)
- [akinsho/flutter-tools.nvim](https://github.comakinsho/flutter-tools.nvim/)
- [f-person/git-blame.nvim](https://github.comf-person/git-blame.nvim/)
- [zbirenbaum/copilot.lua](https://github.comzbirenbaum/copilot.lua/)
- [lewis6991/gitsigns.nvim](https://github.comlewis6991/gitsigns.nvim/)
- [ThePrimeagen/harpoon](https://github.comThePrimeagen/harpoon/)
- [nvim-lua/plenary.nvim](https://github.comnvim-lua/plenary.nvim/)
- [nvim-telescope/telescope.nvim](https://github.comnvim-telescope/telescope.nvim/)
- [3rd/image.nvim](https://github.com3rd/image.nvim/)
- [smjonas/inc-rename.nvim](https://github.comsmjonas/inc-rename.nvim/)
- [lukas-reineke/indent-blankline.nvim](https://github.comlukas-reineke/indent-blankline.nvim/)
- [haya14busa/is.vim](https://github.comhaya14busa/is.vim/)
- [folke/lazydev.nvim](https://github.comfolke/lazydev.nvim/)
- [Bilal2453/luvit-meta](https://github.comBilal2453/luvit-meta/)
- [hrsh7th/nvim-cmp](https://github.comhrsh7th/nvim-cmp/)
- [onsails/lspkind.nvim](https://github.com/onsails/lspkind.nvim)
- [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
- [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path)
- [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
- [hrsh7th/cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- [saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [NvChad/nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [nvim-neotest/nvim-nio](https://github.com/nvim-neotest/nvim-nio)
- [rcarriga/nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- [leoluz/nvim-dap-go](https://github.com/leoluz/nvim-dap-go)
- [svenbergner/telescope-debugee-selector](https://github.com/svenbergner/telescope-debugee-selector)
- [nvim-neotest/neotest](https://github.com/nvim-neotest/neotest)
- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [nvim-neotest/nvim-nio](https://github.com/nvim-neotest/nvim-nio)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [antoinemadec/FixCursorHold.nvim](https://github.com/antoinemadec/FixCursorHold.nvim)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [sidlatau/neotest-dart](https://github.com/sidlatau/neotest-dart)
- [michaelrommel/nvim-silicon](https://github.com/michaelrommel/nvim-silicon)
- [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)
- [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [hedyhli/outline.nvim](https://github.com/hedyhli/outline.nvim)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [mrjones2014/smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [joshmedeski/telescope-smart-goto.nvim](https://github.com/joshmedeski/telescope-smart-goto.nvim)
- [nvim-telescope/telescope-dap.nvim](https://github.com/nvim-telescope/telescope-dap.nvim)
- [nanotee/zoxide.vim](https://github.com/nanotee/zoxide.vim)
- [nvim-telescope/telescope-live-grep-args.nvim](https://github.com/nvim-telescope/telescope-live-grep-args.nvim)
- [nvim-telescope/telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim)
- [debugloop/telescope-undo.nvim](https://github.com/debugloop/telescope-undo.nvim)
- [cljoly/telescope-repo.nvim](https://github.com/cljoly/telescope-repo.nvim)
- [dawsers/telescope-floaterm.nvim](https://github.com/dawsers/telescope-floaterm.nvim)
- [LukasPietzschmann/telescope-tabs](https://github.com/LukasPietzschmann/telescope-tabs)
- [svenbergner/telescope-debugee-selector](https://github.com/svenbergner/telescope-debugee-selector)
- [svenbergner/telescope-cmake-preset-selector](https://github.com/svenbergner/telescope-cmake-preset-selector)
- [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [folke/twilight.nvim](https://github.com/folke/twilight.nvim)
- [mbbill/undotree](https://github.com/mbbill/undotree)
- [chrisbra/unicode.vim](https://github.com/chrisbra/unicode.vim)
- [preservim/vim-lexical](https://github.com/preservim/vim-lexical)
- [preservim/vim-pencil](https://github.com/preservim/vim-pencil)
- [RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [tpope/vim-sleuth](https://github.com/tpope/vim-sleuth)
- [vimwiki/vimwiki](https://github.com/vimwiki/vimwiki)
- [mattn/calendar-vim](https://github.com/mattn/calendar-vim)
- [lukas-reineke/virt-column.nvim](https://github.com/lukas-reineke/virt-column.nvim)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
- [echasnovski/mini.icons](https://github.com/echasnovski/mini.icons)
- [cuducos/yaml.nvim](https://github.com/cuducos/yaml.nvim)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [folke/zen-mode.nvim](https://github.com/folke/zen-mode.nvim)

## Spellchecking

## Syntax Highlighting

