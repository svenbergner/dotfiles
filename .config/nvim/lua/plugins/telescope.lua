-- Telescope - the swiss army knife for finding things
return {
   {
      "nvim-telescope/telescope.nvim",
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
         vim.keymap.set('n', '<F12>', builtin.help_tags, { desc = "Find Help Tags" })
         vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = "Find Symbols" })
         vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = "Find Old Files" })
         vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = "Find Word under Cursor" })
         vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = "Search Git Commits" })
         vim.keymap.set('n', '<leader>gb', builtin.git_bcommits, { desc = "Search Git Commits for Buffer" })
         vim.keymap.set('n', '<leader>sj', builtin.jumplist, { desc = "[S]how [J]umplist" })
      end,
   },
   {
      "nanotee/zoxide.vim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "debugloop/telescope-undo.nvim",
      "cljoly/telescope-repo.nvim",
      'dawsers/telescope-floaterm.nvim',
      'LukasPietzschmann/telescope-tabs',
      "svenbergner/telescope-debugee-selector",
      config = function()
         require("telescope").setup({
            extensions = {
               ["ui-select"] = {
                  require("telescope.themes").get_dropdown({}),
               },
               ['flutter'] = {},
               ['noice'] = {},
               ['neoclip'] = {},
               ['undo'] = {},
               ['live_grep_args'] = {},
               ['floaterm'] = {},
               ['repo'] = {
                  list = {
                     fd_opts = {
                        "--no-ignore-vcs",
                     },
                     search_dirs = {
                        "/Users/svenbergner/Repos/",
                     },
                  },
               },
               ['telescope-tabs'] = {},
               ['debugee_selector'] = {},
            },
         })
         require("telescope").load_extension("ui-select")
         require("telescope").load_extension("flutter")
         require("telescope").load_extension("noice")

         require("telescope").load_extension("neoclip")

         vim.g.zoxide_use_select = true

         require("telescope").load_extension("undo")
         require("telescope").load_extension("live_grep_args")
         require("telescope").load_extension("floaterm")
         require("telescope").load_extension("repo")
         require("telescope").load_extension("debugee_selector")
      end,
   },
}
