-- Move faster with unique f/F indicators for each word on the line. 
-- Like quick-scope, but in Lua.
return {
   'jinh0/eyeliner.nvim',
   config = function()
      require('eyeliner').setup({
         highlight_on_key = true,
         dim = true,
      })
   end
}
