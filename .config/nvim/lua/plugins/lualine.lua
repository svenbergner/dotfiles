local getWords = function()
   if vim.bo.filetype == "text" or vim.bo.filetype == "markdown" or vim.bo.filetype == "vimwiki" then
      if vim.fn.wordcount().visual_words == 1 then
         return tostring(vim.fn.wordcount().visual_words) .. " word"
      elseif not (vim.fn.wordcount().visual_words == nil) then
         return tostring(vim.fn.wordcount().visual_words) .. " words"
      else
         return tostring(vim.fn.wordcount().words) .. " words"
      end
   else
      return ""
   end
end

return {
   'nvim-lualine/lualine.nvim',
   config = function()
      local gitblame = require('gitblame')
      require('lualine').setup({
         options = {
            icons_enabled = true,
            theme = 'auto',
            ignore_focus = { 'dap-repl' },
            disabled_filetypes = {
               "dapui_watches", "dapui_breakpoints",
               "dapui_scopes", "dapui_console",
               "dapui_stacks", "dap-repl",
               "neo-tree"
            },
         },
         winbar = {
            lualine_b = { 'diagnostics' },
            lualine_c = { { 'filename', path = 1 } },
         },
         sections = {
            lualine_b = {
               { 'branch' },
               { 'diff' },
            },
            lualine_c = {
               { gitblame.get_current_blame_text, cond = gitblame.is_blame_text_available }
            },
            lualine_y = {
               { 'progress' },
               { getWords },
            },
         },
         inactive_winbar = {
            lualine_b = { { 'filename', path = 1 } },
            lualine_c = {},
            lualine_x = {},
         },
         inactive_sections = {
            lualine_b = { { 'filename', path = 1 } },
            lualine_c = {},
            lualine_x = {},
         },
      })
   end,
   dependencies = {
      {
         "nvim-tree/nvim-web-devicons",
         "f-person/git-blame.nvim",
         config = function()
            vim.g.gitblame_date_format = '%d.%m.%y %H:%M'
            vim.g.gitblame_message_template = '<author>  <date>  <summary>'
            vim.g.gitblame_message_when_not_committed = 'Not Committed Yet'
            vim.g.gitblame_display_virtual_text = 0
            vim.g.gitblame_ignored_filetypes = { 'log', 'dump' }
         end,
      },
   },
}