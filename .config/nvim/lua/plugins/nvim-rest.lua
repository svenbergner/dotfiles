--[===[ A very fast, powerful, extensible and asynchronous Neovim HTTP client written in Lua.
URL: https://github.com/rest-nvim/rest.nvim

rest.nvim by default makes use of its own curl wrapper made in pure Lua
and a tree-sitter parser to parse http files. So what you can run get exact
and detailed result what you see from your editor!

In addition to this, you can also write integrations with external
HTTP clients, such as the postman CLI.
--]===]

return {
   "rest-nvim/rest.nvim",
   enabled = false,
}
