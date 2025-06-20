-- Language Server Protocol configuration for Azure Pipelines Language Server
-- URL: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#azure_pipelines_ls

-- This configuration sets up the Yaml Language Server with specific command, filetypes, and settings.
vim.lsp.config('azure_pipelines_ls', {
   settings = {
      yaml = {
         schemas = {
            ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
               "*.yml",
               "*.yaml",
            },
         },
      },
   },
})

return {
   cmd = { "azure-pipelines-language-server", "--stdio" },
   filetypes = { "yaml" },
   root_markers = { ".git", },
   settings = {}
}
