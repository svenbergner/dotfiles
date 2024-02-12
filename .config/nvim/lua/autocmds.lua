local api = vim.api

-- Highlight on yank
local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
   command = "silent! lua vim.highlight.on_yank()",
   group = yankGrp,
})

-- Toogle reletive line numbers based on focus
local numberToggleGroup = api.nvim_create_augroup("NumberToggle", { clear = true })
api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
   command = [[if &nu && mode() != "i" | set rnu | endif]],
   group = numberToggleGroup,
})

api.nvim_create_autocmd(
   { "BufLeave", "FocusLost", "InsertEnter", "WinLeave" },
   { command = [[if &nu | set nornu | endif ]], group = numberToggleGroup }
)
