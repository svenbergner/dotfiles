-- Integrates lazygit into Neovim
return {
   "kdheepak/lazygit.nvim",
   event = 'VeryLazy',
   config = function()
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true, desc = "Open LazyGit overlay" })
      vim.keymap.set("n", "<leader><leader>g", ":LazyGit<CR>", { silent = true, desc = "Open LazyGit overlay" })
   end
}
