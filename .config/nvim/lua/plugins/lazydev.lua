--[===[
💻 lazydev.nvim
lazydev.nvim is a plugin that properly configures LuaLS for editing your
Neovim config by lazily updating your workspace libraries.

⚠️ Limitations
If you have files that only use types from a plugin, then those types won't
be available in your workspace.
Completion for module names when typing require(...) will only return loaded
modules in your workspace.
To get around the above, you can: pre-load those plugins with the library option.
Use the nvim-cmp completion source to get all available modules.

URL: https://github.com/folke/lazydev.nvim
--]===]

return {
   {
      "folke/lazydev.nvim",
      enabled = true,
      ft = "lua", -- only load on lua files
      opts = {
         library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
         },
      },
   },
   { "Bilal2453/luvit-meta", lazy = true },
}
