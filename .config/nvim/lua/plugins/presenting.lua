--[===[
Show markdown file as a slide presentation:markdown
https://github.com/sotte/presenting.nvim
--]===]

return {
   'sotte/presenting.nvim',
   enabled = false,
   config = function()
      require('presenting').setup()
   end,
}
