local M = {}

local function notify(message, level)
   vim.notify(message, level, { title = 'SonarLint' })
end

local function open_url(url)
   local _, error = vim.ui.open(url)
   if error then
      notify('Could not open SonarQube: ' .. error, vim.log.levels.ERROR)
   end
end

local function encode_query_value(value)
   return vim.uri_encode(value, 'rfc2396')
end

local function get_client(bufnr)
   for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
      if client.name == 'sonarlint.nvim' then
         return client
      end
   end
end

local function get_web_config(client)
   local settings = client.settings or client.config.settings or {}
   local connected_mode = settings.sonarlint and settings.sonarlint.connectedMode
   local project = connected_mode and connected_mode.project
   local connections = connected_mode and connected_mode.connections

   if not project or not project.projectKey or not connections then
      return
   end

   for _, connection in ipairs(connections.sonarqube or {}) do
      if connection.connectionId == project.connectionId and connection.serverUrl then
         return connection.serverUrl:gsub('/+$', ''), project.projectKey
      end
   end
end

local function get_line_diagnostics(client, bufnr)
   local cursor = vim.api.nvim_win_get_cursor(0)
   local line = cursor[1] - 1
   local namespace = vim.lsp.diagnostic.get_namespace(client.id)
   return vim.diagnostic.get(bufnr, { namespace = namespace, lnum = line })
end

local function open_issue_url(server_url, project_key, issue_key)
   local issue_url = server_url
      .. '/project/issues?id='
      .. encode_query_value(project_key)
      .. '&open='
      .. encode_query_value(issue_key)
   open_url(issue_url)
end

local function component_path(issue, project_key)
   local prefix = project_key .. ':'
   if type(issue.component) == 'string' and vim.startswith(issue.component, prefix) then
      return issue.component:sub(#prefix + 1)
   end
end

local function find_matching_issues(response, diagnostic, file_path, project_key)
   local candidates = {}

   for _, issue in ipairs(response.issues or {}) do
      local remote_path = component_path(issue, project_key)
      if remote_path and file_path:sub(-#remote_path) == remote_path then
         table.insert(candidates, issue)
      end
   end

   local exact_matches = vim.tbl_filter(function(issue)
      return issue.message == diagnostic.message
   end, candidates)
   if not vim.tbl_isempty(exact_matches) then
      candidates = exact_matches
   end

   local local_line = diagnostic.lnum + 1
   table.sort(candidates, function(left, right)
      local left_distance = math.abs((left.line or local_line) - local_line)
      local right_distance = math.abs((right.line or local_line) - local_line)
      return left_distance < right_distance
   end)

   return candidates
end

local function select_issue(issues, callback)
   if #issues == 1 then
      callback(issues[1])
      return
   end

   vim.ui.select(issues, {
      prompt = 'Open SonarQube issue:',
      format_item = function(issue)
         return string.format('%s:%s: %s', issue.component or '?', issue.line or '?', issue.message or issue.key)
      end,
   }, callback)
end

local function lookup_server_issue(server_url, project_key, diagnostic, file_path, project_url)
   local token = vim.env.SONAR_TOKEN
   if not token or token == '' then
      notify('Could not find the SonarQube issue: SONAR_TOKEN is missing.', vim.log.levels.WARN)
      open_url(project_url)
      return
   end

   local command = {
      'curl',
      '--silent',
      '--show-error',
      '--fail',
      '--get',
      '--config',
      '-',
      '--data-urlencode',
      'projects=' .. project_key,
      '--data-urlencode',
      'rules=' .. diagnostic.code,
      '--data-urlencode',
      'ps=500',
      server_url .. '/api/issues/search',
   }
   local escaped_token = token:gsub('\\', '\\\\'):gsub('"', '\\"')
   local curl_config = 'header = "Authorization: Bearer ' .. escaped_token .. '"\n'

   vim.system(command, { text = true, stdin = curl_config }, function(result)
      vim.schedule(function()
         if result.code ~= 0 then
            local message = result.stderr or ('curl exited with status ' .. result.code)
            notify('Could not retrieve the SonarQube issue: ' .. message, vim.log.levels.ERROR)
            return
         end

         local ok, response = pcall(vim.json.decode, result.stdout)
         if not ok or type(response) ~= 'table' then
            notify('Could not retrieve the SonarQube issue: invalid server response.', vim.log.levels.ERROR)
            return
         end

         local issues = find_matching_issues(response, diagnostic, file_path, project_key)
         if vim.tbl_isempty(issues) then
            notify('Could not find this issue in the bound SonarQube project.', vim.log.levels.WARN)
            open_url(project_url)
            return
         end

         select_issue(issues, function(issue)
            if issue and type(issue.key) == 'string' then
               open_issue_url(server_url, project_key, issue.key)
            end
         end)
      end)
   end)
end

function M.open_current()
   local bufnr = vim.api.nvim_get_current_buf()
   local client = get_client(bufnr)
   if not client then
      notify('Could not open SonarQube: no SonarLint client is attached.', vim.log.levels.WARN)
      return
   end

   local server_url, project_key = get_web_config(client)
   if not server_url then
      notify('Could not open SonarQube: the current project is not bound in Connected Mode.', vim.log.levels.WARN)
      return
   end

   local project_url = server_url .. '/dashboard?id=' .. encode_query_value(project_key)
   local diagnostics = get_line_diagnostics(client, bufnr)
   if vim.tbl_isempty(diagnostics) then
      open_url(project_url)
      return
   end

   local function open_diagnostic(diagnostic)
      if not diagnostic then
         return
      end

      local lsp_diagnostic = diagnostic.user_data and diagnostic.user_data.lsp
      local server_issue_key = lsp_diagnostic and lsp_diagnostic.data and lsp_diagnostic.data.serverIssueKey
      if type(server_issue_key) == 'string' and server_issue_key ~= '' then
         open_issue_url(server_url, project_key, server_issue_key)
         return
      end

      if not diagnostic.code then
         notify('Could not find the SonarQube issue: the diagnostic has no rule key.', vim.log.levels.ERROR)
         return
      end

      lookup_server_issue(server_url, project_key, diagnostic, vim.api.nvim_buf_get_name(bufnr), project_url)
   end

   if #diagnostics == 1 then
      open_diagnostic(diagnostics[1])
      return
   end

   vim.ui.select(diagnostics, {
      prompt = 'Select SonarQube diagnostic:',
      format_item = function(diagnostic)
         return string.format('%s: %s', diagnostic.code or '?', diagnostic.message)
      end,
   }, open_diagnostic)
end

return M
