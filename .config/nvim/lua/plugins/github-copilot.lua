return {
   -- -- "github/copilot.vim"
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
      branch = "canary",
      dependencies = {
         { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
         { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      },
      opts = {
         debug = false, -- Enable debugging
         -- See Configuration section for rest
      },
      -- See Commands section for default commands if you want to lazy load on them
   },
}
