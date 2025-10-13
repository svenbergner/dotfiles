local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
autocmd('TextYankPost', {
   pattern = '*',
   group = augroup('YankHighlight', { clear = true }),
   callback = function()
      vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 250 })
   end,
})

-- Toggle relative line numbers based on focus
local numberToggleGroup = augroup("NumberToggle", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
   command = [[if &nu && mode() != "i" | set rnu | endif]],
   group = numberToggleGroup,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
   command = [[if &nu | set nornu | endif ]],
   group = numberToggleGroup
})

-- Disable automatic comment insertion
autocmd("BufEnter", {
   desc = "Disable automatic comment insertion",
   group = augroup("AutoComment", {}),
   callback = function()
      vim.opt_local.formatoptions:remove({ "o" })
   end,
})

-- Disable spell checking in the quickfix list
autocmd("FileType", {
   pattern = "qf",
   callback = function()
      vim.opt_local.spell = false
   end,
})

-- Remove last search highlight after cursor moved
autocmd({ "CursorMoved" }, {
   group = augroup("auto-hlsearch", { clear = true }),
   callback = function()
      if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
         vim.schedule(function()
            vim.cmd.nohlsearch()
         end)
      end
   end,
})
