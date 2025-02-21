local group_id = vim.api.nvim_create_augroup("StartMarkdownPresentation", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
   group = group_id,
   pattern = "*.md",
   callback = function()
      vim.keymap.set('n', '<leader><F5>', '<cmd>PresenterStart<CR>',
         { silent = true, desc = "Starts a presentation of the current markdownfile" })
      vim.keymap.set('n', '<leader>mc', '^I-<Space>[<Space>]<Space><Esc>^j',
         { remap = true, silent = false, desc = "[m]arkdown [c]hackable list item" })
      vim.keymap.set('n', '<leader>ml', '^I-<Space><Esc>^j',
         { remap = true, silent = false, desc = "[m]arkdown [l]ist item" })
   end,
   desc = "Starts a presentation of the current markdownfile",
})
