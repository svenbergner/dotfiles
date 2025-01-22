--[===[
Automatically manage vim sessions
URL: https://github.com/rmagatti/auto-session
--]===]

return {
   'rmagatti/auto-session',
   lazy = false,
   enabled = true,
   config = function()
      require('auto-session').setup(
         {
            session_lens = {
               buftypes_to_ignore = {},
               load_on_setup = true,
               previewer = false,
               theme_conf = { border = true },
            },
            suppress_dirs = { "~/", "~/Download", "/", },
            vim.keymap.set('n', '<leader>ls',
               require('auto-session.session-lens').search_session,
               { noremap = true })
         }
      )
   end,
}
