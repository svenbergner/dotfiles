--[===[
  Showkeys
  Show the keys that are pressed in the bottom right corner.
  URL: https://github.com/nvzone/showkeys
--]===]

return {
   'nvzone/showkeys',
   enabled = true,
   cmd = 'ShowkeysToggle',
   opts = {
      position = 'bottom-right',
      maxkeys = 5,
      show_count = true,
   },
}
