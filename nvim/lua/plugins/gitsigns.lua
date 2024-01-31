return {
   "lewis6991/gitsigns.nvim",
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
      })
      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[G]it [p]review hunk" })
   end
}
