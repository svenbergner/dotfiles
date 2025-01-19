--[===[ Define special keymaps for treesitter textobjects
URL: https://www.github.com/nvim-treesitter/nvim-treesitter-textobjects
--]===]

return {
   "nvim-treesitter/nvim-treesitter-textobjects",
   enabled = true,
   lazy = true,
   config = function()
      require("nvim-treesitter.configs").setup({
         textobjects = {
            select = {
               enable = true,

               -- Automatically jump forward to textobj, similar to targets.vim
               lookahead = true,

               keymaps = {
                  -- You can use capture groups defined in textobjects.scm
                  ["a="] = { query = "@parameter.outer", description = "Select outer part of an assignment" },
                  ["i="] = { query = "@parameter.inner", description = "Select inner part of an assignment" },
                  ["l="] = { query = "@parameter.lhs", description = "Select left hand side of an assignment" },
                  ["r="] = { query = "@parameter.rhs", description = "Select right hand side of an assignment" },
               }
            }
         }
      })
   end
}
