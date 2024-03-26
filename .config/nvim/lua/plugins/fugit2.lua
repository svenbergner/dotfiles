-- A Git Porcelain inside Neovim
-- Git plugin for Neovim (based on libgit2).
return {
       'SuperBo/fugit2.nvim',
       opts = {},
       dependencies = {
          'MunifTanjim/nui.nvim',
          'nvim-tree/nvim-web-devicons',
          'nvim-lua/plenary.nvim',
          {
             'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
             dependencies = { 'stevearc/dressing.nvim' }
          },
       },
       cmd = { 'Fugit2', 'Fugit2Graph' },
       keys = {
          { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' }
       }
    },
    {
       -- optional: for diffview.nvim integration
       'sindrets/diffview.nvim',
       dependencies = { 'nvim-tree/nvim-web-devicons' },
       -- lazy, only load diffview by these commands
       cmd = {
          'DiffviewFileHistory', 'DiffviewOpen', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh'
       }
    }
