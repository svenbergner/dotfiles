return {
   "nvim-neo-tree/neo-tree.nvim",
   branch = "v3.x",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
      {
         "s1n7ax/nvim-window-picker",
         config = function()
            require("window-picker").setup({
               filter_rules = {
                  include_current_win = false,
                  autoselect_one = true,
                  bo = {
                     filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                     buftype = { 'terminal', 'quickfix' },
                  },
               },
            })
         end
      },
   },
   config = function()
      vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", { silent = true })
      vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", { silent = true })

      require("neo-tree").setup({
         close_if_last_window = true,
         source_selector = {
            winbar = true,
         },
         buffers = {
            follow_current_file = true,
         },
         filesystem = {
            follow_current_file = true,
            filtered_items = {
               hide_dotfiles = true,
               hide_gitignored = false,
               never_show = {
                  ".DS_Store",
                  "thumbs.db"
               },
            },
         },
      })
      -- Reload neo-tree after a file has changed on disk
      require("neo-tree.sources.filesystem.commands").refresh( require("neo-tree.sources.manager") .get_state("filesystem"))
   end,
}
