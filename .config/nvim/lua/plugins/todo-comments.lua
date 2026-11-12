--[===[
Highlight todo, notes, etc in comments
https://www.github.com/folke/todo-comments.nvim

TODO:
OPTIMIZE:
PERFORMANCE:
TEST:
PROJECT:
FIXME:
BUG:
WARN:
HACK:
NOTE:
INFO:
HINT:

Usage:
:TodoCommentsHelp or press <leader>f? to list configured keywords and aliases.

--]===]

local function show_help()
   local options = require('todo-comments.config').options
   local keywords = options.keywords
   local highlights = {}
   local color_highlights = {}
   local lines = {
      '  Use KEYWORD: text inside a comment, e.g. TODO: Add error handling.',
      '',
      '    Icons   Keyword    Aliases',
   }

   for _, keyword in ipairs(vim.fn.sort(vim.tbl_keys(keywords))) do
      local opts = keywords[keyword]
      local aliases = vim.tbl_filter(function(alias)
         return alias ~= keyword
      end, opts.alt or {})
      table.sort(aliases)
      local icon = '      ' .. (opts.icon or '   ') .. '    '
      lines[#lines + 1] = string.format('%s%-10s %s', icon, keyword .. ':', table.concat(aliases, ', '))
      highlights[#highlights + 1] = { row = #lines - 1, keyword = keyword, col = #icon }
   end

   lines[#lines + 1] = ''
   lines[#lines + 1] = '  Available colors:'
   local util = require('todo-comments.util')
   for _, name in ipairs(vim.fn.sort(vim.tbl_keys(options.colors))) do
      local colors = options.colors[name]
      colors = type(colors) == 'string' and { colors } or colors
      local hex
      for _, color in ipairs(colors) do
         if color:sub(1, 1) == '#' then
            hex = color
         else
            hex = util.get_hl(color).foreground
         end
         if hex then
            break
         end
      end
      lines[#lines + 1] = string.format('    ■ %-10s %s', name, hex or '(unavailable)')
      if hex then
         color_highlights[#color_highlights + 1] = { row = #lines - 1, name = name, color = hex }
      end
   end

   lines[#lines + 1] = ''
   lines[#lines + 1] = '  Close with q or <Esc>.'

   Snacks.win({
      text = lines,
      title = ' Todo Comments Help ',
      title_pos = 'center',
      width = 70,
      height = #lines,
      border = 'rounded',
      enter = true,
      bo = { modifiable = false },
      on_buf = function(win)
         local ns = vim.api.nvim_create_namespace('todo-comments-help')
         vim.api.nvim_buf_clear_namespace(win.buf, ns, 0, -1)
         for _, highlight in ipairs(highlights) do
            local keyword_end = highlight.col + #highlight.keyword + 1
            vim.api.nvim_buf_set_extmark(win.buf, ns, highlight.row, 0, {
               end_col = highlight.col,
               hl_group = 'TodoFg' .. highlight.keyword,
            })
            vim.api.nvim_buf_set_extmark(win.buf, ns, highlight.row, highlight.col, {
               end_col = keyword_end,
               hl_group = 'TodoBg' .. highlight.keyword,
            })
            vim.api.nvim_buf_set_extmark(win.buf, ns, highlight.row, keyword_end, {
               end_col = #lines[highlight.row + 1],
               hl_group = 'TodoFg' .. highlight.keyword,
            })
         end
         for _, highlight in ipairs(color_highlights) do
            local group = 'TodoHelpColor_' .. highlight.name
            vim.api.nvim_set_hl(0, group, { fg = highlight.color })
            vim.api.nvim_buf_set_extmark(win.buf, ns, highlight.row, 4, {
               end_col = #lines[highlight.row + 1],
               hl_group = group,
            })
         end
      end,
      wo = { spell = false, wrap = true },
      keys = { q = 'close', ['<Esc>'] = 'close' },
   })
end

return {
   'folke/todo-comments.nvim',
   enabled = true,
   event = { 'BufReadPost', 'BufNewFile' },
   cmd = 'TodoCommentsHelp',
   keys = {
      { '<leader>f?', show_help, desc = '[f]ind Todo Comments Help [?]' },
   },
   config = function(_, opts)
      require('todo-comments').setup(opts)
      vim.api.nvim_create_user_command('TodoCommentsHelp', show_help, { desc = 'Show TODO keywords and aliases' })
   end,
   dependencies = {
      'nvim-lua/plenary.nvim',
   },
   opts = {
      signs = true,
      keywords = {
         FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
         PROJECT = { icon = ' ', color = 'info', alt = { 'PROJECT' } },
         TODO = { icon = ' ', color = 'info', alt = { 'TODO' } },
         TEST = { icon = '󰙨 ', color = 'info' },
         WARN = { icon = ' ', color = 'warning', alt = { 'WARN', 'WARNING' } },
         NOTE = { icon = ' ', color = 'hint', alt = { 'INFO', 'HINT' } },
      },
   },
}
