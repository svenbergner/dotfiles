--[===[
Highlight patterns in text
https://github.com/nvim-mini/mini.hipatterns
--]===]

return {
   'nvim-mini/mini.hipatterns',
   version = '*',
   config = function()
      local hipatterns = require('mini.hipatterns')
      local words = {
         ['enabled = true'] = '#B8BB26',
         ['enabled = false'] = '#CC241D',
      }

      local word_color_group = function(_, match)
         local hex = words[match]
         if hex == nil then
            return nil
         end
         return hipatterns.compute_hex_color_group(hex, 'bg')
      end

      require('mini.hipatterns').setup({
         highlighters = {
            word_color = {
               pattern = {
                  'enabled = true',
                  'enabled = false',
               },
               group = word_color_group,
            },
            hex_color = hipatterns.gen_highlighter.hex_color(),
         },
      })
   end,
}
