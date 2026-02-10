-- Language Server Protocol configuration for marksman
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman

return {
   cmd = { "marksman", "server" },
   filetypes = { "markdown", "markdown.mdx", "vimwiki" },
   init_options = { provideFormatter = true, },
   root_markers = { ".marksman.toml", ".git", },
}
