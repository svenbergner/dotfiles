return {
   "nvim-treesitter/nvim-treesitter",
   build = ":TSUpdate",
   event = { "BufReadPre", "BufNewFile" },
   config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
         ensure_installed = {
            "lua",
            "vim",
            "vimdoc",
            "bash",
            "dart",
            "html",
            "css",
            "yaml",
            "regex",
            "markdown",
            "markdown_inline",
            "gitignore",
            "dockerfile",
            "cpp",
            "cmake",
            "commonlisp",
            "json",
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
         sync_install = false,
         highlight = { enable = true },
         indent = { enable = true },
      })
      vim.opt.foldlevel = 20
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
   end,
}
