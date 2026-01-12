--[===[
Advanced git search extension for telescope, fzf-lua and snacks.
Search git history by commit message, content and author in Neovim
URL: https://github.com/aaronhallaert/advanced-git-search.nvim
URL: https://github.com/sindrets/diffview.nvim
--]===]

return {
   'aaronhallaert/advanced-git-search.nvim',
   enabled = true,
   keys = {
      { '<leader>ga' },
   },
   cmd = 'AdvancedGitSearch',
   config = function()
      require('advanced_git_search.snacks').setup({
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
      })

      -- Eigener Keymap für show_custom_functions mit benutzerdefiniertem Layout
      vim.keymap.set('n', '<leader>ga', function()
         local global_picker = require('advanced_git_search.global_picker')
         local keys = global_picker.keys('snacks')
         local items = {}
         for _, key in ipairs(keys) do
            table.insert(items, { text = key })
         end

         Snacks.picker.pick(nil, {
            items = items,
            layout = {
               preset = 'select',
               preview = false,
               layout = {
                  width = 0.4,
                  height = 0.4,
               },
            },
            win = {
               input = {
                  keys = {
                     ['<CR>'] = { 'open_picker', mode = { 'n', 'i' } },
                  },
               },
            },
            actions = {
               open_picker = function(picker, item)
                  picker:close()
                  global_picker.execute_git_function(item.text, 'snacks')
               end,
            },
            format = function(item)
               local ret = {}
               ret[#ret + 1] = { item.text, 'SnacksPickerGitMsg' }
               return ret
            end,
         })
      end, { desc = '[g]it [a]dvanced search' })
   end,
   dependencies = {
      {
         -- 'nvim-telescope/telescope.nvim',
         'folke/snacks.nvim',
         'tpope/vim-fugitive',
         'tpope/vim-rhubarb',
         'sindrets/diffview.nvim',
      },
   },
}
