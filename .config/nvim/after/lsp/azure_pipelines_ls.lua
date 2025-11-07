--[===[
Language Server Protocol configuration for Azure Pipelines
URL: https://github.com/microsoft/azure-pipelines-language-server
URL: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#azure_pipelines_ls
--]===]

local util = require("lspconfig.util")

return {
   cmd = { "azure-pipelines-language-server", "--stdio" },
   filetypes = { "yaml", "yml" },
   root_markers = {
      "pipelines",
      'azure-pipelines.yml',
      'azure-pipelines.yaml',
      '.azure-pipelines',
      'azure-pipeline.yml',
      'azure-pipeline.yaml'
   },
   single_file_support = true,
   settings = {
      yaml = {
         schemas = {
            -- Azure Pipelines schema
            ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/main/service-schema.json"] = {
               "pipelines/**/*.y*ml",
               "azure-pipelines*.y*ml",
               "azure-pipeline.y*ml",
               "*.azure-pipelines.y*ml",
               ".azure-pipelines/**/*.y*ml",
               "Azure-Pipelines/**/*.y*ml",
               "Pipelines/**/*.y*ml",
            },
         },
         format = {
            enable = true,
         },
         validate = true,
      },
   },
}
