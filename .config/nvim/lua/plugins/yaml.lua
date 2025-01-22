--[===[
Simple tools to help developers working YAML in Neovim.
URL: https://github.com/cuducos/yaml.nvim
--]===]

return {
   "cuducos/yaml.nvim",
   enabled = true,
   ft = { "yaml", "yml" },
   dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
   },
   config = function()
      require("yaml_nvim").setup({
         on_attach = function(client, _)
            client.resolved_capabilities.document_formatting = false
            require("nvim-treesitter.configs").setup({
               ensure_installed = "yaml",
               highlight = { enable = true },
               indent = { enable = true },
            })
            require("telescope").load_extension("yaml")
         end,
      })

      vim.api.nvim_buf_set_keymap(0, "n", "<leader>yt", ":YAMLTelescope<CR>", { noremap = false })
      vim.api.nvim_buf_set_keymap(0, "n", "<leader>yl", ":!yamllint %<CR>", { noremap = true, silent = true })
   end,
}
