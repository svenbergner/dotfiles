-- Integrates lazygit into Neovim
return {
   "kdheepak/lazygit.nvim",
   event = 'VeryLazy',
   config = function()
      vim.keymap.set("n", "<leader>gg", ":wa <bar> LazyGit<CR>", { silent = true, desc = "Open LazyGit overlay" })
      vim.keymap.set("n", "<leader><leader>g", ":wa <bar> LazyGit<CR>", { silent = true, desc = "Open LazyGit overlay" })
   end
}
