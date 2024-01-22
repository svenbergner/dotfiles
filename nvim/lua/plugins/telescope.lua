return {
   {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.4",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
         local builtin = require("telescope.builtin")
         vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
         vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
         vim.keymap.set("n", "<leader>?", builtin.keymaps, { desc = "Show all keymaps" })
      end,
   },
   {
      "nvim-telescope/telescope-ui-select.nvim",
      config = function()
         require("telescope").setup({
            extensions = {
               ["ui-select"] = {
                  require("telescope.themes").get_dropdown({}),
               },
            },
         })
         require("telescope").load_extension("ui-select")
         require("telescope").load_extension("flutter")
         require("telescope").load_extension("noice")
      end,
   },
   {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
         return vim.fn.executable 'make' == 1
      end,
   },
   {
      'LukasPietzschmann/telescope-tabs',
      dependencies = { 'nvim-telescope/telescope.nvim' },
      config = function()
         require('telescope-tabs').setup()
      end
   },
}
