--[===[
Treesitter configuration
URL: https://github.com/nvim-treesitter/nvim-treesitter
--]===]

return {
   "nvim-treesitter/nvim-treesitter",
   enabled = true,
   build = ":TSUpdate",
   event = { "BufReadPre", "BufNewFile" },
   dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects"
   },
   opts = {
      inlay_hints = {
         inline = true,
      },
      ast = {
         --These require codicons (https://github.com/microsoft/vscode-codicons)
         role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
         },
         kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
         },
      },
   },
   config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
         ensure_installed = {
            "bash",
            "cmake",
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
            "http",
            "javascript",
            "json",
            "kdl",
            "kotlin",
            "lua",
            "luadoc",
            "luap",
            "make",
            "markdown",        -- basic highlighting
            "markdown_inline", -- needed for full highlighting
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
               init_selection = "<C-Enter>",
               node_incremental = "<C-Enter>",
               scope_incremental = "<S-Enter>",
               node_decremental = "<Backspace>",
            },
         },
         auto_install = true,
         sync_install = false,
         highlight = {
            enable = true,
            use_languagetree = true,
         },
         indent = { enable = true },
      })
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldmethod = "expr"
      vim.opt.foldcolumn = "1"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.keymap.set("n", "<CR>", "za", { noremap = true, silent = true, desc = "Toggle current fold" })
   end,
}
