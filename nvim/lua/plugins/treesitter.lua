return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = { "lua", "vim", "bash", "dart", "html", "css", "yaml" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
        vim.opt.foldlevel = 20
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
}
