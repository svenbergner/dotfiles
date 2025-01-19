--[====[
Adds custom signs for current git status
--]====]

return {
   "lewis6991/gitsigns.nvim",
   enabled = true,
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
      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[g]it [p]review hunk" })
      vim.keymap.set("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "[g]it [s]tage hunk" })
   end
}
