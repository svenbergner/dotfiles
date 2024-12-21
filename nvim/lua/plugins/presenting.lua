--[=====[
Show markdown file as a slide presentation.
URL: https://github.com/sotte/presenting.nvim
--]=====]

return {
   'sotte/presenting.nvim',
   config = function()
      require('presenting').setup()
   end,
}
