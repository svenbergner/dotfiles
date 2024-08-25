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

- [3rd/image.nvim](https://github.com3rd/image.nvim/)
- [Bilal2453/luvit-meta](https://github.com/Bilal2453/luvit-meta/)
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- [LukasPietzschmann/telescope-tabs](https://github.com/LukasPietzschmann/telescope-tabs)
- [LunarVim/bigfile.nvim](https://github.com/LunarVim/bigfile.nvim/)
- [NvChad/nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
- [RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon)
- [actions-preview.nvim](https://github.com/aznhe21/actions-preview.nvim)
- [advanced-git-search.nvim](https://github.com/aaronhallaert/advanced-git-search.nvim)
- [akinsho/flutter-tools.nvim](https://github.com/akinsho/flutter-tools.nvim/)
- [antoinemadec/FixCursorHold.nvim](https://github.com/antoinemadec/FixCursorHold.nvim)
- [chrisbra/unicode.vim](https://github.com/chrisbra/unicode.vim)
- [cljoly/telescope-repo.nvim](https://github.com/cljoly/telescope-repo.nvim)
- [cuducos/yaml.nvim](https://github.com/cuducos/yaml.nvim)
- [dawsers/telescope-floaterm.nvim](https://github.com/dawsers/telescope-floaterm.nvim)
- [debugloop/telescope-undo.nvim](https://github.com/debugloop/telescope-undo.nvim)
- [echasnovski/mini.icons](https://github.com/echasnovski/mini.icons)
- [ellisonleao/gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim/)
- [f-person/git-blame.nvim](https://github.com/f-person/git-blame.nvim/)
- [folke/flash.nvim](https://github.comfolke/flash.nvim/)
- [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim/)
- [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)
- [folke/twilight.nvim](https://github.com/folke/twilight.nvim)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
- [folke/zen-mode.nvim](https://github.com/folke/zen-mode.nvim)
- [haya14busa/is.vim](https://github.com/haya14busa/is.vim/)
- [hedyhli/outline.nvim](https://github.com/hedyhli/outline.nvim)
- [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
- [hrsh7th/cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
- [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
- [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path)
- [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp/)
- [joshmedeski/telescope-smart-goto.nvim](https://github.com/joshmedeski/telescope-smart-goto.nvim)
- [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)
- [leoluz/nvim-dap-go](https://github.com/leoluz/nvim-dap-go)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim/)
- [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim/)
- [lukas-reineke/virt-column.nvim](https://github.com/lukas-reineke/virt-column.nvim)
- [m4xshen/autoclose.nvim](https://github.com/m4xshen/autoclose.nvim)
- [mattn/calendar-vim](https://github.com/mattn/calendar-vim)
- [mbbill/undotree](https://github.com/mbbill/undotree)
- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [michaelrommel/nvim-silicon](https://github.com/michaelrommel/nvim-silicon)
- [mrjones2014/smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)
- [nanotee/zoxide.vim](https://github.com/nanotee/zoxide.vim)
- [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim/)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [nvim-neotest/neotest](https://github.com/nvim-neotest/neotest)
- [nvim-neotest/nvim-nio](https://github.com/nvim-neotest/nvim-nio)
- [nvim-telescope/telescope-dap.nvim](https://github.com/nvim-telescope/telescope-dap.nvim)
- [nvim-telescope/telescope-live-grep-args.nvim](https://github.com/nvim-telescope/telescope-live-grep-args.nvim)
- [nvim-telescope/telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [onsails/lspkind.nvim](https://github.com/onsails/lspkind.nvim)
- [preservim/vim-lexical](https://github.com/preservim/vim-lexical)
- [preservim/vim-pencil](https://github.com/preservim/vim-pencil)
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [rcarriga/nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
- [rmagatti/auto-session](https://github.com/rmagatti/auto-session)
- [romgrk/barbar.nvim](https://github.com/romgrk/barbar.nvim)
- [saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
- [sidlatau/neotest-dart](https://github.com/sidlatau/neotest-dart)
- [smjonas/inc-rename.nvim](https://github.com/smjonas/inc-rename.nvim/)
- [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)
- [svenbergner/telescope-cmake-preset-selector](https://github.com/svenbergner/telescope-cmake-preset-selector)
- [svenbergner/telescope-debugee-selector](https://github.com/svenbergner/telescope-debugee-selector)
- [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
- [tpope/vim-rhubarb](https://github.com/tpope/vim-rhubarb)
- [tpope/vim-sleuth](https://github.com/tpope/vim-sleuth)
- [vimwiki/vimwiki](https://github.com/vimwiki/vimwiki)
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua/)
 
## Spellchecking

## Syntax Highlighting

