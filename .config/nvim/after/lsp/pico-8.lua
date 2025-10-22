--- Full language support for the PICO-8 dialect of Lua.
--- https://github.com/japhib/pico8-ls

local util = require 'lspconfig.util'

return {
  cmd = { 'pico8-ls', '--stdio' },
  filetypes = { 'p8', 'p64' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern('*.p8')(fname))
  end,
  settings = {},
}
