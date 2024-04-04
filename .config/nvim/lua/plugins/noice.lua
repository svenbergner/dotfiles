-- Highly experimental plugin that completely replaces the UI 
-- for messages, cmdline and the popupmenu.
return {
   "folke/noice.nvim",
   event = "VeryLazy",
   keys = {
      { "<leader>nsl", function() require("noice").cmd("last") end,                                   desc = "[N]oice [S]how [L]ast Message" },
      { "<leader>nsh", function() require("noice").cmd("history") end,                                desc = "[N]oice [S]how [H]istory" },
      { "<leader>nsa", function() require("noice").cmd("all") end,                                    desc = "[N]oice [S]how [A]ll" },
      { "<leader>nda", function() require("noice").cmd("dismiss") end,                                desc = "[N]oice [D]ismiss [A]ll" },
      { '<leader>sn',  function() require("telescope").extensions.notify.notify() end,                desc = '[S]earch [N]otificanions'  },
      { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 desc = "Redirect Cmdline", mode = "c" },
      { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  desc = "Scroll forward",   mode = { "i", "n", "s" },  silent = true, expr = true, },
      { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, desc = "Scroll backward",  mode = { "i", "n", "s" },  silent = true, expr = true, },
   },
   config = function()
      require('noice').setup({
         lsp = {
            override = {
               ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
               ["vim.lsp.util.stylize_markdown"] = true,
               ["cmp.entry.get_documentation"] = true,
            },
         },
         views = {
            cmdline_popup = {
               position = {
                  row = "30%",
                  column = "50%",
               },
               size = {
                  width = 60,
                  height = "auto",
               },
               border = {
                  style = "single",
                  padding = { 0, 1 },
               },
               filter_options = {},
               win_options = {
                  winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
               },
            },
            routes = {
               {
                  view = "notify",
                  filter = {
                     event = "msg_showmode"
                  },
               },
            },
            presets = {
               bottom_search = true,
               command_palette = true,
               long_message_to_split = true,
               inc_rename = true,
            },
         },
      })
   end,
   dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify'
   }
}
