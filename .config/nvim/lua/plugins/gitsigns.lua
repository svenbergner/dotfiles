return {
   "lewis6991/gitsigns.nvim",
   event = 'VeryLazy',
   config = function()
      require("gitsigns").setup({
         -- See `:help gitsigns.txt`
         signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
         },
         numhl = true, -- Change color of line number
      })
      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[G]it [p]review hunk" })
   end
}
