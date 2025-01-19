--[===[
Shows an outline view for the current buffer
URL: https://www.github.com/hedhli/outline.nvim
--]===]

return {
   "hedyhli/outline.nvim",
   enabled = true,
   lazy = true,
   cmd = { "Outline", "OutlineOpen" },
   keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
   },
   opts = {
      -- Your setup opts here
   },
}
