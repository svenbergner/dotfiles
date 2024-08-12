-- Telescope - the swiss army knife for finding things
return {
   {
      "nvim-telescope/telescope.nvim",
      dependencies = {
         "ThePrimeagen/harpoon",
         "nvim-lua/plenary.nvim",
         "joshmedeski/telescope-smart-goto.nvim",
         "nvim-telescope/telescope-dap.nvim",
      },
      config = function()
         require("telescope").setup({
            defaults = {
               sorting_strategy = 'ascending',
            }
         })
         local builtin = require("telescope.builtin")
         vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[f]ind all [k]eymaps" })
         vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
         vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = "Resume last search" })
         vim.keymap.set('n', '<leader>fg', "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
            { desc = "Live Grep" })
         vim.keymap.set('n', '<leader>fc',
            '<cmd>lua require("telescope.builtin").live_grep({ glob_pattern = "!{spec,test}"})<CR>',
            { desc = "Live Grep Code" })

         vim.keymap.set('n', '<leader>fb', function()
            local function mapping(prompt_bufnr, map)
               local delete_buf = function()
                  local selection = require('telescope.actions.state').get_selected_entry()
                  require('telescope.actions').close(prompt_bufnr)
                  vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                  require('telescope.builtin').buffers { attach_mappings = mapping }
               end
               map('i', '<C-x>', delete_buf)
               return true
            end
            builtin.buffers { attach_mappings = mapping }
         end, { desc = "[f]ind [b]uffers" })

         vim.keymap.set("n", "<leader>/", function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
               winblend = 10,
               previewer = false,
               layout_config = { width = 0.7 },
            }))
         end, { desc = "[/] Fuzzily search in current buffer" })

         vim.keymap.set("n", "<leader>fi", '<cmd>AdvancedGitSearch<cr>', { desc = "Advanced Git Search" })
         vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find Help Tags" })
         vim.keymap.set('n', '<F12>', builtin.help_tags, { desc = "Find Help Tags" })
         vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = "Find Symbols" })
         vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = "Find Old Files" })
         vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = "Find Word under Cursor" })
         vim.keymap.set('n', '<leader>gC', builtin.git_commits, { desc = "Search all [g]it [C]ommits" })
         vim.keymap.set('n', '<leader>gc', builtin.git_bcommits, { desc = "Search [g]it [c]ommits for Buffer" })
         vim.keymap.set('n', '<leader>Gb', builtin.git_branches, { desc = '[G]it [b]ranches' })
         vim.keymap.set('n', '<leader>sj', builtin.jumplist, { desc = "[S]how [J]umplist" })
         vim.keymap.set('n', '<leader>df', require('telescope.builtin').filetypes, { desc = '[D]ocument [f]iletype' })
         vim.keymap.set('n', '<leader>fa', "<cmd>Telescope autocommands<CR>", { desc = '[f]ind [a]utocommands' })
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
      { "svenbergner/telescope-debugee-selector", dev = true },
      { "svenbergner/telescope-cmake-preset-selector", dev = true },

      config = function()
         local telescopeConfig = require("telescope.config")

         -- Clone the default Telescope configuration
         local vimgrep_arguments = { table.unpack(telescopeConfig.values.vimgrep_arguments) }

         -- I want to search in hidden/dot files.
         table.insert(vimgrep_arguments, "--hidden")
         -- I don't want to search in the `.git` directory.
         table.insert(vimgrep_arguments, "--glob")
         table.insert(vimgrep_arguments, "!**/.git/*")

         local actions = require("telescope.actions")

         local select_one_or_multi = function(prompt_bufnr)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            local multi = picker:get_multi_selection()
            if not vim.tbl_isempty(multi) then
               require("telescope.actions").close(prompt_bufnr)
               for _, j in pairs(multi) do
                  if j.path ~= nil then
                     vim.cmd(string.format("%s %s", "edit", j.path))
                  end
               end
            else
               actions.select_default(prompt_bufnr)
            end
         end
         require("telescope").setup({
            defaults = {
               -- `hidden = true` is not supported in text grep commands.
               vimgrep_arguments = vimgrep_arguments,
               path_display = { "truncate" },
               mappings = {
                  n = {
                     ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
                  },
                  i = {
                     ["<C-j>"] = actions.cycle_history_next,
                     ["<C-k>"] = actions.cycle_history_prev,
                     ["<CR>"] = select_one_or_multi,
                     ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
                     ["<C-S-d>"] = actions.delete_buffer,
                     ["<C-s>"] = actions.cycle_previewers_next,
                     ["<C-a>"] = actions.cycle_previewers_prev,
                  },
               },
            },
            pickers = {
               find_files = {
                  -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                  find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
               },
            },
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
                        "/Users/sven.bergner/Repos/",
                     },
                  },
               },
               ['telescope-tabs'] = {},
               ['debugee_selector'] = {},
            },
         })


         require("telescope").load_extension("neoclip")

         require("telescope").load_extension("fzf")

         require("telescope").load_extension("ui-select")
         vim.g.zoxide_use_select = true

         require("telescope").load_extension("flutter")

         require("telescope").load_extension("undo")
         require("telescope").load_extension("dap")
         require("telescope").load_extension("live_grep_args")
         require("telescope").load_extension("floaterm")
         require("telescope").load_extension("repo")
         require("telescope").load_extension("debugee_selector")
         require("telescope").load_extension("noice")
         require("telescope").load_extension("advanced_git_search")
      end,
   },
}
