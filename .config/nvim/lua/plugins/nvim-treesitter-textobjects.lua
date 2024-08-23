-- Define special keymaps for treesitter textobjects
return {
   "nvim-treesitter/nvim-treesitter-textobjects",
   lazy = true,
   config = function()
      require("nvim-treesitter.configs").setup({
         --       textobjects = {
         --          select = {
         --             enable = true,
         --
         --             -- Automatically jump forward to textobj, similar to targets.vim
         --             lookahead = true,
         --
         --             keymaps = {
         --                -- You can use capture groups defined in textobjects.scm
         --                ["a="] = { "@parameter.outer", description = "Select outer part of an assignment" },
         --                ["i="] = { "@parameter.inner", description = "Select inner part of an assignment" },
         --                ["l="] = { "@parameter.lhs", description = "Select left hand side of an assignment" },
         --                ["r="] = { "@parameter.rhs", description = "Select right hand side of an assignment" },
         --             }
         --          }
         --       }
      })
   end
}
