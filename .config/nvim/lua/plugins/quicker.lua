--[===[
quicker.nvim
https://github.com/stevearc/quicker.nvim

Features:
- Improved styling - including syntax highlighting of grep results.
- Show context lines - easily view lines above and below the quickfix results.
- Editable buffer - make changes across your whole project by editing the quickfix buffer and :w.
- API helpers - some helper methods for common tasks, such as toggling the quickfix
--]===]

return {
   'stevearc/quicker.nvim',
   enabled = true,
   ft = 'qf',
   ---@module "quicker"
   ---@type quicker.SetupOptions
   opts = {
      keys = {
         {
            '>',
            function()
               require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
            end,
            desc = 'Expand quickfix context',
         },
         {
            '<',
            function()
               require('quicker').collapse()
            end,
            desc = 'Collapse quickfix context',
         },
      },
   },
}
