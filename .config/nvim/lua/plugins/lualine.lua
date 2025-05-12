--[===[
Neovim status line configuration
URL: https://github.com/nvim-lualine/lualine.nvim
--]===]

local function getMaxLineLength()
   local max_length = 0
   local total_lines = vim.fn.line('$')

   for i = 1, total_lines do
      local line_length = vim.fn.getline(i):len()
      if line_length > max_length then
         max_length = line_length
      end
   end

   return max_length
end

local getLineInfo = function()
   local current_line = vim.fn.line('.')
   local total_lines = vim.fn.line('$')
   local current_column = vim.fn.col('.')
   local line_length = vim.fn.col('$') - 1
   local total_lines_digits = #tostring(total_lines)
   local max_line_length_digits = #tostring(getMaxLineLength())
   local format_string = "󰦪 %" .. total_lines_digits .. "d|%" .. total_lines_digits .. "d "
   format_string = format_string .. "󰣟 %" .. max_line_length_digits .. "d|%" .. max_line_length_digits .. "d"
   return string.format(format_string, current_line, total_lines, current_column, line_length)
end

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

local function getRecordingMessage()
   local reg = vim.fn.reg_recording()
   if reg == "" then return "" end
   return "recording @" .. reg
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
               { getRecordingMessage, },
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
            lualine_z = {
               { getLineInfo },
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
