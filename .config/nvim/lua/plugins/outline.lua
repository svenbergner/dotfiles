--[===[
Shows an outline view for the current buffer
URL: https://github.com/hedyhli/outline.nvim
--]===]

return {
   "hedyhli/outline.nvim",
   enabled = true,
   lazy = true,
   cmd = { "Outline", "OutlineOpen" },
   keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
   },
   opts = {},
}
