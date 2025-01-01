local api = vim.api

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
api.nvim_create_autocmd('TextYankPost', {
   pattern = '*',
   group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
   callback = function()
      vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 250 })
   end,
})

-- Toggle relative line numbers based on focus
local numberToggleGroup = api.nvim_create_augroup("NumberToggle", { clear = true })
api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
   command = [[if &nu && mode() != "i" | set rnu | endif]],
   group = numberToggleGroup,
})

api.nvim_create_autocmd(
   { "BufLeave", "FocusLost", "InsertEnter", "WinLeave" },
   { command = [[if &nu | set nornu | endif ]], group = numberToggleGroup }
)

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable automatic comment insertion",
  group = vim.api.nvim_create_augroup("AutoComment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})

-- Prevent Telescope from entering insert mode after leaving a prompt
vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
  callback = function(event)
    if vim.bo[event.buf].filetype == "TelescopePrompt" then
      vim.api.nvim_exec2("silent! stopinsert!", {})
    end
  end
})
