return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
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
