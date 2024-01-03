return {
	"VonHeikemen/fine-cmdline.nvim",
	dependencies = {
		{ "MunifTanjim/nui.nvim" },
	},
    config = function ()
        require('fine-cmdline').setup({
            popup = {
                position = {
                    row = "30%",
                },
                border = {
                    text = {
                        top = "CmdLine",
                        top_align = "center",
                    }
                }
            }
        })
        vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})
    end
}
