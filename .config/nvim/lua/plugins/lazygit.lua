return {
   "kdheepak/lazygit.nvim",
   config = function()
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true, desc = "Open LazyGit overlay" })
      vim.keymap.set("n", "<leader><leader>g", ":LazyGit<CR>", { silent = true, desc = "Open LazyGit overlay" })
   end
}
