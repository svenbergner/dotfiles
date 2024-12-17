-- Decorations for vimdoc/help files in Neovim.
-- URL: https://github.com/OXY2DEV/helpview.nvim
return {
    "OXY2DEV/helpview.nvim",
    lazy = false, -- Recommended

    -- In case you still want to lazy load
    -- ft = "help",

    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    }
}

