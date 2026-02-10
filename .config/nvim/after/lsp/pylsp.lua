-- Language Server Protocol configuration for pylsp
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#pylsp

return {
   cmd = { "pylsp" },
   filetypes = { "python" },
   settings = {
      pylsp = {
         plugins = {
            pycodestyle = {
               enabled = true,
               ignore = {
                  "E501", -- line too long
                  "E402", -- Module level import not at top of file
               },
               maxLineLength = 120,
            },
            -- pylint = { enabled = true },
            -- flake8 = { enabled = true },
            -- mccabe = { enabled = true },
            -- pyflakes = { enabled = true },
         },
      },
   },
}
