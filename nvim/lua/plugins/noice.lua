return {
    "folke/noice.nvim",
    config = function()
        require('noice').setup({
            views = {
                cmdline_popup = {
                    position = {
                        row = "30%",
                        column = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                    border = {
                        style = "single",
                        padding = { 0, 1 },
                    },
                    filter_options = {},
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
            },
        })
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
    }
}
