local M = {}

local state = {
   address = nil,
   last_focus = 0,
   pane_id = nil,
   root = nil,
   wezterm_socket = nil,
}

local function now_microseconds()
   local seconds, microseconds = vim.uv.gettimeofday()
   return (seconds * 1000000) + microseconds
end

local function normalized_path(path)
   return vim.uv.fs_realpath(path) or vim.fs.normalize(path)
end

local function cleanup()
   if not state.address then
      return
   end

   pcall(vim.fn.serverstop, state.address)
   pcall(vim.uv.fs_unlink, state.address)
   state.address = nil
end

function M.info()
   return {
      last_focus = state.last_focus,
      pane_id = state.pane_id,
      root = state.root,
      version = 1,
      wezterm_socket = state.wezterm_socket,
   }
end

function M.open(encoded_payload)
   vim.validate('encoded_payload', encoded_payload, 'string')

   local payload = vim.json.decode(vim.base64.decode(encoded_payload))
   vim.validate('payload', payload, 'table')
   vim.validate('payload.path', payload.path, 'string')
   vim.validate('payload.line', payload.line, 'number')
   vim.validate('payload.column', payload.column, 'number')

   if payload.line < 1 or payload.column < 1 then
      error('line and column must be positive')
   end

   local path = vim.uv.fs_realpath(payload.path)
   local path_stat = path and vim.uv.fs_stat(path) or nil
   if not path_stat or path_stat.type ~= 'file' then
      error(('document does not exist or is not a regular file: %s'):format(payload.path))
   end

   vim.api.nvim_cmd({ cmd = 'drop', args = { vim.fn.fnameescape(path) } }, {})
   vim.fn.cursor(payload.line, payload.column)
   return true
end

function M.setup()
   if state.address or not vim.env.WEZTERM_PANE or vim.env.WEZTERM_PANE == '' then
      return
   end

   local socket_dir = vim.fn.stdpath('cache') .. '/remote-open'
   vim.fn.mkdir(socket_dir, 'p', tonumber('700', 8))
   vim.uv.fs_chmod(socket_dir, tonumber('700', 8))

   state.pane_id = tostring(vim.env.WEZTERM_PANE)
   state.root = normalized_path(vim.fn.getcwd())
   state.wezterm_socket = vim.env.WEZTERM_UNIX_SOCKET
   state.last_focus = now_microseconds()

   local safe_pane_id = state.pane_id:gsub('[^%w_.-]', '_')
   local socket_name = ('nvim-%d-%s.sock'):format(vim.fn.getpid(), safe_pane_id)
   state.address = socket_dir .. '/' .. socket_name

   local ok, address = pcall(vim.fn.serverstart, state.address)
   if not ok then
      state.address = nil
      vim.schedule(function()
         vim.notify(('Could not start remote-open server: %s'):format(address), vim.log.levels.WARN)
      end)
      return
   end
   state.address = address

   local group = vim.api.nvim_create_augroup('remote-open', { clear = true })
   vim.api.nvim_create_autocmd('FocusGained', {
      group = group,
      callback = function()
         state.last_focus = now_microseconds()
      end,
      desc = 'Track when this Neovim instance was last focused',
   })
   vim.api.nvim_create_autocmd('VimLeavePre', {
      group = group,
      callback = cleanup,
      desc = 'Stop and remove the remote-open server socket',
   })
end

return M
