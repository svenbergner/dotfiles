--[===[
Neovim status line configuration
https://github.com/nvim-lualine/lualine.nvim
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
   local format_string = '󰦪 %' .. total_lines_digits .. 'd|%' .. total_lines_digits .. 'd '
   format_string = format_string .. '󰣟 %' .. max_line_length_digits .. 'd|%' .. max_line_length_digits .. 'd'
   return string.format(format_string, current_line, total_lines, current_column, line_length)
end

local getWords = function()
   if vim.bo.filetype == 'text' or vim.bo.filetype == 'markdown' or vim.bo.filetype == 'vimwiki' then
      if vim.fn.wordcount().visual_words == 1 then
         return tostring(vim.fn.wordcount().visual_words) .. ' word'
      elseif not (vim.fn.wordcount().visual_words == nil) then
         return tostring(vim.fn.wordcount().visual_words) .. ' words'
      else
         return tostring(vim.fn.wordcount().words) .. ' words'
      end
   else
      return ''
   end
end

local getNeoVimSymbol = function()
   return ''
end

local function getRecordingMessage()
   local reg = vim.fn.reg_recording()
   if reg == '' then
      return ''
   end
   return 'recording @' .. reg
end

local function diffActive()
   if vim.o.diff then
      return '-- Diff --'
   else
      return ''
   end
end

-- Returns current compiler state
---@return string
local function getBuildState()
   local s = require('telescope').extensions.cmake_preset_selector.get_build_state()
   if #s.text < 2 then
      return ''
   end
   local src_hl = s.state == 'successful' and 'DiagnosticOk' or 'DiagnosticError'
   if s.state == 'building' then
      src_hl = 'lualine_c_normal'
   end
   local custom_hl = s.state == 'successful' and 'LualineBuildOk' or 'LualineBuildFail'
   local default_hl = 'lualine_c_normal'
   local fg = vim.api.nvim_get_hl(0, { name = src_hl, link = false }).fg
   local fg_normal = vim.api.nvim_get_hl(0, { name = 'lualine_c_normal', link = false }).fg
   local bg = vim.api.nvim_get_hl(0, { name = 'lualine_c_normal', link = false }).bg
   vim.api.nvim_set_hl(0, custom_hl, { fg = fg, bg = bg })
   vim.api.nvim_set_hl(0, default_hl, { fg = fg_normal, bg = bg })
   return '%#' .. custom_hl .. '#' .. s.icon .. '%*' .. '%#' .. default_hl .. '# ' .. s.text .. '%*'
end

local function getDebugInfos()
   local last_program = require('telescope').extensions.debugee_selector.get_last_program()
   local last_debugee_args = require('telescope').extensions.debugee_selector.get_last_debugee_args()
   local debug_infos = ''

   if #last_program > 0 then
      local program_name = last_program and vim.fn.fnamemodify(last_program, ':t') or 'unknown'
      debug_infos = debug_infos .. ': ' .. program_name
   end

   if #last_debugee_args > 0 then
      if #debug_infos > 0 then
         debug_infos = debug_infos .. ' '
      end
      debug_infos = debug_infos .. ': ' .. last_debugee_args
   end

   return debug_infos
end

local function pathParent(path)
   return path and path:match('^(.+)/[^/]+$') or nil
end

local function pathBasename(path)
   return path and path:match('([^/]+)$') or ''
end

local function findCompileCommandsBuildDir()
   local path = vim.api.nvim_buf_get_name(0)
   if path == '' then
      path = vim.loop.cwd()
   end
   if vim.loop.fs_stat(path) and vim.loop.fs_stat(path).type ~= 'directory' then
      path = pathParent(path)
   end

   local home = vim.loop.os_homedir()
   while path and path ~= home and path ~= '/' do
      local cc = path .. '/compile_commands.json'
      if vim.loop.fs_stat(cc) then
         local real = vim.loop.fs_realpath(cc)
         if real then
            return pathParent(real)
         end
      end
      local parent = pathParent(path)
      if parent == path then
         break
      end
      path = parent
   end
   return nil
end

local function getTestBuildContext()
   local build_dir = findCompileCommandsBuildDir()
   if not build_dir or build_dir == '' then
      return ''
   end

   local label = '󰙨 ' .. pathBasename(build_dir)

   local ok, neotest = pcall(require, 'neotest')
   if not ok or not neotest.state then
      return label
   end

   local total, passed, failed, skipped, running = 0, 0, 0, 0, 0
   for _, adapter_id in ipairs(neotest.state.adapter_ids()) do
      local ok2, counts = pcall(neotest.state.status_counts, adapter_id)
      if ok2 and counts then
         total = total + (counts.total or 0)
         passed  = passed  + (counts.passed  or 0)
         failed  = failed  + (counts.failed  or 0)
         skipped = skipped + (counts.skipped or 0)
         running = running + (counts.running or 0)
      end
   end

   if total == 0 and passed == 0 and failed == 0 and skipped == 0 and running == 0 then
      return label
   end

   -- Build per-state highlight groups (fg from semantic hl, bg from lualine)
   local bg = vim.api.nvim_get_hl(0, { name = 'lualine_c_normal', link = false }).bg
   local function colored(text, src_hl, custom_hl)
      local fg = vim.api.nvim_get_hl(0, { name = src_hl, link = false }).fg
      vim.api.nvim_set_hl(0, custom_hl, { fg = fg, bg = bg })
      return '%#' .. custom_hl .. '#' .. text .. '%*'
   end

   local parts = {}
   if total   > 0 then parts[#parts + 1] = colored(' ' .. total,   'NeotestTest',    'LualineTestTotal')   end
   if passed  > 0 then parts[#parts + 1] = colored(' ' .. passed,  'NeotestPassed',  'LualineTestPassed')  end
   if failed  > 0 then parts[#parts + 1] = colored(' ' .. failed,  'NeotestFailed',  'LualineTestFailed')  end
   if running > 0 then parts[#parts + 1] = colored(' ' .. running, 'NeotestRunning', 'LualineTestRunning') end
   if skipped > 0 then parts[#parts + 1] = colored(' ' .. skipped, 'NeotestSkipped', 'LualineTestSkipped') end

   return label .. '' .. table.concat(parts, '')
end

return {
   'nvim-lualine/lualine.nvim',
   config = function()
      local trouble = require('trouble')
      local symbols = trouble.statusline({
         mode = 'lsp_document_symbols',
         groups = {},
         title = false,
         filter = { range = true },
         format = '{kind_icon}{symbol.name:Normal}',
         hl_group = 'lualine_c_normal',
      })
      require('lualine').setup({
         options = {
            icons_enabled = true,
            theme = 'auto',
            section_separators = { left = '', right = '' },
            ignore_focus = { 'dap-repl' },
            disabled_filetypes = {
               'dap-repl',
               'dap-view',
               'neo-tree',
               'Avante',
               'Avante Ask',
               'Avante Chat',
            },
         },
         winbar = {
            lualine_b = { 'diagnostics' },
            lualine_c = { { 'filename', path = 1 } },
         },
         sections = {
            lualine_a = {
               { getNeoVimSymbol, separator = { left = ' ' } },
               { 'mode' },
               { getRecordingMessage },
            },
            lualine_b = {
               { 'branch', 'diff', 'diagnostics' },
               { diffActive },
            },
            lualine_c = {
               symbols.get,
               -- cond = symbols.has,
            },
            lualine_x = {
               { 'copilot' },
               { 'filetype' },
               { 'encoding' },
               { 'fileformat' },
               {
                  getTestBuildContext,
                  cond = function()
                     return #getTestBuildContext() > 0
                  end,
               },
               {
                  getBuildState,
                  cond = function()
                     return #getBuildState() > 2
                  end,
               },
               {
                  getDebugInfos,
                  cond = function()
                     return #getDebugInfos() > 2
                  end,
               },
            },
            lualine_y = {
               { 'progress' },
               { getWords },
            },
            lualine_z = {
               { getLineInfo, separator = { right = ' ' } },
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
         'AndreM222/copilot-lualine',
         'nvim-tree/nvim-web-devicons',
         'folke/trouble.nvim',
      },
   },
}
