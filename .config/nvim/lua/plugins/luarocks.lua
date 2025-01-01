--[=====[
luarocks.nvim
A LuaRocks frontend for Neovim.
URL: https://github.com/vhyrro/luarocks.nvim
--]=====]

return {
   'vhyrro/luarocks.nvim',
   priority = 1001,
   opt = {
      rocks = {
         'magick',
      },
   },
}
