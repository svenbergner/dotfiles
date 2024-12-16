--[=====[
Github Copilot Plugin

https://github.com/github/copilot.vim
https://github.com/zbirenbaum/copilot.lua
https://github.com/zbirenbaum/copilot-cmp
https://github.com/CopilotC-Nvim/CopilotChat.nvim
--]=====]

return {
   "github/copilot.vim",
   enabled = false,
   {
      "zbirenbaum/copilot.lua",
      config = function()
         require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false }
         })
      end
   },
   {
      "zbirenbaum/copilot-cmp",
      config = function()
         require("copilot_cmp").setup()
      end
   },
   {
      "CopilotC-Nvim/CopilotChat.nvim",
      dependencies = {
         { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
         { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
      },
      opts = {
         debug = false, -- Enable debugging
         -- See Configuration section for rest
      },
      -- See Commands section for default commands if you want to lazy load on them
   },
}
