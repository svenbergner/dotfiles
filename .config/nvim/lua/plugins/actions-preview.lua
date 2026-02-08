--[===[
Shows a preview of the code action before applying it
URL: https://github.com/aznhe21/actions-preview.nvim
--]===]

return {
   'aznhe21/actions-preview.nvim',
   keys = { 'ca', mode = { 'n', 'v' } },
   enabled = true,
   config = function()
      vim.keymap.set({ 'v', 'n' }, 'ca', require('actions-preview').code_actions, { desc = 'Preview [c]ode [a]ctions' })

      require('actions-preview').setup({
         telescope = {
            sorting_strategy = 'ascending',
            layout_strategy = 'vertical',
            layout_config = {
               width = 0.8,
               height = 0.9,
               prompt_position = 'top',
               preview_cutoff = 20,
               preview_height = function(_, _, max_lines)
                  return max_lines - 15
               end,
            },
         },
      })

      local hl = require('actions-preview.highlight')
      require('actions-preview').setup({
         highlight_command = {
            -- Highlight diff using delta: https://github.com/dandavison/delta
            -- The argument is optional, in which case "delta" is assumed to be specified.
            -- hl.delta("path/to/delta --option1 --option2"),
            -- You may need to specify "--no-gitconfig" since it is dependent on
            -- the gitconfig of the project by default.
            hl.delta('delta --no-gitconfig --side-by-side'),

            -- Functions can also be specified for items. Functions are executed during setup.
            -- This is useful for `require(...)` at definition time, such as in lazy.nvim.
            function()
               return require('actions-preview.highlight').delta()
            end,
         },
      })
   end,
}
