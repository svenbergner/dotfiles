--[===[
Telescope - the swiss army knife for finding things
URL: https://github.com/nvim-telescope/telescope.nvim

Default keybindings:
<C-x> go to file selection as a split
<C-v> go to file selection as a vsplit
<C-t> go to a file in a new tab
--]===]

return {
   {
      "nvim-telescope/telescope.nvim",
      enabled = true,
      dependencies = {
         "nvim-lua/plenary.nvim",
         --[[ telescope-dap.nvim
              Integration for nvim-dap with telescope.nvim.
              Overrides dap internal ui, any dap command, which makes use of
              internal ui, will result in a telescope prompt. ]]
         "nvim-telescope/telescope-dap.nvim",
         { "svenbergner/telescope-debugee-selector",      dev = true },
         { "svenbergner/telescope-cmake-preset-selector", dev = true },
         'piersolenski/telescope-import.nvim',
      },
      config = function()
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
            pickers = {
               find_files = {
                  -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                  find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
               },
            },
            defaults = {
               sorting_strategy = 'ascending',
            },
            extensions = {
               ["import"] = { insert_at_top = false, },
               ["ui-select"] = { require("telescope.themes").get_dropdown({}), },
               ['flutter'] = {},
               ['noice'] = {},
               ['debugee_selector'] = {},
            },
         })
         local builtin = require("telescope.builtin")
         local git_opts = { git_command = { 'git', 'log', '--pretty=format:%h %<(20)%aN  %<(16)%ad  %s', '--date=relative', '--' } }

         vim.keymap.set("n", "<leader>fi", '<cmd>AdvancedGitSearch<cr>', { desc = "Advanced Git Search" })
         vim.keymap.set('n', '<leader>gC', function()
            builtin.git_commits(git_opts)
         end, { desc = "Search all [g]it [C]ommits" })
         vim.keymap.set('n', '<leader>gc', function()
               builtin.git_bcommits(git_opts)
            end,
            { desc = "Search [g]it [c]ommits for Buffer" })


         require("telescope").load_extension("advanced_git_search")
         require("telescope").load_extension("dap")
         require("telescope").load_extension("flutter")
         require("telescope").load_extension("import")
         require("telescope").load_extension("noice")

         -- Personal extensions
         require("telescope").load_extension("cmake_preset_selector")
         require("telescope").load_extension("debugee_selector")
         require('telescope.multigrep').setup()
      end,
   },
}
