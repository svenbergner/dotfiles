--[=====[
Integrates lazygit into Neovim
https://github.com/kdheepak/lazygit.nvim
--]=====]

return {
   "kdheepak/lazygit.nvim",
   enabled = false,
   event = 'VeryLazy',
   config = function()
      vim.keymap.set("n", "<leader>gg", ":wa <bar> LazyGit<CR>", { silent = true, desc = "Open LazyGit overlay" })
      vim.keymap.set("n", "<leader><leader>g", ":wa <bar> LazyGit<CR>", { silent = true, desc = "Open LazyGit overlay" })
   end
}
