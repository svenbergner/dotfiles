--[===[
Github Copilot Plugin
https://github.com/zbirenbaum/copilot.lua
--]===]

return {
   {
      'zbirenbaum/copilot.lua',
      enabled = true,
      event = 'InsertEnter',
      config = function()
         require('copilot').setup({
            suggestion = { enabled = true },
            panel = { enabled = true },
         })
      end,
   },
}
