--[===[
Advanced git search extension for Telescope and fzf-lua.
Search git history by commit message, content and author in Neovim
URL: https://github.com/aaronhallaert/advanced-git-search.nvim
--]===]

return {
   'aaronhallaert/advanced-git-search.nvim',
   event = 'VeryLazy',
   enabled = true,
   config = function()
      require('telescope').setup {
         extensions = {
            advanced_git_search = {
               -- fugitive or diffview
               diff_plugin = 'diffview',
               -- customize git in previewer
               -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
               git_flags = {},
               -- customize git diff in previewer
               -- e.g. flags such as { "--raw" }
               git_diff_flags = {},
               -- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
               show_builtin_git_pickers = false,
               entry_default_author_or_date = 'author', -- one of "author" or "date"

               -- Telescope layout setup
               telescope_theme = {
                  function_name_1 = {
                     -- Theme options
                  },
                  function_name_2 = 'dropdown',
                  show_custom_functions = {
                     layout_config = { width = 0.4, height = 0.4 },
                  },

               }
            }
         }
      }

      require('telescope').load_extension('advanced_git_search')
      vim.keymap.set("n", "<leader>ga", '<cmd>AdvancedGitSearch<cr>', { desc = "[g]it [a]dvanced search" })
   end,
   dependencies = {
      {
         'nvim-telescope/telescope.nvim',
         'tpope/vim-fugitive',
         'tpope/vim-rhubarb',
         'sindrets/diffview.nvim',
      }
   },
}
