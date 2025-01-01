-- A vim-vinegar like file explorer that lets you edit your filesystem
-- like a normal Neovim buffer.
return {
   "stevearc/oil.nvim",
   enabled = false,
   opts = {},
   dependencies = {
      "nvim-tree/nvim-web-devicons",
   },
   config = function()
      require("oil").setup({
         default_file_explorer = false,
         columns = {
            "icon",
         }
      })
      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

      -- Open parent directory in floating window
      vim.keymap.set("n", "<leader>-", require('oil').toggle_float,
         { desc = "Open parent directory in a floating window" })
   end
}
