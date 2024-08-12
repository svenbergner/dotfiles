-- A completion engine plugin for neovim written in Lua.
-- Completion sources are installed from external repositories and "sourced".
return {
   "hrsh7th/nvim-cmp",
   lazy = false,
   priority = 100,
   dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
   },
   config = function()
      vim.opt.completeopt = { "menu", "menuone", "preview" }
      vim.opt.shortmess:append("c")

      local lspkind = require("lspkind")

      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      local luasnip = require("luasnip")

      local has_words_before = function()
         if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then return false end
         local line, col = unpack(vim.api.nvim_win_get_cursor(0))
         return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

      local types = require "luasnip.util.types"
      luasnip.config.setup({
         ext_opts = {
            [types.choiceNode] = {
               active = { virt_text = { { "⇥", "GruvboxRed" } }, },
            },
            [types.insertNode] = {
               active = { virt_text = { { "⇥", "GruvboxBlue" } }, },
            },
         }
      })
      cmp.setup({
         formatting = {
            format = lspkind.cmp_format({
               mode = "symbol_text",
               maxwidth = 120,
               ellipsis_char = '...',
               show_labelDetails = true,
               symbol_map = { Copilot = "" },
            })
         },
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
               if cmp.visible() and has_words_before() then
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
         sorting = {
            priority_weight = 2,
            comparators = {
               require("copilot_cmp.comparators").prioritize,
               -- Below is the default comparitor list and order for nvim-cmp
               cmp.config.compare.offset,
               -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
               cmp.config.compare.exact,
               cmp.config.compare.score,
               cmp.config.compare.recently_used,
               cmp.config.compare.locality,
               cmp.config.compare.kind,
               cmp.config.compare.sort_text,
               cmp.config.compare.length,
               cmp.config.compare.order,
            }
         },
         sources = {
            { name = "copilot" },
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "luasnip" },
            { name = "buffer" },
         },
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
         mapping = cmp.mapping.preset.cmdline(),
         sources = {
            { name = 'buffer' },
            { name = 'path' },
            { name = 'file' }
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
