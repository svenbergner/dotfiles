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
            "commonlisp",
            "cpp",
            "css",
            "dart",
            "dockerfile",
            "git_config",
            "gitignore",
            "html",
            "json",
            "kdl",
            "lua",
            "markdown",
            "markdown_inline",
            "regex",
            "vim",
            "vimdoc",
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
      vim.opt.foldlevel = 20
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
   end,
}
