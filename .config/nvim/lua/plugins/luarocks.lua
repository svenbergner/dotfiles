--[===[
luarocks.nvim
A LuaRocks frontend for Neovim.
URL: https://github.com/vhyrro/luarocks.nvim
--]===]

return {
   'vhyrro/luarocks.nvim',
   enabled = true,
   priority = 1001,
   opts = {
      rocks = {
         'magick',
         'lunajson',
         -- Needs lua 5.2
         -- 'lxp',
      },
   },
}
