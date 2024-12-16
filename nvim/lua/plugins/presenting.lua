--[=====[
Show markdown file in presentation mode
http:s//github.com/sotte/presenting.nvim

--]=====]

return {
   'sotte/presenting.nvim',
   config = function()
      require('presenting').setup()
   end,
}
