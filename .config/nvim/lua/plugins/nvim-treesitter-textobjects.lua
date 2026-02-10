--[===[
Define special keymaps for treesitter textobjects
https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--]===]

return {
   'nvim-treesitter/nvim-treesitter-textobjects',
   enabled = true,
   lazy = true,
   branch = 'master',
   debenches = { 'nvim-treesitter/nvim-treesitter' },
   config = function()
      require('nvim-treesitter.configs').setup({
         textobjects = {
            select = {
               enable = true,

               -- Automatically jump forward to textobj, similar to targets.vim
               lookahead = true,

               keymaps = {
                  ['a='] = { query = '@assignment.outer', description = 'Select outer part of an assignment' },
                  ['i='] = { query = '@assignment.inner', description = 'Select inner part of an assignment' },
                  ['l='] = { query = '@assignment.lhs', description = 'Select left hand side of an assignment' },
                  ['r='] = { query = '@assignment.rhs', description = 'Select right hand side of an assignment' },

                  ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
                  ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },

                  ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
                  ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

                  ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
                  ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },

                  ['af'] = { query = '@function.outer', desc = 'Select outer part of a function definition' },
                  ['if'] = { query = '@function.inner', desc = 'Select inner part of a function definition' },

                  ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class region' },
                  ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },

                  ['at'] = { query = '@comment.outer', desc = 'Select outer part of a comment region' },
                  ['it'] = { query = '@comment.inner', desc = 'Select inner part of a comment region' },

                  ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
               },
               -- You can choose the select mode (default is charwise 'v')
               --
               -- Can also be a function which gets passed a table with the keys
               -- * query_string: eg '@function.inner'
               -- * method: eg 'v' or 'o'
               -- and should return the mode ('v', 'V', or '<c-v>') or a table
               -- mapping query_strings to modes.
               selection_modes = {
                  ['@parameter.outer'] = 'v', -- charwise
                  ['@function.outer'] = 'V', -- linewise
                  ['@class.outer'] = '<c-v>', -- blockwise
               },
               -- If you set this to `true` (default is `false`) then any textobject is
               -- extended to include preceding or succeeding whitespace. Succeeding
               -- whitespace has priority in order to act similarly to e.g. the built-in `ap`.
               --
               -- Can also be a function which gets passed a table with the keys
               -- * query_string: e.g. '@function.inner'
               -- * selection_mode: e.g. 'v'
               -- and should return true or false
               include_surrounding_whitespace = true,
            },
            swap = {
               enable = true,
               swap_next = {
                  ['<leader>sp'] = { query = '@parameter.inner', desc = 'Swap with next parameter' },
                  ['<leader>sm'] = { query = '@function.outer', desc = 'Swap with next function' },
               },
               swap_previous = {
                  ['<leader>sP'] = { query = '@parameter.inner', desc = 'Swap with previous parameter' },
                  ['<leader>sM'] = { query = '@function.outer', desc = 'Swap with previous function' },
               },
            },
            move = {
               enable = true,
               set_jumps = true, -- whether to set jumps in the jumplist
               goto_next_start = {
                  ['>f'] = { query = '@call.outer', desc = 'Go to next start of a function call' },
                  ['>m'] = { query = '@function.outer', desc = 'Go to next start of a function' },
                  ['>c'] = { query = '@class.outer', desc = 'Go to next start of a class' },
                  ['>i'] = { query = '@conditional.outer', desc = 'Go to next start of a conditional' },
                  ['>l'] = { query = '@loop.outer', desc = 'Go to next start of a loop' },
                  ['>s'] = { query = '@scope', query_group = 'locals', desc = 'Go to next start of a language scope' },
                  ['>z'] = { query = '@fold', query_group = 'folds', desc = 'Go to next fold' },
               },
               goto_next_end = {
                  ['>F'] = { query = '@call.outer', desc = 'Go to next end of a function call' },
                  ['>M'] = { query = '@function.outer', desc = 'Go to next end of a function' },
                  ['>C'] = { query = '@class.outer', desc = 'Go to next end of a class' },
                  ['>I'] = { query = '@conditional.outer', desc = 'Go to next end of a conditional' },
                  ['>L'] = { query = '@loop.outer', desc = 'Go to next end of a loop' },
                  ['>S'] = { query = '@scope', query_group = 'locals', desc = 'Go to next end of a language scope' },
                  ['>Z'] = { query = '@fold', query_group = 'folds', desc = 'Go to end fold' },
               },
               goto_previous_start = {
                  ['<f'] = { query = '@call.outer', desc = 'Go to previous start of a function call' },
                  ['<m'] = { query = '@function.outer', desc = 'Go to previous start of a function' },
                  ['<c'] = { query = '@class.outer', desc = 'Go to previous start of a class' },
                  ['<i'] = { query = '@conditional.outer', desc = 'Go to previous start of a conditional' },
                  ['<l'] = { query = '@loop.outer', desc = 'Go to previous start of a loop' },
                  ['<s'] = {
                     query = '@scope',
                     query_group = 'locals',
                     desc = 'Go to previous start of a language scope',
                  },
                  ['<z'] = { query = '@fold', query_group = 'folds', desc = 'Go to previous fold' },
               },
               goto_previous_end = {
                  ['<F'] = { query = '@call.outer', desc = 'Go to previous end of a function call' },
                  ['<M'] = { query = '@function.outer', desc = 'Go to previous end of a function' },
                  ['<C'] = { query = '@class.outer', desc = 'Go to previous end of a class' },
                  ['<I'] = { query = '@conditional.outer', desc = 'Go to previous end of a conditional' },
                  ['<L'] = { query = '@loop.outer', desc = 'Go to previous end of a loop' },
                  ['<S'] = { query = '@scope', query_group = 'locals', desc = 'Go to previous end of a language scope' },
                  ['<Z'] = { query = '@fold', query_group = 'folds', desc = 'Go to end of previous fold' },
               },
            },
         },
      })

      local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

      -- vim way: use `;` and `,` to move to the next/previous textobj
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move)
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_opposite)

      -- optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr)
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr)
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr)
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr)
   end,
}
