local M = {}

local function notify_error(message)
   vim.schedule(function()
      vim.notify(message, vim.log.levels.ERROR, { title = 'SonarLint' })
   end)
end

local function positive_integer(value, fallback)
   value = tonumber(value)
   if not value or value < 1 then
      return fallback
   end
   return math.floor(value)
end

function M.show_issue(error, params)
   if error then
      notify_error('Could not open the SonarQube issue: ' .. vim.inspect(error))
      return
   end

   if type(params) ~= 'table' or type(params.fileUri) ~= 'string' then
      notify_error('Could not open the SonarQube issue: the language server did not provide a file URI.')
      return
   end

   local uri_ok, file_path = pcall(vim.uri_to_fname, params.fileUri)
   if not uri_ok then
      notify_error('Could not open the SonarQube issue: invalid file URI.')
      return
   end

   local text_range = type(params.textRange) == 'table' and params.textRange or {}
   local line = positive_integer(text_range.startLine, 1)
   -- SonarQube line offsets are zero-based; nvim-open expects a one-based column.
   local column = positive_integer((tonumber(text_range.startLineOffset) or 0) + 1, 1)
   local helper = vim.fn.expand('~/scripts/nvim-open')

   local started, start_error = pcall(vim.system, {
      helper,
      file_path,
      tostring(line),
      tostring(column),
   }, { text = true }, function(result)
      if result.code == 0 then
         return
      end

      local message = vim.trim(result.stderr or '')
      if message == '' then
         message = ('nvim-open exited with status %d.'):format(result.code)
      end
      notify_error('Could not open the SonarQube issue: ' .. message)
   end)

   if not started then
      notify_error('Could not start nvim-open: ' .. tostring(start_error))
   end
end

return M
