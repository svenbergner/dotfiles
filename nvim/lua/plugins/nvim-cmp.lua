return {
   "hrsh7th/nvim-cmp",
   dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "rafamadriz/friendly-snippets",
   },
   config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})
      cmp.setup({
         snippet = {
            expand = function(args)
               luasnip.lsp_expand(args.body)
            end,
         },
         mapping = cmp.mapping.preset.insert({
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete({}),
            ["<C-CR>"] = cmp.mapping.complete({}),
            ["<CR>"] = cmp.mapping.confirm({
               select = false,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_next_item()
               elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
               else
                  fallback()
               end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_prev_item()
               elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
               else
                  fallback()
               end
            end, { "i", "s" }),
         }),
         sources = {
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "luasnip" },
            { name = "buffer",  keyword_length = 5 },
         },
      })
   end,
}
