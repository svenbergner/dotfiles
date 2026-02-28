--[===[
treesitter-modules.nvim
Original modules from nvim-treesitter master branch
https://github.com/MeanderingProgrammer/treesitter-modules.nvim
--]===]

return {
   'MeanderingProgrammer/treesitter-modules.nvim',
   dependencies = { 'nvim-treesitter/nvim-treesitter' },
   branch = 'main',
   ---@module 'treesitter-modules'
   ---@type ts.mod.UserConfig
   opts = {
      ensure_installed = {
         'bash',
         'cmake',
         'cpp',
         'css',
         'csv',
         'dart',
         'diff',
         'dockerfile',
         'editorconfig',
         'elixir',
         'erlang',
         'git_config',
         'git_rebase',
         'gitattributes',
         'gitcommit',
         'gitignore',
         'go',
         'html',
         'http',
         'javascript',
         'json',
         'kdl',
         'kotlin',
         'lua',
         'luadoc',
         'luap',
         'make',
         'markdown', -- basic highlighting
         'markdown_inline', -- needed for full highlighting
         'ninja',
         'nix',
         'python',
         'regex',
         'rust',
         'toml',
         'vim',
         'vimdoc',
         'xml',
         'yaml',
      },
      incremental_selection = {
         enable = true,
         keymaps = {
            init_selection = '<C-Enter>',
            node_incremental = '<C-Enter>',
            scope_incremental = '<S-Enter>',
            node_decremental = '<Backspace>',
         },
      },
      auto_install = true,
      sync_install = false,
      highlight = {
         enable = true,
         use_languagetree = true,
      },
      indent = { enable = true },
   },
   config = function(_, opts)
      require('treesitter-modules').setup(opts)
   end,
}
