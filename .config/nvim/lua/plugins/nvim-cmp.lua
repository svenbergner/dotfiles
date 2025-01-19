--[====[
An autocompletion engine plugin for neovim written in Lua.
Completion sources are installed from external repositories and "sourced".
URL: https://www.github.com/hrsh7th/nvim-cmp
--]====]

return {
   "hrsh7th/nvim-cmp",
   enabled = true,
   event = "InsertEnter",
   priority = 100,
   dependencies = {
      {
         "L3MON4D3/LuaSnip",
         build = (function()
            -- Build Step is needed for regex support in snippets.
            -- This step is not supported in many windows environments.
            -- Remove the below condition to re-enable on windows.
            if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
               return
            end

            return "make install_jsregexp"
         end)(),
         dependencies = {
            -- `friendly-snippets` contains a variety of premade snippets.
            --    See the README about individual language/framework/plugin snippets:
            --    URL: https://www.github.com/rafamadriz/friendly-snippets
            {
               'rafamadriz/friendly-snippets',
               config = function()
                  require('luasnip.loaders.from_vscode').lazy_load()
               end,
            },
         },
      },
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
   },
   config = function()
      local rhs = function(rhs_str)
         return vim.api.nvim_replace_termcodes(rhs_str, true, true, true)
      end

      -- Returns the current column number.
      local column = function()
         local _, col = unpack(vim.api.nvim_win_get_cursor(0))
         return col
      end

      -- Returns true if the cursor is in leftmost column or at a whitespace
      -- character.
      local in_whitespace = function()
         local col = column()
         return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')
      end

      local in_leading_indent = function()
         local col = column()
         local line = vim.api.nvim_get_current_line()
         local prefix = line:sub(1, col)
         return prefix:find('^%s*$')
      end

      local shift_width = function()
         if vim.o.softtabstop <= 0 then
            return vim.fn.shiftwidth()
         else
            return vim.o.softtabstop
         end
      end

      -- Complement to `smart_tab()`.
      --
      -- When 'noexpandtab' is set (ie. hard tabs are in use), backspace:
      --
      --    - On the left (ie. in the indent) will delete a tab.
      --    - On the right (when in trailing whitespace) will delete enough
      --      spaces to get back to the previous tabstop.
      --    - Everywhere else it will just delete the previous character.
      --
      -- For other buffers ('expandtab'), we let Neovim behave as standard and that
      -- yields intuitive behavior, unless the `dedent` parameter is truthy, in
      -- which case we issue <C-D> to dedent (see `:help i_CTRL-D`).
      local smart_bs = function(dedent)
         local keys = nil
         if vim.o.expandtab then
            if dedent then
               keys = rhs('<C-D>')
            else
               keys = rhs('<BS>')
            end
         else
            local col = column()
            local line = vim.api.nvim_get_current_line()
            local prefix = line:sub(1, col)
            if in_leading_indent() then
               keys = rhs('<BS>')
            else
               local previous_char = prefix:sub(#prefix, #prefix)
               if previous_char ~= ' ' then
                  keys = rhs('<BS>')
               else
                  -- Delete enough spaces to take us back to the previous tabstop.
                  --
                  -- Originally I was calculating the number of <BS> to send, but
                  -- Neovim has some special casing that causes one <BS> to delete
                  -- multiple characters even when 'expandtab' is off (eg. if you hit
                  -- <BS> after pressing <CR> on a line with trailing whitespace and
                  -- Neovim inserts whitespace to match.
                  --
                  -- So, turn 'expandtab' on temporarily and let Neovim figure out
                  -- what a single <BS> should do.
                  --
                  -- See `:h i_CTRL-\_CTRL-O`.
                  keys = rhs('<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>')
               end
            end
         end
         vim.api.nvim_feedkeys(keys, 'nt', true)
      end

      -- In buffers where 'noexpandtab' is set (ie. hard tabs are in use), <Tab>:
      --
      --    - Inserts a tab on the left (for indentation).
      --    - Inserts spaces everywhere else (for alignment).
      --
      -- For other buffers (ie. where 'expandtab' applies), we use spaces everywhere.
      local smart_tab = function()
         local keys = nil
         if vim.o.expandtab then
            keys = '<Tab>' -- Neovim will insert spaces.
         else
            local col = column()
            local line = vim.api.nvim_get_current_line()
            local prefix = line:sub(1, col)
            if in_leading_indent() then
               keys = '<Tab>' -- Neovim will insert a hard tab.
            else
               -- virtcol() returns last column occupied, so if cursor is on a
               -- tab it will report `actual column + tabstop` instead of `actual
               -- column`. So, get last column of previous character instead, and
               -- add 1 to it.
               local sw = shift_width()
               local previous_char = prefix:sub(#prefix, #prefix)
               local previous_column = #prefix - #previous_char + 1
               local current_column = vim.fn.virtcol({ vim.fn.line('.'), previous_column }) + 1
               local remainder = (current_column - 1) % sw
               local move = remainder == 0 and sw or sw - remainder
               keys = (' '):rep(move)
            end
         end

         vim.api.nvim_feedkeys(rhs(keys), 'nt', true)
      end

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

      -- Until https:.com/hrsh7th/nvim-cmp/issues/1716
      -- (cmp.ConfirmBehavior.MatchSuffix) gets implemented, use this local wrapper
      -- to choose between `cmp.ConfirmBehavior.Insert` and
      -- `cmp.ConfirmBehavior.Replace`:
      local confirm = function(entry)
         local behavior = cmp.ConfirmBehavior.Replace
         if entry then
            local completion_item = entry.completion_item
            local newText = ''
            if completion_item.textEdit then
               newText = completion_item.textEdit.newText
            elseif type(completion_item.insertText) == 'string' and completion_item.insertText ~= '' then
               newText = completion_item.insertText
            else
               newText = completion_item.word or completion_item.label or ''
            end

            -- How many characters will be different after the cursor position if we
            -- replace?
            local diff_after = math.max(0, entry.replace_range['end'].character + 1) - entry.context.cursor.col

            -- Does the text that will be replaced after the cursor match the suffix
            -- of the `newText` to be inserted? If not, we should `Insert` instead.
            if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
               behavior = cmp.ConfirmBehavior.Insert
            end
         end
         cmp.confirm({ select = true, behavior = behavior })
      end

      cmp.setup({
         experimental = {
            ghost_text = true,
         },
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
            ['<BS>'] = cmp.mapping(function()
               smart_bs()
            end, { "i", "s" }),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            -- Reject completion with <C-e>
            ["<C-e>"] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.close()
               elseif luasnip.choice_active() then
                  luasnip.jump(1)
               else
                  fallback()
               end
            end),
            -- Accept completion with <C-y>
            ["<C-y>"] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  local entry = cmp.get_selected_entry()
                  confirm(entry)
               else
                  fallback()
               end
            end),
            ["<C-Space>"] = cmp.mapping.complete({}),
            ["<C-CR>"] = cmp.mapping.complete({}),
            ["<CR>"] = cmp.mapping.confirm({
               select = false,
            }),
            ["<Up>"] = cmp.mapping.select_prev_item(),
            ["<Down>"] = cmp.mapping.select_next_item(),

            ["<Tab>"] = cmp.mapping(function(_)
               if cmp.visible() and has_words_before() then
                  -- If there is only one completion candidate, use it.
                  local entries = cmp.get_entries()
                  if #entries == 1 then
                     confirm(entries[1])
                  else
                     cmp.select_next_item()
                  end
               elseif luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
               elseif in_whitespace() then
                  smart_tab()
               else
                  cmp.complete()
               end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_prev_item()
               elseif luasnip.in_snippit() and luasnip.jumpable(-1) then
                  luasnip.jump(-1)
               elseif in_leading_indent() then
                  smart_bs(true)
               elseif in_whitespace() then
                  smart_bs()
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

      cmp.setup.cmdline("@", {
         mapping = cmp.mapping.preset.cmdline(),
         sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
         }),
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
            { name = 'path', },
            { name = 'nvim_lua', },
            {
               name = 'cmdline',
               option = {
                  ignore_cmds = { 'Man', '!' }
               }
            }
         })
      })

      -- Only show ghost text at word boundaries, not inside keywords. Based on idea
      -- from: https:.com/hrsh7th/nvim-cmp/issues/2035#issuecomment-2347186210

      local config = require('cmp.config')

      local toggle_ghost_text = function()
         if vim.api.nvim_get_mode().mode ~= 'i' then
            return
         end

         local cursor_column = vim.fn.col('.')
         local current_line_contents = vim.fn.getline('.')
         local character_after_cursor = current_line_contents:sub(cursor_column, cursor_column)

         local should_enable_ghost_text = character_after_cursor == '' or
             vim.fn.match(character_after_cursor, [[\k]]) == -1

         local current = config.get().experimental.ghost_text
         if current ~= should_enable_ghost_text then
            config.set_global({
               experimental = {
                  ghost_text = should_enable_ghost_text,
               },
            })
         end
      end

      vim.api.nvim_create_autocmd({ 'InsertEnter', 'CursorMovedI' }, {
         callback = toggle_ghost_text,
      })
   end,
}
