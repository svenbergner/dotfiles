-- A pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists to help you solve all the trouble your code is causing.
return {
   "folke/trouble.nvim",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   cmd = { "TroubleToggle", "Trouble" },
   keys = {
      { "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "Workspace Diagnostics" },
      { "<leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<CR>", desc = "Lsp Workspace Diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle lsp_document_diagnostics<CR>", desc = "Lsp Document Diagnostics" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", desc = "Quickfix" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "loclist" },
      { "gR", "<cmd>TroubleToggle lsp_references<CR>", desc = "Lsp References" },
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
