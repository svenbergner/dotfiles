-- Snipe.nvim is selection menu that can accept any list of items and present
-- a user interface with quick minimal character navigation hints to select
-- exactly what you want. It is not flashy it is just fast !
-- https://github.com/leath-dub/snipe.nvim

return {
   "leath-dub/snipe.nvim",
   keys = {
      {
         "<leader>gb", function() require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu"
      }
   },
   opts = {}
}
