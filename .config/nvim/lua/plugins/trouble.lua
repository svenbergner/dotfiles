--[=====[
Trouble
https://github.com/folke/trouble.nvim 
A pretty list for showing diagnostics, references, telescope results,
quickfix and location lists to help you solve all the trouble your code is causing.
--]=====]

return {
   "folke/trouble.nvim",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   cmd = "Trouble",
   keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Symbols (Trouble)" },
   },
   opts = {
      use_diagnostic_signs = true,
      action_keys = {
         close = "q",
         cancel = "<esc>",
         refresh = "r",
         jump = { "<cr>", "<tab>" },
         toggle_mode = "m",
         toggle_preview = "<C-p>",
         preview = "P",
         close_folds = { "zM", "zm" },
         open_folds = { "zR", "zr" },
         toggle_fold = "zA",
      },
   },
}
