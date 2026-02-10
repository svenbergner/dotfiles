-- Language Server Protocol configuration for Terraform Language Server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#terraformls

return {
   cmd = { "terraform-ls", "serve" },
   filetypes = { "terraform", "terraform-vars" },
   root_markers = { ".terraform", ".git", },
}
