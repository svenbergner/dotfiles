--[===[
Shows a preview of the code action before applying it
https://github.com/aznhe21/actions-preview.nvim
--]===]

return {
   'aznhe21/actions-preview.nvim',
   enabled = true,
   config = function()
      vim.keymap.set(
         { 'v', 'n' },
         '<leader>ca',
         require('actions-preview').code_actions,
         { desc = '[c]ode preview [a]ctions' }
      )

      local hl = require('actions-preview.highlight')
      require('actions-preview').setup({
         highlight_command = {
            hl.delta('delta --no-gitconfig --side-by-side'),
         },
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
   end,
}
