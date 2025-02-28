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
                  ["af"] = "@function.outer",
                  ["if"] = "@function.inner",
                  ["ac"] = "@class.outer",
                  -- You can optionally set descriptions to the mappings (used in the desc parameter of
                  -- nvim_buf_set_keymap) which plugins like which-key display
                  ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                  -- You can also use captures from other query groups like `locals.scm`
                  ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                  -- You can use capture groups defined in textobjects.scm
                  ["a="] = { query = "@parameter.outer", description = "Select outer part of an assignment" },
                  ["i="] = { query = "@parameter.inner", description = "Select inner part of an assignment" },
                  ["l="] = { query = "@parameter.lhs", description = "Select left hand side of an assignment" },
                  ["r="] = { query = "@parameter.rhs", description = "Select right hand side of an assignment" },
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
               -- whitespace has priority in order to act similarly to eg the built-in
               -- `ap`.
               --
               -- Can also be a function which gets passed a table with the keys
               -- * query_string: eg '@function.inner'
               -- * selection_mode: eg 'v'
               -- and should return true or false
               include_surrounding_whitespace = true,
            },
            swap = {
               enable = true,
               swap_next = {
                  ["<leader>sp"] = "@parameter.inner",
               },
               swap_previous = {
                  ["<leader>sP"] = "@parameter.inner",
               },
            }
         }
      })
   end
}
