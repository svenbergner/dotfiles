--[===[
Better Escape
URL: https://github.com/max397574/better-escape.nvim

A lot of people have mappings like jk or jj to escape insert mode.
The problem with this mappings is that whenever you type a j, neovim wait
about 100-500ms (depending on your timeoutlen) to see, if you type a j or a k
because these are mapped. Only after that time the j will be inserted.
Then you always get a delay when typing a j.
An example where this has a big impact is e.g. telescope.
Because the characters which are mapped aren't really inserted at first the
whole filtering isn't instant.
--]===]

return {
   "max397574/better-escape.nvim",
   enabled = true,
   keys = {
      { "jk", mode = { "i", "c", "t", "s" } },
      { "jj", mode = { "i", "c" } },
   },
   config = function()
      require("better_escape").setup({
         timeout = vim.o.timeoutlen,
         default_mappings = false,
         mappings = {
            i = {
               j = {
                  -- These can all also be functions
                  k = "<Esc>",
                  j = "<Esc>",
               },
            },
            c = {
               j = {
                  k = "<Esc>",
                  j = "<Esc>",
               },
            },
            t = {
               j = {
                  k = "<C-\\><C-n>",
               },
            },
            -- v = {
            --    j = {
            --       k = "<Esc>",
            --    },
            -- },
            s = {
               j = {
                  k = "<Esc>",
               },
            },
         },

      })
   end,
} -- lua, default settings
