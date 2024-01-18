return {
   "kdheepak/lazygit.nvim",
   config = function()
      vim.keymap.set("n", "<LEADER>gg", ":LazyGit<CR>", { silent = true, desc = "Open LazyGit overlay" })
   end
}
