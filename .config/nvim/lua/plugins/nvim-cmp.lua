return {
   "hrsh7th/nvim-cmp",
   dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
   },
   config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      local luasnip = require("luasnip")
      luasnip.config.setup({})
      cmp.setup({
         snippet = {
            expand = function(args)
               luasnip.lsp_expand(args.body)
            end,
         },
         window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
         },
         mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
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
            { name = "luasnip", keyword_length = 2 },
            { name = "buffer",  keyword_length = 3 },
         },
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
         mapping = cmp.mapping.preset.cmdline(),
         sources = {
            { name = 'buffer' }
         }
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
         mapping = cmp.mapping.preset.cmdline(),
         sources = cmp.config.sources({
            { name = 'path' }
         }, {
            {
               name = 'cmdline',
               option = {
                  ignore_cmds = { 'Man', '!' }
               }
            }
         })
      })
   end,
}