--[===[
Flash
URL: https://github.com/folke/flash.nvim
flash.nvim lets you navigate your code with search labels,
enhanced character motions, and Treesitter integration.
Features
🔍 Search Integration: integrate flash.nvim with your regular search
   using / or ?. Labels appear next to the matches, allowing you to quickly
   jump to any location. Labels are guaranteed not to exist as a continuation
   of the search pattern.
⌨️ type as many characters as you want before using a jump label.
⚡ Enhanced f, t, F, T motions
🌳 Treesitter Integration: all parents of the Treesitter node under your
   cursor are highlighted with a label for quick selection of a specific
   Treesitter node.
🎯 Jump Mode: a standalone jumping mode similar to search
🔎 Search Modes: exact, search (regex), and fuzzy search modes
🪟 Multi Window jumping
🌐 Remote Actions: perform motions in remote locations
⚫ dot-repeatable jumps
📡 highly extensible: check the examples
--]===]

return {
   "folke/flash.nvim",
   enabled = true,
   event = "VeryLazy",
   ---@type Flash.Config
   opts = {
      picker = {
         win = {
            input = {
               keys = {
                  -- Use s in normal mode and <a-s> in insert mode, 
                  -- to jump to a label in the picker results.
                  ["<a-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
               },
            },
         },
         actions = {
            flash = function(picker)
               require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                     mode = "search",
                     exclude = {
                        function(win)
                           return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                        end,
                     },
                  },
                  action = function(match)
                     local idx = picker.list:row2idx(match.pos[1])
                     picker.list:_move(idx, true, true)
                  end,
               })
            end,
         },
      },
      jump = {
         auto_jump = true,
      },
      modes = {
         search = {
            enabled = true,
            label = {
               after = { 0, 0 },
               style = "overlay",
            },
            multi_window = true,
         },
         char = {
            jump_labels = true,
            multi_line = true,
         }
      }
   },
   -- stylua: ignore
   keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = { "o" },           function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
   },
}
