--[===[
Trouble
URL: https://www.github.com/folke/trouble.nvim
A pretty list for showing diagnostics, references, telescope results,
quickfix and location lists to help you solve all the trouble your code is causing.
--]===]

return {
   "folke/trouble.nvim",
   enabled = true,
   dependencies = { "nvim-tree/nvim-web-devicons" },
   cmd = "Trouble",
   keys = {
      { "<leader><leader>td", "<cmd>Trouble diagnostics toggle<CR>",                        desc = "Diagnostics (Trouble)" },
      { "<leader><leader>tD", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",           desc = "Buffer Diagnostics (Trouble)" },
      { "<leader><leader>tl", "<cmd>Trouble loclist toggle<CR>",                            desc = "Location List (Trouble)" },
      { "<leader><leader>tq", "<cmd>Trouble qflist toggle<CR>",                             desc = "Quickfix List (Trouble)" },
      { "<leader><leader>ts", "<cmd>Trouble symbols toggle focus=false<CR>",                desc = "Symbols (Trouble)" },
      { "<leader><leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Symbols (Trouble)" },
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
