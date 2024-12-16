--[=====[
  Showkeys
  Show the keys that are pressed in the bottom right corner.
  http://github.com/nvzone/showkeys
--]=====]

return {
   'nvzone/showkeys',
   cmd = 'ShowkeysToggle',
   opts = {
      position = 'bottom-right',
      maxkeys = 5,
      show_count = true,
   },
}
