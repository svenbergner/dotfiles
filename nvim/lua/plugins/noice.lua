return {
    "folke/noice.nvim",
    opts = {
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
    },
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
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify'
    }
}
