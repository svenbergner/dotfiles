--[===[
Orgmode clone written in Lua for Neovim

URL: https://github.com/nvim-orgmode/orgmode
URL: https://github.com/danilshvalov/org-modern.nvim
URL: https://github.com/nvim-orgmode/org-bullets.nvim
URL: https://github.com/neovim/nvim-lspconfig
--]===]

---@diagnostic disable: redundant-parameter
return {
   'nvim-orgmode/orgmode',
   dependencies = {
      'danilshvalov/org-modern.nvim',
      'nvim-orgmode/org-bullets.nvim',
      'neovim/nvim-lspconfig',
   },
   enabled = true,
   keys = {
      { '<leader>o', mode = 'n' },
   },
   ft = { 'org' },
   cmd = { 'Org' },
   config = function()
      local Menu = require('org-modern.menu')
      -- Setup orgmode
      require('orgmode').setup({
         org_agenda_files = '~/Repos/orgfiles/**/*',
         org_default_notes_file = '~/Repos/orgfiles/refile.org',
         ui = {
            menu = {
               handler = function(data)
                  local menu_hight = #data.items + 4
                  local win_height = vim.o.lines - vim.o.cmdheight
                  local margin_top = 0
                  local margin_bottom = (win_height / 2) + (menu_hight / 2)
                  Menu:new({
                     window = {
                        border = 'rounded',
                        margin = { margin_top, 30, margin_bottom, 30 },
                     },
                  }):open(data)
               end,
            },
         },
      })
      require('org-bullets').setup()
      -- vim.lsp.enable('org')
   end,
}
