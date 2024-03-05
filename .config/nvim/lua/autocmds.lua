local api = vim.api

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
api.nvim_create_autocmd('TextYankPost', {
   group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
   callback = function()
      vim.highlight.on_yank()
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
