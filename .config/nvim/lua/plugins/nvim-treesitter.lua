--[===[
Treesitter configuration
https://github.com/nvim-treesitter/nvim-treesitter
--]===]

return {
   'nvim-treesitter/nvim-treesitter',
   enabled = true,
   branch = 'main',
   lazy = false,
   build = ':TSUpdate',
   -- opts = {
   --    inlay_hints = {
   --       inline = true,
   --    },
   --    ast = {
   --       --These require codicons (https://github.com/microsoft/vscode-codicons)
   --       role_icons = {
   --          type = '',
   --          declaration = '',
   --          expression = '',
   --          specifier = '',
   --          statement = '',
   --          ['template argument'] = '',
   --       },
   --       kind_icons = {
   --          Compound = '',
   --          Recovery = '',
   --          TranslationUnit = '',
   --          PackExpansion = '',
   --          TemplateTypeParm = '',
   --          TemplateTemplateParm = '',
   --          TemplateParamObject = '',
   --       },
   --    },
   -- },
   -- config = function()
   --    vim.opt.foldlevel = 99
   --    vim.opt.foldlevelstart = 99
   --    vim.opt.foldmethod = 'expr'
   --    vim.opt.foldcolumn = '1'
   --    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
   --    vim.keymap.set('n', '<CR>', 'za', { noremap = true, silent = true, desc = 'Toggle current fold' })
   -- end,
}
