local group_id = vim.api.nvim_create_augroup("StartMarkdownPresentation", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
    group = group_id,
    pattern = "*.md",
    callback = function()
        vim.keymap.set('n', '<leader><F5>', '<cmd>PresenterStart<CR>', { silent = true, desc = "Starts a presentation of the current markdownfile" })
    end,
    desc = "Starts a presentation of the current markdownfile",
})

