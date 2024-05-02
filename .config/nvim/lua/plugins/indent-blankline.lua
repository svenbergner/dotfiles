-- This plugin adds indentation guides to Neovim.
-- It uses Neovim's virtual text feature and no conceal
return {
   'lukas-reineke/indent-blankline.nvim',
   event = 'VeryLazy',
   main = 'ibl',
   config = function()
      local hooks = require('ibl.hooks')
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
         vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
         vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
         vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
         vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
         vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
         vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
         vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      require('ibl').setup({
         scope = {
            enabled = true,
            show_start = true,
            show_end = true,
            show_exact_scope = true,
            injected_languages = true,
            highlight = { "Function", "Label" },
            priority = 500,
         },
         indent = {
            highlight = {
               "RainbowRed",
               "RainbowYellow",
               "RainbowBlue",
               "RainbowOrange",
               "RainbowGreen",
               "RainbowViolet",
               "RainbowCyan",
            },
         },
      })
   end,
   dependencies = {
      'HiPhish/rainbow-delimiters.nvim',
      config = function()
         -- This module contains a number of default definitions
         local rainbow_delimiters = require 'rainbow-delimiters'

         vim.g.rainbow_delimiters = {
            strategy = {
               [''] = rainbow_delimiters.strategy['global'],
               vim = rainbow_delimiters.strategy['local'],
            },
            query = {
               [''] = 'rainbow-delimiters',
               lua = 'rainbow-blocks',
            },
            priority = {
               [''] = 110,
               lua = 210,
            },
            highlight = {
               'RainbowDelimiterRed',
               'RainbowDelimiterYellow',
               'RainbowDelimiterBlue',
               'RainbowDelimiterOrange',
               'RainbowDelimiterGreen',
               'RainbowDelimiterViolet',
               'RainbowDelimiterCyan',
            },
         }
      end
   }
}
