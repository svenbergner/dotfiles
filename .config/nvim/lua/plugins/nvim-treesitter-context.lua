--[===[
Treesitter context
URL: https://github.com/nvim-treesitter/nvim-treesitter-context
--]===]

return {
   "nvim-treesitter/nvim-treesitter-context",
   enabled = true,
   event = "VeryLazy",
   opts = {
      mode = "cursor",
      max_lines = 10,
   },
   keys = {
      {
         "<leader>TC",
         function ()
            local tsc = require("treesitter-context")
            tsc.toggle()
         end,
         desc = "[T]oggle Treesitter [C]ontext",
      }
   },
}
