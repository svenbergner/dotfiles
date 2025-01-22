--[===[
Highlight patterns in text
URL: https://github.com/echasnovski/mini.hipatterns
--]===]

return {
   'echasnovski/mini.hipatterns',
   version = '*',
   config = function()
      local hipatterns = require('mini.hipatterns')
      local words = { ['enabled = true'] = '#B8BB26', ['enabled = false'] = '#CC241D' }

      local word_color_group = function(_, match)
         local hex = words[match]
         if hex == nil then return nil end
         return hipatterns.compute_hex_color_group(hex, 'bg')
      end

      require('mini.hipatterns').setup(
         {
            highlighters = {
               word_color = {
                  pattern = {
                     'enabled = true',
                     'enabled = false'
                  },
                  group = word_color_group
               },
            }
         }
      )
   end,
}
