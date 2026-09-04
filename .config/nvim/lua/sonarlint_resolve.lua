local M = {}

local function notify_error(message)
   vim.notify(message, vim.log.levels.ERROR, { title = 'SonarLint' })
end

local function non_empty_string(value)
   if type(value) == 'string' and value ~= '' then
      return value
   end
end

local function diagnostic_fallback(ctx)
   local params = ctx and ctx.params
   local context = params and params.context
   local diagnostics = context and context.diagnostics or {}

   for _, diagnostic in ipairs(diagnostics) do
      local data = diagnostic.data
      local issue_key = data and non_empty_string(data.serverIssueKey)
      if issue_key then
         return issue_key, params.textDocument and non_empty_string(params.textDocument.uri)
      end
   end
end

function M.resolve_issue(action, ctx)
   local arguments = type(action) == 'table' and action.arguments or {}
   local folder_uri = non_empty_string(arguments[1])
   local issue_key = non_empty_string(arguments[2])
   local file_uri = non_empty_string(arguments[3])
   local is_taint_issue = arguments[4] == true

   if not issue_key or not file_uri then
      local fallback_issue_key, fallback_file_uri = diagnostic_fallback(ctx)
      issue_key = issue_key or fallback_issue_key
      file_uri = file_uri or fallback_file_uri
   end

   local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id)
   if not client then
      notify_error('Could not resolve issue: the SonarLint language server is not available.')
      return
   end

   local workspace_folder = client.workspace_folders and client.workspace_folders[1]
   folder_uri = folder_uri or (workspace_folder and non_empty_string(workspace_folder.uri))

   if not folder_uri or not issue_key or not file_uri then
      notify_error('Could not resolve issue: the language server did not provide complete issue information.')
      return
   end

   client:request(
      'sonarlint/checkIssueStatusChangePermitted',
      { folderUri = folder_uri, issueKey = issue_key },
      function(err, result)
         if err then
            notify_error('Could not check issue change permission: ' .. vim.inspect(err))
            return
         end

         if not result or result.permitted == false then
            vim.notify('Status change is not permitted.', vim.log.levels.WARN, { title = 'SonarLint' })
            return
         end

         if type(result.allowedStatuses) ~= 'table' or vim.tbl_isempty(result.allowedStatuses) then
            notify_error('Could not resolve issue: the server returned no allowed statuses.')
            return
         end

         vim.ui.select(result.allowedStatuses, { prompt = 'Resolve Issue' }, function(new_status)
            if not new_status then
               return
            end

            vim.ui.input({ prompt = 'Enter a comment' }, function(comment)
               if comment == nil then
                  return
               end

               client:notify('sonarlint/changeIssueStatus', {
                  configurationScopeId = folder_uri,
                  issueId = issue_key,
                  newStatus = new_status,
                  fileUri = file_uri,
                  comment = comment,
                  isTaintIssue = is_taint_issue,
               })
            end)
         end)
      end
   )
end

return M
