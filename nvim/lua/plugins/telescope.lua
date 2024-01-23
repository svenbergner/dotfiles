return {
   {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.4",
      dependencies = {
         "nvim-lua/plenary.nvim",
      },
      config = function()
         local builtin = require("telescope.builtin")
         vim.keymap.set("n", "<leader>?", builtin.keymaps, { desc = "Show all keymaps" })
         vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
         vim.keymap.set('n', '<leader>fg', "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
            { desc = "Live Grep" })
         vim.keymap.set('n', '<leader>fc',
            '<cmd>lua require("telescope.builtin").live_grep({ glob_pattern = "!{spec,test}"})<CR>',
            { desc = "Live Grep Code" })
         vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
         vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find Help Tags" })
         vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = "Find Symbols" })
         vim.keymap.set('n', '<leader>fi', '<cmd>AdvancedGitSearch<CR>', { desc = "AdvancedGitSearch" })
         vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = "Find Old Files" })
         vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = "Find Word under Cursor" })
         vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = "Search Git Commits" })
         vim.keymap.set('n', '<leader>gb', builtin.git_bcommits, { desc = "Search Git Commits for Buffer" })
      end,
   },
   {
      "nanotee/zoxide.vim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "debugloop/telescope-undo.nvim",
      "aaronhallaert/advanced-git-search.nvim",
      config = function()
         require("telescope").setup({
            extensions = {
               advanced_git_search = {

               },
               ["ui-select"] = {
                  require("telescope.themes").get_dropdown({}),
               },
            },
         })
         require("telescope").load_extension("ui-select")
         require("telescope").load_extension("flutter")
         require("telescope").load_extension("noice")

         require("telescope").load_extension("neoclip")
         require("telescope").load_extension("fzf")

         vim.g.zoxide_use_select = true

         require("telescope").load_extension("undo")
         require("telescope").load_extension("advanced_git_search")
         require("telescope").load_extension("live_grep_args")
      end,
      dependencies = {
         "nvim-telescope/telescope.nvim",
         "tpope/vim-fugitive",
         "tpope/vim-rhubarb",
      }
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
