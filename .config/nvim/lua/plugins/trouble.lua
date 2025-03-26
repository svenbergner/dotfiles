--[===[
Trouble
A pretty list for showing diagnostics, references, telescope results,
quickfix and location lists to help you solve all the trouble your code is causing.
URL: https://github.com/folke/trouble.nvim
--]===]

return {
   "folke/trouble.nvim",
   enabled = true,
   dependencies = { "nvim-tree/nvim-web-devicons" },
   cmd = "Trouble",
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
