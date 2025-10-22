-- Language Server Protocol configuration for Json Language Server
-- URL: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jsonls

return {
   cmd = { "vscode-json-language-server", "--stdio" },
   filetypes = { "json", "jsonc" },
   init_options = { provideFormatter = true, },
   root_markers = { ".git", },
}
