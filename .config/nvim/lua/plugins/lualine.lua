--[===[
Neovim status line configuration
URL: https://www.github.com/nvim-lualine/lualine.nvim 
--]===]

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

local getNeoVimSymbol = function()
   return ""
end

return {
   'nvim-lualine/lualine.nvim',
   config = function()
      local trouble = require('trouble')
      local symbols = trouble.statusline({
         mode = "lsp_document_symbols",
         groups = {},
         title = false,
         filter = { range = true },
         format = "{kind_icon}{symbol.name:Normal}",
         hl_group = "lualine_c_normal",
      })
      require('lualine').setup({
         options = {
            icons_enabled = true,
            theme = 'auto',
            ignore_focus = { 'dap-repl' },
            disabled_filetypes = {
               "dapui_watches", "dapui_breakpoints",
               "dapui_scopes", "dapui_console",
               "dapui_stacks", "dap-repl",
               "neo-tree", "Avante", "Avante Ask", "Avante Chat"
            },
         },
         winbar = {
            lualine_b = { 'diagnostics' },
            lualine_c = { { 'filename', path = 1 } },
         },
         sections = {
            lualine_a = {
               { getNeoVimSymbol },
               { 'mode' },
            },
            lualine_b = {
               { 'branch' },
               { 'diff' },
            },
            lualine_c = {
               symbols.get,
               -- cond = symbols.has,
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
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
         },
      })
   end,
   dependencies = {
      {
         "nvim-tree/nvim-web-devicons",
         "folke/trouble.nvim",
      },
   },
}
