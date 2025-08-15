--[===[
Adds custom signs for current git status
URL: https://github.com/lewis6991/gitsigns.nvim
--]===]

return {
   "lewis6991/gitsigns.nvim",
   enabled = true,
   event = 'VeryLazy',
   config = function()
      require("gitsigns").setup({
         -- See `:help gitsigns.txt`
         signs = {
            add = { text = "" },

            change = { text = "" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "" },
         },
         numhl = true, -- Change color of line number
      })
   end
}
