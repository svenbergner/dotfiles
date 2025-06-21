-- Language Server Protocol configuration for Yaml Language Server
-- URL: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#yamlls

-- This configuration sets up the Yaml Language Server with specific command, filetypes, and settings.
vim.lsp.config('yamlls', {
   settings = {
      yaml = {
         schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            ["../path/relative/to/file.yml"] = "/.github/workflows/*",
            ["/path/from/root/of/project"] = "/.github/workflows/*",
         },
      },
   }
})


return {
   cmd = { "yaml-language-server", "--stdio" },
   filetypes = { "yaml" },
   root_markers = { ".git", },
   settings = {
      redhat = {
         telemetry = {
            enabled = false
         }
      }
   }
}
