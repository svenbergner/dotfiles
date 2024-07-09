-- Plugin which adds a neat filetree

return {
   "nvim-neo-tree/neo-tree.nvim",
   branch = "v3.x",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim",
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
      vim.keymap.set("n", "<leader><leader>n", ":Neotree filesystem reveal left<CR>:Neotree focus filesystem<CR>",
         { silent = true, desc = "Show Neotree Filesystem" })
      vim.keymap.set("n", "<leader>nn", ":Neotree filesystem reveal left<CR>:Neotree focus filesystem<CR>",
         { silent = true, desc = "Show Neotree Filesystem" })
      vim.keymap.set("n", "<leader>nf", ":Neotree filesystem reveal left<CR>:Neotree focus filesystem<CR>",
         { silent = true, desc = "Show Neotree Filesystem" })
      vim.keymap.set("n", "<leader>nb", ":Neotree buffers reveal left<CR>:Neotree focus buffers<CR>",
         { silent = true, desc = "Show Neotree Buffers" })
      vim.keymap.set("n", "<leader>ng", ":Neotree git_status reveal left<CR>:Neotree focus git_status<CR>",
         { silent = true, desc = "Show Neotree Git Status" })

      require("neo-tree").setup({
         sources = {
            "filesystem",
            "buffers",
            "git_status",
         },
         close_if_last_window = false,
         auto_clean_after_session_restore = true,
         default_source = "filesystem",
         source_selector = {
            winbar = true,
            status_line = true,
            sources = {
               { source = "filesystem" },
               { source = "buffers" },
               { source = "git_status" },
            },
         },
         git_status = {
            follow_current_file = true,
         },
         buffers = {
            follow_current_file = { enabled = true, },
         },
         filesystem = {
            follow_current_file = { enabled = true, },
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
   end,
}
