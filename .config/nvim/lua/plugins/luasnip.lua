-- Plugin for writing snippets in lua with lsp-support
return {
   "L3MON4D3/LuaSnip",
   event = 'VeryLazy',
   opts = {},
   dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
   },
}
