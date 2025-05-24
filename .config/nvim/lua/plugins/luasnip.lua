--[===[
These are custom snippets created using LuaSnip

URL: https://github.com/L3MON4D3/LuaSnip

I have added a few snippets for markdown files, including code blocks and links.
I took the idea from this video:
URL: https://youtu.be/FmHhonPjvvA?si=8NrcRWu4GGdmTzee
--]===]

return {
   "L3MON4D3/LuaSnip",
   enabled = true,
   opts = function(_, opts)
      local ls = require("luasnip")

      -- Load my personal snippets
      local snippets_path = vim.fn.stdpath('config') .. "/snippets"
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippets_path } })

      -- Preserve existing opts from LazyVim
      opts = vim.tbl_deep_extend("force", opts, {
         history = true,
         delete_check_events = "TextChanged",
      })

      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      local function clipboard()
         return vim.fn.getreg("+")
      end


      -- Helper function to create code block snippets
      local function create_code_block_snippet(lang)
         return s(lang, {
            t({ "```" .. lang, "" }),
            i(1),
            t({ "", "```" }),
         })
      end

      -- Define languages for code blocks
      local languages = {
         "txt",
         "lua",
         "sql",
         "go",
         "regex",
         "bash",
         "markdown",
         "markdown_inline",
         "yaml",
         "json",
         "jsonc",
         "cpp",
         "csv",
         "java",
         "javascript",
         "python",
         "dockerfile",
         "html",
         "css",
         "templ",
         "php",
      }

      -- Generate snippets for all languages
      local markdown_snippets = {}

      for _, lang in ipairs(languages) do
         table.insert(markdown_snippets, create_code_block_snippet(lang))
      end


      -- #####################################################################
      --                         all the filetypes
      -- #####################################################################
      local all_snippets = {}

      table.insert(
         all_snippets,
         s({
            trig = "dateiso",
            name = "Add current date",
         }, {
            t(os.date("%Y-%m-%d")),
         })
      )
      table.insert(
         all_snippets,
         s({
            trig = "datelocal",
            name = "Add current date",
         }, {
            t(os.date("%d.%m.%Y")),
         })
      )

      ls.add_snippets("all", all_snippets)

      return opts
   end,
}
