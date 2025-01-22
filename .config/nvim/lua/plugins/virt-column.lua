--[===[
Display a character as the colorcolumn.
URL: https://github.com/lukas-reineke/virt-column.nvim
--]===]

return {
   "lukas-reineke/virt-column.nvim",
   enabled = true,
   event = 'VeryLazy',
   opts = {
      virtcolumn = "80,120"
   }
}
