vim.o.background = "dark"

require("lazy").setup( { 
		"ellisonleao/gruvbox.nvim", 
		priority = 1000 , 
		config = true, 
		opts = {
				terminal_colors = true,
		}
})

