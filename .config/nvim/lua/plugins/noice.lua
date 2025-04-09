--[===[
Highly experimental plugin that completely replaces the UI
for messages, cmdline and the popupmenu.
URL: https://github.com/folke/noice.nvim
--]===]

return {
   "folke/noice.nvim",
   enabled = true,
   event = "VeryLazy",
   keys = {
      { "<leader>NL", function() require("noice").cmd("last") end,    desc = "[N]oice show [L]ast Message" },
      { "<leader>NH", function() require("noice").cmd("history") end, desc = "[N]oice show [H]istory" },
      { "<leader>NA", function() require("noice").cmd("all") end,     desc = "[N]oice show [A]ll" },
      { "<leader>ND", function() require("noice").cmd("dismiss") end, desc = "[N]oice [D]ismiss all" },
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
         routes = {
            {
               view = "notify",
               filter = {
                  event = "msg_showmode",
                  kind = "",
               },
            },
         },
         presets = {
            bottom_search = false,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = true,
            lsp_doc_border = true,
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
         },
      })
   end,
   dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify'
   }
}
