--[===[
conform.nvim
https://github.com/stevearc/conform.nvim

Provides external formatter integration with LSP formatting as a fallback.
--]===]

vim.filetype.add({
   pattern = {
      ['.*%.pkr%.hcl'] = 'packer',
      ['.*%.pkrvars%.hcl'] = 'packer',
   },
})

vim.treesitter.language.register('hcl', 'packer')

return {
   'stevearc/conform.nvim',
   opts = {
      default_format_opts = {
         lsp_format = 'fallback',
      },
      formatters_by_ft = {
         hcl = { 'hcl' },
         packer = { 'packer_fmt' },
         terraform = { 'terraform_fmt' },
         ['terraform-vars'] = { 'terraform_fmt' },
         tf = { 'terraform_fmt' },
      },
   },
}
