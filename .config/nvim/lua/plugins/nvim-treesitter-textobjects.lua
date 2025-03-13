--[===[
Define special keymaps for treesitter textobjects

URL: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--]===]

return {
   "nvim-treesitter/nvim-treesitter-textobjects",
   enabled = true,
   lazy = true,
   debenches = { "nvim-treesitter/nvim-treesitter" },
   config = function()
      require("nvim-treesitter.configs").setup({
         textobjects = {
            select = {
               enable = true,

               -- Automatically jump forward to textobj, similar to targets.vim
               lookahead = true,

               keymaps = {
                  -- You can use the capture groups defined in textobjects.scm
                  ["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
                  ["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },
                  -- You can optionally set descriptions to the mappings (used in the desc parameter of
                  -- nvim_buf_set_keymap) which plugins like which-key display
                  ["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
                  ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                  -- You can also use captures from other query groups like `locals.scm`
                  ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                  -- You can use capture groups defined in textobjects.scm
                  ["a="] = { query = "@assignment.outer", description = "Select outer part of an assignment" },
                  ["i="] = { query = "@assignment.inner", description = "Select inner part of an assignment" },
                  ["l="] = { query = "@assignment.lhs", description = "Select left hand side of an assignment" },
                  ["r="] = { query = "@assignment.rhs", description = "Select right hand side of an assignment" },
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
                  ['@function.outer'] = 'V',  -- linewise
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
                  ["<leader>sp"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
               },
               swap_previous = {
                  ["<leader>sP"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
               },
            }
         }
      })
   end
}
