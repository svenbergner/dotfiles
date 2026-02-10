--[===[
Automatically manage vim sessions
https://github.com/rmagatti/auto-session
--]===]

return {
   'rmagatti/auto-session',
   enabled = true,
   config = function()
      require('auto-session').setup({
         session_lens = {
            picker = 'snacks',
            buftypes_to_ignore = {},
            load_on_setup = true,
            theme_conf = { border = true },
         },
         suppress_dirs = { '~/', '~/Download', '/' },
      })
   end,
}
