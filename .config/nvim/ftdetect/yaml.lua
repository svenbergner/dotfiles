-- Based on this medium article
-- https://itnext.io/better-kubernetes-yaml-editing-with-neo-vim-af7da9a1b150

-- Helpers
vim.api.nvim_buf_set_keymap(0, "n", "<leader>yt", ":YAMLTelescope<CR>", { noremap = false })
vim.api.nvim_buf_set_keymap(0, "n", "<leader>yl", ":!yamllint %<CR>", { noremap = true, silent = true })

