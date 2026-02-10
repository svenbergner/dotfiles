--[===[
Showkeys
https://github.com/nvzone/showkeys

Show the last keys that are pressed in a box on the screen.
Useful for screencasts and presentations.
--]===]

return {
   'nvzone/showkeys',
   enabled = true,
   cmd = 'ShowkeysToggle',
   opts = {
      position = 'top-right',
      maxkeys = 5,
      show_count = true,
   },
}
