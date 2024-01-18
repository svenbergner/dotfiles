return {
   "nvim-neo-tree/neo-tree.nvim",
   branch = "v3.x",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
      "s1n7ax/nvim-window-picker",
   },
   config = function()
      vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", { silent = true })
      vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", { silent = true })

      require("neo-tree").setup({})
   end,
}
