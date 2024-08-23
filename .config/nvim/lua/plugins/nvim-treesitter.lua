-- Treesitter configuration
return {
   "nvim-treesitter/nvim-treesitter",
   build = ":TSUpdate",
   event = { "BufReadPre", "BufNewFile" },
   config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
         ensure_installed = {
            "bash",
            "cmake",
            "clojure",
            "commonlisp",
            "cpp",
            "css",
            "csv",
            "dart",
            "diff",
            "dockerfile",
            "editorconfig",
            "elixir",
            "erlang",
            "git_config",
            "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "go",
            "html",
            "javascript",
            "json",
            "kdl",
            "kotlin",
            "lua",
            "luadoc",
            "luap",
            "make",
            "markdown",
            "markdown_inline",
            "ninja",
            "nix",
            "python",
            "regex",
            "rust",
            "toml",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
         },
         incremental_selection = {
            enable = true,
            keymaps = {
               init_selection = "<C-space>",
               node_incremental = "sn",
               scope_incremental = "sc",
               node_decremental = "<bs>",
            },
         },
         auto_install = true,
         sync_install = false,
         highlight = { enable = true },
         indent = { enable = true },
      })
      vim.opt.foldlevel = 99
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
   end,
}
